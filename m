Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaBDI5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 03:57:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: order IEs in probe request correctly
Date: Tue,  4 Feb 2014 09:57:02 +0100
Message-Id: <1391504223-12060-2-git-send-email-johannes@sipsolutions.net> (sfid-20140204_095717_280762_E9A64B46)
In-Reply-To: <1391504223-12060-1-git-send-email-johannes@sipsolutions.net>
References: <1391504223-12060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In probe request frames, the VHT IEs should come before any
vendor IEs, but after interworking and similar, so add code
to order them correctly wrt. the IEs passed from userspace.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 503bbce..caa0cd4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1281,13 +1281,32 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	 * that calculates local->scan_ies_len.
 	 */
 
-	/* add any remaining custom IEs */
+	/* insert custom IEs that go before VHT */
 	if (ie && ie_len) {
-		noffset = ie_len;
+		static const u8 before_vht[] = {
+			WLAN_EID_SSID,
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_REQUEST,
+			WLAN_EID_EXT_SUPP_RATES,
+			WLAN_EID_DS_PARAMS,
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+			WLAN_EID_HT_CAPABILITY,
+			WLAN_EID_BSS_COEX_2040,
+			WLAN_EID_EXT_CAPABILITY,
+			WLAN_EID_SSID_LIST,
+			WLAN_EID_CHANNEL_USAGE,
+			WLAN_EID_INTERWORKING,
+			/* mesh ID can't happen here */
+			/* 60 GHz can't happen here right now */
+		};
+		noffset = ieee80211_ie_split(ie, ie_len,
+					     before_vht, ARRAY_SIZE(before_vht),
+					     offset);
 		if (end - pos < noffset - offset)
 			goto out_err;
 		memcpy(pos, ie + offset, noffset - offset);
 		pos += noffset - offset;
+		offset = noffset;
 	}
 
 	if (sband->vht_cap.vht_supported) {
@@ -1297,6 +1316,15 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 						 sband->vht_cap.cap);
 	}
 
+	/* add any remaining custom IEs */
+	if (ie && ie_len) {
+		noffset = ie_len;
+		if (end - pos < noffset - offset)
+			goto out_err;
+		memcpy(pos, ie + offset, noffset - offset);
+		pos += noffset - offset;
+	}
+
 	return pos - buffer;
  out_err:
 	WARN_ONCE(1, "not enough space for preq IEs\n");
-- 
1.8.5.3

