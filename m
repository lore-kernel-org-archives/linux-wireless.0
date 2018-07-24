Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46398 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388582AbeGXR5N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 13:57:13 -0400
Received: by mail-pf1-f195.google.com with SMTP id u24-v6so980718pfn.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 09:49:53 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
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
Subject: [PATCH v6 09/18] ppp: mppe: Remove VLA usage
Date: Tue, 24 Jul 2018 09:49:27 -0700
Message-Id: <20180724164936.37477-10-keescook@chromium.org> (sfid-20180724_185202_763090_50134CF6)
In-Reply-To: <20180724164936.37477-1-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the quest to remove all stack VLA usage from the kernel[1], this
removes the discouraged use of AHASH_REQUEST_ON_STACK (and associated
VLA) by switching to shash directly and keeping the associated descriptor
allocated with the regular state on the heap.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/ppp_mppe.c | 56 ++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ppp/ppp_mppe.c b/drivers/net/ppp/ppp_mppe.c
index 6c7fd98cb00a..a205750b431b 100644
--- a/drivers/net/ppp/ppp_mppe.c
+++ b/drivers/net/ppp/ppp_mppe.c
@@ -96,7 +96,7 @@ static inline void sha_pad_init(struct sha_pad *shapad)
  */
 struct ppp_mppe_state {
 	struct crypto_skcipher *arc4;
-	struct crypto_ahash *sha1;
+	struct shash_desc *sha1;
 	unsigned char *sha1_digest;
 	unsigned char master_key[MPPE_MAX_KEY_LEN];
 	unsigned char session_key[MPPE_MAX_KEY_LEN];
@@ -136,25 +136,16 @@ struct ppp_mppe_state {
  */
 static void get_new_key_from_sha(struct ppp_mppe_state * state)
 {
-	AHASH_REQUEST_ON_STACK(req, state->sha1);
-	struct scatterlist sg[4];
-	unsigned int nbytes;
-
-	sg_init_table(sg, 4);
-
-	nbytes = setup_sg(&sg[0], state->master_key, state->keylen);
-	nbytes += setup_sg(&sg[1], sha_pad->sha_pad1,
-			   sizeof(sha_pad->sha_pad1));
-	nbytes += setup_sg(&sg[2], state->session_key, state->keylen);
-	nbytes += setup_sg(&sg[3], sha_pad->sha_pad2,
-			   sizeof(sha_pad->sha_pad2));
-
-	ahash_request_set_tfm(req, state->sha1);
-	ahash_request_set_callback(req, 0, NULL, NULL);
-	ahash_request_set_crypt(req, sg, state->sha1_digest, nbytes);
-
-	crypto_ahash_digest(req);
-	ahash_request_zero(req);
+	crypto_shash_init(state->sha1);
+	crypto_shash_update(state->sha1, state->master_key,
+			    state->keylen);
+	crypto_shash_update(state->sha1, sha_pad->sha_pad1,
+			    sizeof(sha_pad->sha_pad1));
+	crypto_shash_update(state->sha1, state->session_key,
+			    state->keylen);
+	crypto_shash_update(state->sha1, sha_pad->sha_pad2,
+			    sizeof(sha_pad->sha_pad2));
+	crypto_shash_final(state->sha1, state->sha1_digest);
 }
 
 /*
@@ -200,6 +191,7 @@ static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
 static void *mppe_alloc(unsigned char *options, int optlen)
 {
 	struct ppp_mppe_state *state;
+	struct crypto_shash *shash;
 	unsigned int digestsize;
 
 	if (optlen != CILEN_MPPE + sizeof(state->master_key) ||
@@ -217,13 +209,21 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 		goto out_free;
 	}
 
-	state->sha1 = crypto_alloc_ahash("sha1", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(state->sha1)) {
-		state->sha1 = NULL;
+	shash = crypto_alloc_shash("sha1", 0, 0);
+	if (IS_ERR(shash))
+		goto out_free;
+
+	state->sha1 = kmalloc(sizeof(*state->sha1) +
+				     crypto_shash_descsize(shash),
+			      GFP_KERNEL);
+	if (!state->sha1) {
+		crypto_free_shash(shash);
 		goto out_free;
 	}
+	state->sha1->tfm = shash;
+	state->sha1->flags = 0;
 
-	digestsize = crypto_ahash_digestsize(state->sha1);
+	digestsize = crypto_shash_digestsize(shash);
 	if (digestsize < MPPE_MAX_KEY_LEN)
 		goto out_free;
 
@@ -246,7 +246,10 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 
 out_free:
 	kfree(state->sha1_digest);
-	crypto_free_ahash(state->sha1);
+	if (state->sha1) {
+		crypto_free_shash(state->sha1->tfm);
+		kzfree(state->sha1);
+	}
 	crypto_free_skcipher(state->arc4);
 	kfree(state);
 out:
@@ -261,7 +264,8 @@ static void mppe_free(void *arg)
 	struct ppp_mppe_state *state = (struct ppp_mppe_state *) arg;
 	if (state) {
 		kfree(state->sha1_digest);
-		crypto_free_ahash(state->sha1);
+		crypto_free_shash(state->sha1->tfm);
+		kzfree(state->sha1);
 		crypto_free_skcipher(state->arc4);
 		kfree(state);
 	}
-- 
2.17.1
