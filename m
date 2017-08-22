Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:59150 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932575AbdHVLoV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:44:21 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 23/30] brcmfmac: stabilise the value of ->sbwad in use for some xfer routines.
Date: Tue, 22 Aug 2017 12:25:43 +0100
Message-Id: <20170822112550.60311-24-ian@mnementh.co.uk> (sfid-20170822_134428_593238_C26F3F6E)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IO functions operate within the Chipcommon IO window. Explicitly
set this, rather than relying on the last initialisation IO access to
leave it set to the right value by chance.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 5 +++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index cabfab9a02a2..eeddefeef9b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -527,7 +527,7 @@ int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 {
-	u32 addr = sdiodev->sbwad;
+	u32 addr = sdiodev->cc_core->base;
 	int err = 0;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
@@ -550,7 +550,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 {
 	struct sk_buff *glom_skb = NULL;
 	struct sk_buff *skb;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = sdiodev->cc_core->base;
 	int err = 0;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
@@ -591,7 +591,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = sdiodev->cc_core->base;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
@@ -623,7 +623,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 			 struct sk_buff_head *pktq)
 {
 	struct sk_buff *skb;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = sdiodev->cc_core->base;
 	int err;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 09b4db117e0d..62561782ab90 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3833,6 +3833,11 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	if (!bus->sdio_core)
 		goto fail;
 
+	/* Pick up the CHIPCOMMON core info struct, for bulk IO in bcmsdh.c */
+	sdiodev->cc_core = brcmf_chip_get_core(bus->ci, BCMA_CORE_CHIPCOMMON);
+	if (!sdiodev->cc_core)
+		goto fail;
+
 	sdiodev->settings = brcmf_get_module_param(sdiodev->dev,
 						   BRCMF_BUSTYPE_SDIO,
 						   bus->ci->chip,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 01def16cd236..ac5f814ff019 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -178,6 +178,7 @@ struct brcmf_sdio_dev {
 	struct sdio_func *func[SDIO_MAX_FUNCS];
 	u8 num_funcs;			/* Supported funcs on client */
 	u32 sbwad;			/* Save backplane window address */
+	struct brcmf_core *cc_core;	/* chipcommon core info struct */
 	struct brcmf_sdio *bus;
 	struct device *dev;
 	struct brcmf_bus *bus_if;
-- 
2.11.0
