Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31519 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab2KPMxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:53:44 -0500
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 7/8] ath6kl: Move and rename ath6kl_cleanup_vif function
Date: Fri, 16 Nov 2012 18:23:36 +0530
Message-ID: <1353070416-6113-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121116_135347_296422_64C2954E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Rename ath6kl_cleanup_vif function as 'ath6kl_cfg80211_vif_stop'
which is the more appropriate name considering the functionality
of the module and vif specific cleanup is actually done by
ath6kl_cfg80211_vif_cleanup. Also move it to cfg80211.c.
Also make ath6kl_cfg80211_sta_bmiss_enhance as static function.
This addresses a FIXME/TODO.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   81 +++++++++++++++++++---------
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    2 -
 drivers/net/wireless/ath/ath6kl/core.h     |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c     |   34 +-----------
 4 files changed, 58 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 8325daf..dc059e2 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -427,6 +427,30 @@ static bool ath6kl_is_tx_pending(struct ath6kl *ar)
 	return ar->tx_pending[ath6kl_wmi_get_control_ep(ar->wmi)] == 0;
 }
 
+static void ath6kl_cfg80211_sta_bmiss_enhance(struct ath6kl_vif *vif,
+					      bool enable)
+{
+	int err;
+
+	if (WARN_ON(!test_bit(WMI_READY, &vif->ar->flag)))
+		return;
+
+	if (vif->nw_type != INFRA_NETWORK)
+		return;
+
+	if (!test_bit(ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
+		      vif->ar->fw_capabilities))
+		return;
+
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s fw bmiss enhance\n",
+		   enable ? "enable" : "disable");
+
+	err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
+					       vif->fw_vif_idx, enable);
+	if (err)
+		ath6kl_err("failed to %s enhanced bmiss detection: %d\n",
+			   enable ? "enable" : "disable", err);
+}
 
 static int ath6kl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 				   struct cfg80211_connect_params *sme)
@@ -1507,7 +1531,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 	list_del(&vif->list);
 	spin_unlock_bh(&ar->list_lock);
 
-	ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
+	ath6kl_cfg80211_vif_stop(vif, test_bit(WMI_READY, &ar->flag));
 
 	ath6kl_cfg80211_vif_cleanup(vif);
 
@@ -2667,30 +2691,6 @@ static int ath6kl_set_ies(struct ath6kl_vif *vif,
 	return 0;
 }
 
-void ath6kl_cfg80211_sta_bmiss_enhance(struct ath6kl_vif *vif, bool enable)
-{
-	int err;
-
-	if (WARN_ON(!test_bit(WMI_READY, &vif->ar->flag)))
-		return;
-
-	if (vif->nw_type != INFRA_NETWORK)
-		return;
-
-	if (!test_bit(ATH6KL_FW_CAPABILITY_BMISS_ENHANCE,
-		      vif->ar->fw_capabilities))
-		return;
-
-	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s fw bmiss enhance\n",
-		   enable ? "enable" : "disable");
-
-	err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
-					       vif->fw_vif_idx, enable);
-	if (err)
-		ath6kl_err("failed to %s enhanced bmiss detection: %d\n",
-			   enable ? "enable" : "disable", err);
-}
-
 static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
 				u8 *rsn_capab)
 {
@@ -3546,6 +3546,37 @@ static int ath6kl_cfg80211_vif_init(struct ath6kl_vif *vif)
 	return 0;
 }
 
