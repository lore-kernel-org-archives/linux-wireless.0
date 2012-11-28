Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1675 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988Ab2K1Uo1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:44:27 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/11] brcmsmac: fix bounds checking in tx/rx
Date: Wed, 28 Nov 2012 21:44:07 +0100
Message-ID: <1354135454-7035-5-git-send-email-arend@broadcom.com> (sfid-20121128_214433_351014_490052A3)
In-Reply-To: <1354135454-7035-1-git-send-email-arend@broadcom.com>
References: <1354135454-7035-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

brcms_b_txstatus and brcms_b_recv are off by one when
doing bounds checking on number of packets to process

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   30 ++++++++++++++----------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 054e1da..8fce687 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1044,11 +1044,17 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	s1 = bcma_read32(core, D11REGOFFS(frmtxstatus));
 	while (!(*fatal)
 	       && (s1 & TXS_V)) {
+		/* !give others some time to run! */
+		if (n >= max_tx_num) {
+			morepending = true;
+			break;
+		}
 
 		if (s1 == 0xffffffff) {
 			brcms_err(core, "wl%d: %s: dead chip\n", wlc_hw->unit,
 				  __func__);
-			return morepending;
+			*fatal = true;
+			return false;
 		}
 		s2 = bcma_read32(core, D11REGOFFS(frmtxstatus2));
 
@@ -1060,17 +1066,12 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 
 		*fatal = brcms_c_dotxstatus(wlc_hw->wlc, txs);
 
-		/* !give others some time to run! */
-		if (++n >= max_tx_num)
-			break;
 		s1 = bcma_read32(core, D11REGOFFS(frmtxstatus));
+		n++;
 	}
 
 	if (*fatal)
-		return 0;
-
-	if (n >= max_tx_num)
-		morepending = true;
+		return false;
 
 	return morepending;
 }
@@ -7631,16 +7632,19 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 
 	uint n = 0;
 	uint bound_limit = bound ? RXBND : -1;
+	bool morepending;
 
 	skb_queue_head_init(&recv_frames);
 
 	/* gather received frames */
-	while (dma_rx(wlc_hw->di[fifo], &recv_frames)) {
-
+	do {
 		/* !give others some time to run! */
-		if (++n >= bound_limit)
+		if (n >= bound_limit)
 			break;
-	}
+
+		morepending = dma_rx(wlc_hw->di[fifo], &recv_frames);
+		n++;
+	} while (morepending);
 
 	/* post more rbufs */
 	dma_rxfill(wlc_hw->di[fifo]);
@@ -7670,7 +7674,7 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 		brcms_c_recv(wlc_hw->wlc, p);
 	}
 
-	return n >= bound_limit;
+	return morepending;
 }
 
 /* second-level interrupt processing
-- 
1.7.10.4


