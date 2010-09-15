Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0IONNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 09:13:36 -0400
Subject: [PATCH] mac80211: set running state earlier
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Rajkumar Manoharan <rmanoharan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 15:13:13 +0200
Message-ID: <1284556393.7705.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When an interface is brought up, the recent changes
to allow changing type-while-up only set the running
bit after everything was done. This broke a number
of things, including idle calculation for monitor
interfaces, and it also broke WDS station insertion
(although nobody noticed yet).

Thus, change the code to set the running bit earlier,
but keep it after the driver's add_interface was
called because otherwise drivers may iterate over
interfaces they haven't fully set up yet.

Reported-by: Rajkumar Manoharan <rmanoharan@atheros.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- iwlwifi-multi.orig/net/mac80211/iface.c	2010-09-15 15:07:56.000000000 +0200
+++ iwlwifi-multi/net/mac80211/iface.c	2010-09-15 15:08:52.000000000 +0200
@@ -280,6 +280,8 @@ static int ieee80211_do_open(struct net_
 			netif_carrier_on(dev);
 	}
 
+	set_bit(SDATA_STATE_RUNNING, &sdata->state);
+
 	if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		/* Create STA entry for the WDS peer */
 		sta = sta_info_alloc(sdata, sdata->u.wds.remote_addr,
@@ -331,8 +333,6 @@ static int ieee80211_do_open(struct net_
 
 	netif_tx_start_all_queues(dev);
 
-	set_bit(SDATA_STATE_RUNNING, &sdata->state);
-
 	return 0;
  err_del_interface:
 	drv_remove_interface(local, &sdata->vif);
@@ -343,6 +343,7 @@ static int ieee80211_do_open(struct net_
 	sdata->bss = NULL;
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		list_del(&sdata->u.vlan.list);
+	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 	return res;
 }
 


