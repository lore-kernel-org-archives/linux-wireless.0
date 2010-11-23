Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45591 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0KWSws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:52:48 -0500
Received: by eye27 with SMTP id 27so4869103eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:52:47 -0800 (PST)
Date: Tue, 23 Nov 2010 20:52:24 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 07/30] ath5k: Check RXE when setting RXDP
Message-ID: <20101123185224.GG4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Make sure we are not trying to set RXDP while RX is active,
 for now ignore the return value.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/dma.c   |   11 +++++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 629a5ee..b36d3a5 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1168,7 +1168,7 @@ void ath5k_hw_set_clockrate(struct ath5k_hw *ah);
 void ath5k_hw_start_rx_dma(struct ath5k_hw *ah);
 int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah);
 u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah);
-void ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr);
+int ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr);
 int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue);
 int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue);
 u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue);
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index bfdfcff..3fe634f 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -95,11 +95,18 @@ u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah)
  * @ah: The &struct ath5k_hw
  * @phys_addr: RX descriptor address
  *
- * XXX: Should we check if rx is enabled before setting rxdp ?
+ * Returns -EIO if rx is active
  */
-void ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
+int ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
 {
+	if (ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_CR_RXE) {
+		ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
+				"tried to set RXDP while rx was active !\n");
+		return -EIO;
+	}
+
 	ath5k_hw_reg_write(ah, phys_addr, AR5K_RXDP);
+	return 0;
 }
 
 
