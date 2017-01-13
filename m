Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:60077 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751704AbdAMMr5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:47:57 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC 3/5] cfg80211: add request id parameter to .sched_scan_stop() signature
Date: Fri, 13 Jan 2017 12:47:42 +0000
Message-Id: <1484311664-4840-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170113_134859_710131_8CE4E2D1)
In-Reply-To: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For multiple scheduled scan support the driver needs to know which
scheduled scan request is being stopped. Pass the request id in the
.sched_scan_stop() callback.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c                |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   |  6 +++---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c           |  2 +-
 include/net/cfg80211.h                                    | 15 ++++++++-------
 net/mac80211/cfg.c                                        |  3 ++-
 net/wireless/rdev-ops.h                                   |  6 +++---
 net/wireless/scan.c                                       |  2 +-
 net/wireless/trace.h                                      | 10 +++++-----
 8 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b7fe0af..1509286 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3354,7 +3354,7 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 }
 
 static int ath6kl_cfg80211_sscan_stop(struct wiphy *wiphy,
-				      struct net_device *dev)
+				      struct net_device *dev, u64 reqid)
 {
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	bool stopped;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ccae3bb..8280f19 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3392,7 +3392,7 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 }
 
 static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
-					  struct net_device *ndev)
+					  struct net_device *ndev, u64 reqid)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
@@ -3595,7 +3595,7 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 				      cfg->wowl.pre_pmmode);
 		cfg->wowl.active = false;
 		if (cfg->wowl.nd_enabled) {
-			brcmf_cfg80211_sched_scan_stop(cfg->wiphy, ifp->ndev);
+			brcmf_cfg80211_sched_scan_stop(cfg->wiphy, ifp->ndev, 0);
 			brcmf_fweh_unregister(cfg->pub, BRCMF_E_PFN_NET_FOUND);
 			brcmf_fweh_register(cfg->pub, BRCMF_E_PFN_NET_FOUND,
 					    brcmf_notify_sched_scan_results);
@@ -3679,7 +3679,7 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 
 	/* Stop scheduled scan */
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO))
-		brcmf_cfg80211_sched_scan_stop(wiphy, ndev);
+		brcmf_cfg80211_sched_scan_stop(wiphy, ndev, 0);
 
 	/* end any scanning */
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 1e3bd43..243349476 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2701,7 +2701,7 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
  * previous bgscan configuration in the firmware
  */
 static int mwifiex_cfg80211_sched_scan_stop(struct wiphy *wiphy,
-					    struct net_device *dev)
+					    struct net_device *dev, u64 reqid)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4c77c82..880a57a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2695,12 +2695,12 @@ struct cfg80211_nan_func {
  * @set_cqm_txe_config: Configure connection quality monitor TX error
  *	thresholds.
  * @sched_scan_start: Tell the driver to start a scheduled scan.
- * @sched_scan_stop: Tell the driver to stop an ongoing scheduled scan. This
- *	call must stop the scheduled scan and be ready for starting a new one
- *	before it returns, i.e. @sched_scan_start may be called immediately
- *	after that again and should not fail in that case. The driver should
- *	not call cfg80211_sched_scan_stopped() for a requested stop (when this
- *	method returns 0.)
+ * @sched_scan_stop: Tell the driver to stop an ongoing scheduled scan with
+ *	given request id. This call must stop the scheduled scan and be ready
+ *	for starting a new one before it returns, i.e. @sched_scan_start may be
+ *	called immediately after that again and should not fail in that case.
+ *	The driver should not call cfg80211_sched_scan_stopped() for a requested
+ *	stop (when this method returns 0).
  *
  * @mgmt_frame_register: Notify driver that a management frame type was
  *	registered. The callback is allowed to sleep.
@@ -2995,7 +2995,8 @@ struct cfg80211_ops {
 	int	(*sched_scan_start)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct cfg80211_sched_scan_request *request);
-	int	(*sched_scan_stop)(struct wiphy *wiphy, struct net_device *dev);
+	int	(*sched_scan_stop)(struct wiphy *wiphy, struct net_device *dev,
+				   u64 reqid);
 
 	int	(*set_rekey_data)(struct wiphy *wiphy, struct net_device *dev,
 				  struct cfg80211_gtk_rekey_data *data);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a0be2f6..85748d0 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2198,7 +2198,8 @@ static void ieee80211_abort_scan(struct wiphy *wiphy, struct wireless_dev *wdev)
 }
 
 static int
-ieee80211_sched_scan_stop(struct wiphy *wiphy, struct net_device *dev)
+ieee80211_sched_scan_stop(struct wiphy *wiphy, struct net_device *dev,
+			  u64 reqid)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 9ada5e2..9da0701 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -809,11 +809,11 @@ static inline int rdev_get_antenna(struct cfg80211_registered_device *rdev,
 }
 
 static inline int rdev_sched_scan_stop(struct cfg80211_registered_device *rdev,
-				       struct net_device *dev)
+				       struct net_device *dev, u64 reqid)
 {
 	int ret;
-	trace_rdev_sched_scan_stop(&rdev->wiphy, dev);
-	ret = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
+	trace_rdev_sched_scan_stop(&rdev->wiphy, dev, reqid);
+	ret = rdev->ops->sched_scan_stop(&rdev->wiphy, dev, reqid);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f2b2064..04615338 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -423,7 +423,7 @@ int cfg80211_stop_sched_scan_req(struct cfg80211_registered_device *rdev,
 	ASSERT_RTNL();
 
 	if (!driver_initiated) {
-		int err = rdev_sched_scan_stop(rdev, req->dev);
+		int err = rdev_sched_scan_stop(rdev, req->dev, req->reqid);
 		if (err)
 			return err;
 	}
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 7990c07..8c04685 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -576,11 +576,6 @@
 	TP_ARGS(wiphy, netdev)
 );
 
-DEFINE_EVENT(wiphy_netdev_evt, rdev_sched_scan_stop,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
-	TP_ARGS(wiphy, netdev)
-);
-
 DEFINE_EVENT(wiphy_netdev_evt, rdev_set_rekey_data,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
 	TP_ARGS(wiphy, netdev)
@@ -1610,6 +1605,11 @@
 	TP_ARGS(wiphy, netdev, id)
 );
 
+DEFINE_EVENT(wiphy_netdev_id_evt, rdev_sched_scan_stop,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u64 id),
+	TP_ARGS(wiphy, netdev, id)
+);
+
 TRACE_EVENT(rdev_tdls_mgmt,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 u8 *peer, u8 action_code, u8 dialog_token,
-- 
1.9.1
