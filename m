Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39109 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaBYTas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:48 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/14] brcmfmac: Remove immediate sleep support from SDIO.
Date: Tue, 25 Feb 2014 20:30:32 +0100
Message-ID: <1393356639-19169-9-git-send-email-arend@broadcom.com> (sfid-20140225_203055_285900_6602853D)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Immediate sleep support is an aggressive power saving option
that has not been enabled in brcmfmac and is removed to
simplify code.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index cc0f1ad..04f5e32c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -304,7 +304,6 @@ struct rte_console {
 /* Flags for SDH calls */
 #define F2SYNC	(SDIO_REQ_4BYTE | SDIO_REQ_FIXED)
 
-#define BRCMF_IDLE_IMMEDIATE	(-1)	/* Enter idle immediately */
 #define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
 					 * when idle
 					 */
@@ -2662,16 +2661,6 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 		    data_ok(bus)) || PKT_AVAILABLE()) {
 		atomic_inc(&bus->dpc_tskcnt);
 	}
-
-	/* If we're done for now, turn off clock request. */
-	if ((bus->clkstate != CLK_PENDING)
-	    && bus->idletime == BRCMF_IDLE_IMMEDIATE) {
-		bus->activity = false;
-		brcmf_dbg(SDIO, "idle state\n");
-		sdio_claim_host(bus->sdiodev->func[1]);
-		brcmf_sdio_bus_sleep(bus, true, false);
-		sdio_release_host(bus->sdiodev->func[1]);
-	}
 }
 
 static struct pktq *brcmf_sdio_bus_gettxq(struct device *dev)
@@ -2948,15 +2937,6 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 		} while (ret < 0 && retries++ < TXRETRIES);
 	}
 
-	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) &&
-	    atomic_read(&bus->dpc_tskcnt) == 0) {
-		bus->activity = false;
-		sdio_claim_host(bus->sdiodev->func[1]);
-		brcmf_dbg(INFO, "idle\n");
-		brcmf_sdio_clkctl(bus, CLK_NONE, true);
-		sdio_release_host(bus->sdiodev->func[1]);
-	}
-
 	if (ret)
 		bus->sdcnt.tx_ctlerrs++;
 	else
-- 
1.7.10.4

