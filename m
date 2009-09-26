Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZIZMpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 08:45:41 -0400
Subject: [PATCH] mac80211: improve/fix mlme messages
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Sep 2009 14:45:41 +0200
Message-Id: <1253969141.5122.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's useful to know the MAC address when being
disassociated; fix a typo (missing colon) and
move some messages so we get them only when they
are actually taking effect.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Might help in .32 but I'll let you make that call.

 net/mac80211/mlme.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-09-26 14:35:33.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-09-26 14:37:16.000000000 +0200
@@ -1388,8 +1388,8 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-	printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",
-			sdata->dev->name, reason_code);
+	printk(KERN_DEBUG "%s: disassociated from %pM (Reason: %u)\n",
+			sdata->dev->name, mgmt->sa, reason_code);
 
 	ieee80211_set_disassoc(sdata, false);
 	return RX_MGMT_CFG80211_DISASSOC;
@@ -1675,7 +1675,7 @@ static void ieee80211_rx_mgmt_probe_resp
 
 	/* direct probe may be part of the association flow */
 	if (wk && wk->state == IEEE80211_MGD_STATE_PROBE) {
-		printk(KERN_DEBUG "%s direct probe responded\n",
+		printk(KERN_DEBUG "%s: direct probe responded\n",
 		       sdata->dev->name);
 		wk->tries = 0;
 		wk->state = IEEE80211_MGD_STATE_AUTH;
@@ -2502,9 +2502,6 @@ int ieee80211_mgd_deauth(struct ieee8021
 	struct ieee80211_mgd_work *wk;
 	const u8 *bssid = NULL;
 
-	printk(KERN_DEBUG "%s: deauthenticating by local choice (reason=%d)\n",
-	       sdata->dev->name, req->reason_code);
-
 	mutex_lock(&ifmgd->mtx);
 
 	if (ifmgd->associated && &ifmgd->associated->cbss == req->bss) {
@@ -2532,6 +2529,9 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 	mutex_unlock(&ifmgd->mtx);
 
+	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
+	       sdata->dev->name, bssid, req->reason_code);
+
 	ieee80211_send_deauth_disassoc(sdata, bssid,
 			IEEE80211_STYPE_DEAUTH, req->reason_code,
 			cookie);
@@ -2545,9 +2545,6 @@ int ieee80211_mgd_disassoc(struct ieee80
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	printk(KERN_DEBUG "%s: disassociating by local choice (reason=%d)\n",
-	       sdata->dev->name, req->reason_code);
-
 	mutex_lock(&ifmgd->mtx);
 
 	/*
@@ -2561,6 +2558,9 @@ int ieee80211_mgd_disassoc(struct ieee80
 		return -ENOLINK;
 	}
 
+	printk(KERN_DEBUG "%s: disassociating from %pM by local choice (reason=%d)\n",
+	       sdata->dev->name, req->bss->bssid, req->reason_code);
+
 	ieee80211_set_disassoc(sdata, false);
 
 	mutex_unlock(&ifmgd->mtx);


