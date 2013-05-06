Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:49901 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab3EFTOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 15:14:11 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 1/4] cfg80211: add chandef to operating class conversion
Date: Mon,  6 May 2013 21:13:52 +0200
Message-Id: <1367867635-3459-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130506_211417_766415_1B9FC633)
In-Reply-To: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This utility functions is needed to convert an chandef to an operating
class. It will be used in extended channel switch announcements.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/cfg80211.h |   11 +++
 net/wireless/util.c    |  193 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 204 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 26e9113..f46ac71 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4061,6 +4061,17 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 bool ieee80211_operating_class_to_band(u8 operating_class,
 				       enum ieee80211_band *band);
 
+/**
+ * ieee80211_operating_class_to_band - convert operating class to band
+ *
+ * @band: pointer to chandef
+ * @operating_class: the operating class to fill
+ *
+ * Returns %true if the conversion was successful, %false otherwise.
+ */
+bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
+					  u8 *operating_class);
+
 /*
  * cfg80211_tdls_oper_request - request userspace to perform TDLS operation
  * @dev: the device on which the operation is requested
diff --git a/net/wireless/util.c b/net/wireless/util.c
index bb52486..50703bf 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1178,6 +1178,199 @@ bool ieee80211_operating_class_to_band(u8 operating_class,
 }
 EXPORT_SYMBOL(ieee80211_operating_class_to_band);
 
+/* return operating class according to IEEE 802.11-12 Table E-4 */
+bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
+					  u8 *operating_class)
+{
+	int ch_num;
+	enum nl80211_channel_type ch_type;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+		break;
+	default:
+		/*
+		 * this function does not support narrow (5, 10 MHz)
+		 * or wide (80, 160 MHz) channels.
+		 */
+		return false;
+	}
+
+	ch_type = cfg80211_get_chandef_type(chandef);
+	ch_num = ieee80211_frequency_to_channel(chandef->chan->center_freq);
+
+	if (chandef->chan->band == IEEE80211_BAND_2GHZ) {
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			if (ch_num == 14) {
+				*operating_class = 82;
+				return true;
+			}
+			*operating_class = 81;
+			return true;
+		case NL80211_CHAN_HT40PLUS:
+			*operating_class = 83;
+			return true;
+		case NL80211_CHAN_HT40MINUS:
+			*operating_class = 84;
+			return true;
+		default:
+			return false;
+		}
+	}
+	if (chandef->chan->band != IEEE80211_BAND_5GHZ)
+		return false;
+
+	/* TODO: handle operating class with 5 MHz and 10 MHz channel width */
+	switch (ch_num) {
+	case 8:
+	case 12:
+	case 16:
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			*operating_class = 112;
+			return true;
+		default:
+			return false;
+		}
+		break;
+	case 36:
+	case 40:
+	case 44:
+	case 48:
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			*operating_class = 115;
+			return true;
+		case NL80211_CHAN_HT40PLUS:
+			*operating_class = 116;
+			return true;
+		case NL80211_CHAN_HT40MINUS:
+			*operating_class = 117;
+			return true;
+		default:
+			return false;
+		}
+		break;
+	case 52:
+	case 56:
+	case 60:
+	case 64:
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			*operating_class = 118;
+			return true;
+		case NL80211_CHAN_HT40PLUS:
+			*operating_class = 119;
+			return true;
+		case NL80211_CHAN_HT40MINUS:
+			*operating_class = 120;
+			return true;
+		default:
+			return false;
+		}
+		break;
+	case 100:
+	case 104:
+	case 108:
+	case 112:
+	case 116:
+	case 120:
+	case 124:
+	case 128:
+	case 132:
+	case 136:
+	case 140:
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			*operating_class = 121;
+			return true;
+		case NL80211_CHAN_HT40PLUS:
+			*operating_class = 122;
+			return true;
+		case NL80211_CHAN_HT40MINUS:
+			*operating_class = 123;
+			return true;
+		default:
+			return false;
+		}
+		break;
+	case 149:
+	case 153:
+	case 157:
+	case 161:
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			/*
+			 * NOTE: These channels are also included in operating
+			 * class 125, marked as "LicenseExcemptBehavior".
+			 */
+			*operating_class = 124;
+			return true;
+		case NL80211_CHAN_HT40PLUS:
+			*operating_class = 126;
+			return true;
+		case NL80211_CHAN_HT40MINUS:
+			*operating_class = 127;
+			return true;
+		default:
+			return false;
+		}
+		break;
+	case 165:
+	case 169:
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			*operating_class = 125;
+			return true;
+		default:
+			return false;
+		}
+		break;
+	case 184:
+	case 188:
+	case 192:
+	case 196:
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			*operating_class = 109;
+			return true;
+		case NL80211_CHAN_HT40PLUS:
+			*operating_class = 104;
+			return true;
+		case NL80211_CHAN_HT40MINUS:
+			*operating_class = 105;
+			return true;
+		default:
+			return false;
+		}
+		break;
+	case 191:
+	case 195:
+		switch (ch_type) {
+		case NL80211_CHAN_NO_HT:
+		case NL80211_CHAN_HT20:
+			*operating_class = 106;
+			return true;
+		default:
+			return false;
+		}
+		break;
+	}
+	return false;
+}
+EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
+
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int)
 {
-- 
1.7.10.4

