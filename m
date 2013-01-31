Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42966 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603Ab3AaJ1N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:13 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4/6] ath9k: Only spectral scan relay file when it was created
Date: Thu, 31 Jan 2013 10:26:47 +0100
Message-Id: <1359624409-14815-4-git-send-email-sven@narfation.org> (sfid-20130131_102719_791281_B5CFD820)
In-Reply-To: <1359624409-14815-1-git-send-email-sven@narfation.org>
References: <1359624409-14815-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The relay file depends on relayfs. Trying to close this file without having
ATH9K_DEBUGFS (and therefore RELAY) activated causes build failures.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c7d116c..93a6dba 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -922,10 +922,12 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 
 	ath9k_eeprom_release(sc);
 
+#ifdef CONFIG_ATH9K_DEBUGFS
 	if (sc->rfs_chan_spec_scan) {
 		relay_close(sc->rfs_chan_spec_scan);
 		sc->rfs_chan_spec_scan = NULL;
 	}
+#endif
 }
 
 void ath9k_deinit_device(struct ath_softc *sc)
-- 
1.7.10.4

