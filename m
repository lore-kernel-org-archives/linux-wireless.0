Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55347 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbYJ3KM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:12:57 -0400
Subject: [PATCH] wireless: implement basic rate helper function
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 20:00:45 +0100
Message-Id: <1225306845.5439.29.camel@johannes.berg> (sfid-20081030_111311_687869_656104BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a helper function that, given a bitmap of basic
rates and a bitrate returns the response rate for this rate.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/wireless.h |   16 ++++++++++++++++
 net/wireless/util.c    |   19 +++++++++++++++++++
 2 files changed, 35 insertions(+)

--- everything.orig/net/wireless/util.c	2008-10-29 19:16:26.000000000 +0100
+++ everything/net/wireless/util.c	2008-10-29 19:16:54.000000000 +0100
@@ -7,6 +7,25 @@
 #include <asm/bitops.h>
 #include "core.h"
 
+struct ieee80211_rate *
+ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
+			    u64 basic_rates, int bitrate)
+{
+	struct ieee80211_rate *result = &sband->bitrates[0];
+	int i;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (!(basic_rates & BIT(i)))
+			continue;
+		if (sband->bitrates[i].bitrate > bitrate)
+			continue;
+		result = &sband->bitrates[i];
+	}
+
+	return result;
+}
+EXPORT_SYMBOL(ieee80211_get_response_rate);
+
 int ieee80211_channel_to_frequency(int chan)
 {
 	if (chan < 14)
--- everything.orig/include/net/wireless.h	2008-10-29 19:16:26.000000000 +0100
+++ everything/include/net/wireless.h	2008-10-29 19:16:47.000000000 +0100
@@ -341,6 +341,22 @@ ieee80211_get_channel(struct wiphy *wiph
 }
 
 /**
+ * ieee80211_get_response_rate - get basic rate for a given rate
+ *
+ * @sband: the band to look for rates in
+ * @basic_rates: bitmap of basic rates
+ * @bitrate: the bitrate for which to find the basic rate
+ *
+ * This function returns the basic rate corresponding to a given
+ * bitrate, that is the next lower bitrate contained in the basic
+ * rate map, which is, for this function, given as a bitmap of
+ * indices of rates in the band's bitrate table.
+ */
+struct ieee80211_rate *
+ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
+			    u64 basic_rates, int bitrate);
+
+/**
  * regulatory_hint - driver hint to the wireless core a regulatory domain
  * @wiphy: the wireless device giving the hint (used only for reporting
  *	conflicts)


