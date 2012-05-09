Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:47788 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756538Ab2EIBc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:32:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 03/18] mwifiex: support for creation of AP interface
Date: Tue,  8 May 2012 18:30:15 -0700
Message-Id: <1336527030-2045-4-git-send-email-bzhao@marvell.com> (sfid-20120509_033301_738192_9E5E072D)
In-Reply-To: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
References: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

1. wiphy structure is per device; hence moved it to mwifiex_adapter
mwifiex_register_cfg80211 takes mwifiex_adapter as parameter.
This function only registers wiphy with cfg80211.
2. Creation of interfaces is moved to cfg80211 add_virtual_interface
handler.
3. Create 2 interfaces by default: station and AP

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |  142 ++++++++++++++++++-------------
 drivers/net/wireless/mwifiex/cfg80211.h |    2 +-
 drivers/net/wireless/mwifiex/main.c     |   18 +++--
 drivers/net/wireless/mwifiex/main.h     |    2 +
 4 files changed, 98 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index c78ea87..38d5191 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1287,6 +1287,7 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	struct mwifiex_adapter *adapter;
 	struct net_device *dev;
 	void *mdev_priv;
+	struct wireless_dev *wdev;
 
 	if (!priv)
 		return NULL;
@@ -1299,12 +1300,21 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	case NL80211_IFTYPE_UNSPECIFIED:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+		priv = adapter->priv[MWIFIEX_BSS_TYPE_STA];
 		if (priv->bss_mode) {
-			wiphy_err(wiphy, "cannot create multiple"
-					" station/adhoc interfaces\n");
+			wiphy_err(wiphy,
+				  "cannot create multiple sta/adhoc ifaces\n");
 			return NULL;
 		}
 
+		wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+		if (!wdev)
+			return NULL;
+
+		wdev->wiphy = wiphy;
+		priv->wdev = wdev;
+		wdev->iftype = NL80211_IFTYPE_STATION;
+
 		if (type == NL80211_IFTYPE_UNSPECIFIED)
 			priv->bss_mode = NL80211_IFTYPE_STATION;
 		else
@@ -1312,11 +1322,36 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
 		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
-		priv->bss_priority = 0;
+		priv->bss_priority = MWIFIEX_BSS_ROLE_STA;
 		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
 		priv->bss_num = 0;
 
 		break;
+	case NL80211_IFTYPE_AP:
+		priv = adapter->priv[MWIFIEX_BSS_TYPE_UAP];
+
+		if (priv->bss_mode) {
+			wiphy_err(wiphy, "Can't create multiple AP interfaces");
+			return NULL;
+		}
+
+		wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+		if (!wdev)
+			return NULL;
+
+		priv->wdev = wdev;
+		wdev->wiphy = wiphy;
+		wdev->iftype = NL80211_IFTYPE_AP;
+
+		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
+		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
+		priv->bss_priority = MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_started = 0;
+		priv->bss_num = 0;
+		priv->bss_mode = type;
+
+		break;
 	default:
 		wiphy_err(wiphy, "type not supported\n");
 		return NULL;
@@ -1329,6 +1364,15 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		goto error;
 	}
 
+	mwifiex_init_priv_params(priv, dev);
+	priv->netdev = dev;
+
+	mwifiex_setup_ht_caps(&wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap, priv);
+
+	if (adapter->config_bands & BAND_A)
+		mwifiex_setup_ht_caps(
+			&wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap, priv);
+
 	dev_net_set(dev, wiphy_net(wiphy));
 	dev->ieee80211_ptr = priv->wdev;
 	dev->ieee80211_ptr->iftype = priv->bss_mode;
@@ -1343,9 +1387,6 @@ struct net_device *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	mdev_priv = netdev_priv(dev);
 	*((unsigned long *) mdev_priv) = (unsigned long) priv;
 
-	priv->netdev = dev;
-	mwifiex_init_priv_params(priv, dev);
-
 	SET_NETDEV_DEV(dev, adapter->dev);
 
 	/* Register network device */
