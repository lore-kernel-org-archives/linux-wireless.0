Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1657 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab2KFAWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 19:22:45 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 05/24] brcmfmac: remove obsolete i-scan and clean up
 related code.
Date: Mon, 5 Nov 2012 16:22:13 -0800
Message-ID: <1352161352-30405-6-git-send-email-frankyl@broadcom.com> (sfid-20121106_013115_759662_7EA65EFA)
In-Reply-To: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
References: <1352161352-30405-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

e-scan has become the default scanning method. This patch removes
the i-scan related code and cleans up e-scan related code to be
always enabled.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig             |    8 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   44 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    9 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  581 +-------------------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   68 +--
 5 files changed, 27 insertions(+), 683 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index c9d811e..b480088 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -55,14 +55,6 @@ config BRCMFMAC_USB
 	  IEEE802.11n embedded FullMAC WLAN driver. Say Y if you want to
 	  use the driver for an USB wireless card.
 
-config BRCMISCAN
-	bool "Broadcom I-Scan (OBSOLETE)"
-	depends on BRCMFMAC
-	---help---
-	  This option enables the I-Scan method. By default fullmac uses the
-	  new E-Scan method which uses less memory in firmware and gives no
-	  limitation on the number of scan results.
-
 config BRCMDBG
 	bool "Broadcom driver debug functions"
 	depends on BRCMSMAC || BRCMFMAC
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 8704daa..34bad32 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -100,19 +100,6 @@
 #define BRCMF_SCAN_PARAMS_COUNT_MASK 0x0000ffff
 #define BRCMF_SCAN_PARAMS_NSSID_SHIFT 16
 
-#define BRCMF_SCAN_ACTION_START      1
-#define BRCMF_SCAN_ACTION_CONTINUE   2
-#define WL_SCAN_ACTION_ABORT      3
-
-#define BRCMF_ISCAN_REQ_VERSION 1
-
-/* brcmf_iscan_results status values */
-#define BRCMF_SCAN_RESULTS_SUCCESS	0
-#define BRCMF_SCAN_RESULTS_PARTIAL	1
-#define BRCMF_SCAN_RESULTS_PENDING	2
-#define BRCMF_SCAN_RESULTS_ABORTED	3
-#define BRCMF_SCAN_RESULTS_NO_MEM	4
-
 /* Indicates this key is using soft encrypt */
 #define WL_SOFT_KEY	(1 << 0)
 /* primary (ie tx) key */
@@ -452,14 +439,6 @@ struct brcmf_scan_params_le {
 	__le16 channel_list[1];	/* list of chanspecs */
 };
 
