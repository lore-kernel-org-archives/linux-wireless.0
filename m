Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:36529 "HELO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752593Ab1LUHrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 02:47:31 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: use IEEE80211_HT_PARAM_CHA_SEC_* macros
Date: Tue, 20 Dec 2011 23:47:21 -0800
Message-Id: <1324453642-1920-2-git-send-email-bzhao@marvell.com> (sfid-20111221_084733_950618_AC002AFF)
In-Reply-To: <1324453642-1920-1-git-send-email-bzhao@marvell.com>
References: <1324453642-1920-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Replace driver specific macros with the corresponding
IEEE80211_HT_PARAM_CHA_SEC_* macros defined in ieee80211.h.
Also, rename 'adapter->chan_offset' to 'adapter->sec_chan_offset'
for consistency.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   48 +++++++++++++++---------------
 drivers/net/wireless/mwifiex/fw.h       |    2 -
 drivers/net/wireless/mwifiex/init.c     |    2 +-
 drivers/net/wireless/mwifiex/ioctl.h    |    4 --
 drivers/net/wireless/mwifiex/join.c     |   14 +++++----
 drivers/net/wireless/mwifiex/main.h     |    2 +-
 drivers/net/wireless/mwifiex/sta_cmd.c  |    2 +-
 7 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 64bf640..0723f61 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -24,26 +24,26 @@
  * This function maps the nl802.11 channel type into driver channel type.
  *
  * The mapping is as follows -
- *      NL80211_CHAN_NO_HT     -> NO_SEC_CHANNEL
- *      NL80211_CHAN_HT20      -> NO_SEC_CHANNEL
- *      NL80211_CHAN_HT40PLUS  -> SEC_CHANNEL_ABOVE
- *      NL80211_CHAN_HT40MINUS -> SEC_CHANNEL_BELOW
- *      Others                 -> NO_SEC_CHANNEL
+ *      NL80211_CHAN_NO_HT     -> IEEE80211_HT_PARAM_CHA_SEC_NONE
+ *      NL80211_CHAN_HT20      -> IEEE80211_HT_PARAM_CHA_SEC_NONE
+ *      NL80211_CHAN_HT40PLUS  -> IEEE80211_HT_PARAM_CHA_SEC_ABOVE
+ *      NL80211_CHAN_HT40MINUS -> IEEE80211_HT_PARAM_CHA_SEC_BELOW
+ *      Others                 -> IEEE80211_HT_PARAM_CHA_SEC_NONE
  */
-static int
-mwifiex_cfg80211_channel_type_to_mwifiex_channels(enum nl80211_channel_type
-						  channel_type)
+static u8
+mwifiex_cfg80211_channel_type_to_sec_chan_offset(enum nl80211_channel_type
+						 channel_type)
 {
 	switch (channel_type) {
 	case NL80211_CHAN_NO_HT:
 	case NL80211_CHAN_HT20:
-		return NO_SEC_CHANNEL;
+		return IEEE80211_HT_PARAM_CHA_SEC_NONE;
 	case NL80211_CHAN_HT40PLUS:
-		return SEC_CHANNEL_ABOVE;
+		return IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
 	case NL80211_CHAN_HT40MINUS:
-		return SEC_CHANNEL_BELOW;
+		return IEEE80211_HT_PARAM_CHA_SEC_BELOW;
 	default:
-		return NO_SEC_CHANNEL;
+		return IEEE80211_HT_PARAM_CHA_SEC_NONE;
 	}
 }
 
@@ -51,20 +51,20 @@ mwifiex_cfg80211_channel_type_to_mwifiex_channels(enum nl80211_channel_type
  * This function maps the driver channel type into nl802.11 channel type.
  *
  * The mapping is as follows -
- *      NO_SEC_CHANNEL      -> NL80211_CHAN_HT20
- *      SEC_CHANNEL_ABOVE   -> NL80211_CHAN_HT40PLUS
- *      SEC_CHANNEL_BELOW   -> NL80211_CHAN_HT40MINUS
- *      Others              -> NL80211_CHAN_HT20
+ *      IEEE80211_HT_PARAM_CHA_SEC_NONE    -> NL80211_CHAN_HT20
+ *      IEEE80211_HT_PARAM_CHA_SEC_ABOVE   -> NL80211_CHAN_HT40PLUS
+ *      IEEE80211_HT_PARAM_CHA_SEC_BELOW   -> NL80211_CHAN_HT40MINUS
+ *      Others                             -> NL80211_CHAN_HT20
  */
 static enum nl80211_channel_type
 mwifiex_channels_to_cfg80211_channel_type(int channel_type)
 {
 	switch (channel_type) {
-	case NO_SEC_CHANNEL:
+	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
 		return NL80211_CHAN_HT20;
-	case SEC_CHANNEL_ABOVE:
+	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 		return NL80211_CHAN_HT40PLUS;
-	case SEC_CHANNEL_BELOW:
+	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
 		return NL80211_CHAN_HT40MINUS;
 	default:
 		return NL80211_CHAN_HT20;
@@ -354,15 +354,15 @@ mwifiex_set_rf_channel(struct mwifiex_private *priv,
 					adapter->adhoc_11n_enabled = false;
 			}
 		}
-		adapter->chan_offset =
-			mwifiex_cfg80211_channel_type_to_mwifiex_channels
+		adapter->sec_chan_offset =
+			mwifiex_cfg80211_channel_type_to_sec_chan_offset
 			(channel_type);
 
 		mwifiex_send_domain_info_cmd_fw(wiphy);
 	}
 
 	wiphy_dbg(wiphy, "info: setting band %d, channel offset %d and "
-		"mode %d\n", config_bands, adapter->chan_offset,
+		"mode %d\n", config_bands, adapter->sec_chan_offset,
 		priv->bss_mode);
 	if (!chan)
 		return 0;
@@ -729,7 +729,7 @@ static int mwifiex_cfg80211_set_bitrate_mask(struct wiphy *wiphy,
 			adapter->adhoc_11n_enabled = false;
 		}
 	}
