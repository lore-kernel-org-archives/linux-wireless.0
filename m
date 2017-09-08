Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:32074 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdIHOQl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:16:41 -0400
Content-Type: text/plain
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [RFC 2/4] mac80211_hwsim: add hwsim_tx_rate_flags to Netlink Attributes
Date: Fri, 8 Sep 2017 16:11:35 +0200
In-Reply-To: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Message-ID: <fb18fe18-c780-4073-886f-9c16788391ee@MAIL1.uni-rostock.de> (sfid-20170908_161758_622705_62F18E86)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For correct interpretation of a tx rate, the corresponding rate flags are needed (e.g. whether a HT-MCS rate or a legacy rate) and
moreover for more correct simulation the other infos of the flags are important (like short-GI). Keeping compability, the flags
are not integrated into the existing hwsim_tx_rate, but transmitted as an additional netlink attribute.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 93 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h | 67 +++++++++++++++++++++++++
 2 files changed, 159 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index aeeea7a35404..62c5a00a76c3 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1014,6 +1014,66 @@ static int hwsim_unicast_netgroup(struct mac80211_hwsim_data *data,
 	return res;
 }
 
+static inline u16 transl_tx_rate_flags_ieee2hwsim(struct ieee80211_tx_rate *rate)
+{
+	u16 result=0;
+	if(rate->flags & IEEE80211_TX_RC_USE_RTS_CTS)
+			result |= MAC80211_HWSIM_TX_RC_USE_RTS_CTS;
+	if(rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
+			result |= MAC80211_HWSIM_TX_RC_USE_CTS_PROTECT;
+	if(rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+			result |= MAC80211_HWSIM_TX_RC_USE_SHORT_PREAMBLE;
+	if(rate->flags & IEEE80211_TX_RC_MCS)
+			result |= MAC80211_HWSIM_TX_RC_MCS;
+	if(rate->flags & IEEE80211_TX_RC_GREEN_FIELD)
+			result |= MAC80211_HWSIM_TX_RC_GREEN_FIELD;
+	if(rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			result |= MAC80211_HWSIM_TX_RC_40_MHZ_WIDTH;
+	if(rate->flags & IEEE80211_TX_RC_DUP_DATA)
+			result |= MAC80211_HWSIM_TX_RC_DUP_DATA;
+	if(rate->flags & IEEE80211_TX_RC_SHORT_GI)
+			result |= MAC80211_HWSIM_TX_RC_SHORT_GI;
+	if(rate->flags & IEEE80211_TX_RC_VHT_MCS)
+			result |= MAC80211_HWSIM_TX_RC_VHT_MCS;
+	if(rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+			result |= MAC80211_HWSIM_TX_RC_80_MHZ_WIDTH;
+	if(rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+			result |= MAC80211_HWSIM_TX_RC_160_MHZ_WIDTH;
+
+	return result;
+}
+
+static inline u16 transl_rate_flags_hwsim2ieee(struct hwsim_tx_rate_flag *rate)
+{
+	u16 result=0;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_USE_RTS_CTS)
+			result |= IEEE80211_TX_RC_USE_RTS_CTS;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_USE_CTS_PROTECT)
+			result |= IEEE80211_TX_RC_USE_CTS_PROTECT;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_USE_SHORT_PREAMBLE)
+			result |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_MCS)
+			result |= IEEE80211_TX_RC_MCS;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_GREEN_FIELD)
+			result |= IEEE80211_TX_RC_GREEN_FIELD;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_40_MHZ_WIDTH)
+			result |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_DUP_DATA)
+			result |= IEEE80211_TX_RC_DUP_DATA;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_SHORT_GI)
+			result |= IEEE80211_TX_RC_SHORT_GI;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_VHT_MCS)
+			result |= IEEE80211_TX_RC_VHT_MCS;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_80_MHZ_WIDTH)
+			result |= IEEE80211_TX_RC_80_MHZ_WIDTH;
+	if(rate->flags & MAC80211_HWSIM_TX_RC_160_MHZ_WIDTH)
+			result |= IEEE80211_TX_RC_160_MHZ_WIDTH;
+
+	return result;
+}
+
+
+
 static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 				       struct sk_buff *my_skb,
 				       int dst_portid)
