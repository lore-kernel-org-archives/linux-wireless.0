Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30913 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703Ab1EMO7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 10:59:40 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 07:59:11 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 2/9] ath9k_hw: enable Antenna diversity for AR9485
Date: Fri, 13 May 2011 20:29:31 +0530
Message-ID: <1305298771-3343-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_165943_405418_7D55CEB8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

read antenna diversity and combining information from the EEPROM.
Enable antenna diversity/combining feature only when both LNA
diversity and fast diversity are supported

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Tested-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 58f3d42..b75b5dc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2022,6 +2022,22 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 
+	if (AR_SREV_9485(ah)) {
+		ant_div_ctl1 = ah->eep_ops->get_eeprom(ah, EEP_ANT_DIV_CTL1);
+		/*
+		 * enable the diversity-combining algorithm only when
+		 * both enable_lna_div and enable_fast_div are set
+		 *		Table for Diversity
+		 * ant_div_alt_lnaconf		bit 0-1
+		 * ant_div_main_lnaconf		bit 2-3
+		 * ant_div_alt_gaintb		bit 4
+		 * ant_div_main_gaintb		bit 5
+		 * enable_ant_div_lnadiv	bit 6
+		 * enable_ant_fast_div		bit 7
+		 */
+		if ((ant_div_ctl1 >> 0x6) == 0x3)
+			pCap->hw_caps |= ATH9K_HW_CAP_ANT_DIV_COMB;
+	}
 
 	if (AR_SREV_9485_10(ah)) {
 		pCap->pcie_lcr_extsync_en = true;
-- 
1.7.0.4

