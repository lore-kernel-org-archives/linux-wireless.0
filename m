Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1915 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab1F2Xsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:47 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 117/119] staging: brcm80211: rename external function in
 wl_cfg80211.c
Date: Wed, 29 Jun 2011 16:48:21 -0700
Message-ID: <1309391303-22741-118-git-send-email-frankyl@broadcom.com> (sfid-20110630_015022_084755_C9950DAD)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Renamed external function getting rid of wl_ prefix. Removed unused
function from the API header file wl_cfg80211.h as it was not defined.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   14 ++++++++------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   18 +++++++++---------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |   19 +++++++++----------
 4 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index cdaa042..e229bcb 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -88,7 +88,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	gInstance->func[func->num] = func;
 
 	if (func->num == 2) {
-		wl_cfg80211_sdio_func(func);
+		brcmf_cfg80211_sdio_func(func);
 		sd_trace(("F2 found, calling brcmf_sdio_probe...\n"));
 		ret = brcmf_sdio_probe(&sdmmc_dev);
 	}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 8db4609..a6dc346 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1052,7 +1052,8 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *net,
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", drvr_priv->pub.drv_version);
 	sprintf(info->fw_version, "%s", BCM4329_FW_NAME);
-	sprintf(info->bus_info, "%s", dev_name(&wl_cfg80211_get_sdio_func()->dev));
+	sprintf(info->bus_info, "%s",
+		dev_name(&brcmf_cfg80211_get_sdio_func()->dev));
 }
 
 struct ethtool_ops brcmf_ethtool_ops = {
@@ -1292,7 +1293,7 @@ static int brcmf_netdev_stop(struct net_device *net)
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 
 	DHD_TRACE(("%s: Enter\n", __func__));
-	wl_cfg80211_down();
+	brcmf_cfg80211_down();
 	if (drvr_priv->pub.up == 0)
 		return 0;
 
@@ -1338,7 +1339,7 @@ static int brcmf_netdev_open(struct net_device *net)
 	/* Allow transmit calls */
 	netif_start_queue(net);
 	drvr_priv->pub.up = 1;
-	if (unlikely(wl_cfg80211_up())) {
+	if (unlikely(brcmf_cfg80211_up())) {
 		DHD_ERROR(("%s: failed to bring up cfg80211\n",
 			   __func__));
 		return -1;
@@ -1464,7 +1465,7 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	}
 
 	/* Attach and link in the cfg80211 */
-	if (unlikely(wl_cfg80211_attach(net, &drvr_priv->pub))) {
+	if (unlikely(brcmf_cfg80211_attach(net, &drvr_priv->pub))) {
 		DHD_ERROR(("wl_cfg80211_attach failed\n"));
 		goto fail;
 	}
@@ -1700,7 +1701,7 @@ void brcmf_detach(struct brcmf_pub *drvr)
 			if (drvr->prot)
 				brcmf_proto_detach(drvr);
 
-			wl_cfg80211_detach();
+			brcmf_cfg80211_detach();
 
 			/* && defined(DHD_GPL) */
 			free_netdev(ifp->net);
@@ -1824,7 +1825,8 @@ static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktd
 	ASSERT(drvr_priv->iflist[*ifidx] != NULL);
 	ASSERT(drvr_priv->iflist[*ifidx]->net != NULL);
 	if (drvr_priv->iflist[*ifidx]->net)
-		wl_cfg80211_event(drvr_priv->iflist[*ifidx]->net, event, *data);
+		brcmf_cfg80211_event(drvr_priv->iflist[*ifidx]->net,
+				     event, *data);
 
 	return bcmerror;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index d109de1..17a6bf0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3440,7 +3440,7 @@ static void wl_deinit_priv(struct brcmf_cfg80211_priv *cfg_priv)
 	brcmf_deinit_priv_mem(cfg_priv);
 }
 
-s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
+s32 brcmf_cfg80211_attach(struct net_device *ndev, void *data)
 {
 	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_priv *cfg_priv;
@@ -3456,9 +3456,9 @@ s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 		WL_ERR("wl_cfg80211_dev is invalid\n");
 		return -ENOMEM;
 	}
-	WL_INFO("func %p\n", wl_cfg80211_get_sdio_func());
+	WL_INFO("func %p\n", brcmf_cfg80211_get_sdio_func());
 	wdev = brcmf_alloc_wdev(sizeof(struct brcmf_cfg80211_iface),
-				&wl_cfg80211_get_sdio_func()->dev);
+				&brcmf_cfg80211_get_sdio_func()->dev);
 	if (IS_ERR(wdev))
 		return -ENOMEM;
 
@@ -3485,7 +3485,7 @@ cfg80211_attach_out:
 	return err;
 }
 
