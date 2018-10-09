Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4222CC6786D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1E83214C5
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="a0Ui4Lbw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1E83214C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbeJITtq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 15:49:46 -0400
Received: from mail.toke.dk ([52.28.52.200]:56815 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726984AbeJITtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 15:49:46 -0400
Subject: [PATCH RFC v5 2/4] cfg80211: Add airtime statistics and settings
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1539088380; bh=X7KXQ+Yiea6O5Sv8sN5mOeX5v2k2QL2Axvbqgis6pWQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a0Ui4LbwY5KMp+j/n/0LT84TAw98BwObdn85u+KUU85vG5B3/0Tr5wJql/m9yJjse
         TrI5pJKjhUxG2Cf+0qnWWXuRRBPJHMfvS8AKpfESQZqJp339yPQjtER+XYn8PsELAv
         GPDTUdE+b3YsaIKGGWdNNGjv3n7OI2gWsRTc5MbGRsZq7Akr2dLX/V2+AjEGeet7rV
         fSr4J3+QWKfbaooJzUVFxPLR0JjHneg7/4kHQPJj1o0dq4E29wvLLPU/NpQMFcflcg
         O7/fdeCeKgnVLs5NrdjH2mkgf7rUWWyRePRo3TVoOehCDz8WNvdsnqHh3sEuvCzJQN
         xd27fJi57MjAA==
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To:     linux-wireless@vger.kernel.org
Cc:     make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Date:   Tue, 09 Oct 2018 14:32:58 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <153908837892.9471.13229753923382209882.stgit@alrua-kau>
In-Reply-To: <153908805217.9471.9290979918041653328.stgit@alrua-kau>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds TX airtime statistics to the cfg80211 station dump (to go along
with the RX info already present), and adds a new parameter to set the
airtime weight of each station. The latter allows userspace to implement
policies for different stations by varying their weights.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/cfg80211.h       |   10 +++++++++-
 include/uapi/linux/nl80211.h |   15 +++++++++++++++
 net/wireless/nl80211.c       |   29 +++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f3ed79c39d7..91d6fc222263 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -990,6 +990,7 @@ enum station_parameters_apply_mask {
  * @support_p2p_ps: information if station supports P2P PS mechanism
  * @he_capa: HE capabilities of station
  * @he_capa_len: the length of the HE capabilities
+ * @airtime_weight: airtime scheduler weight for this station
  */
 struct station_parameters {
 	const u8 *supported_rates;
@@ -1019,6 +1020,7 @@ struct station_parameters {
 	int support_p2p_ps;
 	const struct ieee80211_he_cap_elem *he_capa;
 	u8 he_capa_len;
+	u16 airtime_weight;
 };
 
 /**
@@ -1286,6 +1288,8 @@ struct cfg80211_tid_stats {
  * @rx_beacon_signal_avg: signal strength average (in dBm) for beacons received
  *	from this peer
  * @rx_duration: aggregate PPDU duration(usecs) for all the frames from a peer
+ * @tx_duration: aggregate PPDU duration(usecs) for all the frames to a peer
+ * @airtime_weight: current airtime scheduling weight
  * @pertid: per-TID statistics, see &struct cfg80211_tid_stats, using the last
  *	(IEEE80211_NUM_TIDS) index for MSDUs not encapsulated in QoS-MPDUs.
  *	Note that this doesn't use the @filled bit, but is used if non-NULL.
@@ -1332,10 +1336,12 @@ struct station_info {
 
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
 };
@@ -2363,6 +2369,8 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_TXQ_QUANTUM		= 1 << 8,
 };
 
+#define IEEE80211_DEFAULT_AIRTIME_WEIGHT	256
+
 /**
  * struct cfg80211_pmksa - PMK Security Association
  *
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cfc94178d608..3664bdc7c8c1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2241,6 +2241,9 @@ enum nl80211_commands {
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
  *
+ * @NL80211_ATTR_AIRTIME_WEIGHT: Station's weight when scheduled by the airtime
+ *      scheduler.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2682,6 +2685,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HE_CAPABILITY,
 
+	NL80211_ATTR_AIRTIME_WEIGHT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3051,6 +3056,9 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
  * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
  * @NL80211_STA_INFO_ACK_SIGNAL_AVG: avg signal strength of ACK frames (s8, dBm)
+ * @NL80211_STA_INFO_TX_DURATION: aggregate PPDU duration for all frames
+ *	sent to the station (u64, usec)
+ * @NL80211_STA_INFO_AIRTIME_WEIGHT: current airtime weight for station (u16)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3091,6 +3099,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_PAD,
 	NL80211_STA_INFO_ACK_SIGNAL,
 	NL80211_STA_INFO_ACK_SIGNAL_AVG,
+	NL80211_STA_INFO_TX_DURATION,
+	NL80211_STA_INFO_AIRTIME_WEIGHT,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
@@ -5231,6 +5241,10 @@ enum nl80211_feature_flags {
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
  *
+ * @NL80211_EXT_FEATURE_AIRTIME_FAIRNESS: Driver supports getting airtime
+ *      fairness for transmitted packets and has enabled airtime fairness
+ *      scheduling.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5269,6 +5283,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
+	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d5f9b5235cdd..9db19ae57716 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -430,6 +430,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_TXQ_QUANTUM] = { .type = NLA_U32 },
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
+
+	[NL80211_ATTR_AIRTIME_WEIGHT] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -4656,6 +4658,11 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
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
@@ -5293,6 +5300,17 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
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
@@ -5431,6 +5449,17 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
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
 	err = nl80211_parse_sta_channel_info(info, &params);
 	if (err)
 		return err;

