Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbZLWMWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:22:38 -0500
Message-Id: <20091223121616.118668680@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 07/18] mac80211: rewrite a few work messages
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The station we're authenticating/associating with
may not always be an AP in the sense that word is
mostly understood, so print only the MAC address
of the peer instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/work.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/work.c	2009-12-23 13:11:21.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2009-12-23 13:11:22.000000000 +0100
@@ -376,7 +376,7 @@ ieee80211_direct_probe(struct ieee80211_
 
 	wk->probe_auth.tries++;
 	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
-		printk(KERN_DEBUG "%s: direct probe to AP %pM timed out\n",
+		printk(KERN_DEBUG "%s: direct probe to %pM timed out\n",
 		       sdata->name, wk->filter_ta);
 
 		/*
@@ -394,7 +394,7 @@ ieee80211_direct_probe(struct ieee80211_
 		return WORK_ACT_TIMEOUT;
 	}
 
-	printk(KERN_DEBUG "%s: direct probe to AP %pM (try %d)\n",
+	printk(KERN_DEBUG "%s: direct probe to %pM (try %d)\n",
 			sdata->name, wk->filter_ta, wk->probe_auth.tries);
 
 	/*
@@ -419,7 +419,7 @@ ieee80211_authenticate(struct ieee80211_
 
 	wk->probe_auth.tries++;
 	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
-		printk(KERN_DEBUG "%s: authentication with AP %pM"
+		printk(KERN_DEBUG "%s: authentication with %pM"
 		       " timed out\n", sdata->name, wk->filter_ta);
 
 		/*
@@ -437,7 +437,7 @@ ieee80211_authenticate(struct ieee80211_
 		return WORK_ACT_TIMEOUT;
 	}
 
-	printk(KERN_DEBUG "%s: authenticate with AP %pM (try %d)\n",
+	printk(KERN_DEBUG "%s: authenticate with %pM (try %d)\n",
 	       sdata->name, wk->filter_ta, wk->probe_auth.tries);
 
 	ieee80211_send_auth(sdata, 1, wk->probe_auth.algorithm, wk->ie,
@@ -458,7 +458,7 @@ ieee80211_associate(struct ieee80211_wor
 
 	wk->assoc.tries++;
 	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
-		printk(KERN_DEBUG "%s: association with AP %pM"
+		printk(KERN_DEBUG "%s: association with %pM"
 		       " timed out\n",
 		       sdata->name, wk->filter_ta);
 
@@ -479,7 +479,7 @@ ieee80211_associate(struct ieee80211_wor
 		return WORK_ACT_TIMEOUT;
 	}
 
-	printk(KERN_DEBUG "%s: associate with AP %pM (try %d)\n",
+	printk(KERN_DEBUG "%s: associate with %pM (try %d)\n",
 	       sdata->name, wk->filter_ta, wk->assoc.tries);
 	ieee80211_send_assoc(sdata, wk);
 
@@ -592,9 +592,9 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 		u32 tu, ms;
 		tu = get_unaligned_le32(elems.timeout_int + 1);
 		ms = tu * 1024 / 1000;
-		printk(KERN_DEBUG "%s: AP rejected association temporarily; "
+		printk(KERN_DEBUG "%s: %pM rejected association temporarily; "
 		       "comeback duration %u TU (%u ms)\n",
-		       sdata->name, tu, ms);
+		       sdata->name, mgmt->sa, tu, ms);
 		wk->timeout = jiffies + msecs_to_jiffies(ms);
 		if (ms > IEEE80211_ASSOC_TIMEOUT)
 			run_again(local, wk->timeout);
@@ -602,8 +602,8 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	}
 
 	if (status_code != WLAN_STATUS_SUCCESS)
-		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
-		       sdata->name, status_code);
+		printk(KERN_DEBUG "%s: %pM denied association (code=%d)\n",
+		       sdata->name, mgmt->sa, status_code);
 	else
 		printk(KERN_DEBUG "%s: associated\n", sdata->name);
 


