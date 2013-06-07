Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:25241 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab3FGNgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 09:36:24 -0400
Received: from 89-71-197-70.dynamic.chello.pl (HELO localhost.localdomain) (moorray3@[89.71.197.70])
          (envelope-sender <moorray3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-wireless@vger.kernel.org>; 7 Jun 2013 15:36:22 +0200
From: Jakub Kicinski <moorray3@wp.pl>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	nietrywialneprzejscie@gmail.com
Subject: [RFC 5/5] mac80211: assign right mac addr to active monitors
Date: Fri,  7 Jun 2013 15:36:19 +0200
Message-Id: <1370612179-24385-6-git-send-email-moorray3@wp.pl> (sfid-20130607_153633_825161_2B71265B)
In-Reply-To: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
References: <1370612179-24385-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Active monitors should have a valid mac
address as they are supposed to be able
to ack incoming frames.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 net/mac80211/cfg.c         |  2 +-
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/iface.c       | 12 +++++++-----
 net/mac80211/main.c        |  2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3062210..123b35f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -31,7 +31,7 @@ static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
 	struct ieee80211_sub_if_data *sdata;
 	int err;
 
-	err = ieee80211_if_add(local, name, &wdev, type, params);
+	err = ieee80211_if_add(local, name, &wdev, type, flags, params);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 923e177..a2fa214 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1345,7 +1345,7 @@ int ieee80211_iface_init(void);
 void ieee80211_iface_exit(void);
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
-		     struct vif_params *params);
+		     u32 *flags, struct vif_params *params);
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 96bfafa..16fc8283 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1493,7 +1493,8 @@ static void __ieee80211_assign_perm_addr(struct ieee80211_local *local,
 }
 
 static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
-				       u8 *perm_addr, enum nl80211_iftype type)
+				       u8 *perm_addr, enum nl80211_iftype type,
+				       u32 *flags)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -1517,7 +1518,8 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
-		/* doesn't matter */
+		if (flags && (*flags & MONITOR_FLAG_ACTIVE))
+			__ieee80211_assign_perm_addr(local, perm_addr);
 		break;
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_AP_VLAN:
@@ -1563,7 +1565,7 @@ static void ieee80211_cleanup_sdata_stas_wk(struct work_struct *wk)
 
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
-		     struct vif_params *params)
+		     u32 *flags, struct vif_params *params)
 {
 	struct net_device *ndev = NULL;
 	struct ieee80211_sub_if_data *sdata = NULL;
@@ -1583,7 +1585,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		sdata->dev = NULL;
 		strlcpy(sdata->name, name, IFNAMSIZ);
-		ieee80211_assign_perm_addr(local, wdev->address, type);
+		ieee80211_assign_perm_addr(local, wdev->address, type, flags);
 		memcpy(sdata->vif.addr, wdev->address, ETH_ALEN);
 	} else {
 		if (local->hw.queues >= IEEE80211_NUM_ACS)
@@ -1611,7 +1613,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			return ret;
 		}
 
-		ieee80211_assign_perm_addr(local, ndev->perm_addr, type);
+		ieee80211_assign_perm_addr(local, ndev->perm_addr, type, flags);
 		memcpy(ndev->dev_addr, ndev->perm_addr, ETH_ALEN);
 		SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1998f14..edaca0f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -968,7 +968,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION)) {
 		result = ieee80211_if_add(local, "wlan%d", NULL,
-					  NL80211_IFTYPE_STATION, NULL);
+					  NL80211_IFTYPE_STATION, NULL, NULL);
 		if (result)
 			wiphy_warn(local->hw.wiphy,
 				   "Failed to add default virtual iface\n");
-- 
1.8.1.4

