Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2410 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab1JBRO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:14:59 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/20] staging: brcm80211: reduce indentation level in
 dhd_sdio.c #3
Date: Sun, 2 Oct 2011 10:14:37 -0700
Message-ID: <1317575685-3156-13-git-send-email-frankyl@broadcom.com> (sfid-20111002_191511_039632_CE163139)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

By introducing 1 new function.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |   85 +++++++++++++------------
 1 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index cabf912..0def6e3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2960,6 +2960,48 @@ break2:
 }
 #endif				/* BCMDBG */
 
+static int brcmf_tx_frame(struct brcmf_bus *bus, u8 *frame, u16 len)
+{
+	int i;
+	int ret;
+
+	bus->ctrl_frame_stat = false;
+	ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
+				    SDIO_FUNC_2, F2SYNC, frame, len, NULL);
+
+	if (ret < 0) {
+		/* On failure, abort the command and terminate the frame */
+		brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
+			  ret);
+		bus->tx_sderrs++;
+
+		brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
+
+		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
+				       SBSDIO_FUNC1_FRAMECTRL,
+				       SFC_WF_TERM, NULL);
+		bus->f1regdata++;
+
+		for (i = 0; i < 3; i++) {
+			u8 hi, lo;
+			hi = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+						   SBSDIO_FUNC1_WFRAMEBCHI,
+						   NULL);
+			lo = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
+						   SBSDIO_FUNC1_WFRAMEBCLO,
+						   NULL);
+			bus->f1regdata += 2;
+			if (hi == 0 && lo == 0)
+				break;
+		}
+		return ret;
+	}
+
+	bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
+
+	return ret;
+}
+
 int
 brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 {
@@ -2969,7 +3011,6 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	uint retries = 0;
 	u8 doff = 0;
 	int ret = -1;
-	int i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -3060,46 +3101,8 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 #endif
 
 		do {
-			bus->ctrl_frame_stat = false;
-			ret = brcmf_sdbrcm_send_buf(bus, bus->sdiodev->sbwad,
-					SDIO_FUNC_2, F2SYNC, frame, len, NULL);
-
-			if (ret < 0) {
-				/* On failure, abort the command and
-				 terminate the frame */
-				brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-					  ret);
-				bus->tx_sderrs++;
-
-				brcmf_sdcard_abort(bus->sdiodev, SDIO_FUNC_2);
-
-				brcmf_sdcard_cfg_write(bus->sdiodev,
-						 SDIO_FUNC_1,
-						 SBSDIO_FUNC1_FRAMECTRL,
-						 SFC_WF_TERM, NULL);
-				bus->f1regdata++;
-
-				for (i = 0; i < 3; i++) {
-					u8 hi, lo;
-					hi = brcmf_sdcard_cfg_read(bus->sdiodev,
-					     SDIO_FUNC_1,
-					     SBSDIO_FUNC1_WFRAMEBCHI,
-					     NULL);
-					lo = brcmf_sdcard_cfg_read(bus->sdiodev,
-					     SDIO_FUNC_1,
-					     SBSDIO_FUNC1_WFRAMEBCLO,
-					     NULL);
-					bus->f1regdata += 2;
-					if ((hi == 0) && (lo == 0))
-						break;
-				}
-
-			}
-			if (ret == 0)
-				bus->tx_seq =
-				    (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
-
-		} while ((ret < 0) && retries++ < TXRETRIES);
+			ret = brcmf_tx_frame(bus, frame, len);
+		} while (ret < 0 && retries++ < TXRETRIES);
 	}
 
 	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
-- 
1.7.1


