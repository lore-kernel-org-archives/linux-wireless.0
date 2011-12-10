Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34938 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab1LJVL3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 16:11:29 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH] ath9k: make two mci related functions static
Date: Sat, 10 Dec 2011 22:11:19 +0100
Message-Id: <1323551479-17077-1-git-send-email-nbd@openwrt.org> (sfid-20111210_221132_908278_FD1CB583)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mci.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/mci.h |    4 ----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 5a3a2a9..3118f30 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -234,8 +234,8 @@ static void ath_mci_cal_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 	}
 }
 
-void ath_mci_process_profile(struct ath_softc *sc,
-			     struct ath_mci_profile_info *info)
+static void ath_mci_process_profile(struct ath_softc *sc,
+				    struct ath_mci_profile_info *info)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_btcoex *btcoex = &sc->btcoex;
@@ -261,8 +261,8 @@ void ath_mci_process_profile(struct ath_softc *sc,
 	ath_mci_update_scheme(sc);
 }
 
-void ath_mci_process_status(struct ath_softc *sc,
-			    struct ath_mci_profile_status *status)
+static void ath_mci_process_status(struct ath_softc *sc,
+				   struct ath_mci_profile_status *status)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_btcoex *btcoex = &sc->btcoex;
diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
index b71bded..29e3e51 100644
--- a/drivers/net/wireless/ath/ath9k/mci.h
+++ b/drivers/net/wireless/ath/ath9k/mci.h
@@ -128,10 +128,6 @@ struct ath_mci_coex {
 };
 
 void ath_mci_flush_profile(struct ath_mci_profile *mci);
-void ath_mci_process_profile(struct ath_softc *sc,
-			     struct ath_mci_profile_info *info);
-void ath_mci_process_status(struct ath_softc *sc,
-			    struct ath_mci_profile_status *status);
 int ath_mci_setup(struct ath_softc *sc);
 void ath_mci_cleanup(struct ath_softc *sc);
 void ath_mci_intr(struct ath_softc *sc);
-- 
1.7.3.2

