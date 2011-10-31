Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:38372 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJ4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:56:06 -0400
Subject: [PATCH 2/5] ath6kl: create ath6kl_cfg80211_stop()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 31 Oct 2011 11:56:02 +0200
Message-ID: <20111031095602.3598.40105.stgit@localhost6.localdomain6> (sfid-20111031_105617_057310_B7E880F0)
In-Reply-To: <20111031095550.3598.52653.stgit@localhost6.localdomain6>
References: <20111031095550.3598.52653.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just take code from deep sleep for now, will be improved later. No
functional changes.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   49 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 +
 drivers/net/wireless/ath/ath6kl/main.c     |   46 +-------------------------
 3 files changed, 52 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 188fded..94038cb 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2112,6 +2112,55 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
 };
 
+void ath6kl_cfg80211_stop(struct ath6kl *ar)
+{
+	struct ath6kl_vif *vif;
+
+	/* FIXME: for multi vif */
+	vif = ath6kl_vif_first(ar);
+	if (!vif) {
+		/* save the current power mode before enabling power save */
+		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
+
+		if (ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER) != 0)
+			ath6kl_warn("ath6kl_deep_sleep_enable: "
+				    "wmi_powermode_cmd failed\n");
+		return;
+	}
+
+	switch (vif->sme_state) {
+	case SME_CONNECTING:
+		cfg80211_connect_result(vif->ndev, vif->bssid, NULL, 0,
+					NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
+		break;
+	case SME_CONNECTED:
+	default:
+		/*
+		 * FIXME: oddly enough smeState is in DISCONNECTED during
+		 * suspend, why? Need to send disconnected event in that
+		 * state.
+		 */
+		cfg80211_disconnected(vif->ndev, 0, NULL, 0, GFP_KERNEL);
+		break;
+	}
+
+	if (test_bit(CONNECTED, &vif->flags) ||
+	    test_bit(CONNECT_PEND, &vif->flags))
+		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
+
+	vif->sme_state = SME_DISCONNECTED;
+
+	/* disable scanning */
+	if (ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0xFFFF, 0, 0,
+				      0, 0, 0, 0, 0, 0, 0) != 0)
+		printk(KERN_WARNING "ath6kl: failed to disable scan "
+		       "during suspend\n");
+
+	ath6kl_cfg80211_scan_complete_event(vif, true);
+}
+
 struct ath6kl *ath6kl_core_alloc(struct device *dev)
 {
 	struct ath6kl *ar;
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index f323a49..bb0ac22 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -40,4 +40,6 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid,
 				     bool ismcast);
 
+void ath6kl_cfg80211_stop(struct ath6kl *ar);
+
 #endif /* ATH6KL_CFG80211_H */
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d2822d0..378dc8d 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -580,51 +580,7 @@ void ath6kl_disconnect(struct ath6kl_vif *vif)
 
 void ath6kl_deep_sleep_enable(struct ath6kl *ar)
 {
-	struct ath6kl_vif *vif;
-
-	/* FIXME: for multi vif */
-	vif = ath6kl_vif_first(ar);
-	if (!vif) {
-		/* save the current power mode before enabling power save */
-		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
-
-		if (ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER) != 0)
-			ath6kl_warn("ath6kl_deep_sleep_enable: "
-				    "wmi_powermode_cmd failed\n");
-		return;
-	}
-
-	switch (vif->sme_state) {
-	case SME_CONNECTING:
-		cfg80211_connect_result(vif->ndev, vif->bssid, NULL, 0,
-					NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					GFP_KERNEL);
-		break;
-	case SME_CONNECTED:
-	default:
-		/*
-		 * FIXME: oddly enough smeState is in DISCONNECTED during
-		 * suspend, why? Need to send disconnected event in that
-		 * state.
-		 */
-		cfg80211_disconnected(vif->ndev, 0, NULL, 0, GFP_KERNEL);
-		break;
-	}
-
-	if (test_bit(CONNECTED, &vif->flags) ||
-	    test_bit(CONNECT_PEND, &vif->flags))
-		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
-
-	vif->sme_state = SME_DISCONNECTED;
-
-	/* disable scanning */
-	if (ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0xFFFF, 0, 0,
-				      0, 0, 0, 0, 0, 0, 0) != 0)
-		printk(KERN_WARNING "ath6kl: failed to disable scan "
-		       "during suspend\n");
-
-	ath6kl_cfg80211_scan_complete_event(vif, true);
+	ath6kl_cfg80211_stop(ar);
 
 	/* save the current power mode before enabling power save */
 	ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;

