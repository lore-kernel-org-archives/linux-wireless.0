Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43552 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882Ab0FNS4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:56:12 -0400
Date: Mon, 14 Jun 2010 11:55:56 -0700
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] mac80211: Protect Deauthentication frame when using MFP
Message-ID: <20100614185556.GA5955@jm.kir.nu>
References: <20100611024456.GA3985@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100611024456.GA3985@jm.kir.nu>
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
 net/mac80211/mlme.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

v2: Fix a bug that left STA entries behind and broke some reassociation
    cases.

--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-14 11:40:07.000000000 -0700
+++ wireless-testing/net/mac80211/mlme.c	2010-06-14 11:41:03.000000000 -0700
@@ -2292,14 +2292,16 @@ int ieee80211_mgd_deauth(struct ieee8021
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_work *wk;
-	const u8 *bssid = req->bss->bssid;
+	u8 bssid[ETH_ALEN];
+	bool assoc_bss = false;
 
 	mutex_lock(&ifmgd->mtx);
 
+	memcpy(bssid, req->bss->bssid, ETH_ALEN);
 	if (ifmgd->associated == req->bss) {
-		bssid = req->bss->bssid;
-		ieee80211_set_disassoc(sdata, true);
+		ieee80211_set_disassoc(sdata, false);
 		mutex_unlock(&ifmgd->mtx);
+		assoc_bss = true;
 	} else {
 		bool not_auth_yet = false;
 
@@ -2345,6 +2347,8 @@ int ieee80211_mgd_deauth(struct ieee8021
 	ieee80211_send_deauth_disassoc(sdata, bssid, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, cookie,
 				       !req->local_state_change);
+	if (assoc_bss)
+		sta_info_destroy_addr(sdata, bssid);
 
 	ieee80211_recalc_idle(sdata->local);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
