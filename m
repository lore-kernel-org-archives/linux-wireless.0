Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:47546 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbXFBSwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2007 14:52:16 -0400
Date: Sat, 02 Jun 2007 13:51:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Add module parameter for setting initial rate  in rc80211_simple
Message-ID: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The initial rate for STA's using rc80211_simple is set to the last
rate in the rate table. This is too fast for the bcm43xx-mac80211
driver. To correct this situation without affecting any other driver,
an initial_rate parameter is added to the rc80211_simple module. This
parameter is set to 10 times the desired initial rate. If the parameter
is zero or not set, the original behavior is kept. If the parameter
does not match a valid rate, the first rate in the table will be set.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/net/mac80211/rc80211_simple.c
===================================================================
--- wireless-dev.orig/net/mac80211/rc80211_simple.c
+++ wireless-dev/net/mac80211/rc80211_simple.c
@@ -31,6 +31,10 @@
 
 MODULE_ALIAS("rc80211_default");
 
+static int modparam_initial_rate;
+module_param_named(initial_rate, modparam_initial_rate, int, 0444);
+MODULE_PARM_DESC(initial_rate, "set initial rate in Mbs*10");
+
 static void rate_control_rate_inc(struct ieee80211_local *local,
 				  struct sta_info *sta)
 {
@@ -283,14 +287,18 @@ static void rate_control_simple_rate_ini
 	int i;
 	sta->txrate = 0;
 	mode = local->oper_hw_mode;
-	/* TODO: what is a good starting rate for STA? About middle? Maybe not
-	 * the lowest or the highest rate.. Could consider using RSSI from
-	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
-	 * after assoc.. */
+	/* The starting rate for STA is set to the last rate in the table
+	 * unless the module was loaded with the 'initial_rate' parameter,
+	 * which is set to 10 times the desired rate. If an illegal value
+	 * is used for the parameter, the first rate in the table will be used. */
 	for (i = 0; i < mode->num_rates; i++) {
 		if ((sta->supp_rates & BIT(i)) &&
 		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
-			sta->txrate = i;
+			if (modparam_initial_rate) {
+				if (mode->rates[i].rate == modparam_initial_rate)
+					sta->txrate = i;
+			} else
+				sta->txrate = i;
 	}
 }
 
