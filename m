Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:40343 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYLRVgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:36:52 -0500
Received: from esebh107.NOE.Nokia.com (esebh107.ntc.nokia.com [172.21.143.143])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mBILabQB014382
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 15:36:50 -0600
Received: from [127.0.1.1] (essapo-nirac25252.europe.nokia.com [10.162.252.52])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mBILZDFD022624
	for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 23:35:14 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH v6 1/3] mac80211: enable IEEE80211_CONF_PS only when associated
To: linux-wireless@vger.kernel.org
Date: Thu, 18 Dec 2008 23:35:13 +0200
Message-ID: <20081218213513.7248.46810.stgit@tikku> (sfid-20081218_223716_579746_CAC3BCF5)
In-Reply-To: <20081218213306.7248.64398.stgit@tikku>
References: <20081218213306.7248.64398.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also disable power save when disassociated. It makes no sense to have
power save enabled while disassociated.

iwlwifi seems to have this check in the driver, but it's better to do this
in mac80211 instead.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   15 +++++++++++++--
 net/mac80211/wext.c        |   32 ++++++++++++++++++++++++++------
 3 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a7dabae..18b9160 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -688,6 +688,7 @@ struct ieee80211_local {
 				*/
 	int wifi_wme_noack_test;
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
+	bool powersave;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9a06905..2c5f2ac 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -746,6 +746,11 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
+	if (local->powersave) {
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
 
@@ -818,7 +823,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	u32 changed = 0;
+	u32 changed = 0, config_changed = 0;
 
 	rcu_read_lock();
 
@@ -865,8 +870,14 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	local->hw.conf.ht.enabled = false;
 	local->oper_channel_type = NL80211_CHAN_NO_HT;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
+	config_changed |= IEEE80211_CONF_CHANGE_HT;
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+		config_changed |= IEEE80211_CONF_CHANGE_PS;
+	}
 
+	ieee80211_hw_config(local, config_changed);
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	rcu_read_lock();
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 1542804..f6640d0 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -830,25 +830,46 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 				    struct iw_param *wrq,
 				    char *extra)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
+	int ret = 0;
+	bool ps;
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EINVAL;
 
 	if (wrq->disabled) {
-		conf->flags &= ~IEEE80211_CONF_PS;
-		return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+		ps = false;
+		goto set;
 	}
 
 	switch (wrq->flags & IW_POWER_MODE) {
 	case IW_POWER_ON:       /* If not specified */
 	case IW_POWER_MODE:     /* If set all mask */
 	case IW_POWER_ALL_R:    /* If explicitely state all */
-		conf->flags |= IEEE80211_CONF_PS;
+		ps = true;
 		break;
 	default:                /* Otherwise we don't support it */
 		return -EINVAL;
 	}
 
-	return ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	if (ps == local->powersave)
+		return ret;
+
+set:
+	local->powersave = ps;
+
+	if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+		if (local->powersave)
+			conf->flags |= IEEE80211_CONF_PS;
+		else
+			conf->flags &= ~IEEE80211_CONF_PS;
+
+		ret = ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+
+	return ret;
 }
 
 static int ieee80211_ioctl_giwpower(struct net_device *dev,
@@ -857,9 +878,8 @@ static int ieee80211_ioctl_giwpower(struct net_device *dev,
 				    char *extra)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_conf *conf = &local->hw.conf;
 
-	wrqu->power.disabled = !(conf->flags & IEEE80211_CONF_PS);
+	wrqu->power.disabled = !local->powersave;
 
 	return 0;
 }

