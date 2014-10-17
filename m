Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:44289 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaJQCKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 22:10:08 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 09/23] ath9k: Fix MCC flush timeout
Date: Fri, 17 Oct 2014 07:40:16 +0530
Message-Id: <1413511830-5536-10-git-send-email-sujith@msujith.org> (sfid-20141017_041012_149094_5B2D3497)
In-Reply-To: <1413511830-5536-1-git-send-email-sujith@msujith.org>
References: <1413511830-5536-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In MCC mode, the duration for a channel context
is half the beacon interval and having a large
flush timeout will adversely affect GO operation,
since the default value of 200ms will overshoot
the advertised NoA absence duration.

The scheduler initiates a channel context switch
only when the slot duration for the current
context expires, so there is no possibility of
having a fixed timeout for flush.

Since the channel_switch_time is added to the
absence duration when the GO sets up the NoA
attribute, this is the maximum time that we
have to flush the TX queues. The duration is very
small, but we don't have a choice in MCC mode.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/channel.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 5045b10..7e518aa 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -199,6 +199,7 @@ static const char *chanctx_state_string(enum ath_chanctx_state state)
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_chanctx *ictx;
 	struct ath_vif *avp;
 	bool active = false;
 	u8 n_active = 0;
@@ -206,6 +207,8 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 	if (!ctx)
 		return;
 
+	ictx = ctx;
+
 	list_for_each_entry(avp, &ctx->vifs, list) {
 		struct ieee80211_vif *vif = avp->vif;
 
@@ -228,12 +231,23 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
 		n_active++;
 	}
 
+	spin_lock_bh(&sc->chan_lock);
+
 	if (n_active <= 1) {
+		ictx->flush_timeout = HZ / 5;
 		clear_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags);
+		spin_unlock_bh(&sc->chan_lock);
 		return;
 	}
-	if (test_and_set_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
+
+	ictx->flush_timeout = usecs_to_jiffies(sc->sched.channel_switch_time);
+
+	if (test_and_set_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags)) {
+		spin_unlock_bh(&sc->chan_lock);
 		return;
+	}
+
+	spin_unlock_bh(&sc->chan_lock);
 
 	if (ath9k_is_chanctx_enabled()) {
 		ath_chanctx_event(sc, NULL,
-- 
2.1.2

