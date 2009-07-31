Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50175 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZGaQPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:15:04 -0400
Received: by bwz19 with SMTP id 19so1285215bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 09:15:01 -0700 (PDT)
Subject: [PATCH 000/002] Fix frequent reconnects caused by new conection
 monitor
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: multipart/mixed; boundary="=-xmg/2bmumQZjWoMrv0to"
Date: Fri, 31 Jul 2009 19:13:37 +0300
Message-Id: <1249056817.20593.1.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xmg/2bmumQZjWoMrv0to
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi, here is the updated version of these two patches that fix the
$SUBJECT issue.

I attach these (in case mailer mangles them), and reply with patches.

Tested both with low quality signal, and beacon loss.
Lack of TX is found, every 30 seconds now, and quite reliable.
Lack of beacons, triggers probe like it did every 2 seconds.



Best regards,
Maxim Levitsky

--=-xmg/2bmumQZjWoMrv0to
Content-Disposition: attachment; filename="0001--MAC80211-Retry-probe-request-few-times.patch"
Content-Type: text/x-patch; name="0001--MAC80211-Retry-probe-request-few-times.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 0bf5749f2878f9245b8fb1b64456386374205225 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 31 Jul 2009 18:54:12 +0300
Subject: [PATCH] [MAC80211] Retry probe request few times

Retry 5 times  (chosen arbitary ), before assuming
that station is out of range.

Fixes frequent disassociations while connected to weak,
and sometimes even strong access points.

Signed-off-by: Maxim Levitky <maximlevitsky@gmail.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   42 ++++++++++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index aec6853..bca7b60 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -280,6 +280,7 @@ struct ieee80211_if_managed {
 	struct work_struct beacon_loss_work;
 
 	unsigned long probe_timeout;
+	int probe_send_count;
 
 	struct mutex mtx;
 	struct ieee80211_bss *associated;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ee83125..1d8640a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -31,6 +31,7 @@
 #define IEEE80211_AUTH_MAX_TRIES 3
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
+#define IEEE80211_MAX_PROBE_TRIES 5
 
 /*
  * beacon loss detection timeout
@@ -1156,11 +1157,24 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
 }
 
+static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	const u8 *ssid;
+
+	ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
+	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
+				 ssid + 2, ssid[1], NULL, 0);
+
+	ifmgd->probe_send_count++;
+	ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
+	run_again(ifmgd, ifmgd->probe_timeout);
+}
+
 static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 				   bool beacon)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	const u8 *ssid;
 	bool already = false;
 
 	if (!netif_running(sdata->dev))
@@ -1203,18 +1217,12 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	if (already)
 		goto out;
 
-	ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
-
 	mutex_lock(&sdata->local->iflist_mtx);
 	ieee80211_recalc_ps(sdata->local, -1);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
-	ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
-	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
-				 ssid + 2, ssid[1], NULL, 0);
-
-	run_again(ifmgd, ifmgd->probe_timeout);
-
+	ifmgd->probe_send_count = 0;
+	ieee80211_mgd_probe_ap_send(sdata);
  out:
 	mutex_unlock(&ifmgd->mtx);
 }
@@ -2072,17 +2080,27 @@ static void ieee80211_sta_work(struct work_struct *work)
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL) &&
 	    ifmgd->associated) {
+		u8 bssid[ETH_ALEN];
+
+		memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
 		if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
-		else {
-			u8 bssid[ETH_ALEN];
+
+		else if (ifmgd->probe_send_count < IEEE80211_MAX_PROBE_TRIES) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+			printk(KERN_DEBUG "No probe response from AP %pM"
+				" after %dms, try %d\n", bssid,
+				(1000 * IEEE80211_PROBE_WAIT)/HZ,
+				ifmgd->probe_send_count);
+#endif
+			ieee80211_mgd_probe_ap_send(sdata);
+		} else {
 			/*
 			 * We actually lost the connection ... or did we?
 			 * Let's make sure!
 			 */
 			ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 					  IEEE80211_STA_BEACON_POLL);
-			memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
 			printk(KERN_DEBUG "No probe response from AP %pM"
 				" after %dms, disconnecting.\n",
 				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
-- 
1.6.0.4


--=-xmg/2bmumQZjWoMrv0to
Content-Disposition: attachment; filename="0002--MAC80211-Increase-timeouts-for-station-polling.patch"
Content-Type: text/x-patch; name="0002--MAC80211-Increase-timeouts-for-station-polling.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 04976d22d45f26aa4b4dece5dd520e3347ac32d7 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 31 Jul 2009 18:54:23 +0300
Subject: [PATCH] [MAC80211] Increase timeouts for station polling

Do a probe request every 30 seconds, and wait for probe response, half a second
This should lower the traffic that card sends, thus save power
Wainting longer for response makes probe more robust against 'slow' access points

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 net/mac80211/mlme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1d8640a..e4bb590 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -42,13 +42,13 @@
  * Time the connection can be idle before we probe
  * it to see if we can still talk to the AP.
  */
-#define IEEE80211_CONNECTION_IDLE_TIME	(2 * HZ)
+#define IEEE80211_CONNECTION_IDLE_TIME	(30 * HZ)
 /*
  * Time we wait for a probe response after sending
  * a probe request because of beacon loss or for
  * checking the connection still works.
  */
-#define IEEE80211_PROBE_WAIT		(HZ / 5)
+#define IEEE80211_PROBE_WAIT		(HZ / 2)
 
 #define TMR_RUNNING_TIMER	0
 #define TMR_RUNNING_CHANSW	1
-- 
1.6.0.4


--=-xmg/2bmumQZjWoMrv0to--

