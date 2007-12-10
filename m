Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbXLJRVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:21:53 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 35/48] libertas: move lbs_hard_start_xmit() into tx.c
Message-Id: <E1J1kpe-0006mw-VV@shinybook.infradead.org> (sfid-20071210_172156_529680_3EA8C313)
Date: Mon, 10 Dec 2007 10:46:10 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 12:52:19 -0500

... where it can shortly be merged with lbs_process_tx()...

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/decl.h |    2 +-
 drivers/net/wireless/libertas/main.c |   32 --------------------------------
 drivers/net/wireless/libertas/tx.c   |   33 ++++++++++++++++++++++++++++++++-
 3 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index b094514..fcb5a85 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -50,10 +50,10 @@ void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb);
 
 /** The proc fs interface */
 int lbs_process_rx_command(struct lbs_private *priv);
-int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb);
 void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
 	struct cmd_ctrl_node *ptempcmd);
 
+int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int lbs_set_regiontable(struct lbs_private *priv, u8 region, u8 band);
 
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index c638995..d311d57 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -515,38 +515,6 @@ static int lbs_close(struct net_device *dev)
 		return 0;
 }
 
-
-static int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	int ret = 0;
-	struct lbs_private *priv = dev->priv;
-
-	lbs_deb_enter(LBS_DEB_TX);
-
-	/* We could return NETDEV_TX_BUSY here, but I'd actually 
-	   like to get the point where we can BUG() */
-	if (priv->dnld_sent) {
-		lbs_pr_err("%s while dnld_sent\n", __func__);
-		priv->stats.tx_dropped++;
-		goto done;
-	}
-	if (priv->currenttxskb) {
-		lbs_pr_err("%s while TX skb pending\n", __func__);
-		priv->stats.tx_dropped++;
-		goto done;
-	}
-
-	netif_stop_queue(priv->dev);
-	if (priv->mesh_dev)
-		netif_stop_queue(priv->mesh_dev);
-
-	if (lbs_process_tx(priv, skb) == 0)
-		dev->trans_start = jiffies;
-done:
-	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
-	return ret;
-}
-
 /**
  * @brief Mark mesh packets and handover them to lbs_hard_start_xmit
  *
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 10596f3..336544c 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -56,7 +56,7 @@ static u32 convert_radiotap_rate_to_mv(u8 rate)
  *  @param skb     A pointer to skb which includes TX packet
  *  @return 	   0 or -1
  */
-int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
+static int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
 {
 	int ret = -1;
 	struct txpd localtxpd;
@@ -179,6 +179,37 @@ done:
 	return ret;
 }
 
+int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	int ret = 0;
+	struct lbs_private *priv = dev->priv;
+
+	lbs_deb_enter(LBS_DEB_TX);
+
+	/* We could return NETDEV_TX_BUSY here, but I'd actually 
+	   like to get the point where we can BUG() */
+	if (priv->dnld_sent) {
+		lbs_pr_err("%s while dnld_sent\n", __func__);
+		priv->stats.tx_dropped++;
+		goto done;
+	}
+	if (priv->currenttxskb) {
+		lbs_pr_err("%s while TX skb pending\n", __func__);
+		priv->stats.tx_dropped++;
+		goto done;
+	}
+
+	netif_stop_queue(priv->dev);
+	if (priv->mesh_dev)
+		netif_stop_queue(priv->mesh_dev);
+
+	if (lbs_process_tx(priv, skb) == 0)
+		dev->trans_start = jiffies;
+done:
+	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
+	return ret;
+}
+
 /**
  *  @brief This function sends to the host the last transmitted packet,
  *  filling the radiotap headers with transmission information.
-- 
1.5.3.4

