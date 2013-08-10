Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2726 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968554Ab3HJK14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/12] brcmfmac: remove align from brcmf_bus structure
Date: Sat, 10 Aug 2013 12:27:27 +0200
Message-ID: <1376130450-29746-10-git-send-email-arend@broadcom.com> (sfid-20130810_123908_931126_89A007AB)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

remove align from brcmf_bus since it is only used by sdio bus layer internally

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |  2 --
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 25 +++++++++++++++-------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 289e386..64f4a2b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -350,7 +350,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 	sdiodev->bus_if = bus_if;
 	bus_if->bus_priv.sdio = sdiodev;
-	bus_if->align = BRCMF_SDALIGN;
 	dev_set_drvdata(&func->dev, bus_if);
 	dev_set_drvdata(&sdiodev->func[1]->dev, bus_if);
 	sdiodev->dev = &sdiodev->func[1]->dev;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 9249b6d..f7c1985 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -69,7 +69,6 @@ struct brcmf_bus_ops {
  * @maxctl: maximum size for rxctl request message.
  * @tx_realloc: number of tx packets realloced for headroom.
  * @dstats: dongle-based statistical data.
- * @align: alignment requirement for the bus.
  * @dcmd_list: bus/device specific dongle initialization commands.
  * @chip: device identifier of the dongle chip.
  * @chiprev: revision of the dongle chip.
@@ -84,7 +83,6 @@ struct brcmf_bus {
 	enum brcmf_bus_state state;
 	uint maxctl;
 	unsigned long tx_realloc;
-	u8 align;
 	u32 chip;
 	u32 chiprev;
 	struct list_head dcmd_list;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index aa4caca..2563875 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1166,7 +1166,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 {
 	u16 dlen, totlen;
 	u8 *dptr, num = 0;
-
+	u32 align = 0;
 	u16 sublen;
 	struct sk_buff *pfirst, *pnext;
 
@@ -1181,6 +1181,11 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 	brcmf_dbg(SDIO, "start: glomd %p glom %p\n",
 		  bus->glomd, skb_peek(&bus->glom));
 
+	if (bus->sdiodev->pdata)
+		align = bus->sdiodev->pdata->sd_sgentry_align;
+	if (align < 4)
+		align = 4;
+
 	/* If there's a descriptor, generate the packet chain */
 	if (bus->glomd) {
 		pfirst = pnext = NULL;
@@ -1204,9 +1209,9 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 				pnext = NULL;
 				break;
 			}
-			if (sublen % BRCMF_SDALIGN) {
+			if (sublen % align) {
 				brcmf_err("sublen %d not multiple of %d\n",
-					  sublen, BRCMF_SDALIGN);
+					  sublen, align);
 			}
 			totlen += sublen;
 
@@ -1219,7 +1224,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			}
 
 			/* Allocate/chain packet for next subframe */
-			pnext = brcmu_pkt_buf_get_skb(sublen + BRCMF_SDALIGN);
+			pnext = brcmu_pkt_buf_get_skb(sublen + align);
 			if (pnext == NULL) {
 				brcmf_err("bcm_pkt_buf_get_skb failed, num %d len %d\n",
 					  num, sublen);
@@ -1228,7 +1233,7 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			skb_queue_tail(&bus->glom, pnext);
 
 			/* Adhere to start alignment requirements */
-			pkt_align(pnext, sublen, BRCMF_SDALIGN);
+			pkt_align(pnext, sublen, align);
 		}
 
 		/* If all allocations succeeded, save packet chain
@@ -3832,7 +3837,7 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 	struct brcmf_sdio *bus;
 	struct brcmf_bus_dcmd *dlst;
 	u32 dngl_txglom;
-	u32 dngl_txglomalign;
+	u32 txglomalign = 0;
 	u8 idx;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -3926,9 +3931,13 @@ void *brcmf_sdbrcm_probe(u32 regsva, struct brcmf_sdio_dev *sdiodev)
 			dlst->param_len = sizeof(u32);
 		} else {
 			/* otherwise, set txglomalign */
-			dngl_txglomalign = bus->sdiodev->bus_if->align;
+			if (sdiodev->pdata)
+				txglomalign = sdiodev->pdata->sd_sgentry_align;
+			/* SDIO ADMA requires at least 32 bit alignment */
+			if (txglomalign < 4)
+				txglomalign = 4;
 			dlst->name = "bus:txglomalign";
-			dlst->param = (char *)&dngl_txglomalign;
+			dlst->param = (char *)&txglomalign;
 			dlst->param_len = sizeof(u32);
 		}
 		list_add(&dlst->list, &bus->sdiodev->bus_if->dcmd_list);
-- 
1.8.1.3


