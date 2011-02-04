Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50380 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1BDXa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 18:30:29 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Make some mlme timers module paramaters.
Date: Fri,  4 Feb 2011 15:30:24 -0800
Message-Id: <1296862224-19489-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows users to tune the connection-loss algorithms
to be more or less lenient.  In particular, larger
null-func retries helps when using lots of virtual
stations on a loaded network.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 e059b3a... f77adf1... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |   34 +++++++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e059b3a..f77adf1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -28,8 +28,15 @@
 #include "rate.h"
 #include "led.h"
 
-#define IEEE80211_MAX_NULLFUNC_TRIES 2
-#define IEEE80211_MAX_PROBE_TRIES 5
+static int max_nullfunc_tries = 2;
+module_param(max_nullfunc_tries, int, 0644);
+MODULE_PARM_DESC(max_nullfunc_tries,
+		 "Maximum nullfunc tx tries before disconnecting (reason 4).");
+
+static int max_probe_tries = 5;
+module_param(max_probe_tries, int, 0644);
+MODULE_PARM_DESC(max_probe_tries,
+		 "Maximum probe tries before disconnecting (reason 4).");
 
 /*
  * Beacon loss timeout is calculated as N frames times the
@@ -51,7 +58,11 @@
  * a probe request because of beacon loss or for
  * checking the connection still works.
  */
-#define IEEE80211_PROBE_WAIT		(HZ / 2)
+static int probe_wait_ms = 500;
+module_param(probe_wait_ms, int, 0644);
+MODULE_PARM_DESC(probe_wait_ms,
+		 "Maximum time(ms) to wait for probe response"
+		 " before disconnecting (reason 4).");
 
 /*
  * Weight given to the latest Beacon frame when calculating average signal
@@ -1116,7 +1127,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
 	u8 *dst = ifmgd->associated->bssid;
-	u8 unicast_limit = max(1, IEEE80211_MAX_PROBE_TRIES - 3);
+	u8 unicast_limit = max(1, max_probe_tries - 3);
 
 	/*
 	 * Try sending broadcast probe requests for the last three
@@ -1142,7 +1153,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	}
 
 	ifmgd->probe_send_count++;
-	ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
+	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
 	run_again(ifmgd, ifmgd->probe_timeout);
 }
 
@@ -1243,7 +1254,8 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 
 	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 
-	printk(KERN_DEBUG "Connection to AP %pM lost.\n", bssid);
+	printk(KERN_DEBUG "%s: Connection to AP %pM lost.\n",
+	       sdata->name, bssid);
 
 	ieee80211_set_disassoc(sdata, true, true);
 	mutex_unlock(&ifmgd->mtx);
@@ -1988,9 +2000,9 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 
 		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-			max_tries = IEEE80211_MAX_NULLFUNC_TRIES;
+			max_tries = max_nullfunc_tries;
 		else
-			max_tries = IEEE80211_MAX_PROBE_TRIES;
+			max_tries = max_probe_tries;
 
 		/* ACK received for nullfunc probing frame */
 		if (!ifmgd->probe_send_count)
@@ -2022,7 +2034,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				    "%s: Failed to send nullfunc to AP %pM"
 				    " after %dms, disconnecting.\n",
 				    sdata->name,
-				    bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
+				    bssid, probe_wait_ms);
 #endif
 			ieee80211_sta_connection_lost(sdata, bssid);
 		} else if (ifmgd->probe_send_count < max_tries) {
@@ -2031,7 +2043,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				    "%s: No probe response from AP %pM"
 				    " after %dms, try %d/%i\n",
 				    sdata->name,
-				    bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ,
+				    bssid, probe_wait_ms,
 				    ifmgd->probe_send_count, max_tries);
 #endif
 			ieee80211_mgd_probe_ap_send(sdata);
@@ -2044,7 +2056,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				    "%s: No probe response from AP %pM"
 				    " after %dms, disconnecting.\n",
 				    sdata->name,
-				    bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
+				    bssid, probe_wait_ms);
 
 			ieee80211_sta_connection_lost(sdata, bssid);
 		}
-- 
1.7.2.3

