Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2CMNET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 09:04:19 -0400
Message-Id: <20120313125919.633112600@sipsolutions.net> (sfid-20120313_140424_065595_DC661A93)
Date: Tue, 13 Mar 2012 13:57:04 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] cfg80211: clarify timestamp in cfg80211_inform_bss
References: <20120313125702.703540202@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is intended to be the timestamp sent by the
peer in the beacon/probe response, not any form
of host timestamp. Clarify the documentation and
variable names.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    7 +++----
 net/wireless/scan.c    |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/include/net/cfg80211.h	2012-03-13 09:11:23.000000000 +0100
+++ b/include/net/cfg80211.h	2012-03-13 13:49:53.000000000 +0100
@@ -2697,7 +2697,7 @@ cfg80211_inform_bss_frame(struct wiphy *
  * @wiphy: the wiphy reporting the BSS
  * @channel: The channel the frame was received on
  * @bssid: the BSSID of the BSS
- * @timestamp: the TSF timestamp sent by the peer
+ * @tsf: the TSF sent by the peer in the beacon/probe response (or 0)
  * @capability: the capability field sent by the peer
  * @beacon_interval: the beacon interval announced by the peer
  * @ie: additional IEs sent by the peer
@@ -2713,9 +2713,8 @@ cfg80211_inform_bss_frame(struct wiphy *
 struct cfg80211_bss * __must_check
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *channel,
-		    const u8 *bssid,
-		    u64 timestamp, u16 capability, u16 beacon_interval,
-		    const u8 *ie, size_t ielen,
+		    const u8 *bssid, u64 tsf, u16 capability,
+		    u16 beacon_interval, const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp);
 
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
--- a/net/wireless/scan.c	2012-03-10 09:17:06.000000000 +0100
+++ b/net/wireless/scan.c	2012-03-13 13:50:24.000000000 +0100
@@ -734,9 +734,8 @@ cfg80211_bss_update(struct cfg80211_regi
 struct cfg80211_bss*
 cfg80211_inform_bss(struct wiphy *wiphy,
 		    struct ieee80211_channel *channel,
-		    const u8 *bssid,
-		    u64 timestamp, u16 capability, u16 beacon_interval,
-		    const u8 *ie, size_t ielen,
+		    const u8 *bssid, u64 tsf, u16 capability,
+		    u16 beacon_interval, const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp)
 {
 	struct cfg80211_internal_bss *res;
@@ -758,7 +757,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	memcpy(res->pub.bssid, bssid, ETH_ALEN);
 	res->pub.channel = channel;
 	res->pub.signal = signal;
-	res->pub.tsf = timestamp;
+	res->pub.tsf = tsf;
 	res->pub.beacon_interval = beacon_interval;
 	res->pub.capability = capability;
 	/*


