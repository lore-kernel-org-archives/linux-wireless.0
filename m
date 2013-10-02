Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:48557 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3JBJDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:03:51 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/4] ath10k: split vdev_id calculation from tx function
Date: Wed, 2 Oct 2013 11:03:39 +0200
Message-ID: <1380704621-4670-3-git-send-email-michal.kazior@tieto.com> (sfid-20131002_110358_113677_1701B14F)
In-Reply-To: <1380704621-4670-1-git-send-email-michal.kazior@tieto.com>
References: <1380292706-3609-1-git-send-email-michal.kazior@tieto.com>
 <1380704621-4670-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tidy up ath10k_tx().

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 7415a60..4b7c949 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1421,6 +1421,19 @@ static u8 ath10k_tx_h_get_tid(struct ieee80211_hdr *hdr)
 	return ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
 }
 
+static u8 ath10k_tx_h_get_vdev_id(struct ath10k *ar,
+				  struct ieee80211_tx_info *info)
+{
+	if (info->control.vif)
+		return ath10k_vif_to_arvif(info->control.vif)->vdev_id;
+
+	if (ar->monitor_enabled)
+		return ar->monitor_vdev_id;
+
+	ath10k_warn("could not resolve vdev id\n");
+	return 0;
+}
+
 /*
  * Frames sent to the FW have to be in "Native Wifi" format.
  * Strip the QoS field from the 802.11 header.
@@ -1785,16 +1798,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath10k *ar = hw->priv;
-	struct ath10k_vif *arvif = NULL;
-	u32 vdev_id = 0;
-	u8 tid;
-
-	if (info->control.vif) {
-		arvif = ath10k_vif_to_arvif(info->control.vif);
-		vdev_id = arvif->vdev_id;
-	} else if (ar->monitor_enabled) {
-		vdev_id = ar->monitor_vdev_id;
-	}
+	u8 tid, vdev_id;
 
 	/* We should disable CCK RATE due to P2P */
 	if (info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)
@@ -1803,6 +1807,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 	/* we must calculate tid before we apply qos workaround
 	 * as we'd lose the qos control field */
 	tid = ath10k_tx_h_get_tid(hdr);
+	vdev_id = ath10k_tx_h_get_vdev_id(ar, info);
 
 	/* it makes no sense to process injected frames like that */
 	if (info->control.vif &&
-- 
1.7.9.5

