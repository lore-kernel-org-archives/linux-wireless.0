Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42450 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2IYQDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 12:03:06 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Thomas Wagner <Thomas.Wagner@hs-rm.de>,
	Javier Cardona <javier@cozybit.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix rx filtering issue for older chips
Date: Tue, 25 Sep 2012 21:32:55 +0530
Message-ID: <1348588975-7374-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120925_180311_099059_44FD187F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Wagner <Thomas.Wagner@hs-rm.de>

We need to have the promiscuous mode enabled for older
chipsets so that the olderchips hardware does not
filters out some valid/necessary frames that need
to be sent to mac80211. Fix this by enabling promiscus
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
index 9b2a8cc..a04028b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -424,8 +424,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
 	if (sc->nvifs > 1 || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
-		/* The following may also be needed for other older chips */
-		if (sc->sc_ah->hw_version.macVersion == AR_SREV_VERSION_9160)
+		/* This is needed for older chips */
+		if (sc->sc_ah->hw_version.macVersion <= AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
 		rfilt |= ATH9K_RX_FILTER_MCAST_BCAST_ALL;
 	}
-- 
1.7.0.4

