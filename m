Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6278 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbbAGHK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 02:10:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0779G8l012337
	for <linux-wireless@vger.kernel.org>; Tue, 6 Jan 2015 23:10:55 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rqrtjpf41-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 23:10:55 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: do not emit messages while holding spinlock
Date: Wed, 7 Jan 2015 18:10:25 +0530
Message-ID: <1420634425-28306-1-git-send-email-patila@marvell.com> (sfid-20150107_081059_683326_970C28B9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid printing dev_{warn/dbg} messages while holding spinlock.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           | 2 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 9d4786e..c5c83cf 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -558,10 +558,10 @@ int mwifiex_send_addba(struct mwifiex_private *priv, int tid, u8 *peer_mac)
 		spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 		sta_ptr = mwifiex_get_sta_entry(priv, peer_mac);
 		if (!sta_ptr) {
+			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 			dev_warn(priv->adapter->dev,
 				 "BA setup with unknown TDLS peer %pM!\n",
 				peer_mac);
-			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 			return -1;
 		}
 		if (sta_ptr->is_11ac_enabled)
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index d73fda3..8c60f18 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -353,9 +353,6 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 
 	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 	if (mwifiex_queuing_ra_based(priv)) {
-		dev_dbg(priv->adapter->dev,
-			"info: AP/ADHOC:last_seq=%d start_win=%d\n",
-			last_seq, new_node->start_win);
 		if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP) {
 			node = mwifiex_get_sta_entry(priv, ta);
 			if (node)
@@ -370,6 +367,9 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	}
 	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 
+	dev_dbg(priv->adapter->dev, "info: last_seq=%d start_win=%d\n",
+		last_seq, new_node->start_win);
+
 	if (last_seq != MWIFIEX_DEF_11N_RX_SEQ_NUM &&
 	    last_seq >= new_node->start_win) {
 		new_node->start_win = last_seq + 1;
@@ -468,10 +468,10 @@ int mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 		sta_ptr = mwifiex_get_sta_entry(priv,
 						cmd_addba_req->peer_mac_addr);
 		if (!sta_ptr) {
+			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 			dev_warn(priv->adapter->dev,
 				 "BA setup with unknown TDLS peer %pM!\n",
 				 cmd_addba_req->peer_mac_addr);
-			spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
 			return -1;
 		}
 		if (sta_ptr->is_11ac_enabled)
-- 
1.8.1.4

