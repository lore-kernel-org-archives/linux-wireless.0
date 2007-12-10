Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbXLJRWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:22:42 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 34/48] libertas: kill SendSinglePacket() function.
Message-Id: <E1J1kpd-0006mr-U8@shinybook.infradead.org> (sfid-20071210_172244_750039_7B2C5E90)
Date: Mon, 10 Dec 2007 10:46:09 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 12:48:10 -0500

Make a start on reducing the number of pointless nested functions,
starting with the StudlyCaps. No semantic changes (yet) -- we can sort
out the now-obvious discrepancy in the failure paths in a separate
commit.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/tx.c |   66 +++++++++++++-----------------------
 1 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index 749535e..10596f3 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -49,16 +49,16 @@ static u32 convert_radiotap_rate_to_mv(u8 rate)
 }
 
 /**
- *  @brief This function processes a single packet and sends
- *  to IF layer
+ *  @brief This function checks the conditions and sends packet to IF
+ *  layer if everything is ok.
  *
  *  @param priv    A pointer to struct lbs_private structure
  *  @param skb     A pointer to skb which includes TX packet
  *  @return 	   0 or -1
  */
-static int SendSinglePacket(struct lbs_private *priv, struct sk_buff *skb)
+int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
 {
-	int ret = 0;
+	int ret = -1;
 	struct txpd localtxpd;
 	struct txpd *plocaltxpd = &localtxpd;
 	u8 *p802x_hdr;
@@ -68,16 +68,31 @@ static int SendSinglePacket(struct lbs_private *priv, struct sk_buff *skb)
 
 	lbs_deb_enter(LBS_DEB_TX);
 
+	lbs_deb_hex(LBS_DEB_TX, "TX Data", skb->data, min_t(unsigned int, skb->len, 100));
+
+	if (priv->dnld_sent) {
+		lbs_pr_alert( "TX error: dnld_sent = %d, not sending\n",
+		       priv->dnld_sent);
+		goto done;
+	}
+
+	if ((priv->psstate == PS_STATE_SLEEP) ||
+	    (priv->psstate == PS_STATE_PRE_SLEEP)) {
+		lbs_pr_alert("TX error: packet xmit in %ssleep mode\n",
+			     priv->psstate == PS_STATE_SLEEP?"":"pre-");
+		goto done;
+	}
+
 	if (priv->surpriseremoved)
 		return -1;
 
 	if (!skb->len || (skb->len > MRVDRV_ETH_TX_PACKET_BUFFER_SIZE)) {
 		lbs_deb_tx("tx err: skb length %d 0 or > %zd\n",
 		       skb->len, MRVDRV_ETH_TX_PACKET_BUFFER_SIZE);
-		ret = -1;
-		goto done;
+		goto done_tx;
 	}
 
+	ret = 0;
 	memset(plocaltxpd, 0, sizeof(struct txpd));
 
 	plocaltxpd->tx_packet_length = cpu_to_le16(skb->len);
@@ -130,12 +145,12 @@ static int SendSinglePacket(struct lbs_private *priv, struct sk_buff *skb)
 
 	if (ret) {
 		lbs_deb_tx("tx err: hw_host_to_card returned 0x%X\n", ret);
-		goto done;
+		goto done_tx;
 	}
 
-	lbs_deb_tx("SendSinglePacket succeeds\n");
+	lbs_deb_tx("%s succeeds\n", __func__);
 
-done:
+done_tx:
 	if (!ret) {
 		priv->stats.tx_packets++;
 		priv->stats.tx_bytes += skb->len;
@@ -159,39 +174,6 @@ done:
 		dev_kfree_skb_any(skb);
 	}
 
-	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
-	return ret;
-}
-
-
-/**
- *  @brief This function checks the conditions and sends packet to IF
- *  layer if everything is ok.
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @return 	   n/a
- */
-int lbs_process_tx(struct lbs_private *priv, struct sk_buff *skb)
-{
-	int ret = -1;
-
-	lbs_deb_enter(LBS_DEB_TX);
-	lbs_deb_hex(LBS_DEB_TX, "TX Data", skb->data, min_t(unsigned int, skb->len, 100));
-
-	if (priv->dnld_sent) {
-		lbs_pr_alert( "TX error: dnld_sent = %d, not sending\n",
-		       priv->dnld_sent);
-		goto done;
-	}
-
-	if ((priv->psstate == PS_STATE_SLEEP) ||
-	    (priv->psstate == PS_STATE_PRE_SLEEP)) {
-		lbs_pr_alert("TX error: packet xmit in %ssleep mode\n",
-			     priv->psstate == PS_STATE_SLEEP?"":"pre-");
-		goto done;
-	}
-
-	ret = SendSinglePacket(priv, skb);
 done:
 	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
 	return ret;
-- 
1.5.3.4

