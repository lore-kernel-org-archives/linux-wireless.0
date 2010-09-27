Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:8785 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780Ab0I0ECp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 00:02:45 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-093120161
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 13:02:43 +0900 (JST)
Subject: [PATCH] ath5k: Fix bitmasks and typos for PCU Diagnostic register
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 27 Sep 2010 13:02:40 +0900
Message-ID: <20100927040240.31163.45411.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported by Ryan Niemi, some bitmasks in the register definition for the PCU
Diagnostic register (DIAG_SW) were missing a zero at the end. While at it fix
some typos and add more comments.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/dma.c |    4 ++--
 drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
 drivers/net/wireless/ath/ath5k/reg.h |   29 ++++++++++++++---------------
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 58bb6c5..923c9ca 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -244,7 +244,7 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 
 			/* Force channel idle high */
 			AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW_5211,
-					AR5K_DIAG_SW_CHANEL_IDLE_HIGH);
+					AR5K_DIAG_SW_CHANNEL_IDLE_HIGH);
 
 			/* Wait a while and disable mechanism */
 			udelay(200);
@@ -261,7 +261,7 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 			} while (--i && pending);
 
 			AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW_5211,
-					AR5K_DIAG_SW_CHANEL_IDLE_HIGH);
+					AR5K_DIAG_SW_CHANNEL_IDLE_HIGH);
 		}
 
 		/* Clear register */
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 4932bf2..61da913 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1257,7 +1257,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	 * Disable beacons and RX/TX queues, wait
 	 */
 	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW_5210,
-		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
+		AR5K_DIAG_SW_DIS_TX_5210 | AR5K_DIAG_SW_DIS_RX_5210);
 	beacon = ath5k_hw_reg_read(ah, AR5K_BEACON_5210);
 	ath5k_hw_reg_write(ah, beacon & ~AR5K_BEACON_ENABLE, AR5K_BEACON_5210);
 
@@ -1336,7 +1336,7 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	 * Re-enable RX/TX and beacons
 	 */
 	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW_5210,
-		AR5K_DIAG_SW_DIS_TX | AR5K_DIAG_SW_DIS_RX_5210);
+		AR5K_DIAG_SW_DIS_TX_5210 | AR5K_DIAG_SW_DIS_RX_5210);
 	ath5k_hw_reg_write(ah, beacon, AR5K_BEACON_5210);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 67d6308..a34929f 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1387,10 +1387,9 @@
 
 
 /*
- * PCU control register
+ * PCU Diagnostic register
  *
- * Only DIS_RX is used in the code, the rest i guess are
- * for tweaking/diagnostics.
+ * Used for tweaking/diagnostics.
  */
 #define AR5K_DIAG_SW_5210		0x8068			/* Register Address [5210] */
 #define AR5K_DIAG_SW_5211		0x8048			/* Register Address [5211+] */
@@ -1399,22 +1398,22 @@
 #define AR5K_DIAG_SW_DIS_WEP_ACK	0x00000001	/* Disable ACKs if WEP key is invalid */
 #define AR5K_DIAG_SW_DIS_ACK		0x00000002	/* Disable ACKs */
 #define AR5K_DIAG_SW_DIS_CTS		0x00000004	/* Disable CTSs */
-#define AR5K_DIAG_SW_DIS_ENC		0x00000008	/* Disable encryption */
-#define AR5K_DIAG_SW_DIS_DEC		0x00000010	/* Disable decryption */
-#define AR5K_DIAG_SW_DIS_TX		0x00000020	/* Disable transmit [5210] */
-#define AR5K_DIAG_SW_DIS_RX_5210	0x00000040	/* Disable recieve */
+#define AR5K_DIAG_SW_DIS_ENC		0x00000008	/* Disable HW encryption */
+#define AR5K_DIAG_SW_DIS_DEC		0x00000010	/* Disable HW decryption */
+#define AR5K_DIAG_SW_DIS_TX_5210	0x00000020	/* Disable transmit [5210] */
+#define AR5K_DIAG_SW_DIS_RX_5210	0x00000040	/* Disable receive */
 #define AR5K_DIAG_SW_DIS_RX_5211	0x00000020
 #define	AR5K_DIAG_SW_DIS_RX		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_DIS_RX_5210 : AR5K_DIAG_SW_DIS_RX_5211)
