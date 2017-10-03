Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:57355 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbdJCCYu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 22:24:50 -0400
From: Jia-Ju Bai <baijiaju1990@163.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, vyasevich@gmail.com, luto@kernel.org,
        kvalo@codeaurora.org
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH V2] Fix a sleep-in-atomic bug in shash_setkey_unaligned
Date: Tue,  3 Oct 2017 10:25:22 +0800
Message-Id: <1506997522-26684-1-git-send-email-baijiaju1990@163.com> (sfid-20171003_042458_305112_C2924F4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SCTP program may sleep under a spinlock, and the function call path is:
sctp_generate_t3_rtx_event (acquire the spinlock)
  sctp_do_sm
    sctp_side_effects
      sctp_cmd_interpreter
        sctp_make_init_ack
          sctp_pack_cookie
            crypto_shash_setkey
              shash_setkey_unaligned
                kmalloc(GFP_KERNEL)

For the same reason, the orinoco driver may sleep in interrupt handler, 
and the function call path is:
orinoco_rx_isr_tasklet
  orinoco_rx
    orinoco_mic
      crypto_shash_setkey
        shash_setkey_unaligned
          kmalloc(GFP_KERNEL)

To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.
This bug is found by my static analysis tool and my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 crypto/shash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 5e31c8d..8fcecc6 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -41,7 +41,7 @@ static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 	int err;
 
 	absize = keylen + (alignmask & ~(crypto_tfm_ctx_alignment() - 1));
-	buffer = kmalloc(absize, GFP_KERNEL);
+	buffer = kmalloc(absize, GFP_ATOMIC);
 	if (!buffer)
 		return -ENOMEM;
 
-- 
1.7.9.5
