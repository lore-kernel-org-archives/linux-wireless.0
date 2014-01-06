Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:22541 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbaAFLlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 06:41:01 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/15] brcmfmac: cleanup helper functions in sdio remove path
Date: Mon, 6 Jan 2014 12:40:39 +0100
Message-ID: <1389008450-28529-5-git-send-email-arend@broadcom.com> (sfid-20140106_124116_874633_760F85A7)
In-Reply-To: <1389008450-28529-1-git-send-email-arend@broadcom.com>
References: <1389008450-28529-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two helper functions in the sdio remove path were very thin and
only used once. So its code is moved to the calling function.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   39 +++++---------------
 1 file changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index f214510..27fbcbf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3750,15 +3750,6 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 	}
 }
 
-static void brcmf_sdio_release_malloc(struct brcmf_sdio *bus)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	kfree(bus->rxbuf);
-	bus->rxctl = bus->rxbuf = NULL;
-	bus->rxlen = 0;
-}
-
 static bool brcmf_sdio_probe_malloc(struct brcmf_sdio *bus)
 {
 	brcmf_dbg(TRACE, "Enter\n");
@@ -3955,24 +3946,6 @@ brcmf_sdio_watchdog(unsigned long data)
 	}
 }
 
-static void brcmf_sdio_release_dongle(struct brcmf_sdio *bus)
-{
-	brcmf_dbg(TRACE, "Enter\n");
-
-	if (bus->ci) {
-		sdio_claim_host(bus->sdiodev->func[1]);
-		brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
-		brcmf_sdio_clkctl(bus, CLK_NONE, false);
-		sdio_release_host(bus->sdiodev->func[1]);
-		brcmf_sdio_chip_detach(&bus->ci);
-		if (bus->vars && bus->varsz)
-			kfree(bus->vars);
-		bus->vars = NULL;
-	}
-
-	brcmf_dbg(TRACE, "Disconnected\n");
-}
-
 static struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.stop = brcmf_sdio_bus_stop,
 	.preinit = brcmf_sdio_bus_preinit,
@@ -4108,12 +4081,20 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 
 		if (bus->sdiodev->bus_if->drvr) {
 			brcmf_detach(bus->sdiodev->dev);
-			brcmf_sdio_release_dongle(bus);
+		}
+
+		if (bus->ci) {
+			sdio_claim_host(bus->sdiodev->func[1]);
+			brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
+			brcmf_sdio_clkctl(bus, CLK_NONE, false);
+			sdio_release_host(bus->sdiodev->func[1]);
+			brcmf_sdio_chip_detach(&bus->ci);
 		}
 
 		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
-		brcmf_sdio_release_malloc(bus);
+		kfree(bus->rxbuf);
 		kfree(bus->hdrbuf);
+		kfree(bus->vars);
 		kfree(bus);
 	}
 
-- 
1.7.10.4

