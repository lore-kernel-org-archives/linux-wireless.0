Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33012 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754998AbcGEOKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 10:10:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 17:10:13 +0300
Message-Id: <1467727813-2196-1-git-send-email-luca@coelho.fi> (sfid-20160705_161038_905722_268A5842)
In-Reply-To: <1467721394-8195-5-git-send-email-luca@coelho.fi>
References: <1467721394-8195-5-git-send-email-luca@coelho.fi>
Subject: [PATCH v2] nl80211: Add info to scan results to support beacon report
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Beacon report radio measurement requires reporting observed BSSs
on the channels specified in the beacon request. If the measurement
mode is set to passive or active, it requires actually performing a
scan (passive or active, accordingly), and reporting the time that
the scan was started and the time each beacon/probe was received
(both in terms of TSF of the BSS of the requesting AP). If the
request mode is table, this information is optional.
In addition, the radio measurement request specifies the channel
dwell time for the measurement.

In order to use scan for beacon report when the mode is active or
passive, add a parameter to scan request that specifies the
channel dwell time, and add scan start time and beacon received time
to scan results information.

Supporting beacon report is required for Multi Band Operation (MBO).

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 17 +++++++--
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  6 +++-
 drivers/net/wireless/ath/wil6210/main.c            | 12 +++++--
 drivers/net/wireless/ath/wil6210/p2p.c             |  6 +++-
 drivers/net/wireless/ath/wil6210/wmi.c             |  8 +++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  6 +++-
 drivers/net/wireless/intersil/orinoco/scan.c       | 12 +++++--
 drivers/net/wireless/marvell/libertas/cfg.c        | 11 ++++--
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      | 12 +++++--
 drivers/net/wireless/marvell/mwifiex/main.c        |  6 +++-
 drivers/net/wireless/marvell/mwifiex/scan.c        | 12 +++++--
 drivers/net/wireless/rndis_wlan.c                  | 10 ++++--
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  | 11 ++++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c  | 12 +++++--
 drivers/staging/wlan-ng/cfg80211.c                 |  5 ++-
 include/net/cfg80211.h                             | 40 ++++++++++++++++++---
 include/uapi/linux/nl80211.h                       | 42 ++++++++++++++++++++++
 net/mac80211/scan.c                                |  9 +++--
 net/wireless/core.c                                |  4 +--
 net/wireless/core.h                                | 12 +++++++
 net/wireless/nl80211.c                             | 27 ++++++++++++++
 net/wireless/scan.c                                | 18 ++++++----
 net/wireless/trace.h                               | 33 ++++++++++++-----
 23 files changed, 279 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4e11ba0..ef5b40e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -859,7 +859,11 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 	struct ath6kl *ar = vif->ar;
 
 	if (vif->scan_req) {
-		cfg80211_scan_done(vif->scan_req, true);
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
+		cfg80211_scan_done(vif->scan_req, &info);
 		vif->scan_req = NULL;
 	}
 
@@ -1069,6 +1073,9 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy,
 void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 {
 	struct ath6kl *ar = vif->ar;
+	struct cfg80211_scan_info info = {
+		.aborted = aborted,
+	};
 	int i;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: status%s\n", __func__,
@@ -1089,7 +1096,7 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 	}
 
 out:
-	cfg80211_scan_done(vif->scan_req, aborted);
+	cfg80211_scan_done(vif->scan_req, &info);
 	vif->scan_req = NULL;
 }
 
