Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZIYGWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 02:22:49 -0400
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Sep 2009 08:22:39 +0200
Message-Id: <1253859759.3868.569.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your analysis.

> This seems to look like/relate to a little problem I have for the last
> few days - lately I have authentication failure on first try and have
> to click on NM a 2nd time for it to go through; blow away
> compat-wireless & revert to as-shipped distro modules gives me the
> older/smooth behavior  of NM just associating without me
> clicking/asking.
> 
> v2.6.31-38294-ged3ac87 + 'cfg80211: don't set privacy w/o key' doesn't
> improve my situation.
> 
> wpa_supplicant log:
> --------- distro modules:
> Trying to associate with <id> (SSID='ID' freq=2437 MHz)
> Associated with <id>
> CTRL-EVENT-CONNECTED - Connection to <id> completed (auth) [id=0 id_str=]
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> 
> -------- compat-wireless
> Trying to associate with <id> (SSID='ID' freq=2437 MHz)
> Authentication with 00:00:00:00:00:00 timed out.
> Trying to associate with <id> (SSID='ID' freq=2437 MHz)
> Associated with <id>
> CTRL-EVENT-CONNECTED - Connection to <id> completed (auth) [id=0 id_str=]
> 
> ------ dmesg distro modules
> wlan2: direct probe to AP <id> try 1
> wlan2 direct probe responded
> wlan2: authenticate with AP <id>
> wlan2: authenticated
> wlan2: associate with AP <id>
> wlan2: RX AssocResp from <id> (capab=0x431 status=0 aid=1)
> wlan2: associated
> 
> ------ compat-wireless, note the extra deauth at the beginning, and
> all those 'try 1''s.
> wlan2: deauthenticating by local choice (reason=3)
> wlan2: direct probe to AP <id> (try 1)
> wlan2 direct probe responded
> wlan2: authenticate with AP <id> (try 1)
> wlan2: authenticated
> wlan2: associate with AP <id> (try 1)
> wlan2: RX AssocResp from <id> (capab=0x431 status=0 aid=1)
> wlan2: associated

I've analysed this, and now know the reason for the extra deauth, but it
shouldn't hurt since we never send a wireless extensions event. The
reason is that once wpa_supplicant sets the SSID we already start to
connect with the new changes, but then setting the BSSID might require
restarting the process. This could be optimised, but I would prefer not
having to.

I can see a problem with the code and it trying to scan once more again
etc. Below patch seems to help for me. However, I only once managed to
reproduce the problem you were seeing with the authentication timeout in
wpa_supplicant.

Can you try this? The last hunk is most important, but the other stuff
helps debugging.

johannes

--- wireless-testing.orig/net/mac80211/mlme.c	2009-09-25 07:38:46.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-09-25 08:12:26.000000000 +0200
@@ -1675,7 +1675,7 @@ static void ieee80211_rx_mgmt_probe_resp
 
 	/* direct probe may be part of the association flow */
 	if (wk && wk->state == IEEE80211_MGD_STATE_PROBE) {
-		printk(KERN_DEBUG "%s direct probe responded\n",
+		printk(KERN_DEBUG "%s: direct probe responded\n",
 		       sdata->dev->name);
 		wk->tries = 0;
 		wk->state = IEEE80211_MGD_STATE_AUTH;
@@ -2411,6 +2411,9 @@ int ieee80211_mgd_auth(struct ieee80211_
 	list_add(&wk->list, &sdata->u.mgd.work_list);
 	mutex_unlock(&ifmgd->mtx);
 
+	printk(KERN_DEBUG "%s: starting authentication with %pM\n",
+	       sdata->dev->name, req->bss->bssid);
+
 	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 	return 0;
 }
@@ -2485,6 +2488,9 @@ int ieee80211_mgd_assoc(struct ieee80211
 	else
 		ifmgd->flags &= ~IEEE80211_STA_CONTROL_PORT;
 
+	printk(KERN_DEBUG "%s: starting association with %pM\n",
+	       sdata->dev->name, req->bss->bssid);
+
 	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 
 	err = 0;
@@ -2502,9 +2508,6 @@ int ieee80211_mgd_deauth(struct ieee8021
 	struct ieee80211_mgd_work *wk;
 	const u8 *bssid = NULL;
 
-	printk(KERN_DEBUG "%s: deauthenticating by local choice (reason=%d)\n",
-	       sdata->dev->name, req->reason_code);
-
 	mutex_lock(&ifmgd->mtx);
 
 	if (ifmgd->associated && &ifmgd->associated->cbss == req->bss) {
@@ -2532,6 +2535,9 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 	mutex_unlock(&ifmgd->mtx);
 
+	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
+	       sdata->dev->name, bssid, req->reason_code);
+
 	ieee80211_send_deauth_disassoc(sdata, bssid,
 			IEEE80211_STYPE_DEAUTH, req->reason_code,
 			cookie);
@@ -2545,9 +2551,6 @@ int ieee80211_mgd_disassoc(struct ieee80
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	printk(KERN_DEBUG "%s: disassociating by local choice (reason=%d)\n",
-	       sdata->dev->name, req->reason_code);
-
 	mutex_lock(&ifmgd->mtx);
 
 	/*
@@ -2561,6 +2564,9 @@ int ieee80211_mgd_disassoc(struct ieee80
 		return -ENOLINK;
 	}
 
+	printk(KERN_DEBUG "%s: disassociating from %pM by local choice (reason=%d)\n",
+	       sdata->dev->name, req->bss->bssid, req->reason_code);
+
 	ieee80211_set_disassoc(sdata, false);
 
 	mutex_unlock(&ifmgd->mtx);
--- wireless-testing.orig/net/wireless/sme.c	2009-09-25 08:05:20.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-09-25 08:13:42.000000000 +0200
@@ -762,9 +762,8 @@ int __cfg80211_connect(struct cfg80211_r
 		wdev->conn->params.ssid = wdev->ssid;
 		wdev->conn->params.ssid_len = connect->ssid_len;
 
-		/* don't care about result -- but fill bssid & channel */
-		if (!wdev->conn->params.bssid || !wdev->conn->params.channel)
-			bss = cfg80211_get_conn_bss(wdev);
+		/* see if we have the bss already */
+		bss = cfg80211_get_conn_bss(wdev);
 
 		wdev->sme_state = CFG80211_SME_CONNECTING;
 		wdev->connect_keys = connkeys;


