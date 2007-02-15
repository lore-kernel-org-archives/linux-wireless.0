Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965742AbXBOPAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:00:06 -0500
Message-Id: <20070215144300.830181000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:51 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 10/10] cfg/nl80211: remove legacy network id
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the legacy network ID.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |    4 ----
 include/net/cfg80211.h  |   10 ++++------
 net/wireless/nl80211.c  |   10 ----------
 3 files changed, 4 insertions(+), 20 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-02-15 12:28:37.497940064 +0100
+++ wireless-dev/include/linux/nl80211.h	2007-02-15 12:28:42.007940064 +0100
@@ -161,10 +161,6 @@ enum {
 	/* wiphy list */
 	NL80211_ATTR_WIPHY_LIST,
 
-	/* attributes used for configuration */
-	/* network ID (pre 802.11 HW) */
-	NL80211_ATTR_NETWORK_ID,
-
 	/* channel, 1-14 are B/G */
 	NL80211_ATTR_CHANNEL,
 
--- wireless-dev.orig/include/net/cfg80211.h	2007-02-15 12:28:41.297940064 +0100
+++ wireless-dev/include/net/cfg80211.h	2007-02-15 12:28:42.007940064 +0100
@@ -23,7 +23,6 @@ struct cfg80211_config {
 	s8 ssid_len;
 	u8 ssid[SSID_MAX_LEN];
 
-	u16 network_id;
 	s32 rx_sensitivity;
 	u32 transmit_power;
 	u32 fragmentation_threshold;
@@ -31,11 +30,10 @@ struct cfg80211_config {
 };
 
 #define CFG80211_CFG_VALID_SSID			(1<<0)
-#define CFG80211_CFG_VALID_NWID			(1<<1)
-#define CFG80211_CFG_VALID_RX_SENSITIVITY	(1<<2)
-#define CFG80211_CFG_VALID_TRANSMIT_POWER	(1<<3)
-#define CFG80211_CFG_VALID_FRAG_THRESHOLD	(1<<4)
-#define CFG80211_CFG_VALID_CHANNEL		(1<<5)
+#define CFG80211_CFG_VALID_RX_SENSITIVITY	(1<<1)
+#define CFG80211_CFG_VALID_TRANSMIT_POWER	(1<<2)
+#define CFG80211_CFG_VALID_FRAG_THRESHOLD	(1<<3)
+#define CFG80211_CFG_VALID_CHANNEL		(1<<4)
 
 struct scan_channel {
 	u32 channel;
--- wireless-dev.orig/net/wireless/nl80211.c	2007-02-15 12:28:41.307940064 +0100
+++ wireless-dev/net/wireless/nl80211.c	2007-02-15 12:28:42.007940064 +0100
@@ -75,7 +75,6 @@ static struct nla_policy nl80211_policy[
 				 .len = NL80211_MAX_FRAME_LEN },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
-	[NL80211_ATTR_NETWORK_ID] = { .type = NLA_U16 },
 	[NL80211_ATTR_CHANNEL] = { .type = NLA_U32 },
 	[NL80211_ATTR_RX_SENSITIVITY] = { .type = NLA_U32 },
 	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
@@ -393,12 +392,6 @@ static int nl80211_configure(struct sk_b
 		memcpy(config.ssid, nla_data(attr), config.ssid_len);
 	}
 
-	attr = info->attrs[NL80211_ATTR_NETWORK_ID];
-	if (attr) {
-		config.valid |= CFG80211_CFG_VALID_NWID;
-		config.network_id = nla_get_u16(attr);
-	}
-
 	attr = info->attrs[NL80211_ATTR_RX_SENSITIVITY];
 	if (attr) {
 		config.valid |= CFG80211_CFG_VALID_RX_SENSITIVITY;
@@ -465,9 +458,6 @@ static int nl80211_get_config(struct sk_
 	if (config.ssid)
 		NLA_PUT_STRING(msg, NL80211_ATTR_SSID, config.ssid);
 
-	if (config.valid & CFG80211_CFG_VALID_NWID)
-		NLA_PUT_U16(msg, NL80211_ATTR_NETWORK_ID, config.network_id);
-
 	if (config.valid & CFG80211_CFG_VALID_RX_SENSITIVITY)
 		NLA_PUT_U32(msg, NL80211_ATTR_RX_SENSITIVITY, (u32)config.rx_sensitivity);
 

--