-	adapter->chan_offset = NO_SEC_CHANNEL;
+	adapter->sec_chan_offset = IEEE80211_HT_PARAM_CHA_SEC_NONE;
 
 	wiphy_debug(wiphy, "info: device configured in 802.11%s%s mode\n",
 				(mode & BAND_B) ? "b" : "",
@@ -850,7 +850,7 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 	if (channel)
 		ret = mwifiex_set_rf_channel(priv, channel,
 				mwifiex_channels_to_cfg80211_channel_type
-				(priv->adapter->chan_offset));
+				(priv->adapter->sec_chan_offset));
 
 	ret = mwifiex_set_encode(priv, NULL, 0, 0, 1);	/* Disable keys */
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 62b8639..51c5417 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -376,8 +376,6 @@ enum mwifiex_chan_scan_mode_bitmasks {
 	MWIFIEX_DISABLE_CHAN_FILT = BIT(1),
 };
 
-#define SECOND_CHANNEL_BELOW    0x30
-#define SECOND_CHANNEL_ABOVE    0x10
 struct mwifiex_chan_scan_param_set {
 	u8 radio_type;
 	u8 chan_number;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 244c728..e05b417 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -246,7 +246,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(adapter->event_body, 0, sizeof(adapter->event_body));
 	adapter->hw_dot_11n_dev_cap = 0;
 	adapter->hw_dev_mcs_support = 0;
-	adapter->chan_offset = 0;
+	adapter->sec_chan_offset = 0;
 	adapter->adhoc_11n_enabled = false;
 
 	mwifiex_wmm_init(adapter);
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index eb76b7b..d5d81f1 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -62,10 +62,6 @@ enum {
 	BAND_AN = 16,
 };
 
-#define NO_SEC_CHANNEL               0
-#define SEC_CHANNEL_ABOVE            1
-#define SEC_CHANNEL_BELOW            3
-
 enum {
 	ADHOC_IDLE,
 	ADHOC_STARTED,
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 1c49813..0b0eb5e 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -885,12 +885,14 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		       = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
 		if (adapter->adhoc_start_band & BAND_GN
 		    || adapter->adhoc_start_band & BAND_AN) {
-			if (adapter->chan_offset == SEC_CHANNEL_ABOVE)
+			if (adapter->sec_chan_offset ==
+					    IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
 				chan_tlv->chan_scan_param[0].radio_type |=
-					SECOND_CHANNEL_ABOVE;
-			else if (adapter->chan_offset == SEC_CHANNEL_BELOW)
+					(IEEE80211_HT_PARAM_CHA_SEC_ABOVE << 4);
+			else if (adapter->sec_chan_offset ==
+					    IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
 				chan_tlv->chan_scan_param[0].radio_type |=
-					SECOND_CHANNEL_BELOW;
+					(IEEE80211_HT_PARAM_CHA_SEC_BELOW << 4);
 		}
 		dev_dbg(adapter->dev, "info: ADHOC_S_CMD: TLV Band = %d\n",
 		       chan_tlv->chan_scan_param[0].radio_type);
@@ -936,8 +938,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 
 		ht_info->ht_info.control_chan =
 			(u8) priv->curr_bss_params.bss_descriptor.channel;
-		if (adapter->chan_offset) {
-			ht_info->ht_info.ht_param = adapter->chan_offset;
+		if (adapter->sec_chan_offset) {
+			ht_info->ht_info.ht_param = adapter->sec_chan_offset;
 			ht_info->ht_info.ht_param |=
 					IEEE80211_HT_PARAM_CHAN_WIDTH_ANY;
 		}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index d659650..2287643 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -640,7 +640,7 @@ struct mwifiex_adapter {
 	u32 hw_dot_11n_dev_cap;
 	u8 hw_dev_mcs_support;
 	u8 adhoc_11n_enabled;
-	u8 chan_offset;
+	u8 sec_chan_offset;
 	struct mwifiex_dbg dbg;
 	u8 arp_filter[ARP_FILTER_MAX_BUF_SIZE];
 	u32 arp_filter_size;
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index ea6518d..6e443ff 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -748,7 +748,7 @@ static int mwifiex_cmd_802_11_rf_channel(struct mwifiex_private *priv,
 				cpu_to_le16(HostCmd_SCAN_RADIO_TYPE_A);
 
 		rf_type = le16_to_cpu(rf_chan->rf_type);
-		SET_SECONDARYCHAN(rf_type, priv->adapter->chan_offset);
+		SET_SECONDARYCHAN(rf_type, priv->adapter->sec_chan_offset);
 		rf_chan->current_channel = cpu_to_le16(*channel);
 	}
 	rf_chan->action = cpu_to_le16(cmd_action);
-- 
1.7.0.2

