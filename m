Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:52243 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHWH7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 12/18] ath9k: Fix function declarations
Date: Sat, 23 Aug 2014 13:29:17 +0530
Message-Id: <1408780763-27974-13-git-send-email-sujith@msujith.org> (sfid-20140823_095943_800939_A681305B)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

These routines are required only when
CONFIG_ATH9K_CHANNEL_CONTEXT is enabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5220f2f..8cf8e4f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -418,9 +418,6 @@ void ath_chanctx_init(struct ath_softc *sc);
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
-void ath_offchannel_next(struct ath_softc *sc);
-void ath_scan_complete(struct ath_softc *sc, bool abort);
-void ath_roc_complete(struct ath_softc *sc, bool abort);
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 bool ath9k_is_chanctx_enabled(void);
@@ -439,6 +436,9 @@ void ath9k_p2p_ps_timer(void *priv);
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev);
 void ath_chanctx_set_next(struct ath_softc *sc, bool force);
+void ath_offchannel_next(struct ath_softc *sc);
+void ath_scan_complete(struct ath_softc *sc, bool abort);
+void ath_roc_complete(struct ath_softc *sc, bool abort);
 #else
 static inline bool ath9k_is_chanctx_enabled(void)
 {
-- 
2.0.4

