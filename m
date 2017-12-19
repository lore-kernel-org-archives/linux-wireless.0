Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35072 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967274AbdLSMr3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:47:29 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 03/11] brcmfmac: stabilise the value of ->sbwad in use for some xfer routines.
Date: Tue, 19 Dec 2017 13:47:09 +0100
Message-Id: <1513687637-5555-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171219_134748_368626_2B241B4C)
In-Reply-To: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

The IO functions operate within the Chipcommon IO window. Explicitly
set this, rather than relying on the last initialisation IO access to
leave it set to the right value by chance.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 5 +++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h   | 1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index f8b47c1..29a2d1e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -529,7 +529,7 @@ int brcmf_sdiod_recv_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 
 int brcmf_sdiod_recv_pkt(struct brcmf_sdio_dev *sdiodev, struct sk_buff *pkt)
 {
-	u32 addr = sdiodev->sbwad;
+	u32 addr = sdiodev->cc_core->base;
 	int err = 0;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pkt->len);
@@ -552,7 +552,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 {
 	struct sk_buff *glom_skb = NULL;
 	struct sk_buff *skb;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = sdiodev->cc_core->base;
 	int err = 0;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n",
@@ -593,7 +593,7 @@ int brcmf_sdiod_recv_chain(struct brcmf_sdio_dev *sdiodev,
 int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
 {
 	struct sk_buff *mypkt;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = sdiodev->cc_core->base;
 	int err;
 
 	mypkt = brcmu_pkt_buf_get_skb(nbytes);
@@ -625,7 +625,7 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
 			 struct sk_buff_head *pktq)
 {
 	struct sk_buff *skb;
-	u32 addr = sdiodev->sbwad;
+	u32 addr = sdiodev->cc_core->base;
 	int err;
 
 	brcmf_dbg(SDIO, "addr = 0x%x, size = %d\n", addr, pktq->qlen);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index cc409c7..e334476 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3842,6 +3842,11 @@ static void brcmf_sdio_buscore_write32(void *ctx, u32 addr, u32 val)
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
index 01def16..ac5f814 100644
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
1.9.1
