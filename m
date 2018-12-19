Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB09C43612
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 01:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4889321852
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 01:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PHCTyU4R";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GpdbOkKD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbeLSBCX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 20:02:23 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39318 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbeLSBCW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 20:02:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 993EB60C05; Wed, 19 Dec 2018 01:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545181341;
        bh=gBL+jGKKjzaPQXzKlwKqSjUFfljoFerNH+ShJHWt4dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHCTyU4Rcma9QFVgHErqGFTk9Ih2o72QhusDHUaaCKtm6h3XMckJoUSFw/uBCJ3QC
         O4fFIFsxYrFbhsssY8Y8TkRWUVoTf7oSURkEEUilLo+DGL6s9KyIaWzO5c2gQHcudj
         AUKExdtdItcAaEV9lvtZB0uXwLdL0Dqkkrl6MIII=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 43F1760C01;
        Wed, 19 Dec 2018 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545181340;
        bh=gBL+jGKKjzaPQXzKlwKqSjUFfljoFerNH+ShJHWt4dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpdbOkKDOiUNQUCEjHZKUMYqGmJpM6UOBKM1U6fz8PpEwixLZUZjQ85zutK4OmVHA
         fIJjsJSoo03osvsj7Js00+ZTGMNdSDdMHMjAfHpRcENussJ3f7Aj4dXf+lfwAkZTnl
         UkK41TsL4EfXkBVKjolCrEajJNNiUg9JTY4gppV0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 43F1760C01
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Tue, 18 Dec 2018 17:02:18 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v5 2/6] cfg80211: Add airtime statistics and settings
Date:   Tue, 18 Dec 2018 17:02:07 -0800
Message-Id: <1545181331-5288-3-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>

This adds TX airtime statistics to the cfg80211 station dump (to go along
with the RX info already present), and adds a new parameter to set the
airtime weight of each station. The latter allows userspace to implement
policies for different stations by varying their weights.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
[rmanohar@codeaurora.org: fixed checkpatch warnings]
Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 include/net/cfg80211.h       | 10 +++++++++-
 include/uapi/linux/nl80211.h | 15 +++++++++++++++
 net/wireless/nl80211.c       | 30 ++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7a1be3..f1312f17fbef 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1001,6 +1001,7 @@ enum station_parameters_apply_mask {
  * @support_p2p_ps: information if station supports P2P PS mechanism
  * @he_capa: HE capabilities of station
  * @he_capa_len: the length of the HE capabilities
+ * @airtime_weight: airtime scheduler weight for this station
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -1030,6 +1031,7 @@ struct station_parameters {
 	int support_p2p_ps;
 	const struct ieee80211_he_cap_elem *he_capa;
 	u8 he_capa_len;
+	u16 airtime_weight;
 };
 
 /**
@@ -1297,6 +1299,8 @@ struct cfg80211_tid_stats {
  * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
  *	from this peer
  * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
+ * @tx_duration: aggregate PPDU duration(usecs) for all the frames to a peer
+ * @airtime_weight: current airtime scheduling weight
  * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
  *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
  *	Note that this doesn't use the @filled bit, but is used if non-NULL.
@@ -1347,10 +1351,12 @@ struct station_info {
 
 	u32 expected_throughput;
 
-	u64 rx_beacon;
+	u64 tx_duration;
 	u64 rx_duration;
+	u64 rx_beacon;
 	u8 rx_beacon_signal_avg;
 	struct cfg80211_tid_stats *pertid;
+	u16 airtime_weight;
 	s8 ack_signal;
 	s8 avg_ack_signal;
 
@@ -2381,6 +2387,8 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_TXQ_QUANTUM		= 1 << 8,
 };
 
+#define IEEE80211_DEFAULT_AIRTIME_WEIGHT	256
+
 /**
  * struct cfg80211_pmksa - PMK Security Association
  *
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610bae30a9..9428bd0ebb1a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2254,6 +2254,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
  *	statistics, see &enum nl80211_ftm_responder_stats.
  *
+ * @NL80211_ATTR_AIRTIME_WEIGHT: Station's weight when scheduled by the airtime
+ *	scheduler.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2699,6 +2702,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FTM_RESPONDER_STATS,
 
+	NL80211_ATTR_AIRTIME_WEIGHT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3074,6 +3079,9 @@ enum nl80211_sta_bss_param {
  *	with an FCS error (u32, from this station). This count may not include
  *	some packets with an FCS error due to TA corruption. Hence this counter
  *	might not be fully accurate.
+ * @NL80211_STA_INFO_TX_DURATION: aggregate PPDU duration for all frames
+ *	sent to the station (u64, usec)
+ * @NL80211_STA_INFO_AIRTIME_WEIGHT: current airtime weight for station (u16)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3116,6 +3124,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_ACK_SIGNAL_AVG,
 	NL80211_STA_INFO_RX_MPDUS,
 	NL80211_STA_INFO_FCS_ERROR_COUNT,
+	NL80211_STA_INFO_TX_DURATION,
+	NL80211_STA_INFO_AIRTIME_WEIGHT,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -5258,6 +5268,10 @@ enum nl80211_feature_flags {
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
  *
+ * @NL80211_EXT_FEATURE_AIRTIME_FAIRNESS: Driver supports getting airtime
+ *	fairness for transmitted packets and has enabled airtime fairness
+ *	scheduling.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5297,6 +5311,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2317727d6413..aa53a8563295 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -497,6 +497,7 @@ static int validate_ie_attr(const struct nlattr *attr,
 		.type = NLA_NESTED,
 		.validation_data = nl80211_ftm_responder_policy,
 	},
+	[NL80211_ATTR_AIRTIME_WEIGHT] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -4690,6 +4691,11 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO(PLID, plid, u16);
 	PUT_SINFO(PLINK_STATE, plink_state, u8);
 	PUT_SINFO_U64(RX_DURATION, rx_duration);
+	PUT_SINFO_U64(TX_DURATION, tx_duration);
+
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+		PUT_SINFO(AIRTIME_WEIGHT, airtime_weight, u16);
 
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
@@ -5308,6 +5314,18 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_get_u8(info->attrs[NL80211_ATTR_OPMODE_NOTIF]);
 	}
 
+	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]) {
+		params.airtime_weight =
+			nla_get_u16(info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]);
+		if (!params.airtime_weight)
+			return -EINVAL;
+	}
+
+	if (params.airtime_weight &&
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+		return -EOPNOTSUPP;
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
@@ -5436,6 +5454,18 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_action =
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
 
+	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]) {
+		params.airtime_weight =
+			nla_get_u16(info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]);
+		if (!params.airtime_weight)
+			return -EINVAL;
+	}
+
+	if (params.airtime_weight &&
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+		return -EOPNOTSUPP;
+
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
 		return err;
-- 
1.9.1

