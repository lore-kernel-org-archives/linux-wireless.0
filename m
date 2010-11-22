Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54998 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab0KVR04 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 12:26:56 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k_htc: fix eeprom access
Date: Mon, 22 Nov 2010 18:26:51 +0100
Message-Id: <1290446811-41928-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless-testing commit a05b5d45049d60a06a1b12976150572304a51928
ath9k: add support for reading eeprom from platform data on PCI devices

This change moved the initialization of the AH_USE_EEPROM flag from ath9k_hw
to ath9k. This needs to be added to ath9k_htc as well

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 7c8a38d..fcfabc1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -641,6 +641,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 
 	ah->hw_version.devid = devid;
 	ah->hw_version.subsysid = 0; /* FIXME */
+	ah->ah_flags |= AH_USE_EEPROM;
 	priv->ah = ah;
 
 	common = ath9k_hw_common(ah);
-- 
1.7.3.2

