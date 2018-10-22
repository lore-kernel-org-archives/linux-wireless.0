Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A355C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B7F120652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R/cUCKof";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UL6oX+ZE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B7F120652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbeJWCP5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:15:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38190 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728658AbeJWCP5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 22:15:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D700C61308; Mon, 22 Oct 2018 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230985;
        bh=vY0Ljd7GkHRP3ORYIApugAL7OPfpoYWms2T+Yz9ujK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/cUCKofk4KkF5VxPdcrzr8XZZ/EYmt0aRDyTpjxfsT9S85i1z25DX2M8ANh4+Hnj
         qGno+e2d2auEozh74bz+CMoWrYygEy4KHofOamwZ16PvEwdR+XlwE72+3z6JTKIJV9
         d7EGkEnkVT5YyHF4Nsp5Sj0q2skj8zF/6fOVaQbA=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3458C612F6;
        Mon, 22 Oct 2018 17:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230984;
        bh=vY0Ljd7GkHRP3ORYIApugAL7OPfpoYWms2T+Yz9ujK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UL6oX+ZEqkongji0jkGWMGL2nRLLzXXL7fvPZQREpRUrTTpCPCUHiqcoCz6NOFmNg
         MD86P5T4jmiGUA/PZ0IUeegSCHVHeUhGC0BWQxjJ5vVrFmJt3XOFN7W2iSLay1EEVa
         iYpcRKblRcElA/KeX2cPQ+qo6wf9s5gXE87UFj6U=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3458C612F6
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 3/4] mac80211: Add api to support configuring TID specific configuration
Date:   Mon, 22 Oct 2018 23:25:17 +0530
Message-Id: <1540230918-27712-4-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Implement drv_set_tid_conf api to allow TID specific
retry count for data frames and aggregation enable/disable
configuration. If the retry_short and/or
retry_long value is default (-1), use the nedev wide retry
configuration for the station. This per-TID configuration
will be applied for all the connected stations when MAC is NULL.
enum ieee80211_tid_conf_change introduced to notify the the driver
about which configuration parameter got changed in
ieee80211_tid_conf structure.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h    |   40 +++++++++++++++++++++++++
 net/mac80211/cfg.c        |   71 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h |   16 ++++++++++
 net/mac80211/trace.h      |   34 ++++++++++++++++++++++
 4 files changed, 161 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b6cc3e33..7fa7e25 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1478,6 +1478,35 @@ struct ieee80211_channel_switch {
 	u8 count;
 };
 
