Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:51985 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3IHO4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:56:04 -0400
Subject: [PATCH 6/8] ath10k: add boot messages to htt.c
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:56:02 +0300
Message-ID: <20130908145602.3136.1295.stgit@localhost6.localdomain6> (sfid-20130908_165607_530326_E0361221)
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To unify the boot debug level.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    2 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index af31d2f..a39fbf4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -502,7 +502,7 @@ int ath10k_htt_rx_attach(struct ath10k_htt *htt)
 	if (__ath10k_htt_rx_ring_fill_n(htt, htt->rx_ring.fill_level))
 		goto err_fill_ring;
 
-	ath10k_dbg(ATH10K_DBG_HTT, "HTT RX ring size: %d, fill_level: %d\n",
+	ath10k_dbg(ATH10K_DBG_BOOT, "htt rx ring size %d fill_level %d\n",
 		   htt->rx_ring.size, htt->rx_ring.fill_level);
 	return 0;
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index b6b1420..4548128 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -96,7 +96,7 @@ int ath10k_htt_tx_attach(struct ath10k_htt *htt)
 	htt->max_num_pending_tx = ath10k_hif_get_free_queue_number(htt->ar,
 								   pipe);
 
-	ath10k_dbg(ATH10K_DBG_HTT, "htt tx max num pending tx %d\n",
+	ath10k_dbg(ATH10K_DBG_BOOT, "htt tx max num pending tx %d\n",
 		   htt->max_num_pending_tx);
 
 	htt->pending_tx = kzalloc(sizeof(*htt->pending_tx) *

