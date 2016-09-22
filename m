Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45398 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932181AbcIVURC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 16:17:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 22 Sep 2016 23:16:50 +0300
Message-Id: <20160922201650.16722-1-luca@coelho.fi> (sfid-20160922_221707_009872_C1BD9B08)
Subject: [PATCH] cfg80211: Add support for static WEP in the driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Add support for drivers that implement static WEP internally, i.e.
expose connection keys to the driver in connect flow and don't
upload the keys after the connection.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h     | 12 +++++++++++-
 net/wireless/core.h        |  4 ++--
 net/wireless/ibss.c        |  5 +++--
 net/wireless/sme.c         |  6 +++++-
 net/wireless/util.c        |  2 +-
 net/wireless/wext-compat.c |  2 +-
 net/wireless/wext-sme.c    |  2 +-
 7 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bd26cc6..562d00a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5,7 +5,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014 Intel Mobile Communications GmbH
- * Copyright 2015	Intel Deutschland GmbH
+ * Copyright 2015-2016	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -593,6 +593,8 @@ struct survey_info {
 	s8 noise;
 };
 
+#define CFG80211_MAX_WEP_KEYS	4
+
 /**
  * struct cfg80211_crypto_settings - Crypto settings
  * @wpa_versions: indicates which, if any, WPA versions are enabled
@@ -610,6 +612,9 @@ struct survey_info {
  *	allowed through even on unauthorized ports
  * @control_port_no_encrypt: TRUE to prevent encryption of control port
  *	protocol frames.
+ * @wep_keys: static WEP keys, if not NULL points to an array of
+ *	CFG80211_MAX_WEP_KEYS WEP keys
+ * @wep_tx_key: key index (0..3) of the default TX static WEP key
  */
 struct cfg80211_crypto_settings {
 	u32 wpa_versions;
@@ -621,6 +626,8 @@ struct cfg80211_crypto_settings {
 	bool control_port;
 	__be16 control_port_ethertype;
 	bool control_port_no_encrypt;
+	struct key_params *wep_keys;
+	int wep_tx_key;
 };
 
 /**
@@ -2900,6 +2907,8 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
  * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
  *	beaconing mode (AP, IBSS, Mesh, ...).
+ * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key installation
+ *	before connection.
  */
 enum wiphy_flags {
 	/* use hole at 0 */
@@ -2925,6 +2934,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
+	WIPHY_FLAG_HAS_STATIC_WEP		= BIT(24),
 };
 
 /**
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5555e3c..554f87d 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -249,8 +249,8 @@ struct cfg80211_event {
 };
 
 struct cfg80211_cached_keys {
-	struct key_params params[4];
-	u8 data[4][WLAN_KEY_LEN_WEP104];
+	struct key_params params[CFG80211_MAX_WEP_KEYS];
+	u8 data[CFG80211_MAX_WEP_KEYS][WLAN_KEY_LEN_WEP104];
 	int def;
 };
 
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index eafdfa5..364f900 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -43,7 +43,8 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 	cfg80211_hold_bss(bss_from_pub(bss));
 	wdev->current_bss = bss_from_pub(bss);
 
-	cfg80211_upload_connect_keys(wdev);
+	if (!(wdev->wiphy->flags & WIPHY_FLAG_HAS_STATIC_WEP))
+		cfg80211_upload_connect_keys(wdev);
 
 	nl80211_send_ibss_bssid(wiphy_to_rdev(wdev->wiphy), dev, bssid,
 				GFP_KERNEL);
@@ -296,7 +297,7 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 		ck = kmemdup(wdev->wext.keys, sizeof(*ck), GFP_KERNEL);
 		if (!ck)
 			return -ENOMEM;
-		for (i = 0; i < 4; i++)
+		for (i = 0; i < CFG80211_MAX_WEP_KEYS; i++)
 			ck->params[i].key = ck->data[i];
 	}
 	err = __cfg80211_join_ibss(rdev, wdev->netdev,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c08a3b5..a77db33 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -726,7 +726,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 
 	wdev->current_bss = bss_from_pub(bss);
 
-	cfg80211_upload_connect_keys(wdev);
+	if (!(wdev->wiphy->flags & WIPHY_FLAG_HAS_STATIC_WEP))
+		cfg80211_upload_connect_keys(wdev);
 
 	rcu_read_lock();
 	country_ie = ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
@@ -1043,6 +1044,9 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 				connect->crypto.ciphers_pairwise[0] = cipher;
 			}
 		}
+
+		connect->crypto.wep_keys = connkeys->params;
+		connect->crypto.wep_tx_key = connkeys->def;
 	} else {
 		if (WARN_ON(connkeys))
 			return -EINVAL;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9e6e2aa..e02141d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -912,7 +912,7 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 	if (!wdev->connect_keys)
 		return;
 
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < CFG80211_MAX_WEP_KEYS; i++) {
 		if (!wdev->connect_keys->params[i].cipher)
 			continue;
 		if (rdev_add_key(rdev, dev, i, false, NULL,
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 7b97d43..f381156 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -411,7 +411,7 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 					  GFP_KERNEL);
 		if (!wdev->wext.keys)
 			return -ENOMEM;
-		for (i = 0; i < 4; i++)
+		for (i = 0; i < CFG80211_MAX_WEP_KEYS; i++)
 			wdev->wext.keys->params[i].key =
 				wdev->wext.keys->data[i];
 	}
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 88f1f69..9951638 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -46,7 +46,7 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 		ck = kmemdup(wdev->wext.keys, sizeof(*ck), GFP_KERNEL);
 		if (!ck)
 			return -ENOMEM;
-		for (i = 0; i < 4; i++)
+		for (i = 0; i < CFG80211_MAX_WEP_KEYS; i++)
 			ck->params[i].key = ck->data[i];
 	}
 
-- 
2.9.3
