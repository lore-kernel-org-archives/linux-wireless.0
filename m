Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:58813 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaHJNoa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 09:44:30 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so7573292wev.27
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 06:44:29 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
Date: Sun, 10 Aug 2014 15:44:10 +0200
Message-ID: <1518134.xFh23iA8q1@blech> (sfid-20140810_154434_779540_EF253699)
In-Reply-To: <53E3BB1D.10807@candelatech.com>
References: <5338F1B8.5040305@candelatech.com> <1875618.ePecsgGYZf@blech> <53E3BB1D.10807@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, August 07, 2014 10:45:01 AM Ben Greear wrote:
> On 08/07/2014 07:05 AM, Christian Lamparter wrote:
> > Or: for every 16 Bytes of payload there is one fpu context save and
> > restore... ouch!
>
> Any idea if it would work to put the fpu_begin/end a bit higher
> and do all those 16 byte chunks in a batch without messing with
> the FPU for each chunk?

It sort of works - see sample feature patch for aesni-intel-glue 
(taken from 3.16-wl). Older kernels (like 3.15, 3.14) need:
"crypto: allow blkcipher walks over AEAD data" [0] (and maybe more).

The FPU save/restore overhead should be gone. Also, if the aesni
instructions can't be used, the implementation will fall back
to the original ccm(aes) code. Calculating the MAC is still much
more expensive than the payload encryption or decryption. However,
I can't see a way of making this more efficient without rewriting
and combining the parts I took from crypto/ccm.c into an several, 
dedicated assembler functions.

Regards
Christian
---
 arch/x86/crypto/aesni-intel_glue.c | 484 +++++++++++++++++++++++++++++++++++++
 1 file changed, 484 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 948ad0e..beab823 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -36,6 +36,7 @@
 #include <asm/crypto/aes.h>
 #include <crypto/ablk_helper.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/aead.h>
 #include <crypto/internal/aead.h>
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
@@ -499,6 +500,448 @@ static int ctr_crypt(struct blkcipher_desc *desc,
 
 	return err;
 }
