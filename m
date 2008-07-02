Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbYGBW1d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 18:27:33 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: call bss_info_change only once upon disassociation
Date: Thu,  3 Jul 2008 01:27:13 +0300
Message-Id: <1215037633-27975-1-git-send-email-tomas.winkler@intel.com> (sfid-20080703_002736_953079_F3321A2C)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes call of ieee80211_bss_info_change_notify from within
ieee80211_reset_erp_info. This allows gathering all bss info changes
into one call to the driver in the disassociation flow.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/main.c        |   12 ++++++------
 net/mac80211/mlme.c        |    2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 775d5e8..c916c2f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -892,7 +892,7 @@ int ieee80211_sta_deauthenticate(struct net_device *dev, u16 reason);
 int ieee80211_sta_disassociate(struct net_device *dev, u16 reason);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
-void ieee80211_reset_erp_info(struct net_device *dev);
+u32 ieee80211_reset_erp_info(struct net_device *dev);
 int ieee80211_ht_cap_ie_to_ht_info(struct ieee80211_ht_cap *ht_cap_ie,
 				   struct ieee80211_ht_info *ht_info);
 int ieee80211_ht_addt_info_ie_to_ht_bss_info(
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 074f71a..cc756e9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -182,10 +182,11 @@ static int ieee80211_open(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata, *nsdata;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sta_info *sta;
 	struct ieee80211_if_init_conf conf;
+	u32 changed = 0;
 	int res;
 	bool need_hw_reconfig = 0;
-	struct sta_info *sta;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -329,7 +330,8 @@ static int ieee80211_open(struct net_device *dev)
 			goto err_stop;
 
 		ieee80211_if_config(dev);
-		ieee80211_reset_erp_info(dev);
+		changed |= ieee80211_reset_erp_info(dev);
+		ieee80211_bss_info_change_notify(sdata, changed);
 		ieee80211_enable_keys(sdata);
 
 		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
@@ -1190,15 +1192,13 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 					     changed);
 }
 
-void ieee80211_reset_erp_info(struct net_device *dev)
+u32 ieee80211_reset_erp_info(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	sdata->bss_conf.use_cts_prot = 0;
 	sdata->bss_conf.use_short_preamble = 0;
-	ieee80211_bss_info_change_notify(sdata,
-					 BSS_CHANGED_ERP_CTS_PROT |
-					 BSS_CHANGED_ERP_PREAMBLE);
+	return BSS_CHANGED_ERP_CTS_PROT | BSS_CHANGED_ERP_PREAMBLE;
 }
 
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2a92708..37ea04f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -573,7 +573,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 		ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid);
 		ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
 		netif_carrier_off(dev);
-		ieee80211_reset_erp_info(dev);
+		changed |= ieee80211_reset_erp_info(dev);
 
 		sdata->bss_conf.assoc_ht = 0;
 		sdata->bss_conf.ht_conf = NULL;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

