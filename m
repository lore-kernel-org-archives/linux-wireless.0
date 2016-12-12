Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:54821 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751721AbcLLMAV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 07:00:21 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V3 11/11] brcmfmac: allow gscan to run concurrent with scheduled scan
Date: Mon, 12 Dec 2016 11:59:57 +0000
Message-Id: <1481543997-24624-12-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161212_130025_035462_12489F73)
In-Reply-To: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Android the gscan functionality is initiated by the wifi framework
whereas the scheduled scan can be initiated by wpa_supplicant. As such
it is required that these two scan types can run simultaneously.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  12 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |   2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 278 ++++++++++++++++-----
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.h |  28 +++
 6 files changed, 267 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 61636ad..7749610 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3432,7 +3432,7 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 	struct brcmf_if *ifp = netdev_priv(ndev);

 	brcmf_dbg(SCAN, "enter\n");
-	brcmf_pno_clean(ifp);
+	brcmf_pno_stop_sched_scan(ifp);
 	if (cfg->escan_rid)
 		brcmf_notify_escan_complete(cfg, ifp, true, true);
 	return 0;
@@ -5256,7 +5256,7 @@ static int brcmf_cfg80211_stop_gscan(struct wiphy *wiphy,

 	brcmf_dbg(TRACE, "Enter, bssidx=%d\n", ifp->bsscfgidx);

-	return brcmf_pno_clean(ifp);
+	return brcmf_pno_stop_gscan(ifp);
 }

 #ifdef CONFIG_PM
@@ -7076,6 +7076,13 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		brcmf_p2p_detach(&cfg->p2p);
 		goto wiphy_unreg_out;
 	}