+
+static int __ccm_setkey(struct crypto_aead *tfm, const u8 *in_key,
+		      unsigned int key_len)
+{
+	struct crypto_aes_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return aes_set_key_common(crypto_aead_tfm(tfm), ctx, in_key, key_len);
+}
+
+static int __ccm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	if ((authsize & 1) || authsize < 4)
+		return -EINVAL;
+	return 0;
+}
+
+static int set_msg_len(u8 *block, unsigned int msglen, int csize)
+{
+	__be32 data;
+
+	memset(block, 0, csize);
+	block += csize;
+
+	if (csize >= 4)
+		csize = 4;
+	else if (msglen > (1 << (8 * csize)))
+		return -EOVERFLOW;
+
+	data = cpu_to_be32(msglen);
+	memcpy(block - csize, (u8 *)&data + 4 - csize, csize);
+
+	return 0;
+}
+
+static int ccm_init_mac(struct aead_request *req, u8 maciv[], u32 msglen)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	__be32 *n = (__be32 *)&maciv[AES_BLOCK_SIZE - 8];
+	u32 l = req->iv[0] + 1;
+
+	/* verify that CCM dimension 'L' is set correctly in the IV */
+	if (l < 2 || l > 8)
+		return -EINVAL;
+
+	/* verify that msglen can in fact be represented in L bytes */
+	if (l < 4 && msglen >> (8 * l))
+		return -EOVERFLOW;
+
+	/*
+	 * Even if the CCM spec allows L values of up to 8, the Linux cryptoapi
+	 * uses a u32 type to represent msglen so the top 4 bytes are always 0.
+	 */
+	n[0] = 0;
+	n[1] = cpu_to_be32(msglen);
+
+	memcpy(maciv, req->iv, AES_BLOCK_SIZE - l);
+
+	/*
+	 * Meaning of byte 0 according to CCM spec (RFC 3610/NIST 800-38C)
+	 * - bits 0..2	: max # of bytes required to represent msglen, minus 1
+	 *                (already set by caller)
+	 * - bits 3..5	: size of auth tag (1 => 4 bytes, 2 => 6 bytes, etc)
+	 * - bit 6	: indicates presence of authenticate-only data
+	 */
+	maciv[0] |= (crypto_aead_authsize(aead) - 2) << 2;
+	if (req->assoclen)
+		maciv[0] |= 0x40;
+
+	memset(&req->iv[AES_BLOCK_SIZE - l], 0, l);
+	return set_msg_len(maciv + AES_BLOCK_SIZE - l, msglen, l);
+}
+
+static int compute_mac(struct crypto_aes_ctx *ctx, u8 mac[], u8 *data, int n,
+		       unsigned int ilen, u8 *idata)
+{
+	unsigned int bs = AES_BLOCK_SIZE;
+	u8 *odata = mac;
+	int datalen, getlen;
+
+	datalen = n;
+
+	/* first time in here, block may be partially filled. */
+	getlen = bs - ilen;
+	if (datalen >= getlen) {
+		memcpy(idata + ilen, data, getlen);
+		crypto_xor(odata, idata, bs);
+
+		aesni_enc(ctx, odata, odata);
+		datalen -= getlen;
+		data += getlen;
+		ilen = 0;
+	}
+
+	/* now encrypt rest of data */
+	while (datalen >= bs) {
+		crypto_xor(odata, data, bs);
+
+		aesni_enc(ctx, odata, odata);
+
+		datalen -= bs;
+		data += bs;
+	}
+
+	/* check and see if there's leftover data that wasn't
+	 * enough to fill a block.
+	 */
+	if (datalen) {
+		memcpy(idata + ilen, data, datalen);
+		ilen += datalen;
+	}
+	return ilen;
+}
+
+static unsigned int get_data_to_compute(struct crypto_aes_ctx *ctx, u8 mac[],
+					u8 *idata, struct scatterlist *sg,
+					unsigned int len, unsigned int ilen)
+{
+	struct scatter_walk walk;
+	u8 *data_src;
+	int n;
+
+	scatterwalk_start(&walk, sg);
+
+	while (len) {
+		n = scatterwalk_clamp(&walk, len);
+		if (!n) {
+			scatterwalk_start(&walk, sg_next(walk.sg));
+			n = scatterwalk_clamp(&walk, len);
+		}
+		data_src = scatterwalk_map(&walk);
+
+		ilen = compute_mac(ctx, mac, data_src, n, ilen, idata);
+		len -= n;
+
+		scatterwalk_unmap(data_src);
+		scatterwalk_advance(&walk, n);
+		scatterwalk_done(&walk, 0, len);
+	}
+
+	/* any leftover needs padding and then encrypted */
+	if (ilen) {
+		int padlen;
+		u8 *odata = mac;
+
+		padlen = AES_BLOCK_SIZE - ilen;
+		memset(idata + ilen, 0, padlen);
+		crypto_xor(odata, idata, AES_BLOCK_SIZE);
+
+		aesni_enc(ctx, odata, odata);
+		ilen = 0;
+	}
+	return ilen;
+}
+
+static void ccm_calculate_auth_mac(struct aead_request *req,
+				   struct crypto_aes_ctx *ctx, u8 mac[],
+				   struct scatterlist *src,
+				   unsigned int cryptlen)
+{
+	unsigned int ilen;
+	u8 idata[AES_BLOCK_SIZE];
+	u32 len = req->assoclen;
+
+	aesni_enc(ctx, mac, mac);
+
+	if (len) {
+		struct __packed {
+			__be16 l;
+			__be32 h;
+		} *ltag = (void *)idata;
+
+		/* prepend the AAD with a length tag */
+		if (len < 0xff00) {
+			ltag->l = cpu_to_be16(len);
+			ilen = 2;
+		} else  {
+			ltag->l = cpu_to_be16(0xfffe);
+			ltag->h = cpu_to_be32(len);
+			ilen = 6;
+		}
+
+		ilen = get_data_to_compute(ctx, mac, idata,
+					   req->assoc, req->assoclen,
+					   ilen);
+	} else {
+		ilen = 0;
+	}
+
+	/* compute plaintext into mac */
+	if (cryptlen) {
+		ilen = get_data_to_compute(ctx, mac, idata,
+					   src, cryptlen, ilen);
+	}
+}
+
+static int __ccm_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_aead_ctx(aead));
+	struct blkcipher_desc desc = { .info = req->iv };
+	struct blkcipher_walk walk;
+	struct scatterlist src[2], dst[2], *pdst;
+	u8 __aligned(8) mac[AES_BLOCK_SIZE];
+	u32 len = req->cryptlen;
+	int err;
+
+	err = ccm_init_mac(req, mac, len);
+	if (err)
+		return err;
+
+	ccm_calculate_auth_mac(req, ctx, mac, req->src, len);
+
+	sg_init_table(src, 2);
+	sg_set_buf(src, mac, sizeof(mac));
+	scatterwalk_sg_chain(src, 2, req->src);
+
+	pdst = src;
+	if (req->src != req->dst) {
+		sg_init_table(dst, 2);
+		sg_set_buf(dst, mac, sizeof(mac));
+		scatterwalk_sg_chain(dst, 2, req->dst);
+		pdst = dst;
+	}
+
+	len += sizeof(mac);
+	blkcipher_walk_init(&walk, pdst, src, len);
+	err = blkcipher_aead_walk_virt_block(&desc, &walk, aead,
+					     AES_BLOCK_SIZE);
+
+	while ((len = walk.nbytes) >= AES_BLOCK_SIZE) {
+		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			      len & AES_BLOCK_MASK, walk.iv);
+		len &= AES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(&desc, &walk, len);
+	}
+	if (walk.nbytes) {
+		ctr_crypt_final(ctx, &walk);
+		err = blkcipher_walk_done(&desc, &walk, 0);
+	}
+
+	if (err)
+		return err;
+
+	/* copy authtag to end of dst */
+	scatterwalk_map_and_copy(mac, req->dst, req->cryptlen,
+				 crypto_aead_authsize(aead), 1);
+	return 0;
+}
+
+static int __ccm_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_aead_ctx(aead));
+	unsigned int authsize = crypto_aead_authsize(aead);
+	struct blkcipher_desc desc = { .info = req->iv };
+	struct blkcipher_walk walk;
+	struct scatterlist src[2], dst[2], *pdst;
+	u8 __aligned(8) authtag[AES_BLOCK_SIZE], mac[AES_BLOCK_SIZE];
+	u32 len;
+	int err;
+
+	if (req->cryptlen < authsize)
+		return -EINVAL;
+
+	scatterwalk_map_and_copy(authtag, req->src,
+				 req->cryptlen - authsize, authsize, 0);
+
+	err = ccm_init_mac(req, mac, req->cryptlen - authsize);
+	if (err)
+		return err;
+
+	sg_init_table(src, 2);
+	sg_set_buf(src, authtag, sizeof(authtag));
+	scatterwalk_sg_chain(src, 2, req->src);
+
+	pdst = src;
+	if (req->src != req->dst) {
+		sg_init_table(dst, 2);
+		sg_set_buf(dst, authtag, sizeof(authtag));
+		scatterwalk_sg_chain(dst, 2, req->dst);
+		pdst = dst;
+	}
+
+	blkcipher_walk_init(&walk, pdst, src,
+			    req->cryptlen - authsize + sizeof(mac));
+	err = blkcipher_aead_walk_virt_block(&desc, &walk, aead,
+					     AES_BLOCK_SIZE);
+
+	while ((len = walk.nbytes) >= AES_BLOCK_SIZE) {
+		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+			      len & AES_BLOCK_MASK, walk.iv);
+		len &= AES_BLOCK_SIZE - 1;
+		err = blkcipher_walk_done(&desc, &walk, len);
+	}
+	if (walk.nbytes) {
+		ctr_crypt_final(ctx, &walk);
+		err = blkcipher_walk_done(&desc, &walk, 0);
+	}
+
+	ccm_calculate_auth_mac(req, ctx, mac, req->dst,
+			       req->cryptlen - authsize);
+	if (err)
+		return err;
+
+	/* compare calculated auth tag with the stored one */
+	if (crypto_memneq(mac, authtag, authsize))
+		return -EBADMSG;
+	return 0;
+}
+
+struct ccm_async_ctx {
+	struct crypto_aes_ctx ctx;
+	struct crypto_aead *fallback;
+};
+
+static inline struct
+ccm_async_ctx *get_ccm_ctx(struct crypto_aead *aead)
+{
+	return (struct ccm_async_ctx *)
+		PTR_ALIGN((u8 *)
+		crypto_tfm_ctx(crypto_aead_tfm(aead)), AESNI_ALIGN);
+}
+
+static int ccm_init(struct crypto_tfm *tfm)
+{
+	struct crypto_aead *crypto_tfm;
+	struct ccm_async_ctx *ctx = (struct ccm_async_ctx *)
+		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
+
+	crypto_tfm = crypto_alloc_aead("ccm(aes)", 0,
+		CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(crypto_tfm))
+		return PTR_ERR(crypto_tfm);
+
+	ctx->fallback = crypto_tfm;
+	return 0;
+}
+
+static void ccm_exit(struct crypto_tfm *tfm)
+{
+	struct ccm_async_ctx *ctx = (struct ccm_async_ctx *)
+		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
+
+	if (!IS_ERR_OR_NULL(ctx->fallback))
+		crypto_free_aead(ctx->fallback);
+}
+
+static int ccm_setkey(struct crypto_aead *aead, const u8 *in_key,
+		      unsigned int key_len)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct ccm_async_ctx *ctx = (struct ccm_async_ctx *)
+		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
+	int err;
+
+	err = __ccm_setkey(aead, in_key, key_len);
+	if (err)
+		return err;
+
+	/*
+	 * Set the fallback transform to use the same request flags as
+	 * the hardware transform.
+	 */
+	ctx->fallback->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	ctx->fallback->base.crt_flags |=
+			tfm->crt_flags & CRYPTO_TFM_REQ_MASK;
+	return crypto_aead_setkey(ctx->fallback, in_key, key_len);
+}
+
+static int ccm_setauthsize(struct crypto_aead *aead, unsigned int authsize)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct ccm_async_ctx *ctx = (struct ccm_async_ctx *)
+		PTR_ALIGN((u8 *)crypto_tfm_ctx(tfm), AESNI_ALIGN);
+	int err;
+
+	err = __ccm_setauthsize(aead, authsize);
+	if (err)
+		return err;
+
+	return crypto_aead_setauthsize(ctx->fallback, authsize);
+}
+
+static int ccm_encrypt(struct aead_request *req)
+{
+	int ret;
+
+	if (!irq_fpu_usable()) {
+		struct crypto_aead *aead = crypto_aead_reqtfm(req);
+		struct ccm_async_ctx *ctx = get_ccm_ctx(aead);
+		struct crypto_aead *fallback = ctx->fallback;
+
+		char aead_req_data[sizeof(struct aead_request) +
+				   crypto_aead_reqsize(fallback)]
+		__aligned(__alignof__(struct aead_request));
+		struct aead_request *aead_req = (void *) aead_req_data;
+
+		memset(aead_req, 0, sizeof(aead_req_data));
+		aead_request_set_tfm(aead_req, fallback);
+		aead_request_set_assoc(aead_req, req->assoc, req->assoclen);
+		aead_request_set_crypt(aead_req, req->src, req->dst,
+				       req->cryptlen, req->iv);
+		aead_request_set_callback(aead_req, req->base.flags,
+					  req->base.complete, req->base.data);
+		ret = crypto_aead_encrypt(aead_req);
+	} else {
+		kernel_fpu_begin();
+		ret = __ccm_encrypt(req);
+		kernel_fpu_end();
+	}
+	return ret;
+}
+
+static int ccm_decrypt(struct aead_request *req)
+{
+	int ret;
+
+	if (!irq_fpu_usable()) {
+		struct crypto_aead *aead = crypto_aead_reqtfm(req);
+		struct ccm_async_ctx *ctx = get_ccm_ctx(aead);
+		struct crypto_aead *fallback = ctx->fallback;
+
+		char aead_req_data[sizeof(struct aead_request) +
+				   crypto_aead_reqsize(fallback)]
+		__aligned(__alignof__(struct aead_request));
+		struct aead_request *aead_req = (void *) aead_req_data;
+
+		memset(aead_req, 0, sizeof(aead_req_data));
+		aead_request_set_tfm(aead_req, fallback);
+		aead_request_set_assoc(aead_req, req->assoc, req->assoclen);
+		aead_request_set_crypt(aead_req, req->src, req->dst,
+				       req->cryptlen, req->iv);
+		aead_request_set_callback(aead_req, req->base.flags,
+					  req->base.complete, req->base.data);
+		ret = crypto_aead_decrypt(aead_req);
+	} else {
+		kernel_fpu_begin();
+		ret = __ccm_decrypt(req);
+		kernel_fpu_end();
+	}
+	return ret;
+}
 #endif
 
 static int ablk_ecb_init(struct crypto_tfm *tfm)
