Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42993 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab3AaO5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 09:57:07 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, kvalo@adurom.com,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCHv2 4/6] ath9k: Only remove spectral scan relay file when it was created
Date: Thu, 31 Jan 2013 15:56:56 +0100
Message-Id: <1359644216-24439-1-git-send-email-sven@narfation.org> (sfid-20130131_155711_410329_699C731D)
In-Reply-To: <1359624409-14815-4-git-send-email-sven@narfation.org>
References: <1359624409-14815-4-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The relay file depends on relayfs. Trying to close this file without having
ATH9K_DEBUGFS (and therefore RELAY) activated causes build failures.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2:
* Use config_enabled instead of #ifdef as requested by
  Kalle Valo <kvalo@adurom.com>

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c7d116c..af932c9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -922,7 +922,7 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 
 	ath9k_eeprom_release(sc);
 
-	if (sc->rfs_chan_spec_scan) {
+	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && sc->rfs_chan_spec_scan) {
 		relay_close(sc->rfs_chan_spec_scan);
 		sc->rfs_chan_spec_scan = NULL;
 	}
-- 
1.7.10.4

