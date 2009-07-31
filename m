Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:59233 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbZGaNTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 09:19:46 -0400
Received: by fxm17 with SMTP id 17so1362234fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 06:19:45 -0700 (PDT)
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1249026181.29587.14.camel@johannes.local>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <1249024097.7653.6.camel@maxim-laptop>
	 <1249026181.29587.14.camel@johannes.local>
Content-Type: multipart/mixed; boundary="=-xzyXL1HBlQ4InjRGJPyY"
Date: Fri, 31 Jul 2009 16:19:40 +0300
Message-Id: <1249046380.6418.6.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xzyXL1HBlQ4InjRGJPyY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2009-07-31 at 09:43 +0200, Johannes Berg wrote:
> On Fri, 2009-07-31 at 10:08 +0300, Maxim Levitsky wrote:
> > On Wed, 2009-07-29 at 14:32 -0700, Reinette Chatre wrote:
> > > From: Reinette Chatre <reinette.chatre@intel.com>
> > > 
> > > The connection monitor currently relies on probe requests paired
> > > with probe responses to ensure that a connection is alive. This is
> > > fragile in some environments where probe responses can get lost.
> > > When we receive beacons we can also consider the connection to be
> > > alive, so cancel connection poll instance when we receive a beacon.
> > > 
> > > The debug message "cancelling probereq poll due to a received beacon"
> > > is removed as part of this change as this case is hit very often after
> > > the above change and debug log receives significant number of these messages.
> > 
> > In my opinion this is the correct solution
> > I did plenty of wireless monitoring, and I see that nobody sends probe
> > requests at that rate (1 per second it seems). This is ridiculous.
> 
> Fix it then. Offer an implementation of your superior solution. We've
> done pretty much exactly what you're all pointing out _forever_ in
> mac80211, ever since it was initially merged. Now that it's more
> explicit in the code, people are complaining?
> 
> johannes


Here it is:

First patch makes the probe requests be retried (and with it and only
it, my connection is very stable, it never retries more that 3 times,
and I set max retries to 5)

Second patch, trivial one bumps up the timeouts (30 for ping, and 1/2
for response, so device won't send out frames too often)

I attach the patches, since I afraid my mailer would mangle them.

Here they are in-line too:


-------------------------------------------------------------------------------------------------

[MAC80211] Retry probe request few times, before assuming that AP is out of range

From: Maxim Levitsky <maximlevitsky@gmail.com>

Fixes very often reconnects while connected to nearby APs

Signed-off-by: Maxim Levitky <maximlevitsky@gmail.com>
---

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   27 ++++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index aec6853..ac2489b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -280,6 +280,7 @@ struct ieee80211_if_managed {
 	struct work_struct beacon_loss_work;
 
 	unsigned long probe_timeout;
+	unsigned long probe_miss_count;
 
 	struct mutex mtx;
 	struct ieee80211_bss *associated;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ee83125..38ef7f2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -31,6 +31,7 @@
 #define IEEE80211_AUTH_MAX_TRIES 3
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
+#define IEEE80211_ASSOC_RETRIES 5
 
 /*
  * beacon loss detection timeout
@@ -1209,6 +1210,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_ps(sdata->local, -1);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
+	sdata->u.mgd.probe_miss_count = 0;
 	ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
 	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
 				 ssid + 2, ssid[1], NULL, 0);
@@ -2072,17 +2074,36 @@ static void ieee80211_sta_work(struct work_struct *work)
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL) &&
 	    ifmgd->associated) {
+
+		u8 bssid[ETH_ALEN];
+		const u8 *ssid;
+
+		memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
+
 		if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
-		else {
-			u8 bssid[ETH_ALEN];
+
+		else if (ifmgd->probe_miss_count < IEEE80211_ASSOC_RETRIES) {
+
+			printk(KERN_DEBUG "No probe response from AP %pM"
+				" after %dms, try %d\n", bssid,
+				(1000 * IEEE80211_PROBE_WAIT)/HZ,
+				(int)ifmgd->probe_miss_count);
+
+			ifmgd->probe_miss_count++;
+			ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
+			run_again(ifmgd, ifmgd->probe_timeout);
+
+			ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
+			ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
+				ssid + 2, ssid[1], NULL, 0);
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





------------------------------------------------------------------------------------------

[MAC80211] Increase timeouts for AP polling

From: Maxim Levitsky <maximlevitsky@gmail.com>

Do a poll every 30 seconds, and wait for response half a second

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---

 net/mac80211/mlme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 38ef7f2..a8ab40c 100644
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

--=-xzyXL1HBlQ4InjRGJPyY
Content-Disposition: attachment; filename="0001-mac80211-retry-probe-requests"
Content-Type: text/plain; name="0001-mac80211-retry-probe-requests"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[MAC80211] Retry probe request few times, before assuming that AP is out of range

From: Maxim Levitsky <maximlevitsky@gmail.com>

Fixes very often reconnects while connected to nearby APs

Signed-off-by: Maxim Levitky <maximlevitsky@gmail.com>
---

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   27 ++++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index aec6853..ac2489b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -280,6 +280,7 @@ struct ieee80211_if_managed {
 	struct work_struct beacon_loss_work;
 
 	unsigned long probe_timeout;
+	unsigned long probe_miss_count;
 
 	struct mutex mtx;
 	struct ieee80211_bss *associated;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ee83125..38ef7f2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -31,6 +31,7 @@
 #define IEEE80211_AUTH_MAX_TRIES 3
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
+#define IEEE80211_ASSOC_RETRIES 5
 
 /*
  * beacon loss detection timeout
@@ -1209,6 +1210,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_ps(sdata->local, -1);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
+	sdata->u.mgd.probe_miss_count = 0;
 	ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
 	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
 				 ssid + 2, ssid[1], NULL, 0);
@@ -2072,17 +2074,36 @@ static void ieee80211_sta_work(struct work_struct *work)
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL) &&
 	    ifmgd->associated) {
+
+		u8 bssid[ETH_ALEN];
+		const u8 *ssid;
+
+		memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
+
 		if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
-		else {
-			u8 bssid[ETH_ALEN];
+
+		else if (ifmgd->probe_miss_count < IEEE80211_ASSOC_RETRIES) {
+
+			printk(KERN_DEBUG "No probe response from AP %pM"
+				" after %dms, try %d\n", bssid,
+				(1000 * IEEE80211_PROBE_WAIT)/HZ,
+				(int)ifmgd->probe_miss_count);
+
+			ifmgd->probe_miss_count++;
+			ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
+			run_again(ifmgd, ifmgd->probe_timeout);
+
+			ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
+			ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
+				ssid + 2, ssid[1], NULL, 0);
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

--=-xzyXL1HBlQ4InjRGJPyY
Content-Disposition: attachment; filename="0002-mac80211-increase-timeouts-for"
Content-Type: text/plain; name="0002-mac80211-increase-timeouts-for"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[MAC80211] Increase timeouts for AP polling

From: Maxim Levitsky <maximlevitsky@gmail.com>

Do a poll every 30 seconds, and wait for response half a second

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---

 net/mac80211/mlme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 38ef7f2..a8ab40c 100644
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

--=-xzyXL1HBlQ4InjRGJPyY--

