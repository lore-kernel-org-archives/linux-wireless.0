Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab1DTOCn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 10:02:43 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH wireless-2.6] iwl4965: fix skb usage after free
Date: Wed, 20 Apr 2011 16:01:46 +0200
Message-Id: <1303308106-5263-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since

commit a120e912eb51e347f36c71b60a1d13af74d30e83
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Feb 19 15:47:33 2010 -0800

    iwlwifi: sanity check before counting number of tfds can be free

we use skb->data after calling ieee80211_tx_status_irqsafe(), which
could free skb instantly.

On current kernels I do not observe practical problems related with
bug, but on 2.6.35.y it cause random system hangs when stressing
wireless link, making bisection of other problems impossible.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 5c40502..fbec88d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -1127,12 +1127,16 @@ int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	     q->read_ptr = iwl_legacy_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
-		iwl4965_tx_status(priv, tx_info,
-				 txq_id >= IWL4965_FIRST_AMPDU_QUEUE);
+
+		if (WARN_ON_ONCE(tx_info->skb == NULL))
+			continue;
 
 		hdr = (struct ieee80211_hdr *)tx_info->skb->data;
-		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+		if (ieee80211_is_data_qos(hdr->frame_control))
 			nfreed++;
+
+		iwl4965_tx_status(priv, tx_info,
+				 txq_id >= IWL4965_FIRST_AMPDU_QUEUE);
 		tx_info->skb = NULL;
 
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
-- 
1.7.1

