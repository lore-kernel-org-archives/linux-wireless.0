Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35807 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1HDRxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 13:53:50 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 11/13] ath9k_hw: Disable Walsh spatial spreading for 2 chains
Date: Thu, 4 Aug 2011 23:24:07 +0530
Message-ID: <1312480447-27483-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110804_195358_326113_372C4A42)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Walsh bit is disabled for regulatory consideration.

As per the FCC rulings, only transmissions that are completely
non-coherent, are allowed to waive the array gain contribution
to EIRP for multi-transmit configurations. The use of 2-stream
with 2 transmit and use of 3-steam with 3 transmit qualifies
for this spatial multiplexing MIMO classification as long as
the streams are directly mapped to each radio (not Walsh spread
prior to splitting to multiple radios)

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 2339728..28b44b0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -636,7 +636,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
 	{0x00009e44, 0x02321e27, 0x02321e27, 0x02291e27, 0x02291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
-	{0x0000a204, 0x000037c0, 0x000037c4, 0x000037c4, 0x000037c0},
+	{0x0000a204, 0x000036c0, 0x000036c4, 0x000036c4, 0x000036c0},
 	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
 	{0x0000a22c, 0x01026a2f, 0x01026a2f, 0x01026a2f, 0x01026a2f},
 	{0x0000a230, 0x0000000a, 0x00000014, 0x00000016, 0x0000000b},
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 1baca8e..c906e9e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -482,7 +482,7 @@ static void ar9003_hw_set_channel_regs(struct ath_hw *ah,
 		(REG_READ(ah, AR_PHY_GEN_CTRL) & AR_PHY_GC_ENABLE_DAC_FIFO);
 
 	/* Enable 11n HT, 20 MHz */
-	phymode = AR_PHY_GC_HT_EN | AR_PHY_GC_SINGLE_HT_LTF1 | AR_PHY_GC_WALSH |
+	phymode = AR_PHY_GC_HT_EN | AR_PHY_GC_SINGLE_HT_LTF1 |
 		  AR_PHY_GC_SHORT_GI_40 | enableDacFifo;
 
 	/* Configure baseband for dynamic 20/40 operation */
-- 
1.7.6

