Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:33865 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJ4P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:56:15 -0400
Subject: [PATCH 3/5] ath6kl: implement ath6kl_cfg80211_suspend()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 31 Oct 2011 11:56:10 +0200
Message-ID: <20111031095610.3598.16599.stgit@localhost6.localdomain6> (sfid-20111031_105622_879554_6A85DEE1)
In-Reply-To: <20111031095550.3598.52653.stgit@localhost6.localdomain6>
References: <20111031095550.3598.52653.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is in preparation for cutpower suspend feature. HIF layer makes
the decision based on information provided by cfg80211 and what hardware
actually supports. Then it calls ath6kl_cfg80211_suspend() to enable
the chosen mode.

Functionality should be the same, this is just preparation for
more suspend modes (cutpower and wow).

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   46 ++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    8 +++++
 drivers/net/wireless/ath/ath6kl/core.h     |    1 -
 drivers/net/wireless/ath/ath6kl/main.c     |   12 -------
 drivers/net/wireless/ath/ath6kl/sdio.c     |    9 +----
 5 files changed, 52 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 94038cb..0691a95 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1653,8 +1653,46 @@ static int ath6kl_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
+int ath6kl_cfg80211_suspend(struct ath6kl *ar,
+			    enum ath6kl_cfg_suspend_mode mode)
+{
+	int ret;
+
+	ath6kl_cfg80211_stop(ar);
+
+	switch (mode) {
+	case ATH6KL_CFG_SUSPEND_DEEPSLEEP:
+		/* save the current power mode before enabling power save */
+		ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
+
+		ret = ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER);
+		if (ret) {
+			ath6kl_warn("wmi powermode command failed during suspend: %d\n",
+				    ret);
+		}
+
+		break;
+	}
+
+	return 0;
+}
+
+int ath6kl_cfg80211_resume(struct ath6kl *ar)
+{
+	if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
+		if (ath6kl_wmi_powermode_cmd(ar->wmi, 0,
+			ar->wmi->saved_pwr_mode) != 0)
+			ath6kl_warn("ath6kl_sdio_resume: "
+				"wmi_powermode_cmd failed\n");
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_PM
-static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
+
+/* hif layer decides what suspend mode to use */
+static int __ath6kl_cfg80211_suspend(struct wiphy *wiphy,
 				 struct cfg80211_wowlan *wow)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
@@ -1662,7 +1700,7 @@ static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
 	return ath6kl_hif_suspend(ar);
 }
 
-static int ar6k_cfg80211_resume(struct wiphy *wiphy)
+static int __ath6kl_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
 
@@ -2098,8 +2136,8 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.flush_pmksa = ath6kl_flush_pmksa,
 	CFG80211_TESTMODE_CMD(ath6kl_tm_cmd)
 #ifdef CONFIG_PM
-	.suspend = ar6k_cfg80211_suspend,
-	.resume = ar6k_cfg80211_resume,
+	.suspend = __ath6kl_cfg80211_suspend,
+	.resume = __ath6kl_cfg80211_resume,
 #endif
 	.set_channel = ath6kl_set_channel,
 	.add_beacon = ath6kl_add_beacon,
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index bb0ac22..3630c5e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -17,6 +17,10 @@
 #ifndef ATH6KL_CFG80211_H
 #define ATH6KL_CFG80211_H
 
+enum ath6kl_cfg_suspend_mode {
+	ATH6KL_CFG_SUSPEND_DEEPSLEEP,
+};
+
 struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 					enum nl80211_iftype type,
 					u8 fw_vif_idx, u8 nw_type);
@@ -40,6 +44,10 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid,
 				     bool ismcast);
 
+int ath6kl_cfg80211_suspend(struct ath6kl *ar,
+			    enum ath6kl_cfg_suspend_mode mode);
+int ath6kl_cfg80211_resume(struct ath6kl *ar);
+
 void ath6kl_cfg80211_stop(struct ath6kl *ar);
 
 #endif /* ATH6KL_CFG80211_H */
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 95aed7d..00cc1db 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -649,7 +649,6 @@ void ath6kl_pspoll_event(struct ath6kl_vif *vif, u8 aid);
 
 void ath6kl_dtimexpiry_event(struct ath6kl_vif *vif);
 void ath6kl_disconnect(struct ath6kl_vif *vif);
-void ath6kl_deep_sleep_enable(struct ath6kl *ar);
 void aggr_recv_delba_req_evt(struct ath6kl_vif *vif, u8 tid);
 void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 			     u8 win_sz);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 378dc8d..23da82e 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -578,18 +578,6 @@ void ath6kl_disconnect(struct ath6kl_vif *vif)
 	}
 }
 
-void ath6kl_deep_sleep_enable(struct ath6kl *ar)
-{
-	ath6kl_cfg80211_stop(ar);
-
-	/* save the current power mode before enabling power save */
-	ar->wmi->saved_pwr_mode = ar->wmi->pwr_mode;
-
-	if (ath6kl_wmi_powermode_cmd(ar->wmi, 0, REC_POWER) != 0)
-		ath6kl_warn("ath6kl_deep_sleep_enable: "
-			"wmi_powermode_cmd failed\n");
-}
-
 /* WMI Event handlers */
 
 static const char *get_hw_id_string(u32 id)
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index c61c512..d718926 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -757,19 +757,14 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 		return ret;
 	}
 
-	ath6kl_deep_sleep_enable(ar);
+	ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP);
 
 	return 0;
 }
 
 static int ath6kl_sdio_resume(struct ath6kl *ar)
 {
-	if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
-		if (ath6kl_wmi_powermode_cmd(ar->wmi, 0,
-			ar->wmi->saved_pwr_mode) != 0)
-			ath6kl_warn("ath6kl_sdio_resume: "
-				"wmi_powermode_cmd failed\n");
-	}
+	ath6kl_cfg80211_resume(ar);
 
 	return 0;
 }

