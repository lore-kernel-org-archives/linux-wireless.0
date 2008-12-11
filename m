Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:31284 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792AbYLKVEh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 16:04:37 -0500
Received: by fk-out-0910.google.com with SMTP id 18so711342fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 13:04:35 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [Patch v14 without signature] nl80211: Add signal strength and bandwith to nl80211station info
Date: Thu, 11 Dec 2008 22:04:19 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812112204.20111.hrogge@googlemail.com> (sfid-20081211_220446_775107_F59E8288)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds signal strength and transmission bitrate
to the station_info of nl80211.

Signed-off-by: Henning Rogge <rogge@fgan.de>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 04d4516..7501acf 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -425,6 +425,32 @@ enum nl80211_sta_flags {
 };
 
 /**
+ * enum nl80211_rate_info - bitrate information
+ *
+ * These attribute types are used with %NL80211_STA_INFO_TXRATE
+ * when getting information about the bitrate of a station.
+ *
+ * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
+ * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
+ * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
+ * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
+ * @NL80211_RATE_INFO_MAX: highest rate_info number currently defined
+ * @__NL80211_RATE_INFO_AFTER_LAST: internal use
+ */
+enum nl80211_rate_info {
+	__NL80211_RATE_INFO_INVALID,
+	NL80211_RATE_INFO_BITRATE,
+	NL80211_RATE_INFO_MCS,
+	NL80211_RATE_INFO_40_MHZ_WIDTH,
+	NL80211_RATE_INFO_SHORT_GI,
+
+	/* keep last */
+	__NL80211_RATE_INFO_AFTER_LAST,
+	NL80211_RATE_INFO_MAX = __NL80211_RATE_INFO_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_sta_info - station information
  *
  * These attribute types are used with %NL80211_ATTR_STA_INFO
@@ -436,6 +462,9 @@ enum nl80211_sta_flags {
  * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
+ * @NL80211_STA_INFO_SIGNAL: signal strength of last received PPDU (u8, dBm)
+ * @NL80211_STA_INFO_TX_BITRATE: current unicast tx rate, nested attribute
+ * 	containing info as possible, see &enum nl80211_sta_info_txrate.
  */
 enum nl80211_sta_info {
 	__NL80211_STA_INFO_INVALID,
@@ -445,6 +474,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_LLID,
 	NL80211_STA_INFO_PLID,
 	NL80211_STA_INFO_PLINK_STATE,
+	NL80211_STA_INFO_SIGNAL,
+	NL80211_STA_INFO_TX_BITRATE,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a0c0bf1..65e03ac 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -169,6 +169,9 @@ struct station_parameters {
  * @STATION_INFO_LLID: @llid filled
  * @STATION_INFO_PLID: @plid filled
  * @STATION_INFO_PLINK_STATE: @plink_state filled
+ * @STATION_INFO_SIGNAL: @signal filled
+ * @STATION_INFO_TX_BITRATE: @tx_bitrate fields are filled
+ *  (tx_bitrate, tx_bitrate_flags and tx_bitrate_mcs)
  */
 enum station_info_flags {
 	STATION_INFO_INACTIVE_TIME	= 1<<0,
@@ -177,6 +180,39 @@ enum station_info_flags {
 	STATION_INFO_LLID		= 1<<3,
 	STATION_INFO_PLID		= 1<<4,
 	STATION_INFO_PLINK_STATE	= 1<<5,
+	STATION_INFO_SIGNAL		= 1<<6,
+	STATION_INFO_TX_BITRATE		= 1<<7,
+};
+
+/**
+ * enum station_info_rate_flags - bitrate info flags
+ *
+ * Used by the driver to indicate the specific rate transmission
+ * type for 802.11n transmissions.
+ *
+ * @RATE_INFO_FLAGS_MCS: @tx_bitrate_mcs filled
+ * @RATE_INFO_FLAGS_40_MHZ_WIDTH: 40 Mhz width transmission
+ * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
+ */
+enum rate_info_flags {
+	RATE_INFO_FLAGS_MCS		= 1<<0,
+	RATE_INFO_FLAGS_40_MHZ_WIDTH	= 1<<1,
+	RATE_INFO_FLAGS_SHORT_GI	= 1<<2,
+};
+
+/**
+ * struct rate_info - bitrate information
+ *
+ * Information about a receiving or transmitting bitrate
+ *
+ * @flags: bitflag of flags from &enum rate_info_flags
+ * @mcs: mcs index if struct describes a 802.11n bitrate
+ * @legacy: bitrate in 100kbit/s for 802.11abg
+ */
+struct rate_info {
+	u8 flags;
+	u8 mcs;
+	u16 legacy;
 };
 
 /**
@@ -191,6 +227,8 @@ enum station_info_flags {
  * @llid: mesh local link id
  * @plid: mesh peer link id
  * @plink_state: mesh peer link state
+ * @signal: signal strength of last received packet in dBm
+ * @txrate: current unicast bitrate to this station
  */
 struct station_info {
 	u32 filled;
@@ -200,6 +238,8 @@ struct station_info {
 	u16 llid;
 	u16 plid;
 	u8 plink_state;
+	s8 signal;
+	struct rate_info txrate;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7912eb1..23b5eea 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -310,12 +310,35 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 	sinfo->filled = STATION_INFO_INACTIVE_TIME |
 			STATION_INFO_RX_BYTES |
-			STATION_INFO_TX_BYTES;
+			STATION_INFO_TX_BYTES |
+			STATION_INFO_TX_BITRATE;
 
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
 	sinfo->rx_bytes = sta->rx_bytes;
 	sinfo->tx_bytes = sta->tx_bytes;
 
+	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+		sinfo->filled |= STATION_INFO_SIGNAL;
+		sinfo->signal = (s8)sta->last_signal;
+	}
+
+	sinfo->txrate.flags = 0;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_SHORT_GI)
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
+		struct ieee80211_supported_band *sband;
+		sband = sta->local->hw.wiphy->bands[
+				sta->local->hw.conf.channel->band];
+		sinfo->txrate.legacy =
+			sband->bitrates[sta->last_tx_rate.idx].bitrate;
+	} else
+		sinfo->txrate.mcs = sta->last_tx_rate.idx;
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |= STATION_INFO_LLID |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4335f76..93c9b98 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1091,12 +1091,46 @@ static int parse_station_flags(struct nlattr *nla, u32 *staflags)
 	return 0;
 }
 
+static u16 nl80211_calculate_bitrate(struct rate_info *rate)
+{
+	int modulation, streams, bitrate;
+
+	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
+		return rate->legacy;
+
+	/* the formula below does only work for MCS values smaller than 32 */
+	if (rate->mcs >= 32)
+		return 0;
+
+	modulation = rate->mcs & 7;
+	streams = (rate->mcs >> 3) + 1;
+
+	bitrate = (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
+			13500000 : 6500000;
+
+	if (modulation < 4)
+		bitrate *= (modulation + 1);
+	else if (modulation == 4)
+		bitrate *= (modulation + 2);
+	else
+		bitrate *= (modulation + 3);
+
+	bitrate *= streams;
+
+	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
+		bitrate = (bitrate / 9) * 10;
+
+	/* do NOT round down here */
+	return (bitrate + 50000) / 100000;
+}
+
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
 				u8 *mac_addr, struct station_info *sinfo)
 {
 	void *hdr;
-	struct nlattr *sinfoattr;
+	struct nlattr *sinfoattr, *txrate;
+	u16 bitrate;
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
 	if (!hdr)
@@ -1126,7 +1160,29 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 	if (sinfo->filled & STATION_INFO_PLINK_STATE)
 		NLA_PUT_U8(msg, NL80211_STA_INFO_PLINK_STATE,
 			    sinfo->plink_state);
+	if (sinfo->filled & STATION_INFO_SIGNAL)
+		NLA_PUT_U8(msg, NL80211_STA_INFO_SIGNAL,
+			   sinfo->signal);
+	if (sinfo->filled & STATION_INFO_TX_BITRATE) {
+		txrate = nla_nest_start(msg, NL80211_STA_INFO_TX_BITRATE);
+		if (!txrate)
+			goto nla_put_failure;
+
+		/* nl80211_calculate_bitrate will return 0 for mcs >= 32 */
+		bitrate = nl80211_calculate_bitrate(&sinfo->txrate);
+		if (bitrate > 0)
+			NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
 
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_MCS)
+			NLA_PUT_U8(msg, NL80211_RATE_INFO_MCS,
+				    sinfo->txrate.mcs);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_40_MHZ_WIDTH)
+			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_40_MHZ_WIDTH);
+		if (sinfo->txrate.flags & RATE_INFO_FLAGS_SHORT_GI)
+			NLA_PUT_FLAG(msg, NL80211_RATE_INFO_SHORT_GI);
+
+		nla_nest_end(msg, txrate);
+	}
 	nla_nest_end(msg, sinfoattr);
 
 	return genlmsg_end(msg, hdr);

