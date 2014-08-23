Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56252 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaHWH7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:50 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 18/18] ath9k: Fix 'offchannel' in ath_softc
Date: Sat, 23 Aug 2014 13:29:23 +0530
Message-Id: <1408780763-27974-19-git-send-email-sujith@msujith.org> (sfid-20140823_101534_018486_B0520A8F)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Finally move the 'offchannel' instance in ath_softc
inside a CONFIG_ATH9K_CHANNEL_CONTEXT cage. The offchannel
usage in ath9k_calculate_iter_data() is closed off with
an ifdef for now, since the state/opmode calculation is
common for both the channel context mode and the normal mode.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 2 +-
 drivers/net/wireless/ath/ath9k/main.c  | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8767aa7..02664b3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -925,6 +925,7 @@ struct ath_softc {
 	struct ath_gen_timer *p2p_ps_timer;
 	struct ath_vif *p2p_ps_vif;
 	struct ath_chanctx_sched sched;
+	struct ath_offchannel offchannel;
 #endif
 
 	unsigned long driver_data;
@@ -948,7 +949,6 @@ struct ath_softc {
 	struct ath_chanctx *cur_chan;
 	struct ath_chanctx *next_chan;
 	spinlock_t chan_lock;
-	struct ath_offchannel offchannel;
 
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bc7a780..da63487 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -958,6 +958,7 @@ void ath9k_calculate_iter_data(struct ath_softc *sc,
 	list_for_each_entry(avp, &ctx->vifs, list)
 		ath9k_vif_iter(iter_data, avp->vif->addr, avp->vif);
 
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 	if (ctx == &sc->offchannel.chan) {
 		struct ieee80211_vif *vif;
 
@@ -970,6 +971,7 @@ void ath9k_calculate_iter_data(struct ath_softc *sc,
 			ath9k_vif_iter(iter_data, vif->addr, vif);
 		iter_data->beacons = false;
 	}
+#endif
 }
 
 static void ath9k_set_assoc_state(struct ath_softc *sc,
-- 
2.0.4

