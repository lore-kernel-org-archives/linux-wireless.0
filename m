Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571ABC282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 10:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 287B420844
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 10:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ICEB1nq7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iBIyPbjH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbfBEKFk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 05:05:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49876 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728135AbfBEKFh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 05:05:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7CE296085F; Tue,  5 Feb 2019 10:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549361136;
        bh=icPM7+eUibWonqQfnjS+Scxa3zZsbuka3m8Zqy6FfB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICEB1nq7D5IoxLqfbIC93Kpi1TaYWGArRHgRPUfvX2gEF7uK5mPrIQxUlQRN3tYNI
         nzzqtsfeC3qj6QwkWsbFVkn2Zc+7d/ypinDMGXYlbt5XClv0ilFno9Iftg6quU+SdR
         /h9nDQKv86GI39kA+TqXR4GGp6o284QDs5W8SCBs=
Received: from che-swdbs-01.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5F59F6074F;
        Tue,  5 Feb 2019 10:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549361135;
        bh=icPM7+eUibWonqQfnjS+Scxa3zZsbuka3m8Zqy6FfB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBIyPbjHBjYdIxiWDX2PNWia/BgTjZ7Ku5OSM0BPVChvBeIp8sRKyUsAzFY2vJXRr
         Avk1nb0w31BBQNRMT/51pgVR4FOcaopYOoyJ/BYzTy52Kpxj0YnWtZbP3btfSSMzjt
         MLGwcH+Q85jSAg+agT6z1ubNEMCttxu4loM2qPZc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5F59F6074F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv2 2/2] mac80211: Implement API to configure station specific rssi threshold
Date:   Tue,  5 Feb 2019 15:36:21 +0530
Message-Id: <1549361181-6237-3-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1549361181-6237-1-git-send-email-tamizhr@codeaurora.org>
References: <1549361181-6237-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Implement set_sta_mon_rssi_config API to configure station
specific rssi threshold value to monitor change in connected
station's signal strength. RSSI low and high threshold values
will be calculated as per the station's current signal strength,
if the configuration needs to be a fixed threshold then the user
given value will be chosen as low and high threshold.

And this patch triggers cfg80211_sta_mon_rssi_notify with the
corresponding event when station signal goes out of configured threshold.
It uses rx data signal to check against rssi threshold configured by the user.
And update the lower and upper RSSI threshold for the station if it is not
configured as a fixed threshold.

This event will be useful for the application like steering to take
decision on any station depends on its current link quality.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h  |    7 ++++
 net/mac80211/cfg.c      |  105 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c       |   56 ++++++++++++++++++++++++-
 net/mac80211/sta_info.c |    1 +
 net/mac80211/sta_info.h |   30 ++++++++++++++
 5 files changed, 198 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index de866a7..007850d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -858,6 +858,13 @@ enum mac80211_rate_control_flags {
 };
 
 
+/*
+ * How many frames need to have been used in average station's
+ * signal strength before checking against the threshold
+ */
+#define IEEE80211_STA_SIGNAL_AVE_MIN_COUNT	4
+
+
 /* there are 40 bytes if you don't need the rateset to be kept */
 #define IEEE80211_TX_INFO_DRIVER_DATA_SIZE 40
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d65aa01..83f0472 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3889,6 +3889,110 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return drv_abort_pmsr(local, sdata, request);
 }
 
