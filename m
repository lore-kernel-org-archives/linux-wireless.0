Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29861 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab1EDVBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 17:01:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 14:01:08 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Fiona Cain <fcain@atheros.com>,
	Zhen Xie <Zhen.Xie@Atheros.com>,
	Kathy Giori <kathy.giori@atheros.com>,
	Neha Choksi <neha.choksi@atheros.com>,
	Wayne Daniel <wayne.daniel@atheros.com>,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Samira Naraghi <samira.naraghi@atheros.com>,
	Ashok Chennupati <ashok.chennupati@atheros.com>,
	Lance Zimmerman <lance.zimmerman@atheros.com>
Subject: [PATCH] ath9k_hw: fix power for the HT40 duplicate frames
Date: Wed, 4 May 2011 14:01:26 -0700
Message-ID: <1304542886-19347-1-git-send-email-lrodriguez@atheros.com> (sfid-20110504_230139_691291_515E567C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With AR9003 at about ~ 10 feet from an AP that uses RTS / CTS you
will be able to associate but not not get data through given that
the power for the rates used was set too low. This increases the
power and permits data connectivity at longer distances from
access points when connected with HT40. Without this you will not
get any data through when associated to APs configured in HT40
at about more than 10 feet away.

Cc: stable@kernel.org
Cc: Fiona Cain <fcain@atheros.com>
Cc: Zhen Xie <Zhen.Xie@Atheros.com>
Cc: Kathy Giori <kathy.giori@atheros.com>
Cc: Neha Choksi <neha.choksi@atheros.com>
Cc: Wayne Daniel <wayne.daniel@atheros.com>
Cc: Gaurav Jauhar <gaurav.jauhar@atheros.com>
Cc: Samira Naraghi <samira.naraghi@atheros.com>
CC: Ashok Chennupati <ashok.chennupati@atheros.com>
Cc: Lance Zimmerman <lance.zimmerman@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index fb892e5..3b13c1b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4005,6 +4005,16 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 0)
 	    );
 
+        /* Write the power for duplicated frames - HT40 */
+
+        /* dup40_cck (LSB), dup40_ofdm, ext20_cck, ext20_ofdm (MSB) */
+	REG_WRITE(ah, 0xa3e0,
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 24) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 16) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24],  8) |
+		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L],  0)
+	    );
+
 	/* Write the HT20 power per rate set */
 
 	/* 0/8/16 (LSB), 1-3/9-11/17-19, 4, 5 (MSB) */
-- 
1.7.4.15.g7811d

