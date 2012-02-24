Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51578 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2BXDhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 22:37:32 -0500
Received: by eekb15 with SMTP id b15so61704eek.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 19:37:30 -0800 (PST)
MIME-Version: 1.0
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by hpza10.eem.corp.google.com (Postfix) with ESMTP id 58B7F20004E
	for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 19:37:30 -0800 (PST)
From: Paul Stewart <pstew@chromium.org>
Date: Thu, 23 Feb 2012 17:59:53 -0800
Subject: [RFC] mac80211: Filter duplicate IE ids
To: linux-wireless@vger.kernel.org
Message-Id: <20120224033729.9256A205A0@glenhelen.mtv.corp.google.com> (sfid-20120224_043736_015339_A91A0A49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 is lenient with respect to reception of corrupted beacons.
Even if the frame is corrupted as a whole, the available IE elements
are still passed back and accepted, sometimes replacing legitimate
data.  It is unknown to what extent this "feature" is made use of,
but it is clear that in some cases, this is detrimental.  One such
case is reported in http://crosbug.com/26832 where an AP corrupts
its beacons but not its probe responses.

One approach would be to completely reject frames with invaid data
(for example, if the last tag extends beyond the end of the enclosing
PDU).  The enclosed approach is much more conservative: we simply
prevent later IEs from overwriting the state from previous ones.
This approach hopes that there might be some salient data in the
IE stream before the corruption, and seeks to at least prevent that
data from being overwritten.  This approach will fix the case above.

Short of any statistics gathering in the various forms of AP breakage,
it's not possible to ascertain the side effects of more stringent
discarding of data.

Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 net/mac80211/util.c |   36 ++++++++++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 264397a..661047c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -572,6 +572,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 	size_t left = len;
 	u8 *pos = start;
 	bool calc_crc = filter != 0;
+	u64 seen_elems;
 
 	memset(elems, 0, sizeof(*elems));
 	elems->ie_start = start;
@@ -579,6 +580,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 
 	while (left >= 2) {
 		u8 id, elen;
+		bool parse_failed = false;
 
 		id = *pos++;
 		elen = *pos++;
@@ -587,8 +589,21 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		if (elen > left)
 			break;
 
-		if (calc_crc && id < 64 && (filter & (1ULL << id)))
-			crc = crc32_be(crc, pos - 2, elen + 2);
+		if (id < 64) {
+			if (seen_elems & (1ULL << id)) {
+				/*
+				 * Advance past duplicate entries with
+				 * id < 64.  Notably this excludes vendor
+				 * specific codes which may appear repeatedly.
+				 */
+				left -= elen;
+				pos += elen;
+				continue;
+			}
+
+			if (calc_crc && (filter & (1ULL << id)))
+				crc = crc32_be(crc, pos - 2, elen + 2);
+		}
 
 		switch (id) {
 		case WLAN_EID_SSID:
@@ -615,7 +630,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			if (elen >= sizeof(struct ieee80211_tim_ie)) {
 				elems->tim = (void *)pos;
 				elems->tim_len = elen;
-			}
+			} else
+				parse_failed = true;
 			break;
 		case WLAN_EID_IBSS_PARAMS:
 			elems->ibss_params = pos;
@@ -664,10 +680,14 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		case WLAN_EID_HT_CAPABILITY:
 			if (elen >= sizeof(struct ieee80211_ht_cap))
 				elems->ht_cap_elem = (void *)pos;
+			else
+				parse_failed = true;
 			break;
 		case WLAN_EID_HT_INFORMATION:
 			if (elen >= sizeof(struct ieee80211_ht_info))
 				elems->ht_info_elem = (void *)pos;
+			else
+				parse_failed = true;
 			break;
 		case WLAN_EID_MESH_ID:
 			elems->mesh_id = pos;
@@ -676,6 +696,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		case WLAN_EID_MESH_CONFIG:
 			if (elen >= sizeof(struct ieee80211_meshconf_ie))
 				elems->mesh_config = (void *)pos;
+			else
+				parse_failed = true;
 			break;
 		case WLAN_EID_PEER_MGMT:
 			elems->peering = pos;
@@ -696,6 +718,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 		case WLAN_EID_RANN:
 			if (elen >= sizeof(struct ieee80211_rann_ie))
 				elems->rann = (void *)pos;
+			else
+				parse_failed = true;
 			break;
 		case WLAN_EID_CHANNEL_SWITCH:
 			elems->ch_switch_elem = pos;
@@ -705,7 +729,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			if (!elems->quiet_elem) {
 				elems->quiet_elem = pos;
 				elems->quiet_elem_len = elen;
-			}
+			} else
+				parse_failed = true;
 			elems->num_of_quiet_elem++;
 			break;
 		case WLAN_EID_COUNTRY:
@@ -724,6 +749,9 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			break;
 		}
 
+		if (!parse_failed && id < 64)
+			seen_elems |= (1ULL << id);
+
 		left -= elen;
 		pos += elen;
 	}
-- 
1.7.7.3

