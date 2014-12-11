Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4532 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134AbaLKVtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2014 16:49:00 -0500
Date: Thu, 11 Dec 2014 23:48:55 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Fix 160 MHz channels with 80+80 and 160 MHz drivers
Message-ID: <20141211214855.GA9826@jouni.qca.qualcomm.com> (sfid-20141211_224905_575145_94256A75)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The VHT supported channel width field is a two bit integer, not a
bitfield. cfg80211_chandef_usable() was interpreting it incorrectly and
ended up rejecting 160 MHz channel width if the driver indicated support
for both 160 and 80+80 MHz channels.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/chan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 85506f1d..7aaf741 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -603,7 +603,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 {
 	struct ieee80211_sta_ht_cap *ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap;
-	u32 width, control_freq;
+	u32 width, control_freq, cap;
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return false;
@@ -643,7 +643,8 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			return false;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
-		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ))
+		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
 	case NL80211_CHAN_WIDTH_80:
 		if (!vht_cap->vht_supported)
@@ -654,7 +655,9 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	case NL80211_CHAN_WIDTH_160:
 		if (!vht_cap->vht_supported)
 			return false;
-		if (!(vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ))
+		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
+		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ &&
+		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
 			return false;
 		prohibited_flags |= IEEE80211_CHAN_NO_160MHZ;
 		width = 160;
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
