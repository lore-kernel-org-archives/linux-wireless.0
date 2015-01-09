Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:59964 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbbAIREX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 12:04:23 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de, stable@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH] ath9k: ignore radar PHY errors when DFS is not enabled
Date: Fri,  9 Jan 2015 17:54:18 +0100
Message-Id: <1420822458-531-1-git-send-email-sw@simonwunderlich.de> (sfid-20150109_180427_837763_6623FCE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Performing spectral scans on 5 GHz channels may result in PHY errors
sent by the hardware, even if DFS support is not enabled in the driver
(e.g. channel scanning or passive monitoring). In that case channels may
falsely get marked as 'unusable'. To fix that, only process radar PHY
errors when radar is explicitly enabled in the driver.

Cc: Stable <stable@vger.kernel.org> [v3.10+]
Reported-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/dfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index 726271c..3d04905 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -152,6 +152,12 @@ void ath9k_dfs_process_phyerr(struct ath_softc *sc, void *data,
 		return;
 	}
 
+	if (!sc->hw->conf.radar_enabled) {
+		ath_dbg(common, DFS,
+			"Error: received radar phyerr while radar was disabled\n");
+		return;
+	}
+
 	datalen = rs->rs_datalen;
 	if (datalen == 0) {
 		DFS_STAT_INC(sc, datalen_discards);
-- 
2.1.4

