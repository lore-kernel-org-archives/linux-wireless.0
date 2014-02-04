Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1169 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbaBDAka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 19:40:30 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 24/30] mwifiex: AMPDU support for TDLS link
Date: Mon, 3 Feb 2014 16:39:59 -0800
Message-ID: <1391474404-8103-5-git-send-email-bzhao@marvell.com> (sfid-20140204_014043_348295_530AC024)
In-Reply-To: <1391474404-8103-1-git-send-email-bzhao@marvell.com>
References: <1391474404-8103-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds AMPDU support for TDLS link. We have set 11n
capabilities including AMPDU parameters during ENABLE_LINK.
We set a variable in RA list to indicate this as TDLS link.
This patch uses these capabilities to know if AMPDU is allowed
on TDLS link and enables AMPDU aggregation for TX and RX reording
support for RA list for this peer.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.h           | 18 ++++++++++++++++--
 drivers/net/wireless/mwifiex/11n_rxreorder.c |  6 +++++-
 drivers/net/wireless/mwifiex/main.h          |  1 +
 drivers/net/wireless/mwifiex/tdls.c          |  1 +
 drivers/net/wireless/mwifiex/wmm.c           |  9 ++++++++-
 5 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index fde39fe..12bb6ac 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -81,11 +81,15 @@ static inline u8
 mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
 			 struct mwifiex_ra_list_tbl *ptr, int tid)
 {
-	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP) {
 		return mwifiex_is_station_ampdu_allowed(priv, ptr, tid);
-	else
+	} else {
+		if (ptr->tdls_link)
+			return mwifiex_is_station_ampdu_allowed(priv, ptr, tid);
+
 		return (priv->aggr_prio_tbl[tid].ampdu_ap !=
 			BA_STREAM_NOT_ALLOWED) ? true : false;
+	}
 }
 
 /*
@@ -179,4 +183,14 @@ static inline int mwifiex_is_sta_11n_enabled(struct mwifiex_private *priv,
 
 	return node->is_11n_enabled;
 }
+
+static inline u8
+mwifiex_tdls_peer_11n_enabled(struct mwifiex_private *priv, u8 *ra)
+{
+	struct mwifiex_sta_node *node = mwifiex_get_sta_entry(priv, ra);
+	if (node)
+		return node->is_11n_enabled;
+
+	return false;
+}
 #endif /* !_MWIFIEX_11N_H_ */
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index ada809f..3767399 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -290,7 +290,11 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 				last_seq = node->rx_seq[tid];
 		}
 	} else {
-		last_seq = priv->rx_seq[tid];
+		node = mwifiex_get_sta_entry(priv, ta);
+		if (node)
+			last_seq = node->rx_seq[tid];
+		else
+			last_seq = priv->rx_seq[tid];
 	}
 
 	if (last_seq != MWIFIEX_DEF_11N_RX_SEQ_NUM &&
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 19c60b2..9696d57 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -210,6 +210,7 @@ struct mwifiex_ra_list_tbl {
 	u16 ba_pkt_count;
 	u8 ba_packet_thr;
 	u16 total_pkt_count;
+	bool tdls_link;
 };
 
 struct mwifiex_tid_tbl {
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index ed2ba95..0950bc3 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -49,6 +49,7 @@ mwifiex_restore_tdls_packets(struct mwifiex_private *priv, u8 *mac, u8 status)
 
 		if (status == TDLS_SETUP_COMPLETE) {
 			ra_list = mwifiex_wmm_get_queue_raptr(priv, tid, mac);
+			ra_list->tdls_link = true;
 			tx_info->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
 		} else {
 			tid_list = &priv->wmm.tid_tbl_ptr[tid_down].ra_list;
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 63496ed..e0ba011 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -160,8 +160,15 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 			break;
 
 		ra_list->is_11n_enabled = 0;
+		ra_list->tdls_link = false;
 		if (!mwifiex_queuing_ra_based(priv)) {
-			ra_list->is_11n_enabled = IS_11N_ENABLED(priv);
+			if (mwifiex_get_tdls_link_status(priv, ra) ==
+			    TDLS_SETUP_COMPLETE) {
+				ra_list->is_11n_enabled =
+					mwifiex_tdls_peer_11n_enabled(priv, ra);
+			} else {
+				ra_list->is_11n_enabled = IS_11N_ENABLED(priv);
+			}
 		} else {
 			ra_list->is_11n_enabled =
 				      mwifiex_is_sta_11n_enabled(priv, node);
-- 
1.8.2.3

