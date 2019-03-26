Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7BFC4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE03B20856
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jm2Qlc2O";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jm2Qlc2O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbfCZJ3s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:29:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbfCZJ3r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 05:29:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 82EF46118F; Tue, 26 Mar 2019 09:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553592586;
        bh=UTbRbmA9fHyY23o6vdDRVqbsL+Nln5oQ+MyKyaYzOhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jm2Qlc2OCr65MpUhXABxDMHY+JO+8s6O+W0MRVz2hLJmoxxbcLKndvcyecLhpnF27
         L9k1elK7cRanXaI2wHj2FwFFM4dTV01U5D1YZdxZqZdJkdFdrkMib5IOlXubvFKK9X
         7lqx9SNWXNMl2ROIFwG+9l9PeKzMqhPsKT2fXuok=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF43B6115B;
        Tue, 26 Mar 2019 09:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553592586;
        bh=UTbRbmA9fHyY23o6vdDRVqbsL+Nln5oQ+MyKyaYzOhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jm2Qlc2OCr65MpUhXABxDMHY+JO+8s6O+W0MRVz2hLJmoxxbcLKndvcyecLhpnF27
         L9k1elK7cRanXaI2wHj2FwFFM4dTV01U5D1YZdxZqZdJkdFdrkMib5IOlXubvFKK9X
         7lqx9SNWXNMl2ROIFwG+9l9PeKzMqhPsKT2fXuok=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF43B6115B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv5 6/9] mac80211: Add api to support configuring TID specific configuration
Date:   Tue, 26 Mar 2019 14:59:07 +0530
Message-Id: <1553592550-15282-7-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
References: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Implement drv_set_tid_config api to allow TID specific
configuration. This per-TID configuration
will be applied for all the connected stations when MAC is NULL.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/mac80211.h    |   38 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/cfg.c        |   28 ++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h |   15 +++++++++++++++
 3 files changed, 81 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ac2ed8e..ead7605 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1556,6 +1556,8 @@ enum ieee80211_vif_flags {
 	IEEE80211_VIF_GET_NOA_UPDATE		= BIT(3),
 };
 
+#define IEEE80211_TID_MAX	8
+
 /**
  * struct ieee80211_vif - per-interface data
  *
@@ -1593,6 +1595,13 @@ enum ieee80211_vif_flags {
  * @txq: the multicast data TX queue (if driver uses the TXQ abstraction)
  * @txqs_stopped: per AC flag to indicate that intermediate TXQs are stopped,
  *	protected by fq->lock.
+ * @noack: per-TID noack policy.
+ * @retry_short: per-TID retry count.
+ * @retry_long: per-TID count.
+ * @ampdu: per-TID Aggregation-MPDU.
+ * @rate_ctrl: per-TID tx rate control type.
+ * @rate_code: per-TID tx rate code mask.
+ * @rtscts: per-TID RTSCTS policy.
  */
 struct ieee80211_vif {
 	enum nl80211_iftype type;
@@ -1619,6 +1628,14 @@ struct ieee80211_vif {
 
 	bool txqs_stopped[IEEE80211_NUM_ACS];
 
+	int noack[IEEE80211_TID_MAX];
+	int retry_short[IEEE80211_TID_MAX];
+	int retry_long[IEEE80211_TID_MAX];
+	int ampdu[IEEE80211_TID_MAX];
+	u8 rate_ctrl[IEEE80211_TID_MAX];
+	u32 rate_code[IEEE80211_TID_MAX];
+	u8 rtscts[IEEE80211_TID_MAX];
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -1933,6 +1950,12 @@ struct ieee80211_sta_rates {
  * @max_tid_amsdu_len: Maximum A-MSDU size in bytes for this TID
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction); note that
  *	the last entry (%IEEE80211_NUM_TIDS) is used for non-data frames
+ * @noack: per-TID noack policy.
+ * @retry_short: per-TID retry count.
+ * @retry_long: per-TID count.
+ * @ampdu: per-TID Aggregation-MPDU.
+ * @rate_ctrl: per-TID tx rate control type.
+ * @rtscts: per-TID RTSCTS policy.
  */
 struct ieee80211_sta {
 	u32 supp_rates[NUM_NL80211_BANDS];
@@ -1976,6 +1999,13 @@ struct ieee80211_sta {
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
+	int noack[IEEE80211_TID_MAX];
+	int retry_short[IEEE80211_TID_MAX];
+	int retry_long[IEEE80211_TID_MAX];
+	int ampdu[IEEE80211_TID_MAX];
+	u8 rate_ctrl[IEEE80211_TID_MAX];
+	u8 rtscts[IEEE80211_TID_MAX];
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -3707,6 +3737,10 @@ enum ieee80211_reconfig_type {
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
@@ -4004,6 +4038,10 @@ struct ieee80211_ops {
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
index 28d022a..d316b18 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1348,4 +1348,19 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
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
1.7.9.5

