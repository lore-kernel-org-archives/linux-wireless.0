Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:35689 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbdALPNR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 10:13:17 -0500
Received: by mail-lf0-f44.google.com with SMTP id m78so14976721lfg.2
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 07:13:17 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        greearb@candelatech.com, mohammed@qti.qualcomm.com,
        Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: prevent sta pointer rcu violation
Date: Thu, 12 Jan 2017 16:14:30 +0100
Message-Id: <1484234070-7431-1-git-send-email-michal.kazior@tieto.com> (sfid-20170112_161320_723424_362B312F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Station pointers are RCU protected so driver must
be extra careful if it tries to store them
internally for later use outside of the RCU
section it obtained it in.

It was possible for station teardown to race with
some htt events. The possible outcome could be a
use-after-free and a crash.

Only peer-flow-control capable firmware was
affected (so hardware-wise qca99x0 and qca4019).

This could be done in sta_state() itself via
explicit synchronize_net() call but there's
already a convenient sta_pre_rcu_remove() op that
can be hooked up to avoid extra rcu stall.

The peer->sta pointer itself can't be set to
NULL/ERR_PTR because it is later used in
sta_state() for extra sanity checks.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c7664d6569fa..1ab589296dff 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -314,6 +314,7 @@ struct ath10k_peer {
 	struct ieee80211_vif *vif;
 	struct ieee80211_sta *sta;
 
+	bool removed;
 	int vdev_id;
 	u8 addr[ETH_ALEN];
 	DECLARE_BITMAP(peer_ids, ATH10K_MAX_NUM_PEER_IDS);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d1b7edba5e49..aa91f55b35a4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3774,6 +3774,9 @@ struct ieee80211_txq *ath10k_mac_txq_lookup(struct ath10k *ar,
 	if (!peer)
 		return NULL;
 
+	if (peer->removed)
+		return NULL;
+
 	if (peer->sta)
 		return peer->sta->txq[tid];
 	else if (peer->vif)
@@ -7476,6 +7479,20 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static void ath10k_mac_op_sta_pre_rcu_remove(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_sta *sta)
+{
+	struct ath10k *ar;
+	struct ath10k_peer *peer;
+
+	ar = hw->priv;
+
+	list_for_each_entry(peer, &ar->peers, list)
+		if (peer->sta == sta)
+			peer->removed = true;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_mac_op_tx,
 	.wake_tx_queue			= ath10k_mac_op_wake_tx_queue,
@@ -7516,6 +7533,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.assign_vif_chanctx		= ath10k_mac_op_assign_vif_chanctx,
 	.unassign_vif_chanctx		= ath10k_mac_op_unassign_vif_chanctx,
 	.switch_vif_chanctx		= ath10k_mac_op_switch_vif_chanctx,
+	.sta_pre_rcu_remove		= ath10k_mac_op_sta_pre_rcu_remove,
 
 	CFG80211_TESTMODE_CMD(ath10k_tm_cmd)
 
-- 
2.1.4
