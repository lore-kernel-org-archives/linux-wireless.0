Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40666 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031745Ab0B1KN4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 05:13:56 -0500
Date: Sun, 28 Feb 2010 12:13:46 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix reassociation processing (within ESS roaming)
Message-ID: <20100228101346.GA8962@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit e1dd33f60ced091114e4aacf141e0d03b88d3e13 changed cfg80211 to
allow association commands while in associated state to enable support
for roaming within an ESS. However, this was not enough to resolve all
cases with mac80211 which needs some additional handling of the
reassociation case to clear internal state with the BSS that was in use
previously.

This patch makes ieee80211_mgd_assoc() accept a valid reassociation
command and clean the association state with the previous BSS. This
fixes roaming between BSSes in an ESS when using wpa_supplicant with
-Dnl80211.

Signed-off-by: Jouni Malinen <j@w1.fi>
Cc: stable@kernel.org

---
 net/mac80211/mlme.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- uml.orig/net/mac80211/mlme.c	2010-02-28 11:22:00.000000000 +0200
+++ uml/net/mac80211/mlme.c	2010-02-28 11:51:28.000000000 +0200
@@ -1893,8 +1893,20 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	mutex_lock(&ifmgd->mtx);
 	if (ifmgd->associated) {
-		mutex_unlock(&ifmgd->mtx);
-		return -EALREADY;
+		if (!req->prev_bssid ||
+		    memcmp(req->prev_bssid, ifmgd->associated->bssid,
+			   ETH_ALEN)) {
+			/*
+			 * We are already associated and the request was not a
+			 * reassociation request from the current BSS, so
+			 * reject it.
+			 */
+			mutex_unlock(&ifmgd->mtx);
+			return -EALREADY;
+		}
+
+		/* Trying to reassociate - clear previous association state */
+		ieee80211_set_disassoc(sdata);
 	}
 	mutex_unlock(&ifmgd->mtx);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
