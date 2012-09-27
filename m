Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4925 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab2I0MSS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/11] brcmfmac: rename structure brcmf_cfg80211_priv
Date: Thu, 27 Sep 2012 14:17:55 +0200
Message-ID: <1348748277-21460-10-git-send-email-arend@broadcom.com> (sfid-20120927_141838_839120_525571ED)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Renamed structure to brcmf_cfg80211_info as it is not really a
private structure since it is exposed in header file.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 1193 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   36 +-
 3 files changed, 615 insertions(+), 616 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index eed695a..17e7ae7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -614,7 +614,7 @@ struct brcmf_pub {
 	/* Linkage ponters */
 	struct brcmf_bus *bus_if;
 	struct brcmf_proto *prot;
-	struct brcmf_cfg80211_priv *config;
+	struct brcmf_cfg80211_info *config;
 	struct device *dev;		/* fullmac dongle device pointer */
 
 	/* Internal brcmf items */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 9d8d2eb..1e1637a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -97,10 +97,10 @@ static u32 brcmf_dbg_level = WL_DBG_ERR;
 
 static bool check_sys_up(struct wiphy *wiphy)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	if (!test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	if (!test_bit(WL_STATUS_READY, &cfg->status)) {
 		WL_INFO("device is not ready : status (%d)\n",
-			(int)cfg_priv->status);
+			(int)cfg->status);
 		return false;
 	}
 	return true;
@@ -457,7 +457,7 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 }
 
 static int
