Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33103 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033997AbcKAOsx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 10:48:53 -0400
Received: by mail-pf0-f194.google.com with SMTP id a136so8475372pfa.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2016 07:48:53 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next] rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb
Date: Tue,  1 Nov 2016 14:48:40 +0000
Message-Id: <1478011720-27363-1-git-send-email-weiyj.lk@gmail.com> (sfid-20161101_154856_504628_9A230F46)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

It is not allowed to call kfree_skb() from hardware interrupt
context or with interrupts being disabled, spin_lock_irqsave()
make sure always in irq disable context. So the kfree_skb()
should be replaced with dev_kfree_skb_irq().

This is detected by Coccinelle semantic patch.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 8e7f23c..e89681d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1832,7 +1832,7 @@ bool rtl_cmd_send_packet(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	pskb = __skb_dequeue(&ring->queue);
-	kfree_skb(pskb);
+	dev_kfree_skb_irq(pskb);
 
 	/*this is wrong, fill_tx_cmddesc needs update*/
 	pdesc = &ring->desc[0];
