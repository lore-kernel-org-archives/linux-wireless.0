Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:39508 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751504AbdBOKh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:37:58 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V3 5/5] cfg80211: add request id in cfg80211_sched_scan_stopped{,_rtnl}() api
Date: Wed, 15 Feb 2017 10:37:29 +0000
Message-Id: <1487155049-1892-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170215_113811_640312_9EB55454)
In-Reply-To: <1487155049-1892-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1487155049-1892-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow driver to indicate which scheduled scan request is being aborted
by providing the request id.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c              |  2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c |  2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c         |  6 +++---
 drivers/net/wireless/marvell/mwifiex/main.c             |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c        |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c        |  2 +-
 include/net/cfg80211.h                                  |  6 ++++--
 net/mac80211/pm.c                                       |  2 +-
 net/mac80211/scan.c                                     |  2 +-
 net/mac80211/util.c                                     |  2 +-
 net/wireless/scan.c                                     | 10 +++++-----
 net/wireless/trace.h                                    | 17 +++++++++++------
 12 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index bcc6e24..940c8812 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -170,7 +170,7 @@ static void ath6kl_cfg80211_sscan_disable(struct ath6kl_vif *vif)
 	if (!stopped)
 		return;
 
-	cfg80211_sched_scan_stopped(ar->wiphy);
+	cfg80211_sched_scan_stopped(ar->wiphy, 0);
 }
 
 static int ath6kl_set_wpa_version(struct ath6kl_vif *vif,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b1ff93c..9025ea6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3356,7 +3356,7 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 		goto free_req;
 
 out_err:
-	cfg80211_sched_scan_stopped(wiphy);
+	cfg80211_sched_scan_stopped(wiphy, 0);
 free_req:
 	kfree(request);
 	return err;
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 91c71066..d7dd58b 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2036,7 +2036,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (!mwifiex_stop_bg_scan(priv))
-		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
 
 	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
@@ -2304,7 +2304,7 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 		    (int)sme->ssid_len, (char *)sme->ssid, sme->bssid);
 
 	if (!mwifiex_stop_bg_scan(priv))
-		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
 				     priv->bss_mode, sme->channel, sme, 0);
@@ -2513,7 +2513,7 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 		priv->scan_block = false;
 
 	if (!mwifiex_stop_bg_scan(priv))
-		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
 
 	user_scan_cfg = kzalloc(sizeof(*user_scan_cfg), GFP_KERNEL);
 	if (!user_scan_cfg)
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 9d80180..80321d5 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -744,7 +744,7 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter,
 		mwifiex_dbg(priv->adapter, INFO,
 			    "aborting bgscan on ndo_stop\n");
 		mwifiex_stop_bg_scan(priv);
-		cfg80211_sched_scan_stopped(priv->wdev.wiphy);
+		cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index d63d163..000cb39 100644
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
index e7a74e9..1b56496 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4524,24 +4524,26 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
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
index 28a3a09..d37de3f 100644
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
index 3fd8757..94be10e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1239,7 +1239,7 @@ void ieee80211_sched_scan_end(struct ieee80211_local *local)
 
 	mutex_unlock(&local->mtx);
 
-	cfg80211_sched_scan_stopped(local->hw.wiphy);
+	cfg80211_sched_scan_stopped(local->hw.wiphy, 0);
 }
 
 void ieee80211_sched_scan_stopped_work(struct work_struct *work)
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ac59fbd..616d55d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2103,7 +2103,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	mutex_unlock(&local->mtx);
 
 	if (sched_scan_stopped)
-		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
+		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy, 0);
 
  wake_up:
 	if (local->in_reconfig) {
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index a6c8d0e..0c2ba39 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -402,22 +402,22 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy, u64 reqid)
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
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 55558d0..ca8b205 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2820,12 +2820,7 @@
 		  MAC_PR_ARG(tsf_bssid))
 );
 
-DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_stopped,
-	TP_PROTO(struct wiphy *wiphy),
-	TP_ARGS(wiphy)
-);
-
-TRACE_EVENT(cfg80211_sched_scan_results,
+DECLARE_EVENT_CLASS(wiphy_id_evt,
 	TP_PROTO(struct wiphy *wiphy, u64 id),
 	TP_ARGS(wiphy, id),
 	TP_STRUCT__entry(
@@ -2839,6 +2834,16 @@
 	TP_printk(WIPHY_PR_FMT ", id: %llu", WIPHY_PR_ARG, __entry->id)
 );
 
+DEFINE_EVENT(wiphy_id_evt, cfg80211_sched_scan_stopped,
+	TP_PROTO(struct wiphy *wiphy, u64 id),
+	TP_ARGS(wiphy, id)
+);
+
+DEFINE_EVENT(wiphy_id_evt, cfg80211_sched_scan_results,
+	TP_PROTO(struct wiphy *wiphy, u64 id),
+	TP_ARGS(wiphy, id)
+);
+
 TRACE_EVENT(cfg80211_get_bss,
 	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
 		 const u8 *bssid, const u8 *ssid, size_t ssid_len,
-- 
1.9.1
