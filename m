Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbYDPVCH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 17:02:07 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH] mac80211: Fix n-band association problem
Date: Wed, 16 Apr 2008 14:02:04 -0700
Message-Id: <1208379724-13568-1-git-send-email-reinette.chatre@intel.com> (sfid-20080416_220312_598962_80DA4049)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

There are two structures named wmm_info and wmm_param, they are used while
parsing the beacon frame. (Check the function ieee802_11_parse_elems).
Certain APs like D-link does not set the fifth bit in WMM IE.
While sending the association request to n-only ap it checks for wmm_ie.
If it is set then only ieee80211_ht_cap is sent during association request.
So n-only association fails.
And this patch fixes this problem by copying the wmm_info to wmm_ie,
which enables the "wmm" flag in iee80211_send_assoc.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---

This problem is also present in 2.6.25. This patch does apply to
2.6.25-rc9 after changing the filename to be patched to ieee80211_sta.c

 net/mac80211/mlme.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e3f2cb0..4e4b704 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2668,7 +2668,26 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 			bss->wmm_ie_len = elems.wmm_param_len + 2;
 		} else
 			bss->wmm_ie_len = 0;
-	} else if (!elems.wmm_param && bss->wmm_ie) {
+	} else if (elems.wmm_info &&
+		    (!bss->wmm_ie || bss->wmm_ie_len != elems.wmm_info_len ||
+		     memcmp(bss->wmm_ie, elems.wmm_info, elems.wmm_info_len))) {
+		 /* As for certain AP's Fifth bit is not set in WMM IE in
+		  * beacon frames.So while parsing the beacon frame the
+		  * wmm_info structure is used instead of wmm_param.
+		  * wmm_info structure was never used to set bss->wmm_ie.
+		  * This code fixes this problem by copying the WME
+		  * information from wmm_info to bss->wmm_ie and enabling
+		  * n-band association.
+		  */
+		kfree(bss->wmm_ie);
+		bss->wmm_ie = kmalloc(elems.wmm_info_len + 2, GFP_ATOMIC);
+		if (bss->wmm_ie) {
+			memcpy(bss->wmm_ie, elems.wmm_info - 2,
+			       elems.wmm_info_len + 2);
+			bss->wmm_ie_len = elems.wmm_info_len + 2;
+		} else
+			bss->wmm_ie_len = 0;
+	} else if (!elems.wmm_param && !elems.wmm_info && bss->wmm_ie) {
 		kfree(bss->wmm_ie);
 		bss->wmm_ie = NULL;
 		bss->wmm_ie_len = 0;
-- 
1.5.3.4

