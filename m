Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56768 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760661AbZEHJgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 05:36:08 -0400
Date: Fri, 8 May 2009 12:36:03 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: MFP - Drop unprotected Action frames prior key
	setup
Message-ID: <20090508093603.GB21362@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When management frame protection (IEEE 802.11w) is used, unprotected
Robust Action frames are not allowed prior to key configuration.
However, unprotected Deauthentication and Disassociation frames are
allowed at that point, but not after key configuration.

Make ieee80211_drop_unencrypted() handle the special cases for MFP by
separating the basic Data frame case from Management frame processing
and handle the Management frames only if MFP has been negotiated. In
addition, do not use sdata->drop_unencrypted for Management frames
since the decision on whether to accept the frame depends on the key
being configured.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/rx.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- uml.orig/net/mac80211/rx.c	2009-05-08 11:55:20.000000000 +0300
+++ uml/net/mac80211/rx.c	2009-05-08 12:30:46.000000000 +0300
@@ -1221,17 +1221,27 @@ ieee80211_drop_unencrypted(struct ieee80
 	/* Drop unencrypted frames if key is set. */
 	if (unlikely(!ieee80211_has_protected(fc) &&
 		     !ieee80211_is_nullfunc(fc) &&
-		     (!ieee80211_is_mgmt(fc) ||
-		      (ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
-		       rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP))) &&
-		     (rx->key || rx->sdata->drop_unencrypted)))
-		return -EACCES;
-	/* BIP does not use Protected field, so need to check MMIE */
-	if (unlikely(rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP) &&
-		     ieee80211_is_multicast_robust_mgmt_frame(rx->skb) &&
-		     ieee80211_get_mmie_keyidx(rx->skb) < 0 &&
+		     ieee80211_is_data(fc) &&
 		     (rx->key || rx->sdata->drop_unencrypted)))
 		return -EACCES;
+	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
+		if (unlikely(ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
+			     rx->key))
+			return -EACCES;
+		/* BIP does not use Protected field, so need to check MMIE */
+		if (unlikely(ieee80211_is_multicast_robust_mgmt_frame(rx->skb)
+			     && ieee80211_get_mmie_keyidx(rx->skb) < 0 &&
+			     rx->key))
+			return -EACCES;
+		/*
+		 * When using MFP, Action frames are not allowed prior to
+		 * having configured keys.
+		 */
+		if (unlikely(ieee80211_is_action(fc) && !rx->key &&
+			     ieee80211_is_robust_mgmt_frame(
+				     (struct ieee80211_hdr *) rx->skb->data)))
+			return -EACCES;
+	}
 
 	return 0;
 }

-- 
Jouni Malinen                                            PGP id EFC895FA
