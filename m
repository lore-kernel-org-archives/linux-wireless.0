Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48447 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752095Ab0FOMPz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 08:15:55 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: kalle.valo@iki.fi
Subject: [RFC] Changes in mac80211 to make at76c50x-usb working again
Date: Tue, 15 Jun 2010 14:16:36 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006151416.36686.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the at76c50x-usb driver fails to authenticate with an AP. The last working 
major kernel version was 2.6.30. I investigated the problem and found out 
that the driver needs to send a join command (CMD_JOIN) prior to the actual 
authentication process. For the join command, the driver needs to know the 
bssid of the AP. The problem is now that the mac80211 layer does not inform 
the driver about the bssid prior to the authentication. So we have a 
chicken-and-egg dilemma.

The following patch solves the described problem. As it modifies generic 
mac80211 code and thus has influence on all drivers I'm open for comments on 
how to make a proper, probably less intrusive patch.

Sebastian

---
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a1bf46c..6c34b4f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -180,17 +180,9 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 	if (!changed)
 		return;
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		/*
-		 * While not associated, claim a BSSID of all-zeroes
-		 * so that drivers don't do any weird things with the
-		 * BSSID at that time.
-		 */
-		if (sdata->vif.bss_conf.assoc)
-			sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
-		else
-			sdata->vif.bss_conf.bssid = zero;
-	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+	if (sdata->vif.type == NL80211_IFTYPE_STATION)
+		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4dad08f..b06b175 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2042,6 +2042,9 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	wk->sdata = sdata;
 	wk->done = ieee80211_probe_auth_done;
 
+	memcpy(sdata->u.mgd.bssid, req->bss->bssid, ETH_ALEN);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+
 	ieee80211_add_work(wk);
 	return 0;
 }
