Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41128 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbcBZVOp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 16:14:45 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: remove wdev/vif conversion functions
Date: Fri, 26 Feb 2016 22:14:42 +0100
Message-Id: <1456521282-69932-1-git-send-email-nbd@openwrt.org> (sfid-20160226_221502_348665_87B4AFC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nothing uses them

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 26 --------------------------
 net/mac80211/util.c    | 28 ----------------------------
 2 files changed, 54 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0c09da3..e11d751 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1439,32 +1439,6 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
 }
 
 /**
- * wdev_to_ieee80211_vif - return a vif struct from a wdev
- * @wdev: the wdev to get the vif for
- *
- * This can be used by mac80211 drivers with direct cfg80211 APIs
- * (like the vendor commands) that get a wdev.
- *
- * Note that this function may return %NULL if the given wdev isn't
- * associated with a vif that the driver knows about (e.g. monitor
- * or AP_VLAN interfaces.)
- */
-struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
-
-/**
- * ieee80211_vif_to_wdev - return a wdev struct from a vif
- * @vif: the vif to get the wdev for
- *
- * This can be used by mac80211 drivers with direct cfg80211 APIs
- * (like the vendor commands) that needs to get the wdev for a vif.
- *
- * Note that this function may return %NULL if the given wdev isn't
- * associated with a vif that the driver knows about (e.g. monitor
- * or AP_VLAN interfaces.)
- */
-struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif);
-
-/**
  * enum ieee80211_key_flags - key flags
  *
  * These flags are used for communication about keys between the driver
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89f7179..4482625 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -694,34 +694,6 @@ void ieee80211_iterate_stations_atomic(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_stations_atomic);
 
-struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-
-	if (!ieee80211_sdata_running(sdata) ||
-	    !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
-		return NULL;
-	return &sdata->vif;
-}
-EXPORT_SYMBOL_GPL(wdev_to_ieee80211_vif);
-
-struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	if (!vif)
-		return NULL;
-
-	sdata = vif_to_sdata(vif);
-
-	if (!ieee80211_sdata_running(sdata) ||
-	    !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
-		return NULL;
-
-	return &sdata->wdev;
-}
-EXPORT_SYMBOL_GPL(ieee80211_vif_to_wdev);
-
 /*
  * Nothing should have been stuffed into the workqueue during
  * the suspend->resume cycle. Since we can't check each caller
-- 
2.2.2

