Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2432 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab2LEO0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:25 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/11] brcmfmac: remove WL_SCAN() macro
Date: Wed, 5 Dec 2012 15:26:03 +0100
Message-ID: <1354717564-7183-11-git-send-email-arend@broadcom.com> (sfid-20121205_152651_204571_947E585B)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Get rid of WL_SCAN(...) macro in favor of brcmf_dbg(SCAN,...)

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   77 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    1 -
 2 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 1a24c77..f196613 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -539,19 +539,20 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 	n_ssids = request->n_ssids;
 	n_channels = request->n_channels;
 	/* Copy channel array if applicable */
-	WL_SCAN("### List of channelspecs to scan ### %d\n", n_channels);
+	brcmf_dbg(SCAN, "### List of channelspecs to scan ### %d\n",
+		  n_channels);
 	if (n_channels > 0) {
 		for (i = 0; i < n_channels; i++) {
 			chanspec = channel_to_chanspec(request->channels[i]);
-			WL_SCAN("Chan : %d, Channel spec: %x\n",
-				request->channels[i]->hw_value, chanspec);
+			brcmf_dbg(SCAN, "Chan : %d, Channel spec: %x\n",
+				  request->channels[i]->hw_value, chanspec);
 			params_le->channel_list[i] = cpu_to_le16(chanspec);
 		}
 	} else {
-		WL_SCAN("Scanning all channels\n");
+		brcmf_dbg(SCAN, "Scanning all channels\n");
 	}
 	/* Copy ssid array if applicable */
