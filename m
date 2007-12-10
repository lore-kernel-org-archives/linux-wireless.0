Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55299 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbXLJPqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:46:19 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 36/48] libertas: kill lbs_process_tx() by merging it into lbs_hard_start_xmit()
Message-Id: <E1J1kpg-0006n1-0g@shinybook.infradead.org> (sfid-20071210_154642_119735_EC002395)
Date: Mon, 10 Dec 2007 10:46:12 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 12:57:14 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/tx.c |   45 ++++++++++-------------------------
 1 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 336544c..7bc2124 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -56,8 +56,9 @@ static u32 convert_radiotap_rate_to_mv(u8 rate)
  *  @param skb     A pointer to skb which includes TX packet
  *  @return 	   0 or -1
  */
-static int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
+int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	struct lbs_private *priv = dev->priv;
 	int ret = -1;
 	struct txpd localtxpd;
 	struct txpd *plocaltxpd = &localtxpd;
@@ -70,12 +71,21 @@ static int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
 
 	lbs_deb_hex(LBS_DEB_TX, "TX Data", skb->data, min_t(unsigned int, skb->len, 100));
 
+	netif_stop_queue(priv->dev);
+	if (priv->mesh_dev)
+		netif_stop_queue(priv->mesh_dev);
+
 	if (priv->dnld_sent) {
 		lbs_pr_alert( "TX error: dnld_sent = %d, not sending\n",
 		       priv->dnld_sent);
 		goto done;
 	}
 
+	if (priv->currenttxskb) {
+		lbs_pr_err("%s while TX skb pending\n", __func__);
+		goto done;
+	}
+
 	if ((priv->psstate == PS_STATE_SLEEP) ||
 	    (priv->psstate == PS_STATE_PRE_SLEEP)) {
 		lbs_pr_alert("TX error: packet xmit in %ssleep mode\n",
@@ -154,6 +164,8 @@ done_tx:
 	if (!ret) {
 		priv->stats.tx_packets++;
 		priv->stats.tx_bytes += skb->len;
+
+ 		dev->trans_start = jiffies;
 	} else {
 		priv->stats.tx_dropped++;
 		priv->stats.tx_errors++;
@@ -179,37 +191,6 @@ done:
 	return ret;
 }
 
-int lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
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
  *  @brief This function sends to the host the last transmitted packet,
  *  filling the radiotap headers with transmission information.
-- 
1.5.3.4