-/* incremental scan struct */
-struct brcmf_iscan_params_le {
-	__le32 version;
-	__le16 action;
-	__le16 scan_duration;
-	struct brcmf_scan_params_le params_le;
-};
-
 struct brcmf_scan_results {
 	u32 buflen;
 	u32 version;
@@ -467,12 +446,6 @@ struct brcmf_scan_results {
 	struct brcmf_bss_info_le bss_info_le[];
 };
 
-struct brcmf_scan_results_le {
-	__le32 buflen;
-	__le32 version;
-	__le32 count;
-};
-
 struct brcmf_escan_params_le {
 	__le32 version;
 	__le16 action;
@@ -508,23 +481,6 @@ struct brcmf_join_params {
 	struct brcmf_assoc_params_le params_le;
 };
 
-/* incremental scan results struct */
-struct brcmf_iscan_results {
-	union {
-		u32 status;
-		__le32 status_le;
-	};
-	union {
-		struct brcmf_scan_results results;
-		struct brcmf_scan_results_le results_le;
-	};
-};
-
-/* size of brcmf_iscan_results not including variable length array */
-#define BRCMF_ISCAN_RESULTS_FIXED_SIZE \
-	(sizeof(struct brcmf_scan_results) + \
-	 offsetof(struct brcmf_iscan_results, results))
-
 struct brcmf_wsec_key {
 	u32 index;		/* key index */
 	u32 len;		/* key length */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index eefa6c2..55a4738 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -27,11 +27,10 @@
 #define BRCMF_HDRS_VAL	0x0040
 #define BRCMF_BYTES_VAL	0x0080
 #define BRCMF_INTR_VAL	0x0100
-#define BRCMF_GLOM_VAL	0x0400
-#define BRCMF_EVENT_VAL	0x0800
-#define BRCMF_BTA_VAL	0x1000
-#define BRCMF_ISCAN_VAL 0x2000
-#define BRCMF_FIL_VAL	0x4000
+#define BRCMF_GLOM_VAL	0x0200
+#define BRCMF_EVENT_VAL	0x0400
+#define BRCMF_BTA_VAL	0x0800
+#define BRCMF_FIL_VAL	0x1000
 
 #if defined(DEBUG)
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 94da6c9..0970c1a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -522,185 +522,6 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	}
 }
 
-static void brcmf_iscan_prep(struct brcmf_scan_params_le *params_le,
-			     struct brcmf_ssid *ssid)
-{
-	memset(params_le->bssid, 0xFF, ETH_ALEN);
-	params_le->bss_type = DOT11_BSSTYPE_ANY;
-	params_le->scan_type = 0;
-	params_le->channel_num = 0;
-	params_le->nprobes = cpu_to_le32(-1);
-	params_le->active_time = cpu_to_le32(-1);
-	params_le->passive_time = cpu_to_le32(-1);
-	params_le->home_time = cpu_to_le32(-1);
-	if (ssid && ssid->SSID_len) {
-		params_le->ssid_le.SSID_len = cpu_to_le32(ssid->SSID_len);
-		memcpy(&params_le->ssid_le.SSID, ssid->SSID, ssid->SSID_len);
-	}
-}
-
-static s32
-brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
-		struct brcmf_ssid *ssid, u16 action)
-{
-	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
-			  offsetof(struct brcmf_iscan_params_le, params_le);
-	struct brcmf_iscan_params_le *params;
-	s32 err = 0;
-
-	if (ssid && ssid->SSID_len)
-		params_size += sizeof(struct brcmf_ssid);
-	params = kzalloc(params_size, GFP_KERNEL);
-	if (!params)
-		return -ENOMEM;
-	BUG_ON(params_size >= BRCMF_DCMD_SMLEN);
-
-	brcmf_iscan_prep(&params->params_le, ssid);
-
-	params->version = cpu_to_le32(BRCMF_ISCAN_REQ_VERSION);
-	params->action = cpu_to_le16(action);
-	params->scan_duration = cpu_to_le16(0);
-
-	err = brcmf_fil_iovar_data_set(netdev_priv(iscan->ndev), "iscan",
-				       params, params_size);
-	if (err) {
-		if (err == -EBUSY)
-			WL_INFO("system busy : iscan canceled\n");
-		else
-			WL_ERR("error (%d)\n", err);
-	}
-
-	kfree(params);
-	return err;
-}
-
-static s32 brcmf_do_iscan(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
-	struct net_device *ndev = cfg_to_ndev(cfg);
-	struct brcmf_ssid ssid;
-	u32 passive_scan;
-	s32 err = 0;
-
-	/* Broadcast scan by default */
-	memset(&ssid, 0, sizeof(ssid));
-
-	iscan->state = WL_ISCAN_STATE_SCANING;
-
-	passive_scan = cfg->active_scan ? 0 : 1;
-	err = brcmf_fil_cmd_int_set(netdev_priv(ndev),
-				    BRCMF_C_SET_PASSIVE_SCAN, passive_scan);
-	if (err) {
-		WL_ERR("error (%d)\n", err);
-		return err;
-	}
-	brcmf_set_mpc(ndev, 0);
-	cfg->iscan_kickstart = true;
-	err = brcmf_run_iscan(iscan, &ssid, BRCMF_SCAN_ACTION_START);
-	if (err) {
-		brcmf_set_mpc(ndev, 1);
-		cfg->iscan_kickstart = false;
-		return err;
-	}
-	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
-	iscan->timer_on = 1;
-	return err;
-}
-
-static s32
-brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
-		     struct cfg80211_scan_request *request,
-		     struct cfg80211_ssid *this_ssid)
-{
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
-	struct cfg80211_ssid *ssids;
-	struct brcmf_cfg80211_scan_req *sr = cfg->scan_req_int;
-	u32 passive_scan;
-	bool iscan_req;
-	bool spec_scan;
-	s32 err = 0;
-	u32 SSID_len;
-
-	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		WL_ERR("Scanning already: status (%lu)\n", cfg->scan_status);
-		return -EAGAIN;
-	}
-	if (test_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status)) {
-		WL_ERR("Scanning being aborted: status (%lu)\n",
-		       cfg->scan_status);
-		return -EAGAIN;
-	}
-	if (test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) {
-		WL_ERR("Connecting: status (%lu)\n", ifp->vif->sme_state);
-		return -EAGAIN;
-	}
-
-	iscan_req = false;
-	spec_scan = false;
-	if (request) {
-		/* scan bss */
-		ssids = request->ssids;
-		if (cfg->iscan_on && (!ssids || !ssids->ssid_len))
-			iscan_req = true;
-	} else {
-		/* scan in ibss */
-		/* we don't do iscan in ibss */
-		ssids = this_ssid;
-	}
-
-	cfg->scan_request = request;
-	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
-	if (iscan_req) {
-		err = brcmf_do_iscan(cfg);
-		if (!err)
-			return err;
-		else
-			goto scan_out;
-	} else {
-		WL_SCAN("ssid \"%s\", ssid_len (%d)\n",
-		       ssids->ssid, ssids->ssid_len);
-		memset(&sr->ssid_le, 0, sizeof(sr->ssid_le));
-		SSID_len = min_t(u8, sizeof(sr->ssid_le.SSID), ssids->ssid_len);
-		sr->ssid_le.SSID_len = cpu_to_le32(0);
-		if (SSID_len) {
-			memcpy(sr->ssid_le.SSID, ssids->ssid, SSID_len);
-			sr->ssid_le.SSID_len = cpu_to_le32(SSID_len);
-			spec_scan = true;
-		} else {
-			WL_SCAN("Broadcast scan\n");
-		}
-
-		passive_scan = cfg->active_scan ? 0 : 1;
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PASSIVE_SCAN,
-					    passive_scan);
-		if (err) {
-			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
-			goto scan_out;
-		}
-		brcmf_set_mpc(ndev, 0);
-		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
-					     &sr->ssid_le, sizeof(sr->ssid_le));
-		if (err) {
-			if (err == -EBUSY)
-				WL_INFO("system busy : scan for \"%s\" "
-					"canceled\n", sr->ssid_le.SSID);
-			else
-				WL_ERR("WLC_SCAN error (%d)\n", err);
-
-			brcmf_set_mpc(ndev, 1);
-			goto scan_out;
-		}
-	}
-
-	return 0;
-
-scan_out:
-	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
-	cfg->scan_request = NULL;
-	return err;
-}
-
 static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 			     struct cfg80211_scan_request *request)
 {
@@ -924,7 +745,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
-	struct brcmf_cfg80211_scan_req *sr = cfg->scan_req_int;
+	struct brcmf_cfg80211_scan_req *sr = &cfg->scan_req_int;
 	u32 passive_scan;
 	bool escan_req;
 	bool spec_scan;
@@ -1018,7 +839,6 @@ static s32
 brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct net_device *ndev = request->wdev->netdev;
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -1027,10 +847,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 				       struct brcmf_cfg80211_vif, wdev)))
 		return -EIO;
 
