Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47156 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2EXEDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:03:10 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45758.748897.392749@gargle.gargle.HOWL> (sfid-20120524_060338_903966_664C45A8)
Date: Thu, 24 May 2012 09:32:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 03/22] ath9k: Setup MCI interrupts properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MCI interrupts have to be enabled only when BTCOEX is
actually in use.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 +--
 drivers/net/wireless/ath/ath9k/mci.c  |   11 +++++++++++
 drivers/net/wireless/ath/ath9k/mci.h  |   11 ++++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dfa78e8..3f79923 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1044,8 +1044,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		ah->imask |= ATH9K_INT_CST;
 
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
-		ah->imask |= ATH9K_INT_MCI;
+	ath_mci_enable(sc);
 
 	sc->sc_flags &= ~SC_OP_INVALID;
 	sc->sc_ah->is_monitoring = false;
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 29fe52d..7b553f6 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -538,3 +538,14 @@ void ath_mci_intr(struct ath_softc *sc)
 		mci_int &= ~(AR_MCI_INTERRUPT_RX_INVALID_HDR |
 			     AR_MCI_INTERRUPT_CONT_INFO_TIMEOUT);
 }
+
+void ath_mci_enable(struct ath_softc *sc)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	if (!common->btcoex_enabled)
+		return;
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+		sc->sc_ah->imask |= ATH9K_INT_MCI;
+}
diff --git a/drivers/net/wireless/ath/ath9k/mci.h b/drivers/net/wireless/ath/ath9k/mci.h
index c841444..fc14eea 100644
--- a/drivers/net/wireless/ath/ath9k/mci.h
+++ b/drivers/net/wireless/ath/ath9k/mci.h
@@ -130,4 +130,13 @@ void ath_mci_flush_profile(struct ath_mci_profile *mci);
 int ath_mci_setup(struct ath_softc *sc);
 void ath_mci_cleanup(struct ath_softc *sc);
 void ath_mci_intr(struct ath_softc *sc);
-#endif
+
+#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
+void ath_mci_enable(struct ath_softc *sc);
+#else
+static inline void ath_mci_enable(struct ath_softc *sc)
+{
+}
+#endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
+
+#endif /* MCI_H*/
-- 
1.7.10.2