@@ -1026,6 +1086,8 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	unsigned int hwsim_flags = 0;
 	int i;
 	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
+	struct hwsim_tx_rate_flag tx_attempts_flags[IEEE80211_TX_MAX_RATES];
+
 	uintptr_t cookie;
 
 	if (data->ps != PS_DISABLED)
@@ -1077,7 +1139,10 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		tx_attempts[i].idx = info->status.rates[i].idx;
+		tx_attempts_flags[i].idx= info->status.rates[i].idx;
 		tx_attempts[i].count = info->status.rates[i].count;
+		tx_attempts_flags[i].flags =
+				transl_tx_rate_flags_ieee2hwsim(&info->status.rates[i]);
 	}
 
 	if (nla_put(skb, HWSIM_ATTR_TX_INFO,
@@ -1085,6 +1150,11 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		    tx_attempts))
 		goto nla_put_failure;
 
+	if (nla_put(skb, HWSIM_ATTR_TX_INFO_FLAGS,
+		    sizeof(struct hwsim_tx_rate_flag)*IEEE80211_TX_MAX_RATES,
+		    tx_attempts_flags))
+		goto nla_put_failure;
+
 	/* We create a cookie to identify this skb */
 	data->pending_cookie++;
 	cookie = data->pending_cookie;
@@ -2973,6 +3043,8 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	struct mac80211_hwsim_data *data2;
 	struct ieee80211_tx_info *txi;
 	struct hwsim_tx_rate *tx_attempts;
+	struct hwsim_tx_rate_flag *tx_attempts_flags;
+
 	u64 ret_skb_cookie;
 	struct sk_buff *skb, *tmp;
 	const u8 *src;
@@ -3033,9 +3105,28 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		txi->status.rates[i].idx = tx_attempts[i].idx;
 		txi->status.rates[i].count = tx_attempts[i].count;
-		/*txi->status.rates[i].flags = 0;*/
+		/* txi->status.rates[i].flags = 0; */
 	}
 
