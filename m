Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4482 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760511Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/25] brcmfmac: add optional bus callback definition
 for tx queue cleanup
Date: Wed, 3 Apr 2013 12:40:38 +0200
Message-ID: <1364985650-11719-14-git-send-email-arend@broadcom.com> (sfid-20130403_124136_339608_35D5592B)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a callback to obtain packet queue from the bus-specific code
used to cleanup packet buffers from firmware-signalling code.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   13 ++++++-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   10 ++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   36 ++++++++++++++++++--
 3 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 883ef90..080395f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -39,10 +39,12 @@ struct brcmf_bus_dcmd {
  * @txdata: send a data frame to the dongle (callee disposes skb).
  * @txctl: transmit a control request message to dongle.
  * @rxctl: receive a control response message from dongle.
+ * @gettxq: obtain a reference of bus transmit queue (optional).
  *
  * This structure provides an abstract interface towards the
  * bus specific driver. For control messages to common driver
- * will assure there is only one active transaction.
+ * will assure there is only one active transaction. Unless
+ * indicated otherwise these callbacks are mandatory.
  */
 struct brcmf_bus_ops {
 	int (*init)(struct device *dev);
@@ -50,6 +52,7 @@ struct brcmf_bus_ops {
 	int (*txdata)(struct device *dev, struct sk_buff *skb);
 	int (*txctl)(struct device *dev, unsigned char *msg, uint len);
 	int (*rxctl)(struct device *dev, unsigned char *msg, uint len);
+	struct pktq * (*gettxq)(struct device *dev);
 };
 
 /**
@@ -115,6 +118,14 @@ int brcmf_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint len)
 	return bus->ops->rxctl(bus->dev, msg, len);
 }
 
+static inline
+struct pktq *brcmf_bus_gettxq(struct brcmf_bus *bus)
+{
+	if (!bus->ops->gettxq)
+		return ERR_PTR(-ENOENT);
+
+	return bus->ops->gettxq(bus->dev);
+}
 /*
  * interface functions from common layer
  */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f5f04ba..a5354e7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2293,6 +2293,15 @@ static void brcmf_sdbrcm_dpc(struct brcmf_sdio *bus)
 	}
 }
 
+static struct pktq *brcmf_sdbrcm_bus_gettxq(struct device *dev)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio *bus = sdiodev->bus;
+
+	return &bus->txq;
+}
+
 static int brcmf_sdbrcm_bus_txdata(struct device *dev, struct sk_buff *pkt)
 {
 	int ret = -EBADE;
@@ -3834,6 +3843,7 @@ static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.txdata = brcmf_sdbrcm_bus_txdata,
 	.txctl = brcmf_sdbrcm_bus_txctl,
 	.rxctl = brcmf_sdbrcm_bus_rxctl,
+	.gettxq = brcmf_sdbrcm_bus_gettxq,
 };
 
 void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index a6443c6..2afd850 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -25,6 +25,7 @@
 #include <brcmu_wifi.h>
 #include "dhd.h"
 #include "dhd_dbg.h"
+#include "dhd_bus.h"
 #include "fwil.h"
 #include "fweh.h"
 #include "fwsignal.h"
@@ -236,11 +237,11 @@ struct brcmf_skbuff_cb {
 #define BRCMF_SKB_HTOD_TAG_FREERUN_SHIFT			0
 
 #define brcmf_skb_htod_tag_set_field(skb, field, value) \
-	brcmu_maskset32(&(brcmf_skbcb(skb)->htod_tag), \
+	brcmu_maskset32(&(brcmf_skbcb(skb)->htod), \
 			BRCMF_SKB_HTOD_TAG_ ## field ## _MASK, \
 			BRCMF_SKB_HTOD_TAG_ ## field ## _SHIFT, (value))
 #define brcmf_skb_htod_tag_get_field(skb, field) \
-	brcmu_maskget32(brcmf_skbcb(skb)->htod_tag, \
+	brcmu_maskget32(brcmf_skbcb(skb)->htod, \
 			BRCMF_SKB_HTOD_TAG_ ## field ## _MASK, \
 			BRCMF_SKB_HTOD_TAG_ ## field ## _SHIFT)
 
@@ -548,6 +549,36 @@ static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_mac_descriptor *entry,
 	}
 }
 
+static void brcmf_fws_bus_txq_cleanup(struct brcmf_fws_info *fws,
+				      bool (*fn)(struct sk_buff *, void *),
+				      int ifidx)
+{
+	struct brcmf_fws_hanger_item *hi;
+	struct pktq *txq;
+	struct sk_buff *skb;
+	int prec;
+	u32 hslot;
+
+	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
+	txq = brcmf_bus_gettxq(fws->drvr->bus_if);
+	if (IS_ERR(txq)) {
+		brcmf_dbg(TRACE, "no txq to clean up\n");
+		return;
+	}
+
+	for (prec = 0; prec < txq->num_prec; prec++) {
+		skb = brcmu_pktq_pdeq_match(txq, prec, fn, &ifidx);
+		while (skb) {
+			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
+			hi = &fws->hanger.items[hslot];
+			WARN_ON(skb != hi->pkt);
+			hi->state = BRCMF_FWS_HANGER_ITEM_STATE_FREE;
+			brcmu_pkt_buf_free_skb(skb);
+			skb = brcmu_pktq_pdeq_match(txq, prec, fn, &ifidx);
+		}
+	}
+}
+
 static bool brcmf_fws_ifidx_match(struct sk_buff *skb, void *arg)
 {
 	u32 ifidx = brcmf_skb_if_flags_get_field(skb, INDEX);
@@ -573,6 +604,7 @@ static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 		brcmf_fws_mac_desc_cleanup(&table[i], matchfn, ifidx);
 
 	brcmf_fws_mac_desc_cleanup(&fws->other, matchfn, ifidx);
+	brcmf_fws_bus_txq_cleanup(fws, matchfn, ifidx);
 	brcmf_fws_hanger_cleanup(&fws->hanger, matchfn, ifidx);
 }
 
-- 
1.7.10.4


