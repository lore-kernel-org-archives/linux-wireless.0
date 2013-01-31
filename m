Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42975 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab3AaJ1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:20 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6/6] ath9k: Remove unused variables in ath_mci_cleanup
Date: Thu, 31 Jan 2013 10:26:49 +0100
Message-Id: <1359624409-14815-6-git-send-email-sven@narfation.org> (sfid-20130131_102726_662543_6EFF967F)
In-Reply-To: <1359624409-14815-1-git-send-email-sven@narfation.org>
References: <1359624409-14815-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Leaving the unused variables ath_mci_cleanup causes build warnings.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/mci.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index d207433..815bee2 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -474,8 +474,6 @@ void ath_mci_cleanup(struct ath_softc *sc)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_mci_coex *mci = &sc->mci_coex;
-	struct ath_mci_buf *buf = &mci->sched_buf;
 
 	ar9003_mci_cleanup(ah);
 
-- 
1.7.10.4

