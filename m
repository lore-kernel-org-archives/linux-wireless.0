Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:13468 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728509AbeHMPXW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 11:23:22 -0400
From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH 2/3] nl80211: Add support for EDMG channels
Date: Mon, 13 Aug 2018 15:33:01 +0300
Message-Id: <1534163582-9983-3-git-send-email-ailizaro@codeaurora.org> (sfid-20180813_144124_779536_84243AEB)
In-Reply-To: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org>
References: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11ay specification defines Enhanced Directional Multi-Gigabit
(EDMG) STA and SAP which allow channel bonding of 2 channels and more.
Introduce NL80211_BAND_ATTR_EDMG, NL80211_BAND_ATTR_EDMG_SUPPORTED_CHAN,
NL80211_ATTR_WIPHY_EDMG, NL80211_ATTR_WIPHY_EDMG_CHANNEL and
RATE_INFO_FLAGS_EDMG that needed for enabling and configuring
EDMG support.
Driver is expected to report its EDMG capabilities: whether EDMG
is supported and the supported EDMG channels.
Bitrate calculation is enhanced to take into account EDMG support
according to the 802.11ay specification.
The kernel uses NL80211_BAND_ATTR_EDMG and
NL80211_BAND_ATTR_EDMG_SUPPORTED_CHAN attributes in order to publish
the EDMG capabilities to the userspace, NL80211_BAND_ATTR_EDMG is set
if EDMG is supported and NL80211_BAND_ATTR_EDMG_SUPPORTED_CHAN
contains list of supported EDMG channels.
NL80211_ATTR_WIPHY_EDMG and NL80211_ATTR_WIPHY_EDMG_CHANNEL will be
used by the userspace for AP configuration and connect command.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  2 +-
 include/net/cfg80211.h                      | 48 +++++++++++++++-
 include/uapi/linux/nl80211.h                | 12 ++++
 net/wireless/chan.c                         | 88 +++++++++++++++++++++++++++++
 net/wireless/nl80211.c                      | 33 +++++++++++
 net/wireless/util.c                         | 42 +++++++++++++-
 6 files changed, 219 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index e63b078..4740b53 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -311,7 +311,7 @@ int wil_cid_fill_sinfo(struct wil6210_vif *vif, int cid,
 			BIT_ULL(NL80211_STA_INFO_RX_DROP_MISC) |
 			BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 
-	sinfo->txrate.flags = RATE_INFO_FLAGS_60G;
+	sinfo->txrate.flags = RATE_INFO_FLAGS_DMG;
 	sinfo->txrate.mcs = le16_to_cpu(reply.evt.bf_mcs);
 	sinfo->rxrate.mcs = stats->last_mcs_rx;
 	sinfo->rx_bytes = stats->rx_bytes;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 73ca446..10f9d76 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -321,6 +321,24 @@ struct ieee80211_sband_iftype_data {
 };
 
 /**
+ * struct ieee80211_sta_edmg_cap - EDMG capabilities
+ *
+ * This structure describes most essential parameters needed
+ * to describe 802.11ay EDMG capabilities
+ *
+ * @supported: is EDMG supported, Device may support EDMG
+ *	without supporting channel bonding. In this case
+ *	supported would be TRUE with n_channels = 0
+ * @channels: supported ieee EDMG channel numbers
+ * @n_channels: Number of channels in @channels
+ */
+struct ieee80211_sta_edmg_cap {
+	bool supported;
+	u8 *channels;
+	int n_channels;
+};
+
+/**
  * struct ieee80211_supported_band - frequency band definition
  *
  * This structure describes a frequency band a wiphy
@@ -336,6 +354,7 @@ struct ieee80211_sband_iftype_data {
  * @n_bitrates: Number of bitrates in @bitrates
  * @ht_cap: HT capabilities in this band
  * @vht_cap: VHT capabilities in this band
+ * @edmg_cap: EDMG capabilities in this band
  * @n_iftype_data: number of iftype data entries
  * @iftype_data: interface type data entries.  Note that the bits in
  *	@types_mask inside this structure cannot overlap (i.e. only
@@ -350,6 +369,7 @@ struct ieee80211_supported_band {
 	int n_bitrates;
 	struct ieee80211_sta_ht_cap ht_cap;
 	struct ieee80211_sta_vht_cap vht_cap;
+	struct ieee80211_sta_edmg_cap edmg_cap;
 	u16 n_iftype_data;
 	const struct ieee80211_sband_iftype_data *iftype_data;
 };
@@ -501,12 +521,16 @@ struct key_params {
  * @center_freq1: center frequency of first segment
  * @center_freq2: center frequency of second segment
  *	(only with 80+80 MHz)
+ * @edmg_mode: if defined, edmg supported and primary channel is EDMG
+ * @edmg_channel: the EDMG channel
  */
 struct cfg80211_chan_def {
 	struct ieee80211_channel *chan;
 	enum nl80211_chan_width width;
 	u32 center_freq1;
 	u32 center_freq2;
+	bool edmg_mode;
+	u8 edmg_channel;
 };
 
 /**
@@ -658,6 +682,18 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 }
 
 /**
+ * cfg80211_edmg_usable - check if the EDMG channel can be used
+ * @wiphy: the wiphy
+ * @edmg_cap: EDMG capabilities in this band
+ * @edmg_channel: the EDMG channel that need to be verified
+ * @primary_channel: The primary channel for the EDMG channel
+ * Return: %true the EDMG channel is usable. %false otherwise.
+ */
+bool cfg80211_edmg_usable(struct wiphy *wiphy,
+			  struct ieee80211_sta_edmg_cap *edmg_cap,
+			  u8 edmg_channel, int primary_channel);
+
+/**
  * enum survey_info_flags - survey information flags
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
@@ -1090,15 +1126,17 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
  * @RATE_INFO_FLAGS_MCS: mcs field filled with HT MCS
  * @RATE_INFO_FLAGS_VHT_MCS: mcs field filled with VHT MCS
  * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
- * @RATE_INFO_FLAGS_60G: 60GHz MCS
+ * @RATE_INFO_FLAGS_DMG: 60GHz MCS
  * @RATE_INFO_FLAGS_HE_MCS: HE MCS information
+ * @RATE_INFO_FLAGS_EDMG: 60GHz MCS in EDMG mode
  */
 enum rate_info_flags {
 	RATE_INFO_FLAGS_MCS			= BIT(0),
 	RATE_INFO_FLAGS_VHT_MCS			= BIT(1),
 	RATE_INFO_FLAGS_SHORT_GI		= BIT(2),
-	RATE_INFO_FLAGS_60G			= BIT(3),
+	RATE_INFO_FLAGS_DMG			= BIT(3),
 	RATE_INFO_FLAGS_HE_MCS			= BIT(4),
+	RATE_INFO_FLAGS_EDMG			= BIT(5),
 };
 
 /**
@@ -1138,6 +1176,7 @@ enum rate_info_bw {
  * @he_dcm: HE DCM value
  * @he_ru_alloc: HE RU allocation (from &enum nl80211_he_ru_alloc,
  *	only valid if bw is %RATE_INFO_BW_HE_RU)
+ * @n_bonded_ch: In case of EDMG the number of bonded channels (1-4)
  */
 struct rate_info {
 	u8 flags;
@@ -1148,6 +1187,7 @@ struct rate_info {
 	u8 he_gi;
 	u8 he_dcm;
 	u8 he_ru_alloc;
+	u8 n_bonded_ch;
 };
 
 /**
@@ -2285,6 +2325,8 @@ struct cfg80211_bss_selection {
  * @fils_erp_rrk_len: Length of @fils_erp_rrk in octets.
  * @want_1x: indicates user-space supports and wants to use 802.1X driver
  *	offload of 4-way handshake.
+ * @edmg: enable EDMG mode.
+ * @edmg_channel: The EDMG channel to use.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -2318,6 +2360,8 @@ struct cfg80211_connect_params {
 	const u8 *fils_erp_rrk;
 	size_t fils_erp_rrk_len;
 	bool want_1x;
+	bool edmg;
+	u8 edmg_channel;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 0239896..31b1312 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2240,6 +2240,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_HE_CAPABILITY: HE Capability information element (from
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
+ * @NL80211_ATTR_WIPHY_EDMG: flag attribute. If set it means EDMG mode supported
+ * @NL80211_ATTR_WIPHY_EDMG_CHANNEL: EDMG channel to be used for AP
+ *      configuration and connect command.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2682,6 +2685,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_HE_CAPABILITY,
 
+	NL80211_ATTR_WIPHY_EDMG,
+	NL80211_ATTR_WIPHY_EDMG_CHANNEL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3265,6 +3271,9 @@ enum nl80211_band_iftype_attr {
  * @NL80211_BAND_ATTR_VHT_CAPA: VHT capabilities, as in the HT information IE
  * @NL80211_BAND_ATTR_IFTYPE_DATA: nested array attribute, with each entry using
  *	attributes from &enum nl80211_band_iftype_attr
+ * @NL80211_BAND_ATTR_EDMG: flag attribute. If set it means EDMG mode supported
+ * @NL80211_BAND_ATTR_EDMG_SUPPORTED_CHAN: array of supported EDMG channels in
+ *	this band
  * @NL80211_BAND_ATTR_MAX: highest band attribute currently defined
  * @__NL80211_BAND_ATTR_AFTER_LAST: internal use
  */
@@ -3282,6 +3291,9 @@ enum nl80211_band_attr {
 	NL80211_BAND_ATTR_VHT_CAPA,
 	NL80211_BAND_ATTR_IFTYPE_DATA,
 
+	NL80211_BAND_ATTR_EDMG,
+	NL80211_BAND_ATTR_EDMG_SUPPORTED_CHAN,
+
 	/* keep last */
 	__NL80211_BAND_ATTR_AFTER_LAST,
 	NL80211_BAND_ATTR_MAX = __NL80211_BAND_ATTR_AFTER_LAST - 1
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2db713d..681f434 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -720,12 +720,94 @@ static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 	return true;
 }
 
+static const struct edmg_chan_table {
+	/* the edmg channel - 9,10,11... */
+	u8 edmg_chan;
+	/* the sub channels represented as a bitfield where the bit-index
+	 * corresponds to the legacy channel (bit 0 not used).
+	 */
+	u8 sub_chans;
+} cfg80211_edmg_table[] = {
+	{9, 0x06},	/* channels 1,2 */
+	{10, 0x0c},	/* channels 2,3 */
+	{11, 0x18},	/* channels 3,4 */
+	{12, 0x30},	/* channels 4,5 */
+	{13, 0x60},	/* channels 5,6 */
+	{17, 0x0e},	/* channels 1,2,3 */
+	{18, 0x1c},	/* channels 2,3,4 */
+	{19, 0x38},	/* channels 3,4,5 */
+	{20, 0x70},	/* channels 4,5,6 */
+	{25, 0x1e},	/* channels 1,2,3,4 */
+	{26, 0x3c},	/* channels 2,3,4,5 */
+	{27, 0x78},	/* channels 3,4,5,6 */
+};
+
+static u8 cfg80211_get_edmg_sub_chans(u8 edmg_channel)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cfg80211_edmg_table); i++)
+		if (cfg80211_edmg_table[i].edmg_chan == edmg_channel)
+			return cfg80211_edmg_table[i].sub_chans;
+
+	return 0;
+}
+
+static bool cfg80211_check_edmg_sub_ch(struct wiphy *wiphy,
+				       u8 edmg_channel,
+				       int primary_channel)
+{
+	struct ieee80211_channel *chan;
+	int i, freq;
+	u8 sub_channels;
+
+	sub_channels = cfg80211_get_edmg_sub_chans(edmg_channel);
+	if (!sub_channels)
+		return false;
+
+	if (!(sub_channels & BIT(primary_channel)))
+		return false;
+
+	/* 60GHz channels 1..6 */
+	for (i = 1; i <= 6; i++) {
+		if (!(sub_channels & BIT(i)))
+			continue;
+
+		freq = ieee80211_channel_to_frequency(i, NL80211_BAND_60GHZ);
+		chan = ieee80211_get_channel(wiphy, freq);
+		if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
+			return false;
+	}
+
+	return true;
+}
+
+bool cfg80211_edmg_usable(struct wiphy *wiphy,
+			  struct ieee80211_sta_edmg_cap *edmg_cap,
+			  u8 edmg_channel, int primary_channel)
+{
+	int i;
+
+	if (!edmg_channel)
+		return true;
+
+	for (i = 0; i < edmg_cap->n_channels; i++)
+		if (edmg_channel == edmg_cap->channels[i])
+			break;
+
+	if (i == edmg_cap->n_channels)
+		return false;
+
+	return cfg80211_check_edmg_sub_ch(wiphy, edmg_channel, primary_channel);
+}
+
 bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			     const struct cfg80211_chan_def *chandef,
 			     u32 prohibited_flags)
 {
 	struct ieee80211_sta_ht_cap *ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap;
+	struct ieee80211_sta_edmg_cap *edmg_cap;
 	u32 width, control_freq, cap;
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
@@ -733,6 +815,12 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 
 	ht_cap = &wiphy->bands[chandef->chan->band]->ht_cap;
 	vht_cap = &wiphy->bands[chandef->chan->band]->vht_cap;
+	edmg_cap = &wiphy->bands[chandef->chan->band]->edmg_cap;
+
+	if (edmg_cap->supported &&
+	    !cfg80211_edmg_usable(wiphy, edmg_cap, chandef->edmg_channel,
+				  chandef->chan->hw_value))
+		return false;
 
 	control_freq = chandef->chan->center_freq;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5fb9b7d..043b46f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -209,6 +209,8 @@ enum nl80211_multicast_groups {
 
 	[NL80211_ATTR_WIPHY_FREQ] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_CHANNEL_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_WIPHY_EDMG] = { .type = NLA_FLAG },
+	[NL80211_ATTR_WIPHY_EDMG_CHANNEL] = { .type = NLA_U8 },
 	[NL80211_ATTR_CHANNEL_WIDTH] = { .type = NLA_U32 },
 	[NL80211_ATTR_CENTER_FREQ1] = { .type = NLA_U32 },
 	[NL80211_ATTR_CENTER_FREQ2] = { .type = NLA_U32 },
@@ -1409,6 +1411,13 @@ static int nl80211_send_band_rateinfo(struct sk_buff *msg,
 		nla_nest_end(msg, nl_iftype_data);
 	}
 
+	/* add EDMG info */
+	if (sband->edmg_cap.supported &&
+	    (nla_put_flag(msg, NL80211_BAND_ATTR_EDMG) ||
+	     nla_put(msg, NL80211_BAND_ATTR_EDMG_SUPPORTED_CHAN,
+		     sband->edmg_cap.n_channels, sband->edmg_cap.channels)))
+		return -ENOBUFS;
+
 	/* add bitrates */
 	nl_rates = nla_nest_start(msg, NL80211_BAND_ATTR_RATES);
 	if (!nl_rates)
@@ -2303,6 +2312,8 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
 	chandef->center_freq1 = control_freq;
 	chandef->center_freq2 = 0;
+	chandef->edmg_mode = 0;
+	chandef->edmg_channel = 0;
 
 	/* Primary channel not allowed */
 	if (!chandef->chan || chandef->chan->flags & IEEE80211_CHAN_DISABLED)
@@ -2347,6 +2358,14 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 					info->attrs[NL80211_ATTR_CENTER_FREQ2]);
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_EDMG])
+		chandef->edmg_mode =
+			nla_get_flag(info->attrs[NL80211_ATTR_WIPHY_EDMG]);
+
+	if (info->attrs[NL80211_ATTR_WIPHY_EDMG_CHANNEL])
+		chandef->edmg_channel =
+		       nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_EDMG_CHANNEL]);
+
 	if (!cfg80211_chandef_valid(chandef))
 		return -EINVAL;
 
