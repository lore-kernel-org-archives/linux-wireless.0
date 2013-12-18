Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:35086 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3LRKPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 05:15:14 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so3410893eek.36
        for <linux-wireless@vger.kernel.org>; Wed, 18 Dec 2013 02:15:13 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: implement sta_rc_update()
Date: Wed, 18 Dec 2013 11:11:19 +0100
Message-Id: <1387361479-21289-1-git-send-email-michal.kazior@tieto.com> (sfid-20131218_111522_057572_1A455CD1)
In-Reply-To: <87li09ga42.fsf@kamboji.qca.qualcomm.com>
References: <87li09ga42.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should fix possible connectivity issues upon
changes of channel width, number of streams or
SMPS on connected stations.

An example trigger would be an action frame with
operation mode change notification.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 - handle 160MHz case chwidth explicitly instead
   of default case
 - handle SMPS_NUM_MODES without a fall-through

 drivers/net/wireless/ath/ath10k/mac.c | 91 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h |  6 +++
 2 files changed, 97 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ce9ef349..ddacb1e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3310,6 +3310,96 @@ exit:
 	return ret;
 }
 
+static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_sta *sta,
+				 u32 changed)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
+	u32 chwidth, smps;
+	int ret;
+
+	if (changed & IEEE80211_RC_BW_CHANGED) {
+		chwidth = WMI_PEER_CHWIDTH_20MHZ;
+
+		switch (sta->bandwidth) {
+		case IEEE80211_STA_RX_BW_20:
+			chwidth = WMI_PEER_CHWIDTH_20MHZ;
+			break;
+		case IEEE80211_STA_RX_BW_40:
+			chwidth = WMI_PEER_CHWIDTH_40MHZ;
+			break;
+		case IEEE80211_STA_RX_BW_80:
+			chwidth = WMI_PEER_CHWIDTH_80MHZ;
+			break;
+		case IEEE80211_STA_RX_BW_160:
+			chwidth = WMI_PEER_CHWIDTH_20MHZ;
+			ath10k_warn("unsupported STA BW: %d\n", sta->bandwidth);
+			break;
+		}
+
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac update sta %pM bandwidth (peer chwidth %d) to %d\n",
+			   sta->addr, chwidth, sta->bandwidth);
+
+		ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_CHAN_WIDTH, chwidth);
+		if (ret)
+			ath10k_warn("failed to update STA %pM bandwidth (peer chwidth %d) to %d: %d\n",
+				    sta->addr, chwidth, sta->bandwidth, ret);
+	}
+
+	if (changed & IEEE80211_RC_NSS_CHANGED) {
+		ath10k_dbg(ATH10K_DBG_MAC, "mac update sta %pM nss to %d\n",
+			   sta->addr, sta->rx_nss);
+
+		ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_NSS, sta->rx_nss);
+		if (ret)
+			ath10k_warn("failed to update STA %pM nss to %d: %d\n",
+				    sta->addr, sta->rx_nss, ret);
+	}
+
+	if (changed & IEEE80211_RC_SMPS_CHANGED) {
+		smps = WMI_PEER_SMPS_PS_NONE;
+
+		switch (sta->smps_mode) {
+		case IEEE80211_SMPS_AUTOMATIC:
+		case IEEE80211_SMPS_OFF:
+			smps = WMI_PEER_SMPS_PS_NONE;
+			break;
+		case IEEE80211_SMPS_STATIC:
+			smps = WMI_PEER_SMPS_STATIC;
+			break;
+		case IEEE80211_SMPS_DYNAMIC:
+			smps = WMI_PEER_SMPS_DYNAMIC;
+			break;
+		case IEEE80211_SMPS_NUM_MODES:
+			smps = WMI_PEER_SMPS_PS_NONE;
+			ath10k_warn("invalid smps mode: %d\n", sta->smps_mode);
+			break;
+		}
+
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac update sta %pM smps (peer smps %d) to %d\n",
+			   sta->addr, smps, sta->smps_mode);
+
+		ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
+						WMI_PEER_SMPS_STATE, smps);
+		if (ret)
+			ath10k_warn("failed to update STA %pM smps (peer smps %d) to %d: %d\n",
+				    sta->addr, smps, sta->smps_mode, ret);
+	}
+
+	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
+		/* FIXME: Not implemented. Not really sure if it's possible to
+		 * influence HW rate control so much. */
+		ath10k_dbg(ATH10K_DBG_MAC,
+			   "mac sta rc update - supp rates changed - not implemented\n");
+	}
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -3332,6 +3422,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.tx_last_beacon			= ath10k_tx_last_beacon,
 	.restart_complete		= ath10k_restart_complete,
 	.get_survey			= ath10k_get_survey,
+	.sta_rc_update			= ath10k_sta_rc_update,
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0087d69..e8c4bb7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -3847,6 +3847,12 @@ enum wmi_peer_smps_state {
 	WMI_PEER_SMPS_DYNAMIC = 0x2
 };
 
+enum wmi_peer_chwidth {
+	WMI_PEER_CHWIDTH_20MHZ = 0,
+	WMI_PEER_CHWIDTH_40MHZ = 1,
+	WMI_PEER_CHWIDTH_80MHZ = 2,
+};
+
 enum wmi_peer_param {
 	WMI_PEER_SMPS_STATE = 0x1, /* see %wmi_peer_smps_state */
 	WMI_PEER_AMPDU      = 0x2,
-- 
1.8.4.rc3

