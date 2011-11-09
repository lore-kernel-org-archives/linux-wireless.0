Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707Ab1KIUds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 15:33:48 -0500
Subject: [PATCH] wireless: move ieee80211chan2mhz macro
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 21:33:45 +0100
Message-ID: <1320870825.3845.92.camel@jlt3.sipsolutions.net> (sfid-20111109_213403_062831_EE68F53A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The macro is only used in ipw2200 and we certainly
don't want to encourage its use, so move it out of
the radiotap header file and into the driver.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    8 ++++++++
 include/net/ieee80211_radiotap.h       |    8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ipw2x00/ipw2200.c	2011-11-09 10:07:12.000000000 +0100
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c	2011-11-09 21:32:19.000000000 +0100
@@ -131,6 +131,14 @@ static struct ieee80211_rate ipw2200_rat
 #define ipw2200_bg_rates	(ipw2200_rates + 0)
 #define ipw2200_num_bg_rates	12
 
+/* Ugly macro to convert literal channel numbers into their mhz equivalents
+ * There are certianly some conditions that will break this (like feeding it '30')
+ * but they shouldn't arise since nothing talks on channel 30. */
+#define ieee80211chan2mhz(x) \
+	(((x) <= 14) ? \
+	(((x) == 14) ? 2484 : ((x) * 5) + 2407) : \
+	((x) + 1000) * 5)
+
 #ifdef CONFIG_IPW2200_QOS
 static int qos_enable = 0;
 static int qos_burst_enable = 0;
--- a/include/net/ieee80211_radiotap.h	2011-11-08 18:04:29.000000000 +0100
+++ b/include/net/ieee80211_radiotap.h	2011-11-09 21:32:20.000000000 +0100
@@ -271,14 +271,6 @@ enum ieee80211_radiotap_type {
 #define IEEE80211_RADIOTAP_MCS_FEC_LDPC		0x10
 
 
-/* Ugly macro to convert literal channel numbers into their mhz equivalents
- * There are certianly some conditions that will break this (like feeding it '30')
- * but they shouldn't arise since nothing talks on channel 30. */
-#define ieee80211chan2mhz(x) \
-	(((x) <= 14) ? \
-	(((x) == 14) ? 2484 : ((x) * 5) + 2407) : \
-	((x) + 1000) * 5)
-
 /* helpers */
 static inline int ieee80211_get_radiotap_len(unsigned char *data)
 {


