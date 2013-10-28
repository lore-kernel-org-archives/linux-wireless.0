Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3J1OIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:08:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: remove useless tests for array
Date: Mon, 28 Oct 2013 15:08:24 +0100
Message-Id: <1382969304-25611-4-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150838_935469_7591CEB4)
In-Reply-To: <1382969304-25611-1-git-send-email-johannes@sipsolutions.net>
References: <1382969304-25611-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Coverity points out that checking assoc_data->ie is
completely useless since it's an array in the struct
and can't be NULL - remove the useless checks.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1305ff9..5b2b0a1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -714,7 +714,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	}
 
 	/* if present, add any custom IEs that go before HT */
-	if (assoc_data->ie_len && assoc_data->ie) {
+	if (assoc_data->ie_len) {
 		static const u8 before_ht[] = {
 			WLAN_EID_SSID,
 			WLAN_EID_SUPP_RATES,
@@ -748,7 +748,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 				     &assoc_data->ap_vht_cap);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
-	if (assoc_data->ie_len && assoc_data->ie) {
+	if (assoc_data->ie_len) {
 		noffset = ieee80211_ie_split_vendor(assoc_data->ie,
 						    assoc_data->ie_len,
 						    offset);
@@ -779,7 +779,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	}
 
 	/* add any remaining custom (i.e. vendor specific here) IEs */
-	if (assoc_data->ie_len && assoc_data->ie) {
+	if (assoc_data->ie_len) {
 		noffset = assoc_data->ie_len;
 		pos = skb_put(skb, noffset - offset);
 		memcpy(pos, assoc_data->ie + offset, noffset - offset);
-- 
1.8.4.rc3

