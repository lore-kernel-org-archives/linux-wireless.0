Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbZGATg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:36:28 -0400
Message-Id: <20090701193421.957624423@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:27:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 20/20 v4] mac80211: re-add HT disabling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IEEE80211_STA_TKIP_WEP_USED flag is used internally to
disable HT when WEP or TKIP are used. Now that cfg80211 is
giving us the required information, we can set the flag
appropriately again.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-01 20:29:45.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-01 20:29:47.000000000 +0200
@@ -1228,7 +1228,7 @@ static int ieee80211_assoc(struct wiphy 
 			   struct cfg80211_assoc_request *req)
 {
 	struct ieee80211_sub_if_data *sdata;
-	int ret;
+	int ret, i;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -1236,6 +1236,14 @@ static int ieee80211_assoc(struct wiphy 
 	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
 		return -ENOLINK; /* not authenticated */
 
+	sdata->u.mgd.flags &= ~IEEE80211_STA_TKIP_WEP_USED;
+
+	for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
+		if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||
+		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_TKIP ||
+		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104)
+			sdata->u.mgd.flags |= IEEE80211_STA_TKIP_WEP_USED;
+
 	sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
 	sdata->u.mgd.flags |= IEEE80211_STA_BSSID_SET;
 

-- 

