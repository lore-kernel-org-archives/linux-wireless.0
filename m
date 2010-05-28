Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab0E1S5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:57:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OI4kW-00048j-SN
	for linux-wireless@vger.kernel.org; Fri, 28 May 2010 20:57:41 +0200
Message-Id: <20100528185505.468336320@sipsolutions.net>
Date: Fri, 28 May 2010 20:53:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 6/7] mac80211: pull mgmt frame rx into rx handler
References: <20100528185302.639535282@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some code is duplicated between ibss, mesh and
managed mode regarding the queueing of management
frames. Since all modes now use a common skb
queue and a common work function, we can pull
the queueing code into the rx handler directly
and remove the duplicated length checks etc.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        |   26 -------------------
 net/mac80211/ieee80211_i.h |    4 --
 net/mac80211/mesh.c        |   25 ------------------
 net/mac80211/mesh.h        |    2 -
 net/mac80211/mlme.c        |   27 -------------------
 net/mac80211/rx.c          |   61 +++++++++++++++++++++++++++++++++++----------
 6 files changed, 48 insertions(+), 97 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-05-28 20:37:08.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-05-28 20:37:11.000000000 +0200
@@ -985,8 +985,6 @@ int ieee80211_mgd_action(struct ieee8021
 			 enum nl80211_channel_type channel_type,
 			 bool channel_type_valid,
 			 const u8 *buf, size_t len, u64 *cookie);
-ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
-					  struct sk_buff *skb);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
@@ -1005,8 +1003,6 @@ void ieee80211_sta_rx_queued_mgmt(struct
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
-ieee80211_rx_result
-ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
 					gfp_t gfp);
--- wireless-testing.orig/net/mac80211/mesh.h	2010-05-28 20:35:58.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.h	2010-05-28 20:37:11.000000000 +0200
@@ -237,8 +237,6 @@ void ieee80211s_update_metric(struct iee
 		struct sta_info *stainfo, struct sk_buff *skb);
 void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
-ieee80211_rx_result
-ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
--- wireless-testing.orig/net/mac80211/ibss.c	2010-05-28 20:37:10.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-05-28 20:37:11.000000000 +0200
@@ -848,32 +848,6 @@ void ieee80211_ibss_notify_scan_complete
 	mutex_unlock(&local->iflist_mtx);
 }
 
