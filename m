Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45937 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYKVUBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 15:01:32 -0500
Date: Sat, 22 Nov 2008 22:00:31 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Change max TX power to be in mBm instead of dBm
Message-ID: <20081122200031.GB8265@jm.kir.nu> (sfid-20081122_210147_742533_3B0E19CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to be consistent with NL80211_ATTR_POWER_RULE_MAX_EIRP,
change NL80211_FREQUENCY_ATTR_MAX_TX_POWER to use mBm and U32 instead
of dBm and U8. This is a userspace interface change, but the previous
version had not yet been pushed upstream and there are no userspace
programs using this yet, so there is justification to get this change in
as long as it goes in before the previous version gets out.

Signed-off-by: Jouni Malinen <j@w1.fi>


Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h	2008-11-22 21:22:06.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2008-11-22 21:22:54.000000000 +0200
@@ -508,7 +508,8 @@
  *	on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_RADAR: Radar detection is mandatory
  *	on this channel in current regulatory domain.
- * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in dBm.
+ * @NL80211_FREQUENCY_ATTR_MAX_TX_POWER: Maximum transmission power in mBm
+ *	(100 * dBm).
  */
 enum nl80211_frequency_attr {
 	__NL80211_FREQUENCY_ATTR_INVALID,
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c	2008-11-22 21:23:10.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2008-11-22 21:23:51.000000000 +0200
@@ -198,8 +198,8 @@
 			if (chan->flags & IEEE80211_CHAN_RADAR)
 				NLA_PUT_FLAG(msg, NL80211_FREQUENCY_ATTR_RADAR);
 
-			NLA_PUT_U8(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
-				   chan->max_power);
+			NLA_PUT_U32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
+				    DBM_TO_MBM(chan->max_power));
 
 			nla_nest_end(msg, nl_freq);
 		}

-- 
Jouni Malinen                                            PGP id EFC895FA
