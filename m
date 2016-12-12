Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:54819 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLLMAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 07:00:20 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V3 10/11] brcmfmac: handle gscan events from firmware
Date: Mon, 12 Dec 2016 11:59:56 +0000
Message-Id: <1481543997-24624-11-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161212_130031_676207_31EB4759)
In-Reply-To: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle the gscan events similar to scheduled scan. Collect all SSIDs found
in batch scan and add them to BSS list in cfg80211.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 200 ++++++++++++++++++---
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |   1 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  29 +++
 4 files changed, 214 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2b86c72..61636ad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -733,6 +733,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 {
 	struct brcmf_scan_params_le params_le;
 	struct cfg80211_scan_request *scan_request;
+	enum brcmf_internal_escan_requestor rid;
 	s32 err = 0;

 	brcmf_dbg(SCAN, "Enter\n");
@@ -763,7 +764,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
 					     &params_le, sizeof(params_le));
 		if (err)
-			brcmf_err("Scan abort  failed\n");
+			brcmf_err("Scan abort failed\n");
 	}

 	brcmf_scan_config_mpc(ifp, 1);
@@ -772,11 +773,22 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 	 * e-scan can be initiated internally
 	 * which takes precedence.
 	 */
-	if (cfg->internal_escan) {
-		brcmf_dbg(SCAN, "scheduled scan completed\n");
-		cfg->internal_escan = false;
+	if (cfg->escan_rid) {
+		rid = cfg->escan_rid;
+		cfg->escan_rid = INT_ESCAN_REQ_NONE;
+		brcmf_dbg(SCAN, "internal scan completed (%d)\n", rid);
 		if (!aborted)
-			cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
+			switch (rid) {
+			case INT_ESCAN_REQ_SCHED_SCAN:
+				cfg80211_sched_scan_results(cfg_to_wiphy(cfg));
+				break;
+			case INT_ESCAN_REQ_GSCAN:
+				cfg80211_gscan_results(cfg_to_wiphy(cfg));
+				break;
+			default:
+				/* never happens */
+				break;
+			}
 	} else if (scan_request) {
 		struct cfg80211_scan_info info = {
 			.aborted = aborted,
@@ -1025,7 +1037,7 @@ static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
 			if (!ssid_le.SSID_len)
 				brcmf_dbg(SCAN, "%d: Broadcast scan\n", i);
 			else
-				brcmf_dbg(SCAN, "%d: scan for  %s size =%d\n",
+				brcmf_dbg(SCAN, "%d: scan for  %.32s size=%d\n",
 					  i, ssid_le.SSID, ssid_le.SSID_len);
 			memcpy(ptr, &ssid_le, sizeof(ssid_le));
 			ptr += sizeof(ssid_le);
@@ -3025,7 +3037,7 @@ void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg)
 	struct escan_info *escan = &cfg->escan_info;

 	set_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status);
-	if (cfg->internal_escan || cfg->scan_request) {
+	if (cfg->escan_rid || cfg->scan_request) {
 		escan->escan_state = WL_ESCAN_STATE_IDLE;
 		brcmf_notify_escan_complete(cfg, escan->ifp, true, true);
 	}
@@ -3048,7 +3060,7 @@ static void brcmf_escan_timeout(unsigned long data)
 	struct brcmf_cfg80211_info *cfg =
 			(struct brcmf_cfg80211_info *)data;

-	if (cfg->internal_escan || cfg->scan_request) {
+	if (cfg->escan_rid || cfg->scan_request) {
 		brcmf_err("timer expired\n");
 		schedule_work(&cfg->escan_timeout_work);
 	}
@@ -3131,7 +3143,7 @@ static void brcmf_escan_timeout(unsigned long data)
 		if (brcmf_p2p_scan_finding_common_channel(cfg, bss_info_le))
 			goto exit;

-		if (!cfg->internal_escan && !cfg->scan_request) {
+		if (!cfg->escan_rid && !cfg->scan_request) {
 			brcmf_dbg(SCAN, "result without cfg80211 request\n");
 			goto exit;
 		}
@@ -3177,7 +3189,7 @@ static void brcmf_escan_timeout(unsigned long data)
 		cfg->escan_info.escan_state = WL_ESCAN_STATE_IDLE;
 		if (brcmf_p2p_scan_finding_common_channel(cfg, NULL))
 			goto exit;
-		if (cfg->internal_escan || cfg->scan_request) {
+		if (cfg->escan_rid || cfg->scan_request) {
 			brcmf_inform_bss(cfg);
 			aborted = status != BRCMF_E_STATUS_SUCCESS;
 			brcmf_notify_escan_complete(cfg, ifp, aborted, false);
@@ -3225,7 +3237,7 @@ static int brcmf_internal_escan_add_info(struct cfg80211_scan_request *req,
 {
 	struct ieee80211_channel *chan;
 	enum nl80211_band band;
-	int freq;
+	int freq, i;

 	if (channel <= CH_MAX_2G_CHANNEL)
 		band = NL80211_BAND_2GHZ;
@@ -3240,15 +3252,28 @@ static int brcmf_internal_escan_add_info(struct cfg80211_scan_request *req,
 	if (!chan)
 		return -EINVAL;

-	req->channels[req->n_channels++] = chan;
-	memcpy(req->ssids[req->n_ssids].ssid, ssid, ssid_len);
-	req->ssids[req->n_ssids++].ssid_len = ssid_len;
+	for (i = 0; i < req->n_channels; i++) {
+		if (req->channels[i] == chan)
+			break;
+	}
+	if (i == req->n_channels)
+		req->channels[req->n_channels++] = chan;

+	for (i = 0; i < req->n_ssids; i++) {
+		if (req->ssids[i].ssid_len == ssid_len &&
+		    !memcmp(req->ssids[i].ssid, ssid, ssid_len))
+			break;
+	}
+	if (i == req->n_ssids) {
+		memcpy(req->ssids[req->n_ssids].ssid, ssid, ssid_len);
+		req->ssids[req->n_ssids++].ssid_len = ssid_len;
+	}
 	return 0;
 }

 static int brcmf_start_internal_escan(struct brcmf_if *ifp,
-				      struct cfg80211_scan_request *request)
+				      struct cfg80211_scan_request *request,
+				      enum brcmf_internal_escan_requestor rid)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	int err;
@@ -3265,7 +3290,7 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 		clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 		return err;
 	}
-	cfg->internal_escan = true;
+	cfg->escan_rid = rid;
 	return 0;
 }

@@ -3335,8 +3360,8 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 		brcmf_err("FALSE PNO Event. (pfn_count == 0)\n");
 		goto out_err;
 	}
-	request = brcmf_alloc_internal_escan_request(wiphy,
-						     result_count);
+
+	request = brcmf_alloc_internal_escan_request(wiphy, result_count);
 	if (!request) {
 		err = -ENOMEM;
 		goto out_err;
@@ -3348,23 +3373,22 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 	for (i = 0; i < result_count; i++) {
 		netinfo = &netinfo_start[i];
 		if (!netinfo) {
-			brcmf_err("Invalid netinfo ptr. index: %d\n",
-				  i);
+			brcmf_err("Invalid netinfo ptr. index: %d\n", i);
 			err = -EINVAL;
 			goto out_err;
 		}

 		brcmf_dbg(SCAN, "SSID:%.32s Channel:%d\n",
 			  netinfo->SSID, netinfo->channel);
-		err = brcmf_internal_escan_add_info(request,
-						    netinfo->SSID,
+		err = brcmf_internal_escan_add_info(request, netinfo->SSID,
 						    netinfo->SSID_len,
 						    netinfo->channel);
 		if (err)
 			goto out_err;
 	}

-	err = brcmf_start_internal_escan(ifp, request);
+	err = brcmf_start_internal_escan(ifp, request,
+					 INT_ESCAN_REQ_SCHED_SCAN);
 	if (!err)
 		goto free_req;

@@ -3409,7 +3433,7 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,

 	brcmf_dbg(SCAN, "enter\n");
 	brcmf_pno_clean(ifp);
-	if (cfg->internal_escan)
+	if (cfg->escan_rid)
 		brcmf_notify_escan_complete(cfg, ifp, true, true);
 	return 0;
 }
@@ -5081,6 +5105,131 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	return ret;
 }

+#define BRCMF_GSCAN_RESULT_BUFSIZE		1024
+
+struct brcmf_batch_info {
+	struct list_head list;
+	u8 chan;
+	u8 ssid_len;
+	u8 ssid[32];
+};
+
+static int brcmf_add_batch_info(u8 ssid_len, u8 *ssid, u8 chan,
+				struct list_head *l)
+{
+	struct brcmf_batch_info *entry;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+	entry->chan = chan;
+	entry->ssid_len = ssid_len;
+	memcpy(entry->ssid, ssid, ssid_len);
+	list_add(&entry->list, l);
+
+	return 0;
+}
+
+static s32 brcmf_notify_best_batching(struct brcmf_if *ifp,
+				      const struct brcmf_event_msg *e,
+				      void *data)
+{
+	struct wiphy *wiphy = ifp->drvr->config->wiphy;
+	struct cfg80211_scan_request *request = NULL;
+	struct wl_pfn_lscanresults_v2 *pfn_bestnet;
+	struct wl_pfn_subnet_info_v2 *subnet;
+	struct list_head snlist;
+	struct brcmf_batch_info *batch, *tmp;
+	u32 ts, last_ts, n_subnet;
+	int err, cycle, i, scan_nr;
+
+	brcmf_dbg(TRACE, "Enter\n");
+	INIT_LIST_HEAD(&snlist);
+	n_subnet = 0;
+
+	pfn_bestnet = kmalloc(1024, GFP_KERNEL);
+	if (!pfn_bestnet) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	cycle = 0;
+	pfn_bestnet->status = 0;
+	while (!pfn_bestnet->status) {
+		memset(pfn_bestnet, 0, 1024);
+		err = brcmf_fil_iovar_data_get(ifp, "pfnlbest",
+					       pfn_bestnet, 1024);
+		if (err < 0)
+			goto out_err;
+
+		brcmf_dbg(SCAN, "cycle[%d]: status=%u count=%u\n", cycle++,
+			  le16_to_cpu(pfn_bestnet->status),
+			  le16_to_cpu(pfn_bestnet->count));
+		for (i = 0; i < MAX_CHBKT_PER_RESULT; i++)
+			if (pfn_bestnet->scan_ch_buckets[i]) {
+				brcmf_dbg(SCAN, "  buckets[%d]: %08x\n", i,
+					  le32_to_cpu(pfn_bestnet->scan_ch_buckets[i]));
+			}
+		scan_nr = 0;
+		brcmf_dbg(SCAN, " #%d\n", scan_nr);
+		for (i = 0; i < le16_to_cpu(pfn_bestnet->count); i++) {
+			ts = le32_to_cpu(pfn_bestnet->netinfo[i].timestamp);
+			if (i && abs(ts - last_ts) > 3000)
+				brcmf_dbg(SCAN, " #%d\n", ++scan_nr);
+			subnet = &pfn_bestnet->netinfo[i].pfnsubnet;
+			brcmf_dbg(SCAN, "  %pM: ch=%u ssid=%s (%u) rssi=%d ts=%u rtt=%u rtt-sd=%u\n",
+				  subnet->BSSID, subnet->channel,
+				  subnet->u.SSID, subnet->SSID_len,
+				  (s16)le16_to_cpu(pfn_bestnet->netinfo[i].RSSI),
+				  ts, le16_to_cpu(pfn_bestnet->netinfo[i].rtt0),
+				  le16_to_cpu(pfn_bestnet->netinfo[i].rtt1));
+
+			last_ts = ts;
+			err = brcmf_add_batch_info(subnet->SSID_len,
+						   subnet->u.SSID,
+						   subnet->channel, &snlist);
+			if (err < 0)
+				goto out_err;
+			n_subnet++;
+		}
+	}
+	if (!n_subnet)
+		goto done;
+
+	request = brcmf_alloc_internal_escan_request(wiphy, n_subnet);
+	if (!request) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	list_for_each_entry_safe(batch, tmp, &snlist, list) {
+		err = brcmf_internal_escan_add_info(request,
+						    batch->ssid,
+						    batch->ssid_len,
+						    batch->chan);
+		list_del(&batch->list);
+		kfree(batch);
+		if (err < 0)
+			goto out_err;
+	}
+
+	err = brcmf_start_internal_escan(ifp, request, INT_ESCAN_REQ_GSCAN);
+	if (!err)
+		goto free_req;
+
+out_err:
+	cfg80211_gscan_stopped(wiphy);
+	list_for_each_entry_safe(batch, tmp, &snlist, list) {
+		list_del(&batch->list);
+		kfree(batch);
+	}
+free_req:
+	kfree(request);
+done:
+	kfree(pfn_bestnet);
+	return err;
+}
+
 static int brcmf_cfg80211_start_gscan(struct wiphy *wiphy,
 				      struct net_device *ndev,
 				      struct cfg80211_gscan_request *req)
@@ -5674,6 +5823,9 @@ static void brcmf_register_event_handlers(struct brcmf_cfg80211_info *cfg)
 			    brcmf_p2p_notify_action_tx_complete);
 	brcmf_fweh_register(cfg->pub, BRCMF_E_ACTION_FRAME_OFF_CHAN_COMPLETE,
 			    brcmf_p2p_notify_action_tx_complete);
+	brcmf_fweh_register(cfg->pub, BRCMF_E_PFN_BEST_BATCHING,
+			    brcmf_notify_best_batching);
+
 }

 static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 0c9a708..ff65970 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -253,6 +253,12 @@ struct brcmf_cfg80211_wowl {
 	bool nd_enabled;
 };

+enum brcmf_internal_escan_requestor {
+	INT_ESCAN_REQ_NONE,
+	INT_ESCAN_REQ_SCHED_SCAN,
+	INT_ESCAN_REQ_GSCAN,
+};
+
 /**
  * struct brcmf_cfg80211_info - dongle private data of cfg80211 interface
  *
@@ -271,7 +277,7 @@ struct brcmf_cfg80211_wowl {
  * @pub: common driver information.
  * @channel: current channel.
  * @active_scan: current scan mode.
- * @internal_escan: indicates internally initiated e-scan is running.
+ * @escan_rid: indicates current requestor of internally initiated e-scan.
  * @ibss_starter: indicates this sta is ibss starter.
  * @pwr_save: indicate whether dongle to support power save mode.
  * @dongle_up: indicate whether dongle up or not.
@@ -303,7 +309,7 @@ struct brcmf_cfg80211_info {
 	struct brcmf_pub *pub;
 	u32 channel;
 	bool active_scan;
-	bool internal_escan;
+	enum brcmf_internal_escan_requestor escan_rid;
 	bool ibss_starter;
 	bool pwr_save;
 	bool dongle_up;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
index 5fba4b4..7315736 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
@@ -84,6 +84,7 @@
 	BRCMF_ENUM_DEF(IF, 54) \
 	BRCMF_ENUM_DEF(P2P_DISC_LISTEN_COMPLETE, 55) \
 	BRCMF_ENUM_DEF(RSSI, 56) \
+	BRCMF_ENUM_DEF(PFN_BEST_BATCHING, 57) \
 	BRCMF_ENUM_DEF(EXTLOG_MSG, 58) \
 	BRCMF_ENUM_DEF(ACTION_FRAME, 59) \
 	BRCMF_ENUM_DEF(ACTION_FRAME_COMPLETE, 60) \
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 262642d..a1675c0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -898,4 +898,33 @@ struct brcmf_gscan_config {
 	struct brcmf_gscan_bucket_config bucket[1];
 };

+struct wl_pfn_subnet_info_v2 {
+        u8 BSSID[ETH_ALEN];
+        u8 channel; /**< channel number only */
+        u8 SSID_len;
+        union {
+                u8 SSID[32];
+                __le16 index;
+        } u;
+};
+
+struct wl_pfn_lnet_info_v2 {
+        struct wl_pfn_subnet_info_v2 pfnsubnet; /**< BSSID + channel + SSID len + SSID */
+        __le16 flags; /**< partial scan, etc */
+        __le16 RSSI; /**< receive signal strength (in dBm) */
+        __le32 timestamp; /**< age in miliseconds */
+        __le16 rtt0; /**< estimated distance to this AP in centimeters */
+        __le16 rtt1; /**< standard deviation of the distance to this AP in centimeters */
+};
+
+#define MAX_CHBKT_PER_RESULT            4
+
+struct wl_pfn_lscanresults_v2 {
+        __le32 version;
+        __le16 status;
+        __le16 count;
+        __le32 scan_ch_buckets[MAX_CHBKT_PER_RESULT];
+        struct wl_pfn_lnet_info_v2 netinfo[1];
+};
+
 #endif /* FWIL_TYPES_H_ */
--
1.9.1
