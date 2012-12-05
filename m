Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2432 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab2LEO0a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 09:26:30 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/11] brcmfmac: rework bus interface
Date: Wed, 5 Dec 2012 15:25:54 +0100
Message-ID: <1354717564-7183-2-git-send-email-arend@broadcom.com> (sfid-20121205_152640_660720_347AEBFA)
In-Reply-To: <1354717564-7183-1-git-send-email-arend@broadcom.com>
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rework the bus interface between common driver part and bus-specific
driver part. It prepares for adding tracing in bus-specific callback
functions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   92 ++++++++++++++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   11 +--
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    5 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   11 ++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   16 ++--
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   15 ++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    4 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    3 +-
 9 files changed, 111 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 24bc4e3..fd672bf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -470,7 +470,6 @@ struct brcmf_pub {
 	struct brcmf_bus *bus_if;
 	struct brcmf_proto *prot;
 	struct brcmf_cfg80211_info *config;
-	struct device *dev;		/* fullmac dongle device pointer */
 
 	/* Internal brcmf items */
 	uint hdrlen;		/* Total BRCMF header length (proto + bus) */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index b8f2487..dd38b78 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -43,36 +43,90 @@ struct brcmf_bus_dcmd {
 	struct list_head list;
 };
 
-/* interface structure between common and bus layer */
+/**
+ * struct brcmf_bus_ops - bus callback operations.
+ *
+ * @init: prepare for communication with dongle.
+ * @stop: clear pending frames, disable data flow.
+ * @txdata: send a data frame to the dongle (callee disposes skb).
+ * @txctl: transmit a control request message to dongle.
+ * @rxctl: receive a control response message from dongle.
+ *
+ * This structure provides an abstract interface towards the
+ * bus specific driver. For control messages to common driver
+ * will assure there is only one active transaction.
+ */
+struct brcmf_bus_ops {
+	int (*init)(struct device *dev);
+	void (*stop)(struct device *dev);
+	int (*txdata)(struct device *dev, struct sk_buff *skb);
+	int (*txctl)(struct device *dev, unsigned char *msg, uint len);
+	int (*rxctl)(struct device *dev, unsigned char *msg, uint len);
+};
+
+/**
+ * struct brcmf_bus - interface structure between common and bus layer
+ *
+ * @bus_priv: pointer to private bus device.
+ * @dev: device pointer of bus device.
+ * @drvr: public driver information.
+ * @state: operational state of the bus interface.
+ * @maxctl: maximum size for rxctl request message.
+ * @drvr_up: indicates driver up/down status.
+ * @tx_realloc: number of tx packets realloced for headroom.
+ * @dstats: dongle-based statistical data.
+ * @align: alignment requirement for the bus.
+ * @dcmd_list: bus/device specific dongle initialization commands.
+ */
 struct brcmf_bus {
 	union {
 		struct brcmf_sdio_dev *sdio;
 		struct brcmf_usbdev *usb;
 	} bus_priv;
-	struct brcmf_pub *drvr;	/* pointer to driver pub structure brcmf_pub */
+	struct device *dev;
+	struct brcmf_pub *drvr;
 	enum brcmf_bus_state state;
-	uint maxctl;		/* Max size rxctl request from proto to bus */
-	bool drvr_up;		/* Status flag of driver up/down */
-	unsigned long tx_realloc;	/* Tx packets realloced for headroom */
-	struct dngl_stats dstats;	/* Stats for dongle-based data */
-	u8 align;		/* bus alignment requirement */
+	uint maxctl;
+	bool drvr_up;
+	unsigned long tx_realloc;
+	struct dngl_stats dstats;
+	u8 align;
 	struct list_head dcmd_list;
 
-	/* interface functions pointers */
-	/* Stop bus module: clear pending frames, disable data flow */
-	void (*brcmf_bus_stop)(struct device *);
-	/* Initialize bus module: prepare for communication w/dongle */
-	int (*brcmf_bus_init)(struct device *);
-	/* Send a data frame to the dongle.  Callee disposes of txp. */
-	int (*brcmf_bus_txdata)(struct device *, struct sk_buff *);
-	/* Send/receive a control message to/from the dongle.
-	 * Expects caller to enforce a single outstanding transaction.
-	 */
-	int (*brcmf_bus_txctl)(struct device *, unsigned char *, uint);
-	int (*brcmf_bus_rxctl)(struct device *, unsigned char *, uint);
+	struct brcmf_bus_ops *ops;
 };
 
 /*
+ * callback wrappers
+ */
+static inline int brcmf_bus_init(struct brcmf_bus *bus)
+{
+	return bus->ops->init(bus->dev);
+}
+
+static inline void brcmf_bus_stop(struct brcmf_bus *bus)
+{
+	bus->ops->stop(bus->dev);
+}
+
+static inline int brcmf_bus_txdata(struct brcmf_bus *bus, struct sk_buff *skb)
+{
+	return bus->ops->txdata(bus->dev, skb);
+}
+
+static inline
+int brcmf_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint len)
+{
+	return bus->ops->txctl(bus->dev, msg, len);
+}
+
+static inline
+int brcmf_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint len)
+{
+	return bus->ops->rxctl(bus->dev, msg, len);
+}
+
+/*
  * interface functions from common layer
  */
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 87536d3..b123d25 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -117,9 +117,7 @@ static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 		len = CDC_MAX_MSG_SIZE;
 
 	/* Send request */
