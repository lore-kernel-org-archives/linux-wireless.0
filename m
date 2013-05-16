Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50006 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3EPLB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 07:01:58 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 02/18] nl80211: add rate flags for 5/10 Mhz channels
Date: Thu, 16 May 2013 13:00:29 +0200
Message-Id: <1368702045-27598-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130516_130202_814036_25AB9975)
In-Reply-To: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/net/cfg80211.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 08489cc..c9f5194 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -188,6 +188,8 @@ struct ieee80211_channel {
  *	when used with 802.11g (on the 2.4 GHz band); filled by the
  *	core code when registering the wiphy.
  * @IEEE80211_RATE_ERP_G: This is an ERP rate in 802.11g mode.
+ * @IEEE80211_RATE_SUPPORTS_5MHZ: Rate can be used in 5 MHz mode
+ * @IEEE80211_RATE_SUPPORTS_10MHZ: Rate can be used in 10 MHz mode
  */
 enum ieee80211_rate_flags {
 	IEEE80211_RATE_SHORT_PREAMBLE	= 1<<0,
@@ -195,6 +197,8 @@ enum ieee80211_rate_flags {
 	IEEE80211_RATE_MANDATORY_B	= 1<<2,
 	IEEE80211_RATE_MANDATORY_G	= 1<<3,
 	IEEE80211_RATE_ERP_G		= 1<<4,
+	IEEE80211_RATE_SUPPORTS_5MHZ	= 1<<5,
+	IEEE80211_RATE_SUPPORTS_10MHZ	= 1<<6,
 };
 
 /**
@@ -433,6 +437,30 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			     u32 prohibited_flags);
 
 /**
+ * ieee80211_chandef_rate_flags - returns rate flags for a channel
+ *
+ * In some channel types, not all rates may be used - for example CCK
+ * rates may not be used in 5/10 MHz channels.
+ *
+ * @chandef: channel definition for the channel
+ *
+ * Returns: rate flags which apply for this channel
+ */
+static inline enum ieee80211_rate_flags
+ieee80211_chandef_rate_flags(struct cfg80211_chan_def *chandef)
+{
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+		return IEEE80211_RATE_SUPPORTS_5MHZ;
+	case NL80211_CHAN_WIDTH_10:
+		return IEEE80211_RATE_SUPPORTS_10MHZ;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/**
  * enum survey_info_flags - survey information flags
  *
  * @SURVEY_INFO_NOISE_DBM: noise (in dBm) was filled in
-- 
1.7.10.4

