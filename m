Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65460 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2INOtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 10:49:39 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Thomas Wagner <Thomas.Wagner@hs-rm.de>,
	Javier Cardona <javier@cozybit.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH v2] ath9k: Fix mesh related rx filtering issue for older chips
Date: Fri, 14 Sep 2012 20:19:28 +0530
Message-ID: <1347634168-20706-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120914_164942_316691_52810B37)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Wagner <Thomas.Wagner@hs-rm.de>

We need to have the promiscus mode enabled for older
chipsets(i.e, rule out many frames being filtered in the
hardware itself) if 'FIF_OTHER_BSS' flag is set, when we
start the mesh mode. Fix this by enabling promiscus
mode for all the chipsets whose macversion <= AR9160
chipsets. This should fix
https://bugzilla.kernel.org/show_bug.cgi?id=45591

shafi: made the fix generic by having the frame filtering
disabled for chipsets older than AR9280.

Cc: Javier Cardona <javier@cozybit.com>
Signed-off-by: Thomas Wagner <Thomas.Wagner@hs-rm.de>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4480c0c..76db0b3 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -424,8 +424,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
 	if (sc->nvifs > 1 || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
-		/* The following may also be needed for other older chips */
-		if (sc->sc_ah->hw_version.macVersion == AR_SREV_VERSION_9160)
+		/* This is needed for older chips, especially for mesh mode */
+		if (sc->sc_ah->hw_version.macVersion <= AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 	}
-- 
1.7.0.4

