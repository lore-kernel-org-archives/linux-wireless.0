Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab2CHODO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 09:03:14 -0500
Message-Id: <20120308140226.717127600@sipsolutions.net> (sfid-20120308_150319_339672_69A5DCE3)
Date: Thu, 08 Mar 2012 15:02:03 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] mac80211: move misplaced comment
References: <20120308140202.751490800@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Looks like some changes in this area moved
the code but not the comment that belongs
to the code, move it to the right place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/mac80211/mlme.c	2012-03-08 12:35:20.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-08 13:19:50.000000000 +0100
@@ -3316,6 +3316,13 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	ifmgd->beacon_crc_valid = false;
 
+	/*
+	 * IEEE802.11n does not allow TKIP/WEP as pairwise ciphers in HT mode.
+	 * We still associate in non-HT mode (11a/b/g) if any one of these
+	 * ciphers is configured as pairwise.
+	 * We can set this to true for non-11n hardware, that'll be checked
+	 * separately along with the peer capabilities.
+	 */
 	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
 		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
@@ -3344,13 +3351,6 @@ int ieee80211_mgd_assoc(struct ieee80211
 	} else
 		ifmgd->ap_smps = ifmgd->req_smps;
 
-	/*
-	 * IEEE802.11n does not allow TKIP/WEP as pairwise ciphers in HT mode.
-	 * We still associate in non-HT mode (11a/b/g) if any one of these
-	 * ciphers is configured as pairwise.
-	 * We can set this to true for non-11n hardware, that'll be checked
-	 * separately along with the peer capabilities.
-	 */
 	assoc_data->capability = req->bss->capability;
 	assoc_data->wmm_used = bss->wmm_used;
 	assoc_data->supp_rates = bss->supp_rates;


