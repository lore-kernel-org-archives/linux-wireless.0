Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:13468 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728509AbeHMPXU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 11:23:20 -0400
From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH 1/3] cfg80211: Add support for 60GHz band channels 5 and 6
Date: Mon, 13 Aug 2018 15:33:00 +0300
Message-Id: <1534163582-9983-2-git-send-email-ailizaro@codeaurora.org> (sfid-20180813_144124_051097_CFD42B20)
In-Reply-To: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org>
References: <1534163582-9983-1-git-send-email-ailizaro@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current support in the 60GHz band is for channels 1-4.
Add support for channels 5 and 6.
This requires enlarging ieee80211_channel.center_freq from u16 to u32.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 2 +-
 include/net/cfg80211.h                     | 2 +-
 include/uapi/linux/nl80211.h               | 2 +-
 net/wireless/reg.c                         | 2 +-
 net/wireless/trace.h                       | 2 +-
 net/wireless/util.c                        | 6 +++---
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 58ce044..4b329d1 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1435,7 +1435,7 @@ static int wil_freq_debugfs_show(struct seq_file *s, void *data)
 {
 	struct wil6210_priv *wil = s->private;
 	struct wireless_dev *wdev = wil->main_ndev->ieee80211_ptr;
-	u16 freq = wdev->chandef.chan ? wdev->chandef.chan->center_freq : 0;
+	u32 freq = wdev->chandef.chan ? wdev->chandef.chan->center_freq : 0;
 
 	seq_printf(s, "Freq = %d\n", freq);
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9a85097..73ca446 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -149,7 +149,7 @@ enum ieee80211_channel_flags {
  */
 struct ieee80211_channel {
 	enum nl80211_band band;
-	u16 center_freq;
+	u32 center_freq;
 	u16 hw_value;
 	u32 flags;
 	int max_antenna_gain;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7acc16f..0239896 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4338,7 +4338,7 @@ enum nl80211_txrate_gi {
  * enum nl80211_band - Frequency band
  * @NL80211_BAND_2GHZ: 2.4 GHz ISM band
  * @NL80211_BAND_5GHZ: around 5 GHz band (4.9 - 5.7 GHz)
- * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 64.80 GHz)
+ * @NL80211_BAND_60GHZ: around 60 GHz band (58.32 - 69.12 GHz)
  * @NUM_NL80211_BANDS: number of bands, avoid using this in userspace
  *	since newer kernel versions may support more bands
  */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4fc66a1..2f8e01a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3255,7 +3255,7 @@ void regulatory_hint_disconnect(void)
 	restore_regulatory_settings(false);
 }
 
-static bool freq_is_chan_12_13_14(u16 freq)
+static bool freq_is_chan_12_13_14(u32 freq)
 {
 	if (freq == ieee80211_channel_to_frequency(12, NL80211_BAND_2GHZ) ||
 	    freq == ieee80211_channel_to_frequency(13, NL80211_BAND_2GHZ) ||
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 7c73510..5e7eec8 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -112,7 +112,7 @@
 	} while (0)
 
 #define CHAN_ENTRY __field(enum nl80211_band, band) \
-		   __field(u16, center_freq)
+		   __field(u32, center_freq)
 #define CHAN_ASSIGN(chan)					  \
 	do {							  \
 		if (chan) {					  \
diff --git a/net/wireless/util.c b/net/wireless/util.c
index e0825a0..a450736 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -88,7 +88,7 @@ int ieee80211_channel_to_frequency(int chan, enum nl80211_band band)
 			return 5000 + chan * 5;
 		break;
 	case NL80211_BAND_60GHZ:
-		if (chan < 5)
+		if (chan < 7)
 			return 56160 + chan * 2160;
 		break;
 	default:
@@ -109,7 +109,7 @@ int ieee80211_frequency_to_channel(int freq)
 		return (freq - 4000) / 5;
 	else if (freq <= 45000) /* DMG band lower limit */
 		return (freq - 5000) / 5;
-	else if (freq >= 58320 && freq <= 64800)
+	else if (freq >= 58320 && freq <= 70200)
 		return (freq - 56160) / 2160;
 	else
 		return 0;
@@ -1568,7 +1568,7 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 	}
 
 	/* 56.16 GHz, channel 1..4 */
-	if (freq >= 56160 + 2160 * 1 && freq <= 56160 + 2160 * 4) {
+	if (freq >= 56160 + 2160 * 1 && freq <= 56160 + 2160 * 6) {
 		if (chandef->width >= NL80211_CHAN_WIDTH_40)
 			return false;
 
-- 
1.9.1