+	err = brcmf_pno_attach(ifp);
+	if (err) {
+		brcmf_err("PNO initialisation failed (%d)\n", err);
+		brcmf_btcoex_detach(cfg);
+		brcmf_p2p_detach(&cfg->p2p);
+		goto wiphy_unreg_out;
+	}

 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS)) {
 		err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
@@ -7108,6 +7115,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	return cfg;

 detach:
+	brcmf_pno_detach(ifp);
 	brcmf_btcoex_detach(cfg);
 	brcmf_p2p_detach(&cfg->p2p);
 wiphy_unreg_out:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index ff65970..b9f9375 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -293,6 +293,7 @@ enum brcmf_internal_escan_requestor {
  * @vif_cnt: number of vif instances.
  * @vif_event: vif event signalling.
  * @wowl: wowl related information.
+ * @pi: information of pno module.
  */
 struct brcmf_cfg80211_info {
 	struct wiphy *wiphy;
@@ -326,6 +327,7 @@ struct brcmf_cfg80211_info {
 	struct brcmu_d11inf d11inf;
 	struct brcmf_assoclist_le assoclist;
 	struct brcmf_cfg80211_wowl wowl;
+	struct brcmf_pno_info *pi;
 };

 /**
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9e6f60a..c72653d1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -30,6 +30,7 @@
 #include "debug.h"
 #include "fwil_types.h"
 #include "p2p.h"
+#include "pno.h"
 #include "cfg80211.h"
 #include "fwil.h"
 #include "fwsignal.h"
@@ -1118,8 +1119,10 @@ void brcmf_detach(struct device *dev)

 	/* stop firmware event handling */
 	brcmf_fweh_detach(drvr);
-	if (drvr->config)
+	if (drvr->config) {
+		brcmf_pno_detach(bus_if->drvr->iflist[0]);
 		brcmf_p2p_detach(&drvr->config->p2p);
+	}

 	brcmf_bus_change_state(bus_if, BRCMF_BUS_DOWN);

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 6687812..efc17b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -82,6 +82,7 @@
 #define BRCMF_EVENT_ON()	(brcmf_msg_level & BRCMF_EVENT_VAL)
 #define BRCMF_FIL_ON()		(brcmf_msg_level & BRCMF_FIL_VAL)
 #define BRCMF_FWCON_ON()	(brcmf_msg_level & BRCMF_FWCON_VAL)
+#define BRCMF_SCAN_ON()		(brcmf_msg_level & BRCMF_SCAN_VAL)

 #else /* defined(DEBUG) || defined(CONFIG_BRCM_TRACING) */

@@ -95,6 +96,7 @@
 #define BRCMF_EVENT_ON()	0
 #define BRCMF_FIL_ON()		0
 #define BRCMF_FWCON_ON()	0
+#define BRCMF_SCAN_ON()		0

 #endif /* defined(DEBUG) || defined(CONFIG_BRCM_TRACING) */

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index b868997..c687f21 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 #include <linux/netdevice.h>
+#include <linux/gcd.h>
 #include <net/cfg80211.h>

 #include "core.h"
@@ -38,6 +39,13 @@
 #define GSCAN_BATCH_NO_THR_SET			101
 #define GSCAN_RETRY_THRESHOLD			3

+struct brcmf_pno_info {
+	struct cfg80211_sched_scan_request *sched;
+	struct cfg80211_gscan_request *gscan;
+};
+
+#define ifp_to_pno(_ifp)	(_ifp)->drvr->config->pi
+
 static int brcmf_pno_channel_config(struct brcmf_if *ifp,
 				    struct brcmf_pno_config_le *cfg)
 {
@@ -182,14 +190,46 @@ int brcmf_pno_clean(struct brcmf_if *ifp)
 	return ret;
 }

+static void brcmf_pno_config_ssids(struct brcmf_if *ifp,
+				   struct cfg80211_sched_scan_request *req)
+{
+	struct cfg80211_ssid *ssid;
+	int ret, i;
+
+	/* configure each match set */
+	for (i = 0; i < req->n_match_sets; i++) {
+
+		ssid = &req->match_sets[i].ssid;
+
+		if (!ssid->ssid_len) {
+			brcmf_err("skip broadcast ssid\n");
+			continue;
+		}
+
+		ret = brcmf_pno_add_ssid(ifp, ssid,
+					 brcmf_is_ssid_active(ssid, req));
+		if (ret < 0)
+			brcmf_dbg(SCAN, ">>> PNO filter %s for ssid (%s)\n",
+				  ret == 0 ? "set" : "failed", ssid->ssid);
+	}
+}
+
 int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			       struct cfg80211_sched_scan_request *req)
 {
+	struct brcmf_pno_info *pi;
 	struct brcmf_pno_config_le pno_cfg;
-	struct cfg80211_ssid *ssid;
 	u16 chan;
 	int i, ret;

+	pi = ifp_to_pno(ifp);
+
+	/* g-scan + scheduled scan is handled separately */
+	if (pi->gscan) {
+		pi->sched = req;
+		return brcmf_pno_start_gscan(ifp, pi->gscan);
+	}
+
 	/* clean up everything */
 	ret = brcmf_pno_clean(ifp);
 	if  (ret < 0) {
@@ -217,31 +257,49 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 	}
 	if (req->n_channels) {
 		pno_cfg.channel_num = cpu_to_le32(req->n_channels);
-		brcmf_pno_channel_config(ifp, &pno_cfg);
+		ret = brcmf_pno_channel_config(ifp, &pno_cfg);
+		if (ret < 0)
+			return ret;
 	}

-	/* configure each match set */
-	for (i = 0; i < req->n_match_sets; i++) {
-		ssid = &req->match_sets[i].ssid;
-		if (!ssid->ssid_len) {
-			brcmf_err("skip broadcast ssid\n");
-			continue;
-		}
+	brcmf_pno_config_ssids(ifp, req);

-		ret = brcmf_pno_add_ssid(ifp, ssid,
-					 brcmf_is_ssid_active(ssid, req));
-		if (ret < 0)
-			brcmf_dbg(SCAN, ">>> PNO filter %s for ssid (%s)\n",
-				  ret == 0 ? "set" : "failed", ssid->ssid);
-	}
 	/* Enable the PNO */
 	ret = brcmf_fil_iovar_int_set(ifp, "pfn", 1);
-	if (ret < 0)
+	if (ret < 0) {
 		brcmf_err("PNO enable failed!! ret=%d\n", ret);
+		return ret;
+	}

+	/* keep reference of request */
+	ifp_to_pno(ifp)->sched = req;
 	return ret;
 }

+int brcmf_pno_stop_sched_scan(struct brcmf_if *ifp)
+{
+	struct brcmf_cfg80211_info *cfg;
+	int ret;
+
+	cfg = ifp->drvr->config;
+	if (!cfg->pi)
+		return 0;
+
+	/* may need to reconfigure gscan */
+	cfg->pi->sched = NULL;
+	if (cfg->pi->gscan) {
+		brcmf_dbg(SCAN, "reconfigure gscan\n");
+		ret = brcmf_pno_start_gscan(ifp, cfg->pi->gscan);
+		if (ret < 0) {
+			brcmf_err("gscan reconfiguration failed: err=%d\n", ret);
+			cfg80211_gscan_stopped_rtnl(cfg->wiphy);
+		}
+	} else {
+		brcmf_pno_clean(ifp);
+	}
+	return 0;
+}
+
 static int brcmf_pno_get_bucket_channels(struct brcmf_if *ifp,
 					 struct cfg80211_gscan_bucket *b,
 					 struct brcmf_pno_config_le *pno_cfg)
@@ -260,8 +318,7 @@ static int brcmf_pno_get_bucket_channels(struct brcmf_if *ifp,
 			goto done;
 		}
 		chan = b->channels[i].ch->hw_value;
-		brcmf_dbg(INFO, "[%d] Chan : %u\n",
-			  n_chan, chan);
+		brcmf_dbg(INFO, "[%d] Chan : %u\n", n_chan, chan);
 		pno_cfg->channel_list[n_chan++] = cpu_to_le16(chan);
 	}
 	if (b->band & NL80211_BUCKET_BAND_2GHZ) {
@@ -274,8 +331,7 @@ static int brcmf_pno_get_bucket_channels(struct brcmf_if *ifp,
 				goto done;
 			}
 			chan = band->channels[i].hw_value;
-			brcmf_dbg(INFO, "[%d] Chan : %u\n",
-				  n_chan, chan);
+			brcmf_dbg(INFO, "[%d] Chan : %u\n", n_chan, chan);
 			pno_cfg->channel_list[n_chan++] = cpu_to_le16(chan);
 		}
 	}