@@ -3614,7 +3621,11 @@ void ath6kl_cfg80211_vif_stop(struct ath6kl_vif *vif, bool wmi_ready)
 	}
 
 	if (vif->scan_req) {
-		cfg80211_scan_done(vif->scan_req, true);
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
+		cfg80211_scan_done(vif->scan_req, &info);
 		vif->scan_req = NULL;
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 62bf933..f0e1175 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1369,7 +1369,11 @@ static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
 	mutex_lock(&wil->mutex);
 	started = wil_p2p_stop_discovery(wil);
 	if (started && wil->scan_request) {
-		cfg80211_scan_done(wil->scan_request, 1);
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
+		cfg80211_scan_done(wil->scan_request, &info);
 		wil->scan_request = NULL;
 		wil->radio_wdev = wil->wdev;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 8e31d75..4bc92e5 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -850,10 +850,14 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	mutex_unlock(&wil->wmi_mutex);
 
 	if (wil->scan_request) {
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
 			     wil->scan_request);
 		del_timer_sync(&wil->scan_timer);
-		cfg80211_scan_done(wil->scan_request, true);
+		cfg80211_scan_done(wil->scan_request, &info);
 		wil->scan_request = NULL;
 	}
 
@@ -1049,10 +1053,14 @@ int __wil_down(struct wil6210_priv *wil)
 	(void)wil_p2p_stop_discovery(wil);
 
 	if (wil->scan_request) {
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
 		wil_dbg_misc(wil, "Abort scan_request 0x%p\n",
 			     wil->scan_request);
 		del_timer_sync(&wil->scan_timer);
-		cfg80211_scan_done(wil->scan_request, true);
+		cfg80211_scan_done(wil->scan_request, &info);
 		wil->scan_request = NULL;
 	}
 
diff --git a/drivers/net/wireless/ath/wil6210/p2p.c b/drivers/net/wireless/ath/wil6210/p2p.c
index 213b825..e0f8aa0 100644
--- a/drivers/net/wireless/ath/wil6210/p2p.c
+++ b/drivers/net/wireless/ath/wil6210/p2p.c
@@ -252,8 +252,12 @@ void wil_p2p_search_expired(struct work_struct *work)
 	mutex_unlock(&wil->mutex);
 
 	if (started) {
+		struct cfg80211_scan_info info = {
+			.aborted = false,
+		};
+
 		mutex_lock(&wil->p2p_wdev_mutex);
-		cfg80211_scan_done(wil->scan_request, 0);
+		cfg80211_scan_done(wil->scan_request, &info);
 		wil->scan_request = NULL;
 		wil->radio_wdev = wil->wdev;
 		mutex_unlock(&wil->p2p_wdev_mutex);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index b80c5d8..4d92541 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -426,15 +426,17 @@ static void wmi_evt_scan_complete(struct wil6210_priv *wil, int id,
 {
 	if (wil->scan_request) {
 		struct wmi_scan_complete_event *data = d;
-		bool aborted = (data->status != WMI_SCAN_SUCCESS);
+		struct cfg80211_scan_info info = {
+			.aborted = (data->status != WMI_SCAN_SUCCESS),
+		};
 
 		wil_dbg_wmi(wil, "SCAN_COMPLETE(0x%08x)\n", data->status);
 		wil_dbg_misc(wil, "Complete scan_request 0x%p aborted %d\n",
-			     wil->scan_request, aborted);
+			     wil->scan_request, info.aborted);
 
 		del_timer_sync(&wil->scan_timer);
 		mutex_lock(&wil->p2p_wdev_mutex);
-		cfg80211_scan_done(wil->scan_request, aborted);
+		cfg80211_scan_done(wil->scan_request, &info);
 		wil->radio_wdev = wil->wdev;
 		mutex_unlock(&wil->p2p_wdev_mutex);
 		wil->scan_request = NULL;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 264bd63..afe2b20 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -775,9 +775,13 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		if (!aborted)
 			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
 	} else if (scan_request) {
+		struct cfg80211_scan_info info = {
+			.aborted = aborted,
+		};
+
 		brcmf_dbg(SCAN, "ESCAN Completed scan: %s\n",
 			  aborted ? "Aborted" : "Done");
-		cfg80211_scan_done(scan_request, aborted);
+		cfg80211_scan_done(scan_request, &info);
 	}
 	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status))
 		brcmf_dbg(SCAN, "Scan complete, probably P2P scan\n");
diff --git a/drivers/net/wireless/intersil/orinoco/scan.c b/drivers/net/wireless/intersil/orinoco/scan.c
index d0ceb06..6d1d084 100644
--- a/drivers/net/wireless/intersil/orinoco/scan.c
+++ b/drivers/net/wireless/intersil/orinoco/scan.c
@@ -237,7 +237,11 @@ void orinoco_add_hostscan_results(struct orinoco_private *priv,
 
  scan_abort:
 	if (priv->scan_request) {
-		cfg80211_scan_done(priv->scan_request, abort);
+		struct cfg80211_scan_info info = {
+			.aborted = abort,
+		};
+
+		cfg80211_scan_done(priv->scan_request, &info);
 		priv->scan_request = NULL;
 	}
 }
@@ -245,7 +249,11 @@ void orinoco_add_hostscan_results(struct orinoco_private *priv,
 void orinoco_scan_done(struct orinoco_private *priv, bool abort)
 {
 	if (priv->scan_request) {
-		cfg80211_scan_done(priv->scan_request, abort);
+		struct cfg80211_scan_info info = {
+			.aborted = abort,
+		};
+
+		cfg80211_scan_done(priv->scan_request, &info);
 		priv->scan_request = NULL;
 	}
 }
diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 776b44b..ea48024 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -796,10 +796,15 @@ void lbs_scan_done(struct lbs_private *priv)
 {
 	WARN_ON(!priv->scan_req);
 
-	if (priv->internal_scan)
+	if (priv->internal_scan) {
 		kfree(priv->scan_req);
-	else
-		cfg80211_scan_done(priv->scan_req, false);
+	} else {
+		struct cfg80211_scan_info info = {
+			.aborted = false,
+		};
+
+		cfg80211_scan_done(priv->scan_req, &info);
+	}
 
 	priv->scan_req = NULL;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 6bc2011..e7a2144 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1057,8 +1057,12 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 			if (!priv)
 				continue;
 			if (priv->scan_request) {
+				struct cfg80211_scan_info info = {
+					.aborted = true,
+				};
+
 				mwifiex_dbg(adapter, WARN, "info: aborting scan\n");
-				cfg80211_scan_done(priv->scan_request, 1);
+				cfg80211_scan_done(priv->scan_request, &info);
 				priv->scan_request = NULL;
 			}
 		}
@@ -1112,8 +1116,12 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 			if (!priv)
 				continue;
 			if (priv->scan_request) {
+				struct cfg80211_scan_info info = {
+					.aborted = true,
+				};
+
 				mwifiex_dbg(adapter, WARN, "info: aborting scan\n");
-				cfg80211_scan_done(priv->scan_request, 1);
+				cfg80211_scan_done(priv->scan_request, &info);
 				priv->scan_request = NULL;
 			}
 		}
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 0e280f8..db4925d 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -697,9 +697,13 @@ mwifiex_close(struct net_device *dev)
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (priv->scan_request) {
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
 		mwifiex_dbg(priv->adapter, INFO,
 			    "aborting scan on ndo_stop\n");
-		cfg80211_scan_done(priv->scan_request, 1);
+		cfg80211_scan_done(priv->scan_request, &info);
 		priv->scan_request = NULL;
 		priv->scan_aborting = true;
 	}
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index bc5e52c..fdd7491 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1956,9 +1956,13 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 			mwifiex_complete_scan(priv);
 
 		if (priv->scan_request) {
+			struct cfg80211_scan_info info = {
+				.aborted = false,
+			};
+
 			mwifiex_dbg(adapter, INFO,
 				    "info: notifying scan done\n");
-			cfg80211_scan_done(priv->scan_request, 0);
+			cfg80211_scan_done(priv->scan_request, &info);
 			priv->scan_request = NULL;
 		} else {
 			priv->scan_aborting = false;
@@ -1977,9 +1981,13 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 
 		if (!adapter->active_scan_triggered) {
 			if (priv->scan_request) {
+				struct cfg80211_scan_info info = {
+					.aborted = true,
+				};
+
 				mwifiex_dbg(adapter, INFO,
 					    "info: aborting scan\n");
-				cfg80211_scan_done(priv->scan_request, 1);
+				cfg80211_scan_done(priv->scan_request, &info);
 				priv->scan_request = NULL;
 			} else {
 				priv->scan_aborting = false;
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 569918c..603c904 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2134,6 +2134,7 @@ static void rndis_get_scan_results(struct work_struct *work)
 	struct rndis_wlan_private *priv =
 		container_of(work, struct rndis_wlan_private, scan_work.work);
 	struct usbnet *usbdev = priv->usbdev;
+	struct cfg80211_scan_info info = {};
 	int ret;
 
 	netdev_dbg(usbdev->net, "get_scan_results\n");
@@ -2143,7 +2144,8 @@ static void rndis_get_scan_results(struct work_struct *work)
 
 	ret = rndis_check_bssid_list(usbdev, NULL, NULL);
 
-	cfg80211_scan_done(priv->scan_request, ret < 0);
+	info.aborted = ret < 0;
+	cfg80211_scan_done(priv->scan_request, &info);
 
 	priv->scan_request = NULL;
 }
@@ -3574,7 +3576,11 @@ static int rndis_wlan_stop(struct usbnet *usbdev)
 	flush_workqueue(priv->workqueue);
 
 	if (priv->scan_request) {
-		cfg80211_scan_done(priv->scan_request, true);
+		struct cfg80211_scan_info info = {
+			.aborted = true,
+		};
+
+		cfg80211_scan_done(priv->scan_request, &info);
 		priv->scan_request = NULL;
 	}
 
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 0da559d..d0ba377 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1256,10 +1256,15 @@ void rtw_cfg80211_indicate_scan_done(struct rtw_wdev_priv *pwdev_priv,
 		DBG_8723A("%s with scan req\n", __func__);
 
 		if (pwdev_priv->scan_request->wiphy !=
-		    pwdev_priv->rtw_wdev->wiphy)
+		    pwdev_priv->rtw_wdev->wiphy) {
 			DBG_8723A("error wiphy compare\n");
-		else
-			cfg80211_scan_done(pwdev_priv->scan_request, aborted);
+		} else {
+			struct cfg80211_scan_info info = {
+				.aborted = aborted,
+			};
+
+			cfg80211_scan_done(pwdev_priv->scan_request, &info);
+		}
 
 		pwdev_priv->scan_request = NULL;
 	} else {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 51aff4f..a0d8e22 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -454,7 +454,11 @@ static void CfgScanResult(enum scan_event scan_event,
 			mutex_lock(&priv->scan_req_lock);
 
 			if (priv->pstrScanReq) {
-				cfg80211_scan_done(priv->pstrScanReq, false);
+				struct cfg80211_scan_info info = {
+					.aborted = false,
+				};
+
+				cfg80211_scan_done(priv->pstrScanReq, &info);
 				priv->u32RcvdChCount = 0;
 				priv->bCfgScanning = false;
 				priv->pstrScanReq = NULL;
@@ -464,10 +468,14 @@ static void CfgScanResult(enum scan_event scan_event,
 			mutex_lock(&priv->scan_req_lock);
 
 			if (priv->pstrScanReq) {
+				struct cfg80211_scan_info info = {
+					.aborted = false,
+				};
+
 				update_scan_time();
 				refresh_scan(priv, 1, false);
 
-				cfg80211_scan_done(priv->pstrScanReq, false);
+				cfg80211_scan_done(priv->pstrScanReq, &info);
 				priv->bCfgScanning = false;
 				priv->pstrScanReq = NULL;
 			}
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index a6e6fb9..f46dfe6 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -338,6 +338,8 @@ static int prism2_scan(struct wiphy *wiphy,
 	struct p80211msg_dot11req_scan msg1;
 	struct p80211msg_dot11req_scan_results msg2;
 	struct cfg80211_bss *bss;
+	struct cfg80211_scan_info info = {};
+
 	int result;
 	int err = 0;
 	int numbss = 0;
@@ -440,7 +442,8 @@ static int prism2_scan(struct wiphy *wiphy,
 		err = prism2_result2err(msg2.resultcode.data);
 
 exit:
-	cfg80211_scan_done(request, err ? 1 : 0);
+	info.aborted = !!(err);
+	cfg80211_scan_done(request, &info);
 	priv->scan_request = NULL;
 	return err;
 }
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fa4f0f7..e2658e3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1424,6 +1424,21 @@ struct cfg80211_ssid {
 };
 
 /**
+ * struct cfg80211_scan_info - information about completed scan
+ * @scan_start_tsf: scan start time in terms of the TSF of the BSS that the
+ *	wireless device that requested the scan is connected to. If this
+ *	information is not available, this field is left zero.
+ * @tsf_bssid: the BSSID according to which %scan_start_tsf is set.
+ * @aborted: set to true if the scan was aborted for any reason,
+ *	userspace will be notified of that
+ */
+struct cfg80211_scan_info {
+	u64 scan_start_tsf;
+	u8 tsf_bssid[ETH_ALEN] __aligned(2);
+	bool aborted;
+};
+
+/**
  * struct cfg80211_scan_request - scan request description
  *
  * @ssids: SSIDs to scan for (active scan only)
@@ -1433,12 +1448,17 @@ struct cfg80211_ssid {
  * @scan_width: channel width for scanning
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @duration: how long to listen on each channel, in TUs. If
+ *	%duration_mandatory is not set, this is the maximum dwell time and
+ *	the actual dwell time may be shorter.
+ * @duration_mandatory: if set, the scan duration must be as specified by the
+ *	%duration field.
  * @flags: bit field of flags controlling operation
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
  * @scan_start: time (in jiffies) when the scan started
  * @wdev: the wireless device to scan for
- * @aborted: (internal) scan request was notified as aborted
+ * @info: (internal) information about completed scan
  * @notified: (internal) scan request was notified as done or aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
  * @mac_addr: MAC address used with randomisation
@@ -1454,6 +1474,8 @@ struct cfg80211_scan_request {
 	enum nl80211_bss_scan_width scan_width;
 	const u8 *ie;
 	size_t ie_len;
+	u16 duration;
+	bool duration_mandatory;
 	u32 flags;
 
 	u32 rates[NUM_NL80211_BANDS];
@@ -1467,7 +1489,8 @@ struct cfg80211_scan_request {
 	/* internal */
 	struct wiphy *wiphy;
 	unsigned long scan_start;
-	bool aborted, notified;
+	struct cfg80211_scan_info info;
+	bool notified;
 	bool no_cck;
 
 	/* keep last */
@@ -1600,12 +1623,19 @@ enum cfg80211_signal_type {
  *	buffered on the device) and be accurate to about 10ms.
  *	If the frame isn't buffered, just passing the return value of
  *	ktime_get_boot_ns() is likely appropriate.
+ * @parent_tsf: the time at the start of reception of the first octet of the
+ *	timestamp field of the frame. The time is the TSF of the BSS specified
+ *	by %parent_bssid.
+ * @parent_bssid: the BSS according to which %parent_tsf is set. This is set to
+ *	the BSS that requested the scan in which the beacon/probe was received.
  */
 struct cfg80211_inform_bss {
 	struct ieee80211_channel *chan;
 	enum nl80211_bss_scan_width scan_width;
 	s32 signal;
 	u64 boottime_ns;
+	u64 parent_tsf;
+	u8 parent_bssid[ETH_ALEN] __aligned(2);
 };
 
 /**
@@ -4067,10 +4097,10 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
  * cfg80211_scan_done - notify that scan finished
  *
  * @request: the corresponding scan request
- * @aborted: set to true if the scan was aborted for any reason,
- *	userspace will be notified of that
+ * @info: information about the completed scan
  */
-void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted);
+void cfg80211_scan_done(struct cfg80211_scan_request *request,
+			struct cfg80211_scan_info *info);
 
 /**
  * cfg80211_sched_scan_results - notify that new scan results are available
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1d7da78..b39ccab 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1848,6 +1848,22 @@ enum nl80211_commands {
  *	to turn that feature off set an invalid mac address
  *	(e.g. FF:FF:FF:FF:FF:FF)
  *
+ * @NL80211_ATTR_SCAN_START_TIME_TSF: The time at which the scan was actually
+ *	started (u64). The time is the TSF of the BSS the interface that
+ *	requested the scan is connected to (if available, otherwise this
+ *	attribute must not be included).
+ * @NL80211_ATTR_SCAN_START_TIME_TSF_BSSID: The BSS according to which
+ *	%NL80211_ATTR_SCAN_START_TIME_TSF is set.
+ * @NL80211_ATTR_MEASUREMENT_DURATION: measurement duration in TUs (u16). If
+ *	%NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY is not set, this is the
+ *	maximum measurement duration allowed. This attribute is used with
+ *	measurement requests. It can also be used with %NL80211_CMD_TRIGGER_SCAN
+ *	if the scan is used for beacon report radio measurement.
+ * @NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY: flag attribute that indicates
+ *	that the duration specified with %NL80211_ATTR_MEASUREMENT_DURATION is
+ *	mandatory. If this flag is not set, the duration is the maximum duration
+ *	and the actual measurement duration may be shorter.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2235,6 +2251,11 @@ enum nl80211_attrs {
 	NL80211_ATTR_MU_MIMO_GROUP_DATA,
 	NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR,
 
+	NL80211_ATTR_SCAN_START_TIME_TSF,
+	NL80211_ATTR_SCAN_START_TIME_TSF_BSSID,
+	NL80211_ATTR_MEASUREMENT_DURATION,
+	NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3496,6 +3517,12 @@ enum nl80211_bss_scan_width {
  *	was last updated by a received frame. The value is expected to be
  *	accurate to about 10ms. (u64, nanoseconds)
  * @NL80211_BSS_PAD: attribute used for padding for 64-bit alignment
+ * @NL80211_BSS_PARENT_TSF: the time at the start of reception of the first
+ *	octet of the timestamp field of the last beacon/probe received for
+ *	this BSS. The time is the TSF of the BSS specified by
+ *	@NL80211_BSS_PARENT_BSSID. (u64).
+ * @NL80211_BSS_PARENT_BSSID: the BSS according to which @NL80211_BSS_PARENT_TSF
+ *	is set.
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3517,6 +3544,8 @@ enum nl80211_bss {
 	NL80211_BSS_PRESP_DATA,
 	NL80211_BSS_LAST_SEEN_BOOTTIME,
 	NL80211_BSS_PAD,
+	NL80211_BSS_PARENT_TSF,
+	NL80211_BSS_PARENT_BSSID,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
@@ -4507,6 +4536,16 @@ enum nl80211_feature_flags {
  *	%NL80211_ATTR_MU_MIMO_GROUP_DATA attribute,
  *	or can be configured to follow a station by configuring the
  *	%NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR attribute.
+ * @NL80211_EXT_FEATURE_SCAN_START_TIME: This driver includes the actual
+ *	time the scan started in scan results event. The time is the TSF of
+ *	the BSS that the interface that requested the scan is connected to
+ *	(if available).
+ * @NL80211_EXT_FEATURE_BSS_PARENT_TSF: Per BSS, this driver reports the
+ *	time the last beacon/probe was received. The time is the TSF of the
+ *	BSS that the interface that requested the scan is connected to
+ *	(if available).
+ * @NL80211_EXT_FEATURE_SET_SCAN_DWELL: This driver supports configuration of
+ *	channel dwell time.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4515,6 +4554,9 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_VHT_IBSS,
 	NL80211_EXT_FEATURE_RRM,
 	NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER,
+	NL80211_EXT_FEATURE_SCAN_START_TIME,
+	NL80211_EXT_FEATURE_BSS_PARENT_TSF,
+	NL80211_EXT_FEATURE_SET_SCAN_DWELL,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f9648ef..4ec1c52 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -353,8 +353,13 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	scan_req = rcu_dereference_protected(local->scan_req,
 					     lockdep_is_held(&local->mtx));
 
-	if (scan_req != local->int_scan_req)
-		cfg80211_scan_done(scan_req, aborted);
+	if (scan_req != local->int_scan_req) {
+		struct cfg80211_scan_info info = {
+			.aborted = aborted,
+		};
+
+		cfg80211_scan_done(scan_req, &info);
+	}
 	RCU_INIT_POINTER(local->scan_req, NULL);
 
 	scan_sdata = rcu_dereference_protected(local->scan_sdata,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 39d9abd..7645e97 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -220,7 +220,7 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 
 	if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
 		if (WARN_ON(!rdev->scan_req->notified))
-			rdev->scan_req->aborted = true;
+			rdev->scan_req->info.aborted = true;
 		___cfg80211_scan_done(rdev, false);
 	}
 }
@@ -1087,7 +1087,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
 		if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
 			if (WARN_ON(!rdev->scan_req->notified))
-				rdev->scan_req->aborted = true;
+				rdev->scan_req->info.aborted = true;
 			___cfg80211_scan_done(rdev, false);
 		}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a4d547f..eee9144 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -141,6 +141,18 @@ struct cfg80211_internal_bss {
 	unsigned long refcount;
 	atomic_t hold;
 
+	/* time at the start of the reception of the first octet of the
+	 * timestamp field of the last beacon/probe received for this BSS.
+	 * The time is the TSF of the BSS specified by %parent_bssid.
+	 */
+	u64 parent_tsf;
+
+	/* the BSS according to which %parent_tsf is set. This is set to
+	 * the BSS that the interface that requested the scan was connected to
+	 * when the beacon/probe was received.
+	 */
+	u8 parent_bssid[ETH_ALEN] __aligned(2);
+
 	/* must be last because of priv member */
 	struct cfg80211_bss pub;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 447026f..c53b546 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6223,6 +6223,19 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_MEASUREMENT_DURATION]) {
+		if (!wiphy_ext_feature_isset(wiphy,
+					NL80211_EXT_FEATURE_SET_SCAN_DWELL)) {
+			err = -EOPNOTSUPP;
+			goto out_free;
+		}
+
+		request->duration =
+			nla_get_u16(info->attrs[NL80211_ATTR_MEASUREMENT_DURATION]);
+		request->duration_mandatory =
+			nla_get_flag(info->attrs[NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY]);
+	}
+
 	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
@@ -7056,6 +7069,13 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			jiffies_to_msecs(jiffies - intbss->ts)))
 		goto nla_put_failure;
 
+	if (intbss->parent_tsf &&
+	    (nla_put_u64_64bit(msg, NL80211_BSS_PARENT_TSF,
+			       intbss->parent_tsf, NL80211_BSS_PAD) ||
+	     nla_put(msg, NL80211_BSS_PARENT_BSSID, ETH_ALEN,
+		     intbss->parent_bssid)))
+		goto nla_put_failure;
+
 	if (intbss->ts_boottime &&
 	    nla_put_u64_64bit(msg, NL80211_BSS_LAST_SEEN_BOOTTIME,
 			      intbss->ts_boottime, NL80211_BSS_PAD))
@@ -11829,6 +11849,13 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	    nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags))
 		goto nla_put_failure;
 
