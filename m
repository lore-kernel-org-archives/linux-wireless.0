Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35712 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937AbXHXMbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:31:37 -0400
Message-Id: <20070824122909.224636000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/15] mac80211: support adding/removing keys via cfg80211
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the necessary hooks to mac80211 to make use of
the key add/remove functionality nl80211/cfg80211 offer.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/cfg.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

--- wireless-dev.orig/net/mac80211/cfg.c	2007-08-24 14:16:15.669417211 +0200
+++ wireless-dev/net/mac80211/cfg.c	2007-08-24 14:16:41.539417211 +0200
@@ -6,6 +6,7 @@
  * This file is GPLv2 as found in COPYING.
  */
 
+#include <linux/ieee80211.h>
 #include <linux/nl80211.h>
 #include <linux/rtnetlink.h>
 #include <net/cfg80211.h>
@@ -66,7 +67,86 @@ static int ieee80211_del_iface(struct wi
 	return ieee80211_if_remove(local->mdev, name, -1);
 }
 
+static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
+			     struct key_params *params)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta = NULL;
+	enum ieee80211_key_alg alg;
+	int ret;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	switch (params->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		alg = ALG_WEP;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		alg = ALG_TKIP;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		alg = ALG_CCMP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (params->macaddress) {
+		sta = sta_info_get(sdata->local, params->macaddress);
+		if (!sta)
+			return -EINVAL;
+
+		ieee80211_key_free(sta->key);
+	} else
+		ieee80211_key_free(sdata->keys[params->key_idx]);
+
+	ret = 0;
+	if (!ieee80211_key_alloc(sdata, sta, alg, params->key_idx,
+				 params->key_len, params->key))
+		ret = -ENOMEM;
+
+	if (sta)
+		sta_info_put(sta);
+
+	return ret;
+}
+
+static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
+			     struct key_params *params)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	int ret;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (params->macaddress) {
+		sta = sta_info_get(sdata->local, params->macaddress);
+		if (!sta)
+			return -EINVAL;
+
+		ret = 0;
+		if (sta->key)
+			ieee80211_key_free(sta->key);
+		else
+			ret = -ENOENT;
+
+		sta_info_put(sta);
+		return ret;
+	}
+
+	if (!sdata->keys[params->key_idx])
+		return -ENOENT;
+
+	ieee80211_key_free(sdata->keys[params->key_idx]);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
+	.add_key = ieee80211_add_key,
+	.del_key = ieee80211_del_key,
 };

-- 