-send_key_to_dongle(struct brcmf_cfg80211_priv *cfg_priv, s32 bssidx,
+send_key_to_dongle(struct brcmf_cfg80211_info *cfg, s32 bssidx,
 		   struct net_device *ndev, struct brcmf_wsec_key *key)
 {
 	int err;
@@ -467,7 +467,7 @@ send_key_to_dongle(struct brcmf_cfg80211_priv *cfg_priv, s32 bssidx,
 
 	err  = brcmf_dev_iovar_setbuf_bsscfg(ndev, "wsec_key", &key_le,
 					     sizeof(key_le),
-					     cfg_priv->extra_buf,
+					     cfg->extra_buf,
 					     WL_EXTRA_BUF_MAX, bssidx);
 
 	if (err)
@@ -480,7 +480,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 enum nl80211_iftype type, u32 *flags,
 			 struct vif_params *params)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 infra = 0;
 	s32 ap = 0;
 	s32 err = 0;
@@ -494,15 +494,15 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		       type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
-		cfg_priv->conf->mode = WL_MODE_IBSS;
+		cfg->conf->mode = WL_MODE_IBSS;
 		infra = 0;
 		break;
 	case NL80211_IFTYPE_STATION:
-		cfg_priv->conf->mode = WL_MODE_BSS;
+		cfg->conf->mode = WL_MODE_BSS;
 		infra = 1;
 		break;
 	case NL80211_IFTYPE_AP:
-		cfg_priv->conf->mode = WL_MODE_AP;
+		cfg->conf->mode = WL_MODE_AP;
 		ap = 1;
 		break;
 	default:
@@ -511,11 +511,11 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	if (ap) {
-		set_bit(WL_STATUS_AP_CREATING, &cfg_priv->status);
-		if (!cfg_priv->ap_info)
-			cfg_priv->ap_info = kzalloc(sizeof(*cfg_priv->ap_info),
-						    GFP_KERNEL);
-		if (!cfg_priv->ap_info) {
+		set_bit(WL_STATUS_AP_CREATING, &cfg->status);
+		if (!cfg->ap_info)
+			cfg->ap_info = kzalloc(sizeof(*cfg->ap_info),
+					       GFP_KERNEL);
+		if (!cfg->ap_info) {
 			err = -ENOMEM;
 			goto done;
 		}
@@ -528,7 +528,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			goto done;
 		}
 		WL_INFO("IF Type = %s\n",
-			(cfg_priv->conf->mode == WL_MODE_IBSS) ?
+			(cfg->conf->mode == WL_MODE_IBSS) ?
 			"Adhoc" : "Infra");
 	}
 	ndev->ieee80211_ptr->iftype = type;
@@ -620,7 +620,7 @@ brcmf_dev_intvar_get_bsscfg(struct net_device *ndev, s8 *name, s32 *val,
  * should return the ndev matching bssidx.
  */
 static s32
-brcmf_find_bssidx(struct brcmf_cfg80211_priv *cfg_priv, struct net_device *ndev)
+brcmf_find_bssidx(struct brcmf_cfg80211_info *cfg, struct net_device *ndev)
 {
 	return 0;
 }
@@ -628,9 +628,9 @@ brcmf_find_bssidx(struct brcmf_cfg80211_priv *cfg_priv, struct net_device *ndev)
 static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 {
 	s32 err = 0;
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+	if (test_bit(WL_STATUS_READY, &cfg->status)) {
 		err = brcmf_dev_intvar_set(ndev, "mpc", mpc);
 		if (err) {
 			WL_ERR("fail to set mpc\n");
@@ -716,10 +716,10 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	return err;
 }
 
-static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_do_iscan(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
+	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_ssid ssid;
 	__le32 passive_scan;
 	s32 err = 0;
@@ -729,19 +729,19 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
-	passive_scan = cfg_priv->active_scan ? 0 : cpu_to_le32(1);
-	err = brcmf_exec_dcmd(cfg_to_ndev(cfg_priv), BRCMF_C_SET_PASSIVE_SCAN,
+	passive_scan = cfg->active_scan ? 0 : cpu_to_le32(1);
+	err = brcmf_exec_dcmd(cfg_to_ndev(cfg), BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
 	brcmf_set_mpc(ndev, 0);
-	cfg_priv->iscan_kickstart = true;
+	cfg->iscan_kickstart = true;
 	err = brcmf_run_iscan(iscan, &ssid, BRCMF_SCAN_ACTION_START);
 	if (err) {
 		brcmf_set_mpc(ndev, 1);
-		cfg_priv->iscan_kickstart = false;
+		cfg->iscan_kickstart = false;
 		return err;
 	}
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
@@ -754,27 +754,27 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 		     struct cfg80211_scan_request *request,
 		     struct cfg80211_ssid *this_ssid)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
-	struct brcmf_cfg80211_scan_req *sr = cfg_priv->scan_req_int;
+	struct brcmf_cfg80211_scan_req *sr = cfg->scan_req_int;
 	__le32 passive_scan;
 	bool iscan_req;
 	bool spec_scan;
 	s32 err = 0;
 	u32 SSID_len;
 
-	if (test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
-		WL_ERR("Scanning already : status (%lu)\n", cfg_priv->status);
+	if (test_bit(WL_STATUS_SCANNING, &cfg->status)) {
+		WL_ERR("Scanning already : status (%lu)\n", cfg->status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status)) {
+	if (test_bit(WL_STATUS_SCAN_ABORTING, &cfg->status)) {
 		WL_ERR("Scanning being aborted : status (%lu)\n",
-		       cfg_priv->status);
+		       cfg->status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) {
+	if (test_bit(WL_STATUS_CONNECTING, &cfg->status)) {
 		WL_ERR("Connecting : status (%lu)\n",
-		       cfg_priv->status);
+		       cfg->status);
 		return -EAGAIN;
 	}
 
@@ -783,7 +783,7 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 	if (request) {
 		/* scan bss */
 		ssids = request->ssids;
-		if (cfg_priv->iscan_on && (!ssids || !ssids->ssid_len))
+		if (cfg->iscan_on && (!ssids || !ssids->ssid_len))
 			iscan_req = true;
 	} else {
 		/* scan in ibss */
@@ -791,10 +791,10 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 		ssids = this_ssid;
 	}
 
-	cfg_priv->scan_request = request;
-	set_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	cfg->scan_request = request;
+	set_bit(WL_STATUS_SCANNING, &cfg->status);
 	if (iscan_req) {
-		err = brcmf_do_iscan(cfg_priv);
+		err = brcmf_do_iscan(cfg);
 		if (!err)
 			return err;
 		else
@@ -813,7 +813,7 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 			WL_SCAN("Broadcast scan\n");
 		}
 
-		passive_scan = cfg_priv->active_scan ? 0 : cpu_to_le32(1);
+		passive_scan = cfg->active_scan ? 0 : cpu_to_le32(1);
 		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
 		if (err) {
@@ -838,8 +838,8 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 	return 0;
 
 scan_out:
-	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
-	cfg_priv->scan_request = NULL;
+	clear_bit(WL_STATUS_SCANNING, &cfg->status);
+	cfg->scan_request = NULL;
 	return err;
 }
 
@@ -944,7 +944,7 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 }
 
 static s32
-brcmf_notify_escan_complete(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 			    struct net_device *ndev,
 			    bool aborted, bool fw_abort)
 {
@@ -956,11 +956,11 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_priv *cfg_priv,
 
 	/* clear scan request, because the FW abort can cause a second call */
 	/* to this functon and might cause a double cfg80211_scan_done      */
-	scan_request = cfg_priv->scan_request;
-	cfg_priv->scan_request = NULL;
+	scan_request = cfg->scan_request;
+	cfg->scan_request = NULL;
 
-	if (timer_pending(&cfg_priv->escan_timeout))
-		del_timer_sync(&cfg_priv->escan_timeout);
+	if (timer_pending(&cfg->escan_timeout))
+		del_timer_sync(&cfg->escan_timeout);
 
 	if (fw_abort) {
 		/* Do a scan abort to stop the driver's scan engine */
@@ -986,11 +986,11 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_priv *cfg_priv,
 	 * e-scan can be initiated by scheduled scan
 	 * which takes precedence.
 	 */
-	if (cfg_priv->sched_escan) {
+	if (cfg->sched_escan) {
 		WL_SCAN("scheduled scan completed\n");
-		cfg_priv->sched_escan = false;
+		cfg->sched_escan = false;
 		if (!aborted)
-			cfg80211_sched_scan_results(cfg_to_wiphy(cfg_priv));
+			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
 		brcmf_set_mpc(ndev, 1);
 	} else if (scan_request) {
 		WL_SCAN("ESCAN Completed scan: %s\n",
@@ -998,7 +998,7 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_priv *cfg_priv,
 		cfg80211_scan_done(scan_request, aborted);
 		brcmf_set_mpc(ndev, 1);
 	}
-	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg->status)) {
 		WL_ERR("Scan complete while device not scanning\n");
 		return -EPERM;
 	}
@@ -1007,7 +1007,7 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_priv *cfg_priv,
 }
 
 static s32
-brcmf_run_escan(struct brcmf_cfg80211_priv *cfg_priv, struct net_device *ndev,
+brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
 		struct cfg80211_scan_request *request, u16 action)
 {
 	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
@@ -1037,7 +1037,7 @@ brcmf_run_escan(struct brcmf_cfg80211_priv *cfg_priv, struct net_device *ndev,
 	params->sync_id = cpu_to_le16(0x1234);
 
 	err = brcmf_dev_iovar_setbuf(ndev, "escan", params, params_size,
-			cfg_priv->escan_ioctl_buf, BRCMF_DCMD_MEDLEN);
+			cfg->escan_ioctl_buf, BRCMF_DCMD_MEDLEN);
 	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : escan canceled\n");
@@ -1051,7 +1051,7 @@ exit:
 }
 
 static s32
-brcmf_do_escan(struct brcmf_cfg80211_priv *cfg_priv, struct wiphy *wiphy,
+brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	       struct net_device *ndev, struct cfg80211_scan_request *request)
 {
 	s32 err;
@@ -1059,10 +1059,10 @@ brcmf_do_escan(struct brcmf_cfg80211_priv *cfg_priv, struct wiphy *wiphy,
 	struct brcmf_scan_results *results;
 
 	WL_SCAN("Enter\n");
-	cfg_priv->escan_info.ndev = ndev;
-	cfg_priv->escan_info.wiphy = wiphy;
-	cfg_priv->escan_info.escan_state = WL_ESCAN_STATE_SCANNING;
-	passive_scan = cfg_priv->active_scan ? 0 : cpu_to_le32(1);
+	cfg->escan_info.ndev = ndev;
+	cfg->escan_info.wiphy = wiphy;
+	cfg->escan_info.escan_state = WL_ESCAN_STATE_SCANNING;
+	passive_scan = cfg->active_scan ? 0 : cpu_to_le32(1);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (err) {
@@ -1070,12 +1070,12 @@ brcmf_do_escan(struct brcmf_cfg80211_priv *cfg_priv, struct wiphy *wiphy,
 		return err;
 	}
 	brcmf_set_mpc(ndev, 0);
-	results = (struct brcmf_scan_results *)cfg_priv->escan_info.escan_buf;
+	results = (struct brcmf_scan_results *)cfg->escan_info.escan_buf;
 	results->version = 0;
 	results->count = 0;
 	results->buflen = WL_ESCAN_RESULTS_FIXED_SIZE;
 
-	err = brcmf_run_escan(cfg_priv, ndev, request, WL_ESCAN_ACTION_START);
+	err = brcmf_run_escan(cfg, ndev, request, WL_ESCAN_ACTION_START);
 	if (err)
 		brcmf_set_mpc(ndev, 1);
 	return err;
@@ -1086,9 +1086,9 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 		     struct cfg80211_scan_request *request,
 		     struct cfg80211_ssid *this_ssid)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
-	struct brcmf_cfg80211_scan_req *sr = cfg_priv->scan_req_int;
+	struct brcmf_cfg80211_scan_req *sr = cfg->scan_req_int;
 	__le32 passive_scan;
 	bool escan_req;
 	bool spec_scan;
@@ -1097,23 +1097,23 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 
 	WL_SCAN("START ESCAN\n");
 
-	if (test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
-		WL_ERR("Scanning already : status (%lu)\n", cfg_priv->status);
+	if (test_bit(WL_STATUS_SCANNING, &cfg->status)) {
+		WL_ERR("Scanning already : status (%lu)\n", cfg->status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status)) {
+	if (test_bit(WL_STATUS_SCAN_ABORTING, &cfg->status)) {
 		WL_ERR("Scanning being aborted : status (%lu)\n",
-		       cfg_priv->status);
+		       cfg->status);
 		return -EAGAIN;
 	}
-	if (test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) {
+	if (test_bit(WL_STATUS_CONNECTING, &cfg->status)) {
 		WL_ERR("Connecting : status (%lu)\n",
-		       cfg_priv->status);
+		       cfg->status);
 		return -EAGAIN;
 	}
 
 	/* Arm scan timeout timer */
-	mod_timer(&cfg_priv->escan_timeout, jiffies +
+	mod_timer(&cfg->escan_timeout, jiffies +
 			WL_ESCAN_TIMER_INTERVAL_MS * HZ / 1000);
 
 	escan_req = false;
@@ -1127,10 +1127,10 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 		ssids = this_ssid;
 	}
 
-	cfg_priv->scan_request = request;
-	set_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+	cfg->scan_request = request;
+	set_bit(WL_STATUS_SCANNING, &cfg->status);
 	if (escan_req) {
-		err = brcmf_do_escan(cfg_priv, wiphy, ndev, request);
+		err = brcmf_do_escan(cfg, wiphy, ndev, request);
 		if (!err)
 			return err;
 		else
@@ -1149,7 +1149,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 		} else
 			WL_SCAN("Broadcast scan\n");
 
-		passive_scan = cfg_priv->active_scan ? 0 : cpu_to_le32(1);
+		passive_scan = cfg->active_scan ? 0 : cpu_to_le32(1);
 		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
 		if (err) {
@@ -1174,10 +1174,10 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	return 0;
 
 scan_out:
-	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
-	if (timer_pending(&cfg_priv->escan_timeout))
-		del_timer_sync(&cfg_priv->escan_timeout);
-	cfg_priv->scan_request = NULL;
+	clear_bit(WL_STATUS_SCANNING, &cfg->status);
+	if (timer_pending(&cfg->escan_timeout))
+		del_timer_sync(&cfg->escan_timeout);
+	cfg->scan_request = NULL;
 	return err;
 }
 
@@ -1186,7 +1186,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy,
 		 struct cfg80211_scan_request *request)
 {
 	struct net_device *ndev = request->wdev->netdev;
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -1194,9 +1194,9 @@ brcmf_cfg80211_scan(struct wiphy *wiphy,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	if (cfg_priv->iscan_on)
+	if (cfg->iscan_on)
 		err = brcmf_cfg80211_iscan(wiphy, ndev, request, NULL);
-	else if (cfg_priv->escan_on)
+	else if (cfg->escan_on)
 		err = brcmf_cfg80211_escan(wiphy, ndev, request, NULL);
 
 	if (err)
@@ -1243,8 +1243,8 @@ static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 
 static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -1252,30 +1252,30 @@ static s32 brcmf_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 		return -EIO;
 
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD &&
-	    (cfg_priv->conf->rts_threshold != wiphy->rts_threshold)) {
-		cfg_priv->conf->rts_threshold = wiphy->rts_threshold;
-		err = brcmf_set_rts(ndev, cfg_priv->conf->rts_threshold);
+	    (cfg->conf->rts_threshold != wiphy->rts_threshold)) {
+		cfg->conf->rts_threshold = wiphy->rts_threshold;
+		err = brcmf_set_rts(ndev, cfg->conf->rts_threshold);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD &&
-	    (cfg_priv->conf->frag_threshold != wiphy->frag_threshold)) {
-		cfg_priv->conf->frag_threshold = wiphy->frag_threshold;
-		err = brcmf_set_frag(ndev, cfg_priv->conf->frag_threshold);
+	    (cfg->conf->frag_threshold != wiphy->frag_threshold)) {
+		cfg->conf->frag_threshold = wiphy->frag_threshold;
+		err = brcmf_set_frag(ndev, cfg->conf->frag_threshold);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_RETRY_LONG
-	    && (cfg_priv->conf->retry_long != wiphy->retry_long)) {
-		cfg_priv->conf->retry_long = wiphy->retry_long;
-		err = brcmf_set_retry(ndev, cfg_priv->conf->retry_long, true);
+	    && (cfg->conf->retry_long != wiphy->retry_long)) {
+		cfg->conf->retry_long = wiphy->retry_long;
+		err = brcmf_set_retry(ndev, cfg->conf->retry_long, true);
 		if (!err)
 			goto done;
 	}
 	if (changed & WIPHY_PARAM_RETRY_SHORT
-	    && (cfg_priv->conf->retry_short != wiphy->retry_short)) {
-		cfg_priv->conf->retry_short = wiphy->retry_short;
-		err = brcmf_set_retry(ndev, cfg_priv->conf->retry_short, false);
+	    && (cfg->conf->retry_short != wiphy->retry_short)) {
+		cfg->conf->retry_short = wiphy->retry_short;
+		err = brcmf_set_retry(ndev, cfg->conf->retry_short, false);
 		if (!err)
 			goto done;
 	}
@@ -1285,22 +1285,22 @@ done:
 	return err;
 }
 
-static void *brcmf_read_prof(struct brcmf_cfg80211_priv *cfg_priv, s32 item)
+static void *brcmf_read_prof(struct brcmf_cfg80211_info *cfg, s32 item)
 {
 	switch (item) {
 	case WL_PROF_SEC:
-		return &cfg_priv->profile->sec;
+		return &cfg->profile->sec;
 	case WL_PROF_BSSID:
-		return &cfg_priv->profile->bssid;
+		return &cfg->profile->bssid;
 	case WL_PROF_SSID:
-		return &cfg_priv->profile->ssid;
+		return &cfg->profile->ssid;
 	}
 	WL_ERR("invalid item (%d)\n", item);
 	return NULL;
 }
 
 static s32
-brcmf_update_prof(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_update_prof(struct brcmf_cfg80211_info *cfg,
 		  const struct brcmf_event_msg *e, void *data, s32 item)
 {
 	s32 err = 0;
@@ -1309,27 +1309,27 @@ brcmf_update_prof(struct brcmf_cfg80211_priv *cfg_priv,
 	switch (item) {
 	case WL_PROF_SSID:
 		ssid = (struct brcmf_ssid *) data;
-		memset(cfg_priv->profile->ssid.SSID, 0,
-		       sizeof(cfg_priv->profile->ssid.SSID));
-		memcpy(cfg_priv->profile->ssid.SSID,
+		memset(cfg->profile->ssid.SSID, 0,
+		       sizeof(cfg->profile->ssid.SSID));
+		memcpy(cfg->profile->ssid.SSID,
 		       ssid->SSID, ssid->SSID_len);
-		cfg_priv->profile->ssid.SSID_len = ssid->SSID_len;
+		cfg->profile->ssid.SSID_len = ssid->SSID_len;
 		break;
 	case WL_PROF_BSSID:
 		if (data)
-			memcpy(cfg_priv->profile->bssid, data, ETH_ALEN);
+			memcpy(cfg->profile->bssid, data, ETH_ALEN);
 		else
-			memset(cfg_priv->profile->bssid, 0, ETH_ALEN);
+			memset(cfg->profile->bssid, 0, ETH_ALEN);
 		break;
 	case WL_PROF_SEC:
-		memcpy(&cfg_priv->profile->sec, data,
-		       sizeof(cfg_priv->profile->sec));
+		memcpy(&cfg->profile->sec, data,
+		       sizeof(cfg->profile->sec));
 		break;
 	case WL_PROF_BEACONINT:
-		cfg_priv->profile->beacon_interval = *(u16 *)data;
+		cfg->profile->beacon_interval = *(u16 *)data;
 		break;
 	case WL_PROF_DTIMPERIOD:
-		cfg_priv->profile->dtim_period = *(u8 *)data;
+		cfg->profile->dtim_period = *(u8 *)data;
 		break;
 	default:
 		WL_ERR("unsupported item (%d)\n", item);
@@ -1372,20 +1372,20 @@ static void brcmf_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 	}
 }
 
-static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_link_down(struct brcmf_cfg80211_info *cfg)
 {
 	struct net_device *ndev = NULL;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
-	if (cfg_priv->link_up) {
-		ndev = cfg_to_ndev(cfg_priv);
+	if (cfg->link_up) {
+		ndev = cfg_to_ndev(cfg);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
 		err = brcmf_exec_dcmd(ndev, BRCMF_C_DISASSOC, NULL, 0);
 		if (err)
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
-		cfg_priv->link_up = false;
+		cfg->link_up = false;
 	}
 	WL_TRACE("Exit\n");
 }
@@ -1394,7 +1394,7 @@ static s32
 brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_ibss_params *params)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_join_params join_params;
 	size_t join_params_size = 0;
 	s32 err = 0;
@@ -1413,7 +1413,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		return -EOPNOTSUPP;
 	}
 
-	set_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+	set_bit(WL_STATUS_CONNECTING, &cfg->status);
 
 	if (params->bssid)
 		WL_CONN("BSSID: %pM\n", params->bssid);
@@ -1481,7 +1481,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	memcpy(join_params.ssid_le.SSID, params->ssid, ssid.SSID_len);
 	join_params.ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
 	join_params_size = sizeof(join_params.ssid_le);
-	brcmf_update_prof(cfg_priv, NULL, &ssid, WL_PROF_SSID);
+	brcmf_update_prof(cfg, NULL, &ssid, WL_PROF_SSID);
 
 	/* BSSID */
 	if (params->bssid) {
@@ -1492,24 +1492,24 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		memcpy(join_params.params_le.bssid, ether_bcast, ETH_ALEN);
 	}
 
-	brcmf_update_prof(cfg_priv, NULL,
+	brcmf_update_prof(cfg, NULL,
 			  &join_params.params_le.bssid, WL_PROF_BSSID);
 
 	/* Channel */
 	if (params->channel) {
 		u32 target_channel;
 
-		cfg_priv->channel =
+		cfg->channel =
 			ieee80211_frequency_to_channel(
 				params->channel->center_freq);
 		if (params->channel_fixed) {
 			/* adding chanspec */
-			brcmf_ch_to_chanspec(cfg_priv->channel,
+			brcmf_ch_to_chanspec(cfg->channel,
 				&join_params, &join_params_size);
 		}
 
 		/* set channel for starter */
-		target_channel = cfg_priv->channel;
+		target_channel = cfg->channel;
 		err = brcmf_exec_dcmd_u32(ndev, BRCM_SET_CHANNEL,
 					  &target_channel);
 		if (err) {
@@ -1517,9 +1517,9 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 			goto done;
 		}
 	} else
-		cfg_priv->channel = 0;
+		cfg->channel = 0;
 
-	cfg_priv->ibss_starter = false;
+	cfg->ibss_starter = false;
 
 
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SSID,
@@ -1531,7 +1531,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 done:
 	if (err)
-		clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+		clear_bit(WL_STATUS_CONNECTING, &cfg->status);
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -1539,14 +1539,14 @@ done:
 static s32
 brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	brcmf_link_down(cfg_priv);
+	brcmf_link_down(cfg);
 
 	WL_TRACE("Exit\n");
 
@@ -1556,7 +1556,7 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 static s32 brcmf_set_wpa_version(struct net_device *ndev,
 				 struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1573,7 +1573,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
 	}
-	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
 	sec->wpa_versions = sme->crypto.wpa_versions;
 	return err;
 }
@@ -1581,7 +1581,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 static s32 brcmf_set_auth_type(struct net_device *ndev,
 			       struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1612,7 +1612,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		WL_ERR("set auth failed (%d)\n", err);
 		return err;
 	}
-	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
 	sec->auth_type = sme->auth_type;
 	return err;
 }
@@ -1621,7 +1621,7 @@ static s32
 brcmf_set_set_cipher(struct net_device *ndev,
 		     struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
@@ -1677,7 +1677,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 		return err;
 	}
 
-	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
 	sec->cipher_pairwise = sme->crypto.ciphers_pairwise[0];
 	sec->cipher_group = sme->crypto.cipher_group;
 
@@ -1687,7 +1687,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 static s32
 brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1733,7 +1733,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			return err;
 		}
 	}
-	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
 	sec->wpa_auth = sme->crypto.akm_suites[0];
 
 	return err;
@@ -1743,7 +1743,7 @@ static s32
 brcmf_set_sharedkey(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
 	s32 val;
@@ -1755,7 +1755,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	if (sme->key_len == 0)
 		return 0;
 
-	sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
+	sec = brcmf_read_prof(cfg, WL_PROF_SEC);
 	WL_CONN("wpa_versions 0x%x cipher_pairwise 0x%x\n",
 		sec->wpa_versions, sec->cipher_pairwise);
 
@@ -1791,8 +1791,8 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	WL_CONN("key length (%d) key index (%d) algo (%d)\n",
 		key.len, key.index, key.algo);
 	WL_CONN("key \"%s\"\n", key.data);
-	bssidx = brcmf_find_bssidx(cfg_priv, ndev);
-	err = send_key_to_dongle(cfg_priv, bssidx, ndev, &key);
+	bssidx = brcmf_find_bssidx(cfg, ndev);
+	err = send_key_to_dongle(cfg, bssidx, ndev, &key);
 	if (err)
 		return err;
 
@@ -1810,7 +1810,7 @@ static s32
 brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct ieee80211_channel *chan = sme->channel;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
@@ -1827,15 +1827,15 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EOPNOTSUPP;
 	}
 
-	set_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+	set_bit(WL_STATUS_CONNECTING, &cfg->status);
 
 	if (chan) {
-		cfg_priv->channel =
+		cfg->channel =
 			ieee80211_frequency_to_channel(chan->center_freq);
 		WL_CONN("channel (%d), center_req (%d)\n",
-				cfg_priv->channel, chan->center_freq);
+				cfg->channel, chan->center_freq);
 	} else
-		cfg_priv->channel = 0;
+		cfg->channel = 0;
 
 	WL_INFO("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 
@@ -1876,7 +1876,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	memcpy(&join_params.ssid_le.SSID, sme->ssid, ssid.SSID_len);
 	memcpy(&ssid.SSID, sme->ssid, ssid.SSID_len);
 	join_params.ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
-	brcmf_update_prof(cfg_priv, NULL, &ssid, WL_PROF_SSID);
+	brcmf_update_prof(cfg, NULL, &ssid, WL_PROF_SSID);
 
 	memcpy(join_params.params_le.bssid, ether_bcast, ETH_ALEN);
 
@@ -1884,7 +1884,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		WL_CONN("ssid \"%s\", len (%d)\n",
 		       ssid.SSID, ssid.SSID_len);
 
-	brcmf_ch_to_chanspec(cfg_priv->channel,
+	brcmf_ch_to_chanspec(cfg->channel,
 			     &join_params, &join_params_size);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
@@ -1893,7 +1893,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 done:
 	if (err)
-		clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+		clear_bit(WL_STATUS_CONNECTING, &cfg->status);
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -1902,7 +1902,7 @@ static s32
 brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		       u16 reason_code)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_scb_val_le scbval;
 	s32 err = 0;
 
@@ -1910,16 +1910,16 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	clear_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
+	clear_bit(WL_STATUS_CONNECTED, &cfg->status);
 
-	memcpy(&scbval.ea, brcmf_read_prof(cfg_priv, WL_PROF_BSSID), ETH_ALEN);
+	memcpy(&scbval.ea, brcmf_read_prof(cfg, WL_PROF_BSSID), ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_DISASSOC, &scbval,
 			      sizeof(struct brcmf_scb_val_le));
 	if (err)
 		WL_ERR("error (%d)\n", err);
 
-	cfg_priv->link_up = false;
+	cfg->link_up = false;
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -1930,8 +1930,8 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 			    enum nl80211_tx_power_setting type, s32 mbm)
 {
 
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg);
 	u16 txpwrmw;
 	s32 err = 0;
 	s32 disable = 0;
@@ -1967,7 +1967,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 			(s32) (brcmf_mw_to_qdbm(txpwrmw)));
 	if (err)
 		WL_ERR("qtxpower error (%d)\n", err);
-	cfg_priv->conf->tx_power = dbm;
+	cfg->conf->tx_power = dbm;
 
 done:
 	WL_TRACE("Exit\n");
@@ -1976,8 +1976,8 @@ done:
 
 static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg);
 	s32 txpwrdbm;
 	u8 result;
 	s32 err = 0;
@@ -2004,7 +2004,7 @@ static s32
 brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 			       u8 key_idx, bool unicast, bool multicast)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	u32 index;
 	u32 wsec;
 	s32 err = 0;
@@ -2015,7 +2015,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	bssidx = brcmf_find_bssidx(cfg_priv, ndev);
+	bssidx = brcmf_find_bssidx(cfg, ndev);
 	err = brcmf_dev_intvar_get_bsscfg(ndev, "wsec", &wsec, bssidx);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
@@ -2039,7 +2039,7 @@ static s32
 brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 	      u8 key_idx, const u8 *mac_addr, struct key_params *params)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_wsec_key key;
 	struct brcmf_wsec_key_le key_le;
 	s32 err = 0;
@@ -2052,11 +2052,11 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 	if (!is_multicast_ether_addr(mac_addr))
 		memcpy((char *)&key.ea, (void *)mac_addr, ETH_ALEN);
 	key.len = (u32) params->key_len;
-	bssidx = brcmf_find_bssidx(cfg_priv, ndev);
+	bssidx = brcmf_find_bssidx(cfg, ndev);
 	/* check for key index change */
 	if (key.len == 0) {
 		/* key delete */
-		err = send_key_to_dongle(cfg_priv, bssidx, ndev, &key);
+		err = send_key_to_dongle(cfg, bssidx, ndev, &key);
 		if (err)
 			WL_ERR("key delete error (%d)\n", err);
 	} else {
@@ -2116,7 +2116,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_netdev_wait_pend8021x(ndev);
 		err  = brcmf_dev_iovar_setbuf_bsscfg(ndev, "wsec_key", &key_le,
 						     sizeof(key_le),
-						     cfg_priv->extra_buf,
+						     cfg->extra_buf,
 						     WL_EXTRA_BUF_MAX, bssidx);
 		if (err)
 			WL_ERR("wsec_key error (%d)\n", err);
@@ -2129,7 +2129,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr,
 		    struct key_params *params)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_wsec_key key;
 	s32 val;
 	s32 wsec;
@@ -2171,7 +2171,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		WL_CONN("WLAN_CIPHER_SUITE_WEP104\n");
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		if (cfg_priv->conf->mode != WL_MODE_AP) {
+		if (cfg->conf->mode != WL_MODE_AP) {
 			WL_CONN("Swapping key\n");
 			memcpy(keybuf, &key.data[24], sizeof(keybuf));
 			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
@@ -2197,8 +2197,8 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	bssidx = brcmf_find_bssidx(cfg_priv, ndev);
-	err = send_key_to_dongle(cfg_priv, bssidx, ndev, &key);
+	bssidx = brcmf_find_bssidx(cfg, ndev);
+	err = send_key_to_dongle(cfg, bssidx, ndev, &key);
 	if (err)
 		goto done;
 
@@ -2223,7 +2223,7 @@ static s32
 brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 		    u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_wsec_key key;
 	s32 err = 0;
 	s32 bssidx;
@@ -2241,8 +2241,8 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	WL_CONN("key index (%d)\n", key_idx);
 
 	/* Set the new key/index */
-	bssidx = brcmf_find_bssidx(cfg_priv, ndev);
-	err = send_key_to_dongle(cfg_priv, bssidx, ndev, &key);
+	bssidx = brcmf_find_bssidx(cfg, ndev);
+	err = send_key_to_dongle(cfg, bssidx, ndev, &key);
 	if (err) {
 		if (err == -EINVAL) {
 			if (key.index >= DOT11_MAX_DEFAULT_KEYS)
@@ -2263,7 +2263,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 		    void (*callback) (void *cookie, struct key_params * params))
 {
 	struct key_params params;
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
 	s32 err = 0;
@@ -2276,7 +2276,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	memset(&params, 0, sizeof(params));
 
-	bssidx = brcmf_find_bssidx(cfg_priv, ndev);
+	bssidx = brcmf_find_bssidx(cfg, ndev);
 	err = brcmf_dev_intvar_get_bsscfg(ndev, "wsec", &wsec, bssidx);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
@@ -2286,7 +2286,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	}
 	switch (wsec & ~SES_OW_ENABLED) {
 	case WEP_ENABLED:
-		sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
+		sec = brcmf_read_prof(cfg, WL_PROF_SEC);
 		if (sec->cipher_pairwise & WLAN_CIPHER_SUITE_WEP40) {
 			params.cipher = WLAN_CIPHER_SUITE_WEP40;
 			WL_CONN("WLAN_CIPHER_SUITE_WEP40\n");
@@ -2328,27 +2328,27 @@ static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   u8 *mac, struct station_info *sinfo)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_scb_val_le scb_val;
 	int rssi;
 	s32 rate;
 	s32 err = 0;
-	u8 *bssid = brcmf_read_prof(cfg_priv, WL_PROF_BSSID);
+	u8 *bssid = brcmf_read_prof(cfg, WL_PROF_BSSID);
 	struct brcmf_sta_info_le *sta_info_le;
 
 	WL_TRACE("Enter, MAC %pM\n", mac);
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	if (cfg_priv->conf->mode == WL_MODE_AP) {
+	if (cfg->conf->mode == WL_MODE_AP) {
 		err = brcmf_dev_iovar_getbuf(ndev, "sta_info", mac, ETH_ALEN,
-					     cfg_priv->dcmd_buf,
+					     cfg->dcmd_buf,
 					     WL_DCMD_LEN_MAX);
 		if (err < 0) {
 			WL_ERR("GET STA INFO failed, %d\n", err);
 			goto done;
 		}
-		sta_info_le = (struct brcmf_sta_info_le *)cfg_priv->dcmd_buf;
+		sta_info_le = (struct brcmf_sta_info_le *)cfg->dcmd_buf;
 
 		sinfo->filled = STATION_INFO_INACTIVE_TIME;
 		sinfo->inactive_time = le32_to_cpu(sta_info_le->idle) * 1000;
@@ -2358,7 +2358,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 		}
 		WL_TRACE("STA idle time : %d ms, connected time :%d sec\n",
 			 sinfo->inactive_time, sinfo->connected_time);
-	} else if (cfg_priv->conf->mode == WL_MODE_BSS) {
+	} else if (cfg->conf->mode == WL_MODE_BSS) {
 		if (memcmp(mac, bssid, ETH_ALEN)) {
 			WL_ERR("Wrong Mac address cfg_mac-%pM wl_bssid-%pM\n",
 			       mac, bssid);
@@ -2376,7 +2376,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			WL_CONN("Rate %d Mbps\n", rate / 2);
 		}
 
-		if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status)) {
+		if (test_bit(WL_STATUS_CONNECTED, &cfg->status)) {
 			memset(&scb_val, 0, sizeof(scb_val));
 			err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_RSSI, &scb_val,
 					      sizeof(scb_val));
@@ -2403,7 +2403,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 {
 	s32 pm;
 	s32 err = 0;
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 
 	WL_TRACE("Enter\n");
 
@@ -2411,14 +2411,13 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	 * Powersave enable/disable request is coming from the
 	 * cfg80211 even before the interface is up. In that
 	 * scenario, driver will be storing the power save
-	 * preference in cfg_priv struct to apply this to
+	 * preference in cfg struct to apply this to
 	 * FW later while initializing the dongle
 	 */
-	cfg_priv->pwr_save = enabled;
-	if (!test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+	cfg->pwr_save = enabled;
+	if (!test_bit(WL_STATUS_READY, &cfg->status)) {
 
-		WL_INFO("Device is not ready,"
-			"storing the value in cfg_priv struct\n");
+		WL_INFO("Device is not ready, storing the value in cfg_info struct\n");
 		goto done;
 	}
 
@@ -2496,10 +2495,10 @@ done:
 	return err;
 }
 
-static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
+static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 				   struct brcmf_bss_info_le *bi)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
+	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct ieee80211_channel *notify_channel;
 	struct cfg80211_bss *bss;
 	struct ieee80211_supported_band *band;
@@ -2563,14 +2562,14 @@ next_bss_le(struct brcmf_scan_results *list, struct brcmf_bss_info_le *bss)
 					    le32_to_cpu(bss->length));
 }
 
-static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_scan_results *bss_list;
 	struct brcmf_bss_info_le *bi = NULL;	/* must be initialized */
 	s32 err = 0;
 	int i;
 
-	bss_list = cfg_priv->bss_list;
+	bss_list = cfg->bss_list;
 	if (bss_list->version != BRCMF_BSS_INFO_VERSION) {
 		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
 		       bss_list->version);
@@ -2579,17 +2578,17 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_priv *cfg_priv)
 	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
 	for (i = 0; i < bss_list->count && i < WL_AP_MAX; i++) {
 		bi = next_bss_le(bss_list, bi);
-		err = brcmf_inform_single_bss(cfg_priv, bi);
+		err = brcmf_inform_single_bss(cfg, bi);
 		if (err)
 			break;
 	}
 	return err;
 }
 
-static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
+static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 			  struct net_device *ndev, const u8 *bssid)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
+	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct ieee80211_channel *notify_channel;
 	struct brcmf_bss_info_le *bi = NULL;
 	struct ieee80211_supported_band *band;
@@ -2664,9 +2663,9 @@ CleanUp:
 	return err;
 }
 
-static bool brcmf_is_ibssmode(struct brcmf_cfg80211_priv *cfg_priv)
+static bool brcmf_is_ibssmode(struct brcmf_cfg80211_info *cfg)
 {
-	return cfg_priv->conf->mode == WL_MODE_IBSS;
+	return cfg->conf->mode == WL_MODE_IBSS;
 }
 
 /*
@@ -2736,7 +2735,7 @@ brcmf_find_wpaie(u8 *parse, u32 len)
 	return NULL;
 }
 
-static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_bss_info_le *bi;
 	struct brcmf_ssid *ssid;
@@ -2748,21 +2747,21 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	if (brcmf_is_ibssmode(cfg_priv))
+	if (brcmf_is_ibssmode(cfg))
 		return err;
 
-	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg_priv, WL_PROF_SSID);
+	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg, WL_PROF_SSID);
 
-	*(__le32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = brcmf_exec_dcmd(cfg_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
-			cfg_priv->extra_buf, WL_EXTRA_BUF_MAX);
+	*(__le32 *)cfg->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
+	err = brcmf_exec_dcmd(cfg_to_ndev(cfg), BRCMF_C_GET_BSS_INFO,
+			cfg->extra_buf, WL_EXTRA_BUF_MAX);
 	if (err) {
 		WL_ERR("Could not get bss info %d\n", err);
 		goto update_bss_info_out;
 	}
 
-	bi = (struct brcmf_bss_info_le *)(cfg_priv->extra_buf + 4);
-	err = brcmf_inform_single_bss(cfg_priv, bi);
+	bi = (struct brcmf_bss_info_le *)(cfg->extra_buf + 4);
+	err = brcmf_inform_single_bss(cfg, bi);
 	if (err)
 		goto update_bss_info_out;
 
@@ -2780,7 +2779,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 		* so we speficially query dtim information to dongle.
 		*/
 		u32 var;
-		err = brcmf_dev_intvar_get(cfg_to_ndev(cfg_priv),
+		err = brcmf_dev_intvar_get(cfg_to_ndev(cfg),
 					   "dtim_assoc", &var);
 		if (err) {
 			WL_ERR("wl dtim_assoc failed (%d)\n", err);
@@ -2789,22 +2788,22 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 		dtim_period = (u8)var;
 	}
 
-	brcmf_update_prof(cfg_priv, NULL, &beacon_interval, WL_PROF_BEACONINT);
-	brcmf_update_prof(cfg_priv, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
+	brcmf_update_prof(cfg, NULL, &beacon_interval, WL_PROF_BEACONINT);
+	brcmf_update_prof(cfg, NULL, &dtim_period, WL_PROF_DTIMPERIOD);
 
 update_bss_info_out:
 	WL_TRACE("Exit");
 	return err;
 }
 
-static void brcmf_abort_scanning(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
-	struct escan_info *escan = &cfg_priv->escan_info;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
+	struct escan_info *escan = &cfg->escan_info;
 	struct brcmf_ssid ssid;
 
-	set_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
-	if (cfg_priv->iscan_on) {
+	set_bit(WL_STATUS_SCAN_ABORTING, &cfg->status);
+	if (cfg->iscan_on) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 
 		if (iscan->timer_on) {
@@ -2818,39 +2817,39 @@ static void brcmf_abort_scanning(struct brcmf_cfg80211_priv *cfg_priv)
 		memset(&ssid, 0, sizeof(ssid));
 		brcmf_run_iscan(iscan, &ssid, WL_SCAN_ACTION_ABORT);
 
-		if (cfg_priv->scan_request) {
+		if (cfg->scan_request) {
 			/* Indidate scan abort to cfg80211 layer */
 			WL_INFO("Terminating scan in progress\n");
-			cfg80211_scan_done(cfg_priv->scan_request, true);
-			cfg_priv->scan_request = NULL;
+			cfg80211_scan_done(cfg->scan_request, true);
+			cfg->scan_request = NULL;
 		}
 	}
-	if (cfg_priv->escan_on && cfg_priv->scan_request) {
+	if (cfg->escan_on && cfg->scan_request) {
 		escan->escan_state = WL_ESCAN_STATE_IDLE;
-		brcmf_notify_escan_complete(cfg_priv, escan->ndev, true, true);
+		brcmf_notify_escan_complete(cfg, escan->ndev, true, true);
 	}
-	clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
-	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg_priv->status);
+	clear_bit(WL_STATUS_SCANNING, &cfg->status);
+	clear_bit(WL_STATUS_SCAN_ABORTING, &cfg->status);
 }
 
 static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
 					bool aborted)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_info *cfg = iscan_to_cfg(iscan);
+	struct net_device *ndev = cfg_to_ndev(cfg);
 
-	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg->status)) {
 		WL_ERR("Scan complete while device not scanning\n");
 		return;
 	}
-	if (cfg_priv->scan_request) {
+	if (cfg->scan_request) {
 		WL_SCAN("ISCAN Completed scan: %s\n",
 				aborted ? "Aborted" : "Done");
-		cfg80211_scan_done(cfg_priv->scan_request, aborted);
+		cfg80211_scan_done(cfg->scan_request, aborted);
 		brcmf_set_mpc(ndev, 1);
-		cfg_priv->scan_request = NULL;
+		cfg->scan_request = NULL;
 	}
-	cfg_priv->iscan_kickstart = false;
+	cfg->iscan_kickstart = false;
 }
 
 static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan)
@@ -2903,21 +2902,21 @@ brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 	return err;
 }
 
-static s32 brcmf_iscan_done(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_iscan_done(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg->iscan;
 	s32 err = 0;
 
 	iscan->state = WL_ISCAN_STATE_IDLE;
-	brcmf_inform_bss(cfg_priv);
+	brcmf_inform_bss(cfg);
 	brcmf_notify_iscan_complete(iscan, false);
 
 	return err;
 }
 
-static s32 brcmf_iscan_pending(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_iscan_pending(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg->iscan;
 	s32 err = 0;
 
 	/* Reschedule the timer */
@@ -2927,12 +2926,12 @@ static s32 brcmf_iscan_pending(struct brcmf_cfg80211_priv *cfg_priv)
 	return err;
 }
 
-static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg->iscan;
 	s32 err = 0;
 
-	brcmf_inform_bss(cfg_priv);
+	brcmf_inform_bss(cfg);
 	brcmf_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
 	/* Reschedule the timer */
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
@@ -2941,9 +2940,9 @@ static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_priv *cfg_priv)
 	return err;
 }
 
-static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_priv->iscan;
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg->iscan;
 	s32 err = 0;
 
 	iscan->state = WL_ISCAN_STATE_IDLE;
@@ -2957,7 +2956,7 @@ static void brcmf_cfg80211_iscan_handler(struct work_struct *work)
 	struct brcmf_cfg80211_iscan_ctrl *iscan =
 			container_of(work, struct brcmf_cfg80211_iscan_ctrl,
 				     work);
-	struct brcmf_cfg80211_priv *cfg_priv = iscan_to_cfg(iscan);
+	struct brcmf_cfg80211_info *cfg = iscan_to_cfg(iscan);
 	struct brcmf_cfg80211_iscan_eloop *el = &iscan->el;
 	u32 status = BRCMF_SCAN_RESULTS_PARTIAL;
 
@@ -2966,12 +2965,12 @@ static void brcmf_cfg80211_iscan_handler(struct work_struct *work)
 		iscan->timer_on = 0;
 	}
 
-	if (brcmf_get_iscan_results(iscan, &status, &cfg_priv->bss_list)) {
+	if (brcmf_get_iscan_results(iscan, &status, &cfg->bss_list)) {
 		status = BRCMF_SCAN_RESULTS_ABORTED;
 		WL_ERR("Abort iscan\n");
 	}
 
-	el->handler[status](cfg_priv);
+	el->handler[status](cfg);
 }
 
 static void brcmf_iscan_timer(unsigned long data)
@@ -2986,11 +2985,11 @@ static void brcmf_iscan_timer(unsigned long data)
 	}
 }
 