+	if (req->info.scan_start_tsf &&
+	    (nla_put_u64_64bit(msg, NL80211_ATTR_SCAN_START_TIME_TSF,
+			       req->info.scan_start_tsf, NL80211_BSS_PAD) ||
+	     nla_put(msg, NL80211_ATTR_SCAN_START_TIME_TSF_BSSID, ETH_ALEN,
+		     req->info.tsf_bssid)))
+		goto nla_put_failure;
+
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ef2955c..0358e12 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2016	Intel Deutschland GmbH
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -194,7 +195,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 	if (wdev->netdev)
 		cfg80211_sme_scan_done(wdev->netdev);
 
-	if (!request->aborted &&
+	if (!request->info.aborted &&
 	    request->flags & NL80211_SCAN_FLAG_FLUSH) {
 		/* flush entries from previous scans */
 		spin_lock_bh(&rdev->bss_lock);
@@ -202,10 +203,10 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 		spin_unlock_bh(&rdev->bss_lock);
 	}
 
-	msg = nl80211_build_scan_msg(rdev, wdev, request->aborted);
+	msg = nl80211_build_scan_msg(rdev, wdev, request->info.aborted);
 
 #ifdef CONFIG_CFG80211_WEXT
-	if (wdev->netdev && !request->aborted) {
+	if (wdev->netdev && !request->info.aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));
 
 		wireless_send_event(wdev->netdev, SIOCGIWSCAN, &wrqu, NULL);
@@ -236,12 +237,13 @@ void __cfg80211_scan_done(struct work_struct *wk)
 	rtnl_unlock();
 }
 
