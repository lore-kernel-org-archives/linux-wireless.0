Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47584 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3BLP2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 10:28:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't pick up WPA vendor IE
Date: Tue, 12 Feb 2013 16:28:02 +0100
Message-Id: <1360682882-23014-1-git-send-email-johannes@sipsolutions.net> (sfid-20130212_162813_143448_AD3E94BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no use for it, WPA is entirely handled in
wpa_supplicant in userspace, so don't pick the IE.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 2 --
 net/mac80211/util.c        | 6 +-----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1224859..ab19342 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1166,7 +1166,6 @@ struct ieee802_11_elems {
 	struct ieee80211_tim_ie *tim;
 	u8 *ibss_params;
 	u8 *challenge;
-	u8 *wpa;
 	u8 *rsn;
 	u8 *erp_info;
 	u8 *ext_supp_rates;
@@ -1201,7 +1200,6 @@ struct ieee802_11_elems {
 	u8 tim_len;
 	u8 ibss_params_len;
 	u8 challenge_len;
-	u8 wpa_len;
 	u8 rsn_len;
 	u8 erp_info_len;
 	u8 ext_supp_rates_len;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7fca949..858ca57 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -739,11 +739,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 				if (calc_crc)
 					crc = crc32_be(crc, pos - 2, elen + 2);
 
-				if (pos[3] == 1) {
-					/* OUI Type 1 - WPA IE */
-					elems->wpa = pos;
-					elems->wpa_len = elen;
-				} else if (elen >= 5 && pos[3] == 2) {
+				if (elen >= 5 && pos[3] == 2) {
 					/* OUI Type 2 - WMM IE */
 					if (pos[4] == 0) {
 						elems->wmm_info = pos;
-- 
1.8.0

