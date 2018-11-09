Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0191CC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 23:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC09C20827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 23:17:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC09C20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbeKJJAa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Nov 2018 04:00:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbeKJJAa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Nov 2018 04:00:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DBF0D6083C; Fri,  9 Nov 2018 23:17:44 +0000 (UTC)
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D524A602BC;
        Fri,  9 Nov 2018 23:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D524A602BC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=pass (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=pass smtp.mailfrom=rmanohar@qti.qualcomm.com
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Fri, 09 Nov 2018 15:17:42 -0800
From:   Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v2 2/6] cfg80211: Add airtime statistics and settings
Date:   Fri,  9 Nov 2018 15:16:57 -0800
Message-Id: <1541805421-27309-3-git-send-email-rmanohar@qti.qualcomm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1541805421-27309-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1541805421-27309-1-git-send-email-rmanohar@qti.qualcomm.com>
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
---
 include/net/cfg80211.h       | 10 +++++++++-
 include/uapi/linux/nl80211.h | 15 +++++++++++++++
 net/wireless/nl80211.c       | 28 ++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 1 deletion(-)

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
index 8d763725498c..7837ff74833a 100644
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
@@ -5308,6 +5314,17 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_get_u8(info->attrs[NL80211_ATTR_OPMODE_NOTIF]);
 	}
 
+	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+			return -EOPNOTSUPP;
+
+		params.airtime_weight =
+			nla_get_u16(info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]);
+		if (!params.airtime_weight)
+			return -EINVAL;
+	}
+
 	/* Include parameters for TDLS peer (will check later) */
 	err = nl80211_set_station_tdls(info, &params);
 	if (err)
@@ -5436,6 +5453,17 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.plink_action =
 			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
 
+	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]) {
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
+			return -EOPNOTSUPP;
+
+		params.airtime_weight =
+			nla_get_u16(info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]);
+		if (!params.airtime_weight)
+			return -EINVAL;
+	}
+
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
 		return err;
-- 
1.9.1

