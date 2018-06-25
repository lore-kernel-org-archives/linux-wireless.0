Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:51893 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752284AbeFYBLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 21:11:48 -0400
Received: by mail-it0-f67.google.com with SMTP id 128-v6so3973300itf.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2018 18:11:48 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <me@bobcopeland.com>,
        Masashi Honma <masashi.honma@gmail.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH] nl80211: relax ht operation checks for mesh
Date: Sun, 24 Jun 2018 21:10:49 -0400
Message-Id: <20180625011049.23768-1-me@bobcopeland.com> (sfid-20180625_031153_724825_D52C8A6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 9757235f451c, "nl80211: correct checks for
NL80211_MESHCONF_HT_OPMODE value") relaxed the range for the HT
operation field in meshconf, while also adding checks requiring
the non-greenfield and non-ht-sta bits to be set in certain
circumstances.  The latter bit is actually reserved for mesh BSSes
according to Table 9-168 in 802.11-2016, so in fact it should not
be set.

wpa_supplicant sets these bits because the mesh and AP code share
the same implementation, but authsae does not.  As a result, some
meshconf updates from authsae which set only the NONHT_MIXED
protection bits were being rejected.

In order to avoid breaking userspace by changing the rules again,
simply accept the values with or without the bits set, and mask
off the reserved bit to match the spec.

While in here, update the 802.11-2012 reference to 802.11-2016.

Fixes: 9757235f451c ("nl80211: correct checks for NL80211_MESHCONF_HT_OPMODE value")
Cc: Masashi Honma <masashi.honma@gmail.com>
Signed-off-by: Bob Copeland <bobcopeland@fb.com>
---
 net/wireless/nl80211.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f5e36a23cae3..c9ba4edf25cc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5837,7 +5837,7 @@ do {									    \
 				  nl80211_check_s32);
 	/*
 	 * Check HT operation mode based on
-	 * IEEE 802.11 2012 8.4.2.59 HT Operation element.
+	 * IEEE 802.11-2016 9.4.2.57 HT Operation element.
 	 */
 	if (tb[NL80211_MESHCONF_HT_OPMODE]) {
 		ht_opmode = nla_get_u16(tb[NL80211_MESHCONF_HT_OPMODE]);
@@ -5847,22 +5847,9 @@ do {									    \
 				  IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
 			return -EINVAL;
 
-		if ((ht_opmode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT) &&
-		    (ht_opmode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
-			return -EINVAL;
+		/* NON_HT_STA bit is reserved, but some programs set it */
+		ht_opmode &= ~IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT;
 
-		switch (ht_opmode & IEEE80211_HT_OP_MODE_PROTECTION) {
-		case IEEE80211_HT_OP_MODE_PROTECTION_NONE:
-		case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
-			if (ht_opmode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT)
-				return -EINVAL;
-			break;
-		case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
-		case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
-			if (!(ht_opmode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT))
-				return -EINVAL;
-			break;
-		}
 		cfg->ht_opmode = ht_opmode;
 		mask |= (1 << (NL80211_MESHCONF_HT_OPMODE - 1));
 	}
-- 
2.9.5
