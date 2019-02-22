Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD043C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 05:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91527207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 05:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HqbQm9Nm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Hzc5n/lI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfBVFed (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 00:34:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfBVFed (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 00:34:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 186A460A08; Fri, 22 Feb 2019 05:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550813672;
        bh=Krne235bOX7YMt9umG+m6qUc/oVxUCoCkBbzXRO7xos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HqbQm9NmJHR5cjxwKQPpNPmNSfF7ZlkRTpI0hqw4RPCwbFiCCPW8Pj94nFxk8k5SS
         rJzaAh2OcRJu9S4PpMiXD3scarYmg4+WBRGQ4aZbOsPNrjloygUF1kQwtbN6/z7C62
         LNBCIu5Hfv1adtFF1Ea6D33KdxSVWY93wosiLNvU=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E047660A04;
        Fri, 22 Feb 2019 05:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550813671;
        bh=Krne235bOX7YMt9umG+m6qUc/oVxUCoCkBbzXRO7xos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hzc5n/lIpC2jkLHIQkiwozSx/kesC38F30iF9D++zBPoCLEchuDeO92jLo+EwIITg
         a0Er02CeOpylnP5ddlsJnTBPxnuKo6D7amUkwrL24iFyK4kkFHT6TNxDvcs2vPIte4
         3fflB2zxmcmmJZniaf0CcMBxUtzJwm/jsSwPCBR4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E047660A04
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv2 6/9] mac80211: Add api to support configuring TID specific configuration
Date:   Fri, 22 Feb 2019 11:02:31 +0530
Message-Id: <1550813554-11581-7-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
References: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Implement drv_set_tid_config api to allow TID specific
configuration. This per-TID configuration
will be applied for all the connected stations when MAC is NULL.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h    | 35 +++++++++++++++++++++++++++++++++++
 net/mac80211/cfg.c        | 28 ++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 15 +++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 97aed7b..dda30e9a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1552,6 +1552,8 @@ enum ieee80211_vif_flags {
 	IEEE80211_VIF_GET_NOA_UPDATE		= BIT(3),
 };
 
+#define IEEE80211_TID_MAX	8
+
 /**
  * struct ieee80211_vif - per-interface data
  *
@@ -1589,6 +1591,11 @@ enum ieee80211_vif_flags {
  * @txq: the multicast data TX queue (if driver uses the TXQ abstraction)
  * @txqs_stopped: per AC flag to indicate that intermediate TXQs are stopped,
  *	protected by fq->lock.
+ * @noack: per-TID noack policy.
+ * @retry_short: per-TID retry count.
+ * @retry_long: per-TID count.
+ * @ampdu: per-TID Aggregation-MPDU.
+ * @tx_rate_mask: per-TID tx rate value.
  */
 struct ieee80211_vif {
 	enum nl80211_iftype type;
@@ -1615,6 +1622,14 @@ struct ieee80211_vif {
 
 	bool txqs_stopped[IEEE80211_NUM_ACS];
 
+	u8 noack[IEEE80211_TID_MAX];
+	int retry_short[IEEE80211_TID_MAX];
+	int retry_long[IEEE80211_TID_MAX];
+	u8 ampdu[IEEE80211_TID_MAX];
+	u8 rate_ctrl[IEEE80211_TID_MAX];
+	u32 rate_code[IEEE80211_TID_MAX];
+	u8 rtscts[IEEE80211_TID_MAX];
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -1929,6 +1944,11 @@ struct ieee80211_sta_rates {
  * @max_tid_amsdu_len: Maximum A-MSDU size in bytes for this TID
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction); note that
  *	the last entry (%IEEE80211_NUM_TIDS) is used for non-data frames
+ * @noack: per-TID noack policy.
+ * @retry_short: per-TID retry count.
+ * @retry_long: per-TID count.
+ * @ampdu: per-TID Aggregation-MPDU.
+ * @tx_rate_mask: per-TID tx rate value.
  */
 struct ieee80211_sta {
 	u32 supp_rates[NUM_NL80211_BANDS];
@@ -1972,6 +1992,13 @@ struct ieee80211_sta {
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
+	u8 noack[IEEE80211_TID_MAX];
+	int retry_short[IEEE80211_TID_MAX];
+	int retry_long[IEEE80211_TID_MAX];
+	u8 ampdu[IEEE80211_TID_MAX];
+	u8 rate_ctrl[IEEE80211_TID_MAX];
+	u8 rtscts[IEEE80211_TID_MAX];
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -3698,6 +3725,10 @@ enum ieee80211_reconfig_type {
  *
  * @start_pmsr: start peer measurement (e.g. FTM) (this call can sleep)
  * @abort_pmsr: abort peer measurement (this call can sleep)
+ * @set_tid_config: TID specific configurations will be applied for a particular
+ *	station when @sta is non-NULL. When @sta is NULL, then the configuration
+ *	will be for all the connected clients in the vif.
+ *	This callback may sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3990,6 +4021,10 @@ struct ieee80211_ops {
 			  struct cfg80211_pmsr_request *request);
 	void (*abort_pmsr)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			   struct cfg80211_pmsr_request *request);
+	int (*set_tid_config)(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct ieee80211_sta *sta,
+			      struct ieee80211_tid_config *tid_conf);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 09dd1c2..7d9c44d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3893,6 +3893,33 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return drv_abort_pmsr(local, sdata, request);
 }
 
+static int ieee80211_set_tid_config(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct ieee80211_tid_config *tid_conf)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+	int ret;
+
+	if (!sdata->local->ops->set_tid_config)
+		return -EOPNOTSUPP;
+
+	if (!tid_conf->peer)
+		return drv_set_tid_config(sdata->local, sdata, NULL, tid_conf);
+
+	mutex_lock(&sdata->local->sta_mtx);
+
+	sta = sta_info_get_bss(sdata, tid_conf->peer);
+	if (!sta) {
+		mutex_unlock(&sdata->local->sta_mtx);
+		return -ENOENT;
+	}
+
+	ret = drv_set_tid_config(sdata->local, sdata, &sta->sta, tid_conf);
+	mutex_unlock(&sdata->local->sta_mtx);
+	return ret;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3990,4 +4017,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
 	.start_pmsr = ieee80211_start_pmsr,
 	.abort_pmsr = ieee80211_abort_pmsr,
+	.set_tid_config = ieee80211_set_tid_config,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ba3c07b..082d81b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1319,4 +1319,19 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_set_tid_config(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta *sta,
+				     struct ieee80211_tid_config *tid_conf)
+{
+	int ret;
+
+	might_sleep();
+	ret = local->ops->set_tid_config(&local->hw, &sdata->vif, sta,
+					 tid_conf);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
-- 
1.9.1

