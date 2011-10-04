Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2372 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 20/26] staging: brcm80211: removed unneeded call to
 brcms_b_tx_fifo_suspended
Date: Tue, 4 Oct 2011 23:19:06 +0200
Message-ID: <1317763152-17607-21-git-send-email-arend@broadcom.com> (sfid-20111004_232015_012757_47A6FAE9)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

- removed call to brcms_b_tx_fifo_suspended on receipt of TX FIFO suspend/flush
  completion signal.
- removed brcms_b_tx_fifo_suspended function as it is not being used elsewhere.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   34 -----------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index bd38f33..175d85e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1075,36 +1075,6 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	return morepending;
 }
 
-/* brcms_b_tx_fifo_suspended:
- * Check the MAC's tx suspend status for a tx fifo.
- *
- * When the MAC acknowledges a tx suspend, it indicates that no more
- * packets will be transmitted out the radio. This is independent of
- * DMA channel suspension---the DMA may have finished suspending, or may still
- * be pulling data into a tx fifo, by the time the MAC acks the suspend
- * request.
- */
-static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
-				      uint tx_fifo)
-{
-	/* check that a suspend has been requested and is no longer pending */
-
-	/*
-	 * for DMA mode, the suspend request is set in xmtcontrol of the DMA
-	 * engine, and the tx fifo suspend at the lower end of the MAC is
-	 * acknowledged in the chnstatus register.
-	 *
-	 * The tx fifo suspend completion is independent of the DMA suspend
-	 * completion and may be acked before or after the DMA is suspended.
-	 */
-	if (dma_txsuspended(wlc_hw->di[tx_fifo]) &&
-	    (R_REG(&wlc_hw->regs->chnstatus) &
-	     (1 << tx_fifo)) == 0)
-		return true;
-
-	return false;
-}
-
 /* second-level interrupt processing
  *   Return true if another dpc needs to be re-scheduled. false otherwise.
  *   Param 'bounded' indicates if applicable loops should be bounded.
@@ -1161,10 +1131,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		if (brcms_b_recv(wlc_hw, RX_FIFO, bounded))
 			wlc->macintstatus |= MI_DMAINT;
 
-	/* TX FIFO suspend/flush completion */
-	if (macintstatus & MI_TXSTOP)
-		brcms_b_tx_fifo_suspended(wlc_hw, TX_DATA_FIFO);
-
 	/* noise sample collected */
 	if (macintstatus & MI_BG_NOISE)
 		wlc_phy_noise_sample_intr(wlc_hw->band->pi);
-- 
1.7.4.1


