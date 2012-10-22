Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4481 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2JVUzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:53 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/12] brcmfmac: introduce brcmf_cfg80211_vif structure
Date: Mon, 22 Oct 2012 13:55:30 -0700
Message-ID: <1350939341-17687-2-git-send-email-frankyl@broadcom.com> (sfid-20121022_225558_190334_4F622111)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

This patch introduces the brcmf_cfg80211_vif structure which is
used to keep track of multiple virtual interfaces in the driver.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    5 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  147 ++++++++++++--------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   39 +++++-
 3 files changed, 129 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index bde5e25..8704daa 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -682,10 +682,14 @@ struct brcmf_if_event {
 	u8 bssidx;
 };
 
+/* forward declaration */
+struct brcmf_cfg80211_vif;
+
 /**
  * struct brcmf_if - interface control information.
  *
  * @drvr: points to device related information.
+ * @vif: points to cfg80211 specific interface information.
  * @ndev: associated network device.
  * @stats: interface specific network statistics.
  * @idx: interface index in device firmware.
@@ -694,6 +698,7 @@ struct brcmf_if_event {
  */
 struct brcmf_if {
 	struct brcmf_pub *drvr;
+	struct brcmf_cfg80211_vif *vif;
 	struct net_device *ndev;
 	struct net_device_stats stats;
 	int idx;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 069a4e4..21d6ab3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -49,6 +49,8 @@
 #define BRCMF_PNO_SCAN_COMPLETE		1
 #define BRCMF_PNO_SCAN_INCOMPLETE	0
 
+#define BRCMF_IFACE_MAX_CNT		2
+
 #define TLV_LEN_OFF			1	/* length offset */
 #define TLV_HDR_LEN			2	/* header length */
 #define TLV_BODY_OFF			2	/* body offset */
@@ -3441,7 +3443,7 @@ static int brcmf_cfg80211_sched_scan_stop(struct wiphy *wiphy,
 static int brcmf_cfg80211_testmode(struct wiphy *wiphy, void *data, int len)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	struct net_device *ndev = cfg->wdev->netdev;
+	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_dcmd *dcmd = data;
 	struct sk_buff *reply;
 	int ret;
@@ -4194,72 +4196,95 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 #endif
 }
 
-static struct wireless_dev *brcmf_alloc_wdev(struct device *ndev)
+static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 {
-	struct wireless_dev *wdev;
+	struct wiphy *wiphy;
 	s32 err = 0;
 
-	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
-	if (!wdev)
-		return ERR_PTR(-ENOMEM);
-
-	wdev->wiphy = wiphy_new(&wl_cfg80211_ops,
-				sizeof(struct brcmf_cfg80211_info));
-	if (!wdev->wiphy) {
+	wiphy = wiphy_new(&wl_cfg80211_ops, sizeof(struct brcmf_cfg80211_info));
+	if (!wiphy) {
 		WL_ERR("Could not allocate wiphy device\n");
-		err = -ENOMEM;
-		goto wiphy_new_out;
-	}
-	set_wiphy_dev(wdev->wiphy, ndev);
-	wdev->wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
-	wdev->wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
-	wdev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-				       BIT(NL80211_IFTYPE_ADHOC) |
-				       BIT(NL80211_IFTYPE_AP);
-	wdev->wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
-	wdev->wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_a;	/* Set
+		return ERR_PTR(-ENOMEM);
+	}
+	set_wiphy_dev(wiphy, phydev);
+	wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
+	wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_ADHOC) |
+				 BIT(NL80211_IFTYPE_AP);
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
+	wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_a;	/* Set
 						* it as 11a by default.
 						* This will be updated with
 						* 11n phy tables in
 						* "ifconfig up"
 						* if phy has 11n capability
 						*/
-	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
-	wdev->wiphy->cipher_suites = __wl_cipher_suites;
-	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
-	wdev->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;	/* enable power
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->cipher_suites = __wl_cipher_suites;
+	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
+	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;	/* enable power
 								 * save mode
 								 * by default
 								 */
-	brcmf_wiphy_pno_params(wdev->wiphy);
-	err = wiphy_register(wdev->wiphy);
+	brcmf_wiphy_pno_params(wiphy);
+	err = wiphy_register(wiphy);
 	if (err < 0) {
 		WL_ERR("Could not register wiphy device (%d)\n", err);
-		goto wiphy_register_out;
+		wiphy_free(wiphy);
+		return ERR_PTR(err);
 	}
-	return wdev;
+	return wiphy;
+}
+
+static
+struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
+					   struct net_device *netdev,
+					   s32 mode, bool pm_block)
+{
+	struct brcmf_cfg80211_vif *vif;
+
+	if (cfg->vif_cnt == BRCMF_IFACE_MAX_CNT)
+		return ERR_PTR(-ENOSPC);
+
+	vif = kzalloc(sizeof(*vif), GFP_KERNEL);
+	if (!vif)
+		return ERR_PTR(-ENOMEM);
 
-wiphy_register_out:
-	wiphy_free(wdev->wiphy);
+	vif->wdev.wiphy = cfg->wiphy;
+	vif->wdev.netdev = netdev;
+	vif->wdev.iftype = brcmf_mode_to_nl80211_iftype(mode);
 
-wiphy_new_out:
-	kfree(wdev);
+	if (netdev) {
+		vif->ifp = netdev_priv(netdev);
+		netdev->ieee80211_ptr = &vif->wdev;
+		SET_NETDEV_DEV(netdev, wiphy_dev(cfg->wiphy));
+	}
+
+	vif->mode = mode;
+	vif->pm_block = pm_block;
+	vif->roam_off = -1;
 
-	return ERR_PTR(err);
+	list_add_tail(&vif->list, &cfg->vif_list);
+	cfg->vif_cnt++;
+	return vif;
 }
 
-static void brcmf_free_wdev(struct brcmf_cfg80211_info *cfg)
+static void brcmf_free_vif(struct brcmf_cfg80211_vif *vif)
 {
-	struct wireless_dev *wdev = cfg->wdev;
+	struct brcmf_cfg80211_info *cfg;
+	struct wiphy *wiphy;
 
-	if (!wdev) {
-		WL_ERR("wdev is invalid\n");
-		return;
+	wiphy = vif->wdev.wiphy;
+	cfg = wiphy_priv(wiphy);
+	list_del(&vif->list);
+	cfg->vif_cnt--;
+
+	kfree(vif);
+	if (!cfg->vif_cnt) {
+		wiphy_unregister(wiphy);
+		wiphy_free(wiphy);
 	}
-	wiphy_unregister(wdev->wiphy);
-	wiphy_free(wdev->wiphy);
-	kfree(wdev);
-	cfg->wdev = NULL;
 }
 
 static bool brcmf_is_linkup(struct brcmf_cfg80211_info *cfg,
@@ -4935,8 +4960,10 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr)
 {
 	struct net_device *ndev = drvr->iflist[0]->ndev;
 	struct device *busdev = drvr->dev;
-	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_info *cfg;
+	struct wiphy *wiphy;
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_if *ifp;
 	s32 err = 0;
 
 	if (!ndev) {
@@ -4944,35 +4971,45 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr)
 		return NULL;
 	}
 
-	wdev = brcmf_alloc_wdev(busdev);
-	if (IS_ERR(wdev)) {
+	ifp = netdev_priv(ndev);
+	wiphy = brcmf_setup_wiphy(busdev);
+	if (IS_ERR(wiphy))
 		return NULL;
-	}
 
-	wdev->iftype = brcmf_mode_to_nl80211_iftype(WL_MODE_BSS);
-	cfg = wdev_to_cfg(wdev);
-	cfg->wdev = wdev;
+	cfg = wiphy_priv(wiphy);
+	cfg->wiphy = wiphy;
 	cfg->pub = drvr;
-	ndev->ieee80211_ptr = wdev;
-	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
-	wdev->netdev = ndev;
+	INIT_LIST_HEAD(&cfg->vif_list);
+
+	vif = brcmf_alloc_vif(cfg, ndev, WL_MODE_BSS, false);
+	if (IS_ERR(vif)) {
+		wiphy_free(wiphy);
+		return NULL;
+	}
+
 	err = wl_init_priv(cfg);
 	if (err) {
 		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
 
+	ifp->vif = vif;
 	return cfg;
 
 cfg80211_attach_out:
-	brcmf_free_wdev(cfg);
+	brcmf_free_vif(vif);
 	return NULL;
 }
 
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_cfg80211_vif *tmp;
+
 	wl_deinit_priv(cfg);
-	brcmf_free_wdev(cfg);
+	list_for_each_entry_safe(vif, tmp, &cfg->vif_list, list) {
+		brcmf_free_vif(vif);
+	}
 }
 
 void
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 1912625..6644ea8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -235,6 +235,25 @@ struct brcmf_cfg80211_profile {
 	s32 band;
 };
 
+/**
+ * struct brcmf_cfg80211_vif - virtual interface specific information.
+ *
+ * @ifp: lower layer interface pointer
+ * @wdev: wireless device.
+ * @mode: operating mode.
+ * @roam_off: roaming state.
+ * @pm_block: power-management blocked.
+ * @list: linked list.
+ */
+struct brcmf_cfg80211_vif {
+	struct brcmf_if *ifp;
+	struct wireless_dev wdev;
+	s32 mode;
+	s32 roam_off;
+	bool pm_block;
+	struct list_head list;
+};
+
 /* dongle iscan event loop */
 struct brcmf_cfg80211_iscan_eloop {
 	s32 (*handler[WL_SCAN_ERSULTS_LAST])
@@ -383,7 +402,7 @@ struct brcmf_pno_scanresults_le {
 /**
  * struct brcmf_cfg80211_info - dongle private data of cfg80211 interface
  *
- * @wdev: representing wl cfg80211 device.
+ * @wiphy: wiphy object for cfg80211 interface.
  * @conf: dongle configuration.
  * @scan_request: cfg80211 scan request object.
  * @el: main event loop.
@@ -422,10 +441,11 @@ struct brcmf_pno_scanresults_le {
  * @escan_timeout_work: scan timeout worker.
  * @escan_ioctl_buf: dongle command buffer for escan commands.
  * @ap_info: host ap information.
- * @ci: used to link this structure to netdev private data.
+ * @vif_list: linked list of vif instances.
+ * @vif_cnt: number of vif instances.
  */
 struct brcmf_cfg80211_info {
-	struct wireless_dev *wdev;
+	struct wiphy *wiphy;
 	struct brcmf_cfg80211_conf *conf;
 	struct cfg80211_scan_request *scan_request;
 	struct brcmf_cfg80211_event_loop el;
@@ -464,11 +484,13 @@ struct brcmf_cfg80211_info {
 	struct work_struct escan_timeout_work;
 	u8 *escan_ioctl_buf;
 	struct ap_info *ap_info;
+	struct list_head vif_list;
+	u8 vif_cnt;
 };
 
-static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_info *w)
+static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_info *cfg)
 {
-	return w->wdev->wiphy;
+	return cfg->wiphy;
 }
 
 static inline struct brcmf_cfg80211_info *wiphy_to_cfg(struct wiphy *w)
@@ -481,9 +503,12 @@ static inline struct brcmf_cfg80211_info *wdev_to_cfg(struct wireless_dev *wd)
 	return (struct brcmf_cfg80211_info *)(wdev_priv(wd));
 }
 
-static inline struct net_device *cfg_to_ndev(struct brcmf_cfg80211_info *cfg)
+static inline
+struct net_device *cfg_to_ndev(struct brcmf_cfg80211_info *cfg)
 {
-	return cfg->wdev->netdev;
+	struct brcmf_cfg80211_vif *vif;
+	vif = list_first_entry(&cfg->vif_list, struct brcmf_cfg80211_vif, list);
+	return vif->wdev.netdev;
 }
 
 static inline struct brcmf_cfg80211_info *ndev_to_cfg(struct net_device *ndev)
-- 
1.7.9.5


