Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbXLJRQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:16:15 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 46/48] libertas: fix error cases in lbs_process_rxed_802_11_packet()
Message-Id: <E1J1kpq-0006np-JU@shinybook.infradead.org> (sfid-20071210_171619_959791_06D28AA4)
Date: Mon, 10 Dec 2007 10:46:22 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 00:17:28 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/rx.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 90a2199..141069f 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -337,9 +337,10 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	// lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data, min(skb->len, 100));
 
 	if (skb->len < (ETH_HLEN + 8 + sizeof(struct rxpd))) {
-		lbs_deb_rx("rx err: frame received wit bad length\n");
+		lbs_deb_rx("rx err: frame received with bad length\n");
 		priv->stats.rx_length_errors++;
-		ret = 0;
+		ret = -EINVAL;
+		kfree(skb);
 		goto done;
 	}
 
@@ -381,10 +382,11 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 
 	/* add space for the new radio header */
 	if ((skb_headroom(skb) < sizeof(struct rx_radiotap_hdr)) &&
-	    pskb_expand_head(skb, sizeof(struct rx_radiotap_hdr), 0,
-			     GFP_ATOMIC)) {
-		lbs_pr_alert("%s: couldn't pskb_expand_head\n",
-			     __func__);
+	    pskb_expand_head(skb, sizeof(struct rx_radiotap_hdr), 0, GFP_ATOMIC)) {
+		lbs_pr_alert("%s: couldn't pskb_expand_head\n", __func__);
+		ret = -ENOMEM;
+		kfree_skb(skb);
+		goto done;
 	}
 
 	pradiotap_hdr = (void *)skb_push(skb, sizeof(struct rx_radiotap_hdr));
-- 
1.5.3.4

