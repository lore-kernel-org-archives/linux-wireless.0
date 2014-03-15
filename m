Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45742 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbaCOQSe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 12:18:34 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/5] brcmfmac: assure active clock request upon entering SLEEP state
Date: Sat, 15 Mar 2014 17:18:20 +0100
Message-ID: <1394900301-15417-5-git-send-email-arend@broadcom.com> (sfid-20140315_171837_505681_F08880F5)
In-Reply-To: <1394900301-15417-1-git-send-email-arend@broadcom.com>
References: <1394900301-15417-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the SDIO driver goes in low power state it must assure that
a clock request in ChipCLKCSR is set. Otherwise waking up the
device can fail. The register is read and if necessary the ALP
clock will be requested.

Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   39 ++++++++++++++------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index bcdaf72..859eddd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -175,6 +175,7 @@ struct rte_console {
 #define SBSDIO_ALP_AVAIL		0x40
 /* Status: HT is ready */
 #define SBSDIO_HT_AVAIL			0x80
+#define SBSDIO_CSR_MASK			0x1F
 #define SBSDIO_AVBITS		(SBSDIO_HT_AVAIL | SBSDIO_ALP_AVAIL)
 #define SBSDIO_ALPAV(regval)	((regval) & SBSDIO_AVBITS)
 #define SBSDIO_HTAV(regval)	(((regval) & SBSDIO_AVBITS) == SBSDIO_AVBITS)
@@ -720,16 +721,12 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 	int err = 0;
 	int try_cnt = 0;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(TRACE, "Enter: on=%d\n", on);
 
 	wr_val = (on << SBSDIO_FUNC1_SLEEPCSR_KSO_SHIFT);
 	/* 1st KSO write goes to AOS wake up core if device is asleep  */
 	brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 			  wr_val, &err);
-	if (err) {
-		brcmf_err("SDIO_AOS KSO write error: %d\n", err);
-		return err;
-	}
 
 	if (on) {
 		/* device WAKEUP through KSO:
@@ -759,13 +756,19 @@ brcmf_sdio_kso_control(struct brcmf_sdio *bus, bool on)
 					   &err);
 		if (((rd_val & bmask) == cmp_val) && !err)
 			break;
-		brcmf_dbg(SDIO, "KSO wr/rd retry:%d (max: %d) ERR:%x\n",
-			  try_cnt, MAX_KSO_ATTEMPTS, err);
+
 		udelay(KSO_WAIT_US);
 		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR,
 				  wr_val, &err);
 	} while (try_cnt++ < MAX_KSO_ATTEMPTS);
 
+	if (try_cnt > 2)
+		brcmf_dbg(SDIO, "try_cnt=%d rd_val=0x%x err=%d\n", try_cnt,
+			  rd_val, err);
+
+	if (try_cnt > MAX_KSO_ATTEMPTS)
+		brcmf_err("max tries: rd_val=0x%x err=%d\n", rd_val, err);
+
 	return err;
 }
 
@@ -966,6 +969,7 @@ static int
 brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 {
 	int err = 0;
+	u8 clkcsr;
 
 	brcmf_dbg(SDIO, "Enter: request %s currently %s\n",
 		  (sleep ? "SLEEP" : "WAKE"),
@@ -984,8 +988,20 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 			    atomic_read(&bus->ipend) > 0 ||
 			    (!atomic_read(&bus->fcstate) &&
 			    brcmu_pktq_mlen(&bus->txq, ~bus->flowcontrol) &&
-			    data_ok(bus)))
-				 return -EBUSY;
+			    data_ok(bus))) {
+				 err = -EBUSY;
+				 goto done;
+			}
+
+			clkcsr = brcmf_sdiod_regrb(bus->sdiodev,
+						   SBSDIO_FUNC1_CHIPCLKCSR,
+						   &err);
+			if ((clkcsr & SBSDIO_CSR_MASK) == 0) {
+				brcmf_dbg(SDIO, "no clock, set ALP\n");
+				brcmf_sdiod_regwb(bus->sdiodev,
+						  SBSDIO_FUNC1_CHIPCLKCSR,
+						  SBSDIO_ALP_AVAIL_REQ, &err);
+			}
 			err = brcmf_sdio_kso_control(bus, false);
 			/* disable watchdog */
 			if (!err)
@@ -1002,7 +1018,7 @@ brcmf_sdio_bus_sleep(struct brcmf_sdio *bus, bool sleep, bool pendok)
 		} else {
 			brcmf_err("error while changing bus sleep state %d\n",
 				  err);
-			return err;
+			goto done;
 		}
 	}
 
@@ -1014,7 +1030,8 @@ end:
 	} else {
 		brcmf_sdio_clkctl(bus, CLK_AVAIL, pendok);
 	}
-
+done:
+	brcmf_dbg(SDIO, "Exit: err=%d\n", err);
 	return err;
 
 }
-- 
1.7.9.5

