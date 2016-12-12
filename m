Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:54820 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbcLLMAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 07:00:20 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V3 09/11] brcmfmac: implement gscan functionality
Date: Mon, 12 Dec 2016 11:59:55 +0000
Message-Id: <1481543997-24624-10-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161212_130030_025711_BE4FF317)
In-Reply-To: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements configuration of gscan in the device. Handling
the results is done in subsequent change. This initial implementation
does not support running scheduled scan and gscan simultaneously.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  31 ++++
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  18 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 184 ++++++++++++++++++++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.h |   9 +
 4 files changed, 233 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 374b72c..2b86c72 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5081,6 +5081,35 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	return ret;
 }

+static int brcmf_cfg80211_start_gscan(struct wiphy *wiphy,
+				      struct net_device *ndev,
+				      struct cfg80211_gscan_request *req)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
+
+	brcmf_dbg(SCAN, "Enter: n_buckets=%d\n", req->n_buckets);
+
+	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
+		brcmf_err("Scanning suppressed: status (%lu)\n",
+			  cfg->scan_status);
+		return -EAGAIN;
+	}
+
+	/* configure gscan */
+	return brcmf_pno_start_gscan(ifp, req);
+}
+
+static int brcmf_cfg80211_stop_gscan(struct wiphy *wiphy,
+				     struct net_device *ndev)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+
+	brcmf_dbg(TRACE, "Enter, bssidx=%d\n", ifp->bsscfgidx);
+
+	return brcmf_pno_clean(ifp);
+}
+
 #ifdef CONFIG_PM
 static int
 brcmf_cfg80211_set_rekey_data(struct wiphy *wiphy, struct net_device *ndev,
@@ -5148,6 +5177,8 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	.crit_proto_start = brcmf_cfg80211_crit_proto_start,
 	.crit_proto_stop = brcmf_cfg80211_crit_proto_stop,
 	.tdls_oper = brcmf_cfg80211_tdls_oper,
+	.start_gscan = brcmf_cfg80211_start_gscan,
+	.stop_gscan = brcmf_cfg80211_stop_gscan,
 };

 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 8c18fad..262642d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -855,16 +855,20 @@ struct brcmf_gscan_bucket_config {
 };

 /* version supported which must match firmware */
-#define BRCMF_GSCAN_CFG_VERSION                     1
+#define BRCMF_GSCAN_CFG_VERSION                     2

 /**
  * enum brcmf_gscan_cfg_flags - bit values for gscan flags.
  *
  * @BRCMF_GSCAN_CFG_FLAGS_ALL_RESULTS: send probe responses/beacons to host.
+ * @BRCMF_GSCAN_CFG_ALL_BUCKETS_IN_1ST_SCAN: all buckets will be included in
+ *	first scan cycle.
  * @BRCMF_GSCAN_CFG_FLAGS_CHANGE_ONLY: indicated only flags member is changed.
+ *
  */
 enum brcmf_gscan_cfg_flags {
 	BRCMF_GSCAN_CFG_FLAGS_ALL_RESULTS = BIT(0),
+	BRCMF_GSCAN_CFG_ALL_BUCKETS_IN_1ST_SCAN = BIT(3),
 	BRCMF_GSCAN_CFG_FLAGS_CHANGE_ONLY = BIT(7),
 };