@@ -296,8 +352,7 @@ static int brcmf_pno_get_bucket_channels(struct brcmf_if *ifp,
 				goto done;
 			}
 			chan = band->channels[i].hw_value;
-			brcmf_dbg(INFO, "[%d] Chan : %u\n",
-				  n_chan, chan);
+			brcmf_dbg(INFO, "[%d] Chan : %u\n", n_chan, chan);
 			pno_cfg->channel_list[n_chan++] = cpu_to_le16(chan);
 		}
 	}
@@ -311,14 +366,31 @@ static int brcmf_pno_get_bucket_channels(struct brcmf_if *ifp,
 static int brcmf_pno_prepare_gscan(struct brcmf_if *ifp,
 				   struct cfg80211_gscan_request *req,
 				   struct brcmf_pno_config_le *pno_cfg,
-				   struct brcmf_gscan_bucket_config **buckets)
+				   struct brcmf_gscan_bucket_config **buckets,
+				   u32 *scan_freq)
 {
+	struct cfg80211_sched_scan_request *sr;
 	struct brcmf_gscan_bucket_config *fw_buckets;
 	struct cfg80211_gscan_bucket *bucket;
-	int i, err, chidx;
+	int i, err, chidx, n_fw_buckets;
+	u32 n_chan;
+	u16 chan;
+
+	sr = ifp_to_pno(ifp)->sched;
+	*scan_freq = req->base_period;
+	n_fw_buckets = req->n_buckets;
+	/*
+	 * scheduled scan uses an additional bucket in firmware
+	 * and the actual scan period must be the gcd.
+	 */
+	if (sr) {
+		*scan_freq = gcd(sr->scan_plans[0].interval, *scan_freq);
+		n_fw_buckets++;
+		brcmf_dbg(SCAN, "g-scan+scheduled: period=%u\n", *scan_freq);
+	}

 	*buckets = NULL;
-	fw_buckets = kcalloc(req->n_buckets, sizeof(*buckets[0]), GFP_KERNEL);
+	fw_buckets = kcalloc(n_fw_buckets, sizeof(*buckets[0]), GFP_KERNEL);
 	if (!fw_buckets)
 		return -ENOMEM;

@@ -331,14 +403,46 @@ static int brcmf_pno_prepare_gscan(struct brcmf_if *ifp,
 			goto fail;
 		}
 		fw_buckets[i].bucket_end_index = chidx - 1;
-		fw_buckets[i].bucket_freq_multiple = bucket->period / req->base_period;
+		fw_buckets[i].bucket_freq_multiple =
+			bucket->period / *scan_freq;
 		fw_buckets[i].repeat = cpu_to_le16(bucket->step_count);
-		fw_buckets[i].max_freq_multiple = cpu_to_le16(bucket->max_period / req->base_period);
-		fw_buckets[i].flag = bucket->report_events ^ NL80211_BUCKET_REPORT_NO_BATCH;
+		fw_buckets[i].max_freq_multiple =
+			cpu_to_le16(bucket->max_period / *scan_freq);
+		fw_buckets[i].flag =
+			bucket->report_events ^ NL80211_BUCKET_REPORT_NO_BATCH;
 		bucket++;
 	}
