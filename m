Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50621 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbcDKHpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 03:45:18 -0400
Date: Mon, 11 Apr 2016 10:44:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] ath10k: add some sanity checks
Message-ID: <20160411074438.GA15227@mwanda> (sfid-20160411_094523_478562_464ECAEC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains that since "ev->peer_id" comes from skb->data that
means we can't trust it and have to do a bounds check on it to prevent
an array overflow.

Fixes: 6942726f7f7b ('ath10k: add fast peer_map lookup')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 9369411..fd6ba69 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -190,6 +190,9 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
 	struct ath10k *ar = htt->ar;
 	struct ath10k_peer *peer;
 
+	if (ev->peer_id >= ATH10K_MAX_NUM_PEER_IDS)
+		return;
+
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find(ar, ev->vdev_id, ev->addr);
 	if (!peer) {
@@ -218,6 +221,9 @@ void ath10k_peer_unmap_event(struct ath10k_htt *htt,
 	struct ath10k *ar = htt->ar;
 	struct ath10k_peer *peer;
 
+	if (ev->peer_id >= ATH10K_MAX_NUM_PEER_IDS)
+		return;
+
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, ev->peer_id);
 	if (!peer) {
