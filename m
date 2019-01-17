Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B96AC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 11:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 534BF2054F
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 11:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iK5KWrWK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="beDJsBTV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfAQLYS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:24:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfAQLYS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 06:24:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DA58960878; Thu, 17 Jan 2019 11:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547724256;
        bh=e/h6fVD/AvrgevtK7jl5YgTyntQHbW1M63acEDuS4BY=;
        h=From:To:Cc:Subject:Date:From;
        b=iK5KWrWKHQG7dfDXvH+6CL/8qa4QxKNXTUnIC1gqYllzMnwQnmCp95LI2WuubVdzL
         MpPvK4UFqU/JRquLDnXSeAackaZx2kMSApvnPUmjQrkhrXAiI9JpdRQuD0mOu8waR8
         22SH/JaS5xHSmf5HA2Ls5jc3aLnbTIBu3QsHo3eQ=
Received: from checstex0244823-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bpothuno@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 26D61608BA;
        Thu, 17 Jan 2019 11:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547724255;
        bh=e/h6fVD/AvrgevtK7jl5YgTyntQHbW1M63acEDuS4BY=;
        h=From:To:Cc:Subject:Date:From;
        b=beDJsBTVg3zjpPpwT88pGk+Hot8/mmH1mW7lRInnBTHUrhlOZP59CtIvHq0vYD83b
         BQjLOsJq++sqTiyGHpfAn9k3bc7EK/043nrSaEIiYqljj++3n/9jMoGBeRwdWbUNSt
         1/SCSVUnddz03O969kXKsQwH2upWrWdIhehmzZu0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 26D61608BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bpothuno@codeaurora.org
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH 2/3] mac80211: store tx power value from user to station
Date:   Thu, 17 Jan 2019 16:54:07 +0530
Message-Id: <1547724247-11481-1-git-send-email-bpothuno@codeaurora.org>
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
 include/net/mac80211.h    | 12 ++++++++++++
 net/mac80211/cfg.c        |  9 +++++++++
 net/mac80211/driver-ops.c | 21 +++++++++++++++++++++
 net/mac80211/driver-ops.h |  5 +++++
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 5 files changed, 74 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9386cf9..2826734 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1877,6 +1877,13 @@ struct ieee80211_sta_rates {
  * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @max_rc_amsdu_len: Maximum A-MSDU size in bytes recommended by rate control.
  * @max_tid_amsdu_len: Maximum A-MSDU size in bytes for this TID
+ * @txpwr: indicates the tx power, in mBm, to be used when sending data frames
+ *	to the STA.
+ * @type: In particular if TPC %type is NL80211_TX_POWER_LIMITED then txpwr will
+ *	be less than or equal to specified from userspace, whereas if TPC %type
+ *	is NL80211_TX_POWER_AUTOMATIC then it indicates default txpwr.
+ *	NL80211_TX_POWER_FIXED is not a valid configuration option for
+ *	per peer TPC.
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction); note that
  *	the last entry (%IEEE80211_NUM_TIDS) is used for non-data frames
  */
@@ -1919,6 +1926,8 @@ struct ieee80211_sta {
 	bool support_p2p_ps;
 	u16 max_rc_amsdu_len;
 	u16 max_tid_amsdu_len[IEEE80211_NUM_TIDS];
+	s16 txpwr;
+	enum nl80211_tx_power_setting type;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS + 1];
 
@@ -3718,6 +3727,9 @@ struct ieee80211_ops {
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
index cf8f946..a598cee 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1412,6 +1412,15 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (params->listen_interval >= 0)
 		sta->listen_interval = params->listen_interval;
 
+	if (params->sta_modify_mask & STATION_PARAM_APPLY_STA_TXPOWER) {
+		sta->sta.type = params->type;
+		if (params->type == NL80211_TX_POWER_LIMITED)
+			sta->sta.txpwr = params->txpwr;
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
index 3e0d592..12efc41 100644
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
index 35ea0dc..faf027e 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -828,6 +828,33 @@ TRACE_EVENT(drv_sta_state,
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
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->txpwr = sta->txpwr;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " txpwr: %d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->txpwr
+	)
+);
+
 TRACE_EVENT(drv_sta_rc_update,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.7.4