+
+	/* additional scheduled scan bucket */
+	if (sr) {
+		fw_buckets[i].bucket_freq_multiple =
+			sr->scan_plans[0].interval / *scan_freq;
+		n_chan = le32_to_cpu(pno_cfg->channel_num);
+		for (chidx = 0; chidx < sr->n_channels; chidx++) {
+			if (n_chan >= BRCMF_NUMCHANNELS) {
+				err = -ENOSPC;
+				goto fail;
+			}
+			chan = sr->channels[chidx]->hw_value;
+			brcmf_dbg(INFO, "[%d] Chan : %u\n", n_chan, chan);
+			pno_cfg->channel_list[n_chan++] = cpu_to_le16(chan);
+		}
+		pno_cfg->channel_num = cpu_to_le32(n_chan);
+		fw_buckets[i].bucket_end_index = n_chan - 1;
+	}
+
+	if (BRCMF_SCAN_ON()) {
+		brcmf_err("base period=%u\n", *scan_freq);
+		for (i = 0; i < n_fw_buckets; i++) {
+			brcmf_err("[%d] period %u max %u repeat %u flag %x idx %u\n",
+				  i, fw_buckets[i].bucket_freq_multiple,
+				  le16_to_cpu(fw_buckets[i].max_freq_multiple),
+				  fw_buckets[i].repeat, fw_buckets[i].flag,
+				  fw_buckets[i].bucket_end_index);
+		}
+	}
 	*buckets = fw_buckets;
-	return 0;
+	return n_fw_buckets;

 fail:
 	kfree(fw_buckets);
