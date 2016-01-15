Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36887 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbcAOKSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 05:18:53 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v2 5/5] ath9k: fix data bus error on ar9300 and ar9580
Date: Fri, 15 Jan 2016 18:17:21 +0800
Message-Id: <1452853041-3674-6-git-send-email-miaoqing@codeaurora.org> (sfid-20160115_111857_852991_9D31F41A)
In-Reply-To: <1452853041-3674-1-git-send-email-miaoqing@codeaurora.org>
References: <1452853041-3674-1-git-send-email-miaoqing@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

One crash issue be found on ar9300: RTC_RC reg read leads crash, leading
the data bus error, due to RTC_RC reg write not happen properly.

Warm Reset trigger in continuous beacon stuck for one of the customer for
other chip, noticed the MAC was stuck in RTC reset. After analysis noticed
DMA did not complete when RTC was put in reset.

So, before resetting the MAC need to make sure there are no pending DMA
transactions because this reset does not reset all parts of the chip.

The 12th and 11th bit of MAC _DMA_CFG register used to do that.
	12 cfg_halt_ack 0x0
		0 DMA has not yet halted
		1 DMA has halted
	11 cfg_halt_req 0x0
		0 DMA logic operates normally
		1 Request DMA logic to stop so software can reset the MAC

The Bit [12] of this register indicates when the halt has taken effect or
not. the DMA halt IS NOT recoverable; once software sets bit [11] to
request a DMA halt, software must wait for bit [12] to be set and reset
the MAC.

So, the same thing we implemented for ar9580 chip.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  | 10 ++++++++++
 drivers/net/wireless/ath/ath9k/reg.h |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 257f46e..e7a3101 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1368,6 +1368,16 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	if (ath9k_hw_mci_is_enabled(ah))
 		ar9003_mci_check_gpm_offset(ah);
 
+	/* DMA HALT added to resolve ar9300 and ar9580 bus error during
+	 * RTC_RC reg read
+	 */
+	if (AR_SREV_9300(ah) || AR_SREV_9580(ah)) {
+		REG_SET_BIT(ah, AR_CFG, AR_CFG_HALT_REQ);
+		ath9k_hw_wait(ah, AR_CFG, AR_CFG_HALT_ACK, AR_CFG_HALT_ACK,
+			      20 * AH_WAIT_TIMEOUT);
+		REG_CLR_BIT(ah, AR_CFG, AR_CFG_HALT_REQ);
+	}
+
 	REG_WRITE(ah, AR_RTC_RC, rst_flags);
 
 	REGWRITE_BUFFER_FLUSH(ah);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index caba54d..c8d35fe 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -34,8 +34,10 @@
 #define AR_CFG_SWRG          0x00000010
 #define AR_CFG_AP_ADHOC_INDICATION 0x00000020
 #define AR_CFG_PHOK          0x00000100
-#define AR_CFG_CLK_GATE_DIS  0x00000400
 #define AR_CFG_EEBS          0x00000200
+#define AR_CFG_CLK_GATE_DIS  0x00000400
+#define AR_CFG_HALT_REQ	     0x00000800
+#define AR_CFG_HALT_ACK	     0x00001000
 #define AR_CFG_PCI_MASTER_REQ_Q_THRESH         0x00060000
 #define AR_CFG_PCI_MASTER_REQ_Q_THRESH_S       17
 
-- 
1.9.1