+/*
+ * enum ieee80211_tid_conf_change - TID change configuration notification flags
+ *
+ * These flags are used with the set_tid_conf() callback
+ * to indicate which TID configuration parameter changed.
+ *
+ * @TID_RETRY_CONF_CHANGED: retry configuration changed.
+ * @TID_AGGR_CONF_CHANGED: Aggregation config changed for the TID.
+ */
+enum ieee80211_tid_conf_change {
+	TID_RETRY_CONF_CHANGED		= BIT(0),
+	TID_AGGR_CONF_CHANGED		= BIT(1),
+};
+
+/*
+ * struct ieee80211_tid_conf - holds the tid configiuration data
+ * The information provided in the structure is required for the driver
+ * to configure TID specific configuration.
+ * @tid: TID number
+ * @retry_short: retry count value
+ * @retry_long: retry count value
+ * @aggr: enable/disable aggregation
+ */
+struct ieee80211_tid_conf {
+	u8 tid;
+	int retry_short;
+	int retry_long;
+	bool aggr;
+};
 /**
  * enum ieee80211_vif_flags - virtual interface flags
  *
@@ -1565,6 +1594,8 @@ struct ieee80211_vif {
 
 	bool txqs_stopped[IEEE80211_NUM_ACS];
 
+	struct ieee80211_tid_conf tid_conf;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -3632,6 +3663,10 @@ enum ieee80211_reconfig_type {
  *	level. Drivers mplementing this callback must take care of setting NoAck
  *	policy in QOS control field based on the configured TID bitmap.
  *	This callback may sleep.
+ * @set_tid_conf: TID specific configuration like number of retries for
+ *	the given TID. Apply this configuration for a particular station when
+ *	@sta is non-NULL. When @sta is NULL, the configuration will be for all
+ *	the connected clients in the vif. This callback may sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3924,6 +3959,11 @@ struct ieee80211_ops {
 	int (*set_noack_tid_bitmap)(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    struct ieee80211_sta *sta, int noack_map);
+	int (*set_tid_conf)(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta,
+			    struct ieee80211_tid_conf *tid_conf,
+			    u8 changed);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 02e6d49..786b561 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3889,6 +3889,75 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return drv_get_ftm_responder_stats(local, sdata, ftm_stats);
 }
 
+static int ieee80211_set_data_retry_count(struct wiphy *wiphy,
+					  struct net_device *dev,
+					  const u8 *peer, u8 tid,
+					  int retry_short, int retry_long)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+	int ret;
+
+	if (!sdata->local->ops->set_tid_conf)
+		return -EOPNOTSUPP;
+
+	sdata->vif.tid_conf.tid = tid;
+	sdata->vif.tid_conf.retry_short = retry_short;
+	sdata->vif.tid_conf.retry_long = retry_long;
+
+	if (!peer)
+		return drv_set_tid_conf(sdata->local, sdata, NULL,
+					TID_RETRY_CONF_CHANGED);
+
+	mutex_lock(&sdata->local->sta_mtx);
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta) {
+		mutex_unlock(&sdata->local->sta_mtx);
+		return -ENOENT;
+	}
+
+	ret = drv_set_tid_conf(sdata->local, sdata, &sta->sta,
+			       TID_RETRY_CONF_CHANGED);
+
+	mutex_unlock(&sdata->local->sta_mtx);
+	return ret;
+}
+
+static int ieee80211_set_tid_aggr_config(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 const u8 *peer, u8 tid,
+					 bool aggr)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+	int ret;
+
+	if (!sdata->local->ops->set_tid_conf)
+		return -EOPNOTSUPP;
+
+	sdata->vif.tid_conf.tid = tid;
+	sdata->vif.tid_conf.aggr = aggr;
+
+	if (!peer)
+		return drv_set_tid_conf(sdata->local, sdata, NULL,
+					TID_AGGR_CONF_CHANGED);
+
+	mutex_lock(&sdata->local->sta_mtx);
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta) {
+		mutex_unlock(&sdata->local->sta_mtx);
+		return -ENOENT;
+	}
+
+	ret = drv_set_tid_conf(sdata->local, sdata, &sta->sta,
+			       TID_AGGR_CONF_CHANGED);
+
+	mutex_unlock(&sdata->local->sta_mtx);
+	return ret;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3984,4 +4053,6 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
 	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
+	.set_data_retry_count = ieee80211_set_data_retry_count,
+	.set_tid_aggr_config = ieee80211_set_tid_aggr_config,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ed9bd59..e717cc0 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1300,4 +1300,20 @@ static inline int drv_set_noack_tid_bitmap(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_set_tid_conf(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_sta *sta,
+				   u8 changed)
+{
+	int ret;
+
+	might_sleep();
+	trace_drv_set_tid_conf(local, sdata, sta, changed);
+	ret = local->ops->set_tid_conf(&local->hw, &sdata->vif, sta,
+				       &sdata->vif.tid_conf, changed);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index e0e6c9a..5aed6ad 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2648,6 +2648,40 @@ struct trace_switch_entry {
 	)
 );
 
+TRACE_EVENT(drv_set_tid_conf,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 u8 changed),
+
+	TP_ARGS(local, sdata, sta, changed),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, tid)
+		__field(int, retry_short)
+		__field(int, retry_long)
+		__field(u8, changed)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->tid = sdata->vif.tid_conf.tid;
+		__entry->retry_short = sdata->vif.tid_conf.retry_short;
+		__entry->retry_long = sdata->vif.tid_conf.retry_long;
+		__entry->changed = changed;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT STA_PR_FMT " changed: %#x",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->changed
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.9.5