-	return drvr->bus_if->brcmf_bus_txctl(drvr->dev,
-					     (unsigned char *)&prot->msg,
-					     len);
+	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&prot->msg, len);
 }
 
 static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
@@ -128,11 +126,10 @@ static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	struct brcmf_proto *prot = drvr->prot;
 
 	brcmf_dbg(TRACE, "Enter\n");
-
+	len += sizeof(struct brcmf_proto_cdc_dcmd);
 	do {
-		ret = drvr->bus_if->brcmf_bus_rxctl(drvr->dev,
-				(unsigned char *)&prot->msg,
-				len + sizeof(struct brcmf_proto_cdc_dcmd));
+		ret = brcmf_bus_rxctl(drvr->bus_if, (unsigned char *)&prot->msg,
+				      len);
 		if (ret < 0)
 			break;
 	} while (CDC_DCMD_ID(le32_to_cpu(prot->msg.flags)) != id);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 7e58e8c..57671ed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -20,6 +20,7 @@
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include "dhd.h"
+#include "dhd_bus.h"
 #include "dhd_dbg.h"
 
 static struct dentry *root_folder;
@@ -42,10 +43,12 @@ void brcmf_debugfs_exit(void)
 
 int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 {
+	struct device *dev = drvr->bus_if->dev;
+
 	if (!root_folder)
 		return -ENODEV;
 
-	drvr->dbgfs_dir = debugfs_create_dir(dev_name(drvr->dev), root_folder);
+	drvr->dbgfs_dir = debugfs_create_dir(dev_name(dev), root_folder);
 	return PTR_RET(drvr->dbgfs_dir);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index b6c86b0..421b49c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -219,7 +219,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	brcmf_proto_hdrpush(drvr, ifp->idx, skb);
 
 	/* Use bus module to send data frame */
-	ret =  drvr->bus_if->brcmf_bus_txdata(drvr->dev, skb);
+	ret =  brcmf_bus_txdata(drvr->bus_if, skb);
 
 done:
 	if (ret)
@@ -397,7 +397,7 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *ndev,
 
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", drvr->drv_version);
-	sprintf(info->bus_info, "%s", dev_name(drvr->dev));
+	sprintf(info->bus_info, "%s", dev_name(drvr->bus_if->dev));
 }
 
 static const struct ethtool_ops brcmf_ethtool_ops = {
@@ -753,7 +753,6 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 	drvr->hdrlen = bus_hdrlen;
 	drvr->bus_if = dev_get_drvdata(dev);
 	drvr->bus_if->drvr = drvr;
-	drvr->dev = dev;
 
 	/* create device debugfs folder */
 	brcmf_debugfs_attach(drvr);
@@ -790,7 +789,7 @@ int brcmf_bus_start(struct device *dev)
 	brcmf_dbg(TRACE, "\n");
 
 	/* Bring up the bus */
-	ret = bus_if->brcmf_bus_init(dev);
+	ret = brcmf_bus_init(bus_if);
 	if (ret != 0) {
 		brcmf_dbg(ERROR, "brcmf_sdbrcm_bus_init failed %d\n", ret);
 		return ret;
@@ -809,7 +808,7 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		goto fail;
 
-	drvr->config = brcmf_cfg80211_attach(drvr);
+	drvr->config = brcmf_cfg80211_attach(drvr, bus_if->dev);
 	if (drvr->config == NULL) {
 		ret = -ENOMEM;
 		goto fail;
@@ -842,7 +841,7 @@ static void brcmf_bus_detach(struct brcmf_pub *drvr)
 		brcmf_proto_stop(drvr);
 
 		/* Stop the bus module */
-		drvr->bus_if->brcmf_bus_stop(drvr->dev);
+		brcmf_bus_stop(drvr->bus_if);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4572545..f2293bb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3883,6 +3883,14 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 	brcmf_dbg(TRACE, "Disconnected\n");
 }
 
+static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
+	.stop = brcmf_sdbrcm_bus_stop,
+	.init = brcmf_sdbrcm_bus_init,
+	.txdata = brcmf_sdbrcm_bus_txdata,
+	.txctl = brcmf_sdbrcm_bus_txctl,
+	.rxctl = brcmf_sdbrcm_bus_rxctl,
+};
+
 void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
@@ -3946,11 +3954,9 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	spin_lock_init(&bus->dpc_tl_lock);
 
 	/* Assign bus interface call back */
-	bus->sdiodev->bus_if->brcmf_bus_stop = brcmf_sdbrcm_bus_stop;
-	bus->sdiodev->bus_if->brcmf_bus_init = brcmf_sdbrcm_bus_init;
-	bus->sdiodev->bus_if->brcmf_bus_txdata = brcmf_sdbrcm_bus_txdata;
-	bus->sdiodev->bus_if->brcmf_bus_txctl = brcmf_sdbrcm_bus_txctl;
-	bus->sdiodev->bus_if->brcmf_bus_rxctl = brcmf_sdbrcm_bus_rxctl;
+	bus->sdiodev->bus_if->dev = bus->sdiodev->dev;
+	bus->sdiodev->bus_if->ops = &brcmf_sdio_bus_ops;
+
 	/* Attach to the brcmf/OS/network interface */
 	ret = brcmf_attach(SDPCM_RESERVE, bus->sdiodev->dev);
 	if (ret != 0) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 39a5baa..5eb7bf8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -1228,6 +1228,14 @@ error:
 	return NULL;
 }
 
