Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8095CC71133
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40C5F214C3
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:59:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="APWcxBf3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="E8c40+NB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40C5F214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbeJPBpR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 21:45:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38898 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbeJPBpQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 21:45:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BFBF3613FC; Mon, 15 Oct 2018 17:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539626339;
        bh=YSctTWKfkxGGejVgAiLyxyhOLpDkY8zZdYnEyRrw57s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APWcxBf36MzmM8/5SZRudfKQxDbj4NLq2FLL77d2XLGTuPVqFD07RxcUktwOC37nO
         kt8cVjA3v8OZN5wBY+MuNquwwjxGPaFRxlzYwATKQ8ziG4gurAbuEoB4aCBDkE9dns
         K1zu9IZUF1KCW5FLK/rsXZsqs9FJSipvVpn5p5AU=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B992F61324;
        Mon, 15 Oct 2018 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539626338;
        bh=YSctTWKfkxGGejVgAiLyxyhOLpDkY8zZdYnEyRrw57s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8c40+NBlg1qEhsO9YBsSkhD8pLUICFo+n+DlKYYVJuq/yTMClmlDefkp+AXNO4Yu
         1rxDxvQboBqIJJ+IFjb9RjKsk9FHuh1fy0rGuRwXSpBxvHwLh2hJvwkAH4dCV6/Tjt
         +aKTyh0c+XLYFzsZ+6D5TBEJGtZWn4TFOyHjqc4M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B992F61324
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 3/3] mac80211: Implement functionality to monitor station's signal stregnth
Date:   Mon, 15 Oct 2018 23:27:30 +0530
Message-Id: <1539626250-769-4-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Triggers cfg80211_sta_mon_rssi_notify with the corresponding event when
station signal goes out of configured threshold. It uses rx data signal
to check against rssi threshold configured by the user. And update
the lower and upper RSSI threshold for the station if it is not
configured as a fixed threshold.
This event will be useful for the application like steering to take
decision on any station depends on its current link quality.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h  |    7 +++++++
 net/mac80211/cfg.c      |    2 +-
 net/mac80211/rx.c       |   51 ++++++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/sta_info.h |    5 +++++
 4 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71985e9..355e522 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -849,6 +849,13 @@ enum mac80211_rate_control_flags {
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
index 72d2b07..be386ff 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3856,7 +3856,7 @@ void sta_mon_rssi_config_free(struct sta_info *sta)
 	sta->n_rssi_tholds = 0;
 }
 
-static void ieee80211_update_rssi_config(struct sta_info *sta)
+void ieee80211_update_rssi_config(struct sta_info *sta)
 {
 	s32 last;
 	u32 hyst;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3bd3b57..1afef40 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1681,6 +1681,52 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
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
+	sta->count_rx_signal++;
+	if (sta->count_rx_signal < IEEE80211_STA_SIGNAL_AVE_MIN_COUNT)
+		return;
+
+	if (sta->rssi_low && bss_conf->enable_beacon) {
+		int last_event =
+			sta->last_rssi_event_value;
+		int sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
+		int low = sta->rssi_low;
+		int high = sta->rssi_high;
+
+		if (sig < low &&
+		    (last_event == 0 || last_event >= low)) {
+			sta->last_rssi_event_value = sig;
+			cfg80211_sta_mon_rssi_notify(
+				rx->sdata->dev, sta->addr,
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+				sig, GFP_ATOMIC);
+			rssi_cross = true;
+		} else if (sig > high &&
+			   (last_event == 0 || last_event <= high)) {
+			sta->last_rssi_event_value = sig;
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
+}
+
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 {
@@ -1736,6 +1782,7 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *pubsta, u8 tid)
 	if (!(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		sta->rx_stats.last_signal = status->signal;
 		ewma_signal_add(&sta->rx_stats_avg.signal, -status->signal);
+		ieee80211_sta_rx_signal_thold_check(rx);
 	}
 
 	if (status->chains) {
@@ -4177,9 +4224,11 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
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
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index acbad98..ebf5cb0 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -493,6 +493,9 @@ struct sta_mon_rssi_config {
  * @rssi_hyst: RSSI hysteresis for this station
  * @last_rssi_event_value: Last RSSI value for this station triggered the
  *	RSSI cross event.
+ * @count_rx_signal: Number of data frames used in averaging station signal.
+ *	This can be used to avoid generating less reliable station rssi cross
+ *	events that would be based only on couple of received frames.
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -600,6 +603,7 @@ struct sta_info {
 	s32 rssi_high;
 	u32 rssi_hyst;
 	s32 last_rssi_event_value;
+	unsigned int count_rx_signal;
 
 	/* keep last! */
 	struct ieee80211_sta sta;
@@ -771,6 +775,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 u8 sta_info_tx_streams(struct sta_info *sta);
+void ieee80211_update_rssi_config(struct sta_info *sta);
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta);
-- 
1.7.9.5

