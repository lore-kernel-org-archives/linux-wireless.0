Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:49137 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbaFQJlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2014 05:41:01 -0400
Subject: [PATCH 2/6] ath6kl: implement rx flush for htc pipe
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Jun 2014 12:40:58 +0300
Message-ID: <20140617094058.22040.10223.stgit@potku.adurom.net> (sfid-20140617_114104_852516_FF3D70D1)
In-Reply-To: <20140617093836.22040.99081.stgit@potku.adurom.net>
References: <20140617093836.22040.99081.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jessica Wu <kvalo@qca.qualcomm.com>

rx flush was not implemented for htc pipe, add that now. Doesn't fix any known
issues.

Also free the skb if htc control messages get canceled.

Signed-off-by: Jessica Wu <wjessica@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   32 +++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 756fe52a12c8..ca1a18c86c0d 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -1170,8 +1170,12 @@ static int htc_wait_recv_ctrl_message(struct htc_target *target)
 static void htc_rxctrl_complete(struct htc_target *context,
 				struct htc_packet *packet)
 {
-	/* TODO, can't really receive HTC control messages yet.... */
-	ath6kl_dbg(ATH6KL_DBG_HTC, "%s: invalid call function\n", __func__);
+	struct sk_buff *skb = packet->skb;
+
+	if (packet->endpoint == ENDPOINT_0 &&
+	    packet->status == -ECANCELED &&
+	    skb != NULL)
+		dev_kfree_skb(skb);
 }
 
 /* htc pipe initialization */
@@ -1678,7 +1682,29 @@ static void ath6kl_htc_pipe_activity_changed(struct htc_target *target,
 
 static void ath6kl_htc_pipe_flush_rx_buf(struct htc_target *target)
 {
-	/* TODO */
+	struct htc_endpoint *endpoint;
+	struct htc_packet *packet, *tmp_pkt;
+	int i;
+
+	for (i = ENDPOINT_0; i < ENDPOINT_MAX; i++) {
+		endpoint = &target->endpoint[i];
+
+		spin_lock_bh(&target->rx_lock);
+
+		list_for_each_entry_safe(packet, tmp_pkt,
+					 &endpoint->rx_bufq, list) {
+			list_del(&packet->list);
+			spin_unlock_bh(&target->rx_lock);
+			ath6kl_dbg(ATH6KL_DBG_HTC,
+				   "htc rx flush pkt 0x%p len %d ep %d\n",
+				   packet, packet->buf_len,
+				   packet->endpoint);
+			dev_kfree_skb(packet->pkt_cntxt);
+			spin_lock_bh(&target->rx_lock);
+		}
+
+		spin_unlock_bh(&target->rx_lock);
+	}
 }
 
 static int ath6kl_htc_pipe_credit_setup(struct htc_target *target,

