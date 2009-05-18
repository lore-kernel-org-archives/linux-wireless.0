Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46749 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZERTaP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 15:30:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "Wey-Yi W Guy" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix managed mode BSSID handling
Date: Mon, 18 May 2009 15:20:11 -0400
Message-Id: <1242674411-26301-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1242299414.500.7.camel@johannes.local>
References: <1242299414.500.7.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Did not apply to 2.6.30-rc6 as posted -- please verify my fix-up!

 net/mac80211/main.c |   16 ++++++++++++----
 net/mac80211/mlme.c |   14 +++++++-------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1413419..346c25e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -157,20 +157,28 @@ int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_conf conf;
+	static const u8 zero[ETH_ALEN] = { 0 };
 
 	if (WARN_ON(!netif_running(sdata->dev)))
 		return 0;
 
 	memset(&conf, 0, sizeof(conf));
 
-	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		conf.bssid = sdata->u.mgd.bssid;
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
 		conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)
 		conf.bssid = sdata->dev->dev_addr;
 	else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-		static const u8 zero[ETH_ALEN] = { 0 };
 		conf.bssid = zero;
 	} else {
 		WARN_ON(1);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 132938b..61ade8d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -632,6 +632,10 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	 * changed or not.
 	 */
 	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
+
+	/* And the BSSID changed - we're associated now */
+	bss_info_changed |= BSS_CHANGED_BSSID;
+
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	if (local->powersave) {
@@ -831,6 +835,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ieee80211_hw_config(local, config_changed);
+
+	/* And the BSSID changed -- not very interesting here */
+	changed |= BSS_CHANGED_BSSID;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	rcu_read_lock();
@@ -2032,13 +2039,6 @@ int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid)
 		ifmgd->flags &= ~IEEE80211_STA_BSSID_SET;
 	}
 
-	if (netif_running(sdata->dev)) {
-		if (ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID)) {
-			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
-			       "the low-level driver\n", sdata->dev->name);
-		}
-	}
-
 	return ieee80211_sta_commit(sdata);
 }
 
-- 
1.6.0.6

