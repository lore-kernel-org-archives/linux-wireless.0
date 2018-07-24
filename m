Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41243 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388534AbeGXR5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 13:57:10 -0400
Received: by mail-pf1-f193.google.com with SMTP id y10-v6so982728pfn.8
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 09:49:49 -0700 (PDT)
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
Subject: [PATCH v6 05/18] crypto alg: Introduce generic max blocksize and alignmask
Date: Tue, 24 Jul 2018 09:49:23 -0700
Message-Id: <20180724164936.37477-6-keescook@chromium.org> (sfid-20180724_185246_326727_36966D73)
In-Reply-To: <20180724164936.37477-1-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the quest to remove all stack VLA usage from the kernel[1], this
exposes a new general upper bound on crypto blocksize and alignmask
(higher than for the existing cipher limits) for VLA removal,
and introduces new checks.

At present, the highest cra_alignmask in the kernel is 63. The highest
cra_blocksize is 144 (SHA3_224_BLOCK_SIZE, 18 8-byte words). For the
new blocksize limit, I went with 160 (20 8-byte words).

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/algapi.c         | 7 ++++++-
 include/crypto/algapi.h | 4 +++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c0755cf4f53f..496fc51bf215 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -57,9 +57,14 @@ static int crypto_check_alg(struct crypto_alg *alg)
 	if (alg->cra_alignmask & (alg->cra_alignmask + 1))
 		return -EINVAL;
 
-	if (alg->cra_blocksize > PAGE_SIZE / 8)
+	/* General maximums for all algs. */
+	if (alg->cra_alignmask > MAX_ALGAPI_ALIGNMASK)
 		return -EINVAL;
 
+	if (alg->cra_blocksize > MAX_ALGAPI_BLOCKSIZE)
+		return -EINVAL;
+
+	/* Lower maximums for specific alg types. */
 	if (!alg->cra_type && (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
 			       CRYPTO_ALG_TYPE_CIPHER) {
 		if (alg->cra_alignmask > MAX_CIPHER_ALIGNMASK)
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index bd5e8ccf1687..21371ac8f355 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -20,8 +20,10 @@
 /*
  * Maximum values for blocksize and alignmask, used to allocate
  * static buffers that are big enough for any combination of
- * ciphers and architectures.
+ * algs and architectures. Ciphers have a lower maximum size.
  */
+#define MAX_ALGAPI_BLOCKSIZE		160
+#define MAX_ALGAPI_ALIGNMASK		63
 #define MAX_CIPHER_BLOCKSIZE		16
 #define MAX_CIPHER_ALIGNMASK		15
 
-- 
2.17.1
