Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39462 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYKURCe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 12:02:34 -0500
Date: Fri, 21 Nov 2008 19:01:30 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Report max TX power in NL80211_BAND_ATTR_FREQS
Message-ID: <20081121170130.GA4887@jm.kir.nu> (sfid-20081121_180238_649198_423B9B26)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is useful information to provide for userspace (e.g., hostapd needs
this to generate Country IE).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h	2008-11-21 18:35:40.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2008-11-21 18:38:10.000000000 +0200
@@ -508,6 +508,7 @@
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_RADAR: Radar detection is mandatory
  *	on this channel in current regulatory domain.
+ * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in dBm.
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
@@ -516,12 +517,15 @@
 	NL80211_FREQUENCY_ATTR_PASSIVE_SCAN,
 	NL80211_FREQUENCY_ATTR_NO_IBSS,
 	NL80211_FREQUENCY_ATTR_RADAR,
+	NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
 	NL80211_FREQUENCY_ATTR_MAX = __NL80211_FREQUENCY_ATTR_AFTER_LAST - 1
 };
 
+#define NL80211_FREQUENCY_ATTR_MAX_TX_POWER NL80211_FREQUENCY_ATTR_MAX_TX_POWER
+
 /**
  * enum nl80211_bitrate_attr - bitrate attributes
  * @NL80211_BITRATE_ATTR_RATE: Bitrate in units of 100 kbps
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c	2008-11-21 18:37:10.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2008-11-21 18:37:56.000000000 +0200
@@ -198,6 +198,9 @@
 			if (chan->flags & IEEE80211_CHAN_RADAR)
 				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
 
+			NLA_PUT_U8(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+				   chan->max_power);
+
 			nla_nest_end(msg, nl_freq);
 		}
 

-- 
Jouni Malinen                                            PGP id EFC895FA
