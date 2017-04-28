Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:48530 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936491AbdD1Mkf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 08:40:35 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V4] cfg80211: add request id to cfg80211_sched_scan_*() api
Date: Fri, 28 Apr 2017 13:40:28 +0100
Message-Id: <1493383228-30528-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170428_144150_705458_138B4BB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have proper request id filled in the SCHED_SCAN_RESULTS and
SCHED_SCAN_STOPPED notifications toward user-space by having the
driver provide it through the api.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Johannes,

Able to give it a spin on my test equipment and it passed so
here it is. Did not see the pull-request so ....

Regards,
Arend

changed since:
 V4:
  - move result work to struct registered_device.
  - return valid pointer or NULL in sched-scan search function.
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  4 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  6 +--
 drivers/net/wireless/marvell/mwifiex/main.c        |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  2 +-
 include/net/cfg80211.h                             | 11 ++--
 net/mac80211/pm.c                                  |  2 +-
 net/mac80211/scan.c                                |  4 +-
 net/mac80211/util.c                                |  2 +-
 net/wireless/core.c                                |  2 +-
 net/wireless/core.h                                |  4 +-
 net/wireless/scan.c                                | 62 +++++++++++-----------
 net/wireless/trace.h                               | 26 ++++++---
 16 files changed, 77 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fd53ffb..decb937 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -169,7 +169,7 @@ static void ath6kl_cfg80211_sscan_disable(struct ath6kl_vif *vif)
 	if (!stopped)
 		return;
 
