Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38479 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 07/10] ath5k: initialize eeprom struct early on attach
Date: Thu, 10 Sep 2009 15:30:24 -0400
Message-Id: <1252611027-5285-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes this sparse warning:

  CHECK   drivers/net/wireless/ath/ath5k/attach.c
drivers/net/wireless/ath/ath5k/attach.c:288:42: warning: symbol 'ee' shadows an earlier one
drivers/net/wireless/ath/ath5k/attach.c:109:34: originally declared here

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/attach.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 2d262c7..123612a 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -281,12 +281,12 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 		goto err_free;
 	}
 
+	ee = &ah->ah_capabilities.cap_eeprom;
+
 	/*
 	 * Write PCI-E power save settings
 	 */
 	if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
-		struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-
 		ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
 		ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
 
@@ -324,7 +324,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 	}
 
 	/* Crypto settings */
-	ee = &ah->ah_capabilities.cap_eeprom;
 	ah->ah_aes_support = srev >= AR5K_SREV_AR5212_V4 &&
 		(ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
 		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5));
-- 
1.6.3.3