-	WL_SCAN("### List of SSIDs to scan ### %d\n", n_ssids);
+	brcmf_dbg(SCAN, "### List of SSIDs to scan ### %d\n", n_ssids);
 	if (n_ssids > 0) {
 		offset = offsetof(struct brcmf_scan_params_le, channel_list) +
 				n_channels * sizeof(u16);
@@ -564,18 +565,19 @@ static void brcmf_escan_prep(struct brcmf_scan_params_le *params_le,
 			memcpy(ssid_le.SSID, request->ssids[i].ssid,
 			       request->ssids[i].ssid_len);
 			if (!ssid_le.SSID_len)
-				WL_SCAN("%d: Broadcast scan\n", i);
+				brcmf_dbg(SCAN, "%d: Broadcast scan\n", i);
 			else
-				WL_SCAN("%d: scan for  %s size =%d\n", i,
-					ssid_le.SSID, ssid_le.SSID_len);
+				brcmf_dbg(SCAN, "%d: scan for  %s size =%d\n",
+					  i, ssid_le.SSID, ssid_le.SSID_len);
 			memcpy(ptr, &ssid_le, sizeof(ssid_le));
 			ptr += sizeof(ssid_le);
 		}
 	} else {
-		WL_SCAN("Broadcast scan %p\n", request->ssids);
+		brcmf_dbg(SCAN, "Broadcast scan %p\n", request->ssids);
 		if ((request->ssids) && request->ssids->ssid_len) {
-			WL_SCAN("SSID %s len=%d\n", params_le->ssid_le.SSID,
-				request->ssids->ssid_len);
+			brcmf_dbg(SCAN, "SSID %s len=%d\n",
+				  params_le->ssid_le.SSID,
+				  request->ssids->ssid_len);
 			params_le->ssid_le.SSID_len =
 				cpu_to_le32(request->ssids->ssid_len);
 			memcpy(&params_le->ssid_le.SSID, request->ssids->ssid,
@@ -597,7 +599,7 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 	struct cfg80211_scan_request *scan_request;
 	s32 err = 0;
 
-	WL_SCAN("Enter\n");
+	brcmf_dbg(SCAN, "Enter\n");
 
 	/* clear scan request, because the FW abort can cause a second call */
 	/* to this functon and might cause a double cfg80211_scan_done      */
@@ -609,7 +611,7 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 
 	if (fw_abort) {
 		/* Do a scan abort to stop the driver's scan engine */
-		WL_SCAN("ABORT scan in firmware\n");
+		brcmf_dbg(SCAN, "ABORT scan in firmware\n");
 		memset(&params_le, 0, sizeof(params_le));
 		memset(params_le.bssid, 0xFF, ETH_ALEN);
 		params_le.bss_type = DOT11_BSSTYPE_ANY;
@@ -632,14 +634,14 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 	 * which takes precedence.
 	 */
 	if (cfg->sched_escan) {
-		WL_SCAN("scheduled scan completed\n");
+		brcmf_dbg(SCAN, "scheduled scan completed\n");
 		cfg->sched_escan = false;
 		if (!aborted)
 			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
 		brcmf_set_mpc(ndev, 1);
 	} else if (scan_request) {
-		WL_SCAN("ESCAN Completed scan: %s\n",
-				aborted ? "Aborted" : "Done");
+		brcmf_dbg(SCAN, "ESCAN Completed scan: %s\n",
+			  aborted ? "Aborted" : "Done");
 		cfg80211_scan_done(scan_request, aborted);
 		brcmf_set_mpc(ndev, 1);
 	}
@@ -660,7 +662,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
 	struct brcmf_escan_params_le *params;
 	s32 err = 0;
 
-	WL_SCAN("E-SCAN START\n");
+	brcmf_dbg(SCAN, "E-SCAN START\n");
 
 	if (request != NULL) {
 		/* Allocate space for populating ssids in struct */
@@ -703,7 +705,7 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	u32 passive_scan;
 	struct brcmf_scan_results *results;
 
-	WL_SCAN("Enter\n");
+	brcmf_dbg(SCAN, "Enter\n");
 	cfg->escan_info.ndev = ndev;
 	cfg->escan_info.wiphy = wiphy;
 	cfg->escan_info.escan_state = WL_ESCAN_STATE_SCANNING;
@@ -741,7 +743,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err;
 	u32 SSID_len;
 
-	WL_SCAN("START ESCAN\n");
+	brcmf_dbg(SCAN, "START ESCAN\n");
 
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
@@ -779,8 +781,8 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 		if (err)
 			goto scan_out;
 	} else {
-		WL_SCAN("ssid \"%s\", ssid_len (%d)\n",
-		       ssids->ssid, ssids->ssid_len);
+		brcmf_dbg(SCAN, "ssid \"%s\", ssid_len (%d)\n",
+			  ssids->ssid, ssids->ssid_len);
 		memset(&sr->ssid_le, 0, sizeof(sr->ssid_le));
 		SSID_len = min_t(u8, sizeof(sr->ssid_le.SSID), ssids->ssid_len);
 		sr->ssid_le.SSID_len = cpu_to_le32(0);
@@ -790,7 +792,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 			sr->ssid_le.SSID_len = cpu_to_le32(SSID_len);
 			spec_scan = true;
 		} else
-			WL_SCAN("Broadcast scan\n");
+			brcmf_dbg(SCAN, "Broadcast scan\n");
 
 		passive_scan = cfg->active_scan ? 0 : 1;
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PASSIVE_SCAN,
@@ -2150,7 +2152,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 			  bss_list->version);
 		return -EOPNOTSUPP;
 	}
-	WL_SCAN("scanned AP count (%d)\n", bss_list->count);
+	brcmf_dbg(SCAN, "scanned AP count (%d)\n", bss_list->count);
 	for (i = 0; i < bss_list->count; i++) {
 		bi = next_bss_le(bss_list, bi);
 		err = brcmf_inform_single_bss(cfg, bi);
@@ -2462,14 +2464,14 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 	}
 
 	if (status == BRCMF_E_STATUS_PARTIAL) {
-		WL_SCAN("ESCAN Partial result\n");
+		brcmf_dbg(SCAN, "ESCAN Partial result\n");
 		escan_result_le = (struct brcmf_escan_result_le *) data;
 		if (!escan_result_le) {
 			brcmf_err("Invalid escan result (NULL pointer)\n");
 			goto exit;
 		}
 		if (!cfg->scan_request) {
-			WL_SCAN("result without cfg80211 request\n");
+			brcmf_dbg(SCAN, "result without cfg80211 request\n");
 			goto exit;
 		}
 
@@ -2770,10 +2772,10 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	u32 result_count;
 	u32 status;
 
-	WL_SCAN("Enter\n");
+	brcmf_dbg(SCAN, "Enter\n");
 
 	if (e->event_code == BRCMF_E_PFN_NET_LOST) {
-		WL_SCAN("PFN NET LOST event. Do Nothing\n");
+		brcmf_dbg(SCAN, "PFN NET LOST event. Do Nothing\n");
 		return 0;
 	}
 
@@ -2786,7 +2788,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	 * multiple NET_FOUND events. For now place a warning here.
 	 */
 	WARN_ON(status != BRCMF_PNO_SCAN_COMPLETE);
-	WL_SCAN("PFN NET FOUND event. count: %d\n", result_count);
+	brcmf_dbg(SCAN, "PFN NET FOUND event. count: %d\n", result_count);
 	if (result_count > 0) {
 		int i;
 
@@ -2811,8 +2813,8 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 				goto out_err;
 			}
 
-			WL_SCAN("SSID:%s Channel:%d\n",
-			netinfo->SSID, netinfo->channel);
+			brcmf_dbg(SCAN, "SSID:%s Channel:%d\n",
+				  netinfo->SSID, netinfo->channel);
 			memcpy(ssid[i].ssid, netinfo->SSID, netinfo->SSID_len);
 			ssid[i].ssid_len = netinfo->SSID_len;
 			request->n_ssids++;
@@ -2913,8 +2915,8 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 	int i;
 	int ret = 0;
 
-	WL_SCAN("Enter n_match_sets:%d   n_ssids:%d\n",
-		request->n_match_sets, request->n_ssids);
+	brcmf_dbg(SCAN, "Enter n_match_sets:%d   n_ssids:%d\n",
+		  request->n_match_sets, request->n_ssids);
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
 		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
 		return -EAGAIN;
@@ -2929,8 +2931,8 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 	if (request->n_ssids > 0) {
 		for (i = 0; i < request->n_ssids; i++) {
 			/* Active scan req for ssids */
-			WL_SCAN(">>> Active scan req for ssid (%s)\n",
-				request->ssids[i].ssid);
+			brcmf_dbg(SCAN, ">>> Active scan req for ssid (%s)\n",
+				  request->ssids[i].ssid);
 
 			/*
 			 * match_set ssids is a supert set of n_ssid list,
@@ -2975,9 +2977,8 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 			memcpy(pfn.ssid.SSID, ssid->ssid, ssid_len);
 			ret = brcmf_fil_iovar_data_set(ifp, "pfn_add", &pfn,
 						       sizeof(pfn));
-			WL_SCAN(">>> PNO filter %s for ssid (%s)\n",
-				ret == 0 ? "set" : "failed",
-				ssid->ssid);
+			brcmf_dbg(SCAN, ">>> PNO filter %s for ssid (%s)\n",
+				  ret == 0 ? "set" : "failed", ssid->ssid);
 		}
 		/* Enable the PNO */
 		if (brcmf_fil_iovar_int_set(ifp, "pfn", 1) < 0) {
@@ -2996,7 +2997,7 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 
-	WL_SCAN("enter\n");
+	brcmf_dbg(SCAN, "enter\n");
 	brcmf_dev_pno_clean(ndev);
 	if (cfg->sched_escan)
 		brcmf_notify_escan_complete(cfg, ndev, true, true);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 577152f..e636813 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -19,7 +19,6 @@
 
 #include "dhd_dbg.h"
 
-#define	WL_SCAN(fmt, ...)	brcmf_dbg(SCAN, fmt, ##__VA_ARGS__)
 #define	WL_CONN(fmt, ...)	brcmf_dbg(CONN, fmt, ##__VA_ARGS__)
 
 #define WL_NUM_SCAN_MAX			10
-- 
1.7.9.5