+void sta_mon_rssi_config_free(struct sta_info *sta)
+{
+	if (sta->rssi_config) {
+		kfree_rcu(sta->rssi_config, rcu_head);
+		sta->rssi_config = NULL;
+	}
+}
+
+void ieee80211_update_rssi_config(struct sta_info *sta)
+{
+	s32 last;
+	u32 hyst;
+	int i, n;
+
+	if (!sta->rssi_config || sta->rssi_config->fixed_thold)
+		return;
+
+	if (!sta->rssi_config->last_value)
+		sta->rssi_config->last_value =
+			-ewma_signal_read(&sta->rx_stats_avg.signal);
+
+	last = sta->rssi_config->last_value;
+	hyst = sta->rssi_config->hyst;
+	n = sta->rssi_config->n_thresholds;
+
+	for (i = 0; i < n; i++)
+		if (last < sta->rssi_config->thresholds[i])
+			break;
+
+	sta->rssi_config->low =
+		i > 0 ? (sta->rssi_config->thresholds[i - 1] - hyst) : S32_MIN;
+	sta->rssi_config->high =
+		i < n ? (sta->rssi_config->thresholds[i] + hyst - 1) : S32_MAX;
+}
+
+static int
+ieee80211_set_sta_mon_rssi_config(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  const u8 *mac_addr,
+				  const struct cfg80211_sta_mon *sta_mon_cfg)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_mon_rssi_config *rssi_config;
+	struct sta_info *sta;
+	int ret = 0;
+
+	mutex_lock(&local->sta_mtx);
+	rcu_read_lock();
+
+	if (mac_addr) {
+		sta = sta_info_get_bss(sdata, mac_addr);
+		if (!sta) {
+			ret = -ENOENT;
+			goto out;
+		}
+
+		if (sta_mon_cfg->fixed_thold &&
+		    sta_mon_cfg->n_rssi_tholds > 2) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		rssi_config = kzalloc(sizeof(*rssi_config) +
+				      sta_mon_cfg->n_rssi_tholds * sizeof(s32),
+				      GFP_KERNEL);
+		if (!rssi_config) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		rssi_config->hyst = sta_mon_cfg->rssi_hyst;
+		if (sta_mon_cfg->fixed_thold) {
+			sta_mon_rssi_config_free(sta);
+			if (sta_mon_cfg->n_rssi_tholds == 1) {
+				rssi_config->low = sta_mon_cfg->rssi_tholds[0];
+				rssi_config->high = sta_mon_cfg->rssi_tholds[0];
+			} else {
+				rssi_config->low = sta_mon_cfg->rssi_tholds[0];
+				rssi_config->high = sta_mon_cfg->rssi_tholds[1];
+			}
+			rssi_config->fixed_thold = sta_mon_cfg->fixed_thold;
+			rssi_config->hyst = sta_mon_cfg->rssi_hyst;
+			rssi_config->n_thresholds = sta_mon_cfg->n_rssi_tholds;
+			sta->rssi_config = rssi_config;
+		} else {
+			sta_mon_rssi_config_free(sta);
+			rssi_config->n_thresholds = sta_mon_cfg->n_rssi_tholds;
+			memcpy(rssi_config->thresholds,
+			       sta_mon_cfg->rssi_tholds,
+			       rssi_config->n_thresholds * sizeof(s32));
+			rssi_config->hyst = sta_mon_cfg->rssi_hyst;
+			sta->rssi_config = rssi_config;
+			/* Calculate low and high RSSI thresholds */
+			ieee80211_update_rssi_config(sta);
+		}
+	}
+
+out:
+	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
+	return ret;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3986,4 +4090,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
 	.start_pmsr = ieee80211_start_pmsr,
 	.abort_pmsr = ieee80211_abort_pmsr,
+	.set_sta_mon_rssi_config = ieee80211_set_sta_mon_rssi_config,
 };
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bb4d71e..6c10a51 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1695,6 +1695,57 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	return RX_CONTINUE;
 }
 
