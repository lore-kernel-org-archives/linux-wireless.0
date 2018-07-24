Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39492 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388534AbeGXSDm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 14:03:42 -0400
Received: by mail-pg1-f193.google.com with SMTP id g2-v6so3308742pgs.6
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 09:56:19 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Will Deacon <will.deacon@arm.com>, dm-devel@redhat.com,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        qat-linux@intel.com, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-afs@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 17/18] crypto: ccm: Remove VLA usage
Date: Tue, 24 Jul 2018 09:49:35 -0700
Message-Id: <20180724164936.37477-18-keescook@chromium.org> (sfid-20180724_185707_076161_B7DB60DA)
In-Reply-To: <20180724164936.37477-1-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

In the quest to remove all stack VLA usage from the kernel[1], this
drops AHASH_REQUEST_ON_STACK by preallocated the ahash request area
with the skcipher area (which are not used at the same time).

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/ccm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 0a083342ec8c..b242fd0d3262 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -50,7 +50,10 @@ struct crypto_ccm_req_priv_ctx {
 	u32 flags;
 	struct scatterlist src[3];
 	struct scatterlist dst[3];
-	struct skcipher_request skreq;
+	union {
+		struct ahash_request ahreq;
+		struct skcipher_request skreq;
+	};
 };
 
 struct cbcmac_tfm_ctx {
@@ -181,7 +184,7 @@ static int crypto_ccm_auth(struct aead_request *req, struct scatterlist *plain,
 	struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct crypto_ccm_ctx *ctx = crypto_aead_ctx(aead);
-	AHASH_REQUEST_ON_STACK(ahreq, ctx->mac);
+	struct ahash_request *ahreq = &pctx->ahreq;
 	unsigned int assoclen = req->assoclen;
 	struct scatterlist sg[3];
 	u8 *odata = pctx->odata;
@@ -427,7 +430,7 @@ static int crypto_ccm_init_tfm(struct crypto_aead *tfm)
 	crypto_aead_set_reqsize(
 		tfm,
 		align + sizeof(struct crypto_ccm_req_priv_ctx) +
-		crypto_skcipher_reqsize(ctr));
+		max(crypto_ahash_reqsize(mac), crypto_skcipher_reqsize(ctr)));
 
 	return 0;
 
-- 
2.17.1
