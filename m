Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2CHODV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 09:03:21 -0500
Message-Id: <20120308140227.275371120@sipsolutions.net> (sfid-20120308_150324_856202_349A82E4)
Date: Thu, 08 Mar 2012 15:02:07 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] mac80211: refactor common auth/assoc setup code
References: <20120308140202.751490800@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As associating is possible without first authenticating
(for FT over DS) association also has to be able to
switch to the right channel, insert the station entry
etc. Factor out this common code into a new function
called ieee80211_prep_connection().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |  121 +++++++++++++++++++++++++---------------------------
 1 file changed, 59 insertions(+), 62 deletions(-)

--- a/net/mac80211/mlme.c	2012-03-08 13:55:22.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-08 13:57:09.000000000 +0100
@@ -3128,6 +3128,60 @@ int ieee80211_max_network_latency(struct
 	return 0;
 }
 
+static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_bss *bss, bool assoc)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct sta_info *sta;
+	bool have_sta = false;
+	int err;
+
+	if (WARN_ON(!ifmgd->auth_data && !ifmgd->assoc_data))
+		return -EINVAL;
+
+	if (assoc) {
+		rcu_read_lock();
+		have_sta = sta_info_get(sdata, bss->bssid);
+		rcu_read_unlock();
+	}
+
+	if (!have_sta) {
+		sta = sta_info_alloc(sdata, bss->bssid, GFP_KERNEL);
+		if (!sta)
+			return -ENOMEM;
+	}
+
+	mutex_lock(&local->mtx);
+	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&local->mtx);
+
+	/* switch to the right channel */
+	local->oper_channel = bss->channel;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	if (!have_sta) {
+		/* set BSSID - if STA already there this will be set too */
+		memcpy(ifmgd->bssid, bss->bssid, ETH_ALEN);
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+
+		if (assoc)
+			sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+
+		err = sta_info_insert(sta);
+		sta = NULL;
+		if (err) {
+			printk(KERN_DEBUG
+			       "%s: failed to insert STA entry for the AP (error %d)\n",
+			       sdata->name, err);
+			return err;
+		}
+	} else
+		WARN_ON_ONCE(compare_ether_addr(ifmgd->bssid, bss->bssid));
+
+	return 0;
+}
+
 /* config hooks */
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		       struct cfg80211_auth_request *req)
@@ -3135,7 +3189,6 @@ int ieee80211_mgd_auth(struct ieee80211_
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_auth_data *auth_data;
-	struct sta_info *sta;
 	u16 auth_alg;
 	int err;
 
@@ -3201,32 +3254,9 @@ int ieee80211_mgd_auth(struct ieee80211_
 	printk(KERN_DEBUG "%s: authenticate with %pM\n",
 	       sdata->name, req->bss->bssid);
 
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&local->mtx);
-
-	/* switch to the right channel */
-	local->oper_channel = req->bss->channel;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-
-	/* set BSSID */
-	memcpy(ifmgd->bssid, req->bss->bssid, ETH_ALEN);
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
-
-	/* add station entry */
-	sta = sta_info_alloc(sdata, req->bss->bssid, GFP_KERNEL);
-	if (!sta) {
-		err = -ENOMEM;
+	err = ieee80211_prep_connection(sdata, req->bss, false);
+	if (err)
 		goto err_clear;
-	}
-
-	err = sta_info_insert(sta);
-	if (err) {
-		printk(KERN_DEBUG
-		       "%s: failed to insert STA entry for the AP %pM (error %d)\n",
-		       sdata->name, req->bss->bssid, err);
-		goto err_clear;
-	}
 
 	err = ieee80211_probe_auth(sdata);
 	if (err) {
@@ -3260,7 +3290,6 @@ int ieee80211_mgd_assoc(struct ieee80211
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
 	struct ieee80211_mgd_assoc_data *assoc_data;
 	struct ieee80211_supported_band *sband;
-	struct sta_info *sta;
 	const u8 *ssidie;
 	int i, err;
 
@@ -3385,41 +3414,9 @@ int ieee80211_mgd_assoc(struct ieee80211
 
 	ifmgd->assoc_data = assoc_data;
 
-	mutex_lock(&local->mtx);
-	ieee80211_recalc_idle(sdata->local);
-	mutex_unlock(&local->mtx);
-
-	/* switch to the right channel */
-	local->oper_channel = req->bss->channel;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-
-	rcu_read_lock();
-	sta = sta_info_get(sdata, req->bss->bssid);
-	rcu_read_unlock();
-
-	if (!sta) {
-		/* set BSSID */
-		memcpy(ifmgd->bssid, req->bss->bssid, ETH_ALEN);
-		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
-
-		sta = sta_info_alloc(sdata, req->bss->bssid, GFP_KERNEL);
-		if (!sta) {
-			err = -ENOMEM;
-			goto err_clear;
-		}
-
-		sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
-
-		err = sta_info_insert(sta);
-		sta = NULL;
-		if (err) {
-			printk(KERN_DEBUG
-			       "%s: failed to insert STA entry for the AP (error %d)\n",
-			       sdata->name, err);
-			goto err_clear;
-		}
-	} else
-		WARN_ON_ONCE(compare_ether_addr(ifmgd->bssid, req->bss->bssid));
+	err = ieee80211_prep_connection(sdata, req->bss, true);
+	if (err)
+		goto err_clear;
 
 	if (!bss->dtim_period &&
 	    sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {


