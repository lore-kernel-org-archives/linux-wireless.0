Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbZF3LyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 07:54:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MLbui-0003SJ-CX
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2009 13:54:16 +0200
Message-Id: <20090630115303.111250594@sipsolutions.net>
References: <20090630115245.675553951@sipsolutions.net>
Date: Tue, 30 Jun 2009 13:52:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 8/8 v3] mac80211: re-add HT disabling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IEEE80211_STA_TKIP_WEP_USED flag is used internally to
disable HT when WEP or TKIP are used. Now that cfg80211 is
giving us the required information, we can set the flag
appropriately again.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/cfg.c	2009-06-30 13:25:43.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-06-30 13:25:45.000000000 +0200
@@ -1228,7 +1228,7 @@ static int ieee80211_assoc(struct wiphy 
 			   struct cfg80211_assoc_request *req)
 {
 	struct ieee80211_sub_if_data *sdata;
-	int ret;
+	int ret, i;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -1236,6 +1236,19 @@ static int ieee80211_assoc(struct wiphy 
 	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
 		return -ENOLINK; /* not authenticated */
 
+	sdata->u.mgd.flags &= ~IEEE80211_STA_TKIP_WEP_USED;
+
+	if (req->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40 ||
+	    req->crypto.cipher_group == WLAN_CIPHER_SUITE_TKIP ||
+	    req->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104)
+		sdata->u.mgd.flags |= IEEE80211_STA_TKIP_WEP_USED;
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

