Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbZENLKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 07:10:47 -0400
Subject: [PATCH 2.6.30] mac80211: fix managed mode BSSID handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 13:10:14 +0200
Message-Id: <1242299414.500.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, we will ask the driver to configure right away
when somebody changes the desired BSSID. That's totally
strange because then we will configure the driver without
even knowing whether the BSS exists. Change this to only
configure the BSSID when associated, and configure a zero
BSSID when not associated.

As a side effect, this fixes an issue with the iwlwifi
driver which doesn't implement sta_notify properly and
uses the BSSID instead and gets very confused if the
BSSID is cleared before we disassociate, which results
in the warning Marcel posted [1] and iwlwifi bug 1995 [2].

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/32598
[2] http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1995

Cc: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |   16 ++++++++++++----
 net/mac80211/mlme.c |   10 +++++++---
 2 files changed, 19 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-14 11:38:42.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-14 12:39:57.000000000 +0200
@@ -865,6 +865,10 @@ static void ieee80211_set_associated(str
 	 * changed or not.
 	 */
 	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
+
+	/* And the BSSID changed - we're associated now */
+	bss_info_changed |= BSS_CHANGED_BSSID;
+
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	/* will be same as sdata */
@@ -1064,6 +1068,9 @@ static void ieee80211_set_disassoc(struc
 	}
 
 	ieee80211_hw_config(local, config_changed);
+
+	/* And the BSSID changed -- not very interesting here */
+	changed |= BSS_CHANGED_BSSID;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	rcu_read_lock();
@@ -2310,9 +2317,6 @@ int ieee80211_sta_set_bssid(struct ieee8
 		ifmgd->flags &= ~IEEE80211_STA_BSSID_SET;
 	}
 
-	if (netif_running(sdata->dev))
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
-
 	return ieee80211_sta_commit(sdata);
 }
 
--- wireless-testing.orig/net/mac80211/main.c	2009-05-14 12:40:44.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-05-14 12:54:23.000000000 +0200
@@ -219,18 +219,26 @@ void ieee80211_bss_info_change_notify(st
 				      u32 changed)
 {
 	struct ieee80211_local *local = sdata->local;
+	static const u8 zero[ETH_ALEN] = { 0 };
 
 	if (!changed)
 		return;
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
-	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		/*
+		 * While not associated, claim a BSSID of all-zeroes
+		 * so that drivers don't do any weird things with the
+		 * BSSID at that time.
+		 */
+		if (sdata->vif.bss_conf.assoc)
+			sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
+		else
+			sdata->vif.bss_conf.bssid = zero;
+	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		sdata->vif.bss_conf.bssid = sdata->dev->dev_addr;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		static const u8 zero[ETH_ALEN] = { 0 };
 		sdata->vif.bss_conf.bssid = zero;
 	} else {
 		WARN_ON(1);