+void ath6kl_cfg80211_vif_stop(struct ath6kl_vif *vif, bool wmi_ready)
+{
+	static u8 bcast_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	bool discon_issued;
+
+	netif_stop_queue(vif->ndev);
+
+	clear_bit(WLAN_ENABLED, &vif->flags);
+
+	if (wmi_ready) {
+		discon_issued = test_bit(CONNECTED, &vif->flags) ||
+				test_bit(CONNECT_PEND, &vif->flags);
+		ath6kl_disconnect(vif);
+		del_timer(&vif->disconnect_timer);
+
+		if (discon_issued)
+			ath6kl_disconnect_event(vif, DISCONNECT_CMD,
+						(vif->nw_type & AP_NETWORK) ?
+						bcast_mac : vif->bssid,
+						0, NULL, 0);
+	}
+
+	if (vif->scan_req) {
+		cfg80211_scan_done(vif->scan_req, true);
+		vif->scan_req = NULL;
+	}
+
+	/* need to clean up enhanced bmiss detection fw state */
+	ath6kl_cfg80211_sta_bmiss_enhance(vif, false);
+}
+
 void ath6kl_cfg80211_vif_cleanup(struct ath6kl_vif *vif)
 {
 	struct ath6kl *ar = vif->ar;
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 3d6a0b5..7a42b49 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -61,7 +61,5 @@ void ath6kl_cfg80211_cleanup(struct ath6kl *ar);
 
 struct ath6kl *ath6kl_cfg80211_create(void);
 void ath6kl_cfg80211_destroy(struct ath6kl *ar);
-/* TODO: remove this once ath6kl_vif_cleanup() is moved to cfg80211.c */
-void ath6kl_cfg80211_sta_bmiss_enhance(struct ath6kl_vif *vif, bool enable);
 
 #endif /* ATH6KL_CFG80211_H */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 3b2dfc1..f7ef041 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -937,7 +937,7 @@ void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 			 bool wait_fot_compltn, bool cold_reset);
 void ath6kl_init_control_info(struct ath6kl_vif *vif);
 struct ath6kl_vif *ath6kl_vif_first(struct ath6kl *ar);
-void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready);
+void ath6kl_cfg80211_vif_stop(struct ath6kl_vif *vif, bool wmi_ready);
 int ath6kl_init_hw_start(struct ath6kl *ar);
 int ath6kl_init_hw_stop(struct ath6kl *ar);
 int ath6kl_init_fetch_firmwares(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 4fddf12..3779f1d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1712,38 +1712,6 @@ void ath6kl_init_hw_restart(struct ath6kl *ar)
 	}
 }
 
-/* FIXME: move this to cfg80211.c and rename to ath6kl_cfg80211_vif_stop() */
-void ath6kl_cleanup_vif(struct ath6kl_vif *vif, bool wmi_ready)
-{
-	static u8 bcast_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	bool discon_issued;
-
-	netif_stop_queue(vif->ndev);
-
-	clear_bit(WLAN_ENABLED, &vif->flags);
-
-	if (wmi_ready) {
-		discon_issued = test_bit(CONNECTED, &vif->flags) ||
-				test_bit(CONNECT_PEND, &vif->flags);
-		ath6kl_disconnect(vif);
-		del_timer(&vif->disconnect_timer);
-
-		if (discon_issued)
-			ath6kl_disconnect_event(vif, DISCONNECT_CMD,
-						(vif->nw_type & AP_NETWORK) ?
-						bcast_mac : vif->bssid,
-						0, NULL, 0);
-	}
-
-	if (vif->scan_req) {
-		cfg80211_scan_done(vif->scan_req, true);
-		vif->scan_req = NULL;
-	}
-
-	/* need to clean up enhanced bmiss detection fw state */
-	ath6kl_cfg80211_sta_bmiss_enhance(vif, false);
-}
-
 void ath6kl_stop_txrx(struct ath6kl *ar)
 {
 	struct ath6kl_vif *vif, *tmp_vif;
@@ -1763,7 +1731,7 @@ void ath6kl_stop_txrx(struct ath6kl *ar)
 	list_for_each_entry_safe(vif, tmp_vif, &ar->vif_list, list) {
 		list_del(&vif->list);
 		spin_unlock_bh(&ar->list_lock);
-		ath6kl_cleanup_vif(vif, test_bit(WMI_READY, &ar->flag));
+		ath6kl_cfg80211_vif_stop(vif, test_bit(WMI_READY, &ar->flag));
 		rtnl_lock();
 		ath6kl_cfg80211_vif_cleanup(vif);
 		rtnl_unlock();
-- 
1.7.0.4

