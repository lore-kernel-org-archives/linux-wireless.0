Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0FGLDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa6g-0007AU-BS
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:02 +0200
Message-Id: <20100607110159.253854920@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 02/21] mac80211: use common skb queue
References: <20100607110133.472649120@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IBSS, managed and mesh modes all have an
skb queue, and in the future we want to
also use it in other modes, so make them
all use a common skb queue already.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        |    7 +++----
 net/mac80211/ieee80211_i.h |    7 ++-----
 net/mac80211/iface.c       |   21 +++++++++++----------
 net/mac80211/mesh.c        |   14 ++------------
 net/mac80211/mlme.c        |    5 ++---
 5 files changed, 20 insertions(+), 34 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2010-05-31 21:20:18.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-06-01 10:19:35.000000000 +0200
@@ -779,7 +779,7 @@ static void ieee80211_ibss_work(struct w
 		return;
 	ifibss = &sdata->u.ibss;
 
-	while ((skb = skb_dequeue(&ifibss->skb_queue)))
+	while ((skb = skb_dequeue(&sdata->skb_queue)))
 		ieee80211_ibss_rx_queued_mgmt(sdata, skb);
 
 	if (!test_and_clear_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request))
@@ -850,7 +850,6 @@ void ieee80211_ibss_setup_sdata(struct i
 	INIT_WORK(&ifibss->work, ieee80211_ibss_work);
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
-	skb_queue_head_init(&ifibss->skb_queue);
 }
 
 /* scan finished notification */
@@ -890,7 +889,7 @@ ieee80211_ibss_rx_mgmt(struct ieee80211_
 	case IEEE80211_STYPE_BEACON:
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_AUTH:
-		skb_queue_tail(&sdata->u.ibss.skb_queue, skb);
+		skb_queue_tail(&sdata->skb_queue, skb);
 		ieee80211_queue_work(&local->hw, &sdata->u.ibss.work);
 		return RX_QUEUED;
 	}
