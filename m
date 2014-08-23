Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59135 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaHWH7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 02/18] ath9k: Add a routine to tear down channel contexts
Date: Sat, 23 Aug 2014 13:29:07 +0530
Message-Id: <1408780763-27974-3-git-send-email-sujith@msujith.org> (sfid-20140823_095938_056813_A3CF22A1)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 4 ++++
 drivers/net/wireless/ath/ath9k/channel.c | 5 +++++
 drivers/net/wireless/ath/ath9k/main.c    | 3 ++-
 drivers/net/wireless/ath/ath9k/wow.c     | 3 ++-
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index eb3572f..e88e18d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -437,6 +437,7 @@ void ath_roc_complete(struct ath_softc *sc, bool abort);
 bool ath9k_is_chanctx_enabled(void);
 void ath9k_fill_chanctx_ops(void);
 void ath9k_init_channel_context(struct ath_softc *sc);
+void ath9k_deinit_channel_context(struct ath_softc *sc);
 int ath9k_init_p2p(struct ath_softc *sc);
 void ath9k_deinit_p2p(struct ath_softc *sc);
 void ath9k_p2p_remove_vif(struct ath_softc *sc,
@@ -456,6 +457,9 @@ static inline void ath9k_fill_chanctx_ops(void)
 static inline void ath9k_init_channel_context(struct ath_softc *sc)
 {
 }
+static inline void ath9k_deinit_channel_context(struct ath_softc *sc)
+{
+}
 static inline int ath9k_init_p2p(struct ath_softc *sc)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index a4366c1..9c2cf90 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -959,6 +959,11 @@ void ath9k_init_channel_context(struct ath_softc *sc)
 		    (unsigned long)sc);
 }
 
+void ath9k_deinit_channel_context(struct ath_softc *sc)
+{
+	cancel_work_sync(&sc->chanctx_work);
+}
+
 bool ath9k_is_chanctx_enabled(void)
 {
 	return (ath9k_use_chanctx == 1);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ed281ac..e5c523a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -822,7 +822,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_common *common = ath9k_hw_common(ah);
 	bool prev_idle;
 
-	cancel_work_sync(&sc->chanctx_work);
+	ath9k_deinit_channel_context(sc);
+
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index a4f4f0d..33531d9 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -193,7 +193,8 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	u32 wow_triggers_enabled = 0;
 	int ret = 0;
 
-	cancel_work_sync(&sc->chanctx_work);
+	ath9k_deinit_channel_context(sc);
+
 	mutex_lock(&sc->mutex);
 
 	ath_cancel_work(sc);
-- 
2.0.4