-ieee80211_rx_result
-ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_mgmt *mgmt;
-	u16 fc;
-
-	if (skb->len < 24)
-		return RX_DROP_MONITOR;
-
-	mgmt = (struct ieee80211_mgmt *) skb->data;
-	fc = le16_to_cpu(mgmt->frame_control);
-
-	switch (fc & IEEE80211_FCTL_STYPE) {
-	case IEEE80211_STYPE_PROBE_RESP:
-	case IEEE80211_STYPE_BEACON:
-	case IEEE80211_STYPE_PROBE_REQ:
-	case IEEE80211_STYPE_AUTH:
-		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &sdata->work);
-		return RX_QUEUED;
-	}
-
-	return RX_DROP_MONITOR;
-}
-
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params)
 {
--- wireless-testing.orig/net/mac80211/mesh.c	2010-05-28 20:37:10.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2010-05-28 20:37:11.000000000 +0200
@@ -705,28 +705,3 @@ void ieee80211_mesh_init_sdata(struct ie
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
 }
-
-ieee80211_rx_result
-ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_mgmt *mgmt;
-	u16 fc;
-
-	if (skb->len < 24)
-		return RX_DROP_MONITOR;
-
-	mgmt = (struct ieee80211_mgmt *) skb->data;
-	fc = le16_to_cpu(mgmt->frame_control);
-
-	switch (fc & IEEE80211_FCTL_STYPE) {
-	case IEEE80211_STYPE_ACTION:
-	case IEEE80211_STYPE_PROBE_RESP:
-	case IEEE80211_STYPE_BEACON:
-		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &sdata->work);
-		return RX_QUEUED;
-	}
-
-	return RX_CONTINUE;
-}
--- wireless-testing.orig/net/mac80211/mlme.c	2010-05-28 20:37:10.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-05-28 20:37:11.000000000 +0200
@@ -1633,33 +1633,6 @@ static void ieee80211_rx_mgmt_beacon(str
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
-ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
-					  struct sk_buff *skb)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_mgmt *mgmt;
-	u16 fc;
-
-	if (skb->len < 24)
-		return RX_DROP_MONITOR;
-
-	mgmt = (struct ieee80211_mgmt *) skb->data;
-	fc = le16_to_cpu(mgmt->frame_control);
-
-	switch (fc & IEEE80211_FCTL_STYPE) {
-	case IEEE80211_STYPE_PROBE_RESP:
-	case IEEE80211_STYPE_BEACON:
-	case IEEE80211_STYPE_DEAUTH:
-	case IEEE80211_STYPE_DISASSOC:
-	case IEEE80211_STYPE_ACTION:
-		skb_queue_tail(&sdata->skb_queue, skb);
-		ieee80211_queue_work(&local->hw, &sdata->work);
-		return RX_QUEUED;
-	}
-
-	return RX_DROP_MONITOR;
-}
-
 void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				  struct sk_buff *skb)
 {
--- wireless-testing.orig/net/mac80211/rx.c	2010-05-28 20:35:58.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-05-28 20:37:11.000000000 +0200
@@ -1936,8 +1936,11 @@ ieee80211_rx_h_action(struct ieee80211_r
 		if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 			break;
 
-		if (sdata->vif.type == NL80211_IFTYPE_STATION)
-			return ieee80211_sta_rx_mgmt(sdata, rx->skb);
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			skb_queue_tail(&sdata->skb_queue, rx->skb);
+			ieee80211_queue_work(&local->hw, &sdata->work);
+			return RX_QUEUED;
+		}
 
 		switch (mgmt->u.action.u.addba_req.action_code) {
 		case WLAN_ACTION_ADDBA_REQ:
@@ -1989,7 +1992,9 @@ ieee80211_rx_h_action(struct ieee80211_r
 			if (memcmp(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN))
 				break;
 
-			return ieee80211_sta_rx_mgmt(sdata, rx->skb);
+			skb_queue_tail(&sdata->skb_queue, rx->skb);
+			ieee80211_queue_work(&local->hw, &sdata->work);
+			return RX_QUEUED;
 		}
 		break;
 	case WLAN_CATEGORY_SA_QUERY:
@@ -2007,9 +2012,11 @@ ieee80211_rx_h_action(struct ieee80211_r
 		break;
 	case WLAN_CATEGORY_MESH_PLINK:
 	case WLAN_CATEGORY_MESH_PATH_SEL:
-		if (ieee80211_vif_is_mesh(&sdata->vif))
-			return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
-		break;
+		if (!ieee80211_vif_is_mesh(&sdata->vif))
+			break;
+		skb_queue_tail(&sdata->skb_queue, rx->skb);
+		ieee80211_queue_work(&local->hw, &sdata->work);
+		return RX_QUEUED;
 	}
 
 	/*
@@ -2067,10 +2074,15 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	ieee80211_rx_result rxs;
+	struct ieee80211_mgmt *mgmt = (void *)rx->skb->data;
+	__le16 stype;
 
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
+	if (rx->skb->len < 24)
+		return RX_DROP_MONITOR;
+
 	if (ieee80211_drop_unencrypted_mgmt(rx))
 		return RX_DROP_UNUSABLE;
 
@@ -2078,16 +2090,39 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	if (rxs != RX_CONTINUE)
 		return rxs;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		return ieee80211_mesh_rx_mgmt(sdata, rx->skb);
+	stype = mgmt->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE);
+
+	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_STATION)
+		return RX_DROP_MONITOR;
 
-	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return ieee80211_ibss_rx_mgmt(sdata, rx->skb);
+	switch (stype) {
+	case cpu_to_le16(IEEE80211_STYPE_BEACON):
+	case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
+		/* process for all: mesh, mlme, ibss */
+		break;
+	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+	case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
+		/* process only for station */
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			return RX_DROP_MONITOR;
+		break;
+	case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
+	case cpu_to_le16(IEEE80211_STYPE_AUTH):
+		/* process only for ibss */
+		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
+			return RX_DROP_MONITOR;
+		break;
+	default:
+		return RX_DROP_MONITOR;
+	}
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		return ieee80211_sta_rx_mgmt(sdata, rx->skb);
+	/* queue up frame and kick off work to process it */
+	skb_queue_tail(&sdata->skb_queue, rx->skb);
+	ieee80211_queue_work(&rx->local->hw, &sdata->work);
 
-	return RX_DROP_MONITOR;
+	return RX_QUEUED;
 }
 
 static void ieee80211_rx_michael_mic_report(struct ieee80211_hdr *hdr,


