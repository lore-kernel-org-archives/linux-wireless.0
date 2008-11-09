Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38838 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbYKIPoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 10:44:19 -0500
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mA9FiBPI029197
	for <linux-wireless@vger.kernel.org>; Sun, 9 Nov 2008 09:44:17 -0600
Received: from localhost.localdomain (essapo-nirac252197.europe.nokia.com [10.162.252.197])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mA9Fi1i6014022
	for <linux-wireless@vger.kernel.org>; Sun, 9 Nov 2008 17:44:06 +0200
From: Kalle Valo <kalle.valo@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: enable IEEE80211_CONF_PS only when associated
Date: Sun,  9 Nov 2008 17:43:58 +0200
Message-Id: <1226245439-30329-2-git-send-email-kalle.valo@nokia.com> (sfid-20081109_164422_067827_8A0241DA)
In-Reply-To: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also disable power save when disassociated.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   15 +++++++++++++--
 net/mac80211/wext.c        |   30 ++++++++++++++++++++++++------
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 155a204..3f25955 100644
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
index 12064fb..5a48b2b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -747,6 +747,11 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	bss_info_changed |= BSS_CHANGED_BASIC_RATES;
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
+	if (local->powersave) {
+		local->hw.conf.flags |= IEEE80211_CONF_PS;
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
+	}
+
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
 
@@ -815,7 +820,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
-	u32 changed = 0;
+	u32 changed = 0, config_changed = 0;
 
 	rcu_read_lock();
 
@@ -865,8 +870,14 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sta_info_destroy(sta);
 
 	local->hw.conf.ht.enabled = false;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_HT);
+	config_changed |= IEEE80211_CONF_CHANGE_HT;
+
+	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
+		local->hw.conf.flags &= ~IEEE80211_CONF_PS;
+		config_changed |= IEEE80211_CONF_PS;
+	}
 
+	ieee80211_hw_config(local, config_changed);
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 63f36e9..febcd41 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -945,25 +945,44 @@ static int ieee80211_ioctl_siwpower(struct net_device *dev,
 				    struct iw_param *wrq,
 				    char *extra)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
 	struct ieee80211_conf *conf = &local->hw.conf;
+	int ret = 0;
+	bool ps;
 
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
+	if (ifsta->flags && IEEE80211_STA_ASSOCIATED) {
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
@@ -972,9 +991,8 @@ static int ieee80211_ioctl_giwpower(struct net_device *dev,
 				    char *extra)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_conf *conf = &local->hw.conf;
 
-	wrqu->power.disabled = !(conf->flags & IEEE80211_CONF_PS);
+	wrqu->power.disabled = !local->powersave;
 
 	return 0;
 }
-- 
1.5.6.5