-	cfg80211_sched_scan_stopped(ar->wiphy);
+	cfg80211_sched_scan_stopped(ar->wiphy, 0);
 }
 
 static int ath6kl_set_wpa_version(struct ath6kl_vif *vif,
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index a082de8..bfc20b4 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1082,7 +1082,7 @@ void ath6kl_wmi_sscan_timer(unsigned long ptr)
 {
 	struct ath6kl_vif *vif = (struct ath6kl_vif *) ptr;
 
-	cfg80211_sched_scan_results(vif->ar->wiphy);
+	cfg80211_sched_scan_results(vif->ar->wiphy, 0);
 }
 
 static int ath6kl_wmi_bssinfo_event_rx(struct wmi *wmi, u8 *datap, int len,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 130f0d4..089b6e0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -762,7 +762,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		brcmf_dbg(SCAN, "scheduled scan completed\n");
 		cfg->internal_escan = false;
 		if (!aborted)
-			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
+			cfg80211_sched_scan_results(cfg_to_wiphy(cfg), 0);
 	} else if (scan_request) {
 		struct cfg80211_scan_info info = {
 			.aborted = aborted,
@@ -3372,7 +3372,7 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 		goto free_req;
 
 out_err:
-	cfg80211_sched_scan_stopped(wiphy);
+	cfg80211_sched_scan_stopped(wiphy, 0);
 free_req:
 	kfree(request);
 	return err;
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 0406a98..7ec06bf 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2053,7 +2053,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (!mwifiex_stop_bg_scan(priv))
-		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
 
 	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
@@ -2321,7 +2321,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 		    (int)sme->ssid_len, (char *)sme->ssid, sme->bssid);
 
 	if (!mwifiex_stop_bg_scan(priv))
-		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
 				     priv->bss_mode, sme->channel, sme, 0);
@@ -2530,7 +2530,7 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 		priv->scan_block = false;
 
 	if (!mwifiex_stop_bg_scan(priv))
-		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
 
 	user_scan_cfg = kzalloc(sizeof(*user_scan_cfg), GFP_KERNEL);
 	if (!user_scan_cfg)
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 976011d..dd87b9f 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -748,7 +748,7 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter,
 		mwifiex_dbg(priv->adapter, INFO,
 			    "aborting bgscan on ndo_stop\n");
 		mwifiex_stop_bg_scan(priv);
-		cfg80211_sched_scan_stopped(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index ab75da3..f1d1f56f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -1201,7 +1201,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
 		ret = mwifiex_ret_802_11_scan(priv, resp);
-		cfg80211_sched_scan_results(priv->wdev.wiphy);
+		cfg80211_sched_scan_results(priv->wdev.wiphy, 0);
 		mwifiex_dbg(adapter, CMD,
 			    "info: CMD_RESP: BG_SCAN result is ready!\n");
 		break;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index b5b7664..839df8a 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -793,7 +793,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_BG_SCAN_STOPPED:
 		dev_dbg(adapter->dev, "event: BGS_STOPPED\n");
-		cfg80211_sched_scan_stopped(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
 		if (priv->sched_scanning)
 			priv->sched_scanning = false;
 		break;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 1532ac9..42997e0 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -560,7 +560,7 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 #endif
 			mwifiex_dbg(adapter, CMD, "aborting bgscan!\n");
 			mwifiex_stop_bg_scan(priv);
-			cfg80211_sched_scan_stopped(priv->wdev.wiphy);
+			cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
 #ifdef CONFIG_PM
 		}
 #endif
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e427189..a783f66 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1666,6 +1666,7 @@ struct cfg80211_bss_select_adjust {
  * 	(others are filtered out).
  *	If ommited, all results are passed.
  * @n_match_sets: number of match sets
+ * @results_wk: worker for processing results notification.
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @scan_start: start time of the scheduled scan
@@ -1726,6 +1727,7 @@ struct cfg80211_sched_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	unsigned long scan_start;
+	bool report_results;
 	struct rcu_head rcu_head;
 	u32 owner_nlportid;
 	bool nl_owner_dead;
@@ -4564,31 +4566,34 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
  * cfg80211_sched_scan_results - notify that new scan results are available
  *
  * @wiphy: the wiphy which got scheduled scan results
+ * @reqid: identifier for the related scheduled scan request
  */
-void cfg80211_sched_scan_results(struct wiphy *wiphy);
+void cfg80211_sched_scan_results(struct wiphy *wiphy, u64 reqid);
 
 /**
  * cfg80211_sched_scan_stopped - notify that the scheduled scan has stopped
  *
  * @wiphy: the wiphy on which the scheduled scan stopped
+ * @reqid: identifier for the related scheduled scan request
  *
  * The driver can call this function to inform cfg80211 that the
  * scheduled scan had to be stopped, for whatever reason.  The driver
  * is then called back via the sched_scan_stop operation when done.
  */
-void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
+void cfg80211_sched_scan_stopped(struct wiphy *wiphy, u64 reqid);
 
 /**
  * cfg80211_sched_scan_stopped_rtnl - notify that the scheduled scan has stopped
  *
  * @wiphy: the wiphy on which the scheduled scan stopped
+ * @reqid: identifier for the related scheduled scan request
  *
  * The driver can call this function to inform cfg80211 that the
  * scheduled scan had to be stopped, for whatever reason.  The driver
  * is then called back via the sched_scan_stop operation when done.
  * This function should be called with rtnl locked.
  */
-void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy);
+void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy, u64 reqid);
 
 /**
  * cfg80211_inform_bss_frame_data - inform cfg80211 of a received BSS frame
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 76a8bcd..a87d195 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -10,7 +10,7 @@ static void ieee80211_sched_scan_cancel(struct ieee80211_local *local)
 {
 	if (ieee80211_request_sched_scan_stop(local))
 		return;
-	cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
+	cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy, 0);
 }
 
 int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index faab3c4..94be10e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1219,7 +1219,7 @@ void ieee80211_sched_scan_results(struct ieee80211_hw *hw)
 
 	trace_api_sched_scan_results(local);
 
-	cfg80211_sched_scan_results(hw->wiphy);
+	cfg80211_sched_scan_results(hw->wiphy, 0);
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_results);
 
@@ -1239,7 +1239,7 @@ void ieee80211_sched_scan_end(struct ieee80211_local *local)
 
 	mutex_unlock(&local->mtx);
 
-	cfg80211_sched_scan_stopped(local->hw.wiphy);
+	cfg80211_sched_scan_stopped(local->hw.wiphy, 0);
 }
 
 void ieee80211_sched_scan_stopped_work(struct work_struct *work)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 37dad3d..d17b3ad 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2103,7 +2103,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mutex_unlock(&local->mtx);
 
 	if (sched_scan_stopped)
-		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy, 0);
 
  wake_up:
 	if (local->in_reconfig) {
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a3c0c48a..83ea164 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -456,7 +456,6 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_LIST_HEAD(&rdev->sched_scan_req_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
-	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
 	INIT_LIST_HEAD(&rdev->mlme_unreg);
 	spin_lock_init(&rdev->mlme_unreg_lock);
 	INIT_WORK(&rdev->mlme_unreg_wk, cfg80211_mlme_unreg_wk);
@@ -473,6 +472,7 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 
 	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
 	INIT_WORK(&rdev->sched_scan_stop_wk, cfg80211_sched_scan_stop_wk);
+	INIT_WORK(&rdev->sched_scan_res_wk, cfg80211_sched_scan_results_wk);
 	INIT_WORK(&rdev->propagate_radar_detect_wk,
 		  cfg80211_propagate_radar_detect_wk);
 	INIT_WORK(&rdev->propagate_cac_done_wk, cfg80211_propagate_cac_done_wk);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 06eaf96..c9445b5 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -77,7 +77,6 @@ struct cfg80211_registered_device {
 	struct list_head sched_scan_req_list;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
-	struct work_struct sched_scan_results_wk;
 
 	struct genl_info *cur_cmd_info;
 
@@ -93,6 +92,7 @@ struct cfg80211_registered_device {
 
 	struct work_struct destroy_work;
 	struct work_struct sched_scan_stop_wk;
+	struct work_struct sched_scan_res_wk;
 
 	struct cfg80211_chan_def radar_chandef;
 	struct work_struct propagate_radar_detect_wk;
@@ -420,7 +420,7 @@ void cfg80211_add_sched_scan_req(struct cfg80211_registered_device *rdev,
 				 struct cfg80211_sched_scan_request *req);
 int cfg80211_sched_scan_req_possible(struct cfg80211_registered_device *rdev,
 				     bool want_multi);
-void __cfg80211_sched_scan_results(struct work_struct *wk);
+void cfg80211_sched_scan_results_wk(struct work_struct *work);
 int cfg80211_stop_sched_scan_req(struct cfg80211_registered_device *rdev,
 				 struct cfg80211_sched_scan_request *req,
 				 bool driver_initiated);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 8d86f70..5278222 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -328,7 +328,7 @@ static void cfg80211_del_sched_scan_req(struct cfg80211_registered_device *rdev,
 		if (pos->reqid == reqid)
 			return pos;
 	}
-	return ERR_PTR(-ENOENT);
+	return NULL;
 }
 
 /*
@@ -364,67 +364,67 @@ int cfg80211_sched_scan_req_possible(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-void __cfg80211_sched_scan_results(struct work_struct *wk)
+void cfg80211_sched_scan_results_wk(struct work_struct *work)
 {
 	struct cfg80211_registered_device *rdev;
-	struct cfg80211_sched_scan_request *request;
+	struct cfg80211_sched_scan_request *req, *tmp;
 
-	rdev = container_of(wk, struct cfg80211_registered_device,
-			    sched_scan_results_wk);
+	rdev = container_of(work, struct cfg80211_registered_device,
+			   sched_scan_res_wk);
 
 	rtnl_lock();
-
-	request = cfg80211_find_sched_scan_req(rdev, 0);
-
-	/* we don't have sched_scan_req anymore if the scan is stopping */
-	if (!IS_ERR(request)) {
-		if (request->flags & NL80211_SCAN_FLAG_FLUSH) {
-			/* flush entries from previous scans */
-			spin_lock_bh(&rdev->bss_lock);
-			__cfg80211_bss_expire(rdev, request->scan_start);
-			spin_unlock_bh(&rdev->bss_lock);
-			request->scan_start = jiffies;
+	list_for_each_entry_safe(req, tmp, &rdev->sched_scan_req_list, list) {
+		if (req->report_results) {
+			req->report_results = false;
+			if (req->flags & NL80211_SCAN_FLAG_FLUSH) {
+				/* flush entries from previous scans */
+				spin_lock_bh(&rdev->bss_lock);
+				__cfg80211_bss_expire(rdev, req->scan_start);
+				spin_unlock_bh(&rdev->bss_lock);
+				req->scan_start = jiffies;
+			}
+			nl80211_send_sched_scan(req,
+						NL80211_CMD_SCHED_SCAN_RESULTS);
 		}
-		nl80211_send_sched_scan(request, NL80211_CMD_SCHED_SCAN_RESULTS);
 	}
-
 	rtnl_unlock();
 }
 
-void cfg80211_sched_scan_results(struct wiphy *wiphy)
+void cfg80211_sched_scan_results(struct wiphy *wiphy, u64 reqid)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_sched_scan_request *request;
 
-	trace_cfg80211_sched_scan_results(wiphy);
+	trace_cfg80211_sched_scan_results(wiphy, reqid);
 	/* ignore if we're not scanning */
 
 	rtnl_lock();
-	request = cfg80211_find_sched_scan_req(rdev, 0);
+	request = cfg80211_find_sched_scan_req(rdev, reqid);
+	if (request) {
+		request->report_results = true;
+		queue_work(cfg80211_wq, &rdev->sched_scan_res_wk);
+	}
 	rtnl_unlock();
 
-	if (!IS_ERR(request))
-		queue_work(cfg80211_wq,
-			   &wiphy_to_rdev(wiphy)->sched_scan_results_wk);
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_results);
 
-void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy)
+void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy, u64 reqid)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	ASSERT_RTNL();
 