-#define AR5K_DIAG_SW_LOOP_BACK_5210	0x00000080	/* Loopback (i guess it goes with DIS_TX) [5210] */
+#define AR5K_DIAG_SW_LOOP_BACK_5210	0x00000080	/* TX Data Loopback (i guess it goes with DIS_TX) [5210] */
 #define AR5K_DIAG_SW_LOOP_BACK_5211	0x00000040
 #define AR5K_DIAG_SW_LOOP_BACK		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_LOOP_BACK_5210 : AR5K_DIAG_SW_LOOP_BACK_5211)
-#define AR5K_DIAG_SW_CORR_FCS_5210	0x00000100	/* Corrupted FCS */
+#define AR5K_DIAG_SW_CORR_FCS_5210	0x00000100	/* Generate invalid TX FCS */
 #define AR5K_DIAG_SW_CORR_FCS_5211	0x00000080
 #define AR5K_DIAG_SW_CORR_FCS		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_CORR_FCS_5210 : AR5K_DIAG_SW_CORR_FCS_5211)
-#define AR5K_DIAG_SW_CHAN_INFO_5210	0x00000200	/* Dump channel info */
+#define AR5K_DIAG_SW_CHAN_INFO_5210	0x00000200	/* Add 56 bytes of channel info before the frame data in the RX buffer */
 #define AR5K_DIAG_SW_CHAN_INFO_5211	0x00000100
 #define AR5K_DIAG_SW_CHAN_INFO		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_CHAN_INFO_5210 : AR5K_DIAG_SW_CHAN_INFO_5211)
@@ -1426,17 +1425,17 @@
 #define AR5K_DIAG_SW_SCVRAM_SEED	0x0003f800	/* [5210] */
 #define AR5K_DIAG_SW_SCRAM_SEED_M	0x0001fc00	/* Scrambler seed mask */
 #define AR5K_DIAG_SW_SCRAM_SEED_S	10
-#define AR5K_DIAG_SW_DIS_SEQ_INC	0x00040000	/* Disable seqnum increment (?)[5210] */
+#define AR5K_DIAG_SW_DIS_SEQ_INC_5210	0x00040000	/* Disable seqnum increment (?)[5210] */
 #define AR5K_DIAG_SW_FRAME_NV0_5210	0x00080000
 #define AR5K_DIAG_SW_FRAME_NV0_5211	0x00020000	/* Accept frames of non-zero protocol number */
 #define	AR5K_DIAG_SW_FRAME_NV0		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_FRAME_NV0_5210 : AR5K_DIAG_SW_FRAME_NV0_5211)
 #define AR5K_DIAG_SW_OBSPT_M		0x000c0000	/* Observation point select (?) */
 #define AR5K_DIAG_SW_OBSPT_S		18
-#define AR5K_DIAG_SW_RX_CLEAR_HIGH	0x0010000	/* Force RX Clear high */
-#define AR5K_DIAG_SW_IGNORE_CARR_SENSE	0x0020000	/* Ignore virtual carrier sense */
-#define AR5K_DIAG_SW_CHANEL_IDLE_HIGH	0x0040000	/* Force channel idle high */
-#define AR5K_DIAG_SW_PHEAR_ME		0x0080000	/* ??? */
+#define AR5K_DIAG_SW_RX_CLEAR_HIGH	0x00100000	/* Ignore carrier sense */
+#define AR5K_DIAG_SW_IGNORE_CARR_SENSE	0x00200000	/* Ignore virtual carrier sense */
+#define AR5K_DIAG_SW_CHANNEL_IDLE_HIGH	0x00400000	/* Force channel idle high */
+#define AR5K_DIAG_SW_PHEAR_ME		0x00800000	/* ??? */
 
 /*
  * TSF (clock) register (lower 32 bits)

