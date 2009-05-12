Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZELSNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 14:13:49 -0400
Subject: [PATCH v2] mac80211: split out and decrease probe wait time
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242151393.11924.3.camel@johannes.local>
References: <1242151393.11924.3.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 12 May 2009 20:11:26 +0200
Message-Id: <1242151886.11924.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The time we wait for a probe response after probing an AP due to
beacon loss is currently the same as the monitoring interval, 2s.
This is far too long, APs should respond to probes within a
fraction of that time. To be able to adjust both values, add a
new constant IEEE80211_PROBE_WAIT, use it for checking the probe
response, and adjust it down to 200ms instead of 2 seconds.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Oops, replaced one too many, although we probably should make that bit
smarter too.

 net/mac80211/mlme.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-12 19:58:27.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-12 20:10:30.000000000 +0200
@@ -33,6 +33,7 @@
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
+#define IEEE80211_PROBE_WAIT (HZ / 20)
 #define IEEE80211_PROBE_IDLE_TIME (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 
@@ -1205,7 +1206,7 @@ void ieee80211_beacon_loss_work(struct w
 	ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
 				 ifmgd->ssid_len, NULL, 0);
 
-	mod_timer(&ifmgd->timer, jiffies + IEEE80211_MONITORING_INTERVAL);
+	mod_timer(&ifmgd->timer, jiffies + IEEE80211_PROBE_WAIT);
 }
 
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
@@ -1242,7 +1243,7 @@ static void ieee80211_associated(struct 
 	}
 
 	if ((ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) &&
-	    time_after(jiffies, sta->last_rx + IEEE80211_MONITORING_INTERVAL)) {
+	    time_after(jiffies, sta->last_rx + IEEE80211_PROBE_WAIT)) {
 		printk(KERN_DEBUG "%s: no probe response from AP %pM "
 		       "- disassociating\n",
 		       sdata->dev->name, ifmgd->bssid);