-	trace_cfg80211_sched_scan_stopped(wiphy);
+	trace_cfg80211_sched_scan_stopped(wiphy, reqid);
 
-	__cfg80211_stop_sched_scan(rdev, 0, true);
+	__cfg80211_stop_sched_scan(rdev, reqid, true);
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped_rtnl);
 
-void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
+void cfg80211_sched_scan_stopped(struct wiphy *wiphy, u64 reqid)
 {
 	rtnl_lock();
-	cfg80211_sched_scan_stopped_rtnl(wiphy);
+	cfg80211_sched_scan_stopped_rtnl(wiphy, reqid);
 	rtnl_unlock();
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
@@ -456,8 +456,8 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	ASSERT_RTNL();
 
 	sched_scan_req = cfg80211_find_sched_scan_req(rdev, reqid);
-	if (IS_ERR(sched_scan_req))
-		return PTR_ERR(sched_scan_req);
+	if (!sched_scan_req)
+		return -ENOENT;
 
 	return cfg80211_stop_sched_scan_req(rdev, sched_scan_req,
 					    driver_initiated);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 8d8f6b4..ca8b205 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2820,14 +2820,28 @@
 		  MAC_PR_ARG(tsf_bssid))
 );
 
-DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_results,
-	TP_PROTO(struct wiphy *wiphy),
-	TP_ARGS(wiphy)
+DECLARE_EVENT_CLASS(wiphy_id_evt,
+	TP_PROTO(struct wiphy *wiphy, u64 id),
+	TP_ARGS(wiphy, id),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(u64, id)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->id = id;
+	),
+	TP_printk(WIPHY_PR_FMT ", id: %llu", WIPHY_PR_ARG, __entry->id)
 );
 
-DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_stopped,
-	TP_PROTO(struct wiphy *wiphy),
-	TP_ARGS(wiphy)
+DEFINE_EVENT(wiphy_id_evt, cfg80211_sched_scan_stopped,
+	TP_PROTO(struct wiphy *wiphy, u64 id),
+	TP_ARGS(wiphy, id)
+);
+
+DEFINE_EVENT(wiphy_id_evt, cfg80211_sched_scan_results,
+	TP_PROTO(struct wiphy *wiphy, u64 id),
+	TP_ARGS(wiphy, id)
 );
 
 TRACE_EVENT(cfg80211_get_bss,
-- 
1.9.1
