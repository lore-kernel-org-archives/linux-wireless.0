Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3C5C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 06:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E37D20818
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 06:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="itHzoGJv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JQXeMHTc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfBVGer (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 01:34:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55476 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfBVGer (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 01:34:47 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CA3B4608CF; Fri, 22 Feb 2019 06:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550817285;
        bh=jk0wCZf4+AUePyi87wsRB51ekSiDUgZBRU6k5VFozk8=;
        h=From:To:Cc:Subject:Date:From;
        b=itHzoGJv0BDmSZVgPIK7PcKbQs2++nmqi8e28AIY8zqO1tP8oIovweBJyImhSwGFR
         qkXZ+03IucDnR5xJyR4Cka+73YZd5/dpwd4M5otV7ffDhlmrZ2b1RPhYyvR/3Gv4Hn
         veJAxHVYoxrmgqYXq1tOIog/FuYp1gI7fzETdjUY=
Received: from checstex0244823-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bpothuno@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 302A36079B;
        Fri, 22 Feb 2019 06:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550817284;
        bh=jk0wCZf4+AUePyi87wsRB51ekSiDUgZBRU6k5VFozk8=;
        h=From:To:Cc:Subject:Date:From;
        b=JQXeMHTcynoEc/wPSVCq/tDRUpUAVUGj9DSTTj3VFYG+QykHGULUhLShvAh1ZzM/I
         F5Mn4AN2FqHzuf1l+RcdN8nYBUXVlRT/BbXLRo3tOAqKKU55zrf37CPlxNF6eyUcXs
         UUnccb8pjYFlC1/U3iHm2d2XmP9YyWH25m5OzGtE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 302A36079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bpothuno@codeaurora.org
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc:     ath10k@lists.infradead.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v3 2/3] mac80211: store tx power value from user to station
Date:   Fri, 22 Feb 2019 12:04:36 +0530
Message-Id: <1550817276-18582-1-git-send-email-bpothuno@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ashok Raj Nagarajan <arnagara@codeaurora.org>

This patch introduce a new driver callback drv_sta_set_txpwr. This API will
copy the transmit power value passed from user space and call the driver
callback to set the tx power for the station.

Co-developed-by: Balaji Pothunoori <bpothuno@codeaurora.org>
Signed-off-by: Ashok Raj Nagarajan <arnagara@codeaurora.org>
Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
---
v2: add txpwr structure
    added tx power set type in trace event
v3: updated kernel-doc for ieee80211_sta_txpwr
    structure and rebased

 include/net/mac80211.h    | 22 ++++++++++++++++++++++
 net/mac80211/cfg.c        |  9 +++++++++
 net/mac80211/driver-ops.c | 21 +++++++++++++++++++++
 net/mac80211/driver-ops.h |  5 +++++
 net/mac80211/trace.h      | 30 ++++++++++++++++++++++++++++++
 5 files changed, 87 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 97aed7b..74aad69 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1884,6 +1884,24 @@ struct ieee80211_sta_rates {
 };
 
 /**
+ * struct ieee80211_sta_txpwr - station txpower configuration
+ *
+ * Used to configure txpower for station.
+ *
+ * @power: indicates the tx power, in dBm, to be used when sending data frames
+ *	to the STA.
+ * @type: In particular if TPC %type is NL80211_TX_POWER_LIMITED then tx power
+ *	will be less than or equal to specified from userspace, whereas if TPC
+ *	%type is NL80211_TX_POWER_AUTOMATIC then it indicates default tx power.
+ *	NL80211_TX_POWER_FIXED is not a valid configuration option for
+ *	per peer TPC.
+ */
+struct ieee80211_sta_txpwr {
+		s16 power;
+		enum nl80211_tx_power_setting type;
+};
+
+/**
  * struct ieee80211_sta - station table entry
  *
  * A station table entry represents a station we are possibly
@@ -1969,6 +1987,7 @@ struct ieee80211_sta {
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
 	u16 max_tid_amsdu_len[IEEE80211_NUM_TIDS];
+	struct ieee80211_sta_txpwr txpwr;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
@@ -3785,6 +3804,9 @@ struct ieee80211_ops {
 #endif
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
+	int (*sta_set_txpwr)(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta);
 	int (*sta_state)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta,
 			 enum ieee80211_sta_state old_state,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d65aa01..6a8b4a4 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1417,6 +1417,15 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (params->listen_interval >= 0)
 		sta->listen_interval = params->listen_interval;
 
+	if (params->sta_modify_mask & STATION_PARAM_APPLY_STA_TXPOWER) {
+		sta->sta.txpwr.type = params->txpwr.type;
+		if (params->txpwr.type == NL80211_TX_POWER_LIMITED)
+			sta->sta.txpwr.power = params->txpwr.power;
+		ret = drv_sta_set_txpwr(local, sdata, sta);
+		if (ret)
+			return ret;
+	}
+
 	if (params->supported_rates) {
 		ieee80211_parse_bitrates(&sdata->vif.bss_conf.chandef,
 					 sband, params->supported_rates,
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index bb886e7..839c002 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -138,6 +138,27 @@ int drv_sta_state(struct ieee80211_local *local,
 	return ret;
 }
 
+__must_check
+int drv_sta_set_txpwr(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata,
+		      struct sta_info *sta)
+{
+	int ret = -EOPNOTSUPP;
+
+	might_sleep();
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_sta_set_txpwr(local, sdata, &sta->sta);
+	if (local->ops->sta_set_txpwr)
+		ret = local->ops->sta_set_txpwr(&local->hw, &sdata->vif,
+						&sta->sta);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 void drv_sta_rc_update(struct ieee80211_local *local,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct ieee80211_sta *sta, u32 changed)
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ba3c07b..2cc5bb2 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -529,6 +529,11 @@ int drv_sta_state(struct ieee80211_local *local,
 		  enum ieee80211_sta_state old_state,
 		  enum ieee80211_sta_state new_state);
 
+__must_check
+int drv_sta_set_txpwr(struct ieee80211_local *local,
+		      struct ieee80211_sub_if_data *sdata,
+		      struct sta_info *sta);
+
 void drv_sta_rc_update(struct ieee80211_local *local,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct ieee80211_sta *sta, u32 changed);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 35ea0dc..c86e42a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -828,6 +828,36 @@ TRACE_EVENT(drv_sta_state,
 	)
 );
 
+TRACE_EVENT(drv_sta_set_txpwr,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+
+	TP_ARGS(local, sdata, sta),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(s16, txpwr)
+		__field(u8, type)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->txpwr = sta->txpwr.power;
+		__entry->type = sta->txpwr.type;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " txpwr: %d type %d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG,
+		__entry->txpwr,  __entry->type
+	)
+);
+
 TRACE_EVENT(drv_sta_rc_update,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.7.4

