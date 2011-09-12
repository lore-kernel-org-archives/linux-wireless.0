Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3819 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab1ILKPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:24 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/20] staging: brcm80211: remove static variables from
 wl_cfg80211.c
Date: Mon, 12 Sep 2011 12:14:53 +0200
Message-ID: <1315822504-24210-10-git-send-email-rvossen@broadcom.com> (sfid-20110912_121541_978344_7FD7BEA4)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source file contained two static variable which were used by
the driver instance. This makes having multiple instances of the driver
on one system impossible. This patch removes the use of these static
variables allowing multiple driver instances.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    2 +
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |    3 +
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   20 +++--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |    5 ++
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   77 ++++++++-------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |   15 ++--
 7 files changed, 59 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b38e698..0aff62d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -539,7 +539,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			return -ENODEV;
 		sdiodev->func[2] = func;
 
-		brcmf_cfg80211_sdio_func(func);
 		brcmf_dbg(TRACE, "F2 found, calling brcmf_sdio_probe...\n");
 		ret = brcmf_sdio_probe(sdiodev);
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index b0cfe51..9f84837 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -540,6 +540,7 @@ struct brcmf_ioctl {
 struct brcmf_bus;		/* device bus info */
 struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_info;	/* device driver info */
+struct brcmf_cfg80211_dev; /* cfg80211 device info */
 
 /* Common structure for module and instance linkage */
 struct brcmf_pub {
@@ -547,6 +548,7 @@ struct brcmf_pub {
 	struct brcmf_bus *bus;
 	struct brcmf_proto *prot;
 	struct brcmf_info *info;
+	struct brcmf_cfg80211_dev *config;
 
 	/* Internal brcmf items */
 	bool up;		/* Driver up/down (to OS) */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 3361e01..aa05b1c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -38,6 +38,9 @@ extern uint brcmf_watchdog_ms;
 extern int brcmf_bus_register(void);
 extern void brcmf_bus_unregister(void);
 
+/* obtain linux device object providing bus function */
+extern struct device *brcmf_bus_get_device(struct brcmf_bus *bus);
+
 /* Stop bus module: clear pending frames, disable data flow */
 extern void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 539a24d..cfdd645 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -828,7 +828,7 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *net,
 	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
 	sprintf(info->fw_version, "%s", BCM4329_FW_NAME);
 	sprintf(info->bus_info, "%s",
-		dev_name(&brcmf_cfg80211_get_sdio_func()->dev));
+		dev_name(brcmf_bus_get_device(drvr_priv->pub.bus)));
 }
 
 static struct ethtool_ops brcmf_ethtool_ops = {
@@ -1055,15 +1055,15 @@ done:
 
 static int brcmf_netdev_stop(struct net_device *net)
 {
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
+	struct brcmf_pub *drvr = *(struct brcmf_pub **) netdev_priv(net);
 
 	brcmf_dbg(TRACE, "Enter\n");
-	brcmf_cfg80211_down();
-	if (drvr_priv->pub.up == 0)
+	brcmf_cfg80211_down(drvr->config);
+	if (drvr->up == 0)
 		return 0;
 
 	/* Set state and stop OS transmissions */
-	drvr_priv->pub.up = 0;
+	drvr->up = 0;
 	netif_stop_queue(net);
 
 	return 0;
@@ -1102,7 +1102,7 @@ static int brcmf_netdev_open(struct net_device *net)
 	/* Allow transmit calls */
 	netif_start_queue(net);
 	drvr_priv->pub.up = 1;
-	if (unlikely(brcmf_cfg80211_up())) {
+	if (unlikely(brcmf_cfg80211_up(drvr_priv->pub.config))) {
 		brcmf_dbg(ERROR, "failed to bring up cfg80211\n");
 		return -1;
 	}
@@ -1220,7 +1220,11 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	}
 
 	/* Attach and link in the cfg80211 */
-	if (unlikely(brcmf_cfg80211_attach(net, &drvr_priv->pub))) {
+	drvr_priv->pub.config =
+			brcmf_cfg80211_attach(net,
+					      brcmf_bus_get_device(bus),
+					      &drvr_priv->pub);
+	if (unlikely(drvr_priv->pub.config == NULL)) {
 		brcmf_dbg(ERROR, "wl_cfg80211_attach failed\n");
 		goto fail;
 	}
@@ -1425,7 +1429,7 @@ void brcmf_detach(struct brcmf_pub *drvr)
 			if (drvr->prot)
 				brcmf_proto_detach(drvr);
 
-			brcmf_cfg80211_detach();
+			brcmf_cfg80211_detach(drvr->config);
 
 			free_netdev(ifp->net);
 			kfree(ifp);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 823567f..0de4dc6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -4317,6 +4317,11 @@ void brcmf_bus_unregister(void)
 	brcmf_sdio_unregister();
 }
 
+struct device *brcmf_bus_get_device(struct brcmf_bus *bus)
+{
+	return &bus->sdiodev->func[2]->dev;
+}
+
 static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 {
 	int offset = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index dd56baa..d33d2cd 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -23,7 +23,6 @@
 #include <linux/bitops.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
-#include <linux/mmc/sdio_func.h>
 #include <linux/uaccess.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
@@ -37,8 +36,6 @@
 #define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params) - sizeof(u16))
 
-static struct sdio_func *cfg80211_sdio_func;
-static struct brcmf_cfg80211_dev *cfg80211_dev;
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
 static u32 brcmf_dbg_level = WL_DBG_ERR;
@@ -148,11 +145,6 @@ static s32 brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
 				   const struct brcmf_event_msg *e, void *data);
 
 /*
-** register/deregister sdio function
-*/
-static void brcmf_clear_sdio_func(void);
-
-/*
 ** ioctl utilites
 */
 static s32 brcmf_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
@@ -312,9 +304,10 @@ static int
 brcmf_debugfs_add_netdev_params(struct brcmf_cfg80211_priv *cfg_priv);
 static void brcmf_debugfs_remove_netdev(struct brcmf_cfg80211_priv *cfg_priv);
 
-static struct brcmf_cfg80211_priv *brcmf_priv_get(void)
+static
+struct brcmf_cfg80211_priv *brcmf_priv_get(struct brcmf_cfg80211_dev *cfg_dev)
 {
-	struct brcmf_cfg80211_iface *ci = brcmf_get_drvdata(cfg80211_dev);
+	struct brcmf_cfg80211_iface *ci = brcmf_get_drvdata(cfg_dev);
 	return ci->cfg_priv;
 }
 
@@ -3430,27 +3423,31 @@ static void wl_deinit_priv(struct brcmf_cfg80211_priv *cfg_priv)
 	brcmf_deinit_priv_mem(cfg_priv);
 }
 
-s32 brcmf_cfg80211_attach(struct net_device *ndev, void *data)
+struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
+						 struct device *busdev,
+						 void *data)
 {
 	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_priv *cfg_priv;
 	struct brcmf_cfg80211_iface *ci;
+	struct brcmf_cfg80211_dev *cfg_dev;
 	s32 err = 0;
 
 	if (unlikely(!ndev)) {
 		WL_ERR("ndev is invalid\n");
-		return -ENODEV;
+		return NULL;
 	}
-	cfg80211_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
-	if (unlikely(!cfg80211_dev)) {
+	cfg_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
+	if (unlikely(!cfg_dev)) {
 		WL_ERR("wl_cfg80211_dev is invalid\n");
-		return -ENOMEM;
+		return NULL;
+	}
+
+	wdev = brcmf_alloc_wdev(sizeof(struct brcmf_cfg80211_iface), busdev);
+	if (IS_ERR(wdev)) {
+		kfree(cfg_dev);
+		return NULL;
 	}
-	WL_INFO("func %p\n", brcmf_cfg80211_get_sdio_func());
-	wdev = brcmf_alloc_wdev(sizeof(struct brcmf_cfg80211_iface),
-				&brcmf_cfg80211_get_sdio_func()->dev);
-	if (IS_ERR(wdev))
-		return -ENOMEM;
 
 	wdev->iftype = brcmf_mode_to_nl80211_iftype(WL_MODE_BSS);
 	cfg_priv = wdev_to_cfg(wdev);
@@ -3466,27 +3463,26 @@ s32 brcmf_cfg80211_attach(struct net_device *ndev, void *data)
 		WL_ERR("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
-	brcmf_set_drvdata(cfg80211_dev, ci);
+	brcmf_set_drvdata(cfg_dev, ci);
 
-	return err;
+	return cfg_dev;
 
 cfg80211_attach_out:
 	brcmf_free_wdev(cfg_priv);
-	return err;
+	kfree(cfg_dev);
+	return NULL;
 }
 
-void brcmf_cfg80211_detach(void)
+void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg_dev)
 {
 	struct brcmf_cfg80211_priv *cfg_priv;
 
-	cfg_priv = brcmf_priv_get();
+	cfg_priv = brcmf_priv_get(cfg_dev);
 
 	wl_deinit_priv(cfg_priv);
 	brcmf_free_wdev(cfg_priv);
-	brcmf_set_drvdata(cfg80211_dev, NULL);
-	kfree(cfg80211_dev);
-	cfg80211_dev = NULL;
-	brcmf_clear_sdio_func();
+	brcmf_set_drvdata(cfg_dev, NULL);
+	kfree(cfg_dev);
 }
 
 static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv)
@@ -3620,21 +3616,6 @@ static void brcmf_put_event(struct brcmf_cfg80211_event_q *e)
 	kfree(e);
 }
 