-	if (cfg->iscan_on)
-		err = brcmf_cfg80211_iscan(wiphy, ndev, request, NULL);
-	else if (cfg->escan_on)
-		err = brcmf_cfg80211_escan(wiphy, ndev, request, NULL);
+	err = brcmf_cfg80211_escan(wiphy, ndev, request, NULL);
 
 	if (err)
 		WL_ERR("scan error (%d)\n", err);
@@ -2352,7 +2169,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 		return -EOPNOTSUPP;
 	}
 	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
-	for (i = 0; i < bss_list->count && i < WL_AP_MAX; i++) {
+	for (i = 0; i < bss_list->count; i++) {
 		bi = next_bss_le(bss_list, bi);
 		err = brcmf_inform_single_bss(cfg, bi);
 		if (err)
@@ -2574,33 +2391,10 @@ update_bss_info_out:
 
 static void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
 	struct escan_info *escan = &cfg->escan_info;
-	struct brcmf_ssid ssid;
 
 	set_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status);
-	if (cfg->iscan_on) {
-		iscan->state = WL_ISCAN_STATE_IDLE;
-
-		if (iscan->timer_on) {
-			del_timer_sync(&iscan->timer);
-			iscan->timer_on = 0;
-		}
-
-		cancel_work_sync(&iscan->work);
-
-		/* Abort iscan running in FW */
-		memset(&ssid, 0, sizeof(ssid));
-		brcmf_run_iscan(iscan, &ssid, WL_SCAN_ACTION_ABORT);
-
-		if (cfg->scan_request) {
-			/* Indidate scan abort to cfg80211 layer */
-			WL_INFO("Terminating scan in progress\n");
-			cfg80211_scan_done(cfg->scan_request, true);
-			cfg->scan_request = NULL;
-		}
-	}
-	if (cfg->escan_on && cfg->scan_request) {
+	if (cfg->scan_request) {
 		escan->escan_state = WL_ESCAN_STATE_IDLE;
 		brcmf_notify_escan_complete(cfg, escan->ndev, true, true);
 	}
@@ -2608,198 +2402,6 @@ static void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
 	clear_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status);
 }
 