-static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
 
-	if (cfg_priv->iscan_on) {
+	if (cfg->iscan_on) {
 		iscan->state = WL_ISCAN_STATE_IDLE;
 		INIT_WORK(&iscan->work, brcmf_cfg80211_iscan_handler);
 	}
@@ -3008,21 +3007,21 @@ static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el)
 	el->handler[BRCMF_SCAN_RESULTS_NO_MEM] = brcmf_iscan_aborted;
 }
 
-static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_init_iscan(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg_priv);
+	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
 	int err = 0;
 
-	if (cfg_priv->iscan_on) {
-		iscan->ndev = cfg_to_ndev(cfg_priv);
+	if (cfg->iscan_on) {
+		iscan->ndev = cfg_to_ndev(cfg);
 		brcmf_init_iscan_eloop(&iscan->el);
 		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
 		init_timer(&iscan->timer);
 		iscan->timer.data = (unsigned long) iscan;
 		iscan->timer.function = brcmf_iscan_timer;
-		err = brcmf_invoke_iscan(cfg_priv);
+		err = brcmf_invoke_iscan(cfg);
 		if (!err)
-			iscan->data = cfg_priv;
+			iscan->data = cfg;
 	}
 
 	return err;
@@ -3030,23 +3029,23 @@ static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 
 static void brcmf_cfg80211_escan_timeout_worker(struct work_struct *work)
 {
-	struct brcmf_cfg80211_priv *cfg_priv =
-			container_of(work, struct brcmf_cfg80211_priv,
+	struct brcmf_cfg80211_info *cfg =
+			container_of(work, struct brcmf_cfg80211_info,
 				     escan_timeout_work);
 
-	brcmf_notify_escan_complete(cfg_priv,
-		cfg_priv->escan_info.ndev, true, true);
+	brcmf_notify_escan_complete(cfg,
+		cfg->escan_info.ndev, true, true);
 }
 
 static void brcmf_escan_timeout(unsigned long data)
 {
-	struct brcmf_cfg80211_priv *cfg_priv =
-			(struct brcmf_cfg80211_priv *)data;
+	struct brcmf_cfg80211_info *cfg =
+			(struct brcmf_cfg80211_info *)data;
 
-	if (cfg_priv->scan_request) {
+	if (cfg->scan_request) {
 		WL_ERR("timer expired\n");
-		if (cfg_priv->escan_on)
-			schedule_work(&cfg_priv->escan_timeout_work);
+		if (cfg->escan_on)
+			schedule_work(&cfg->escan_timeout_work);
 	}
 }
 
@@ -3083,7 +3082,7 @@ brcmf_compare_update_same_bss(struct brcmf_bss_info_le *bss,
 }
 
 static s32
-brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_info *cfg,
 			     struct net_device *ndev,
 			     const struct brcmf_event_msg *e, void *data)
 {
@@ -3099,11 +3098,11 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
 
 	status = be32_to_cpu(e->status);
 
-	if (!ndev || !cfg_priv->escan_on ||
-			!test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+	if (!ndev || !cfg->escan_on ||
+			!test_bit(WL_STATUS_SCANNING, &cfg->status)) {
 		WL_ERR("scan not ready ndev %p wl->escan_on %d drv_status %x\n",
-			ndev, cfg_priv->escan_on,
-			!test_bit(WL_STATUS_SCANNING, &cfg_priv->status));
+			ndev, cfg->escan_on,
+			!test_bit(WL_STATUS_SCANNING, &cfg->status));
 		return -EPERM;
 	}
 
@@ -3114,7 +3113,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
 			WL_ERR("Invalid escan result (NULL pointer)\n");
 			goto exit;
 		}
-		if (!cfg_priv->scan_request) {
+		if (!cfg->scan_request) {
 			WL_SCAN("result without cfg80211 request\n");
 			goto exit;
 		}
@@ -3134,7 +3133,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
 			goto exit;
 		}
 
-		if (!(cfg_to_wiphy(cfg_priv)->interface_modes &
+		if (!(cfg_to_wiphy(cfg)->interface_modes &
 					BIT(NL80211_IFTYPE_ADHOC))) {
 			if (le16_to_cpu(bss_info_le->capability) &
 						WLAN_CAPABILITY_IBSS) {
@@ -3144,7 +3143,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
 		}
 
 		list = (struct brcmf_scan_results *)
-				cfg_priv->escan_info.escan_buf;
+				cfg->escan_info.escan_buf;
 		if (bi_length > WL_ESCAN_BUF_SIZE - list->buflen) {
 			WL_ERR("Buffer is too small: ignoring\n");
 			goto exit;
@@ -3157,19 +3156,19 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
 			if (brcmf_compare_update_same_bss(bss, bss_info_le))
 				goto exit;
 		}
-		memcpy(&(cfg_priv->escan_info.escan_buf[list->buflen]),
+		memcpy(&(cfg->escan_info.escan_buf[list->buflen]),
 			bss_info_le, bi_length);
 		list->version = le32_to_cpu(bss_info_le->version);
 		list->buflen += bi_length;
 		list->count++;
 	} else {
-		cfg_priv->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
-		if (cfg_priv->scan_request) {
-			cfg_priv->bss_list = (struct brcmf_scan_results *)
-				cfg_priv->escan_info.escan_buf;
-			brcmf_inform_bss(cfg_priv);
+		cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
+		if (cfg->scan_request) {
+			cfg->bss_list = (struct brcmf_scan_results *)
+				cfg->escan_info.escan_buf;
+			brcmf_inform_bss(cfg);
 			aborted = status != BRCMF_E_STATUS_SUCCESS;
-			brcmf_notify_escan_complete(cfg_priv, ndev, aborted,
+			brcmf_notify_escan_complete(cfg, ndev, aborted,
 						    false);
 		} else
 			WL_ERR("Unexpected scan result 0x%x\n", status);
@@ -3178,18 +3177,18 @@ exit:
 	return err;
 }
 
-static void brcmf_init_escan(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_init_escan(struct brcmf_cfg80211_info *cfg)
 {
 
-	if (cfg_priv->escan_on) {
-		cfg_priv->el.handler[BRCMF_E_ESCAN_RESULT] =
+	if (cfg->escan_on) {
+		cfg->el.handler[BRCMF_E_ESCAN_RESULT] =
 			brcmf_cfg80211_escan_handler;
-		cfg_priv->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
+		cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
 		/* Init scan_timeout timer */
-		init_timer(&cfg_priv->escan_timeout);
-		cfg_priv->escan_timeout.data = (unsigned long) cfg_priv;
-		cfg_priv->escan_timeout.function = brcmf_escan_timeout;
-		INIT_WORK(&cfg_priv->escan_timeout_work,
+		init_timer(&cfg->escan_timeout);
+		cfg->escan_timeout.data = (unsigned long) cfg;
+		cfg->escan_timeout.function = brcmf_escan_timeout;
+		INIT_WORK(&cfg->escan_timeout_work,
 			brcmf_cfg80211_escan_timeout_worker);
 	}
 }
@@ -3206,7 +3205,7 @@ static __always_inline void brcmf_delay(u32 ms)
 
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 
 	/*
 	 * Check for WL_STATUS_READY before any function call which
@@ -3215,7 +3214,7 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 	 */
 	WL_TRACE("Enter\n");
 
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
+	if (test_bit(WL_STATUS_READY, &cfg->status))
 		brcmf_invoke_iscan(wiphy_to_cfg(wiphy));
 
 	WL_TRACE("Exit\n");
@@ -3225,8 +3224,8 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 				  struct cfg80211_wowlan *wow)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg_to_ndev(cfg);
 
 	WL_TRACE("Enter\n");
 
@@ -3240,12 +3239,12 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 	 * While going to suspend if associated with AP disassociate
 	 * from AP to save power while system is in suspended state
 	 */
-	if ((test_bit(WL_STATUS_CONNECTED, &cfg_priv->status) ||
-	     test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) &&
-	     test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+	if ((test_bit(WL_STATUS_CONNECTED, &cfg->status) ||
+	     test_bit(WL_STATUS_CONNECTING, &cfg->status)) &&
+	     test_bit(WL_STATUS_READY, &cfg->status)) {
 		WL_INFO("Disassociating from AP"
 			" while entering suspend state\n");
-		brcmf_link_down(cfg_priv);
+		brcmf_link_down(cfg);
 
 		/*
 		 * Make sure WPA_Supplicant receives all the event
@@ -3255,13 +3254,13 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 		brcmf_delay(500);
 	}
 
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
-		brcmf_abort_scanning(cfg_priv);
+	if (test_bit(WL_STATUS_READY, &cfg->status))
+		brcmf_abort_scanning(cfg);
 	else
-		clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+		clear_bit(WL_STATUS_SCANNING, &cfg->status);
 
 	/* Turn off watchdog timer */
-	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
+	if (test_bit(WL_STATUS_READY, &cfg->status))
 		brcmf_set_mpc(ndev, 1);
 
 	WL_TRACE("Exit\n");
@@ -3272,14 +3271,14 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 static __used s32
 brcmf_dev_bufvar_set(struct net_device *ndev, s8 *name, s8 *buf, s32 len)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	u32 buflen;
 
-	buflen = brcmf_c_mkiovar(name, buf, len, cfg_priv->dcmd_buf,
+	buflen = brcmf_c_mkiovar(name, buf, len, cfg->dcmd_buf,
 			       WL_DCMD_LEN_MAX);
 	BUG_ON(!buflen);
 
-	return brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, cfg_priv->dcmd_buf,
+	return brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, cfg->dcmd_buf,
 			       buflen);
 }
 
@@ -3287,20 +3286,20 @@ static s32
 brcmf_dev_bufvar_get(struct net_device *ndev, s8 *name, s8 *buf,
 		  s32 buf_len)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	u32 len;
 	s32 err = 0;
 
-	len = brcmf_c_mkiovar(name, NULL, 0, cfg_priv->dcmd_buf,
+	len = brcmf_c_mkiovar(name, NULL, 0, cfg->dcmd_buf,
 			    WL_DCMD_LEN_MAX);
 	BUG_ON(!len);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, cfg_priv->dcmd_buf,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, cfg->dcmd_buf,
 			      WL_DCMD_LEN_MAX);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
-	memcpy(buf, cfg_priv->dcmd_buf, buf_len);
+	memcpy(buf, cfg->dcmd_buf, buf_len);
 
 	return err;
 }
@@ -3333,8 +3332,8 @@ static s32
 brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			 struct cfg80211_pmksa *pmksa)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct pmkid_list *pmkids = &cfg_priv->pmk_list->pmkids;
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct pmkid_list *pmkids = &cfg->pmk_list->pmkids;
 	s32 err = 0;
 	int i;
 	int pmkid_len;
@@ -3362,7 +3361,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
 		WL_CONN("%02x\n", pmkids->pmkid[pmkid_len].PMKID[i]);
 
-	err = brcmf_update_pmklist(ndev, cfg_priv->pmk_list, err);
+	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -3372,7 +3371,7 @@ static s32
 brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_pmksa *pmksa)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct pmkid_list pmkid;
 	s32 err = 0;
 	int i, pmkid_len;
@@ -3389,30 +3388,30 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
 		WL_CONN("%02x\n", pmkid.pmkid[0].PMKID[i]);
 
-	pmkid_len = le32_to_cpu(cfg_priv->pmk_list->pmkids.npmkid);
+	pmkid_len = le32_to_cpu(cfg->pmk_list->pmkids.npmkid);
 	for (i = 0; i < pmkid_len; i++)
 		if (!memcmp
-		    (pmksa->bssid, &cfg_priv->pmk_list->pmkids.pmkid[i].BSSID,
+		    (pmksa->bssid, &cfg->pmk_list->pmkids.pmkid[i].BSSID,
 		     ETH_ALEN))
 			break;
 
 	if ((pmkid_len > 0)
 	    && (i < pmkid_len)) {
-		memset(&cfg_priv->pmk_list->pmkids.pmkid[i], 0,
+		memset(&cfg->pmk_list->pmkids.pmkid[i], 0,
 		       sizeof(struct pmkid));
 		for (; i < (pmkid_len - 1); i++) {
-			memcpy(&cfg_priv->pmk_list->pmkids.pmkid[i].BSSID,
-			       &cfg_priv->pmk_list->pmkids.pmkid[i + 1].BSSID,
+			memcpy(&cfg->pmk_list->pmkids.pmkid[i].BSSID,
+			       &cfg->pmk_list->pmkids.pmkid[i + 1].BSSID,
 			       ETH_ALEN);
-			memcpy(&cfg_priv->pmk_list->pmkids.pmkid[i].PMKID,
-			       &cfg_priv->pmk_list->pmkids.pmkid[i + 1].PMKID,
+			memcpy(&cfg->pmk_list->pmkids.pmkid[i].PMKID,
+			       &cfg->pmk_list->pmkids.pmkid[i + 1].PMKID,
 			       WLAN_PMKID_LEN);
 		}
-		cfg_priv->pmk_list->pmkids.npmkid = cpu_to_le32(pmkid_len - 1);
+		cfg->pmk_list->pmkids.npmkid = cpu_to_le32(pmkid_len - 1);
 	} else
 		err = -EINVAL;
 
-	err = brcmf_update_pmklist(ndev, cfg_priv->pmk_list, err);
+	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -3422,15 +3421,15 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 static s32
 brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	memset(cfg_priv->pmk_list, 0, sizeof(*cfg_priv->pmk_list));
-	err = brcmf_update_pmklist(ndev, cfg_priv->pmk_list, err);
+	memset(cfg->pmk_list, 0, sizeof(*cfg->pmk_list));
+	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
 
 	WL_TRACE("Exit\n");
 	return err;
@@ -3446,7 +3445,7 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
  * cfg80211_scan_request one out of the received PNO event.
  */
 static s32
-brcmf_notify_sched_scan_results(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_notify_sched_scan_results(struct brcmf_cfg80211_info *cfg,
 				struct net_device *ndev,
 				const struct brcmf_event_msg *e, void *data)
 {
@@ -3454,7 +3453,7 @@ brcmf_notify_sched_scan_results(struct brcmf_cfg80211_priv *cfg_priv,
 	struct cfg80211_scan_request *request = NULL;
 	struct cfg80211_ssid *ssid = NULL;
 	struct ieee80211_channel *channel = NULL;
-	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
+	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	int err = 0;
 	int channel_req = 0;
 	int band = 0;
@@ -3526,19 +3525,19 @@ brcmf_notify_sched_scan_results(struct brcmf_cfg80211_priv *cfg_priv,
 		if (request->n_ssids)
 			request->ssids = &ssid[0];
 
-		if (test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+		if (test_bit(WL_STATUS_SCANNING, &cfg->status)) {
 			/* Abort any on-going scan */
-			brcmf_abort_scanning(cfg_priv);
+			brcmf_abort_scanning(cfg);
 		}
 
-		set_bit(WL_STATUS_SCANNING, &cfg_priv->status);
-		err = brcmf_do_escan(cfg_priv, wiphy, ndev, request);
+		set_bit(WL_STATUS_SCANNING, &cfg->status);
+		err = brcmf_do_escan(cfg, wiphy, ndev, request);
 		if (err) {
-			clear_bit(WL_STATUS_SCANNING, &cfg_priv->status);
+			clear_bit(WL_STATUS_SCANNING, &cfg->status);
 			goto out_err;
 		}
-		cfg_priv->sched_escan = true;
-		cfg_priv->scan_request = request;
+		cfg->sched_escan = true;
+		cfg->scan_request = request;
 	} else {
 		WL_ERR("FALSE PNO Event. (pfn_count == 0)\n");
 		goto out_err;
@@ -3603,15 +3602,15 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 				struct cfg80211_sched_scan_request *request)
 {
 	char iovbuf[128];
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_priv(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_pno_net_param_le pfn;
 	int i;
 	int ret = 0;
 
 	WL_SCAN("Enter n_match_sets:%d   n_ssids:%d\n",
 		request->n_match_sets, request->n_ssids);
-	if (test_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
-		WL_ERR("Scanning already : status (%lu)\n", cfg_priv->status);
+	if (test_bit(WL_STATUS_SCANNING, &cfg->status)) {
+		WL_ERR("Scanning already : status (%lu)\n", cfg->status);
 		return -EAGAIN;
 	}
 
@@ -3690,12 +3689,12 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 					  struct net_device *ndev)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 
 	WL_SCAN("enter\n");
 	brcmf_dev_pno_clean(ndev);
-	if (cfg_priv->sched_escan)
-		brcmf_notify_escan_complete(cfg_priv, ndev, true, true);
+	if (cfg->sched_escan)
+		brcmf_notify_escan_complete(cfg, ndev, true, true);
 	return 0;
 }
 #endif /* CONFIG_BRCMISCAN */
@@ -3703,8 +3702,8 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 #ifdef CONFIG_NL80211_TESTMODE
 static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg_priv->wdev->netdev;
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct net_device *ndev = cfg->wdev->netdev;
 	struct brcmf_dcmd *dcmd = data;
 	struct sk_buff *reply;
 	int ret;
@@ -4012,7 +4011,7 @@ brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 }
 
 s32
-brcmf_set_management_ie(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 			struct net_device *ndev, s32 bssidx, s32 pktflag,
 			u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
@@ -4037,19 +4036,19 @@ brcmf_set_management_ie(struct brcmf_cfg80211_priv *cfg_priv,
 	if (!iovar_ie_buf)
 		return -ENOMEM;
 	curr_ie_buf = iovar_ie_buf;
-	if (test_bit(WL_STATUS_AP_CREATING, &cfg_priv->status) ||
-	    test_bit(WL_STATUS_AP_CREATED, &cfg_priv->status)) {
+	if (test_bit(WL_STATUS_AP_CREATING, &cfg->status) ||
+	    test_bit(WL_STATUS_AP_CREATED, &cfg->status)) {
 		switch (pktflag) {
 		case VNDR_IE_PRBRSP_FLAG:
-			mgmt_ie_buf = cfg_priv->ap_info->probe_res_ie;
-			mgmt_ie_len = &cfg_priv->ap_info->probe_res_ie_len;
+			mgmt_ie_buf = cfg->ap_info->probe_res_ie;
+			mgmt_ie_len = &cfg->ap_info->probe_res_ie_len;
 			mgmt_ie_buf_len =
-				sizeof(cfg_priv->ap_info->probe_res_ie);
+				sizeof(cfg->ap_info->probe_res_ie);
 			break;
 		case VNDR_IE_BEACON_FLAG:
-			mgmt_ie_buf = cfg_priv->ap_info->beacon_ie;
-			mgmt_ie_len = &cfg_priv->ap_info->beacon_ie_len;
-			mgmt_ie_buf_len = sizeof(cfg_priv->ap_info->beacon_ie);
+			mgmt_ie_buf = cfg->ap_info->beacon_ie;
+			mgmt_ie_len = &cfg->ap_info->beacon_ie_len;
+			mgmt_ie_buf_len = sizeof(cfg->ap_info->beacon_ie);
 			break;
 		default:
 			err = -EPERM;
@@ -4155,7 +4154,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_priv *cfg_priv,
 		err  = brcmf_dev_iovar_setbuf_bsscfg(ndev, "vndr_ie",
 						     iovar_ie_buf,
 						     total_ie_buf_len,
-						     cfg_priv->extra_buf,
+						     cfg->extra_buf,
 						     WL_EXTRA_BUF_MAX, bssidx);
 		if (err)
 			WL_ERR("vndr ie set error : %d\n", err);
@@ -4178,7 +4177,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_tlv *rsn_ie;
 	struct brcmf_vs_tlv *wpa_ie;
 	struct brcmf_join_params join_params;
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 bssidx = 0;
 
 	WL_TRACE("channel_type=%d, beacon_interval=%d, dtim_period=%d,\n",
@@ -4188,7 +4187,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		 settings->ssid, settings->ssid_len, settings->auth_type,
 		 settings->inactivity_timeout);
 
-	if (!test_bit(WL_STATUS_AP_CREATING, &cfg_priv->status)) {
+	if (!test_bit(WL_STATUS_AP_CREATING, &cfg->status)) {
 		WL_ERR("Not in AP creation mode\n");
 		return -EPERM;
 	}
@@ -4239,10 +4238,10 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	wpa_ie = brcmf_find_wpaie((u8 *)settings->beacon.tail,
 				  settings->beacon.tail_len);
 
-	kfree(cfg_priv->ap_info->rsn_ie);
-	cfg_priv->ap_info->rsn_ie = NULL;
-	kfree(cfg_priv->ap_info->wpa_ie);
-	cfg_priv->ap_info->wpa_ie = NULL;
+	kfree(cfg->ap_info->rsn_ie);
+	cfg->ap_info->rsn_ie = NULL;
+	kfree(cfg->ap_info->wpa_ie);
+	cfg->ap_info->wpa_ie = NULL;
 
 	if ((wpa_ie != NULL || rsn_ie != NULL)) {
 		WL_TRACE("WPA(2) IE is found\n");
@@ -4252,7 +4251,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 						    bssidx);
 			if (err < 0)
 				goto exit;
-			cfg_priv->ap_info->wpa_ie = kmemdup(wpa_ie,
+			cfg->ap_info->wpa_ie = kmemdup(wpa_ie,
 							    wpa_ie->len +
 							    TLV_HDR_LEN,
 							    GFP_KERNEL);
@@ -4262,19 +4261,19 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 				(struct brcmf_vs_tlv *)rsn_ie, true, bssidx);
 			if (err < 0)
 				goto exit;
-			cfg_priv->ap_info->rsn_ie = kmemdup(rsn_ie,
+			cfg->ap_info->rsn_ie = kmemdup(rsn_ie,
 							    rsn_ie->len +
 							    TLV_HDR_LEN,
 							    GFP_KERNEL);
 		}
-		cfg_priv->ap_info->security_mode = true;
+		cfg->ap_info->security_mode = true;
 	} else {
 		WL_TRACE("No WPA(2) IEs found\n");
 		brcmf_configure_opensecurity(ndev, bssidx);
-		cfg_priv->ap_info->security_mode = false;
+		cfg->ap_info->security_mode = false;
 	}
 	/* Set Beacon IEs to FW */
-	err = brcmf_set_management_ie(cfg_priv, ndev, bssidx,
+	err = brcmf_set_management_ie(cfg, ndev, bssidx,
 				      VNDR_IE_BEACON_FLAG,
 				      (u8 *)settings->beacon.tail,
 				      settings->beacon.tail_len);
@@ -4284,7 +4283,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		WL_TRACE("Applied Vndr IEs for Beacon\n");
 
 	/* Set Probe Response IEs to FW */
-	err = brcmf_set_management_ie(cfg_priv, ndev, bssidx,
+	err = brcmf_set_management_ie(cfg, ndev, bssidx,
 				      VNDR_IE_PRBRSP_FLAG,
 				      (u8 *)settings->beacon.proberesp_ies,
 				      settings->beacon.proberesp_ies_len);
@@ -4328,8 +4327,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		WL_ERR("SET SSID error (%d)\n", err);
 		goto exit;
 	}
-	clear_bit(WL_STATUS_AP_CREATING, &cfg_priv->status);
-	set_bit(WL_STATUS_AP_CREATED, &cfg_priv->status);
+	clear_bit(WL_STATUS_AP_CREATING, &cfg->status);
+	set_bit(WL_STATUS_AP_CREATED, &cfg->status);
 
 exit:
 	if (err)
@@ -4339,13 +4338,13 @@ exit:
 
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
-	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	s32 ioctl_value;
 	s32 err = -EPERM;
 
 	WL_TRACE("Enter\n");
 
-	if (cfg_priv->conf->mode == WL_MODE_AP) {
+	if (cfg->conf->mode == WL_MODE_AP) {
 		/* Due to most likely deauths outstanding we sleep */
 		/* first to make sure they get processed by fw. */
 		msleep(400);
@@ -4362,8 +4361,8 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 			goto exit;
 		}
 		brcmf_set_mpc(ndev, 1);
-		clear_bit(WL_STATUS_AP_CREATING, &cfg_priv->status);
-		clear_bit(WL_STATUS_AP_CREATED, &cfg_priv->status);
+		clear_bit(WL_STATUS_AP_CREATING, &cfg->status);
+		clear_bit(WL_STATUS_AP_CREATED, &cfg->status);
 	}
 exit:
 	return err;
@@ -4468,7 +4467,7 @@ static struct wireless_dev *brcmf_alloc_wdev(struct device *ndev)
 		return ERR_PTR(-ENOMEM);
 
 	wdev->wiphy = wiphy_new(&wl_cfg80211_ops,
-				sizeof(struct brcmf_cfg80211_priv));
+				sizeof(struct brcmf_cfg80211_info));
 	if (!wdev->wiphy) {
 		WL_ERR("Could not allocate wiphy device\n");
 		err = -ENOMEM;
@@ -4512,9 +4511,9 @@ wiphy_new_out:
 	return ERR_PTR(err);
 }
 
-static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_free_wdev(struct brcmf_cfg80211_info *cfg)
 {
-	struct wireless_dev *wdev = cfg_priv->wdev;
+	struct wireless_dev *wdev = cfg->wdev;
 
 	if (!wdev) {
 		WL_ERR("wdev is invalid\n");
@@ -4523,10 +4522,10 @@ static void brcmf_free_wdev(struct brcmf_cfg80211_priv *cfg_priv)
 	wiphy_unregister(wdev->wiphy);
 	wiphy_free(wdev->wiphy);
 	kfree(wdev);
-	cfg_priv->wdev = NULL;
+	cfg->wdev = NULL;
 }
 
-static bool brcmf_is_linkup(struct brcmf_cfg80211_priv *cfg_priv,
+static bool brcmf_is_linkup(struct brcmf_cfg80211_info *cfg,
 			    const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
@@ -4534,14 +4533,14 @@ static bool brcmf_is_linkup(struct brcmf_cfg80211_priv *cfg_priv,
 
 	if (event == BRCMF_E_SET_SSID && status == BRCMF_E_STATUS_SUCCESS) {
 		WL_CONN("Processing set ssid\n");
-		cfg_priv->link_up = true;
+		cfg->link_up = true;
 		return true;
 	}
 
 	return false;
 }
 
-static bool brcmf_is_linkdown(struct brcmf_cfg80211_priv *cfg_priv,
+static bool brcmf_is_linkdown(struct brcmf_cfg80211_info *cfg,
 			      const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
@@ -4554,7 +4553,7 @@ static bool brcmf_is_linkdown(struct brcmf_cfg80211_priv *cfg_priv,
 	return false;
 }
 
-static bool brcmf_is_nonetwork(struct brcmf_cfg80211_priv *cfg_priv,
+static bool brcmf_is_nonetwork(struct brcmf_cfg80211_info *cfg,
 			       const struct brcmf_event_msg *e)
 {
 	u32 event = be32_to_cpu(e->event_type);
@@ -4575,9 +4574,9 @@ static bool brcmf_is_nonetwork(struct brcmf_cfg80211_priv *cfg_priv,
 	return false;
 }
 
-static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 
 	kfree(conn_info->req_ie);
 	conn_info->req_ie = NULL;
@@ -4587,30 +4586,30 @@ static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 	conn_info->resp_ie_len = 0;
 }
 
-static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 {
-	struct net_device *ndev = cfg_to_ndev(cfg_priv);
+	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_cfg80211_assoc_ielen_le *assoc_info;
-	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	u32 req_len;
 	u32 resp_len;
 	s32 err = 0;
 
-	brcmf_clear_assoc_ies(cfg_priv);
+	brcmf_clear_assoc_ies(cfg);
 
-	err = brcmf_dev_bufvar_get(ndev, "assoc_info", cfg_priv->extra_buf,
+	err = brcmf_dev_bufvar_get(ndev, "assoc_info", cfg->extra_buf,
 				WL_ASSOC_INFO_MAX);
 	if (err) {
 		WL_ERR("could not get assoc info (%d)\n", err);
 		return err;
 	}
 	assoc_info =
-		(struct brcmf_cfg80211_assoc_ielen_le *)cfg_priv->extra_buf;
+		(struct brcmf_cfg80211_assoc_ielen_le *)cfg->extra_buf;
 	req_len = le32_to_cpu(assoc_info->req_len);
 	resp_len = le32_to_cpu(assoc_info->resp_len);
 	if (req_len) {
 		err = brcmf_dev_bufvar_get(ndev, "assoc_req_ies",
-					   cfg_priv->extra_buf,
+					   cfg->extra_buf,
 					   WL_ASSOC_INFO_MAX);
 		if (err) {
 			WL_ERR("could not get assoc req (%d)\n", err);
@@ -4618,7 +4617,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 		}
 		conn_info->req_ie_len = req_len;
 		conn_info->req_ie =
-		    kmemdup(cfg_priv->extra_buf, conn_info->req_ie_len,
+		    kmemdup(cfg->extra_buf, conn_info->req_ie_len,
 			    GFP_KERNEL);
 	} else {
 		conn_info->req_ie_len = 0;
@@ -4626,7 +4625,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 	}
 	if (resp_len) {
 		err = brcmf_dev_bufvar_get(ndev, "assoc_resp_ies",
-					   cfg_priv->extra_buf,
+					   cfg->extra_buf,
 					   WL_ASSOC_INFO_MAX);
 		if (err) {
 			WL_ERR("could not get assoc resp (%d)\n", err);
@@ -4634,7 +4633,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 		}
 		conn_info->resp_ie_len = resp_len;
 		conn_info->resp_ie =
-		    kmemdup(cfg_priv->extra_buf, conn_info->resp_ie_len,
+		    kmemdup(cfg->extra_buf, conn_info->resp_ie_len,
 			    GFP_KERNEL);
 	} else {
 		conn_info->resp_ie_len = 0;
@@ -4647,12 +4646,12 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_priv *cfg_priv)
 }
 
 static s32
-brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev,
 		       const struct brcmf_event_msg *e)
 {
-	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
-	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
+	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct brcmf_channel_info_le channel_le;
 	struct ieee80211_channel *notify_channel;
 	struct ieee80211_supported_band *band;
@@ -4662,9 +4661,9 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 
 	WL_TRACE("Enter\n");
 
-	brcmf_get_assoc_ies(cfg_priv);
-	brcmf_update_prof(cfg_priv, NULL, &e->addr, WL_PROF_BSSID);
-	brcmf_update_bss_info(cfg_priv);
+	brcmf_get_assoc_ies(cfg);
+	brcmf_update_prof(cfg, NULL, &e->addr, WL_PROF_BSSID);
+	brcmf_update_bss_info(cfg);
 
 	brcmf_exec_dcmd(ndev, BRCMF_C_GET_CHANNEL, &channel_le,
 			sizeof(channel_le));
@@ -4681,35 +4680,35 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
 	cfg80211_roamed(ndev, notify_channel,
-			(u8 *)brcmf_read_prof(cfg_priv, WL_PROF_BSSID),
+			(u8 *)brcmf_read_prof(cfg, WL_PROF_BSSID),
 			conn_info->req_ie, conn_info->req_ie_len,
 			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
 	WL_CONN("Report roaming result\n");
 
-	set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
+	set_bit(WL_STATUS_CONNECTED, &cfg->status);
 	WL_TRACE("Exit\n");
 	return err;
 }
 
 static s32
-brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 		       struct net_device *ndev, const struct brcmf_event_msg *e,
 		       bool completed)
 {
-	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
+	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
-	if (test_and_clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) {
+	if (test_and_clear_bit(WL_STATUS_CONNECTING, &cfg->status)) {
 		if (completed) {
-			brcmf_get_assoc_ies(cfg_priv);
-			brcmf_update_prof(cfg_priv, NULL, &e->addr,
+			brcmf_get_assoc_ies(cfg);
+			brcmf_update_prof(cfg, NULL, &e->addr,
 					  WL_PROF_BSSID);
-			brcmf_update_bss_info(cfg_priv);
+			brcmf_update_bss_info(cfg);
 		}
 		cfg80211_connect_result(ndev,
-					(u8 *)brcmf_read_prof(cfg_priv,
+					(u8 *)brcmf_read_prof(cfg,
 							      WL_PROF_BSSID),
 					conn_info->req_ie,
 					conn_info->req_ie_len,
@@ -4719,7 +4718,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
 						    WLAN_STATUS_AUTH_TIMEOUT,
 					GFP_KERNEL);
 		if (completed)
-			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
+			set_bit(WL_STATUS_CONNECTED, &cfg->status);
 		WL_CONN("Report connect result - connection %s\n",
 				completed ? "succeeded" : "failed");
 	}
@@ -4728,7 +4727,7 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
 }
 
 static s32
-brcmf_notify_connect_status_ap(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 			       struct net_device *ndev,
 			       const struct brcmf_event_msg *e, void *data)
 {
@@ -4767,54 +4766,54 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_priv *cfg_priv,
 }
 
 static s32
-brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_notify_connect_status(struct brcmf_cfg80211_info *cfg,
 			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
 	s32 err = 0;
 
-	if (cfg_priv->conf->mode == WL_MODE_AP) {
-		err = brcmf_notify_connect_status_ap(cfg_priv, ndev, e, data);
-	} else if (brcmf_is_linkup(cfg_priv, e)) {
+	if (cfg->conf->mode == WL_MODE_AP) {
+		err = brcmf_notify_connect_status_ap(cfg, ndev, e, data);
+	} else if (brcmf_is_linkup(cfg, e)) {
 		WL_CONN("Linkup\n");
-		if (brcmf_is_ibssmode(cfg_priv)) {
-			brcmf_update_prof(cfg_priv, NULL, (void *)e->addr,
+		if (brcmf_is_ibssmode(cfg)) {
+			brcmf_update_prof(cfg, NULL, (void *)e->addr,
 				WL_PROF_BSSID);
-			wl_inform_ibss(cfg_priv, ndev, e->addr);
+			wl_inform_ibss(cfg, ndev, e->addr);
 			cfg80211_ibss_joined(ndev, e->addr, GFP_KERNEL);
-			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
-			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
+			clear_bit(WL_STATUS_CONNECTING, &cfg->status);
+			set_bit(WL_STATUS_CONNECTED, &cfg->status);
 		} else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, true);
-	} else if (brcmf_is_linkdown(cfg_priv, e)) {
+			brcmf_bss_connect_done(cfg, ndev, e, true);
+	} else if (brcmf_is_linkdown(cfg, e)) {
 		WL_CONN("Linkdown\n");
-		if (brcmf_is_ibssmode(cfg_priv)) {
-			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+		if (brcmf_is_ibssmode(cfg)) {
+			clear_bit(WL_STATUS_CONNECTING, &cfg->status);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
-				&cfg_priv->status))
-				brcmf_link_down(cfg_priv);
+				&cfg->status))
+				brcmf_link_down(cfg);
 		} else {
-			brcmf_bss_connect_done(cfg_priv, ndev, e, false);
+			brcmf_bss_connect_done(cfg, ndev, e, false);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
-				&cfg_priv->status)) {
+				&cfg->status)) {
 				cfg80211_disconnected(ndev, 0, NULL, 0,
 					GFP_KERNEL);
-				brcmf_link_down(cfg_priv);
+				brcmf_link_down(cfg);
 			}
 		}
-		brcmf_init_prof(cfg_priv->profile);
-	} else if (brcmf_is_nonetwork(cfg_priv, e)) {
-		if (brcmf_is_ibssmode(cfg_priv))
-			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
+		brcmf_init_prof(cfg->profile);
+	} else if (brcmf_is_nonetwork(cfg, e)) {
+		if (brcmf_is_ibssmode(cfg))
+			clear_bit(WL_STATUS_CONNECTING, &cfg->status);
 		else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, false);
+			brcmf_bss_connect_done(cfg, ndev, e, false);
 	}
 
 	return err;
 }
 
 static s32
-brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_notify_roaming_status(struct brcmf_cfg80211_info *cfg,
 			    struct net_device *ndev,
 			    const struct brcmf_event_msg *e, void *data)
 {
@@ -4823,17 +4822,17 @@ brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
 	u32 status = be32_to_cpu(e->status);
 
 	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
-		if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status))
-			brcmf_bss_roaming_done(cfg_priv, ndev, e);
+		if (test_bit(WL_STATUS_CONNECTED, &cfg->status))
+			brcmf_bss_roaming_done(cfg, ndev, e);
 		else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, true);
+			brcmf_bss_connect_done(cfg, ndev, e, true);
 	}
 
 	return err;
 }
 
 static s32
-brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_notify_mic_status(struct brcmf_cfg80211_info *cfg,
 			struct net_device *ndev,
 			const struct brcmf_event_msg *e, void *data)
 {
@@ -4852,7 +4851,7 @@ brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
 }
 
 static s32
-brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
+brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
 			 struct net_device *ndev,
 			 const struct brcmf_event_msg *e, void *data)
 {
@@ -4865,12 +4864,12 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 
 	WL_TRACE("Enter\n");
 
-	if (cfg_priv->iscan_on && cfg_priv->iscan_kickstart) {
+	if (cfg->iscan_on && cfg->iscan_kickstart) {
 		WL_TRACE("Exit\n");
-		return brcmf_wakeup_iscan(cfg_to_iscan(cfg_priv));
+		return brcmf_wakeup_iscan(cfg_to_iscan(cfg));
 	}
 
-	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg_priv->status)) {
+	if (!test_and_clear_bit(WL_STATUS_SCANNING, &cfg->status)) {
 		WL_ERR("Scan complete while device not scanning\n");
 		scan_abort = true;
 		err = -EINVAL;
@@ -4887,33 +4886,33 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 	scan_channel = le32_to_cpu(channel_inform_le.scan_channel);
 	if (scan_channel)
 		WL_CONN("channel_inform.scan_channel (%d)\n", scan_channel);
-	cfg_priv->bss_list = cfg_priv->scan_results;
-	bss_list_le = (struct brcmf_scan_results_le *) cfg_priv->bss_list;
+	cfg->bss_list = cfg->scan_results;
+	bss_list_le = (struct brcmf_scan_results_le *) cfg->bss_list;
 
-	memset(cfg_priv->scan_results, 0, len);
+	memset(cfg->scan_results, 0, len);
 	bss_list_le->buflen = cpu_to_le32(len);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN_RESULTS,
-			      cfg_priv->scan_results, len);
+			      cfg->scan_results, len);
 	if (err) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
 		scan_abort = true;
 		goto scan_done_out;
 	}
-	cfg_priv->scan_results->buflen = le32_to_cpu(bss_list_le->buflen);
-	cfg_priv->scan_results->version = le32_to_cpu(bss_list_le->version);
-	cfg_priv->scan_results->count = le32_to_cpu(bss_list_le->count);
+	cfg->scan_results->buflen = le32_to_cpu(bss_list_le->buflen);
+	cfg->scan_results->version = le32_to_cpu(bss_list_le->version);
+	cfg->scan_results->count = le32_to_cpu(bss_list_le->count);
 
-	err = brcmf_inform_bss(cfg_priv);
+	err = brcmf_inform_bss(cfg);
 	if (err)
 		scan_abort = true;
 
 scan_done_out:
-	if (cfg_priv->scan_request) {
+	if (cfg->scan_request) {
 		WL_SCAN("calling cfg80211_scan_done\n");
-		cfg80211_scan_done(cfg_priv->scan_request, scan_abort);
+		cfg80211_scan_done(cfg->scan_request, scan_abort);
 		brcmf_set_mpc(ndev, 1);
-		cfg_priv->scan_request = NULL;
+		cfg->scan_request = NULL;
 	}
 
 	WL_TRACE("Exit\n");
@@ -4947,74 +4946,74 @@ static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 	el->handler[BRCMF_E_PFN_NET_FOUND] = brcmf_notify_sched_scan_results;
 }
 
-static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	kfree(cfg_priv->scan_results);
-	cfg_priv->scan_results = NULL;
-	kfree(cfg_priv->bss_info);
-	cfg_priv->bss_info = NULL;
-	kfree(cfg_priv->conf);
-	cfg_priv->conf = NULL;
-	kfree(cfg_priv->profile);
-	cfg_priv->profile = NULL;
-	kfree(cfg_priv->scan_req_int);
-	cfg_priv->scan_req_int = NULL;
-	kfree(cfg_priv->escan_ioctl_buf);
-	cfg_priv->escan_ioctl_buf = NULL;
-	kfree(cfg_priv->dcmd_buf);
-	cfg_priv->dcmd_buf = NULL;
-	kfree(cfg_priv->extra_buf);
-	cfg_priv->extra_buf = NULL;
-	kfree(cfg_priv->iscan);
-	cfg_priv->iscan = NULL;
-	kfree(cfg_priv->pmk_list);
-	cfg_priv->pmk_list = NULL;
-	if (cfg_priv->ap_info) {
-		kfree(cfg_priv->ap_info->wpa_ie);
-		kfree(cfg_priv->ap_info->rsn_ie);
-		kfree(cfg_priv->ap_info);
-		cfg_priv->ap_info = NULL;
-	}
-}
-
-static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	cfg_priv->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
-	if (!cfg_priv->scan_results)
+static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
+{
+	kfree(cfg->scan_results);
+	cfg->scan_results = NULL;
+	kfree(cfg->bss_info);
+	cfg->bss_info = NULL;
+	kfree(cfg->conf);
+	cfg->conf = NULL;
+	kfree(cfg->profile);
+	cfg->profile = NULL;
+	kfree(cfg->scan_req_int);
+	cfg->scan_req_int = NULL;
+	kfree(cfg->escan_ioctl_buf);
+	cfg->escan_ioctl_buf = NULL;
+	kfree(cfg->dcmd_buf);
+	cfg->dcmd_buf = NULL;
+	kfree(cfg->extra_buf);
+	cfg->extra_buf = NULL;
+	kfree(cfg->iscan);
+	cfg->iscan = NULL;
+	kfree(cfg->pmk_list);
+	cfg->pmk_list = NULL;
+	if (cfg->ap_info) {
+		kfree(cfg->ap_info->wpa_ie);
+		kfree(cfg->ap_info->rsn_ie);
+		kfree(cfg->ap_info);
+		cfg->ap_info = NULL;
+	}
+}
+
+static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
+{
+	cfg->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
+	if (!cfg->scan_results)
 		goto init_priv_mem_out;
-	cfg_priv->conf = kzalloc(sizeof(*cfg_priv->conf), GFP_KERNEL);
-	if (!cfg_priv->conf)
+	cfg->conf = kzalloc(sizeof(*cfg->conf), GFP_KERNEL);
+	if (!cfg->conf)
 		goto init_priv_mem_out;
-	cfg_priv->profile = kzalloc(sizeof(*cfg_priv->profile), GFP_KERNEL);
-	if (!cfg_priv->profile)
+	cfg->profile = kzalloc(sizeof(*cfg->profile), GFP_KERNEL);
+	if (!cfg->profile)
 		goto init_priv_mem_out;
-	cfg_priv->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
-	if (!cfg_priv->bss_info)
+	cfg->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
+	if (!cfg->bss_info)
 		goto init_priv_mem_out;
-	cfg_priv->scan_req_int = kzalloc(sizeof(*cfg_priv->scan_req_int),
+	cfg->scan_req_int = kzalloc(sizeof(*cfg->scan_req_int),
 					 GFP_KERNEL);
-	if (!cfg_priv->scan_req_int)
+	if (!cfg->scan_req_int)
 		goto init_priv_mem_out;
-	cfg_priv->escan_ioctl_buf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
-	if (!cfg_priv->escan_ioctl_buf)
+	cfg->escan_ioctl_buf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
+	if (!cfg->escan_ioctl_buf)
 		goto init_priv_mem_out;
-	cfg_priv->dcmd_buf = kzalloc(WL_DCMD_LEN_MAX, GFP_KERNEL);
-	if (!cfg_priv->dcmd_buf)
+	cfg->dcmd_buf = kzalloc(WL_DCMD_LEN_MAX, GFP_KERNEL);
+	if (!cfg->dcmd_buf)
 		goto init_priv_mem_out;
-	cfg_priv->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
-	if (!cfg_priv->extra_buf)
+	cfg->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
+	if (!cfg->extra_buf)
 		goto init_priv_mem_out;
-	cfg_priv->iscan = kzalloc(sizeof(*cfg_priv->iscan), GFP_KERNEL);
-	if (!cfg_priv->iscan)
+	cfg->iscan = kzalloc(sizeof(*cfg->iscan), GFP_KERNEL);
+	if (!cfg->iscan)
 		goto init_priv_mem_out;
-	cfg_priv->pmk_list = kzalloc(sizeof(*cfg_priv->pmk_list), GFP_KERNEL);
-	if (!cfg_priv->pmk_list)
+	cfg->pmk_list = kzalloc(sizeof(*cfg->pmk_list), GFP_KERNEL);
+	if (!cfg->pmk_list)
 		goto init_priv_mem_out;
 
 	return 0;
 
 init_priv_mem_out:
-	brcmf_deinit_priv_mem(cfg_priv);
+	brcmf_deinit_priv_mem(cfg);
 
 	return -ENOMEM;
 }
@@ -5024,17 +5023,17 @@ init_priv_mem_out:
 */
 
 static struct brcmf_cfg80211_event_q *brcmf_deq_event(
-	struct brcmf_cfg80211_priv *cfg_priv)
+	struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_cfg80211_event_q *e = NULL;
 
-	spin_lock_irq(&cfg_priv->evt_q_lock);
-	if (!list_empty(&cfg_priv->evt_q_list)) {
-		e = list_first_entry(&cfg_priv->evt_q_list,
+	spin_lock_irq(&cfg->evt_q_lock);
+	if (!list_empty(&cfg->evt_q_list)) {
+		e = list_first_entry(&cfg->evt_q_list,
 				     struct brcmf_cfg80211_event_q, evt_q_list);
 		list_del(&e->evt_q_list);
 	}
-	spin_unlock_irq(&cfg_priv->evt_q_lock);
+	spin_unlock_irq(&cfg->evt_q_lock);
 
 	return e;
 }
@@ -5046,7 +5045,7 @@ static struct brcmf_cfg80211_event_q *brcmf_deq_event(
 */
 
 static s32
-brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
+brcmf_enq_event(struct brcmf_cfg80211_info *cfg, u32 event,
 		const struct brcmf_event_msg *msg, void *data)
 {
 	struct brcmf_cfg80211_event_q *e;
@@ -5070,9 +5069,9 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
 	if (data)
 		memcpy(&e->edata, data, data_len);
 
-	spin_lock_irqsave(&cfg_priv->evt_q_lock, flags);
-	list_add_tail(&e->evt_q_list, &cfg_priv->evt_q_list);
-	spin_unlock_irqrestore(&cfg_priv->evt_q_lock, flags);
+	spin_lock_irqsave(&cfg->evt_q_lock, flags);
+	list_add_tail(&e->evt_q_list, &cfg->evt_q_list);
+	spin_unlock_irqrestore(&cfg->evt_q_lock, flags);
 
 	return err;
 }
@@ -5084,12 +5083,12 @@ static void brcmf_put_event(struct brcmf_cfg80211_event_q *e)
 
 static void brcmf_cfg80211_event_handler(struct work_struct *work)
 {
-	struct brcmf_cfg80211_priv *cfg_priv =
-			container_of(work, struct brcmf_cfg80211_priv,
+	struct brcmf_cfg80211_info *cfg =
+			container_of(work, struct brcmf_cfg80211_info,
 				     event_work);
 	struct brcmf_cfg80211_event_q *e;
 
-	e = brcmf_deq_event(cfg_priv);
+	e = brcmf_deq_event(cfg);
 	if (unlikely(!e)) {
 		WL_ERR("event queue empty...\n");
 		return;
@@ -5097,95 +5096,95 @@ static void brcmf_cfg80211_event_handler(struct work_struct *work)
 
 	do {
 		WL_INFO("event type (%d)\n", e->etype);
-		if (cfg_priv->el.handler[e->etype])
-			cfg_priv->el.handler[e->etype](cfg_priv,
-						       cfg_to_ndev(cfg_priv),
+		if (cfg->el.handler[e->etype])
+			cfg->el.handler[e->etype](cfg,
+						       cfg_to_ndev(cfg),
 						       &e->emsg, e->edata);
 		else
 			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
 		brcmf_put_event(e);
-	} while ((e = brcmf_deq_event(cfg_priv)));
+	} while ((e = brcmf_deq_event(cfg)));
 
 }
 
-static void brcmf_init_eq(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_init_eq(struct brcmf_cfg80211_info *cfg)
 {
-	spin_lock_init(&cfg_priv->evt_q_lock);
-	INIT_LIST_HEAD(&cfg_priv->evt_q_list);
+	spin_lock_init(&cfg->evt_q_lock);
+	INIT_LIST_HEAD(&cfg->evt_q_list);
 }
 
-static void brcmf_flush_eq(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_flush_eq(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_cfg80211_event_q *e;
 
-	spin_lock_irq(&cfg_priv->evt_q_lock);
-	while (!list_empty(&cfg_priv->evt_q_list)) {
-		e = list_first_entry(&cfg_priv->evt_q_list,
+	spin_lock_irq(&cfg->evt_q_lock);
+	while (!list_empty(&cfg->evt_q_list)) {
+		e = list_first_entry(&cfg->evt_q_list,
 				     struct brcmf_cfg80211_event_q, evt_q_list);
 		list_del(&e->evt_q_list);
 		kfree(e);
 	}
-	spin_unlock_irq(&cfg_priv->evt_q_lock);
+	spin_unlock_irq(&cfg->evt_q_lock);
 }
 
-static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 {
 	s32 err = 0;
 
-	cfg_priv->scan_request = NULL;
-	cfg_priv->pwr_save = true;
+	cfg->scan_request = NULL;
+	cfg->pwr_save = true;
 #ifdef CONFIG_BRCMISCAN
-	cfg_priv->iscan_on = true;	/* iscan on & off switch.
+	cfg->iscan_on = true;	/* iscan on & off switch.
 				 we enable iscan per default */
-	cfg_priv->escan_on = false;	/* escan on & off switch.
+	cfg->escan_on = false;	/* escan on & off switch.
 				 we disable escan per default */
 #else
-	cfg_priv->iscan_on = false;	/* iscan on & off switch.
+	cfg->iscan_on = false;	/* iscan on & off switch.
 				 we disable iscan per default */
-	cfg_priv->escan_on = true;	/* escan on & off switch.
+	cfg->escan_on = true;	/* escan on & off switch.
 				 we enable escan per default */
 #endif
-	cfg_priv->roam_on = true;	/* roam on & off switch.
+	cfg->roam_on = true;	/* roam on & off switch.
 				 we enable roam per default */
 
-	cfg_priv->iscan_kickstart = false;
-	cfg_priv->active_scan = true;	/* we do active scan for
+	cfg->iscan_kickstart = false;
+	cfg->active_scan = true;	/* we do active scan for
 				 specific scan per default */
-	cfg_priv->dongle_up = false;	/* dongle is not up yet */
-	brcmf_init_eq(cfg_priv);
-	err = brcmf_init_priv_mem(cfg_priv);
+	cfg->dongle_up = false;	/* dongle is not up yet */
+	brcmf_init_eq(cfg);
+	err = brcmf_init_priv_mem(cfg);
 	if (err)
 		return err;
-	INIT_WORK(&cfg_priv->event_work, brcmf_cfg80211_event_handler);
-	brcmf_init_eloop_handler(&cfg_priv->el);
-	mutex_init(&cfg_priv->usr_sync);
-	err = brcmf_init_iscan(cfg_priv);
+	INIT_WORK(&cfg->event_work, brcmf_cfg80211_event_handler);
+	brcmf_init_eloop_handler(&cfg->el);
+	mutex_init(&cfg->usr_sync);
+	err = brcmf_init_iscan(cfg);
 	if (err)
 		return err;
-	brcmf_init_escan(cfg_priv);
-	brcmf_init_conf(cfg_priv->conf);
-	brcmf_init_prof(cfg_priv->profile);
-	brcmf_link_down(cfg_priv);
+	brcmf_init_escan(cfg);
+	brcmf_init_conf(cfg->conf);
+	brcmf_init_prof(cfg->profile);
+	brcmf_link_down(cfg);
 
 	return err;
 }
 
-static void wl_deinit_priv(struct brcmf_cfg80211_priv *cfg_priv)
+static void wl_deinit_priv(struct brcmf_cfg80211_info *cfg)
 {
-	cancel_work_sync(&cfg_priv->event_work);
-	cfg_priv->dongle_up = false;	/* dongle down */
-	brcmf_flush_eq(cfg_priv);
-	brcmf_link_down(cfg_priv);
-	brcmf_abort_scanning(cfg_priv);
-	brcmf_deinit_priv_mem(cfg_priv);
+	cancel_work_sync(&cfg->event_work);
+	cfg->dongle_up = false;	/* dongle down */
+	brcmf_flush_eq(cfg);
+	brcmf_link_down(cfg);
+	brcmf_abort_scanning(cfg);
+	brcmf_deinit_priv_mem(cfg);
 }
 
-struct brcmf_cfg80211_priv *brcmf_cfg80211_attach(struct net_device *ndev,
+struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct net_device *ndev,
 						  struct device *busdev,
 						  struct brcmf_pub *drvr)
 {
 	struct wireless_dev *wdev;
-	struct brcmf_cfg80211_priv *cfg_priv;
+	struct brcmf_cfg80211_info *cfg;
 	s32 err = 0;
 
 	if (!ndev) {
@@ -5199,29 +5198,29 @@ struct brcmf_cfg80211_priv *brcmf_cfg80211_attach(struct net_device *ndev,
 	}
 
 	wdev->iftype = brcmf_mode_to_nl80211_iftype(WL_MODE_BSS);
-	cfg_priv = wdev_to_cfg(wdev);
-	cfg_priv->wdev = wdev;
-	cfg_priv->pub = drvr;
+	cfg = wdev_to_cfg(wdev);
+	cfg->wdev = wdev;
+	cfg->pub = drvr;
 	ndev->ieee80211_ptr = wdev;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
-	err = wl_init_priv(cfg_priv);
+	err = wl_init_priv(cfg);
 	if (err) {
 		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
 
-	return cfg_priv;
+	return cfg;
 
 cfg80211_attach_out:
-	brcmf_free_wdev(cfg_priv);
+	brcmf_free_wdev(cfg);
 	return NULL;
 }
 
-void brcmf_cfg80211_detach(struct brcmf_cfg80211_priv *cfg_priv)
+void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 {
-	wl_deinit_priv(cfg_priv);
-	brcmf_free_wdev(cfg_priv);
+	wl_deinit_priv(cfg);
+	brcmf_free_wdev(cfg);
 }
 
 void
@@ -5229,10 +5228,10 @@ brcmf_cfg80211_event(struct net_device *ndev,
 		  const struct brcmf_event_msg *e, void *data)
 {
 	u32 event_type = be32_to_cpu(e->event_type);
-	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
+	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 
-	if (!brcmf_enq_event(cfg_priv, event_type, e, data))
-		schedule_work(&cfg_priv->event_work);
+	if (!brcmf_enq_event(cfg, event_type, e, data))
+		schedule_work(&cfg->event_work);
 }
 
 static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
@@ -5428,14 +5427,14 @@ dongle_scantime_out:
 	return err;
 }
 
-static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 wl_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 {
 	struct wiphy *wiphy;
 	s32 phy_list;
 	s8 phy;
 	s32 err = 0;
 
-	err = brcmf_exec_dcmd(cfg_to_ndev(cfg_priv), BRCM_GET_PHYLIST,
+	err = brcmf_exec_dcmd(cfg_to_ndev(cfg), BRCM_GET_PHYLIST,
 			      &phy_list, sizeof(phy_list));
 	if (err) {
 		WL_ERR("error (%d)\n", err);
@@ -5445,29 +5444,29 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
 	phy = ((char *)&phy_list)[0];
 	WL_INFO("%c phy\n", phy);
 	if (phy == 'n' || phy == 'a') {
-		wiphy = cfg_to_wiphy(cfg_priv);
+		wiphy = cfg_to_wiphy(cfg);
 		wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_n;
 	}
 
 	return err;
 }
 
-static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_dongle_probecap(struct brcmf_cfg80211_info *cfg)
 {
-	return wl_update_wiphybands(cfg_priv);
+	return wl_update_wiphybands(cfg);
 }
 
-static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
 	s32 power_mode;
 	s32 err = 0;
 
-	if (cfg_priv->dongle_up)
+	if (cfg->dongle_up)
 		return err;
 
-	ndev = cfg_to_ndev(cfg_priv);
+	ndev = cfg_to_ndev(cfg);
 	wdev = ndev->ieee80211_ptr;
 
 	brcmf_dongle_scantime(ndev, WL_SCAN_CHANNEL_TIME,
@@ -5477,21 +5476,21 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv)
 	if (err)
 		goto default_conf_out;
 
-	power_mode = cfg_priv->pwr_save ? PM_FAST : PM_OFF;
+	power_mode = cfg->pwr_save ? PM_FAST : PM_OFF;
 	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_PM, &power_mode);
 	if (err)
 		goto default_conf_out;
 	WL_INFO("power save set to %s\n",
 		(power_mode ? "enabled" : "disabled"));
 
-	err = brcmf_dongle_roam(ndev, (cfg_priv->roam_on ? 0 : 1),
+	err = brcmf_dongle_roam(ndev, (cfg->roam_on ? 0 : 1),
 				WL_BEACON_TIMEOUT);
 	if (err)
 		goto default_conf_out;
 	err = brcmf_dongle_mode(ndev, wdev->iftype);
 	if (err && err != -EINPROGRESS)
 		goto default_conf_out;
-	err = brcmf_dongle_probecap(cfg_priv);
+	err = brcmf_dongle_probecap(cfg);
 	if (err)
 		goto default_conf_out;
 
@@ -5499,31 +5498,31 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv)
 
 default_conf_out:
 
-	cfg_priv->dongle_up = true;
+	cfg->dongle_up = true;
 
 	return err;
 
 }
 
-static int brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv)
+static int brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_info *cfg)
 {
 	char buf[10+IFNAMSIZ];
 	struct dentry *fd;
 	s32 err = 0;
 
-	sprintf(buf, "netdev:%s", cfg_to_ndev(cfg_priv)->name);
-	cfg_priv->debugfsdir = debugfs_create_dir(buf,
-					cfg_to_wiphy(cfg_priv)->debugfsdir);
+	sprintf(buf, "netdev:%s", cfg_to_ndev(cfg)->name);
+	cfg->debugfsdir = debugfs_create_dir(buf,
+					cfg_to_wiphy(cfg)->debugfsdir);
 
-	fd = debugfs_create_u16("beacon_int", S_IRUGO, cfg_priv->debugfsdir,
-		(u16 *)&cfg_priv->profile->beacon_interval);
+	fd = debugfs_create_u16("beacon_int", S_IRUGO, cfg->debugfsdir,
+		(u16 *)&cfg->profile->beacon_interval);
 	if (!fd) {
 		err = -ENOMEM;
 		goto err_out;
 	}
 
-	fd = debugfs_create_u8("dtim_period", S_IRUGO, cfg_priv->debugfsdir,
-		(u8 *)&cfg_priv->profile->dtim_period);
+	fd = debugfs_create_u8("dtim_period", S_IRUGO, cfg->debugfsdir,
+		(u8 *)&cfg->profile->dtim_period);
 	if (!fd) {
 		err = -ENOMEM;
 		goto err_out;
@@ -5533,40 +5532,40 @@ err_out:
 	return err;
 }
 
-static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv)
+static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_info *cfg)
 {
-	debugfs_remove_recursive(cfg_priv->debugfsdir);
-	cfg_priv->debugfsdir = NULL;
+	debugfs_remove_recursive(cfg->debugfsdir);
+	cfg->debugfsdir = NULL;
 }
 
-static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
 {
 	s32 err = 0;
 
-	set_bit(WL_STATUS_READY, &cfg_priv->status);
+	set_bit(WL_STATUS_READY, &cfg->status);
 
-	brcmf_debugfs_add_netdev_params(cfg_priv);
+	brcmf_debugfs_add_netdev_params(cfg);
 
-	err = brcmf_config_dongle(cfg_priv);
+	err = brcmf_config_dongle(cfg);
 	if (err)
 		return err;
 
-	brcmf_invoke_iscan(cfg_priv);
+	brcmf_invoke_iscan(cfg);
 
 	return err;
 }
 
-static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
+static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
 {
 	/*
 	 * While going down, if associated with AP disassociate
 	 * from AP to save power
 	 */
-	if ((test_bit(WL_STATUS_CONNECTED, &cfg_priv->status) ||
-	     test_bit(WL_STATUS_CONNECTING, &cfg_priv->status)) &&
-	     test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+	if ((test_bit(WL_STATUS_CONNECTED, &cfg->status) ||
+	     test_bit(WL_STATUS_CONNECTING, &cfg->status)) &&
+	     test_bit(WL_STATUS_READY, &cfg->status)) {
 		WL_INFO("Disassociating from AP");
-		brcmf_link_down(cfg_priv);
+		brcmf_link_down(cfg);
 
 		/* Make sure WPA_Supplicant receives all the event
 		   generated due to DISASSOC call to the fw to keep
@@ -5575,32 +5574,32 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 		brcmf_delay(500);
 	}
 
-	brcmf_abort_scanning(cfg_priv);
-	clear_bit(WL_STATUS_READY, &cfg_priv->status);
+	brcmf_abort_scanning(cfg);
+	clear_bit(WL_STATUS_READY, &cfg->status);
 
-	brcmf_debugfs_remove_netdev(cfg_priv);
+	brcmf_debugfs_remove_netdev(cfg);
 
 	return 0;
 }
 
-s32 brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv)
+s32 brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
 {
 	s32 err = 0;
 
-	mutex_lock(&cfg_priv->usr_sync);
-	err = __brcmf_cfg80211_up(cfg_priv);
-	mutex_unlock(&cfg_priv->usr_sync);
+	mutex_lock(&cfg->usr_sync);
+	err = __brcmf_cfg80211_up(cfg);
+	mutex_unlock(&cfg->usr_sync);
 
 	return err;
 }
 
-s32 brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
+s32 brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
 {
 	s32 err = 0;
 
-	mutex_lock(&cfg_priv->usr_sync);
-	err = __brcmf_cfg80211_down(cfg_priv);
-	mutex_unlock(&cfg_priv->usr_sync);
+	mutex_lock(&cfg->usr_sync);
+	err = __brcmf_cfg80211_down(cfg);
+	mutex_unlock(&cfg->usr_sync);
 
 	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 3746800..71ced17 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -176,11 +176,11 @@ struct brcmf_cfg80211_conf {
 };
 
 /* forward declaration */
-struct brcmf_cfg80211_priv;
+struct brcmf_cfg80211_info;
 
 /* cfg80211 main event loop */
 struct brcmf_cfg80211_event_loop {
-	s32(*handler[BRCMF_E_LAST]) (struct brcmf_cfg80211_priv *cfg_priv,
+	s32(*handler[BRCMF_E_LAST]) (struct brcmf_cfg80211_info *cfg,
 				     struct net_device *ndev,
 				     const struct brcmf_event_msg *e,
 				     void *data);
@@ -238,7 +238,7 @@ struct brcmf_cfg80211_profile {
 /* dongle iscan event loop */
 struct brcmf_cfg80211_iscan_eloop {
 	s32 (*handler[WL_SCAN_ERSULTS_LAST])
-		(struct brcmf_cfg80211_priv *cfg_priv);
+		(struct brcmf_cfg80211_info *cfg);
 };
 
 /* dongle iscan controller */
@@ -381,7 +381,7 @@ struct brcmf_pno_scanresults_le {
 };
 
 /**
- * struct brcmf_cfg80211_priv - dongle private data of cfg80211 interface
+ * struct brcmf_cfg80211_info - dongle private data of cfg80211 interface
  *
  * @wdev: representing wl cfg80211 device.
  * @conf: dongle configuration.
@@ -424,7 +424,7 @@ struct brcmf_pno_scanresults_le {
  * @ap_info: host ap information.
  * @ci: used to link this structure to netdev private data.
  */
-struct brcmf_cfg80211_priv {
+struct brcmf_cfg80211_info {
 	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_conf *conf;
 	struct cfg80211_scan_request *scan_request;
@@ -466,49 +466,49 @@ struct brcmf_cfg80211_priv {
 	struct ap_info *ap_info;
 };
 
-static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_priv *w)
+static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_info *w)
 {
 	return w->wdev->wiphy;
 }
 
-static inline struct brcmf_cfg80211_priv *wiphy_to_cfg(struct wiphy *w)
+static inline struct brcmf_cfg80211_info *wiphy_to_cfg(struct wiphy *w)
 {
-	return (struct brcmf_cfg80211_priv *)(wiphy_priv(w));
+	return (struct brcmf_cfg80211_info *)(wiphy_priv(w));
 }
 
-static inline struct brcmf_cfg80211_priv *wdev_to_cfg(struct wireless_dev *wd)
+static inline struct brcmf_cfg80211_info *wdev_to_cfg(struct wireless_dev *wd)
 {
-	return (struct brcmf_cfg80211_priv *)(wdev_priv(wd));
+	return (struct brcmf_cfg80211_info *)(wdev_priv(wd));
 }
 
-static inline struct net_device *cfg_to_ndev(struct brcmf_cfg80211_priv *cfg)
+static inline struct net_device *cfg_to_ndev(struct brcmf_cfg80211_info *cfg)
 {
 	return cfg->wdev->netdev;
 }
 
-static inline struct brcmf_cfg80211_priv *ndev_to_cfg(struct net_device *ndev)
+static inline struct brcmf_cfg80211_info *ndev_to_cfg(struct net_device *ndev)
 {
 	return wdev_to_cfg(ndev->ieee80211_ptr);
 }
 
-#define iscan_to_cfg(i) ((struct brcmf_cfg80211_priv *)(i->data))
+#define iscan_to_cfg(i) ((struct brcmf_cfg80211_info *)(i->data))
 #define cfg_to_iscan(w) (w->iscan)
 
 static inline struct
-brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_priv *cfg)
+brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_info *cfg)
 {
 	return &cfg->conn_info;
 }
 
-struct brcmf_cfg80211_priv *brcmf_cfg80211_attach(struct net_device *ndev,
+struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct net_device *ndev,
 						  struct device *busdev,
 						  struct brcmf_pub *drvr);
-void brcmf_cfg80211_detach(struct brcmf_cfg80211_priv *cfg_priv);
+void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
 
 /* event handler from dongle */
 void brcmf_cfg80211_event(struct net_device *ndev,
 			  const struct brcmf_event_msg *e, void *data);
-s32 brcmf_cfg80211_up(struct brcmf_cfg80211_priv *cfg_priv);
-s32 brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv);
+s32 brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg);
+s32 brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.9.5


