Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:58257 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab3JBJDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:03:51 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/4] ath10k: split tid calculation from tx function
Date: Wed, 2 Oct 2013 11:03:38 +0200
Message-ID: <1380704621-4670-2-git-send-email-michal.kazior@tieto.com> (sfid-20131002_110355_362102_F6BEB451)
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
 drivers/net/wireless/ath/ath10k/mac.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8684e03..7415a60 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1407,6 +1407,20 @@ static void ath10k_reg_notifier(struct wiphy *wiphy,
 /* TX handlers */
 /***************/
 
+static u8 ath10k_tx_h_get_tid(struct ieee80211_hdr *hdr)
+{
+	if (ieee80211_is_mgmt(hdr->frame_control))
+		return HTT_DATA_TX_EXT_TID_MGMT;
+
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
+
+	if (!is_unicast_ether_addr(ieee80211_get_DA(hdr)))
+		return HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
+
+	return ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
+}
+
 /*
  * Frames sent to the FW have to be in "Native Wifi" format.
  * Strip the QoS field from the 802.11 header.
@@ -1788,14 +1802,7 @@ static void ath10k_tx(struct ieee80211_hw *hw,
 
 	/* we must calculate tid before we apply qos workaround
 	 * as we'd lose the qos control field */
-	tid = HTT_DATA_TX_EXT_TID_NON_QOS_MCAST_BCAST;
-	if (ieee80211_is_mgmt(hdr->frame_control)) {
-		tid = HTT_DATA_TX_EXT_TID_MGMT;
-	} else if (ieee80211_is_data_qos(hdr->frame_control) &&
-		   is_unicast_ether_addr(ieee80211_get_DA(hdr))) {
-		u8 *qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-	}
+	tid = ath10k_tx_h_get_tid(hdr);
 
 	/* it makes no sense to process injected frames like that */
 	if (info->control.vif &&
-- 
1.7.9.5