-static void brcmf_notify_iscan_complete(struct brcmf_cfg80211_iscan_ctrl *iscan,
-					bool aborted)
-{
-	struct brcmf_cfg80211_info *cfg = iscan_to_cfg(iscan);
-	struct net_device *ndev = cfg_to_ndev(cfg);
-
-	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		WL_ERR("Scan complete while device not scanning\n");
-		return;
-	}
-	if (cfg->scan_request) {
-		WL_SCAN("ISCAN Completed scan: %s\n",
-				aborted ? "Aborted" : "Done");
-		cfg80211_scan_done(cfg->scan_request, aborted);
-		brcmf_set_mpc(ndev, 1);
-		cfg->scan_request = NULL;
-	}
-	cfg->iscan_kickstart = false;
-}
-
-static s32 brcmf_wakeup_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan)
-{
-	if (iscan->state != WL_ISCAN_STATE_IDLE) {
-		WL_SCAN("wake up iscan\n");
-		schedule_work(&iscan->work);
-		return 0;
-	}
-
-	return -EIO;
-}
-
-static s32
-brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
-		     struct brcmf_scan_results **bss_list)
-{
-	struct brcmf_scan_results *results;
-	struct brcmf_scan_results_le *results_le;
-	struct brcmf_iscan_results *list_buf;
-	s32 err = 0;
-
-	memset(iscan->scan_buf, 0, WL_ISCAN_BUF_MAX);
-	list_buf = (struct brcmf_iscan_results *)iscan->scan_buf;
-	results = &list_buf->results;
-	results_le = &list_buf->results_le;
-	results_le->buflen = cpu_to_le32(sizeof(iscan->scan_buf));
-	results_le->version = 0;
-	results_le->count = 0;
-
-	err = brcmf_fil_iovar_data_get(netdev_priv(iscan->ndev), "iscanresults",
-				       iscan->scan_buf,
-				       sizeof(iscan->scan_buf));
-	if (err) {
-		WL_ERR("error (%d)\n", err);
-		return err;
-	}
-	results->buflen = le32_to_cpu(results_le->buflen);
-	results->version = le32_to_cpu(results_le->version);
-	results->count = le32_to_cpu(results_le->count);
-	WL_SCAN("results->count = %d\n", results_le->count);
-	WL_SCAN("results->buflen = %d\n", results_le->buflen);
-	*status = le32_to_cpu(list_buf->status_le);
-	WL_SCAN("status = %d\n", *status);
-	*bss_list = results;
-
-	return err;
-}
-
-static s32 brcmf_iscan_done(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg->iscan;
-	s32 err = 0;
-
-	iscan->state = WL_ISCAN_STATE_IDLE;
-	brcmf_inform_bss(cfg);
-	brcmf_notify_iscan_complete(iscan, false);
-
-	return err;
-}
-
-static s32 brcmf_iscan_pending(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg->iscan;
-	s32 err = 0;
-
-	/* Reschedule the timer */
-	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
-	iscan->timer_on = 1;
-
-	return err;
-}
-
-static s32 brcmf_iscan_inprogress(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg->iscan;
-	s32 err = 0;
-
-	brcmf_inform_bss(cfg);
-	brcmf_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
-	/* Reschedule the timer */
-	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
-	iscan->timer_on = 1;
-
-	return err;
-}
-
-static s32 brcmf_iscan_aborted(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg->iscan;
-	s32 err = 0;
-
-	iscan->state = WL_ISCAN_STATE_IDLE;
-	brcmf_notify_iscan_complete(iscan, true);
-
-	return err;
-}
-
-static void brcmf_cfg80211_iscan_handler(struct work_struct *work)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan =
-			container_of(work, struct brcmf_cfg80211_iscan_ctrl,
-				     work);
-	struct brcmf_cfg80211_info *cfg = iscan_to_cfg(iscan);
-	struct brcmf_cfg80211_iscan_eloop *el = &iscan->el;
-	u32 status = BRCMF_SCAN_RESULTS_PARTIAL;
-
-	if (iscan->timer_on) {
-		del_timer_sync(&iscan->timer);
-		iscan->timer_on = 0;
-	}
-
-	if (brcmf_get_iscan_results(iscan, &status, &cfg->bss_list)) {
-		status = BRCMF_SCAN_RESULTS_ABORTED;
-		WL_ERR("Abort iscan\n");
-	}
-
-	el->handler[status](cfg);
-}
-
-static void brcmf_iscan_timer(unsigned long data)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan =
-			(struct brcmf_cfg80211_iscan_ctrl *)data;
-
-	if (iscan) {
-		iscan->timer_on = 0;
-		WL_SCAN("timer expired\n");
-		brcmf_wakeup_iscan(iscan);
-	}
-}
-
-static s32 brcmf_invoke_iscan(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
-
-	if (cfg->iscan_on) {
-		iscan->state = WL_ISCAN_STATE_IDLE;
-		INIT_WORK(&iscan->work, brcmf_cfg80211_iscan_handler);
-	}
-
-	return 0;
-}
-
-static void brcmf_init_iscan_eloop(struct brcmf_cfg80211_iscan_eloop *el)
-{
-	memset(el, 0, sizeof(*el));
-	el->handler[BRCMF_SCAN_RESULTS_SUCCESS] = brcmf_iscan_done;
-	el->handler[BRCMF_SCAN_RESULTS_PARTIAL] = brcmf_iscan_inprogress;
-	el->handler[BRCMF_SCAN_RESULTS_PENDING] = brcmf_iscan_pending;
-	el->handler[BRCMF_SCAN_RESULTS_ABORTED] = brcmf_iscan_aborted;
-	el->handler[BRCMF_SCAN_RESULTS_NO_MEM] = brcmf_iscan_aborted;
-}
-
-static s32 brcmf_init_iscan(struct brcmf_cfg80211_info *cfg)
-{
-	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
-	int err = 0;
-
-	if (cfg->iscan_on) {
-		iscan->ndev = cfg_to_ndev(cfg);
-		brcmf_init_iscan_eloop(&iscan->el);
-		iscan->timer_ms = WL_ISCAN_TIMER_INTERVAL_MS;
-		init_timer(&iscan->timer);
-		iscan->timer.data = (unsigned long) iscan;
-		iscan->timer.function = brcmf_iscan_timer;
-		err = brcmf_invoke_iscan(cfg);
-		if (!err)
-			iscan->data = cfg;
-	}
-
-	return err;
-}
-
 static void brcmf_cfg80211_escan_timeout_worker(struct work_struct *work)
 {
 	struct brcmf_cfg80211_info *cfg =
@@ -2817,8 +2419,7 @@ static void brcmf_escan_timeout(unsigned long data)
 
 	if (cfg->scan_request) {
 		WL_ERR("timer expired\n");
-		if (cfg->escan_on)
-			schedule_work(&cfg->escan_timeout_work);
+		schedule_work(&cfg->escan_timeout_work);
 	}
 }
 
