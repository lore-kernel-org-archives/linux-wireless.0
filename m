Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:50477 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753307Ab2AYExy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 23:53:54 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: pass priv pointer instead of adapter
Date: Tue, 24 Jan 2012 20:50:24 -0800
Message-Id: <1327467025-5190-1-git-send-email-bzhao@marvell.com> (sfid-20120125_055357_271092_6A2A4B21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Pass mwifiex_private pointer directly to wmm_add_buf_txqueue()
instead of passing adapter and then deriving priv again in
mwifiex_get_priv_by_id(). This reduces a 'for' loop in TX path.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |    2 +-
 drivers/net/wireless/mwifiex/wmm.c  |    6 ++----
 drivers/net/wireless/mwifiex/wmm.h  |    4 ++--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 1a0775d..80e4456 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -462,7 +462,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_info->bss_type = priv->bss_type;
 	mwifiex_fill_buffer(skb);
 
-	mwifiex_wmm_add_buf_txqueue(priv->adapter, skb);
+	mwifiex_wmm_add_buf_txqueue(priv, skb);
 	atomic_inc(&priv->adapter->tx_pending);
 
 	if (atomic_read(&priv->adapter->tx_pending) >= MAX_TX_PENDING) {
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index e6a2cb1..75f79ef 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -599,12 +599,10 @@ mwifiex_is_ralist_valid(struct mwifiex_private *priv,
  * is queued at the list tail.
  */
 void
-mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
+mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 			    struct sk_buff *skb)
 {
-	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
-	struct mwifiex_private *priv = mwifiex_get_priv_by_id(adapter,
-			tx_info->bss_num, tx_info->bss_type);
+	struct mwifiex_adapter *adapter = priv->adapter;
 	u32 tid;
 	struct mwifiex_ra_list_tbl *ra_list;
 	u8 ra[ETH_ALEN], tid_down;
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index fcea1f6..ec83995 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -80,8 +80,8 @@ mwifiex_wmm_is_ra_list_empty(struct list_head *ra_list_hhead)
 	return true;
 }
 
-void mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
-				 struct sk_buff *skb);
+void mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
+					struct sk_buff *skb);
 void mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra);
 
 int mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter);
-- 
1.7.0.2