@@ -9302,6 +9321,7 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_connect_params connect;
 	struct wiphy *wiphy;
 	struct cfg80211_cached_keys *connkeys = NULL;
+	struct ieee80211_sta_edmg_cap *edmg_cap;
 	int err;
 
 	memset(&connect, 0, sizeof(connect));
@@ -9392,6 +9412,19 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_EDMG]) {
+		connect.edmg =
+			nla_get_flag(info->attrs[NL80211_ATTR_WIPHY_EDMG]);
+		if (info->attrs[NL80211_ATTR_WIPHY_EDMG_CHANNEL])
+			connect.edmg_channel =
+		       nla_get_u8(info->attrs[NL80211_ATTR_WIPHY_EDMG_CHANNEL]);
+		edmg_cap = &rdev->wiphy.bands[NL80211_BAND_60GHZ]->edmg_cap;
+		if (edmg_cap && connect.edmg &&
+		    !cfg80211_edmg_usable(wiphy, edmg_cap, connect.edmg_channel,
+					  connect.channel->hw_value))
+			connect.edmg_channel = 0;
+	}
+
 	if (connect.privacy && info->attrs[NL80211_ATTR_KEYS]) {
 		connkeys = nl80211_parse_connkeys(rdev, info, NULL);
 		if (IS_ERR(connkeys))
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a450736..08b43a2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1009,7 +1009,7 @@ static u32 cfg80211_calculate_bitrate_ht(struct rate_info *rate)
 	return (bitrate + 50000) / 100000;
 }
 
