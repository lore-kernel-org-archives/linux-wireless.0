Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:64813 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966376AbeAJQnt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 11:43:49 -0500
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH v3 5/5] mac80211_hwsim: add hwsim_tx_rate_flags to netlink attributes
Date: Wed, 10 Jan 2018 17:42:55 +0100
In-Reply-To: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <6071f4de-9547-411d-a641-5a409aa747a9@MAIL2.uni-rostock.de> (sfid-20180110_174414_445795_A0075443)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For correct interpretation of a tx rate, the corresponding rate flags are
needed (e.g. whether a HT-MCS rate or a legacy rate) and moreover for more
correct simulation the other infos of the flags are important (like
short-GI). Keeping compatibility, the flags are not integrated into the
existing hwsim_tx_rate, but transmitted as an additional netlink attribute.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
---
 drivers/net/wireless/mac80211_hwsim.c | 41 ++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h | 68 ++++++++++++++++++++++++++++++++++-
 2 files changed, 107 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1e0d651c43fc..226fa98f16a6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1026,6 +1026,36 @@ static int hwsim_unicast_netgroup(struct mac80211_hwsim_data *data,
 	return res;
 }
 
+static inline u16 trans_tx_rate_flags_ieee2hwsim(struct ieee80211_tx_rate *rate)
+{
+	u16 result = 0;
+
+	if (rate->flags & IEEE80211_TX_RC_USE_RTS_CTS)
+		result |= MAC80211_HWSIM_TX_RC_USE_RTS_CTS;
+	if (rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
+		result |= MAC80211_HWSIM_TX_RC_USE_CTS_PROTECT;
+	if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+		result |= MAC80211_HWSIM_TX_RC_USE_SHORT_PREAMBLE;
+	if (rate->flags & IEEE80211_TX_RC_MCS)
+		result |= MAC80211_HWSIM_TX_RC_MCS;
+	if (rate->flags & IEEE80211_TX_RC_GREEN_FIELD)
+		result |= MAC80211_HWSIM_TX_RC_GREEN_FIELD;
+	if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		result |= MAC80211_HWSIM_TX_RC_40_MHZ_WIDTH;
+	if (rate->flags & IEEE80211_TX_RC_DUP_DATA)
+		result |= MAC80211_HWSIM_TX_RC_DUP_DATA;
+	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+		result |= MAC80211_HWSIM_TX_RC_SHORT_GI;
+	if (rate->flags & IEEE80211_TX_RC_VHT_MCS)
+		result |= MAC80211_HWSIM_TX_RC_VHT_MCS;
+	if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		result |= MAC80211_HWSIM_TX_RC_80_MHZ_WIDTH;
+	if (rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+		result |= MAC80211_HWSIM_TX_RC_160_MHZ_WIDTH;
+
+	return result;
+}
+
 static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 				       struct sk_buff *my_skb,
 				       int dst_portid)
@@ -1038,6 +1068,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	unsigned int hwsim_flags = 0;
 	int i;
 	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
+	struct hwsim_tx_rate_flag tx_attempts_flags[IEEE80211_TX_MAX_RATES];
 	uintptr_t cookie;
 
 	if (data->ps != PS_DISABLED)
@@ -1089,7 +1120,11 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		tx_attempts[i].idx = info->status.rates[i].idx;
+		tx_attempts_flags[i].idx = info->status.rates[i].idx;
 		tx_attempts[i].count = info->status.rates[i].count;
+		tx_attempts_flags[i].flags =
+				trans_tx_rate_flags_ieee2hwsim(
+						&info->status.rates[i]);
 	}
 
 	if (nla_put(skb, HWSIM_ATTR_TX_INFO,
@@ -1097,6 +1132,11 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		    tx_attempts))
 		goto nla_put_failure;
 
+	if (nla_put(skb, HWSIM_ATTR_TX_INFO_FLAGS,
+		    sizeof(struct hwsim_tx_rate_flag) * IEEE80211_TX_MAX_RATES,
+		    tx_attempts_flags))
+		goto nla_put_failure;
+
 	/* We create a cookie to identify this skb */
 	data->pending_cookie++;
 	cookie = data->pending_cookie;
