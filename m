Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58558 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752161AbZKQTfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 14:35:42 -0500
Date: Tue, 17 Nov 2009 21:35:38 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: Allow reassociation in associated state
Message-ID: <20091117193538.GA18225@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 rejects all association requests when in associated state. This
prevents clean roaming within an ESS since one would first need to
disassociate before being able to request reassociation.

Accept the reassociation request and let the old association to be
dropped when the new one is completed. This fixes nl80211-based
roaming with the current snapshot version of wpa_supplicant (that has
code for requesting reassociation explicitly withthe previous BSSID
attribute).

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/wireless/mlme.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- uml.orig/net/wireless/mlme.c	2009-11-17 19:40:28.000000000 +0200
+++ uml/net/wireless/mlme.c	2009-11-17 21:18:24.000000000 +0200
@@ -446,12 +446,23 @@ int __cfg80211_mlme_assoc(struct cfg8021
 	struct cfg80211_assoc_request req;
 	struct cfg80211_internal_bss *bss;
 	int i, err, slot = -1;
+	bool was_connected = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
 	memset(&req, 0, sizeof(req));
 
-	if (wdev->current_bss)
+	if (wdev->current_bss && prev_bssid &&
+	    memcmp(wdev->current_bss->pub.bssid, prev_bssid, ETH_ALEN) == 0) {
+		/*
+		 * Trying to reassociate: Allow this to proceed and let the old
+		 * association to be dropped when the new one is completed.
+		 */
+		if (wdev->sme_state == CFG80211_SME_CONNECTED) {
+			was_connected = true;
+			wdev->sme_state = CFG80211_SME_CONNECTING;
+		}
+	} else if (wdev->current_bss)
 		return -EALREADY;
 
 	req.ie = ie;
@@ -461,8 +472,11 @@ int __cfg80211_mlme_assoc(struct cfg8021
 	req.prev_bssid = prev_bssid;
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
 				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
-	if (!req.bss)
+	if (!req.bss) {
+		if (was_connected)
+			wdev->sme_state = CFG80211_SME_CONNECTED;
 		return -ENOENT;
+	}
 
 	bss = bss_from_pub(req.bss);
 
@@ -480,6 +494,8 @@ int __cfg80211_mlme_assoc(struct cfg8021
 
 	err = rdev->ops->assoc(&rdev->wiphy, dev, &req);
  out:
+	if (err && was_connected)
+		wdev->sme_state = CFG80211_SME_CONNECTED;
 	/* still a reference in wdev->auth_bsses[slot] */
 	cfg80211_put_bss(req.bss);
 	return err;


-- 
Jouni Malinen                                            PGP id EFC895FA
