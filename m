Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11450 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbbIRNdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDOkxU030872
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:06 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7eqj-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:06 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 09/16] mwifiex: correct paused tx data packet counter
Date: Fri, 18 Sep 2015 06:32:11 -0700
Message-ID: <1442583138-2979-10-git-send-email-akarwar@marvell.com> (sfid-20150918_153313_101188_3EE26DB5)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch fixes observed issues while updating counter for
number of paused data packets in wmm queue when trying to
delete packet or delete station entry.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_txrx.c | 10 +++++++---
 drivers/net/wireless/mwifiex/wmm.c      |  9 +++++++--
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
index 8766741..74d5d72 100644
--- a/drivers/net/wireless/mwifiex/uap_txrx.c
+++ b/drivers/net/wireless/mwifiex/uap_txrx.c
@@ -31,7 +31,8 @@
  */
 static bool
 mwifiex_uap_del_tx_pkts_in_ralist(struct mwifiex_private *priv,
-				  struct list_head *ra_list_head)
+				  struct list_head *ra_list_head,
+				  int tid)
 {
 	struct mwifiex_ra_list_tbl *ra_list;
 	struct sk_buff *skb, *tmp;
@@ -49,7 +50,10 @@ mwifiex_uap_del_tx_pkts_in_ralist(struct mwifiex_private *priv,
 				__skb_unlink(skb, &ra_list->skb_head);
 				mwifiex_write_data_complete(adapter, skb, 0,
 							    -1);
-				atomic_dec(&priv->wmm.tx_pkts_queued);
+				if (ra_list->tx_paused)
+					priv->wmm.pkts_paused[tid]--;
+				else
+					atomic_dec(&priv->wmm.tx_pkts_queued);
 				pkt_deleted = true;
 			}
 			if ((atomic_read(&adapter->pending_bridged_pkts) <=
@@ -77,7 +81,7 @@ static void mwifiex_uap_cleanup_tx_queues(struct mwifiex_private *priv)
 		if (priv->del_list_idx == MAX_NUM_TID)
 			priv->del_list_idx = 0;
 		ra_list = &priv->wmm.tid_tbl_ptr[priv->del_list_idx].ra_list;
-		if (mwifiex_uap_del_tx_pkts_in_ralist(priv, ra_list)) {
+		if (mwifiex_uap_del_tx_pkts_in_ralist(priv, ra_list, i)) {
 			priv->del_list_idx++;
 			break;
 		}
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 173d366..8e30fb3 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -160,7 +160,6 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 		ra_list->tdls_link = false;
 		ra_list->ba_status = BA_SETUP_NONE;
 		ra_list->amsdu_in_ampdu = false;
-		ra_list->tx_paused = false;
 		if (!mwifiex_queuing_ra_based(priv)) {
 			if (mwifiex_is_tdls_link_setup
 				(mwifiex_get_tdls_link_status(priv, ra))) {
@@ -173,6 +172,8 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 		} else {
 			spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 			node = mwifiex_get_sta_entry(priv, ra);
+			if (node)
+				ra_list->tx_paused = node->tx_pause;
 			ra_list->is_11n_enabled =
 				      mwifiex_is_sta_11n_enabled(priv, node);
 			if (ra_list->is_11n_enabled)
@@ -737,7 +738,11 @@ mwifiex_wmm_del_peer_ra_list(struct mwifiex_private *priv, const u8 *ra_addr)
 		if (!ra_list)
 			continue;
 		mwifiex_wmm_del_pkts_in_ralist_node(priv, ra_list);
-		atomic_sub(ra_list->total_pkt_count, &priv->wmm.tx_pkts_queued);
+		if (ra_list->tx_paused)
+			priv->wmm.pkts_paused[i] -= ra_list->total_pkt_count;
+		else
+			atomic_sub(ra_list->total_pkt_count,
+				   &priv->wmm.tx_pkts_queued);
 		list_del(&ra_list->list);
 		kfree(ra_list);
 	}
-- 
1.8.1.4

