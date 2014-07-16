Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33650 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934406AbaGPNuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 09:50:03 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so907261wgh.20
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 06:49:55 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: prevent some tx flushing failures
Date: Wed, 16 Jul 2014 15:41:13 +0200
Message-Id: <1405518073-14513-1-git-send-email-michal.kazior@tieto.com> (sfid-20140716_155152_259712_FE427AA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware could request inspection of some
submitted tx requests. Since the callback wasn't
implemented it was possible to bleed tx msdu_ids
which could translate to tx flushing timeouts.

There's nothing ath10k can do to help firmware
with tx processing now so just report all tx
frames as already inspected to prevent firmware
from sending up inspection events and force it to
report regular tx completion indications with
discard status.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 7 +++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index eebc860..318efc3 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1516,6 +1516,13 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		trace_ath10k_htt_stats(skb->data, skb->len);
 		break;
 	case HTT_T2H_MSG_TYPE_TX_INSPECT_IND:
+		/* Firmware can return tx frames if it's unable to fully
+		 * process them and suspects host may be able to fix it. ath10k
+		 * sends all tx frames as already inspected so this shouldn't
+		 * happen unless fw has a bug.
+		 */
+		ath10k_warn("received an unexpected htt tx inspect event\n");
+		break;
 	case HTT_T2H_MSG_TYPE_RX_ADDBA:
 	case HTT_T2H_MSG_TYPE_RX_DELBA:
 	case HTT_T2H_MSG_TYPE_RX_FLUSH:
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index accb6b4..8b27bfc 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -531,6 +531,12 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L3_OFFLOAD;
 	flags1 |= HTT_DATA_TX_DESC_FLAGS1_CKSUM_L4_OFFLOAD;
 
+	/* Prevent firmware from sending up tx inspection requests. There's
+	 * nothing ath10k can do with frames requested for inspection so force
+	 * it to simply rely a regular tx completion with discard status.
+	 */
+	flags1 |= HTT_DATA_TX_DESC_FLAGS1_POSTPONED;
+
 	skb_cb->htt.txbuf->cmd_hdr.msg_type = HTT_H2T_MSG_TYPE_TX_FRM;
 	skb_cb->htt.txbuf->cmd_tx.flags0 = flags0;
 	skb_cb->htt.txbuf->cmd_tx.flags1 = __cpu_to_le16(flags1);
-- 
1.8.5.3

