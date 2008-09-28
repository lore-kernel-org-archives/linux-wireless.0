Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:48885 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbYI1WXT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 18:23:19 -0400
Date: Mon, 29 Sep 2008 01:23:07 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH 3/5] ath5k: Use QUIET mechanism on tx dma stop
Message-ID: <20080928222307.GC21335@makis> (sfid-20080929_002322_340874_15264E87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Use QUIET mechanism to drain tx buffer on PCU for newer chips
 * Make sure that INTPEND is really 1 and not 0xffffffff while checking for pending interrupts

 Changes-Licensed-under: ISC
 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath5k/dma.c |   49 ++++++++++++++++++++++++++++++++++----
 drivers/net/wireless/ath5k/reg.h |    4 +-
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath5k/dma.c b/drivers/net/wireless/ath5k/dma.c
index a28090b..7adceb2 100644
--- a/drivers/net/wireless/ath5k/dma.c
+++ b/drivers/net/wireless/ath5k/dma.c
@@ -68,7 +68,7 @@ int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 	/*
 	 * It may take some time to disable the DMA receive unit
 	 */
-	for (i = 2000; i > 0 &&
+	for (i = 1000; i > 0 &&
 			(ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_CR_RXE) != 0;
 			i--)
 		udelay(10);
@@ -182,11 +182,10 @@ int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
  * have any pending frames. Returns -EBUSY if we still have pending frames,
  * -EINVAL if queue number is out of range.
  *
- * TODO: Test queue drain code
  */
 int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 {
-	unsigned int i = 100;
+	unsigned int i = 40;
 	u32 tx_queue, pending;
 
 	ATH5K_TRACE(ah->ah_sc);
@@ -233,13 +232,53 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 			udelay(100);
 		} while (--i && pending);
 
+		/* For 2413+ order PCU to drop packets using
+		 * QUIET mechanism */
+		if (ah->ah_mac_version >= (AR5K_SREV_AR2414 >> 4) &&
+		pending){
+			/* Set periodicity and duration */
+			ath5k_hw_reg_write(ah,
+				AR5K_REG_SM(100, AR5K_QUIET_CTL2_QT_PER)|
+				AR5K_REG_SM(10, AR5K_QUIET_CTL2_QT_DUR),
+				AR5K_QUIET_CTL2);
+
+			/* Enable quiet period for current TSF */
+			ath5k_hw_reg_write(ah,
+				AR5K_QUIET_CTL1_QT_EN |
+				AR5K_REG_SM(ath5k_hw_reg_read(ah,
+						AR5K_TSF_L32_5211) >> 10,
+						AR5K_QUIET_CTL1_NEXT_QT_TSF),
+				AR5K_QUIET_CTL1);
+
+			/* Force channel idle high */
+			AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW_5211,
+					AR5K_DIAG_SW_CHANEL_IDLE_HIGH);
+
+			/* Wait a while and disable mechanism */
+			udelay(200);
+			AR5K_REG_DISABLE_BITS(ah, AR5K_QUIET_CTL1,
+						AR5K_QUIET_CTL1_QT_EN);
+
+			/* Re-check for pending frames */
+			i = 40;
+			do {
+				pending = ath5k_hw_reg_read(ah,
+					AR5K_QUEUE_STATUS(queue)) &
+					AR5K_QCU_STS_FRMPENDCNT;
+				udelay(100);
+			} while (--i && pending);
+
+			AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW_5211,
+					AR5K_DIAG_SW_CHANEL_IDLE_HIGH);
+		}
+
 		/* Clear register */
 		ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
 		if (pending)
 			return -EBUSY;
 	}
 
-	/* TODO: Check for success else return error */
+	/* TODO: Check for success on 5210 else return error */
 	return 0;
 }
 
@@ -415,7 +454,7 @@ done:
 bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	return ath5k_hw_reg_read(ah, AR5K_INTPEND);
+	return ath5k_hw_reg_read(ah, AR5K_INTPEND) == 1 ? 1 : 0;
 }
 
 /**
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 2c0fb8a..13456be 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1424,7 +1424,7 @@
 #define AR5K_DIAG_SW_OBSPT_S		18
 #define AR5K_DIAG_SW_RX_CLEAR_HIGH	0x0010000	/* Force RX Clear high */
 #define AR5K_DIAG_SW_IGNORE_CARR_SENSE	0x0020000	/* Ignore virtual carrier sense */
-#define AR5K_DIAG_SW_CHANEL_IDLE_HIGH	0x0040000	/* Force channel idle high (?) */
+#define AR5K_DIAG_SW_CHANEL_IDLE_HIGH	0x0040000	/* Force channel idle high */
 #define AR5K_DIAG_SW_PHEAR_ME		0x0080000	/* ??? */
 
 /*
@@ -1660,7 +1660,7 @@
  */
 #define AR5K_QUIET_CTL1			0x80fc			/* Register Address */
 #define AR5K_QUIET_CTL1_NEXT_QT_TSF	0x0000ffff	/* Next quiet period TSF (TU) */
-#define	AR5K_QUIET_CTL1_NEXT_QT_TSF_0
+#define	AR5K_QUIET_CTL1_NEXT_QT_TSF_S	0
 #define AR5K_QUIET_CTL1_QT_EN		0x00010000	/* Enable quiet period */
 #define	AR5K_QUIET_CTL1_ACK_CTS_EN	0x00020000	/* Send ACK/CTS during quiet period */
 