@@ -2871,11 +2472,9 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_info *cfg,
 
 	status = be32_to_cpu(e->status);
 
-	if (!ndev || !cfg->escan_on ||
-			!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		WL_ERR("scan not ready ndev %p wl->escan_on %d drv_status %x\n",
-			ndev, cfg->escan_on,
-			!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status));
+	if (!ndev || !test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
+		WL_ERR("scan not ready ndev %p drv_status %x\n", ndev,
+		       !test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status));
 		return -EPERM;
 	}
 
@@ -2953,17 +2552,15 @@ exit:
 static void brcmf_init_escan(struct brcmf_cfg80211_info *cfg)
 {
 
-	if (cfg->escan_on) {
-		cfg->el.handler[BRCMF_E_ESCAN_RESULT] =
-			brcmf_cfg80211_escan_handler;
-		cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
-		/* Init scan_timeout timer */
-		init_timer(&cfg->escan_timeout);
-		cfg->escan_timeout.data = (unsigned long) cfg;
-		cfg->escan_timeout.function = brcmf_escan_timeout;
-		INIT_WORK(&cfg->escan_timeout_work,
-			brcmf_cfg80211_escan_timeout_worker);
-	}
+	cfg->el.handler[BRCMF_E_ESCAN_RESULT] =
+		brcmf_cfg80211_escan_handler;
+	cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
+	/* Init scan_timeout timer */
+	init_timer(&cfg->escan_timeout);
+	cfg->escan_timeout.data = (unsigned long) cfg;
+	cfg->escan_timeout.function = brcmf_escan_timeout;
+	INIT_WORK(&cfg->escan_timeout_work,
+		  brcmf_cfg80211_escan_timeout_worker);
 }
 
 static __always_inline void brcmf_delay(u32 ms)
@@ -2978,20 +2575,8 @@ static __always_inline void brcmf_delay(u32 ms)
 
 static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 {
-	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
-
-	/*
-	 * Check for BRCMF_VIF_STATUS_READY before any function call which
-	 * could result is bus access. Don't block the resume for
-	 * any driver error conditions
-	 */
 	WL_TRACE("Enter\n");
 
-	if (check_vif_up(ifp->vif))
-		brcmf_invoke_iscan(cfg);
-
-	WL_TRACE("Exit\n");
 	return 0;
 }
 
@@ -3301,7 +2886,6 @@ out_err:
 	return err;
 }
 
-#ifndef CONFIG_BRCMISCAN
 static int brcmf_dev_pno_clean(struct net_device *ndev)
 {
 	int ret;
@@ -3438,7 +3022,6 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 		brcmf_notify_escan_complete(cfg, ndev, true, true);
 	return 0;
 }
-#endif /* CONFIG_BRCMISCAN */
 
 #ifdef CONFIG_NL80211_TESTMODE
 static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
@@ -4146,11 +3729,8 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.start_ap = brcmf_cfg80211_start_ap,
 	.stop_ap = brcmf_cfg80211_stop_ap,
 	.del_station = brcmf_cfg80211_del_station,
-#ifndef CONFIG_BRCMISCAN
-	/* scheduled scan need e-scan, which is mutual exclusive with i-scan */
 	.sched_scan_start = brcmf_cfg80211_sched_scan_start,
 	.sched_scan_stop = brcmf_cfg80211_sched_scan_stop,
-#endif
 #ifdef CONFIG_NL80211_TESTMODE
 	.testmode_cmd = brcmf_cfg80211_testmode
 #endif
