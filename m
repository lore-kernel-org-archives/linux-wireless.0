Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:43938 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaJNEAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 00:00:01 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/9] ath9k: Add a function to check for an active GO
Date: Tue, 14 Oct 2014 09:30:48 +0530
Message-Id: <1413259256-4808-2-git-send-email-sujith@msujith.org> (sfid-20141014_060044_618111_6D95292F)
In-Reply-To: <1413259256-4808-1-git-send-email-sujith@msujith.org>
References: <1413259256-4808-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 +
 drivers/net/wireless/ath/ath9k/channel.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9e92cb21..8f6f46c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -469,6 +469,7 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force);
 void ath_offchannel_next(struct ath_softc *sc);
 void ath_scan_complete(struct ath_softc *sc, bool abort);
 void ath_roc_complete(struct ath_softc *sc, bool abort);
+struct ath_chanctx* ath_is_go_chanctx_present(struct ath_softc *sc);
 
 #else
 
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 9c4f872..2066b09 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -146,6 +146,36 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 
+/*************/
+/* Utilities */
+/*************/
+
+struct ath_chanctx* ath_is_go_chanctx_present(struct ath_softc *sc)
+{
+	struct ath_chanctx *ctx;
+	struct ath_vif *avp;
+	struct ieee80211_vif *vif;
+
+	spin_lock_bh(&sc->chan_lock);
+
+	ath_for_each_chanctx(sc, ctx) {
+		if (!ctx->active)
+			continue;
+
+		list_for_each_entry(avp, &ctx->vifs, list) {
+			vif = avp->vif;
+
+			if (ieee80211_vif_type_p2p(vif) == NL80211_IFTYPE_P2P_GO) {
+				spin_unlock_bh(&sc->chan_lock);
+				return ctx;
+			}
+		}
+	}
+
+	spin_unlock_bh(&sc->chan_lock);
+	return NULL;
+}
+
 /**********************************************************/
 /* Functions to handle the channel context state machine. */
 /**********************************************************/
-- 
2.1.2