@@ -884,12 +888,12 @@ enum brcmf_gscan_cfg_flags {
  */
 struct brcmf_gscan_config {
 	__le16 version;
-	u8  flags;
-	u8   buffer_threshold;
-	u8   swc_nbssid_threshold;
-	u8  swc_rssi_window_size;
-	u8  count_of_channel_buckets;
-	u8  retry_threshold;
+	u8 flags;
+	u8 buffer_threshold;
+	u8 swc_nbssid_threshold;
+	u8 swc_rssi_window_size;
+	u8 count_of_channel_buckets;
+	u8 retry_threshold;
 	__le16  lost_ap_window;
 	struct brcmf_gscan_bucket_config bucket[1];
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 9a25e79..b868997 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -35,6 +35,9 @@
 #define BRCMF_PNO_HIDDEN_BIT		2
 #define BRCMF_PNO_SCHED_SCAN_PERIOD	30

+#define GSCAN_BATCH_NO_THR_SET			101
+#define GSCAN_RETRY_THRESHOLD			3
+
 static int brcmf_pno_channel_config(struct brcmf_if *ifp,
 				    struct brcmf_pno_config_le *cfg)
 {
@@ -182,7 +185,6 @@ int brcmf_pno_clean(struct brcmf_if *ifp)
 int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			       struct cfg80211_sched_scan_request *req)
 {
-	struct brcmu_d11inf *d11inf;
 	struct brcmf_pno_config_le pno_cfg;
 	struct cfg80211_ssid *ssid;
 	u16 chan;
@@ -209,7 +211,6 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	}

 	/* configure channels to use */
-	d11inf = &ifp->drvr->config->d11inf;
 	for (i = 0; i < req->n_channels; i++) {
 		chan = req->channels[i]->hw_value;
 		pno_cfg.channel_list[i] = cpu_to_le16(chan);
@@ -241,3 +242,182 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	return ret;
 }

+static int brcmf_pno_get_bucket_channels(struct brcmf_if *ifp,
+					 struct cfg80211_gscan_bucket *b,
+					 struct brcmf_pno_config_le *pno_cfg)
+{
+	struct wiphy *wiphy;
+	struct ieee80211_supported_band *band;
+	u32 n_chan = le32_to_cpu(pno_cfg->channel_num);
+	u16 chan;
+	int i, err = 0;
+
+	wiphy = ifp->drvr->config->wiphy;
+
+	for (i = 0; i < b->n_channels; i++) {
+		if (n_chan >= BRCMF_NUMCHANNELS) {
+			err = -ENOSPC;
+			goto done;
+		}
+		chan = b->channels[i].ch->hw_value;
+		brcmf_dbg(INFO, "[%d] Chan : %u\n",
+			  n_chan, chan);
+		pno_cfg->channel_list[n_chan++] = cpu_to_le16(chan);
+	}
+	if (b->band & NL80211_BUCKET_BAND_2GHZ) {
+		band = wiphy->bands[NL80211_BAND_2GHZ];
+		for (i = 0; i < band->n_channels; i++) {
+			if (band->channels[i].flags & IEEE80211_CHAN_DISABLED)
+				continue;
+			if (n_chan >= BRCMF_NUMCHANNELS) {
+				err = -ENOSPC;
+				goto done;
+			}
+			chan = band->channels[i].hw_value;
+			brcmf_dbg(INFO, "[%d] Chan : %u\n",
+				  n_chan, chan);
+			pno_cfg->channel_list[n_chan++] = cpu_to_le16(chan);
+		}
+	}
+	if (b->band & NL80211_BUCKET_BAND_5GHZ) {
+		band = wiphy->bands[NL80211_BAND_5GHZ];
+		for (i = 0; i < band->n_channels; i++) {
+			if (band->channels[i].flags & IEEE80211_CHAN_DISABLED)
+				continue;
+			if (band->channels[i].flags & IEEE80211_CHAN_RADAR) {
+				if (b->band & NL80211_BUCKET_BAND_NODFS)
+					continue;
+			} else {
+				if (b->band & NL80211_BUCKET_BAND_DFS_ONLY)
+					continue;
+			}
+			if (n_chan >= BRCMF_NUMCHANNELS) {
+				err = -ENOSPC;
+				goto done;
+			}
+			chan = band->channels[i].hw_value;
+			brcmf_dbg(INFO, "[%d] Chan : %u\n",
+				  n_chan, chan);
+			pno_cfg->channel_list[n_chan++] = cpu_to_le16(chan);
+		}
+	}
+	/* return number of channels */
+	err = n_chan;
+done:
+	pno_cfg->channel_num = cpu_to_le32(n_chan);
+	return err;
+}
+
+static int brcmf_pno_prepare_gscan(struct brcmf_if *ifp,
+				   struct cfg80211_gscan_request *req,
+				   struct brcmf_pno_config_le *pno_cfg,
+				   struct brcmf_gscan_bucket_config **buckets)
+{
+	struct brcmf_gscan_bucket_config *fw_buckets;
+	struct cfg80211_gscan_bucket *bucket;
+	int i, err, chidx;
+
+	*buckets = NULL;
+	fw_buckets = kcalloc(req->n_buckets, sizeof(*buckets[0]), GFP_KERNEL);
+	if (!fw_buckets)
+		return -ENOMEM;
+
+	memset(pno_cfg, 0, sizeof(*pno_cfg));
+	bucket = &req->buckets[0];
+	for (i = 0; i < req->n_buckets; i++) {
+		chidx = brcmf_pno_get_bucket_channels(ifp, bucket, pno_cfg);
+		if (chidx < 0) {
+			err = chidx;
+			goto fail;
+		}
+		fw_buckets[i].bucket_end_index = chidx - 1;
+		fw_buckets[i].bucket_freq_multiple = bucket->period / req->base_period;
+		fw_buckets[i].repeat = cpu_to_le16(bucket->step_count);
+		fw_buckets[i].max_freq_multiple = cpu_to_le16(bucket->max_period / req->base_period);
+		fw_buckets[i].flag = bucket->report_events ^ NL80211_BUCKET_REPORT_NO_BATCH;
+		bucket++;
+	}
+	*buckets = fw_buckets;
+	return 0;
+
+fail:
+	kfree(fw_buckets);
+	return err;
+}
+
+int brcmf_pno_start_gscan(struct brcmf_if *ifp,
+			  struct cfg80211_gscan_request *req)
+{
+	struct brcmf_gscan_config *gscan_cfg;
+	struct brcmf_gscan_bucket_config *buckets;
+	struct brcmf_pno_config_le pno_cfg;
+	size_t gscan_cfg_size;
+	int err;
+
+	/* clean up everything */
+	err = brcmf_pno_clean(ifp);
+	if  (err < 0) {
+		brcmf_err("failed error=%d\n", err);
+		return err;
+	}
+
+	/* configure pno */
+	err = brcmf_pno_config(ifp, req->base_period / 1000,
+			       req->report_threshold_num_scans,
+			       req->max_ap_per_scan);
+	if (err < 0)
+		return err;
+
+	/* configure random mac */
+	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+		err = brcmf_pno_set_random(ifp, req->mac, req->mac_mask);
+		if (err < 0)
+			return err;
+	}
+
+	err = brcmf_pno_prepare_gscan(ifp, req, &pno_cfg, &buckets);
+	if (err < 0)
+		return err;
+
+	gscan_cfg_size = sizeof(*gscan_cfg) +
+			 (req->n_buckets - 1) * sizeof(*buckets);
+	gscan_cfg = kzalloc(gscan_cfg_size, GFP_KERNEL);
+	if (!gscan_cfg) {
+		err = -ENOMEM;
+		goto free_buckets;
+	}
+
+	err = brcmf_pno_channel_config(ifp, &pno_cfg);
+	if (err < 0)
+		goto free_gscan;
+
+	gscan_cfg->version = cpu_to_le16(BRCMF_GSCAN_CFG_VERSION);
+	gscan_cfg->retry_threshold = GSCAN_RETRY_THRESHOLD;
+
+	if (!req->report_threshold_percent)
+		gscan_cfg->buffer_threshold = GSCAN_BATCH_NO_THR_SET;
+	else
+		gscan_cfg->buffer_threshold = req->report_threshold_percent;
+
+	gscan_cfg->flags = BRCMF_GSCAN_CFG_ALL_BUCKETS_IN_1ST_SCAN;
+
+	gscan_cfg->count_of_channel_buckets = req->n_buckets;
+	memcpy(&gscan_cfg->bucket[0], buckets,
+	       req->n_buckets * sizeof(*buckets));
+
+	err = brcmf_fil_iovar_data_set(ifp, "pfn_gscan_cfg", gscan_cfg,
+				       gscan_cfg_size);
+	if (err < 0)
+		goto free_gscan;
+
+	/* Enable the PNO */
+	err = brcmf_fil_iovar_int_set(ifp, "pfn", 1);
+	if (err < 0)
+		brcmf_err("PNO enable failed!! ret=%d\n", err);
+free_gscan:
+	kfree(gscan_cfg);
+free_buckets:
+	kfree(buckets);
+	return err;
+}
+
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
index bae55b2..06ad3b0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
@@ -37,4 +37,13 @@
 int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			       struct cfg80211_sched_scan_request *req);

+/**
+ * brcmf_pno_start_gscan - initiate gscan on device.
+ *
+ * @ifp: interface object used.
+ * @req: GScan request parameters.
+ */
+int brcmf_pno_start_gscan(struct brcmf_if *ifp,
+			  struct cfg80211_gscan_request *req);
+
 #endif /* _BRCMF_PNO_H */
--
1.9.1
