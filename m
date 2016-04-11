Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33344 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbcDKIQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 04:16:04 -0400
Date: Mon, 11 Apr 2016 11:15:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch v2] ath10k: add some sanity checks
Message-ID: <20160411081520.GA17911@mwanda> (sfid-20160411_101641_111223_46FD29F8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+BoTQmpYtGoYk4M-NaFduO8iX0KYgoLz6Mj_40i0um8MqDdww@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains that since "ev->peer_id" comes from skb->data that
means we can't trust it and have to do a bounds check on it to prevent
an array overflow.

Fixes: 6942726f7f7b ('ath10k: add fast peer_map lookup')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Add a warning message.  There is a checkpatch.pl warning that
the alignment should match the open parenthesis but I ignored it because
we're going off the end of the 80 character limit and this way is fine.

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 9369411..0885fce 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -190,6 +190,13 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
 	struct ath10k *ar = htt->ar;
 	struct ath10k_peer *peer;
 
+	if (ev->peer_id >= ATH10K_MAX_NUM_PEER_IDS) {
+		ath10k_warn(ar,
+			"received htt peer map event with idx out of bounds: %hu\n",
+			ev->peer_id);
+		return;
+	}
+
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find(ar, ev->vdev_id, ev->addr);
 	if (!peer) {
@@ -218,6 +225,13 @@ void ath10k_peer_unmap_event(struct ath10k_htt *htt,
 	struct ath10k *ar = htt->ar;
 	struct ath10k_peer *peer;
 
+	if (ev->peer_id >= ATH10K_MAX_NUM_PEER_IDS) {
+		ath10k_warn(ar,
+			"received htt peer unmap event with idx out of bounds: %hu\n",
+			ev->peer_id);
+		return;
+	}
+
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, ev->peer_id);
 	if (!peer) {
