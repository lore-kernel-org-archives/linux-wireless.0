Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3237 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab3KFWHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 17:07:39 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/7] brcmfmac: replace dongle command list with
 .preinit() callback
Date: Wed, 6 Nov 2013 23:07:18 +0100
Message-ID: <1383775642-647-4-git-send-email-arend@broadcom.com> (sfid-20131106_230756_916183_5F6BD9B6)
In-Reply-To: <1383775642-647-1-git-send-email-arend@broadcom.com>
References: <1383775642-647-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bus-specific interface allowed a list of dongle commands to be
provided to the common driver part. However, upcoming functionality
requires a more dynamic behaviour. Hence the list is replaced
by a new callback function so the bus-specific driver part can
implement this behaviour.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  | 12 ++++-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   | 15 +-----
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    | 10 +++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 58 +++++++++++-----------
 4 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 392fc28..dfa9bdd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -34,6 +34,7 @@ struct brcmf_bus_dcmd {
 /**
  * struct brcmf_bus_ops - bus callback operations.
  *
+ * @preinit: execute bus/device specific dongle init commands (optional).
  * @init: prepare for communication with dongle.
  * @stop: clear pending frames, disable data flow.
  * @txdata: send a data frame to the dongle. When the data
@@ -51,6 +52,7 @@ struct brcmf_bus_dcmd {
  * indicated otherwise these callbacks are mandatory.
  */
 struct brcmf_bus_ops {
+	int (*preinit)(struct device *dev);
 	int (*init)(struct device *dev);
 	void (*stop)(struct device *dev);
 	int (*txdata)(struct device *dev, struct sk_buff *skb);
@@ -85,7 +87,6 @@ struct brcmf_bus {
 	unsigned long tx_realloc;
 	u32 chip;
 	u32 chiprev;
-	struct list_head dcmd_list;
 
 	struct brcmf_bus_ops *ops;
 };
@@ -93,6 +94,13 @@ struct brcmf_bus {
 /*
  * callback wrappers
  */
+static inline int brcmf_bus_preinit(struct brcmf_bus *bus)
+{
+	if (!bus->ops->preinit)
+		return 0;
+	return bus->ops->preinit(bus->dev);
+}
+
 static inline int brcmf_bus_init(struct brcmf_bus *bus)
 {
 	return bus->ops->init(bus->dev);
@@ -152,6 +160,8 @@ extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
 			     bool success);
 
 extern int brcmf_bus_start(struct device *dev);
+extern s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data,
+				u32 len);
 extern void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
 
 #ifdef CONFIG_BRCMFMAC_SDIO
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 9431af2..5c0c919 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -257,8 +257,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	u8 buf[BRCMF_DCMD_SMLEN];
 	char *ptr;
 	s32 err;
-	struct brcmf_bus_dcmd *cmdlst;
-	struct list_head *cur, *q;
 
 	/* retreive mac address */
 	err = brcmf_fil_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
@@ -342,17 +340,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	brcmf_c_pktfilter_offload_enable(ifp, BRCMF_DEFAULT_PACKET_FILTER,
 					 0, true);
 
-	/* set bus specific command if there is any */
-	list_for_each_safe(cur, q, &ifp->drvr->bus_if->dcmd_list) {
-		cmdlst = list_entry(cur, struct brcmf_bus_dcmd, list);
-		if (cmdlst->name && cmdlst->param && cmdlst->param_len) {
-			brcmf_fil_iovar_data_set(ifp, cmdlst->name,
-						 cmdlst->param,
-						 cmdlst->param_len);
-		}
-		list_del(cur);
-		kfree(cmdlst);
-	}
+	/* do bus specific preinit here */
+	err = brcmf_bus_preinit(ifp->drvr->bus_if);
 done:
 	return err;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 0c4c230..ab207e2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1048,8 +1048,6 @@ int brcmf_attach(struct device *dev)
 	/* attach firmware event handler */
 	brcmf_fweh_attach(drvr);
 
-	INIT_LIST_HEAD(&drvr->bus_if->dcmd_list);
-
 	return ret;
 
 fail:
@@ -1206,6 +1204,14 @@ void brcmf_detach(struct device *dev)
 	kfree(drvr);
 }
 
+s32 brcmf_iovar_data_set(struct device *dev, char *name, void *data, u32 len)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_if *ifp = bus_if->drvr->iflist[0];
+
+	return brcmf_fil_iovar_data_set(ifp, name, data, len);
+}
+
 static int brcmf_get_pend_8021x_cnt(struct brcmf_if *ifp)
 {
 	return atomic_read(&ifp->pend_8021x_cnt);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 928983b..2597a53 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3425,6 +3425,35 @@ brcmf_sdbrcm_download_firmware(struct brcmf_sdio *bus)
 	return ret;
 }
 
