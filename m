Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59017 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaHWNmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 09:42:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/4] ath9k: Fix channel context variables in ath_softc
Date: Sat, 23 Aug 2014 19:12:13 +0530
Message-Id: <1408801336-7626-2-git-send-email-sujith@msujith.org> (sfid-20140823_154225_419907_88C3DD40)
In-Reply-To: <1408801336-7626-1-git-send-email-sujith@msujith.org>
References: <1408801336-7626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

chanctx_work and next_chan are required only when
CONFIG_ATH9K_CHANNEL_CONTEXT is enabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 02664b3..a2f4fa7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -324,6 +324,10 @@ struct ath_rx {
 	u32 ampdu_ref;
 };
 
+/*******************/
+/* Channel Context */
+/*******************/
+
 struct ath_chanctx {
 	struct cfg80211_chan_def chandef;
 	struct list_head vifs;
@@ -917,15 +921,16 @@ struct ath_softc {
 	struct mutex mutex;
 	struct work_struct paprd_work;
 	struct work_struct hw_reset_work;
-	struct work_struct chanctx_work;
 	struct completion paprd_complete;
 	wait_queue_head_t tx_wait;
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+	struct work_struct chanctx_work;
 	struct ath_gen_timer *p2p_ps_timer;
 	struct ath_vif *p2p_ps_vif;
 	struct ath_chanctx_sched sched;
 	struct ath_offchannel offchannel;
+	struct ath_chanctx *next_chan;
 #endif
 
 	unsigned long driver_data;
@@ -947,7 +952,6 @@ struct ath_softc {
 	struct cfg80211_chan_def cur_chandef;
 	struct ath_chanctx chanctx[ATH9K_NUM_CHANCTX];
 	struct ath_chanctx *cur_chan;
-	struct ath_chanctx *next_chan;
 	spinlock_t chan_lock;
 
 #ifdef CONFIG_MAC80211_LEDS
-- 
2.0.4

