Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:43978 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623Ab0CYFts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:48 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0443436186
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:46 +0900 (JST)
Subject: [PATCH 08/10] ath5k: update phy errors codes
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:42 +0900
Message-ID: <20100325054942.10697.65242.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update PHY error codes from the HAL, and keep them in statistics for debugging
via the 'frameerrors' file. This will also be used by ANI.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c  |    2 ++
 drivers/net/wireless/ath/ath5k/base.h  |    1 +
 drivers/net/wireless/ath/ath5k/debug.c |    8 +++++++
 drivers/net/wireless/ath/ath5k/desc.h  |   35 ++++++++++++++++++++++++--------
 4 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ea33b99..a1c0dcb 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1940,6 +1940,8 @@ ath5k_tasklet_rx(unsigned long data)
 				sc->stats.rxerr_fifo++;
 			if (rs.rs_status & AR5K_RXERR_PHY) {
 				sc->stats.rxerr_phy++;
+				if (rs.rs_phyerr > 0 && rs.rs_phyerr < 32)
+					sc->stats.rxerr_phy_code[rs.rs_phyerr]++;
 				goto next;
 			}
 			if (rs.rs_status & AR5K_RXERR_DECRYPT) {
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index fe5dae5..a572a48 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -116,6 +116,7 @@ struct ath5k_statistics {
 	unsigned int tx_all_count;	/* all TX frames, including errors */
 	unsigned int rxerr_crc;
 	unsigned int rxerr_phy;
+	unsigned int rxerr_phy_code[32];
 	unsigned int rxerr_fifo;
 	unsigned int rxerr_decrypt;
 	unsigned int rxerr_mic;
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index bccd4a7..90247dc 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -474,6 +474,7 @@ static ssize_t read_file_frameerrors(struct file *file, char __user *user_buf,
 	struct ath5k_statistics *st = &sc->stats;
 	char buf[700];
 	unsigned int len = 0;
+	int i;
 
 	len += snprintf(buf+len, sizeof(buf)-len,
 			"RX\n---------------------\n");
@@ -485,6 +486,13 @@ static ssize_t read_file_frameerrors(struct file *file, char __user *user_buf,
 			st->rxerr_phy,
 			st->rx_all_count > 0 ?
 				st->rxerr_phy*100/st->rx_all_count : 0);
+	for (i = 0; i < 32; i++) {
+		if (st->rxerr_phy_code[i])
+			len += snprintf(buf+len, sizeof(buf)-len,
+				" phy_err[%d]\t%d\n",
+				i, st->rxerr_phy_code[i]);
+	}
+
 	len += snprintf(buf+len, sizeof(buf)-len, "FIFO\t%d\t(%d%%)\n",
 			st->rxerr_fifo,
 			st->rx_all_count > 0 ?
diff --git a/drivers/net/wireless/ath/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
index 56158c8..64538fb 100644
--- a/drivers/net/wireless/ath/ath5k/desc.h
+++ b/drivers/net/wireless/ath/ath5k/desc.h
@@ -112,15 +112,32 @@ struct ath5k_hw_rx_error {
 #define AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE	0x0000ff00
 #define AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE_S	8
 
-/* PHY Error codes */
-#define AR5K_DESC_RX_PHY_ERROR_NONE		0x00
-#define AR5K_DESC_RX_PHY_ERROR_TIMING		0x20
-#define AR5K_DESC_RX_PHY_ERROR_PARITY		0x40
-#define AR5K_DESC_RX_PHY_ERROR_RATE		0x60
-#define AR5K_DESC_RX_PHY_ERROR_LENGTH		0x80
-#define AR5K_DESC_RX_PHY_ERROR_64QAM		0xa0
-#define AR5K_DESC_RX_PHY_ERROR_SERVICE		0xc0
-#define AR5K_DESC_RX_PHY_ERROR_TRANSMITOVR	0xe0
+/**
+ * enum ath5k_phy_error_code - PHY Error codes
+ */
+enum ath5k_phy_error_code {
+	AR5K_RX_PHY_ERROR_UNDERRUN		= 0,	/* Transmit underrun */
+	AR5K_RX_PHY_ERROR_TIMING		= 1,	/* Timing error */
+	AR5K_RX_PHY_ERROR_PARITY		= 2,	/* Illegal parity */
+	AR5K_RX_PHY_ERROR_RATE			= 3,	/* Illegal rate */
+	AR5K_RX_PHY_ERROR_LENGTH		= 4,	/* Illegal length */
+	AR5K_RX_PHY_ERROR_RADAR			= 5,	/* Radar detect */
+	AR5K_RX_PHY_ERROR_SERVICE		= 6,	/* Illegal service */
+	AR5K_RX_PHY_ERROR_TOR			= 7,	/* Transmit override receive */
+	/* these are specific to the 5212 */
+	AR5K_RX_PHY_ERROR_OFDM_TIMING		= 17,
+	AR5K_RX_PHY_ERROR_OFDM_SIGNAL_PARITY	= 18,
+	AR5K_RX_PHY_ERROR_OFDM_RATE_ILLEGAL	= 19,
+	AR5K_RX_PHY_ERROR_OFDM_LENGTH_ILLEGAL	= 20,
+	AR5K_RX_PHY_ERROR_OFDM_POWER_DROP	= 21,
+	AR5K_RX_PHY_ERROR_OFDM_SERVICE		= 22,
+	AR5K_RX_PHY_ERROR_OFDM_RESTART		= 23,
+	AR5K_RX_PHY_ERROR_CCK_TIMING		= 25,
+	AR5K_RX_PHY_ERROR_CCK_HEADER_CRC	= 26,
+	AR5K_RX_PHY_ERROR_CCK_RATE_ILLEGAL	= 27,
+	AR5K_RX_PHY_ERROR_CCK_SERVICE		= 30,
+	AR5K_RX_PHY_ERROR_CCK_RESTART		= 31,
+};
 
 /*
  * 5210/5211 hardware 2-word TX control descriptor

