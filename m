Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:51220 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759525AbZJMLqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 07:46:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: remove warning in deauth case
Date: Tue, 13 Oct 2009 13:45:28 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910131345.28395.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It might be the case that __cfg80211_disconnected() has already
cleaned up wdev->current_bss() for us. The old code didn't catch
that situation and didn't warn needlessly.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

For more info, see mail "cfg80211 / libertas: an unusual race"
in the linux-wireless mailing list.


--- linux-wl.orig/net/wireless/mlme.c
+++ linux-wl/net/wireless/mlme.c
@@ -130,7 +130,6 @@
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	const u8 *bssid = mgmt->bssid;
 	int i;
-	bool done = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -138,7 +137,6 @@
 
 	if (wdev->current_bss &&
 	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
-		done = true;
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(&wdev->current_bss->pub);
 		wdev->current_bss = NULL;
@@ -148,7 +146,6 @@
 			cfg80211_unhold_bss(wdev->auth_bsses[i]);
 			cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
 			wdev->auth_bsses[i] = NULL;
-			done = true;
 			break;
 		}
 		if (wdev->authtry_bsses[i] &&
@@ -156,13 +153,10 @@
 			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
 			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
 			wdev->authtry_bsses[i] = NULL;
-			done = true;
 			break;
 		}
 	}
 
-	WARN_ON(!done);
-
 	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
 		u16 reason_code;
 		bool from_ap;

-- 
http://www.holgerschurig.de