@@ -3003,7 +3043,6 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		txi->status.rates[i].idx = tx_attempts[i].idx;
 		txi->status.rates[i].count = tx_attempts[i].count;
-		/*txi->status.rates[i].flags = 0;*/
 	}
 
 	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index e2592b596090..b304dfb70036 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -64,7 +64,8 @@ enum hwsim_tx_control_flags {
  * @HWSIM_CMD_TX_INFO_FRAME: Transmission info report from user space to
  *	kernel, uses:
  *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_FLAGS,
- *	%HWSIM_ATTR_TX_INFO, %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
+ *	%HWSIM_ATTR_TX_INFO, %WSIM_ATTR_TX_INFO_FLAGS,
+ *	%HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
  * @HWSIM_CMD_NEW_RADIO: create a new radio with the given parameters,
  *	returns the radio ID (>= 0) or negative on errors, if successful
  *	then multicast the result, uses optional parameter:
@@ -76,6 +77,8 @@ enum hwsim_tx_control_flags {
  * @HWSIM_CMD_DEL_RADIO: destroy a radio, reply is multicasted
  * @HWSIM_CMD_GET_RADIO: fetch information about existing radios, uses:
  *	%HWSIM_ATTR_RADIO_ID
+ * @HWSIM_ATTR_TX_INFO_FLAGS: additional flags for corresponding
+ *	rates of %HWSIM_ATTR_TX_INFO
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -156,6 +159,7 @@ enum {
 	HWSIM_ATTR_FREQ,
 	HWSIM_ATTR_PAD,
 	HWSIM_ATTR_PERM_ADDR,
+	HWSIM_ATTR_TX_INFO_FLAGS,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
@@ -178,4 +182,66 @@ struct hwsim_tx_rate {
 	u8 count;
 } __packed;
 
+/**
+ * enum hwsim_tx_rate_flags - per-rate flags set by the rate control algorithm.
+ *	Inspired by structure mac80211_rate_control_flags. New flags may be
+ *	appended, but old flags not deleted, to keep compatibility for
+ *	userspace.
+ *
+ * These flags are set by the Rate control algorithm for each rate during tx,
+ * in the @flags member of struct ieee80211_tx_rate.
+ *
+ * @MAC80211_HWSIM_TX_RC_USE_RTS_CTS: Use RTS/CTS exchange for this rate.
+ * @MAC80211_HWSIM_TX_RC_USE_CTS_PROTECT: CTS-to-self protection is required.
+ *	This is set if the current BSS requires ERP protection.
+ * @MAC80211_HWSIM_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
+ * @MAC80211_HWSIM_TX_RC_MCS: HT rate.
+ * @MAC80211_HWSIM_TX_RC_VHT_MCS: VHT MCS rate, in this case the idx field is
+ *	split into a higher 4 bits (Nss) and lower 4 bits (MCS number)
+ * @MAC80211_HWSIM_TX_RC_GREEN_FIELD: Indicates whether this rate should be used
+ *	in Greenfield mode.
+ * @MAC80211_HWSIM_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width should be
+ *	40 MHz.
+ * @MAC80211_HWSIM_TX_RC_80_MHZ_WIDTH: Indicates 80 MHz transmission
+ * @MAC80211_HWSIM_TX_RC_160_MHZ_WIDTH: Indicates 160 MHz transmission
+ *	(80+80 isn't supported yet)
+ * @MAC80211_HWSIM_TX_RC_DUP_DATA: The frame should be transmitted on both of
+ *	the adjacent 20 MHz channels, if the current channel type is
+ *	NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS.
+ * @MAC80211_HWSIM_TX_RC_SHORT_GI: Short Guard interval should be used for this
+ *	rate.
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
 #endif /* __MAC80211_HWSIM_H */
-- 
2.15.1
