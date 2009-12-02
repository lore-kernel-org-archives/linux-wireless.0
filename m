Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbZLBLsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 06:48:45 -0500
Message-Id: <20091202114646.771433413@sipsolutions.net>
Date: Wed, 02 Dec 2009 12:43:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] mac80211: dont try to use existing sta for AP
References: <20091202114341.088046714@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clean out some cruft that could use an already existing
sta_info struct -- that case cannot happen. Also, there's
a bug there -- if allocation/insertion fails then it is
possible that we are left in a lingering state where
mac80211 waits for the AP, cfg80211 waits for mac80211,
but the AP has already replied. Since there's no way to
indicate an internal error, pretend there was a timeout,
i.e. that the AP never responded.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   57 +++++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-01 18:26:51.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-01 18:26:59.000000000 +0100
@@ -75,6 +75,9 @@ enum rx_mgmt_action {
 	/* caller must call cfg80211_send_disassoc() */
 	RX_MGMT_CFG80211_DISASSOC,
 
+	/* caller must tell cfg80211 about internal error */
+	RX_MGMT_CFG80211_ASSOC_ERROR,
+
 	/* caller must call cfg80211_auth_timeout() & free work */
 	RX_MGMT_CFG80211_AUTH_TO,
 
@@ -1479,8 +1482,8 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	u8 *pos;
 	u32 changed = 0;
-	int i, j;
-	bool have_higher_than_11mbit = false, newsta = false;
+	int i, j, err;
+	bool have_higher_than_11mbit = false;
 	u16 ap_ht_cap_flags;
 
 	/*
@@ -1542,30 +1545,18 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	printk(KERN_DEBUG "%s: associated\n", sdata->name);
 	ifmgd->aid = aid;
 
-	rcu_read_lock();
-
-	/* Add STA entry for the AP */
-	sta = sta_info_get(sdata, wk->bss->cbss.bssid);
+	sta = sta_info_alloc(sdata, wk->bss->cbss.bssid, GFP_KERNEL);
 	if (!sta) {
-		newsta = true;
-
-		rcu_read_unlock();
-
-		sta = sta_info_alloc(sdata, wk->bss->cbss.bssid, GFP_KERNEL);
-		if (!sta) {
-			printk(KERN_DEBUG "%s: failed to alloc STA entry for"
-			       " the AP\n", sdata->name);
-			return RX_MGMT_NONE;
-		}
-
-		set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC |
-				   WLAN_STA_ASSOC_AP);
-		if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
-			set_sta_flags(sta, WLAN_STA_AUTHORIZED);
-
-		rcu_read_lock();
+		printk(KERN_DEBUG "%s: failed to alloc STA entry for"
+		       " the AP\n", sdata->name);
+		return RX_MGMT_CFG80211_ASSOC_ERROR;
 	}
 
+	set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC |
+			   WLAN_STA_ASSOC_AP);
+	if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
+		set_sta_flags(sta, WLAN_STA_AUTHORIZED);
+
 	rates = 0;
 	basic_rates = 0;
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
@@ -1628,18 +1619,14 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	if (elems.wmm_param)
 		set_sta_flags(sta, WLAN_STA_WME);
 
-	if (newsta) {
-		int err = sta_info_insert(sta);
-		if (err) {
-			printk(KERN_DEBUG "%s: failed to insert STA entry for"
-			       " the AP (error %d)\n", sdata->name, err);
-			rcu_read_unlock();
-			return RX_MGMT_NONE;
-		}
+	err = sta_info_insert(sta);
+	sta = NULL;
+	if (err) {
+		printk(KERN_DEBUG "%s: failed to insert STA entry for"
+		       " the AP (error %d)\n", sdata->name, err);
+		return RX_MGMT_CFG80211_ASSOC_ERROR;
 	}
 
-	rcu_read_unlock();
-
 	if (elems.wmm_param)
 		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
 					 elems.wmm_param_len);
@@ -2084,6 +2071,10 @@ static void ieee80211_sta_rx_queued_mgmt
 	case RX_MGMT_CFG80211_DEAUTH:
 		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
 		break;
+	case RX_MGMT_CFG80211_ASSOC_ERROR:
+		/* an internal error -- pretend timeout for now */
+		cfg80211_send_assoc_timeout(sdata->dev, mgmt->bssid);
+		break;
 	default:
 		WARN(1, "unexpected: %d", rma);
 	}


