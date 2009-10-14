Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:58186 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761838AbZJNPIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 11:08:23 -0400
To: linville@tuxdriver.com
Subject: [PATCH] ath9k: adjust ahb callbacks to new struct layout to avoid compile errors
From: Marek Lindner <lindner_marek@yahoo.de>
Date: Wed, 14 Oct 2009 23:04:45 +0800
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910142304.46025.lindner_marek@yahoo.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
---
 drivers/net/wireless/ath/ath9k/ahb.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c 
b/drivers/net/wireless/ath/ath9k/ahb.c
index 33c9e81..25531f2 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -29,15 +29,13 @@ static void ath_ahb_read_cachesize(struct ath_common 
*common, int *csz)
 
 static void ath_ahb_cleanup(struct ath_common *common)
 {
-	struct ath_hw *ah = (struct ath_hw *) common->ah;
-	struct ath_softc *sc = ah->ah_sc;
+	struct ath_softc *sc = (struct ath_softc *)common->priv;
 	iounmap(sc->mem);
 }
 
 static bool ath_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
-	struct ath_hw *ah = (struct ath_hw *) common->ah;
-	struct ath_softc *sc = ah->ah_sc;
+	struct ath_softc *sc = (struct ath_softc *)common->priv;
 	struct platform_device *pdev = to_platform_device(sc->dev);
 	struct ath9k_platform_data *pdata;
 
-- 
1.6.4.3

