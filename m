Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35965 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761671AbdACW5i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 17:57:38 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V5 2/3] cfg80211: move function checking range fit to util.c
Date: Tue,  3 Jan 2017 23:57:13 +0100
Message-Id: <20170103225715.14072-2-zajec5@gmail.com> (sfid-20170103_235743_211874_63E8B173)
In-Reply-To: <20170103225715.14072-1-zajec5@gmail.com>
References: <20170103225715.14072-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

It is needed for another cfg80211 helper that will be out of reg.c so
move it to common util.c file and make it non-static.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V5: Add this patch as suggested by Arend
---
 net/wireless/core.h |  3 +++
 net/wireless/reg.c  | 27 +++++++--------------------
 net/wireless/util.c | 15 +++++++++++++++
 3 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index af6e023..bc8ba6e 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -430,6 +430,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 
+bool cfg80211_does_bw_fit_range(const struct ieee80211_freq_range *freq_range,
+				u32 center_freq_khz, u32 bw_khz);
+
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
  * @wiphy: the wiphy to validate against
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5dbac37..753efcd 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -748,21 +748,6 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 	return true;
 }
 
-static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
-			    u32 center_freq_khz, u32 bw_khz)
-{
-	u32 start_freq_khz, end_freq_khz;
-
-	start_freq_khz = center_freq_khz - (bw_khz/2);
-	end_freq_khz = center_freq_khz + (bw_khz/2);
-
-	if (start_freq_khz >= freq_range->start_freq_khz &&
-	    end_freq_khz <= freq_range->end_freq_khz)
-		return true;
-
-	return false;
-}
-
 /**
  * freq_in_rule_band - tells us if a frequency is in a frequency band
  * @freq_range: frequency rule we want to query
@@ -1070,7 +1055,7 @@ freq_reg_info_regd(u32 center_freq,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, bw);
+		bw_fits = cfg80211_does_bw_fit_range(fr, center_freq, bw);
 
 		if (band_rule_found && bw_fits)
 			return rr;
@@ -1138,11 +1123,13 @@ static uint32_t reg_rule_to_chan_bw_flags(const struct ieee80211_regdomain *regd
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
 
 	/* If we get a reg_rule we can assume that at least 5Mhz fit */
-	if (!reg_does_bw_fit(freq_range, MHZ_TO_KHZ(chan->center_freq),
-			     MHZ_TO_KHZ(10)))
+	if (!cfg80211_does_bw_fit_range(freq_range,
+					MHZ_TO_KHZ(chan->center_freq),
+					MHZ_TO_KHZ(10)))
 		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
-	if (!reg_does_bw_fit(freq_range, MHZ_TO_KHZ(chan->center_freq),
-			     MHZ_TO_KHZ(20)))
+	if (!cfg80211_does_bw_fit_range(freq_range,
+					MHZ_TO_KHZ(chan->center_freq),
+					MHZ_TO_KHZ(20)))
 		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 
 	if (max_bandwidth_khz < MHZ_TO_KHZ(10))
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2cf7df8..62dc214 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1847,6 +1847,21 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f)
 }
 EXPORT_SYMBOL(cfg80211_free_nan_func);
 
+bool cfg80211_does_bw_fit_range(const struct ieee80211_freq_range *freq_range,
+				u32 center_freq_khz, u32 bw_khz)
+{
+	u32 start_freq_khz, end_freq_khz;
+
+	start_freq_khz = center_freq_khz - (bw_khz / 2);
+	end_freq_khz = center_freq_khz + (bw_khz / 2);
+
+	if (start_freq_khz >= freq_range->start_freq_khz &&
+	    end_freq_khz <= freq_range->end_freq_khz)
+		return true;
+
+	return false;
+}
+
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
 const unsigned char rfc1042_header[] __aligned(2) =
-- 
2.10.1
