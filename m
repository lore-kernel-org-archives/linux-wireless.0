Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60829 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab1KHObd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:31:33 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix packet drop when ath6kl_cookie runs out
Date: Tue, 8 Nov 2011 20:01:25 +0530
Message-ID: <1320762685-4665-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111108_153153_118583_AD3D86D1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ath6kl: Maintain virtual interface in a list" mistakenly stops the
netq only when the mode is ibss. This causes packet drops in sta mode
when the available cookies (buffer abstraction in ath6kl and also used
for tx throttling) runs out for the highest priority traffic. This patch
just fixes this regression though the original code may still need fixes
which can be addressed in separate patches.

Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 62beadb..0b45d45 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -453,11 +453,11 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 		set_bit(WMI_CTRL_EP_FULL, &ar->flag);
 		spin_unlock_bh(&ar->lock);
 		ath6kl_err("wmi ctrl ep is full\n");
-		goto stop_adhoc_netq;
+		return action;
 	}
 
 	if (packet->info.tx.tag == ATH6KL_CONTROL_PKT_TAG)
-		goto stop_adhoc_netq;
+		return action;
 
 	/*
 	 * The last MAX_HI_COOKIE_NUM "batch" of cookies are reserved for
@@ -465,20 +465,18 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 	 */
 	if (ar->ac_stream_pri_map[ar->ep2ac_map[endpoint]] <
 	    ar->hiac_stream_active_pri &&
-	    ar->cookie_count <= MAX_HI_COOKIE_NUM) {
+	    ar->cookie_count <= MAX_HI_COOKIE_NUM)
 		/*
 		 * Give preference to the highest priority stream by
 		 * dropping the packets which overflowed.
 		 */
 		action = HTC_SEND_FULL_DROP;
-		goto stop_adhoc_netq;
-	}
 
-stop_adhoc_netq:
 	/* FIXME: Locking */
 	spin_lock_bh(&ar->list_lock);
 	list_for_each_entry(vif, &ar->vif_list, list) {
-		if (vif->nw_type == ADHOC_NETWORK) {
+		if (vif->nw_type == ADHOC_NETWORK ||
+		    action != HTC_SEND_FULL_DROP) {
 			spin_unlock_bh(&ar->list_lock);
 
 			spin_lock_bh(&vif->if_lock);
-- 
1.7.0.4

