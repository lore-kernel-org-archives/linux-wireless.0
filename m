Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60011 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3IIDmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 23:42:16 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so5651993pdj.17
        for <linux-wireless@vger.kernel.org>; Sun, 08 Sep 2013 20:42:15 -0700 (PDT)
From: Fred Zhou <fred.zy@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Fred Zhou <fred.zy@gmail.com>
Subject: [PATCH] mac80211: do not check duplicate IEs when parsing elements.
Date: Mon,  9 Sep 2013 11:41:54 +0800
Message-Id: <1378698114-18930-1-git-send-email-fred.zy@gmail.com> (sfid-20130909_054219_207398_CF7CDE15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 The 802.11 standard does not prevent the same IE to be
 included in one frame (e.g. beacon)  multiple times. When
 the same ID is seen more than once, it should not be
 declared to be parse error. Remove the checking for
 duplicate  IE.

Signed-off-by: Fred Zhou <fred.zy@gmail.com>

---
 net/mac80211/util.c |   43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e1b34a1..49c92af 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -716,49 +716,6 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			break;
 		}
 
-		switch (id) {
-		case WLAN_EID_SSID:
-		case WLAN_EID_SUPP_RATES:
-		case WLAN_EID_FH_PARAMS:
-		case WLAN_EID_DS_PARAMS:
-		case WLAN_EID_CF_PARAMS:
-		case WLAN_EID_TIM:
-		case WLAN_EID_IBSS_PARAMS:
-		case WLAN_EID_CHALLENGE:
-		case WLAN_EID_RSN:
-		case WLAN_EID_ERP_INFO:
-		case WLAN_EID_EXT_SUPP_RATES:
-		case WLAN_EID_HT_CAPABILITY:
-		case WLAN_EID_HT_OPERATION:
-		case WLAN_EID_VHT_CAPABILITY:
-		case WLAN_EID_VHT_OPERATION:
-		case WLAN_EID_MESH_ID:
-		case WLAN_EID_MESH_CONFIG:
-		case WLAN_EID_PEER_MGMT:
-		case WLAN_EID_PREQ:
-		case WLAN_EID_PREP:
-		case WLAN_EID_PERR:
-		case WLAN_EID_RANN:
-		case WLAN_EID_CHANNEL_SWITCH:
-		case WLAN_EID_EXT_CHANSWITCH_ANN:
-		case WLAN_EID_COUNTRY:
-		case WLAN_EID_PWR_CONSTRAINT:
-		case WLAN_EID_TIMEOUT_INTERVAL:
-		case WLAN_EID_SECONDARY_CHANNEL_OFFSET:
-		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
-		/*
-		 * not listing WLAN_EID_CHANNEL_SWITCH_WRAPPER -- it seems possible
-		 * that if the content gets bigger it might be needed more than once
-		 */
-			if (test_bit(id, seen_elems)) {
-				elems->parse_error = true;
-				left -= elen;
-				pos += elen;
-				continue;
-			}
-			break;
-		}
-
 		if (calc_crc && id < 64 && (filter & (1ULL << id)))
 			crc = crc32_be(crc, pos - 2, elen + 2);
 
-- 
1.7.9.5

