Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:43487 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753806AbeBPINd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 03:13:33 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codeaurora.org>
Subject: [PATCH 1/8] wil6210: add wil6210_vif structure for per-VIF data
Date: Fri, 16 Feb 2018 10:04:36 +0200
Message-Id: <1518768283-2318-2-git-send-email-merez@codeaurora.org> (sfid-20180216_091358_158111_200C2A5B)
In-Reply-To: <1518768283-2318-1-git-send-email-merez@codeaurora.org>
References: <1518768283-2318-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <liord@codeaurora.org>

For supporting multiple virtual interfaces in the future,
introduce a wil6210_vif structure which will hold per-VIF
data. Change the module initialization so wil6210_vif will
be part of net_device structure, and wireless_dev will be
embedded inside the wil6210_vif structure. This will allow
us to find the appropriate wil6210_vif structure when we
only have access to wireless_dev or net_device.

Signed-off-by: Lior David <liord@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 57 ++++++++++--------
 drivers/net/wireless/ath/wil6210/netdev.c   | 93 ++++++++++++++++++-----------
 drivers/net/wireless/ath/wil6210/wil6210.h  | 22 +++++--
 3 files changed, 107 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 768f63f38..4611d8b 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -418,6 +419,7 @@ static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	struct net_device *ndev = wil_to_ndev(wil);
+	struct wil6210_vif *vif;
 	struct wireless_dev *p2p_wdev;
 
 	wil_dbg_misc(wil, "add_iface\n");
@@ -432,10 +434,11 @@ static void wil_cfg80211_stop_p2p_device(struct wiphy *wiphy,
 		return ERR_PTR(-EINVAL);
 	}
 
-	p2p_wdev = kzalloc(sizeof(*p2p_wdev), GFP_KERNEL);
-	if (!p2p_wdev)
+	vif = kzalloc(sizeof(*vif), GFP_KERNEL);
+	if (!vif)
 		return ERR_PTR(-ENOMEM);
 
+	p2p_wdev = &vif->wdev;
 	p2p_wdev->iftype = type;
 	p2p_wdev->wiphy = wiphy;
 	/* use our primary ethernet address */
@@ -1892,51 +1895,52 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 #endif
 }
 
-struct wireless_dev *wil_cfg80211_init(struct device *dev)
+struct wil6210_priv *wil_cfg80211_init(struct device *dev)
 {
-	int rc = 0;
-	struct wireless_dev *wdev;
+	struct wiphy *wiphy;
+	struct wil6210_priv *wil;
+	struct ieee80211_channel *ch;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
-	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
-	if (!wdev)
+	/* Note: the wireless_dev structure is no longer allocated here.
+	 * Instead, it is allocated as part of the net_device structure
+	 * for main interface and each VIF.
+	 */
+	wiphy = wiphy_new(&wil_cfg80211_ops, sizeof(struct wil6210_priv));
+	if (!wiphy)
 		return ERR_PTR(-ENOMEM);
 
-	wdev->wiphy = wiphy_new(&wil_cfg80211_ops,
-				sizeof(struct wil6210_priv));
-	if (!wdev->wiphy) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	set_wiphy_dev(wdev->wiphy, dev);
-	wil_wiphy_init(wdev->wiphy);
+	set_wiphy_dev(wiphy, dev);
+	wil_wiphy_init(wiphy);
 
-	return wdev;
+	wil = wiphy_to_wil(wiphy);
+	wil->wiphy = wiphy;
 
-out:
-	kfree(wdev);
+	/* default monitor channel */
+	ch = wiphy->bands[NL80211_BAND_60GHZ]->channels;
+	cfg80211_chandef_create(&wil->monitor_chandef, ch, NL80211_CHAN_NO_HT);
 
-	return ERR_PTR(rc);
+	return wil;
 }
 
