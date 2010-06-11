Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:45055 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab0FKDMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 23:12:24 -0400
Date: Thu, 10 Jun 2010 19:44:56 -0700
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Protect Deauthentication frame when using MFP
Message-ID: <20100611024456.GA3985@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When management frame protection (IEEE 802.11w) is used,
Deauthentication frame needs to be protected when the pairwise key is
configured. mac80211 was removing the station entry (and its keys)
before actually sending out the Deauthentication frame. Fix this by
reordering the code to send the frame before the station entry gets
removed. This matches an earlier change that handled the Disassociation
frame processing, but missed Deauthentication frames.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-10 18:09:38.000000000 -0700
+++ wireless-testing/net/mac80211/mlme.c	2010-06-10 18:35:20.000000000 -0700
@@ -2292,13 +2292,13 @@ int ieee80211_mgd_deauth(struct ieee8021
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_work *wk;
-	const u8 *bssid = req->bss->bssid;
+	u8 bssid[ETH_ALEN];
 
 	mutex_lock(&ifmgd->mtx);
 
+	memcpy(bssid, req->bss->bssid, ETH_ALEN);
 	if (ifmgd->associated == req->bss) {
-		bssid = req->bss->bssid;
-		ieee80211_set_disassoc(sdata, true);
+		ieee80211_set_disassoc(sdata, false);
 		mutex_unlock(&ifmgd->mtx);
 	} else {
 		bool not_auth_yet = false;
@@ -2345,6 +2345,8 @@ int ieee80211_mgd_deauth(struct ieee8021
 	ieee80211_send_deauth_disassoc(sdata, bssid, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, cookie,
 				       !req->local_state_change);
+	if (ifmgd->associated == req->bss)
+		sta_info_destroy_addr(sdata, bssid);
 
 	ieee80211_recalc_idle(sdata->local);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
