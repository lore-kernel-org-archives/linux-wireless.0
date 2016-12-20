Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33206 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbcLTCiU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 21:38:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-kernel@vger.kernel.org, driver-devel@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH] rtlwifi: Fix kernel oops introduced with commit e49656147359
Date: Mon, 19 Dec 2016 20:38:12 -0600
Message-Id: <20161220023812.5999-1-Larry.Finger@lwfinger.net> (sfid-20161220_033927_493861_9A7CBAA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With commit e49656147359 {"rtlwifi: Use dev_kfree_skb_irq instead of
kfree_skb"), the method used to free an skb was changed because the
kfree_skb() was inside a spinlock. What was forgotten is that kfree_skb()
guards against a NULL value for the argument. Routine dev_kfree_skb_irq()
does not, and a test is needed to prevent kernel panics.

Fixes: commit e49656147359 {"rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> (4.9+)
Cc: Wei Yongjun <weiyongjun1@huawei.com>
---
Kalle,

This change should be sent to mainline during the 4.10 merge period,
or as soon as possible.

Thanks,

Larry
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 955055b..df8b977 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1823,7 +1823,8 @@ bool rtl_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	pskb = __skb_dequeue(&ring->queue);
-	dev_kfree_skb_irq(pskb);
+	if (pskb)
+		dev_kfree_skb_irq(pskb);
 
 	/*this is wrong, fill_tx_cmddesc needs update*/
 	pdesc = &ring->desc[0];
-- 
2.10.2
