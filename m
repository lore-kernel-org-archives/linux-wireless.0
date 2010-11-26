Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:33420 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0KZJ5O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 04:57:14 -0500
Date: Fri, 26 Nov 2010 10:57:12 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org
Message-ID: <19201442.521290765431151.JavaMail.wlan@CHBU500181>
In-Reply-To: <10164575.321290765232556.JavaMail.wlan@CHBU500181>
Subject: [PATCH v6 7/9] ath5k: Add initial registers values for radio RF2317
 chip.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/initvals.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 8fa4393..05baa4e 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -1501,6 +1501,29 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 					rf5112_ini_bbgain, change_channel);
 			break;
 		case AR5K_RF2317:
+
+			ath5k_hw_ini_mode_registers(ah,
+					ARRAY_SIZE(rf2413_ini_mode_end),
+					rf2413_ini_mode_end, mode);
+
+			ath5k_hw_ini_registers(ah,
+					ARRAY_SIZE(rf2425_ini_common_end),
+					rf2425_ini_common_end, change_channel);
+
+			/* Override settings from rf2413_ini_mode_end */
+			ath5k_hw_reg_write(ah, 0x00180a65, AR5K_PHY_GAIN);
+
+			/* Override settings from rf2413_ini_common_end */
+			ath5k_hw_reg_write(ah, 0x00004000, AR5K_PHY_AGC);
+			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_TPC_RG5,
+				AR5K_PHY_TPC_RG5_PD_GAIN_OVERLAP, 0xa);
+			ath5k_hw_reg_write(ah, 0x800000a8, 0x8140);
+			ath5k_hw_reg_write(ah, 0x000000ff, 0x9958);
+
+			ath5k_hw_ini_registers(ah,
+					ARRAY_SIZE(rf5112_ini_bbgain),
+					rf5112_ini_bbgain, change_channel);
+			break;
 		case AR5K_RF2425:
 
 			ath5k_hw_ini_mode_registers(ah,
-- 
1.7.1

