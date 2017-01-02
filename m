Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33853 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932325AbdABN2c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 08:28:32 -0500
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 1/3] cfg80211: allow passing struct device in the wiphy_new call
Date: Mon,  2 Jan 2017 14:27:45 +0100
Message-Id: <20170102132747.3491-1-zajec5@gmail.com> (sfid-20170102_142835_927221_3E066E99)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

So far wiphy's device had to be set using separated set_wiphy_dev call.
Most drivers were doing this right after calling wiphy_new anyway so
this just simplifies the code a bit.
The real advantage of this however is having access to struct dev during
early wiphy init. This allows e.g. reading extra DT info thanks to
of_node reference. It's important for things that may happen before
wiphy_register like custom regulatory.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: This is a new patch, wasn't used in V1
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c                  | 7 ++-----
 drivers/net/wireless/ath/ath6kl/cfg80211.h                  | 2 +-
 drivers/net/wireless/ath/ath6kl/core.c                      | 2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c                 | 3 +--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +--
 drivers/net/wireless/intel/ipw2x00/libipw_module.c          | 2 +-
 drivers/net/wireless/intersil/orinoco/cfg.c                 | 2 --
 drivers/net/wireless/intersil/orinoco/main.c                | 2 +-
 drivers/net/wireless/marvell/libertas/cfg.c                 | 3 ++-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c             | 4 +---
 drivers/net/wireless/rndis_wlan.c                           | 5 ++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c           | 9 ++++-----
 drivers/staging/wlan-ng/cfg80211.c                          | 3 +--
 include/net/cfg80211.h                                      | 9 +++++----
 net/mac80211/main.c                                         | 3 ++-
 net/wireless/core.c                                         | 6 ++++--
 16 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b7fe0af..0f9f7e7 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3870,9 +3870,6 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 
 	wiphy->max_remain_on_channel_duration = 5000;
 
-	/* set device pointer for wiphy */
-	set_wiphy_dev(wiphy, ar->dev);
-
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_ADHOC) |
 				 BIT(NL80211_IFTYPE_AP);
@@ -4004,13 +4001,13 @@ void ath6kl_cfg80211_cleanup(struct ath6kl *ar)
 	ar->wiphy_registered = false;
 }
 