+	if(info->attrs[HWSIM_ATTR_TX_INFO_FLAGS]){
+			tx_attempts_flags = (struct hwsim_tx_rate_flag *)nla_data(
+					       info->attrs[HWSIM_ATTR_TX_INFO_FLAGS]);
+			for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+
+				WARN(txi->status.rates[i].idx != tx_attempts_flags[i].idx,
+						"rate idx of tx_info received via netlink "
+							"does not match to rate idx of tx_info_flags");
+
+				txi->status.rates[i].flags =
+						transl_rate_flags_hwsim2ieee(&tx_attempts_flags[i]);
+						}
+		}
+		else{
+			WARN_ONCE(1,"received tx_info via netlink does not contain"
+				"rate flags, may cause statistic or rate control problems");
+		}
+
+
 	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	if (!(hwsim_flags & HWSIM_TX_CTL_NO_ACK) &&
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 3f5eda591dba..5f831fffcb13 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -123,6 +123,7 @@ enum {
  * @HWSIM_ATTR_RADIO_NAME: Name of radio, e.g. phy666
  * @HWSIM_ATTR_NO_VIF:  Do not create vif (wlanX) when creating radio.
  * @HWSIM_ATTR_FREQ: Frequency at which packet is transmitted or received.
+ * @HWSIM_ATTR_TX_INFO_FLAGS: additional flags for corresponding rates of %HWSIM_ATTR_TX_INFO
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -149,10 +150,76 @@ enum {
 	HWSIM_ATTR_NO_VIF,
 	HWSIM_ATTR_FREQ,
 	HWSIM_ATTR_PAD,
+	HWSIM_ATTR_TX_INFO_FLAGS,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
 
+
+/**
+ * enum hwsim_tx_rate_flags - per-rate flags set by the
+ *	Rate Control algorithm. Inspired by structure mac80211_rate_control_flags.
+ *	New flags may be appended, but old flags not deleted, to keep compatibility
+ *	for userspace.
+ *
+ * These flags are set by the Rate control algorithm for each rate during tx,
+ * in the @flags member of struct ieee80211_tx_rate.
+ *
+ * @MAC80211_HWSIM_TX_RC_USE_RTS_CTS: Use RTS/CTS exchange for this rate.
+ * @MAC80211_HWSIM_TX_RC_USE_CTS_PROTECT: CTS-to-self protection is required.
+ *	This is set if the current BSS requires ERP protection.
+ * @MAC80211_HWSIM_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
+ * @MAC80211_HWSIM_TX_RC_MCS: HT rate.
+ * @MAC80211_HWSIM_TX_RC_VHT_MCS: VHT MCS rate, in this case the idx field is split
+ *	into a higher 4 bits (Nss) and lower 4 bits (MCS number)
+ * @MAC80211_HWSIM_TX_RC_GREEN_FIELD: Indicates whether this rate should be used in
+ *	Greenfield mode.
+ * @MAC80211_HWSIM_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width should be 40 MHz.
+ * @MAC80211_HWSIM_TX_RC_80_MHZ_WIDTH: Indicates 80 MHz transmission
+ * @MAC80211_HWSIM_TX_RC_160_MHZ_WIDTH: Indicates 160 MHz transmission
+ *	(80+80 isn't supported yet)
+ * @MAC80211_HWSIM_TX_RC_DUP_DATA: The frame should be transmitted on both of the
+ *	adjacent 20 MHz channels, if the current channel type is
+ *	NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS.
+ * @MAC80211_HWSIM_TX_RC_SHORT_GI: Short Guard interval should be used for this rate.
+ */
+enum hwsim_tx_rate_flags {
+	MAC80211_HWSIM_TX_RC_USE_RTS_CTS		= BIT(0),
+	MAC80211_HWSIM_TX_RC_USE_CTS_PROTECT		= BIT(1),
+	MAC80211_HWSIM_TX_RC_USE_SHORT_PREAMBLE	= BIT(2),
+
+	/* rate index is an HT/VHT MCS instead of an index */
+	MAC80211_HWSIM_TX_RC_MCS			= BIT(3),
+	MAC80211_HWSIM_TX_RC_GREEN_FIELD		= BIT(4),
+	MAC80211_HWSIM_TX_RC_40_MHZ_WIDTH		= BIT(5),
+	MAC80211_HWSIM_TX_RC_DUP_DATA		= BIT(6),
+	MAC80211_HWSIM_TX_RC_SHORT_GI		= BIT(7),
+	MAC80211_HWSIM_TX_RC_VHT_MCS			= BIT(8),
+	MAC80211_HWSIM_TX_RC_80_MHZ_WIDTH		= BIT(9),
+	MAC80211_HWSIM_TX_RC_160_MHZ_WIDTH		= BIT(10),
+};
+
+/**
+ * struct hwsim_tx_rate - rate selection/status
+ *
+ * @idx: rate index to attempt to send with
+ * @count: number of tries in this rate before going to the next rate
+ *
+ * A value of -1 for @idx indicates an invalid rate and, if used
+ * in an array of retry rates, that no more rates should be tried.
+ *
+ * When used for transmit status reporting, the driver should
+ * always report the rate and number of retries used.
+ *
+ */
+struct hwsim_tx_rate_flag {
+	s8 idx;
+	u16 flags;
+} __packed;
+
+
+
+
 /**
  * struct hwsim_tx_rate - rate selection/status
  *
-- 
2.14.1
