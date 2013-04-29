Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3D2KKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 06:10:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix WoWLAN wakeup tracing
Date: Mon, 29 Apr 2013 12:10:23 +0200
Message-Id: <1367230223-16740-1-git-send-email-johannes@sipsolutions.net> (sfid-20130429_121039_695193_E0DA9A6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the device reports a non-wireless wakeup reason, the
tracing code crashes trying to dereference a NULL pointer.
Fix this by checking the pointer on all accesses and also
add a non_wireless tag to the event.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/trace.h | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ecd4fce..5755bc1 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2441,6 +2441,7 @@ TRACE_EVENT(cfg80211_report_wowlan_wakeup,
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		WDEV_ENTRY
+		__field(bool, non_wireless)
 		__field(bool, disconnect)
 		__field(bool, magic_pkt)
 		__field(bool, gtk_rekey_failure)
@@ -2449,20 +2450,22 @@ TRACE_EVENT(cfg80211_report_wowlan_wakeup,
 		__field(bool, rfkill_release)
 		__field(s32, pattern_idx)
 		__field(u32, packet_len)
-		__dynamic_array(u8, packet, wakeup->packet_present_len)
+		__dynamic_array(u8, packet,
+				wakeup ? wakeup->packet_present_len : 0)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		WDEV_ASSIGN;
-		__entry->disconnect = wakeup->disconnect;
-		__entry->magic_pkt = wakeup->magic_pkt;
-		__entry->gtk_rekey_failure = wakeup->gtk_rekey_failure;
-		__entry->eap_identity_req = wakeup->eap_identity_req;
-		__entry->four_way_handshake = wakeup->four_way_handshake;
-		__entry->rfkill_release = wakeup->rfkill_release;
-		__entry->pattern_idx = wakeup->pattern_idx;
-		__entry->packet_len = wakeup->packet_len;
-		if (wakeup->packet && wakeup->packet_present_len)
+		__entry->non_wireless = !wakeup;
+		__entry->disconnect = wakeup ? wakeup->disconnect : false;
+		__entry->magic_pkt = wakeup ? wakeup->magic_pkt : false;
+		__entry->gtk_rekey_failure = wakeup ? wakeup->gtk_rekey_failure : false;
+		__entry->eap_identity_req = wakeup ? wakeup->eap_identity_req : false;
+		__entry->four_way_handshake = wakeup ? wakeup->four_way_handshake : false;
+		__entry->rfkill_release = wakeup ? wakeup->rfkill_release : false;
+		__entry->pattern_idx = wakeup ? wakeup->pattern_idx : false;
+		__entry->packet_len = wakeup ? wakeup->packet_len : false;
+		if (wakeup && wakeup->packet && wakeup->packet_present_len)
 			memcpy(__get_dynamic_array(packet), wakeup->packet,
 			       wakeup->packet_present_len);
 	),
-- 
1.8.0