-struct ath6kl *ath6kl_cfg80211_create(void)
+struct ath6kl *ath6kl_cfg80211_create(struct device *dev)
 {
 	struct ath6kl *ar;
 	struct wiphy *wiphy;
 
 	/* create a new wiphy for use with cfg80211 */
-	wiphy = wiphy_new(&ath6kl_cfg80211_ops, sizeof(struct ath6kl));
+	wiphy = wiphy_new(dev, &ath6kl_cfg80211_ops, sizeof(struct ath6kl));
 
 	if (!wiphy) {
 		ath6kl_err("couldn't allocate wiphy device\n");
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 5aa57a7..994ba2c 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -60,7 +60,7 @@ void ath6kl_cfg80211_stop_all(struct ath6kl *ar);
 int ath6kl_cfg80211_init(struct ath6kl *ar);
 void ath6kl_cfg80211_cleanup(struct ath6kl *ar);
 
-struct ath6kl *ath6kl_cfg80211_create(void);
+struct ath6kl *ath6kl_cfg80211_create(struct device *dev);
 void ath6kl_cfg80211_destroy(struct ath6kl *ar);
 
 #endif /* ATH6KL_CFG80211_H */
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index ebb9f16..d3f3822 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -267,7 +267,7 @@ struct ath6kl *ath6kl_core_create(struct device *dev)
 	struct ath6kl *ar;
 	u8 ctr;
 
-	ar = ath6kl_cfg80211_create();
+	ar = ath6kl_cfg80211_create(dev);
 	if (!ar)
 		return NULL;
 
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6aa3ff4..ce4d7d4 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1575,14 +1575,13 @@ struct wireless_dev *wil_cfg80211_init(struct device *dev)
 	if (!wdev)
 		return ERR_PTR(-ENOMEM);
 
-	wdev->wiphy = wiphy_new(&wil_cfg80211_ops,
+	wdev->wiphy = wiphy_new(dev, &wil_cfg80211_ops,
 				sizeof(struct wil6210_priv));
 	if (!wdev->wiphy) {
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	set_wiphy_dev(wdev->wiphy, dev);
 	wil_wiphy_init(wdev->wiphy);
 
 	return wdev;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ccae3bb..29cb1e9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6779,13 +6779,12 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_WOWL_GTK))
 		ops->set_rekey_data = brcmf_cfg80211_set_rekey_data;
 #endif
-	wiphy = wiphy_new(ops, sizeof(struct brcmf_cfg80211_info));
+	wiphy = wiphy_new(busdev, ops, sizeof(struct brcmf_cfg80211_info));
 	if (!wiphy) {
 		brcmf_err("Could not allocate wiphy device\n");
 		return NULL;
 	}
 	memcpy(wiphy->perm_addr, drvr->mac, ETH_ALEN);
-	set_wiphy_dev(wiphy, busdev);
 
 	cfg = wiphy_priv(wiphy);
 	cfg->wiphy = wiphy;
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_module.c b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
index 2332075..555ef56 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
@@ -135,7 +135,7 @@ struct net_device *alloc_libipw(int sizeof_priv, int monitor)
 	ieee->dev = dev;
 
 	if (!monitor) {
-		ieee->wdev.wiphy = wiphy_new(&libipw_config_ops, 0);
+		ieee->wdev.wiphy = wiphy_new(NULL, &libipw_config_ops, 0);
 		if (!ieee->wdev.wiphy) {
 			LIBIPW_ERROR("Unable to allocate wiphy.\n");
 			goto failed_free_netdev;
diff --git a/drivers/net/wireless/intersil/orinoco/cfg.c b/drivers/net/wireless/intersil/orinoco/cfg.c
index 7aa4706..5848fd6 100644
--- a/drivers/net/wireless/intersil/orinoco/cfg.c
+++ b/drivers/net/wireless/intersil/orinoco/cfg.c
@@ -26,8 +26,6 @@ void orinoco_wiphy_init(struct wiphy *wiphy)
 	struct orinoco_private *priv = wiphy_priv(wiphy);
 
 	wiphy->privid = orinoco_wiphy_privid;
-
-	set_wiphy_dev(wiphy, priv->dev);
 }
 
 /* Called after firmware is initialised */
diff --git a/drivers/net/wireless/intersil/orinoco/main.c b/drivers/net/wireless/intersil/orinoco/main.c
index 9d96b7c..3465ea6 100644
--- a/drivers/net/wireless/intersil/orinoco/main.c
+++ b/drivers/net/wireless/intersil/orinoco/main.c
@@ -2178,7 +2178,7 @@ struct orinoco_private
 	 * NOTE: We only support a single virtual interface
 	 *       but this may change when monitor mode is added
 	 */
-	wiphy = wiphy_new(&orinoco_cfg_ops,
+	wiphy = wiphy_new(device, &orinoco_cfg_ops,
 			  sizeof(struct orinoco_private) + sizeof_card);
 	if (!wiphy)
 		return NULL;
diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 7ff2efa..f87d279 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -2120,7 +2120,8 @@ struct wireless_dev *lbs_cfg_alloc(struct device *dev)
 	if (!wdev)
 		return ERR_PTR(-ENOMEM);
 
-	wdev->wiphy = wiphy_new(&lbs_cfg80211_ops, sizeof(struct lbs_private));
+	wdev->wiphy = wiphy_new(dev, &lbs_cfg80211_ops,
+				sizeof(struct lbs_private));
 	if (!wdev->wiphy) {
 		dev_err(dev, "cannot allocate wiphy\n");
 		ret = -ENOMEM;
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 1e3bd43..d92a649 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4232,7 +4232,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	u32 thr, retry;
 
 	/* create a new wiphy for use with cfg80211 */
-	wiphy = wiphy_new(&mwifiex_cfg80211_ops,
+	wiphy = wiphy_new(priv->adapter->dev, &mwifiex_cfg80211_ops,
 			  sizeof(struct mwifiex_adapter *));
 	if (!wiphy) {
 		mwifiex_dbg(adapter, ERROR,
@@ -4328,8 +4328,6 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wdev_priv = wiphy_priv(wiphy);
 	*(unsigned long *)wdev_priv = (unsigned long)adapter;
 
-	set_wiphy_dev(wiphy, priv->adapter->dev);
-
 	ret = wiphy_register(wiphy);
 	if (ret < 0) {
 		mwifiex_dbg(adapter, ERROR,
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 603c904..6535f26 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -3408,7 +3408,8 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	 * NOTE: We only support a single virtual interface, so wiphy
 	 * and wireless_dev are somewhat synonymous for this device.
 	 */
-	wiphy = wiphy_new(&rndis_config_ops, sizeof(struct rndis_wlan_private));
+	wiphy = wiphy_new(&usbdev->udev->dev, &rndis_config_ops,
+			  sizeof(struct rndis_wlan_private));
 	if (!wiphy)
 		return -ENOMEM;
 
@@ -3486,8 +3487,6 @@ static int rndis_wlan_bind(struct usbnet *usbdev, struct usb_interface *intf)
 	wiphy->cipher_suites = priv->cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(rndis_cipher_suites);
 
-	set_wiphy_dev(wiphy, &usbdev->udev->dev);
-
 	if (wiphy_register(wiphy)) {
 		retval = -ENODEV;
 		goto fail;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 60d8b05..dd87557 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2243,7 +2243,7 @@ static const struct cfg80211_ops wilc_cfg80211_ops = {
 
 };
 
-static struct wireless_dev *WILC_WFI_CfgAlloc(void)
+static struct wireless_dev *WILC_WFI_CfgAlloc(struct device *dev)
 {
 	struct wireless_dev *wdev;
 
@@ -2251,7 +2251,8 @@ static struct wireless_dev *WILC_WFI_CfgAlloc(void)
 	if (!wdev)
 		goto _fail_;
 
-	wdev->wiphy = wiphy_new(&wilc_cfg80211_ops, sizeof(struct wilc_priv));
+	wdev->wiphy = wiphy_new(dev, &wilc_cfg80211_ops,
+				sizeof(struct wilc_priv));
 	if (!wdev->wiphy)
 		goto _fail_mem_;
 
@@ -2277,7 +2278,7 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	struct wireless_dev *wdev;
 	s32 s32Error = 0;
 
-	wdev = WILC_WFI_CfgAlloc();
+	wdev = WILC_WFI_CfgAlloc(dev);
 	if (!wdev) {
 		netdev_err(net, "wiphy new allocate failed\n");
 		return NULL;
@@ -2302,8 +2303,6 @@ struct wireless_dev *wilc_create_wiphy(struct net_device *net, struct device *de
 	wdev->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	wdev->iftype = NL80211_IFTYPE_STATION;
 
-	set_wiphy_dev(wdev->wiphy, dev);
-
 	s32Error = wiphy_register(wdev->wiphy);
 	if (s32Error)
 		netdev_err(net, "Cannot register wiphy device\n");
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 182b2d5..444b7fc 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -694,7 +694,7 @@ static struct wiphy *wlan_create_wiphy(struct device *dev, struct wlandevice *wl
 	struct wiphy *wiphy;
 	struct prism2_wiphy_private *priv;
 
-	wiphy = wiphy_new(&prism2_usb_cfg_ops, sizeof(*priv));
+	wiphy = wiphy_new(dev, &prism2_usb_cfg_ops, sizeof(*priv));
 	if (!wiphy)
 		return NULL;
 
@@ -710,7 +710,6 @@ static struct wiphy *wlan_create_wiphy(struct device *dev, struct wlandevice *wl
 	priv->band.ht_cap.ht_supported = false;
 	wiphy->bands[NL80211_BAND_2GHZ] = &priv->band;
 
-	set_wiphy_dev(wiphy, dev);
 	wiphy->privid = prism2_wiphy_privid;
 	wiphy->max_scan_ssids = 1;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ca2ac1c..e952cca 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3730,8 +3730,8 @@ static inline const char *wiphy_name(const struct wiphy *wiphy)
  * Return: A pointer to the new wiphy. This pointer must be
  * assigned to each netdev's ieee80211_ptr for proper operation.
  */
-struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
-			   const char *requested_name);
+struct wiphy *wiphy_new_nm(struct device *dev, const struct cfg80211_ops *ops,
+			   int sizeof_priv, const char *requested_name);
 
 /**
  * wiphy_new - create a new wiphy for use with cfg80211
@@ -3745,10 +3745,11 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
  * Return: A pointer to the new wiphy. This pointer must be
  * assigned to each netdev's ieee80211_ptr for proper operation.
  */
-static inline struct wiphy *wiphy_new(const struct cfg80211_ops *ops,
+static inline struct wiphy *wiphy_new(struct device *dev,
+				      const struct cfg80211_ops *ops,
 				      int sizeof_priv)
 {
-	return wiphy_new_nm(ops, sizeof_priv, NULL);
+	return wiphy_new_nm(dev, ops, sizeof_priv, NULL);
 }
 
 /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1822c77..a0f780f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -524,7 +524,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	 */
 	priv_size = ALIGN(sizeof(*local), NETDEV_ALIGN) + priv_data_len;
 
-	wiphy = wiphy_new_nm(&mac80211_config_ops, priv_size, requested_name);
+	wiphy = wiphy_new_nm(NULL, &mac80211_config_ops, priv_size,
+			     requested_name);
 
 	if (!wiphy)
 		return NULL;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 158c59e..398922a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -359,8 +359,8 @@ static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
 
 /* exported functions */
 
-struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
-			   const char *requested_name)
+struct wiphy *wiphy_new_nm(struct device *dev, const struct cfg80211_ops *ops,
+			   int sizeof_priv, const char *requested_name)
 {
 	static atomic_t wiphy_counter = ATOMIC_INIT(0);
 
@@ -404,6 +404,8 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	/* atomic_inc_return makes it start at 1, make it start at 0 */
 	rdev->wiphy_idx--;
 
+	set_wiphy_dev(&rdev->wiphy, dev);
+
 	/* give it a proper name */
 	if (requested_name && requested_name[0]) {
 		int rv;
-- 
2.10.1
