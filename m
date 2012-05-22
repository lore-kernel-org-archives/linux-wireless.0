Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59314 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2EVHW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 03:22:59 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/2] ath6kl: Update netstats for some of the tx failrues in ath6kl_data_tx()
Date: Tue, 22 May 2012 12:52:49 +0530
Message-ID: <1337671370-32519-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120522_092305_138370_2387F64D)
In-Reply-To: <1337671370-32519-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1337671370-32519-1-git-send-email-vthiagar@qca.qualcomm.com>
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