-static u32 cfg80211_calculate_bitrate_60g(struct rate_info *rate)
+static u32 cfg80211_calculate_bitrate_dmg(struct rate_info *rate)
 {
 	static const u32 __mcs2bitrate[] = {
 		/* control PHY */
@@ -1056,6 +1056,40 @@ static u32 cfg80211_calculate_bitrate_60g(struct rate_info *rate)
 	return __mcs2bitrate[rate->mcs];
 }
 
+static u32 cfg80211_calculate_bitrate_edmg(struct rate_info *rate)
+{
+	static const u32 __mcs2bitrate[] = {
+		/* control PHY */
+		[0] =   275,
+		/* SC PHY */
+		[1] =  3850,
+		[2] =  7700,
+		[3] =  9625,
+		[4] = 11550,
+		[5] = 12512, /* 1251.25 mbps */
+		[6] = 13475,
+		[7] = 15400,
+		[8] = 19250,
+		[9] = 23100,
+		[10] = 25025,
+		[11] = 26950,
+		[12] = 30800,
+		[13] = 38500,
+		[14] = 46200,
+		[15] = 50050,
+		[16] = 53900,
+		[17] = 57750,
+		[18] = 69300,
+		[19] = 75075,
+		[20] = 80850,
+	};
+
+	if (WARN_ON_ONCE(rate->mcs >= ARRAY_SIZE(__mcs2bitrate)))
+		return 0;
+
+	return __mcs2bitrate[rate->mcs] * rate->n_bonded_ch;
+}
+
 static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 {
 	static const u32 base[4][10] = {
@@ -1226,8 +1260,10 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 {
 	if (rate->flags & RATE_INFO_FLAGS_MCS)
 		return cfg80211_calculate_bitrate_ht(rate);
-	if (rate->flags & RATE_INFO_FLAGS_60G)
-		return cfg80211_calculate_bitrate_60g(rate);
+	if (rate->flags & RATE_INFO_FLAGS_DMG)
+		return cfg80211_calculate_bitrate_dmg(rate);
+	if (rate->flags & RATE_INFO_FLAGS_EDMG)
+		return cfg80211_calculate_bitrate_edmg(rate);
 	if (rate->flags & RATE_INFO_FLAGS_VHT_MCS)
 		return cfg80211_calculate_bitrate_vht(rate);
 	if (rate->flags & RATE_INFO_FLAGS_HE_MCS)
-- 
1.9.1
