Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbXLSPsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:48:10 -0500
Message-Id: <20071219010339.661616000@sipsolutions.net> (sfid-20071219_154814_073085_08E82DCF)
References: <20071219010328.762470000@sipsolutions.net>
Date: Wed, 19 Dec 2007 02:03:30 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/9] mac80211: support adding/removing keys via cfg80211
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the necessary hooks to mac80211 to allow userspace
to edit keys with cfg80211 (through nl80211.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

--- everything.orig/net/mac80211/cfg.c	2007-12-19 00:50:13.963022840 +0100
+++ everything/net/mac80211/cfg.c	2007-12-19 00:50:16.293022569 +0100
@@ -6,6 +6,7 @@
  * This file is GPLv2 as found in COPYING.
  */
 
+#include <linux/ieee80211.h>
 #include <linux/nl80211.h>
 #include <linux/rtnetlink.h>
 #include <net/net_namespace.h>
@@ -99,8 +100,98 @@ static int ieee80211_change_iface(struct
 	return 0;
 }
 
+static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
+			     u8 key_idx, u8 *mac_addr,
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
+	if (mac_addr) {
+		sta = sta_info_get(sdata->local, mac_addr);
+		if (!sta)
+			return -ENOENT;
+	}
+
+	ret = 0;
+	if (!ieee80211_key_alloc(sdata, sta, alg, key_idx,
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
+			     u8 key_idx, u8 *mac_addr)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct sta_info *sta;
+	int ret;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (mac_addr) {
+		sta = sta_info_get(sdata->local, mac_addr);
+		if (!sta)
+			return -ENOENT;
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
+	if (!sdata->keys[key_idx])
+		return -ENOENT;
+
+	ieee80211_key_free(sdata->keys[key_idx]);
+
+	return 0;
+}
+
+static int ieee80211_config_default_key(struct wiphy *wiphy,
+					struct net_device *dev,
+					u8 key_idx)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ieee80211_set_default_key(sdata, key_idx);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
 	.change_virtual_intf = ieee80211_change_iface,
+	.add_key = ieee80211_add_key,
+	.del_key = ieee80211_del_key,
+	.set_default_key = ieee80211_config_default_key,
 };

-- 

