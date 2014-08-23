Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43357 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaHWH72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 03/18] ath9k: Make ath_chanctx_work static
Date: Sat, 23 Aug 2014 13:29:08 +0530
Message-Id: <1408780763-27974-4-git-send-email-sujith@msujith.org> (sfid-20140823_095938_612096_39D793E2)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Also compile it conditionally based on
CONFIG_ATH9K_CHANNEL_CONTEXT.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 -
 drivers/net/wireless/ath/ath9k/channel.c | 18 +++++++++---------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e88e18d..f3455ce 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -633,7 +633,6 @@ void ath9k_csa_update(struct ath_softc *sc);
 #define ATH_PAPRD_TIMEOUT         100 /* msecs */
 #define ATH_PLL_WORK_INTERVAL     100
 
-void ath_chanctx_work(struct work_struct *work);
 void ath_tx_complete_poll_work(struct work_struct *work);
 void ath_reset_work(struct work_struct *work);
 bool ath_hw_check(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 9c2cf90..0b84917 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -305,15 +305,6 @@ static void ath_chanctx_set_next(struct ath_softc *sc, bool force)
 	ath_chanctx_event(sc, NULL, ATH_CHANCTX_EVENT_SWITCH);
 }
 
-void ath_chanctx_work(struct work_struct *work)
-{
-	struct ath_softc *sc = container_of(work, struct ath_softc,
-					    chanctx_work);
-	mutex_lock(&sc->mutex);
-	ath_chanctx_set_next(sc, false);
-	mutex_unlock(&sc->mutex);
-}
-
 void ath_chanctx_init(struct ath_softc *sc)
 {
 	struct ath_chanctx *ctx;
@@ -949,6 +940,15 @@ static void ath_offchannel_timer(unsigned long data)
 	}
 }
 
+static void ath_chanctx_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    chanctx_work);
+	mutex_lock(&sc->mutex);
+	ath_chanctx_set_next(sc, false);
+	mutex_unlock(&sc->mutex);
+}
+
 void ath9k_init_channel_context(struct ath_softc *sc)
 {
 	INIT_WORK(&sc->chanctx_work, ath_chanctx_work);
-- 
2.0.4

