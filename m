Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZGAHjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 03:39:17 -0400
Subject: [PATCH 8/8 v3.1] mac80211: re-add HT disabling
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1246370452.16643.11.camel@johannes.local>
References: <20090630115245.675553951@sipsolutions.net>
	 <20090630115303.111250594@sipsolutions.net>
	 <20090630132547.GB24667@vasanth-laptop>
	 <1246369077.16643.10.camel@johannes.local>
	 <20090630135207.GC24667@vasanth-laptop>
	 <1246370452.16643.11.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 09:39:16 +0200
Message-Id: <1246433956.16643.35.camel@johannes.local>
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

--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-01 09:01:25.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-01 09:09:01.000000000 +0200
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
 