@@ -4174,13 +3754,11 @@ static s32 brcmf_mode_to_nl80211_iftype(s32 mode)
 
 static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 {
-#ifndef CONFIG_BRCMFISCAN
 	/* scheduled scan settings */
 	wiphy->max_sched_scan_ssids = BRCMF_PNO_MAX_PFN_COUNT;
 	wiphy->max_match_sets = BRCMF_PNO_MAX_PFN_COUNT;
 	wiphy->max_sched_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
-#endif
 }
 
 static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
@@ -4625,78 +4203,6 @@ brcmf_notify_mic_status(struct brcmf_cfg80211_info *cfg,
 	return 0;
 }
 
-static s32
-brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
-			 struct net_device *ndev,
-			 const struct brcmf_event_msg *e, void *data)
-{
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct brcmf_channel_info_le channel_inform_le;
-	struct brcmf_scan_results_le *bss_list_le;
-	u32 len = WL_SCAN_BUF_MAX;
-	s32 err = 0;
-	bool scan_abort = false;
-	u32 scan_channel;
-
-	WL_TRACE("Enter\n");
-
-	if (cfg->iscan_on && cfg->iscan_kickstart) {
-		WL_TRACE("Exit\n");
-		return brcmf_wakeup_iscan(cfg_to_iscan(cfg));
-	}
-
-	if (!test_and_clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		WL_ERR("Scan complete while device not scanning\n");
-		scan_abort = true;
-		err = -EINVAL;
-		goto scan_done_out;
-	}
-
-	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CHANNEL,
-				     &channel_inform_le,
-				     sizeof(channel_inform_le));
-	if (err) {
-		WL_ERR("scan busy (%d)\n", err);
-		scan_abort = true;
-		goto scan_done_out;
-	}
-	scan_channel = le32_to_cpu(channel_inform_le.scan_channel);
-	if (scan_channel)
-		WL_CONN("channel_inform.scan_channel (%d)\n", scan_channel);
-	cfg->bss_list = cfg->scan_results;
-	bss_list_le = (struct brcmf_scan_results_le *) cfg->bss_list;
-
-	memset(cfg->scan_results, 0, len);
-	bss_list_le->buflen = cpu_to_le32(len);
-	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_SCAN_RESULTS,
-				     cfg->scan_results, len);
-	if (err) {
-		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
-		err = -EINVAL;
-		scan_abort = true;
-		goto scan_done_out;
-	}
-	cfg->scan_results->buflen = le32_to_cpu(bss_list_le->buflen);
-	cfg->scan_results->version = le32_to_cpu(bss_list_le->version);
-	cfg->scan_results->count = le32_to_cpu(bss_list_le->count);
-
-	err = brcmf_inform_bss(cfg);
-	if (err)
-		scan_abort = true;
-
-scan_done_out:
-	if (cfg->scan_request) {
-		WL_SCAN("calling cfg80211_scan_done\n");
-		cfg80211_scan_done(cfg->scan_request, scan_abort);
-		brcmf_set_mpc(ndev, 1);
-		cfg->scan_request = NULL;
-	}
-
-	WL_TRACE("Exit\n");
-
-	return err;
-}
-
 static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 {
 	conf->mode = (u32)-1;
@@ -4710,7 +4216,6 @@ static void brcmf_init_conf(struct brcmf_cfg80211_conf *conf)
 static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 {
 	memset(el, 0, sizeof(*el));
-	el->handler[BRCMF_E_SCAN_COMPLETE] = brcmf_notify_scan_status;
 	el->handler[BRCMF_E_LINK] = brcmf_notify_connect_status;
 	el->handler[BRCMF_E_DEAUTH_IND] = brcmf_notify_connect_status;
 	el->handler[BRCMF_E_DEAUTH] = brcmf_notify_connect_status;
@@ -4725,53 +4230,27 @@ static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el)
 
 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
 {
-	kfree(cfg->scan_results);
-	cfg->scan_results = NULL;
-	kfree(cfg->bss_info);
-	cfg->bss_info = NULL;
 	kfree(cfg->conf);
 	cfg->conf = NULL;
-	kfree(cfg->scan_req_int);
-	cfg->scan_req_int = NULL;
 	kfree(cfg->escan_ioctl_buf);
 	cfg->escan_ioctl_buf = NULL;
-	kfree(cfg->dcmd_buf);
-	cfg->dcmd_buf = NULL;
 	kfree(cfg->extra_buf);
 	cfg->extra_buf = NULL;
-	kfree(cfg->iscan);
-	cfg->iscan = NULL;
 	kfree(cfg->pmk_list);
 	cfg->pmk_list = NULL;
 }
 
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
 {
-	cfg->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
-	if (!cfg->scan_results)
-		goto init_priv_mem_out;
 	cfg->conf = kzalloc(sizeof(*cfg->conf), GFP_KERNEL);
 	if (!cfg->conf)
 		goto init_priv_mem_out;
-	cfg->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
-	if (!cfg->bss_info)
-		goto init_priv_mem_out;
-	cfg->scan_req_int = kzalloc(sizeof(*cfg->scan_req_int),
-					 GFP_KERNEL);
-	if (!cfg->scan_req_int)
-		goto init_priv_mem_out;
 	cfg->escan_ioctl_buf = kzalloc(BRCMF_DCMD_MEDLEN, GFP_KERNEL);
 	if (!cfg->escan_ioctl_buf)
 		goto init_priv_mem_out;
-	cfg->dcmd_buf = kzalloc(WL_DCMD_LEN_MAX, GFP_KERNEL);
-	if (!cfg->dcmd_buf)
-		goto init_priv_mem_out;
 	cfg->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (!cfg->extra_buf)
 		goto init_priv_mem_out;
-	cfg->iscan = kzalloc(sizeof(*cfg->iscan), GFP_KERNEL);
-	if (!cfg->iscan)
-		goto init_priv_mem_out;
 	cfg->pmk_list = kzalloc(sizeof(*cfg->pmk_list), GFP_KERNEL);
 	if (!cfg->pmk_list)
 		goto init_priv_mem_out;
@@ -4899,21 +4378,8 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 
 	cfg->scan_request = NULL;
 	cfg->pwr_save = true;
-#ifdef CONFIG_BRCMISCAN
-	cfg->iscan_on = true;	/* iscan on & off switch.
-				 we enable iscan per default */
-	cfg->escan_on = false;	/* escan on & off switch.
-				 we disable escan per default */
-#else
-	cfg->iscan_on = false;	/* iscan on & off switch.
-				 we disable iscan per default */
-	cfg->escan_on = true;	/* escan on & off switch.
-				 we enable escan per default */
-#endif
 	cfg->roam_on = true;	/* roam on & off switch.
 				 we enable roam per default */
-
-	cfg->iscan_kickstart = false;
 	cfg->active_scan = true;	/* we do active scan for
 				 specific scan per default */
 	cfg->dongle_up = false;	/* dongle is not up yet */
@@ -4924,9 +4390,6 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 	INIT_WORK(&cfg->event_work, brcmf_cfg80211_event_handler);
 	brcmf_init_eloop_handler(&cfg->el);
 	mutex_init(&cfg->usr_sync);
-	err = brcmf_init_iscan(cfg);
-	if (err)
-		return err;
 	brcmf_init_escan(cfg);
 	brcmf_init_conf(cfg->conf);
 	brcmf_link_down(cfg);
@@ -5044,7 +4507,6 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	setbit(eventmask, BRCMF_E_PMKID_CACHE);
 	setbit(eventmask, BRCMF_E_TXFAIL);
 	setbit(eventmask, BRCMF_E_JOIN_START);
-	setbit(eventmask, BRCMF_E_SCAN_COMPLETE);
 	setbit(eventmask, BRCMF_E_ESCAN_RESULT);
 	setbit(eventmask, BRCMF_E_PFN_NET_FOUND);
 
@@ -5236,17 +4698,10 @@ default_conf_out:
 static s32 __brcmf_cfg80211_up(struct brcmf_cfg80211_info *cfg)
 {
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
-	s32 err = 0;
 
 	set_bit(BRCMF_VIF_STATUS_READY, &ifp->vif->sme_state);
 
-	err = brcmf_config_dongle(cfg);
-	if (err)
-		return err;
-
-	brcmf_invoke_iscan(cfg);
-
-	return err;
+	return brcmf_config_dongle(cfg);
 }
 
 static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_info *cfg)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index d7d473c..3c59931 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -84,31 +84,12 @@ do {								\
 #define	WL_CONN(fmt, args...)
 #endif /* (defined DEBUG) */
 
-#define WL_NUM_SCAN_MAX		1
-#define WL_NUM_PMKIDS_MAX	MAXPMKID	/* will be used
-						 * for 2.6.33 kernel
-						 * or later
-						 */
-#define WL_SCAN_BUF_MAX			(1024 * 8)
+#define WL_NUM_SCAN_MAX			10
+#define WL_NUM_PMKIDS_MAX		MAXPMKID
 #define WL_TLV_INFO_MAX			1024
 #define WL_BSS_INFO_MAX			2048
-#define WL_ASSOC_INFO_MAX	512	/*
-				 * needs to grab assoc info from dongle to
-				 * report it to cfg80211 through "connect"
-				 * event
-				 */
-#define WL_DCMD_LEN_MAX	1024
-#define WL_EXTRA_BUF_MAX	2048
-#define WL_ISCAN_BUF_MAX	2048	/*
-				 * the buf length can be BRCMF_DCMD_MAXLEN
-				 * to reduce iteration
-				 */
-#define WL_ISCAN_TIMER_INTERVAL_MS	3000
-#define WL_SCAN_ERSULTS_LAST	(BRCMF_SCAN_RESULTS_NO_MEM+1)
-#define WL_AP_MAX	256	/* virtually unlimitted as long
-				 * as kernel memory allows
-				 */
-
+#define WL_ASSOC_INFO_MAX		512	/* assoc related fil max buf */
+#define WL_EXTRA_BUF_MAX		2048
 #define WL_ROAM_TRIGGER_LEVEL		-75
 #define WL_ROAM_DELTA			20
 #define WL_BEACON_TIMEOUT		3
@@ -145,12 +126,6 @@ enum wl_mode {
 	WL_MODE_AP
 };
 
-/* dongle iscan state */
-enum wl_iscan_state {
-	WL_ISCAN_STATE_IDLE,
-	WL_ISCAN_STATE_SCANING
-};
-
 /* dongle configuration */
 struct brcmf_cfg80211_conf {
 	u32 mode;		/* adhoc , infrastructure or ap */
@@ -270,26 +245,6 @@ struct brcmf_cfg80211_vif {
 	struct list_head list;
 };
 
-/* dongle iscan event loop */
-struct brcmf_cfg80211_iscan_eloop {
-	s32 (*handler[WL_SCAN_ERSULTS_LAST])
-		(struct brcmf_cfg80211_info *cfg);
-};
-
-/* dongle iscan controller */
-struct brcmf_cfg80211_iscan_ctrl {
-	struct net_device *ndev;
-	struct timer_list timer;
-	u32 timer_ms;
-	u32 timer_on;
-	s32 state;
-	struct work_struct work;
-	struct brcmf_cfg80211_iscan_eloop el;
-	void *data;
-	s8 dcmd_buf[BRCMF_DCMD_SMLEN];
-	s8 scan_buf[WL_ISCAN_BUF_MAX];
-};
-
 /* association inform */
 struct brcmf_cfg80211_connect_info {
 	u8 *req_ie;
@@ -415,19 +370,15 @@ struct brcmf_pno_scanresults_le {
  * @evt_q_lock: for event queue synchronization.
  * @usr_sync: mainly for dongle up/down synchronization.
  * @bss_list: bss_list holding scanned ap information.
- * @scan_results: results of the last scan.
  * @scan_req_int: internal scan request object.
  * @bss_info: bss information for cfg80211 layer.
  * @ie: information element object for internal purpose.
- * @iscan: iscan controller information.
  * @conn_info: association info.
  * @pmk_list: wpa2 pmk list.
  * @event_work: event handler work struct.
  * @scan_status: scan activity on the dongle.
  * @pub: common driver information.
  * @channel: current channel.
- * @iscan_on: iscan on/off switch.
- * @iscan_kickstart: indicate iscan already started.
  * @active_scan: current scan mode.
  * @sched_escan: e-scan for scheduled scan support running.
  * @ibss_starter: indicates this sta is ibss starter.
@@ -439,7 +390,6 @@ struct brcmf_pno_scanresults_le {
  * @dcmd_buf: dcmd buffer.
  * @extra_buf: mainly to grab assoc information.
  * @debugfsdir: debugfs folder for this device.
- * @escan_on: escan on/off switch.
  * @escan_info: escan information.
  * @escan_timeout: Timer for catch scan timeout.
  * @escan_timeout_work: scan timeout worker.
@@ -456,19 +406,15 @@ struct brcmf_cfg80211_info {
 	spinlock_t	 evt_q_lock;
 	struct mutex usr_sync;
 	struct brcmf_scan_results *bss_list;
-	struct brcmf_scan_results *scan_results;
-	struct brcmf_cfg80211_scan_req *scan_req_int;
+	struct brcmf_cfg80211_scan_req scan_req_int;
 	struct wl_cfg80211_bss_info *bss_info;
 	struct brcmf_cfg80211_ie ie;
-	struct brcmf_cfg80211_iscan_ctrl *iscan;
 	struct brcmf_cfg80211_connect_info conn_info;
 	struct brcmf_cfg80211_pmk_list *pmk_list;
 	struct work_struct event_work;
 	unsigned long scan_status;
 	struct brcmf_pub *pub;
 	u32 channel;
-	bool iscan_on;
-	bool iscan_kickstart;
 	bool active_scan;
 	bool sched_escan;
 	bool ibss_starter;
@@ -480,7 +426,6 @@ struct brcmf_cfg80211_info {
 	u8 *dcmd_buf;
 	u8 *extra_buf;
 	struct dentry *debugfsdir;
-	bool escan_on;
 	struct escan_info escan_info;
 	struct timer_list escan_timeout;
 	struct work_struct escan_timeout_work;
@@ -523,9 +468,6 @@ static inline struct brcmf_cfg80211_profile *ndev_to_prof(struct net_device *nd)
 	return &ifp->vif->profile;
 }
 
-#define iscan_to_cfg(i) ((struct brcmf_cfg80211_info *)(i->data))
-#define cfg_to_iscan(w) (w->iscan)
-
 static inline struct
 brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_info *cfg)
 {
-- 
1.7.9.5