@@ -348,11 +452,25 @@ static int brcmf_pno_prepare_gscan(struct brcmf_if *ifp,
 int brcmf_pno_start_gscan(struct brcmf_if *ifp,
 			  struct cfg80211_gscan_request *req)
 {
+	struct brcmf_pno_info *pi;
 	struct brcmf_gscan_config *gscan_cfg;
 	struct brcmf_gscan_bucket_config *buckets;
 	struct brcmf_pno_config_le pno_cfg;
-	size_t gscan_cfg_size;
-	int err;
+	size_t gsz;
+	u32 scan_freq;
+	int err, n_buckets;
+
+	n_buckets = brcmf_pno_prepare_gscan(ifp, req, &pno_cfg, &buckets,
+					    &scan_freq);
+	if (n_buckets < 0)
+		return n_buckets;
+
+	gsz = sizeof(*gscan_cfg) + (n_buckets - 1) * sizeof(*buckets);
+	gscan_cfg = kzalloc(gsz, GFP_KERNEL);
+	if (!gscan_cfg) {
+		err = -ENOMEM;
+		goto free_buckets;
+	}

 	/* clean up everything */
 	err = brcmf_pno_clean(ifp);
@@ -362,31 +480,11 @@ int brcmf_pno_start_gscan(struct brcmf_if *ifp,
 	}

 	/* configure pno */
-	err = brcmf_pno_config(ifp, req->base_period / 1000,
-			       req->report_threshold_num_scans,
+	err = brcmf_pno_config(ifp, scan_freq, req->report_threshold_num_scans,
 			       req->max_ap_per_scan);
 	if (err < 0)
 		return err;

-	/* configure random mac */
-	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
-		err = brcmf_pno_set_random(ifp, req->mac, req->mac_mask);
-		if (err < 0)
-			return err;
-	}
-
-	err = brcmf_pno_prepare_gscan(ifp, req, &pno_cfg, &buckets);
-	if (err < 0)
-		return err;
-
-	gscan_cfg_size = sizeof(*gscan_cfg) +
-			 (req->n_buckets - 1) * sizeof(*buckets);
-	gscan_cfg = kzalloc(gscan_cfg_size, GFP_KERNEL);
-	if (!gscan_cfg) {
-		err = -ENOMEM;
-		goto free_buckets;
-	}
-
 	err = brcmf_pno_channel_config(ifp, &pno_cfg);
 	if (err < 0)
 		goto free_gscan;
@@ -401,19 +499,35 @@ int brcmf_pno_start_gscan(struct brcmf_if *ifp,

 	gscan_cfg->flags = BRCMF_GSCAN_CFG_ALL_BUCKETS_IN_1ST_SCAN;

-	gscan_cfg->count_of_channel_buckets = req->n_buckets;
+	gscan_cfg->count_of_channel_buckets = n_buckets;
 	memcpy(&gscan_cfg->bucket[0], buckets,
-	       req->n_buckets * sizeof(*buckets));
+	       n_buckets * sizeof(*buckets));

-	err = brcmf_fil_iovar_data_set(ifp, "pfn_gscan_cfg", gscan_cfg,
-				       gscan_cfg_size);
+	err = brcmf_fil_iovar_data_set(ifp, "pfn_gscan_cfg", gscan_cfg, gsz);
 	if (err < 0)
 		goto free_gscan;

+	/* configure random mac */
+	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+		err = brcmf_pno_set_random(ifp, req->mac, req->mac_mask);
+		if (err < 0)
+			return err;
+	}
+
+	pi = ifp_to_pno(ifp);
+	if (pi->sched)
+		brcmf_pno_config_ssids(ifp, pi->sched);
+
 	/* Enable the PNO */
 	err = brcmf_fil_iovar_int_set(ifp, "pfn", 1);
-	if (err < 0)
+	if (err < 0) {
 		brcmf_err("PNO enable failed!! ret=%d\n", err);
+		goto free_gscan;
+	}
+
+	/* keep reference of request */
+	pi->gscan = req;
+
 free_gscan:
 	kfree(gscan_cfg);
 free_buckets:
@@ -421,3 +535,53 @@ int brcmf_pno_start_gscan(struct brcmf_if *ifp,
 	return err;
 }

+int brcmf_pno_stop_gscan(struct brcmf_if *ifp)
+{
+	struct brcmf_cfg80211_info *cfg;
+	int ret;
+
+	cfg = ifp->drvr->config;
+	if (!cfg->pi)
+		return 0;
+
+	cfg->pi->gscan = NULL;
+	if (cfg->pi->sched) {
+		brcmf_dbg(SCAN, "reconfigure scheduled scan\n");
+		ret = brcmf_pno_start_sched_scan(ifp, cfg->pi->sched);
+		if (ret < 0) {
+			brcmf_err("scheduled scan reconfiguration failed: err=%d\n",
+				  ret);
+			cfg80211_sched_scan_stopped_rtnl(cfg->wiphy);
+		}
+	} else {
+		brcmf_pno_clean(ifp);
+	}
+	return 0;
+}
+
+int brcmf_pno_attach(struct brcmf_if *ifp)
+{
+	struct brcmf_pno_info *pi;
+
+	brcmf_err("enter\n");
+	pi = kzalloc(sizeof(*pi), GFP_KERNEL);
+	if (!pi)
+		return -ENOMEM;
+
+	ifp_to_pno(ifp) = pi;
+	return 0;
+}
+
+void brcmf_pno_detach(struct brcmf_if *ifp)
+{
+	struct brcmf_cfg80211_info *cfg;
+	struct brcmf_pno_info *pi;
+
+	brcmf_err("enter\n");
+	cfg = ifp->drvr->config;
+	pi = cfg->pi;
+	cfg->pi = NULL;
+
+	kfree(pi);
+}
+
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
index 06ad3b0..5690ac2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.h
@@ -38,6 +38,13 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			       struct cfg80211_sched_scan_request *req);

 /**
+ * brcmf_pno_stop_sched_scan - terminate scheduled scan on device.
+ *
+ * @ifp: interface object used.
+ */
+int brcmf_pno_stop_sched_scan(struct brcmf_if *ifp);
+
+/**
  * brcmf_pno_start_gscan - initiate gscan on device.
  *
  * @ifp: interface object used.
@@ -46,4 +53,25 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 int brcmf_pno_start_gscan(struct brcmf_if *ifp,
 			  struct cfg80211_gscan_request *req);

+/**
+ * brcmf_pno_stop_gscan - terminate gscan on device.
+ *
+ * @ifp: interface object used.
+ */
+int brcmf_pno_stop_gscan(struct brcmf_if *ifp);
+
+/**
+ * brcmf_pno_attach - allocate and attach module information.
+ *
+ * @ifp: interface object used.
+ */
+int brcmf_pno_attach(struct brcmf_if *ifp);
+
+/**
+ * brcmf_pno_detach - detach and free module information.
+ *
+ * @ifp: interface object used.
+ */
+void brcmf_pno_detach(struct brcmf_if *ifp);
+
 #endif /* _BRCMF_PNO_H */
--
1.9.1
