Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2CMNER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 09:04:17 -0400
Message-Id: <20120313125919.370791280@sipsolutions.net> (sfid-20120313_140421_642123_6BC8E250)
Date: Tue, 13 Mar 2012 13:57:03 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] brmc80211: dont use jiffies for BSS TSF
References: <20120313125702.703540202@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The cfg80211_inform_bss() timestamp argument is
intended to be the TSF, not any form of host
timestamp.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c	2012-03-10 09:17:00.000000000 +0100
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c	2012-03-13 13:45:43.000000000 +0100
@@ -2003,7 +2003,6 @@ static s32 brcmf_inform_single_bss(struc
 	s32 err = 0;
 	u16 channel;
 	u32 freq;
-	u64 notify_timestamp;
 	u16 notify_capability;
 	u16 notify_interval;
 	u8 *notify_ie;
@@ -2026,7 +2025,6 @@ static s32 brcmf_inform_single_bss(struc
 	freq = ieee80211_channel_to_frequency(channel, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
-	notify_timestamp = jiffies_to_msecs(jiffies)*1000; /* uSec */
 	notify_capability = le16_to_cpu(bi->capability);
 	notify_interval = le16_to_cpu(bi->beacon_period);
 	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
@@ -2040,10 +2038,9 @@ static s32 brcmf_inform_single_bss(struc
 	WL_CONN("Capability: %X\n", notify_capability);
 	WL_CONN("Beacon interval: %d\n", notify_interval);
 	WL_CONN("Signal: %d\n", notify_signal);
-	WL_CONN("notify_timestamp: %#018llx\n", notify_timestamp);
 
 	bss = cfg80211_inform_bss(wiphy, notify_channel, (const u8 *)bi->BSSID,
-		notify_timestamp, notify_capability, notify_interval, notify_ie,
+		0, notify_capability, notify_interval, notify_ie,
 		notify_ielen, notify_signal, GFP_KERNEL);
 
 	if (!bss)
@@ -2098,7 +2095,6 @@ static s32 wl_inform_ibss(struct brcmf_c
 	s32 err = 0;
 	u16 channel;
 	u32 freq;
-	u64 notify_timestamp;
 	u16 notify_capability;
 	u16 notify_interval;
 	u8 *notify_ie;
@@ -2134,7 +2130,6 @@ static s32 wl_inform_ibss(struct brcmf_c
 	freq = ieee80211_channel_to_frequency(channel, band->band);
 	notify_channel = ieee80211_get_channel(wiphy, freq);
 
-	notify_timestamp = jiffies_to_msecs(jiffies)*1000; /* uSec */
 	notify_capability = le16_to_cpu(bi->capability);
 	notify_interval = le16_to_cpu(bi->beacon_period);
 	notify_ie = (u8 *)bi + le16_to_cpu(bi->ie_offset);
@@ -2145,10 +2140,9 @@ static s32 wl_inform_ibss(struct brcmf_c
 	WL_CONN("capability: %X\n", notify_capability);
 	WL_CONN("beacon interval: %d\n", notify_interval);
 	WL_CONN("signal: %d\n", notify_signal);
-	WL_CONN("notify_timestamp: %#018llx\n", notify_timestamp);
 
 	bss = cfg80211_inform_bss(wiphy, notify_channel, bssid,
-		notify_timestamp, notify_capability, notify_interval,
+		0, notify_capability, notify_interval,
 		notify_ie, notify_ielen, notify_signal, GFP_KERNEL);
 
 	if (!bss) {


