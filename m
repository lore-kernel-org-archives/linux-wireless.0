Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:42185 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab3GWCSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 02/21] mwifiex: rename pkt_count to ba_pkt_count in mwifiex_ra_list_tbl struct
Date: Mon, 22 Jul 2013 19:17:39 -0700
Message-ID: <1374545878-15683-3-git-send-email-bzhao@marvell.com> (sfid-20130723_041833_551103_0C669429)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

pkt_count is used to determine if BA can be formed on this RA list
by comparing it with randomly generated BA threshold. The pkt_count
variable name here is ambiguous and does not reflect its usage
correctly. Rename it to ba_pkt_count.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h | 2 +-
 drivers/net/wireless/mwifiex/wmm.c  | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 253e0bd..884b42b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -207,7 +207,7 @@ struct mwifiex_ra_list_tbl {
 	u32 total_pkts_size;
 	u32 is_11n_enabled;
 	u16 max_amsdu;
-	u16 pkt_count;
+	u16 ba_pkt_count;
 	u8 ba_packet_thr;
 };
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 944e884..9c1eeee 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -188,7 +188,7 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 			ra_list, ra_list->is_11n_enabled);
 
 		if (ra_list->is_11n_enabled) {
-			ra_list->pkt_count = 0;
+			ra_list->ba_pkt_count = 0;
 			ra_list->ba_packet_thr =
 					      mwifiex_get_random_ba_threshold();
 		}
@@ -680,7 +680,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	skb_queue_tail(&ra_list->skb_head, skb);
 
 	ra_list->total_pkts_size += skb->len;
-	ra_list->pkt_count++;
+	ra_list->ba_pkt_count++;
 
 	if (atomic_read(&priv->wmm.highest_queued_prio) <
 						tos_to_tid_inv[tid_down])
@@ -1063,7 +1063,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		skb_queue_tail(&ptr->skb_head, skb);
 
 		ptr->total_pkts_size += skb->len;
-		ptr->pkt_count++;
+		ptr->ba_pkt_count++;
 		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
@@ -1224,7 +1224,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		   mwifiex_send_single_packet() */
 	} else {
 		if (mwifiex_is_ampdu_allowed(priv, tid) &&
-		    ptr->pkt_count > ptr->ba_packet_thr) {
+		    ptr->ba_pkt_count > ptr->ba_packet_thr) {
 			if (mwifiex_space_avail_for_new_ba_stream(adapter)) {
 				mwifiex_create_ba_tbl(priv, ptr->ra, tid,
 						      BA_SETUP_INPROGRESS);
-- 
1.8.2.3