+static struct brcmf_bus_ops brcmf_usb_bus_ops = {
+	.txdata = brcmf_usb_tx,
+	.init = brcmf_usb_up,
+	.stop = brcmf_usb_down,
+	.txctl = brcmf_usb_tx_ctlpkt,
+	.rxctl = brcmf_usb_rx_ctlpkt,
+};
+
 static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 {
 	struct brcmf_bus *bus = NULL;
@@ -1246,14 +1254,11 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 		goto fail;
 	}
 
+	bus->dev = dev;
 	bus_pub->bus = bus;
-	bus->brcmf_bus_txdata = brcmf_usb_tx;
-	bus->brcmf_bus_init = brcmf_usb_up;
-	bus->brcmf_bus_stop = brcmf_usb_down;
-	bus->brcmf_bus_txctl = brcmf_usb_tx_ctlpkt;
-	bus->brcmf_bus_rxctl = brcmf_usb_rx_ctlpkt;
 	bus->bus_priv.usb = bus_pub;
 	dev_set_drvdata(dev, bus);
+	bus->ops = &brcmf_usb_bus_ops;
 
 	/* Attach to the common driver interface */
 	ret = brcmf_attach(0, dev);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 96bc349..4ddd58f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4271,10 +4271,10 @@ static void wl_deinit_priv(struct brcmf_cfg80211_info *cfg)
 	brcmf_deinit_priv_mem(cfg);
 }
 
-struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr)
+struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
+						  struct device *busdev)
 {
 	struct net_device *ndev = drvr->iflist[0]->ndev;
-	struct device *busdev = drvr->dev;
 	struct brcmf_cfg80211_info *cfg;
 	struct wiphy *wiphy;
 	struct brcmf_cfg80211_vif *vif;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index d60de18..c163e4d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -450,7 +450,8 @@ brcmf_cfg80211_connect_info *cfg_to_conn(struct brcmf_cfg80211_info *cfg)
 	return &cfg->conn_info;
 }
 
-struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr);
+struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
+						  struct device *busdev);
 void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
 s32 brcmf_cfg80211_up(struct net_device *ndev);
 s32 brcmf_cfg80211_down(struct net_device *ndev);
-- 
1.7.9.5


