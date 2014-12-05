Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50559 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbaLEMYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 07:24:31 -0500
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/4] mwifiex: delete peer station's RA list upon deauthentication
Date: Fri, 5 Dec 2014 23:23:40 +0530
Message-ID: <1417802022-7364-2-git-send-email-patila@marvell.com> (sfid-20141205_132445_952263_0CCC33FB)
In-Reply-To: <1417802022-7364-1-git-send-email-patila@marvell.com>
References: <1417802022-7364-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to delete peer station's RA lists
upon station deautheticate event on AP interface. Patch also
decrements TX pending count upon removing packets from RA list.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h      |  2 ++
 drivers/net/wireless/mwifiex/uap_event.c |  1 +
 drivers/net/wireless/mwifiex/wmm.c       | 26 ++++++++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index bdba37b..e66993c 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -975,6 +975,8 @@ int mwifiex_handle_uap_rx_forward(struct mwifiex_private *priv,
 int mwifiex_process_sta_event(struct mwifiex_private *);
 int mwifiex_process_uap_event(struct mwifiex_private *);
 void mwifiex_delete_all_station_list(struct mwifiex_private *priv);
+void mwifiex_wmm_del_peer_ra_list(struct mwifiex_private *priv,
+				  const u8 *ra_addr);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 void *mwifiex_process_uap_txpd(struct mwifiex_private *, struct sk_buff *skb);
 int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 38390cb..c54a537 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -110,6 +110,7 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 			mwifiex_11n_del_rx_reorder_tbl_by_ta(priv, deauth_mac);
 			mwifiex_del_tx_ba_stream_tbl_by_ra(priv, deauth_mac);
 		}
+		mwifiex_wmm_del_peer_ra_list(priv, deauth_mac);
 		mwifiex_del_sta_entry(priv, deauth_mac);
 		break;
 	case EVENT_UAP_BSS_IDLE:
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index dc1f2ad..0dafcb0 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -611,6 +611,32 @@ mwifiex_wmm_get_queue_raptr(struct mwifiex_private *priv, u8 tid,
 }
 
 /*
+ * This function deletes RA list nodes for given mac for all TIDs.
+ * Function also decrements TX pending count accordingly.
+ */
+void
+mwifiex_wmm_del_peer_ra_list(struct mwifiex_private *priv, const u8 *ra_addr)
+{
+	struct mwifiex_ra_list_tbl *ra_list;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+
+	for (i = 0; i < MAX_NUM_TID; ++i) {
+		ra_list = mwifiex_wmm_get_ralist_node(priv, i, ra_addr);
+
+		if (!ra_list)
+			continue;
+		mwifiex_wmm_del_pkts_in_ralist_node(priv, ra_list);
+		atomic_sub(ra_list->total_pkt_count, &priv->wmm.tx_pkts_queued);
+		list_del(&ra_list->list);
+		kfree(ra_list);
+	}
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+}
+
+/*
  * This function checks if a particular RA list node exists in a given TID
  * table index.
  */
-- 
1.8.1.4

