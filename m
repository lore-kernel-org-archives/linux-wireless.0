Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:37187 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1LMMvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 07:51:43 -0500
Subject: [PATCH v2 3/6] ath6kl: implement ath6kl_cfg80211_stop_all()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2011 14:51:37 +0200
Message-ID: <20111213125137.10834.75911.stgit@localhost6.localdomain6> (sfid-20111213_135145_425972_A8447C69)
In-Reply-To: <20111213124923.10834.20626.stgit@localhost6.localdomain6>
References: <20111213124923.10834.20626.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During suspend we need to stop all vifs, not just the first.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   53 ++++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    3 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    3 +-
 3 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5f12c04..2bab65f 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1799,7 +1799,7 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 	case ATH6KL_CFG_SUSPEND_DEEPSLEEP:
 
-		ath6kl_cfg80211_stop(ar);
+		ath6kl_cfg80211_stop_all(ar);
 
 		/* save the current power mode before enabling power save */
 		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
@@ -1816,7 +1816,7 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 	case ATH6KL_CFG_SUSPEND_CUTPOWER:
 
-		ath6kl_cfg80211_stop(ar);
+		ath6kl_cfg80211_stop_all(ar);
 
 		if (ar->state == ATH6KL_STATE_OFF) {
 			ath6kl_dbg(ATH6KL_DBG_SUSPEND,
@@ -2389,22 +2389,8 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
 };
 
-void ath6kl_cfg80211_stop(struct ath6kl *ar)
+void ath6kl_cfg80211_stop(struct ath6kl_vif *vif)
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
 	switch (vif->sme_state) {
 	case SME_DISCONNECTED:
 		break;
@@ -2421,21 +2407,44 @@ void ath6kl_cfg80211_stop(struct ath6kl *ar)
 
 	if (test_bit(CONNECTED, &vif->flags) ||
 	    test_bit(CONNECT_PEND, &vif->flags))
-		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
+		ath6kl_wmi_disconnect_cmd(vif->ar->wmi, vif->fw_vif_idx);
 
 	vif->sme_state = SME_DISCONNECTED;
 	clear_bit(CONNECTED, &vif->flags);
 	clear_bit(CONNECT_PEND, &vif->flags);
 
 	/* disable scanning */
-	if (ath6kl_wmi_scanparams_cmd(ar->wmi, vif->fw_vif_idx, 0xFFFF, 0, 0,
-				      0, 0, 0, 0, 0, 0, 0) != 0)
-		printk(KERN_WARNING "ath6kl: failed to disable scan "
-		       "during suspend\n");
+	if (ath6kl_wmi_scanparams_cmd(vif->ar->wmi, vif->fw_vif_idx, 0xFFFF,
+				      0, 0, 0, 0, 0, 0, 0, 0, 0) != 0)
+		ath6kl_warn("failed to disable scan during stop\n");
 
 	ath6kl_cfg80211_scan_complete_event(vif, true);
 }
 
+void ath6kl_cfg80211_stop_all(struct ath6kl *ar)
+{
+	struct ath6kl_vif *vif;
+
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
+	/*
+	 * FIXME: we should take ar->list_lock to protect changes in the
+	 * vif_list, but that's not trivial to do as ath6kl_cfg80211_stop()
+	 * sleeps.
+	 */
+	list_for_each_entry(vif, &ar->vif_list, list)
+		ath6kl_cfg80211_stop(vif);
+}
+
 struct ath6kl *ath6kl_core_alloc(struct device *dev)
 {
 	struct ath6kl *ar;
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 59fa9d8..226a734 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -52,6 +52,7 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 int ath6kl_cfg80211_resume(struct ath6kl *ar);
 
-void ath6kl_cfg80211_stop(struct ath6kl *ar);
+void ath6kl_cfg80211_stop(struct ath6kl_vif *vif);
+void ath6kl_cfg80211_stop_all(struct ath6kl *ar);
 
 #endif /* ATH6KL_CFG80211_H */
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 0c7a013..f96e9f3 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1000,12 +1000,11 @@ static int ath6kl_open(struct net_device *dev)
 
 static int ath6kl_close(struct net_device *dev)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
 	netif_stop_queue(dev);
 
-	ath6kl_cfg80211_stop(ar);
+	ath6kl_cfg80211_stop(vif);
 
 	clear_bit(WLAN_ENABLED, &vif->flags);
 

