Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59531 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbaBYTaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 14:30:46 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/14] brcmfmac: Put frame sdio tx error handling in sub function.
Date: Tue, 25 Feb 2014 20:30:35 +0100
Message-ID: <1393356639-19169-12-git-send-email-arend@broadcom.com> (sfid-20140225_203052_556784_EE725106)
In-Reply-To: <1393356639-19169-1-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  112 ++++++--------------
 1 file changed, 33 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 90ff406..8871d94 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1237,6 +1237,28 @@ static void brcmf_sdio_rxfail(struct brcmf_sdio *bus, bool abort, bool rtx)
 	bus->cur_read.len = 0;
 }
 
+static void brcmf_sdio_txfail(struct brcmf_sdio *bus)
+{
+	struct brcmf_sdio_dev *sdiodev = bus->sdiodev;
+	u8 i, hi, lo;
+
+	/* On failure, abort the command and terminate the frame */
+	brcmf_err("sdio error, abort command and terminate frame\n");
+	bus->sdcnt.tx_sderrs++;
+
+	brcmf_sdiod_abort(sdiodev, SDIO_FUNC_2);
+	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_FRAMECTRL, SFC_WF_TERM, NULL);
+	bus->sdcnt.f1regdata++;
+
+	for (i = 0; i < 3; i++) {
+		hi = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_WFRAMEBCHI, NULL);
+		lo = brcmf_sdiod_regrb(sdiodev, SBSDIO_FUNC1_WFRAMEBCLO, NULL);
+		bus->sdcnt.f1regdata += 2;
+		if ((hi == 0) && (lo == 0))
+			break;
+	}
+}
+
 /* return total length of buffer chain */
 static uint brcmf_sdio_glom_len(struct brcmf_sdio *bus)
 {
@@ -2252,7 +2274,6 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 			    uint chan)
 {
 	int ret;
-	int i;
 	struct sk_buff *pkt_next, *tmp;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2265,28 +2286,9 @@ static int brcmf_sdio_txpkt(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 	ret = brcmf_sdiod_send_pkt(bus->sdiodev, pktq);
 	bus->sdcnt.f2txdata++;
 
-	if (ret < 0) {
-		/* On failure, abort the command and terminate the frame */
-		brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-			  ret);
-		bus->sdcnt.tx_sderrs++;
+	if (ret < 0)
+		brcmf_sdio_txfail(bus);
 
-		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-				  SFC_WF_TERM, NULL);
-		bus->sdcnt.f1regdata++;
-
-		for (i = 0; i < 3; i++) {
-			u8 hi, lo;
-			hi = brcmf_sdiod_regrb(bus->sdiodev,
-					       SBSDIO_FUNC1_WFRAMEBCHI, NULL);
-			lo = brcmf_sdiod_regrb(bus->sdiodev,
-					       SBSDIO_FUNC1_WFRAMEBCLO, NULL);
-			bus->sdcnt.f1regdata += 2;
-			if ((hi == 0) && (lo == 0))
-				break;
-		}
-	}
 	sdio_release_host(bus->sdiodev->func[1]);
 
 done:
@@ -2597,42 +2599,17 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
 	brcmf_sdio_clrintr(bus);
 
 	if (data_ok(bus) && bus->ctrl_frame_stat &&
-		(bus->clkstate == CLK_AVAIL)) {
-		int i;
+	    (bus->clkstate == CLK_AVAIL)) {
 
 		sdio_claim_host(bus->sdiodev->func[1]);
 		err = brcmf_sdiod_send_buf(bus->sdiodev, bus->ctrl_frame_buf,
 					   (u32)bus->ctrl_frame_len);
 
-		if (err < 0) {
-			/* On failure, abort the command and
-				terminate the frame */
-			brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-				  err);
-			bus->sdcnt.tx_sderrs++;
-
-			brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
-
-			brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-					  SFC_WF_TERM, &err);
-			bus->sdcnt.f1regdata++;
-
-			for (i = 0; i < 3; i++) {
-				u8 hi, lo;
-				hi = brcmf_sdiod_regrb(bus->sdiodev,
-						       SBSDIO_FUNC1_WFRAMEBCHI,
-						       &err);
-				lo = brcmf_sdiod_regrb(bus->sdiodev,
-						       SBSDIO_FUNC1_WFRAMEBCLO,
-						       &err);
-				bus->sdcnt.f1regdata += 2;
-				if ((hi == 0) && (lo == 0))
-					break;
-			}
-
-		} else {
+		if (err < 0)
+			brcmf_sdio_txfail(bus);
+		else
 			bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
-		}
+
 		sdio_release_host(bus->sdiodev->func[1]);
 		bus->ctrl_frame_stat = false;
 		brcmf_sdio_wait_event_wakeup(bus);
@@ -2802,38 +2779,15 @@ break2:
 
 static int brcmf_sdio_tx_frame(struct brcmf_sdio *bus, u8 *frame, u16 len)
 {
-	int i;
 	int ret;
 
 	bus->ctrl_frame_stat = false;
 	ret = brcmf_sdiod_send_buf(bus->sdiodev, frame, len);
 
-	if (ret < 0) {
-		/* On failure, abort the command and terminate the frame */
-		brcmf_dbg(INFO, "sdio error %d, abort command and terminate frame\n",
-			  ret);
-		bus->sdcnt.tx_sderrs++;
-
-		brcmf_sdiod_abort(bus->sdiodev, SDIO_FUNC_2);
-
-		brcmf_sdiod_regwb(bus->sdiodev, SBSDIO_FUNC1_FRAMECTRL,
-				  SFC_WF_TERM, NULL);
-		bus->sdcnt.f1regdata++;
-
-		for (i = 0; i < 3; i++) {
-			u8 hi, lo;
-			hi = brcmf_sdiod_regrb(bus->sdiodev,
-					       SBSDIO_FUNC1_WFRAMEBCHI, NULL);
-			lo = brcmf_sdiod_regrb(bus->sdiodev,
-					       SBSDIO_FUNC1_WFRAMEBCLO, NULL);
-			bus->sdcnt.f1regdata += 2;
-			if (hi == 0 && lo == 0)
-				break;
-		}
-		return ret;
-	}
-
-	bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
+	if (ret < 0)
+		brcmf_sdio_txfail(bus);
+	else
+		bus->tx_seq = (bus->tx_seq + 1) % SDPCM_SEQ_WRAP;
 
 	return ret;
 }
-- 
1.7.10.4