@@ -1436,82 +1477,65 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
  * default parameters and handler function pointers, and finally
  * registers the device.
  */
-int mwifiex_register_cfg80211(struct mwifiex_private *priv)
+
+int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 {
 	int ret;
 	void *wdev_priv;
-	struct wireless_dev *wdev;
-	struct ieee80211_sta_ht_cap *ht_info;
+	struct wiphy *wiphy;
+	struct mwifiex_private *priv = adapter->priv[MWIFIEX_BSS_TYPE_STA];
 	u8 *country_code;
 
-	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
-	if (!wdev) {
-		dev_err(priv->adapter->dev, "%s: allocating wireless device\n",
-			__func__);
+	/* create a new wiphy for use with cfg80211 */
+	wiphy = wiphy_new(&mwifiex_cfg80211_ops,
+			  sizeof(struct mwifiex_adapter *));
+	if (!wiphy) {
+		dev_err(adapter->dev, "%s: creating new wiphy\n", __func__);
 		return -ENOMEM;
 	}
-	wdev->wiphy =
-		wiphy_new(&mwifiex_cfg80211_ops,
-			  sizeof(struct mwifiex_private *));
-	if (!wdev->wiphy) {
-		kfree(wdev);
-		return -ENOMEM;
-	}
-	wdev->iftype = NL80211_IFTYPE_STATION;
-	wdev->wiphy->max_scan_ssids = 10;
-	wdev->wiphy->max_scan_ie_len = MWIFIEX_MAX_VSIE_LEN;
-	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				       BIT(NL80211_IFTYPE_ADHOC);
-
-	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &mwifiex_band_2ghz;
-	ht_info = &wdev->wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap;
-	mwifiex_setup_ht_caps(ht_info, priv);
-
-	if (priv->adapter->config_bands & BAND_A) {
-		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &mwifiex_band_5ghz;
-		ht_info = &wdev->wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap;
-		mwifiex_setup_ht_caps(ht_info, priv);
-	} else {
-		wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
-	}
+	wiphy->max_scan_ssids = MWIFIEX_MAX_SSID_LIST_LENGTH;
+	wiphy->max_scan_ie_len = MWIFIEX_MAX_VSIE_LEN;
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_ADHOC) |
+				 BIT(NL80211_IFTYPE_AP);
+
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &mwifiex_band_2ghz;
+	if (adapter->config_bands & BAND_A)
+		wiphy->bands[IEEE80211_BAND_5GHZ] = &mwifiex_band_5ghz;
+	else
+		wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
 	/* Initialize cipher suits */
-	wdev->wiphy->cipher_suites = mwifiex_cipher_suites;
-	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
+	wiphy->cipher_suites = mwifiex_cipher_suites;
+	wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
 
-	memcpy(wdev->wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
-	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	memcpy(wiphy->perm_addr, priv->curr_addr, ETH_ALEN);
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME | WIPHY_FLAG_CUSTOM_REGULATORY;
 
 	/* Reserve space for mwifiex specific private data for BSS */
-	wdev->wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
+	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
 
-	wdev->wiphy->reg_notifier = mwifiex_reg_notifier;
+	wiphy->reg_notifier = mwifiex_reg_notifier;
 
 	/* Set struct mwifiex_private pointer in wiphy_priv */
-	wdev_priv = wiphy_priv(wdev->wiphy);
+	wdev_priv = wiphy_priv(wiphy);
 
 	*(unsigned long *) wdev_priv = (unsigned long) priv;
 
-	set_wiphy_dev(wdev->wiphy, (struct device *) priv->adapter->dev);
+	set_wiphy_dev(wiphy, (struct device *)priv->adapter->dev);
 
-	ret = wiphy_register(wdev->wiphy);
+	ret = wiphy_register(wiphy);
 	if (ret < 0) {
-		dev_err(priv->adapter->dev, "%s: registering cfg80211 device\n",
-			__func__);
-		wiphy_free(wdev->wiphy);
-		kfree(wdev);
+		dev_err(adapter->dev,
+			"%s: wiphy_register failed: %d\n", __func__, ret);
+		wiphy_free(wiphy);
 		return ret;
-	} else {
-		dev_dbg(priv->adapter->dev,
-			"info: successfully registered wiphy device\n");
 	}
-
 	country_code = mwifiex_11d_code_2_region(priv->adapter->region_code);
-	if (country_code && regulatory_hint(wdev->wiphy, country_code))
-		dev_err(priv->adapter->dev,
-			"%s: regulatory_hint failed\n", __func__);
-
-	priv->wdev = wdev;
+	if (country_code && regulatory_hint(wiphy, country_code))
+		dev_err(adapter->dev, "regulatory_hint() failed\n");
 
+	adapter->wiphy = wiphy;
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/cfg80211.h b/drivers/net/wireless/mwifiex/cfg80211.h
index 76c76c6..c584893 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.h
+++ b/drivers/net/wireless/mwifiex/cfg80211.h
@@ -24,6 +24,6 @@
 
 #include "main.h"
 
-int mwifiex_register_cfg80211(struct mwifiex_private *);
+int mwifiex_register_cfg80211(struct mwifiex_adapter *);
 
 #endif
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 5ac0059..43e4efa 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -349,19 +349,26 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	if (adapter->hw_status != MWIFIEX_HW_STATUS_READY)
 		goto done;
 
-	priv = adapter->priv[0];
-	if (mwifiex_register_cfg80211(priv) != 0) {
+	priv = adapter->priv[MWIFIEX_BSS_ROLE_STA];
+	if (mwifiex_register_cfg80211(adapter)) {
 		dev_err(adapter->dev, "cannot register with cfg80211\n");
 		goto err_init_fw;
 	}
 
 	rtnl_lock();
 	/* Create station interface by default */
-	if (!mwifiex_add_virtual_intf(priv->wdev->wiphy, "mlan%d",
+	if (!mwifiex_add_virtual_intf(adapter->wiphy, "mlan%d",
 				      NL80211_IFTYPE_STATION, NULL, NULL)) {
 		dev_err(adapter->dev, "cannot create default STA interface\n");
 		goto err_add_intf;
 	}
+
+	/* Create AP interface by default */
+	if (!mwifiex_add_virtual_intf(adapter->wiphy, "uap%d",
+				      NL80211_IFTYPE_AP, NULL, NULL)) {
+		dev_err(adapter->dev, "cannot create default AP interface\n");
+		goto err_add_intf;
+	}
 	rtnl_unlock();
 
 	mwifiex_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
@@ -369,7 +376,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	goto done;
 
 err_add_intf:
-	mwifiex_del_virtual_intf(priv->wdev->wiphy, priv->netdev);
+	mwifiex_del_virtual_intf(adapter->wiphy, priv->netdev);
 	rtnl_unlock();
 err_init_fw:
 	pr_debug("info: %s: unregister device\n", __func__);
@@ -830,8 +837,7 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 
 		rtnl_lock();
 		if (priv->wdev && priv->netdev)
-			mwifiex_del_virtual_intf(priv->wdev->wiphy,
-						 priv->netdev);
+			mwifiex_del_virtual_intf(adapter->wiphy, priv->netdev);
 		rtnl_unlock();
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 324ad39..9fc2242 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -370,6 +370,7 @@ struct mwifiex_private {
 	u8 bss_role;
 	u8 bss_priority;
 	u8 bss_num;
+	u8 bss_started;
 	u8 frame_type;
 	u8 curr_addr[ETH_ALEN];
 	u8 media_connected;
@@ -571,6 +572,7 @@ struct mwifiex_adapter {
 	char fw_name[32];
 	int winner;
 	struct device *dev;
+	struct wiphy *wiphy;
 	bool surprise_removed;
 	u32 fw_release_number;
 	u16 init_wait_q_woken;
-- 
1.7.0.2