-void wl_cfg80211_detach(void)
+void brcmf_cfg80211_detach(void)
 {
 	struct brcmf_cfg80211_priv *cfg_priv;
 
@@ -3536,7 +3536,7 @@ static s32 brcmf_event_handler(void *data)
 }
 
 void
-wl_cfg80211_event(struct net_device *ndev,
+brcmf_cfg80211_event(struct net_device *ndev,
 		  const struct brcmf_event_msg *e, void *data)
 {
 	u32 event_type = be32_to_cpu(e->event_type);
@@ -3619,7 +3619,7 @@ static void brcmf_put_event(struct brcmf_cfg80211_event_q *e)
 	kfree(e);
 }
 
-void wl_cfg80211_sdio_func(void *func)
+void brcmf_cfg80211_sdio_func(void *func)
 {
 	cfg80211_sdio_func = (struct sdio_func *)func;
 }
@@ -3629,7 +3629,7 @@ static void brcmf_clear_sdio_func(void)
 	cfg80211_sdio_func = NULL;
 }
 
-struct sdio_func *wl_cfg80211_get_sdio_func(void)
+struct sdio_func *brcmf_cfg80211_get_sdio_func(void)
 {
 	return cfg80211_sdio_func;
 }
@@ -3938,7 +3938,7 @@ static s32 __brcmf_cfg80211_down(struct brcmf_cfg80211_priv *cfg_priv)
 	return 0;
 }
 
-s32 wl_cfg80211_up(void)
+s32 brcmf_cfg80211_up(void)
 {
 	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
@@ -3951,7 +3951,7 @@ s32 wl_cfg80211_up(void)
 	return err;
 }
 
-s32 wl_cfg80211_down(void)
+s32 brcmf_cfg80211_down(void)
 {
 	struct brcmf_cfg80211_priv *cfg_priv;
 	s32 err = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 3ee7a3f..f26d087 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -343,15 +343,14 @@ static inline struct brcmf_bss_info *next_bss(struct brcmf_scan_results *list,
 #define for_each_bss(list, bss, __i)	\
 	for (__i = 0; __i < list->count && __i < WL_AP_MAX; __i++, bss = next_bss(list, bss))
 
-extern s32 wl_cfg80211_attach(struct net_device *ndev, void *data);
-extern void wl_cfg80211_detach(void);
+extern s32 brcmf_cfg80211_attach(struct net_device *ndev, void *data);
+extern void brcmf_cfg80211_detach(void);
 /* event handler from dongle */
-extern void wl_cfg80211_event(struct net_device *ndev,
-			      const struct brcmf_event_msg *e, void *data);
-extern void wl_cfg80211_sdio_func(void *func);	/* set sdio function info */
-extern struct sdio_func *wl_cfg80211_get_sdio_func(void);
-extern s32 wl_cfg80211_up(void);	/* dongle up */
-extern s32 wl_cfg80211_down(void);	/* dongle down */
-extern void wl_cfg80211_dbg_level(u32 level);	/* set dongle
-							 debugging level */
+extern void brcmf_cfg80211_event(struct net_device *ndev,
+				 const struct brcmf_event_msg *e, void *data);
+extern void brcmf_cfg80211_sdio_func(void *func); /* set sdio function info */
+extern struct sdio_func *brcmf_cfg80211_get_sdio_func(void);
+extern s32 brcmf_cfg80211_up(void);	/* dongle up */
+extern s32 brcmf_cfg80211_down(void);	/* dongle down */
+
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.1