-void wil_wdev_free(struct wil6210_priv *wil)
+void wil_cfg80211_deinit(struct wil6210_priv *wil)
 {
-	struct wireless_dev *wdev = wil_to_wdev(wil);
+	struct wiphy *wiphy = wil_to_wiphy(wil);
 
 	dev_dbg(wil_to_dev(wil), "%s()\n", __func__);
 
-	if (!wdev)
+	if (!wiphy)
 		return;
 
-	wiphy_free(wdev->wiphy);
-	kfree(wdev);
+	wiphy_free(wiphy);
+	/* do not access wil6210_priv after returning from here */
 }
 
 void wil_p2p_wdev_free(struct wil6210_priv *wil)
 {
 	struct wireless_dev *p2p_wdev;
+	struct wil6210_vif *vif;
 
 	mutex_lock(&wil->p2p_wdev_mutex);
 	p2p_wdev = wil->p2p_wdev;
@@ -1945,7 +1949,8 @@ void wil_p2p_wdev_free(struct wil6210_priv *wil)
 	mutex_unlock(&wil->p2p_wdev_mutex);
 	if (p2p_wdev) {
 		cfg80211_unregister_wdev(p2p_wdev);
-		kfree(p2p_wdev);
+		vif = wdev_to_vif(p2p_wdev);
+		kfree(vif);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 7ba4e0a..648f636 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -121,63 +122,85 @@ static void wil_dev_setup(struct net_device *dev)
 	dev->tx_queue_len = WIL_TX_Q_LEN_DEFAULT;
 }
 
-void *wil_if_alloc(struct device *dev)
+struct wil6210_vif *
+wil_vif_alloc(struct wil6210_priv *wil, const char *name,
+	      unsigned char name_assign_type, enum nl80211_iftype iftype,
+	      u8 mid)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
+	struct wil6210_vif *vif;
+
+	ndev = alloc_netdev(sizeof(*vif), name, name_assign_type,
+			    wil_dev_setup);
+	if (!ndev) {
+		dev_err(wil_to_dev(wil), "alloc_netdev failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	if (mid == 0)
+		wil->ndev = ndev;
+	vif = ndev_to_vif(ndev);
+	vif->wil = wil;
+	vif->mid = mid;
+
+	wdev = &vif->wdev;
+	wdev->wiphy = wil->wiphy;
+	wdev->iftype = iftype;
+
+	ndev->netdev_ops = &wil_netdev_ops;
+	wil_set_ethtoolops(ndev);
+	ndev->ieee80211_ptr = wdev;
+	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
+			    NETIF_F_SG | NETIF_F_GRO |
+			    NETIF_F_TSO | NETIF_F_TSO6 |
+			    NETIF_F_RXHASH;
+
+	ndev->features |= ndev->hw_features;
+	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
+	wdev->netdev = ndev;
+	return vif;
+}
+
+void *wil_if_alloc(struct device *dev)
+{
+	struct wireless_dev *wdev;
 	struct wil6210_priv *wil;
-	struct ieee80211_channel *ch;
+	struct wil6210_vif *vif;
 	int rc = 0;
 
-	wdev = wil_cfg80211_init(dev);
-	if (IS_ERR(wdev)) {
+	wil = wil_cfg80211_init(dev);
+	if (IS_ERR(wil)) {
 		dev_err(dev, "wil_cfg80211_init failed\n");
-		return wdev;
+		return wil;
 	}
 
-	wil = wdev_to_wil(wdev);
-	wil->wdev = wdev;
-	wil->radio_wdev = wdev;
-
-	wil_dbg_misc(wil, "if_alloc\n");
-
 	rc = wil_priv_init(wil);
 	if (rc) {
 		dev_err(dev, "wil_priv_init failed\n");
-		goto out_wdev;
+		goto out_cfg;
 	}
 
-	wdev->iftype = NL80211_IFTYPE_STATION; /* TODO */
-	/* default monitor channel */
-	ch = wdev->wiphy->bands[NL80211_BAND_60GHZ]->channels;
-	cfg80211_chandef_create(&wil->monitor_chandef, ch, NL80211_CHAN_NO_HT);
+	wil_dbg_misc(wil, "if_alloc\n");
 
-	ndev = alloc_netdev(0, "wlan%d", NET_NAME_UNKNOWN, wil_dev_setup);
-	if (!ndev) {
-		dev_err(dev, "alloc_netdev_mqs failed\n");
+	vif = wil_vif_alloc(wil, "wlan%d", NET_NAME_UNKNOWN,
+			    NL80211_IFTYPE_STATION, 0);
+	if (IS_ERR(vif)) {
+		dev_err(dev, "wil_vif_alloc failed\n");
 		rc = -ENOMEM;
 		goto out_priv;
 	}
 
-	ndev->netdev_ops = &wil_netdev_ops;
-	wil_set_ethtoolops(ndev);
-	ndev->ieee80211_ptr = wdev;
-	ndev->hw_features = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
-			    NETIF_F_SG | NETIF_F_GRO |
-			    NETIF_F_TSO | NETIF_F_TSO6 |
-			    NETIF_F_RXHASH;
-
-	ndev->features |= ndev->hw_features;
-	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
-	wdev->netdev = ndev;
+	wdev = &vif->wdev;
+	wil->wdev = wdev;
+	wil->radio_wdev = wdev;
 
 	return wil;
 
- out_priv:
+out_priv:
 	wil_priv_deinit(wil);
 
- out_wdev:
-	wil_wdev_free(wil);
+out_cfg:
+	wil_cfg80211_deinit(wil);
 
 	return ERR_PTR(rc);
 }
@@ -196,13 +219,13 @@ void wil_if_free(struct wil6210_priv *wil)
 	wil_to_ndev(wil) = NULL;
 	free_netdev(ndev);
 
-	wil_wdev_free(wil);
+	wil_cfg80211_deinit(wil);
 }
 
 int wil_if_add(struct wil6210_priv *wil)
 {
 	struct wireless_dev *wdev = wil_to_wdev(wil);
-	struct wiphy *wiphy = wdev->wiphy;
+	struct wiphy *wiphy = wil->wiphy;
 	struct net_device *ndev = wil_to_ndev(wil);
 	int rc;
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0df2aad..b33aa7d 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -669,10 +669,18 @@ struct wil_debugfs_data {
 extern u8 led_id;
 extern u8 led_polarity;
 
+struct wil6210_vif {
+	struct wireless_dev wdev;
+	struct wil6210_priv *wil;
+	u8 mid;
+};
+
 struct wil6210_priv {
 	struct pci_dev *pdev;
 	u32 bar_size;
+	struct wiphy *wiphy;
 	struct wireless_dev *wdev;
+	struct net_device *ndev;
 	void __iomem *csr;
 	DECLARE_BITMAP(status, wil_status_last);
 	u8 fw_version[ETHTOOL_FWVERS_LEN];
@@ -798,13 +806,15 @@ struct wil6210_priv {
 	u32 iccm_base;
 };
 
-#define wil_to_wiphy(i) (i->wdev->wiphy)
+#define wil_to_wiphy(i) (i->wiphy)
 #define wil_to_dev(i) (wiphy_dev(wil_to_wiphy(i)))
 #define wiphy_to_wil(w) (struct wil6210_priv *)(wiphy_priv(w))
 #define wil_to_wdev(i) (i->wdev)
 #define wdev_to_wil(w) (struct wil6210_priv *)(wdev_priv(w))
-#define wil_to_ndev(i) (wil_to_wdev(i)->netdev)
+#define wil_to_ndev(i) (i->ndev)
 #define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
+#define ndev_to_vif(n) (struct wil6210_vif *)(netdev_priv(n))
+#define wdev_to_vif(w) (container_of(w, struct wil6210_vif, wdev))
 
 __printf(2, 3)
 void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
@@ -900,6 +910,10 @@ void wil_memcpy_fromio_32(void *dst, const volatile void __iomem *src,
 void wil_memcpy_toio_32(volatile void __iomem *dst, const void *src,
 			size_t count);
 
+struct wil6210_vif *
+wil_vif_alloc(struct wil6210_priv *wil, const char *name,
+	      unsigned char name_assign_type, enum nl80211_iftype iftype,
+	      u8 mid);
 void *wil_if_alloc(struct device *dev);
 void wil_if_free(struct wil6210_priv *wil);
 int wil_if_add(struct wil6210_priv *wil);
@@ -1010,8 +1024,8 @@ static inline void wil6210_debugfs_remove(struct wil6210_priv *wil) {}
 int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 		       struct station_info *sinfo);
 
-struct wireless_dev *wil_cfg80211_init(struct device *dev);
-void wil_wdev_free(struct wil6210_priv *wil);
+struct wil6210_priv *wil_cfg80211_init(struct device *dev);
+void wil_cfg80211_deinit(struct wil6210_priv *wil);
 void wil_p2p_wdev_free(struct wil6210_priv *wil);
 
 int wmi_set_mac_address(struct wil6210_priv *wil, void *addr);
-- 
1.9.1