+static void ieee80211_sta_rx_signal_thold_check(struct ieee80211_rx_data *rx)
+{
+	struct sta_info *sta = rx->sta;
+	struct ieee80211_bss_conf *bss_conf = &rx->sdata->vif.bss_conf;
+	bool rssi_cross =  false;
+
+	if (!wiphy_ext_feature_isset(rx->local->hw.wiphy,
+				NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG))
+		return;
+
+	if (!sta->rssi_config)
+		return;
+
+	rcu_read_lock();
+	sta->rssi_config->count_rx_signal++;
+	if (sta->rssi_config->count_rx_signal <
+	    IEEE80211_STA_SIGNAL_AVE_MIN_COUNT)
+		return;
+
+	if (sta->rssi_config->low && bss_conf->enable_beacon) {
+		int last_event = sta->rssi_config->last_value;
+		int sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
+		int low = sta->rssi_config->low;
+		int high = sta->rssi_config->high;
+
+		if (sig < low &&
+		    (last_event == 0 || last_event >= low)) {
+			sta->rssi_config->last_value = sig;
+			cfg80211_sta_mon_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+				sig, GFP_ATOMIC);
+			rssi_cross = true;
+		} else if (sig > high &&
+			   (last_event == 0 || last_event <= high)) {
+			sta->rssi_config->last_value = sig;
+			cfg80211_sta_mon_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+				sig, GFP_ATOMIC);
+			rssi_cross = true;
+		}
+	}
+
+	if (rssi_cross) {
+		ieee80211_update_rssi_config(sta);
+		rssi_cross = false;
+	}
+	rcu_read_unlock();
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
@@ -1750,6 +1801,7 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		sta->rx_stats.last_signal = status->signal;
 		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
+		ieee80211_sta_rx_signal_thold_check(rx);
 	}
 
 	if (status->chains) {
@@ -4193,9 +4245,11 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	/* statistics part of ieee80211_rx_h_sta_process() */
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		stats->last_signal = status->signal;
-		if (!fast_rx->uses_rss)
+		if (!fast_rx->uses_rss) {
 			ewma_signal_add(&sta->rx_stats_avg.signal,
 					-status->signal);
+			ieee80211_sta_rx_signal_thold_check(rx);
+		}
 	}
 
 	if (status->chains) {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 11f0589..db5e3b6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1020,6 +1020,7 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
+	sta_mon_rssi_config_free(sta);
 
 	cleanup_single_sta(sta);
 }
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 71f7e49..b8af534 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -427,6 +427,33 @@ struct ieee80211_sta_rx_stats {
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
 };
 
+/**
+ * struct sta_mon_rssi_config - Monitor station's signal strength
+ * @rcu_head: rcu head for freeing structure
+ * @n_rssi_tholds: Number of thresholds passed by user
+ * @low: RSSI lower threshold for this station, a zero value implies
+ *	disabled
+ * @high: RSSI upper threshold for this station
+ * @hyst: RSSI hysteresis for this station
+ * @last_value: Last RSSI value for this station triggered the
+ *	RSSI cross event
+ * @fixed_thold - Indicate whether to use fixed thresholds limit or not
+ * @threholds: RSSI threshold limit passed by the user
+ * @count_rx_signal: Number of data frames used in averaging station signal.
+ *	This can be used to avoid generating less reliable station rssi cross
+ *	events that would be based only on couple of received frames
+ */
+struct sta_mon_rssi_config {
+	struct rcu_head rcu_head;
+	int n_thresholds;
+	s32 low, high;
+	u32 hyst;
+	s32 last_value;
+	u8 fixed_thold;
+	unsigned int count_rx_signal;
+	s32 thresholds[0];
+};
+
 /*
  * The bandwidth threshold below which the per-station CoDel parameters will be
  * scaled to be more lenient (to prevent starvation of slow stations). This
@@ -623,6 +650,7 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	struct sta_mon_rssi_config *rssi_config;
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
@@ -760,6 +788,7 @@ int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
 			  const u8 *addr);
 int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr);
+void sta_mon_rssi_config_free(struct sta_info *sta);
 
 void sta_info_recalc_tim(struct sta_info *sta);
 
@@ -792,6 +821,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 u8 sta_info_tx_streams(struct sta_info *sta);
+void ieee80211_update_rssi_config(struct sta_info *sta);
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
-- 
1.7.9.5

