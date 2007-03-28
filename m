Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbXC2LIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:08:23 -0400
Received: from [131.234.78.148]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.66)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HWsUP-0005FZ-1b
	for linux-wireless@vger.kernel.org; Thu, 29 Mar 2007 12:08:21 +0100
Subject: [FYI] use NLA_BINARY in nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 00:20:08 +0200
Message-Id: <1175120409.8807.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unfortunately I hadn't noticed when starting nl80211 that NLA_STRING
validation removes a trailing \0. This means that we have a problem
right now with SSIDs for example in nl80211 when they end with \0, or,
more importantly maybe, with key data as well.

This patch changes this to use the new NLA_BINARY attribute type I
created but which isn't in wireless-dev yet, it is in davem's .22 branch
though.

---
 net/wireless/nl80211.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- wireless-dev.orig/net/wireless/nl80211.c	2007-03-29 00:16:07.935831178 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-03-29 00:16:14.825831178 +0200
@@ -75,7 +75,7 @@ static struct nla_policy nl80211_policy[
 				      .len = BUS_ID_SIZE-1 },
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
-	[NL80211_ATTR_SSID] = { .type = NLA_STRING,
+	[NL80211_ATTR_SSID] = { .type = NLA_BINARY,
 				.len = IEEE80211_MAX_SSID_LEN },
 	[NL80211_ATTR_CHANNEL] = { .type = NLA_U32 },
 	[NL80211_ATTR_PHYMODE] = { .type = NLA_U32 },
@@ -85,7 +85,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_BEACON_PERIOD] = { .type = NLA_U32 },
 	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
 	[NL80211_ATTR_TIMESTAMP] = { .type = NLA_U64 },
-	[NL80211_ATTR_IE] = { .type = NLA_STRING, .len = NL80211_MAX_IE_LEN },
+	[NL80211_ATTR_IE] = { .type = NLA_BINARY, .len = NL80211_MAX_IE_LEN },
 	[NL80211_ATTR_AUTH_ALGORITHM] = { .type = NLA_U32 },
 	[NL80211_ATTR_TIMEOUT_TU] = { .type = NLA_U32 },
 	[NL80211_ATTR_REASON_CODE] = { .type = NLA_U32 },
@@ -95,9 +95,10 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_TRANSMIT_POWER] = { .type = NLA_U32 },
 	[NL80211_ATTR_FRAG_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_FLAG_SCAN_ACTIVE] = { .type = NLA_FLAG },
-	[NL80211_ATTR_BEACON_HEAD] = { .type = NLA_STRING },
-	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_STRING },
-	[NL80211_ATTR_KEY_DATA] = { .type = NLA_STRING, .len = WLAN_MAX_KEY_LEN },
+	[NL80211_ATTR_BEACON_HEAD] = { .type = NLA_BINARY },
+	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_BINARY },
+	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
+				    .len = WLAN_MAX_KEY_LEN },
 	[NL80211_ATTR_KEY_ID] = { .type = NLA_U32 },
 	[NL80211_ATTR_KEY_TYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_MAC] = { .len = ETH_ALEN },


