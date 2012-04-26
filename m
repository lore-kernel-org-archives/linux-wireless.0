Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5563 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab2DZOzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 10:55:24 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Update netstats for some of the tx failrues in ath6kl_data_tx()
Date: Thu, 26 Apr 2012 20:26:13 +0530
Message-ID: <1335452174-7093-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120426_165806_023143_741854DD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are few cases where the tx skb is dropped but netstats is
not updated, fix this.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 82f2f5c..67206ae 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -362,15 +362,11 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 		   skb, skb->data, skb->len);
 
 	/* If target is not associated */
-	if (!test_bit(CONNECTED, &vif->flags)) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
+	if (!test_bit(CONNECTED, &vif->flags))
+		goto fail_tx;
 
-	if (WARN_ON_ONCE(ar->state != ATH6KL_STATE_ON)) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
+	if (WARN_ON_ONCE(ar->state != ATH6KL_STATE_ON))
+		goto fail_tx;
 
 	if (!test_bit(WMI_READY, &ar->flag))
 		goto fail_tx;
-- 
1.7.0.4

