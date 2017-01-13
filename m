Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:60075 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751701AbdAMMr5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:47:57 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC 4/5] cfg80211: add request id to cfg80211_sched_scan_results() api
Date: Fri, 13 Jan 2017 12:47:43 +0000
Message-Id: <1484311664-4840-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170113_134900_105839_7F189089)
In-Reply-To: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Have proper request id filled in the SCHED_SCAN_RESULTS notification
toward user-space by having the driver provide it through the api.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c              |  2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  2 +-
 include/net/cfg80211.h                             |  4 ++-
 net/mac80211/scan.c                                |  2 +-
 net/wireless/core.c                                |  1 -
 net/wireless/core.h                                |  1 -
 net/wireless/nl80211.c                             |  2 ++
 net/wireless/scan.c                                | 30 +++++++++++-----------
 net/wireless/trace.h                               | 17 +++++++++---
 10 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 84a6d12..04df853 100644
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
index 8280f19..34d318e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -766,7 +766,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		brcmf_dbg(SCAN, "scheduled scan completed\n");
 		cfg->internal_escan = false;
 		if (!aborted)
-			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
+			cfg80211_sched_scan_results(cfg_to_wiphy(cfg), 0);
 	} else if (scan_request) {
 		struct cfg80211_scan_info info = {
 			.aborted = aborted,
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 8548027..12b471f 100644
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
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 880a57a..17c78c4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1677,6 +1677,7 @@ struct cfg80211_sched_scan_request {
 	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
 
 	/* internal */
+	struct work_struct results_wk;
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	unsigned long scan_start;
@@ -4441,8 +4442,9 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
  * cfg80211_sched_scan_results - notify that new scan results are available
  *
  * @wiphy: the wiphy which got scheduled scan results
+ * @reqid: identifier for the related scheduled scan request
  */
-void cfg80211_sched_scan_results(struct wiphy *wiphy);
+void cfg80211_sched_scan_results(struct wiphy *wiphy, u64 reqid);
 
 /**
  * cfg80211_sched_scan_stopped - notify that the scheduled scan has stopped
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index faab3c4..3fd8757 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1219,7 +1219,7 @@ void ieee80211_sched_scan_results(struct ieee80211_hw *hw)
 
 	trace_api_sched_scan_results(local);
 
-	cfg80211_sched_scan_results(hw->wiphy);
+	cfg80211_sched_scan_results(hw->wiphy, 0);
 }
 EXPORT_SYMBOL(ieee80211_sched_scan_results);
 
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 1f91e85..3ac0f91 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -442,7 +442,6 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_LIST_HEAD(&rdev->sched_scan_req_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
-	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
 	INIT_LIST_HEAD(&rdev->mlme_unreg);
 	spin_lock_init(&rdev->mlme_unreg_lock);
 	INIT_WORK(&rdev->mlme_unreg_wk, cfg80211_mlme_unreg_wk);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 621b67c..9c406b9 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -78,7 +78,6 @@ struct cfg80211_registered_device {
 	struct cfg80211_sched_scan_request __rcu *sched_scan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
-	struct work_struct sched_scan_results_wk;
 
 	struct genl_info *cur_cmd_info;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a0cd0e2..81a9382 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7198,6 +7198,8 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (err)
 		goto out_err;
 
+	INIT_WORK(&sched_scan_req->results_wk, __cfg80211_sched_scan_results);
+
 	/* leave request id zero for legacy request
 	 * or if driver does not support multi-scheduled scan
 	 */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 04615338..5f24c13 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -361,38 +361,38 @@ int cfg80211_sched_scan_req_possible(struct cfg80211_registered_device *rdev,
 void __cfg80211_sched_scan_results(struct work_struct *wk)
 {
 	struct cfg80211_registered_device *rdev;
-	struct cfg80211_sched_scan_request *request;
+	struct cfg80211_sched_scan_request *req;
 
-	rdev = container_of(wk, struct cfg80211_registered_device,
-			    sched_scan_results_wk);
+	req = container_of(wk, struct cfg80211_sched_scan_request, results_wk);
+	rdev = wiphy_to_rdev(req->wiphy);
 
 	rtnl_lock();
 
-	request = rtnl_dereference(rdev->sched_scan_req);
-
 	/* we don't have sched_scan_req anymore if the scan is stopping */
-	if (request) {
-		if (request->flags & NL80211_SCAN_FLAG_FLUSH) {
+	if (req) {
+		if (req->flags & NL80211_SCAN_FLAG_FLUSH) {
 			/* flush entries from previous scans */
 			spin_lock_bh(&rdev->bss_lock);
-			__cfg80211_bss_expire(rdev, request->scan_start);
+			__cfg80211_bss_expire(rdev, req->scan_start);
 			spin_unlock_bh(&rdev->bss_lock);
-			request->scan_start = jiffies;
+			req->scan_start = jiffies;
 		}
-		nl80211_send_sched_scan(request, NL80211_CMD_SCHED_SCAN_RESULTS);
+		nl80211_send_sched_scan(req, NL80211_CMD_SCHED_SCAN_RESULTS);
 	}
 
 	rtnl_unlock();
 }
 
-void cfg80211_sched_scan_results(struct wiphy *wiphy)
+void cfg80211_sched_scan_results(struct wiphy *wiphy, u64 reqid)
 {
-	trace_cfg80211_sched_scan_results(wiphy);
+	struct cfg80211_sched_scan_request *request;
+
+	trace_cfg80211_sched_scan_results(wiphy, reqid);
 	/* ignore if we're not scanning */
 
-	if (rcu_access_pointer(wiphy_to_rdev(wiphy)->sched_scan_req))
-		queue_work(cfg80211_wq,
-			   &wiphy_to_rdev(wiphy)->sched_scan_results_wk);
+	request = cfg80211_find_sched_scan_req(wiphy_to_rdev(wiphy), reqid);
+	if (!IS_ERR(request))
+		queue_work(cfg80211_wq, &request->results_wk);
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_results);
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 8c04685..126779a 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2795,14 +2795,23 @@
 		  MAC_PR_ARG(tsf_bssid))
 );
 
-DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_results,
+DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_stopped,
 	TP_PROTO(struct wiphy *wiphy),
 	TP_ARGS(wiphy)
 );
 
-DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_stopped,
-	TP_PROTO(struct wiphy *wiphy),
-	TP_ARGS(wiphy)
+TRACE_EVENT(cfg80211_sched_scan_results,
+	TP_PROTO(struct wiphy *wiphy, u64 reqid),
+	TP_ARGS(wiphy, reqid),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(u64 reqid)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->reqid = reqid;
+	),
+	TP_printk(WIPHY_PR_FMT ", reqid: %llu", WIPHY_PR_ARG, __entry->reqid)
 );
 
 TRACE_EVENT(cfg80211_get_bss,
-- 
1.9.1
