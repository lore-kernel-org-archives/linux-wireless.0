Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab0D0J7i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 05:59:38 -0400
Subject: [PATCH] mac80211: give virtual interface to hw_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 11:59:34 +0200
Message-ID: <1272362374.3549.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When scanning, it is somewhat important to scan
on the correct virtual interface. All drivers
that currently implement hw_scan only support a
single virtual interface, but that may change
and then we'd want to be ready.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>	
---
 drivers/net/wireless/at76c50x-usb.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h   |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-scan.c   |    3 ++-
 drivers/net/wireless/mac80211_hwsim.c     |    1 +
 drivers/net/wireless/wl12xx/wl1251_main.c |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |    1 +
 include/net/mac80211.h                    |    2 +-
 net/mac80211/driver-ops.h                 |    5 +++--
 net/mac80211/driver-trace.h               |    9 ++++++---
 net/mac80211/scan.c                       |    4 ++--
 10 files changed, 21 insertions(+), 10 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/at76c50x-usb.c	2009-12-29 14:31:37.000000000 +0100
+++ wireless-testing/drivers/net/wireless/at76c50x-usb.c	2010-04-27 11:58:52.000000000 +0200
@@ -1889,6 +1889,7 @@ static void at76_dwork_hw_scan(struct wo
 }
 
 static int at76_hw_scan(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif,
 			struct cfg80211_scan_request *req)
 {
 	struct at76_priv *priv = hw->priv;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h	2010-04-20 21:14:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h	2010-04-27 11:58:52.000000000 +0200
@@ -512,7 +512,9 @@ static inline __le32 iwl_hw_set_rate_n_f
 void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
-int iwl_mac_hw_scan(struct ieee80211_hw *hw, struct cfg80211_scan_request *req);
+int iwl_mac_hw_scan(struct ieee80211_hw *hw,
+		    struct ieee80211_vif *vif,
+		    struct cfg80211_scan_request *req);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
 int iwl_force_reset(struct iwl_priv *priv, int mode);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-scan.c	2010-04-20 21:14:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-scan.c	2010-04-27 11:58:52.000000000 +0200
@@ -313,7 +313,8 @@ static int iwl_scan_initiate(struct iwl_
 }
 
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
-		     struct cfg80211_scan_request *req)
+		    struct ieee80211_vif *vif,
+		    struct cfg80211_scan_request *req)
 {
 	struct iwl_priv *priv = hw->priv;
 	int ret;
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2010-04-27 11:58:18.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2010-04-27 11:58:52.000000000 +0200
@@ -991,6 +991,7 @@ static void hw_scan_done(struct work_str
 }
 
 static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
 				  struct cfg80211_scan_request *req)
 {
 	struct hw_scan_done *hsd = kzalloc(sizeof(*hsd), GFP_KERNEL);
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2010-04-20 21:14:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_main.c	2010-04-27 11:58:52.000000000 +0200
@@ -857,6 +857,7 @@ out:
 }
 
 static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
 			     struct cfg80211_scan_request *req)
 {
 	struct wl1251 *wl = hw->priv;
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_main.c	2010-04-20 21:14:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_main.c	2010-04-27 11:58:52.000000000 +0200
@@ -1524,6 +1524,7 @@ out:
 }
 
 static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
 			     struct cfg80211_scan_request *req)
 {
 	struct wl1271 *wl = hw->priv;
--- wireless-testing.orig/include/net/mac80211.h	2010-04-27 11:58:17.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-04-27 11:58:52.000000000 +0200
@@ -1666,7 +1666,7 @@ struct ieee80211_ops {
 				struct ieee80211_key_conf *conf,
 				struct ieee80211_sta *sta,
 				u32 iv32, u16 *phase1key);
-	int (*hw_scan)(struct ieee80211_hw *hw,
+	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct cfg80211_scan_request *req);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
 	void (*sw_scan_complete)(struct ieee80211_hw *hw);
--- wireless-testing.orig/net/mac80211/driver-ops.h	2010-04-20 21:14:43.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2010-04-27 11:58:52.000000000 +0200
@@ -154,14 +154,15 @@ static inline void drv_update_tkip_key(s
 }
 
 static inline int drv_hw_scan(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
 			      struct cfg80211_scan_request *req)
 {
 	int ret;
 
 	might_sleep();
 
-	ret = local->ops->hw_scan(&local->hw, req);
-	trace_drv_hw_scan(local, req, ret);
+	ret = local->ops->hw_scan(&local->hw, &sdata->vif, req);
+	trace_drv_hw_scan(local, sdata, req, ret);
 	return ret;
 }
 
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-04-09 11:46:46.000000000 +0200
+++ wireless-testing/net/mac80211/driver-trace.h	2010-04-27 11:58:52.000000000 +0200
@@ -363,23 +363,26 @@ TRACE_EVENT(drv_update_tkip_key,
 
 TRACE_EVENT(drv_hw_scan,
 	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
 		 struct cfg80211_scan_request *req, int ret),
 
-	TP_ARGS(local, req, ret),
+	TP_ARGS(local, sdata, req, ret),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
+		VIF_ENTRY
 		__field(int, ret)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
+		VIF_ASSIGN;
 		__entry->ret = ret;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " ret:%d",
-		LOCAL_PR_ARG, __entry->ret
+		LOCAL_PR_FMT VIF_PR_FMT " ret:%d",
+		LOCAL_PR_ARG,VIF_PR_ARG, __entry->ret
 	)
 );
 
--- wireless-testing.orig/net/mac80211/scan.c	2010-04-20 21:14:43.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2010-04-27 11:58:52.000000000 +0200
@@ -411,7 +411,7 @@ static int __ieee80211_start_scan(struct
 
 	if (local->ops->hw_scan) {
 		WARN_ON(!ieee80211_prep_hw_scan(local));
-		rc = drv_hw_scan(local, local->hw_scan_req);
+		rc = drv_hw_scan(local, sdata, local->hw_scan_req);
 	} else
 		rc = ieee80211_start_sw_scan(local);
 
@@ -655,7 +655,7 @@ void ieee80211_scan_work(struct work_str
 	}
 
 	if (local->hw_scan_req) {
-		int rc = drv_hw_scan(local, local->hw_scan_req);
+		int rc = drv_hw_scan(local, sdata, local->hw_scan_req);
 		mutex_unlock(&local->scan_mtx);
 		if (rc)
 			ieee80211_scan_completed(&local->hw, true);


