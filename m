Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42498 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759448AbZAVXGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:06:38 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 15:06:38 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 03/12] cfg80211: export freq_reg_info()
Date: Thu, 22 Jan 2009 15:05:45 -0800
Message-ID: <1232665554-26132-4-git-send-email-lrodriguez@atheros.com> (sfid-20090123_000642_729968_20A0281C)
In-Reply-To: <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
References: <1232665554-26132-1-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-2-git-send-email-lrodriguez@atheros.com>
 <1232665554-26132-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used by drivers on the reg_notifier()

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/wireless.h |   24 ++++++++++++++++++++++++
 net/wireless/reg.c     |   24 ++----------------------
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/net/wireless.h b/include/net/wireless.h
index 585caad..a8971f6 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -418,4 +418,28 @@ extern void wiphy_apply_custom_regulatory(
 	struct wiphy *wiphy,
 	const struct ieee80211_regdomain *regd);
 
+/**
+ * freq_reg_info - get regulatory information for the given frequency
+ * @wiphy: the wiphy for which we want to process this rule for
+ * @center_freq: Frequency in KHz for which we want regulatory information for
+ * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
+ * 	you can set this to 0. If this frequency is allowed we then set
+ * 	this value to the maximum allowed bandwidth.
+ * @reg_rule: the regulatory rule which we have for this frequency
+ *
+ * Use this function to get the regulatory rule for a specific frequency on
+ * a given wireless device. If the device has a specific regulatory domain
+ * it wants to follow we respect that unless a country IE has been received
+ * and processed already.
+ *
+ * Returns 0 if it was able to find a valid regulatory rule which does
+ * apply to the given center_freq otherwise it returns non-zero. It will
+ * also return -ERANGE if we determine the given center_freq does not even have
+ * a regulatory rule for a frequency range in the center_freq's band. See
+ * freq_in_rule_band() for our current definition of a band -- this is purely
+ * subjective and right now its 802.11 specific.
+ */
+extern int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
+			 const struct ieee80211_reg_rule **reg_rule);
+
 #endif /* __NET_WIRELESS_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2f2f6f5..70691de 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -833,29 +833,9 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 
 	return !max_bandwidth;
 }
+EXPORT_SYMBOL(freq_reg_info);
 
-/**
- * freq_reg_info - get regulatory information for the given frequency
- * @wiphy: the wiphy for which we want to process this rule for
- * @center_freq: Frequency in KHz for which we want regulatory information for
- * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
- * 	you can set this to 0. If this frequency is allowed we then set
- * 	this value to the maximum allowed bandwidth.
- * @reg_rule: the regulatory rule which we have for this frequency
- *
- * Use this function to get the regulatory rule for a specific frequency on
- * a given wireless device. If the device has a specific regulatory domain
- * it wants to follow we respect that unless a country IE has been received
- * and processed already.
- *
- * Returns 0 if it was able to find a valid regulatory rule which does
- * apply to the given center_freq otherwise it returns non-zero. It will
- * also return -ERANGE if we determine the given center_freq does not even have
- * a regulatory rule for a frequency range in the center_freq's band. See
- * freq_in_rule_band() for our current definition of a band -- this is purely
- * subjective and right now its 802.11 specific.
- */
-static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
+int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
 			 const struct ieee80211_reg_rule **reg_rule)
 {
 	return freq_reg_info_regd(wiphy, center_freq,
-- 
1.6.1.rc3.51.g5832d