-void brcmf_cfg80211_sdio_func(void *func)
-{
-	cfg80211_sdio_func = (struct sdio_func *)func;
-}
-
-static void brcmf_clear_sdio_func(void)
-{
-	cfg80211_sdio_func = NULL;
-}
-
-struct sdio_func *brcmf_cfg80211_get_sdio_func(void)
-{
-	return cfg80211_sdio_func;
-}
-
 static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
 {
 	s32 infra = 0;
@@ -3951,12 +3932,12 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 	return 0;
 }
 
-s32 brcmf_cfg80211_up(void)
+s32 brcmf_cfg80211_up(struct brcmf_cfg80211_dev *cfg_dev)
 {
 	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
 
-	cfg_priv = brcmf_priv_get();
+	cfg_priv = brcmf_priv_get(cfg_dev);
 	mutex_lock(&cfg_priv->usr_sync);
 	err = __brcmf_cfg80211_up(cfg_priv);
 	mutex_unlock(&cfg_priv->usr_sync);
@@ -3964,12 +3945,12 @@ s32 brcmf_cfg80211_up(void)
 	return err;
 }
 
-s32 brcmf_cfg80211_down(void)
+s32 brcmf_cfg80211_down(struct brcmf_cfg80211_dev *cfg_dev)
 {
 	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
 
-	cfg_priv = brcmf_priv_get();
+	cfg_priv = brcmf_priv_get(cfg_dev);
 	mutex_lock(&cfg_priv->usr_sync);
 	err = __brcmf_cfg80211_down(cfg_priv);
 	mutex_unlock(&cfg_priv->usr_sync);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index cfbf50d..db71762 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -364,16 +364,17 @@ static inline struct brcmf_bss_info *next_bss(struct brcmf_scan_results *list,
 
 #define for_each_bss(list, bss, __i)	\
 	for (__i = 0; __i < list->count && __i < WL_AP_MAX; __i++, \
-	     bss = next_bss(list, bss))
+		bss = next_bss(list, bss))
+
+extern struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
+							struct device *busdev,
+							void *data);
+extern void brcmf_cfg80211_detach(struct brcmf_cfg80211_dev *cfg);
 
-extern s32 brcmf_cfg80211_attach(struct net_device *ndev, void *data);
-extern void brcmf_cfg80211_detach(void);
 /* event handler from dongle */
 extern void brcmf_cfg80211_event(struct net_device *ndev,
 				 const struct brcmf_event_msg *e, void *data);
-extern void brcmf_cfg80211_sdio_func(void *func); /* set sdio function info */
-extern struct sdio_func *brcmf_cfg80211_get_sdio_func(void);
-extern s32 brcmf_cfg80211_up(void);	/* dongle up */
-extern s32 brcmf_cfg80211_down(void);	/* dongle down */
+extern s32 brcmf_cfg80211_up(struct brcmf_cfg80211_dev *cfg_dev);
+extern s32 brcmf_cfg80211_down(struct brcmf_cfg80211_dev *cfg_dev);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.4.1