-void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
+void cfg80211_scan_done(struct cfg80211_scan_request *request,
+			struct cfg80211_scan_info *info)
 {
-	trace_cfg80211_scan_done(request, aborted);
+	trace_cfg80211_scan_done(request, info);
 	WARN_ON(request != wiphy_to_rdev(request->wiphy)->scan_req);
 
-	request->aborted = aborted;
+	request->info = *info;
 	request->notified = true;
 	queue_work(cfg80211_wq, &wiphy_to_rdev(request->wiphy)->scan_done_wk);
 }
@@ -843,6 +845,8 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		found->pub.capability = tmp->pub.capability;
 		found->ts = tmp->ts;
 		found->ts_boottime = tmp->ts_boottime;
+		found->parent_tsf = tmp->parent_tsf;
+		ether_addr_copy(found->parent_bssid, tmp->parent_bssid);
 	} else {
 		struct cfg80211_internal_bss *new;
 		struct cfg80211_internal_bss *hidden;
@@ -1086,6 +1090,8 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 	tmp.ts_boottime = data->boottime_ns;
+	tmp.parent_tsf = data->parent_tsf;
+	ether_addr_copy(tmp.parent_bssid, data->parent_bssid);
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 3c1091a..72b5255 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2642,8 +2642,9 @@ TRACE_EVENT(cfg80211_tdls_oper_request,
 	);
 
 TRACE_EVENT(cfg80211_scan_done,
-	TP_PROTO(struct cfg80211_scan_request *request, bool aborted),
-	TP_ARGS(request, aborted),
+	TP_PROTO(struct cfg80211_scan_request *request,
+		 struct cfg80211_scan_info *info),
+	TP_ARGS(request, info),
 	TP_STRUCT__entry(
 		__field(u32, n_channels)
 		__dynamic_array(u8, ie, request ? request->ie_len : 0)
@@ -2652,6 +2653,8 @@ TRACE_EVENT(cfg80211_scan_done,
 		MAC_ENTRY(wiphy_mac)
 		__field(bool, no_cck)
 		__field(bool, aborted)
+		__field(u64, scan_start_tsf)
+		MAC_ENTRY(tsf_bssid)
 	),
 	TP_fast_assign(
 		if (request) {
@@ -2666,9 +2669,16 @@ TRACE_EVENT(cfg80211_scan_done,
 					   request->wiphy->perm_addr);
 			__entry->no_cck = request->no_cck;
 		}
-		__entry->aborted = aborted;
+		if (info) {
+			__entry->aborted = info->aborted;
+			__entry->scan_start_tsf = info->scan_start_tsf;
+			MAC_ASSIGN(tsf_bssid, info->tsf_bssid);
+		}
 	),
-	TP_printk("aborted: %s", BOOL_TO_STR(__entry->aborted))
+	TP_printk("aborted: %s, scan start (TSF): %llu, tsf_bssid: " MAC_PR_FMT,
+		  BOOL_TO_STR(__entry->aborted),
+		  (unsigned long long)__entry->scan_start_tsf,
+		  MAC_PR_ARG(tsf_bssid))
 );
 
 DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_results,
@@ -2721,6 +2731,8 @@ TRACE_EVENT(cfg80211_inform_bss_frame,
 		__dynamic_array(u8, mgmt, len)
 		__field(s32, signal)
 		__field(u64, ts_boottime)
+		__field(u64, parent_tsf)
+		MAC_ENTRY(parent_bssid)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
@@ -2730,10 +2742,15 @@ TRACE_EVENT(cfg80211_inform_bss_frame,
 			memcpy(__get_dynamic_array(mgmt), mgmt, len);
 		__entry->signal = data->signal;
 		__entry->ts_boottime = data->boottime_ns;
-	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT "(scan_width: %d) signal: %d, tsb:%llu",
-		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->scan_width,
-		  __entry->signal, (unsigned long long)__entry->ts_boottime)
+		__entry->parent_tsf = data->parent_tsf;
+		MAC_ASSIGN(parent_bssid, data->parent_bssid);
+	),
+	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT
+		  "(scan_width: %d) signal: %d, tsb:%llu, detect_tsf:%llu, tsf_bssid: "
+		  MAC_PR_FMT, WIPHY_PR_ARG, CHAN_PR_ARG, __entry->scan_width,
+		  __entry->signal, (unsigned long long)__entry->ts_boottime,
+		  (unsigned long long)__entry->parent_tsf,
+		  MAC_PR_ARG(parent_bssid))
 );
 
 DECLARE_EVENT_CLASS(cfg80211_bss_evt,
-- 
2.8.1

