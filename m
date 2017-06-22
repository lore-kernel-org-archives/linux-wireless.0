Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41336 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752711AbdFVKBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 06:01:09 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/4] brcmfmac: use atomic_t for statistic counter in struct brcmf_bus
Date: Thu, 22 Jun 2017 11:01:02 +0100
Message-Id: <1498125664-25980-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170622_120113_651614_82B8FC81)
In-Reply-To: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The statistic counter is used in common layer and in the bus layer
in different thread contexts so change to use atomic operations.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h  | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index e2c895b..e1a4d9e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -138,7 +138,7 @@ struct brcmf_bus {
 	struct brcmf_pub *drvr;
 	enum brcmf_bus_state state;
 	uint maxctl;
-	unsigned long tx_realloc;
+	atomic_t tx_realloc;
 	u32 chip;
 	u32 chiprev;
 	bool always_use_fws_queue;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 81f9594..a280536 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2046,7 +2046,7 @@ static int brcmf_sdio_txpkt_hdalign(struct brcmf_sdio *bus, struct sk_buff *pkt)
 	head_pad = ((unsigned long)dat_buf % bus->head_align);
 	if (head_pad) {
 		if (skb_headroom(pkt) < head_pad) {
-			bus->sdiodev->bus_if->tx_realloc++;
+			atomic_inc(&bus->sdiodev->bus_if->tx_realloc);
 			head_pad = 0;
 			if (skb_cow(pkt, head_pad))
 				return -ENOMEM;
-- 
1.9.1
