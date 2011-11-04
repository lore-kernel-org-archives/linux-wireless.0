Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33433 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab1KDKTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:19:18 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix tx packet drop in AP mode with bridge
Date: Fri, 4 Nov 2011 15:48:51 +0530
Message-ID: <1320401931-3493-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111104_111922_449831_CF0EBF1E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb is dropped in ath6kl_data_tx() when the headroom in skb
is insufficient. We hit this condition for every skb in AP mode
which is used with bridge, so all tx packets are getting dropped
when tried to send traffic to wireless client from bridge. Fix
this by reallocating the headroom instead of dropping the skb
when it has lesser headroom than needed.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 06e4912..251abf8 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -266,8 +266,14 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 
 	if (test_bit(WMI_ENABLED, &ar->flag)) {
 		if (skb_headroom(skb) < dev->needed_headroom) {
-			WARN_ON(1);
-			goto fail_tx;
+			struct sk_buff *tmp_skb = skb;
+
+			skb = skb_realloc_headroom(skb, dev->needed_headroom);
+			kfree_skb(tmp_skb);
+			if (skb == NULL) {
+				vif->net_stats.tx_dropped++;
+				return 0;
+			}
 		}
 
 		if (ath6kl_wmi_dix_2_dot3(ar->wmi, skb)) {
-- 
1.7.0.4

