Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35995 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbbFCKRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 06:17:16 -0400
Received: by wibdq8 with SMTP id dq8so85700620wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 03:17:15 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: fix ar->rx_channel updating logic
Date: Wed,  3 Jun 2015 12:16:54 +0200
Message-Id: <1433326616-23279-1-git-send-email-michal.kazior@tieto.com> (sfid-20150603_121719_941709_F3B81734)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel contexts aren't iterable until after
they've been added to the driver. The code assumed
otherwise.

This problem could result in:

 * rx_channel being NULL and forcing Rx path to go
   the slow way to get channel on QCA988X,

 * report incorrect channel when running
   multi-channel on QCA61X4 hw2.1,

 * report incorrect channel after AP channel
   switch.

Fixes: 500ff9f9389d ("ath10k: implement chanctx API")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f4de71721f7d..fe53b1f5e6c9 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6144,7 +6144,10 @@ static int ath10k_ampdu_action(struct ieee80211_hw *hw,
 }
 
 static void
-ath10k_mac_update_rx_channel(struct ath10k *ar)
+ath10k_mac_update_rx_channel(struct ath10k *ar,
+			     struct ieee80211_chanctx_conf *ctx,
+			     struct ieee80211_vif_chanctx_switch *vifs,
+			     int n_vifs)
 {
 	struct cfg80211_chan_def *def = NULL;
 
@@ -6154,6 +6157,9 @@ ath10k_mac_update_rx_channel(struct ath10k *ar)
 	lockdep_assert_held(&ar->conf_mutex);
 	lockdep_assert_held(&ar->data_lock);
 
+	WARN_ON(ctx && vifs);
+	WARN_ON(vifs && n_vifs != 1);
+
 	/* FIXME: Sort of an optimization and a workaround. Peers and vifs are
 	 * on a linked list now. Doing a lookup peer -> vif -> chanctx for each
 	 * ppdu on Rx may reduce performance on low-end systems. It should be
@@ -6165,11 +6171,17 @@ ath10k_mac_update_rx_channel(struct ath10k *ar)
 	 * affected much.
 	 */
 	rcu_read_lock();
-	if (ath10k_mac_num_chanctxs(ar) == 1) {
+	if (!ctx && ath10k_mac_num_chanctxs(ar) == 1) {
 		ieee80211_iter_chan_contexts_atomic(ar->hw,
 					ath10k_mac_get_any_chandef_iter,
 					&def);
+
+		if (vifs)
+			def = &vifs[0].new_ctx->def;
+
 		ar->rx_channel = def->chan;
+	} else if (ctx && ath10k_mac_num_chanctxs(ar) == 0) {
+		ar->rx_channel = ctx->def.chan;
 	} else {
 		ar->rx_channel = NULL;
 	}
@@ -6204,7 +6216,7 @@ ath10k_mac_op_add_chanctx(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&ar->data_lock);
 	ath10k_mac_chan_ctx_init(ar, arctx, ctx);
-	ath10k_mac_update_rx_channel(ar);
+	ath10k_mac_update_rx_channel(ar, ctx, NULL, 0);
 	spin_unlock_bh(&ar->data_lock);
 
 	ath10k_recalc_radar_detection(ar);
@@ -6228,7 +6240,7 @@ ath10k_mac_op_remove_chanctx(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	spin_lock_bh(&ar->data_lock);
-	ath10k_mac_update_rx_channel(ar);
+	ath10k_mac_update_rx_channel(ar, NULL, NULL, 0);
 	spin_unlock_bh(&ar->data_lock);
 
 	ath10k_recalc_radar_detection(ar);
@@ -6413,7 +6425,7 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 		 */
 		arctx_old->conf = *vifs[i].new_ctx;
 	}
-	ath10k_mac_update_rx_channel(ar);
+	ath10k_mac_update_rx_channel(ar, NULL, vifs, n_vifs);
 	spin_unlock_bh(&ar->data_lock);
 
 	/* FIXME: Reconfigure only affected vifs */
-- 
2.1.4