+static int brcmf_sdbrcm_bus_preinit(struct device *dev)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio *bus = sdiodev->bus;
+	u32 value;
+	u8 idx;
+	int err;
+
+	/* sdio bus core specific dcmd */
+	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
+	if (bus->ci->c_inf[idx].rev < 12) {
+		/* for sdio core rev < 12, disable txgloming */
+		value = 0;
+		err = brcmf_iovar_data_set(dev, "bus:txglom", &value,
+					   sizeof(u32));
+	} else {
+		/* otherwise, set txglomalign */
+		value = 4;
+		if (sdiodev->pdata)
+			value = sdiodev->pdata->sd_sgentry_align;
+		/* SDIO ADMA requires at least 32 bit alignment */
+		value = max_t(u32, value, 4);
+		err = brcmf_iovar_data_set(dev, "bus:txglomalign", &value,
+					   sizeof(u32));
+	}
+	return err;
+}
+
 static int brcmf_sdbrcm_bus_init(struct device *dev)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
@@ -3905,6 +3934,7 @@ static void brcmf_sdbrcm_release(struct brcmf_sdio *bus)
 
 static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.stop = brcmf_sdbrcm_bus_stop,
+	.preinit = brcmf_sdbrcm_bus_preinit,
 	.init = brcmf_sdbrcm_bus_init,
 	.txdata = brcmf_sdbrcm_bus_txdata,
 	.txctl = brcmf_sdbrcm_bus_txctl,
@@ -3916,10 +3946,6 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 {
 	int ret;
 	struct brcmf_sdio *bus;
-	struct brcmf_bus_dcmd *dlst;
-	u32 dngl_txglom;
-	u32 txglomalign = 0;
-	u8 idx;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -4003,30 +4029,6 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	brcmf_sdio_debugfs_create(bus);
 	brcmf_dbg(INFO, "completed!!\n");
 
-	/* sdio bus core specific dcmd */
-	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
-	dlst = kzalloc(sizeof(struct brcmf_bus_dcmd), GFP_KERNEL);
-	if (dlst) {
-		if (bus->ci->c_inf[idx].rev < 12) {
-			/* for sdio core rev < 12, disable txgloming */
-			dngl_txglom = 0;
-			dlst->name = "bus:txglom";
-			dlst->param = (char *)&dngl_txglom;
-			dlst->param_len = sizeof(u32);
-		} else {
-			/* otherwise, set txglomalign */
-			if (sdiodev->pdata)
-				txglomalign = sdiodev->pdata->sd_sgentry_align;
-			/* SDIO ADMA requires at least 32 bit alignment */
-			if (txglomalign < 4)
-				txglomalign = 4;
-			dlst->name = "bus:txglomalign";
-			dlst->param = (char *)&txglomalign;
-			dlst->param_len = sizeof(u32);
-		}
-		list_add(&dlst->list, &bus->sdiodev->bus_if->dcmd_list);
-	}
-
 	brcmf_bus_add_txhdrlen(bus->sdiodev->dev, bus->tx_hdrlen);
 
 	/* if firmware path present try to download and bring up bus */
-- 
1.8.1.3