@@ -1308,6 +1751,47 @@ static struct crypto_alg aesni_algs[] = { {
 		},
 	},
 }, {
+	.cra_name		= "__ccm-aes-aesni",
+	.cra_driver_name	= "__driver-ccm-aes-aesni",
+	.cra_priority		= 0,
+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= sizeof(struct crypto_aes_ctx) +
+				  AESNI_ALIGN - 1,
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_aead_type,
+	.cra_module		= THIS_MODULE,
+	.cra_aead = {
+		.ivsize		= AES_BLOCK_SIZE,
+		.maxauthsize	= AES_BLOCK_SIZE,
+		.setkey		= __ccm_setkey,
+		.setauthsize	= __ccm_setauthsize,
+		.encrypt	= __ccm_encrypt,
+		.decrypt	= __ccm_decrypt,
+	},
+}, {
+	.cra_name		= "ccm(aes)",
+	.cra_driver_name	= "ccm-aes-aesni",
+	.cra_priority		= 700,
+	.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+				  CRYPTO_ALG_NEED_FALLBACK,
+	.cra_blocksize		= 1,
+	.cra_ctxsize		= AESNI_ALIGN - 1 +
+				  sizeof(struct ccm_async_ctx),
+	.cra_alignmask		= 0,
+	.cra_type		= &crypto_aead_type,
+	.cra_module		= THIS_MODULE,
+	.cra_init		= ccm_init,
+	.cra_exit		= ccm_exit,
+	.cra_aead = {
+		.ivsize		= AES_BLOCK_SIZE,
+		.maxauthsize	= AES_BLOCK_SIZE,
+		.setkey		= ccm_setkey,
+		.setauthsize	= ccm_setauthsize,
+		.encrypt	= ccm_encrypt,
+		.decrypt	= ccm_decrypt,
+	},
+}, {
 	.cra_name		= "__gcm-aes-aesni",
 	.cra_driver_name	= "__driver-gcm-aes-aesni",
 	.cra_priority		= 0,
-- 
2.0.1

[0] <https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=4f7f1d7cff8f2c170ce0319eb4c01a82c328d34f>