@@ -983,7 +982,7 @@ int ieee80211_ibss_leave(struct ieee8021
 	synchronize_rcu();
 	kfree_skb(skb);
 
-	skb_queue_purge(&sdata->u.ibss.skb_queue);
+	skb_queue_purge(&sdata->skb_queue);
 	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
 	sdata->u.ibss.ssid_len = 0;
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-01 09:51:50.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-01 10:19:35.000000000 +0200
@@ -340,8 +340,6 @@ struct ieee80211_if_managed {
 
 	u16 aid;
 
-	struct sk_buff_head skb_queue;
-
 	unsigned long timers_running; /* used for quiesce/restart */
 	bool powersave; /* powersave requested for this iface */
 	enum ieee80211_smps_mode req_smps, /* requested smps mode */
@@ -388,8 +386,6 @@ struct ieee80211_if_ibss {
 	struct timer_list timer;
 	struct work_struct work;
 
-	struct sk_buff_head skb_queue;
-
 	unsigned long request;
 	unsigned long last_scan_completed;
 
@@ -420,7 +416,6 @@ struct ieee80211_if_mesh {
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
 	struct timer_list mesh_path_root_timer;
-	struct sk_buff_head skb_queue;
 
 	unsigned long timers_running;
 
@@ -517,6 +512,8 @@ struct ieee80211_sub_if_data {
 
 	u16 sequence_number;
 
+	struct sk_buff_head skb_queue;
+
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
--- wireless-testing.orig/net/mac80211/iface.c	2010-06-01 10:19:33.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-01 10:19:35.000000000 +0200
@@ -465,21 +465,11 @@ static int ieee80211_stop(struct net_dev
 		cancel_work_sync(&sdata->u.mgd.monitor_work);
 		cancel_work_sync(&sdata->u.mgd.beacon_connection_loss_work);
 
-		/*
-		 * When we get here, the interface is marked down.
-		 * Call synchronize_rcu() to wait for the RX path
-		 * should it be using the interface and enqueuing
-		 * frames at this very time on another CPU.
-		 */
-		synchronize_rcu();
-		skb_queue_purge(&sdata->u.mgd.skb_queue);
 		/* fall through */
 	case NL80211_IFTYPE_ADHOC:
 		if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 			del_timer_sync(&sdata->u.ibss.timer);
 			cancel_work_sync(&sdata->u.ibss.work);
-			synchronize_rcu();
-			skb_queue_purge(&sdata->u.ibss.skb_queue);
 		}
 		/* fall through */
 	case NL80211_IFTYPE_MESH_POINT:
@@ -495,6 +485,15 @@ static int ieee80211_stop(struct net_dev
 		}
 		/* fall through */
 	default:
+		/*
+		 * When we get here, the interface is marked down.
+		 * Call synchronize_rcu() to wait for the RX path
+		 * should it be using the interface and enqueuing
+		 * frames at this very time on another CPU.
+		 */
+		synchronize_rcu();
+		skb_queue_purge(&sdata->skb_queue);
+
 		if (local->scan_sdata == sdata)
 			ieee80211_scan_cancel(local);
 
@@ -721,6 +720,8 @@ static void ieee80211_setup_sdata(struct
 	/* only monitor differs */
 	sdata->dev->type = ARPHRD_ETHER;
 
+	skb_queue_head_init(&sdata->skb_queue);
+
 	switch (type) {
 	case NL80211_IFTYPE_AP:
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
--- wireless-testing.orig/net/mac80211/mesh.c	2010-05-31 21:20:18.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2010-06-01 10:19:35.000000000 +0200
@@ -537,15 +537,6 @@ void ieee80211_stop_mesh(struct ieee8021
 	 * it no longer is.
 	 */
 	cancel_work_sync(&sdata->u.mesh.work);
-
-	/*
-	 * When we get here, the interface is marked down.
-	 * Call synchronize_rcu() to wait for the RX path
-	 * should it be using the interface and enqueuing
-	 * frames at this very time on another CPU.
-	 */
-	rcu_barrier(); /* Wait for RX path and call_rcu()'s */
-	skb_queue_purge(&sdata->u.mesh.skb_queue);
 }
 
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
@@ -650,7 +641,7 @@ static void ieee80211_mesh_work(struct w
 	if (local->scanning)
 		return;
 
-	while ((skb = skb_dequeue(&ifmsh->skb_queue)))
+	while ((skb = skb_dequeue(&sdata->skb_queue)))
 		ieee80211_mesh_rx_queued_mgmt(sdata, skb);
 
 	if (ifmsh->preq_queue_len &&
@@ -690,7 +681,6 @@ void ieee80211_mesh_init_sdata(struct ie
 	setup_timer(&ifmsh->housekeeping_timer,
 		    ieee80211_mesh_housekeeping_timer,
 		    (unsigned long) sdata);
-	skb_queue_head_init(&sdata->u.mesh.skb_queue);
 
 	ifmsh->mshcfg.dot11MeshRetryTimeout = MESH_RET_T;
 	ifmsh->mshcfg.dot11MeshConfirmTimeout = MESH_CONF_T;
@@ -750,7 +740,7 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_
 	case IEEE80211_STYPE_ACTION:
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
-		skb_queue_tail(&ifmsh->skb_queue, skb);
+		skb_queue_tail(&sdata->skb_queue, skb);
 		ieee80211_queue_work(&local->hw, &ifmsh->work);
 		return RX_QUEUED;
 	}
--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-01 10:19:33.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-06-01 10:19:35.000000000 +0200
@@ -1652,7 +1652,7 @@ ieee80211_rx_result ieee80211_sta_rx_mgm
 	case IEEE80211_STYPE_DEAUTH:
 	case IEEE80211_STYPE_DISASSOC:
 	case IEEE80211_STYPE_ACTION:
-		skb_queue_tail(&sdata->u.mgd.skb_queue, skb);
+		skb_queue_tail(&sdata->skb_queue, skb);
 		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 		return RX_QUEUED;
 	}
@@ -1810,7 +1810,7 @@ static void ieee80211_sta_work(struct wo
 	ifmgd = &sdata->u.mgd;
 
 	/* first process frames to avoid timing out while a frame is pending */
-	while ((skb = skb_dequeue(&ifmgd->skb_queue)))
+	while ((skb = skb_dequeue(&sdata->skb_queue)))
 		ieee80211_sta_rx_queued_mgmt(sdata, skb);
 
 	/* then process the rest of the work */
@@ -1967,7 +1967,6 @@ void ieee80211_sta_setup_sdata(struct ie
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,
 		    (unsigned long) sdata);
-	skb_queue_head_init(&ifmgd->skb_queue);
 
 	ifmgd->flags = 0;
 


