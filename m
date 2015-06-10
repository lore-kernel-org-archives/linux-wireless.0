Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:55316 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbbFJWMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 18:12:31 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/7] brcmfmac: have sdio return -EIO when device communication is not possible
Date: Thu, 11 Jun 2015 00:12:20 +0200
Message-ID: <1433974343-16982-5-git-send-email-arend@broadcom.com> (sfid-20150611_001239_693147_E55B9AFA)
In-Reply-To: <1433974343-16982-1-git-send-email-arend@broadcom.com>
References: <1433974343-16982-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bus interface functions txctl and rxctl may be used while the device
can not be accessed, eg. upon driver .remove() callback. This patch will
immediately return -EIO when this is the case which speeds up the module
unload.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 1 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio.c   | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 71779b9..410a664 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -988,6 +988,7 @@ static void brcmf_sdiod_freezer_detach(struct brcmf_sdio_dev *sdiodev)
 
 static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
 {
+	sdiodev->state = BRCMF_SDIOD_DOWN;
 	if (sdiodev->bus) {
 		brcmf_sdio_remove(sdiodev->bus);
 		sdiodev->bus = NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
index bf7a8b1..d36f5f3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
@@ -2820,6 +2820,8 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter: pkt: data %p len %d\n", pkt->data, pkt->len);
+	if (sdiodev->state != BRCMF_SDIOD_DATA)
+		return -EIO;
 
 	/* Add space for the header */
 	skb_push(pkt, bus->tx_hdrlen);
@@ -2948,6 +2950,8 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 	int ret;
 
 	brcmf_dbg(TRACE, "Enter\n");
+	if (sdiodev->state != BRCMF_SDIOD_DATA)
+		return -EIO;
 
 	/* Send from dpc */
 	bus->ctrl_frame_buf = msg;
@@ -3238,6 +3242,8 @@ brcmf_sdio_bus_rxctl(struct device *dev, unsigned char *msg, uint msglen)
 	struct brcmf_sdio *bus = sdiodev->bus;
 
 	brcmf_dbg(TRACE, "Enter\n");
+	if (sdiodev->state != BRCMF_SDIOD_DATA)
+		return -EIO;
 
 	/* Wait until control frame is available */
 	timeleft = brcmf_sdio_dcmd_resp_wait(bus, &bus->rxlen, &pending);
-- 
1.9.1

