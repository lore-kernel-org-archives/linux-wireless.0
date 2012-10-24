Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556Ab2JXMVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 08:21:08 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Paul Stewart <pstew@chromium.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use blacklist for duplicate IE check
Date: Wed, 24 Oct 2012 14:21:37 +0200
Message-Id: <1351081297-14623-1-git-send-email-johannes@sipsolutions.net> (sfid-20121024_142120_065304_6D305ED3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of the current whitelist which accepts duplicates
only for the quiet and vendor IEs, use a blacklist of all
IEs (that we currently parse) that can't be duplicated.

This avoids detecting a beacon as corrupt in the future
when new IEs are added that can be duplicated.

Cc: Paul Stewart <pstew@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 22ca350..e6e4bda 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -643,13 +643,41 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			break;
 		}
 
-		if (id != WLAN_EID_VENDOR_SPECIFIC &&
-		    id != WLAN_EID_QUIET &&
-		    test_bit(id, seen_elems)) {
-			elems->parse_error = true;
-			left -= elen;
-			pos += elen;
-			continue;
+		switch (id) {
+		case WLAN_EID_SSID:
+		case WLAN_EID_SUPP_RATES:
+		case WLAN_EID_FH_PARAMS:
+		case WLAN_EID_DS_PARAMS:
+		case WLAN_EID_CF_PARAMS:
+		case WLAN_EID_TIM:
+		case WLAN_EID_IBSS_PARAMS:
+		case WLAN_EID_CHALLENGE:
+		case WLAN_EID_RSN:
+		case WLAN_EID_ERP_INFO:
+		case WLAN_EID_EXT_SUPP_RATES:
+		case WLAN_EID_HT_CAPABILITY:
+		case WLAN_EID_HT_OPERATION:
+		case WLAN_EID_VHT_CAPABILITY:
+		case WLAN_EID_VHT_OPERATION:
+		case WLAN_EID_MESH_ID:
+		case WLAN_EID_MESH_CONFIG:
+		case WLAN_EID_PEER_MGMT:
+		case WLAN_EID_PREQ:
+		case WLAN_EID_PREP:
+		case WLAN_EID_PERR:
+		case WLAN_EID_RANN:
+		case WLAN_EID_CHANNEL_SWITCH:
+		case WLAN_EID_EXT_CHANSWITCH_ANN:
+		case WLAN_EID_COUNTRY:
+		case WLAN_EID_PWR_CONSTRAINT:
+		case WLAN_EID_TIMEOUT_INTERVAL:
+			if (test_bit(id, seen_elems)) {
+				elems->parse_error = true;
+				left -= elen;
+				pos += elen;
+				continue;
+			}
+			break;
 		}
 
 		if (calc_crc && id < 64 && (filter & (1ULL << id)))
-- 
1.7.10.4

