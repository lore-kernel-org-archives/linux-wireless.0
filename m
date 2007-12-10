Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55298 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXLJPqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:46:19 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 47/48] libertas: kill lbs_upload_tx_packet()
Message-Id: <E1J1kpr-0006nu-Ks@shinybook.infradead.org> (sfid-20071210_154641_039839_CFCBDBF5)
Date: Mon, 10 Dec 2007 10:46:23 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 00:49:26 -0500

It replaces two lines of code. And even for those it has to make
inferences about things (i.e. which device) which the caller would have
just known.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/decl.h |    2 --
 drivers/net/wireless/libertas/rx.c   |   32 +++++++++-----------------------
 drivers/net/wireless/libertas/tx.c   |    8 +++++++-
 3 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireless/libertas/decl.h
index fcb5a85..e8387c7 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -46,8 +46,6 @@ void lbs_get_fwversion(struct lbs_private *priv,
 	char *fwversion,
 	int maxlen);
 
-void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb);
-
 /** The proc fs interface */
 int lbs_process_rx_command(struct lbs_private *priv);
 void __lbs_cleanup_and_insert_cmd(struct lbs_private *priv,
diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 141069f..6332fd4 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -131,22 +131,6 @@ static void lbs_compute_rssi(struct lbs_private *priv, struct rxpd *p_rx_pd)
 	lbs_deb_leave(LBS_DEB_RX);
 }
 
-void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb)
-{
-	lbs_deb_rx("skb->data %p\n", skb->data);
-
-	if (priv->monitormode != LBS_MONITOR_OFF) {
-		skb->protocol = eth_type_trans(skb, priv->rtap_net_dev);
-	} else {
-		if (priv->mesh_dev && IS_MESH_FRAME(skb))
-			skb->protocol = eth_type_trans(skb, priv->mesh_dev);
-		else
-			skb->protocol = eth_type_trans(skb, priv->dev);
-	}
-	skb->ip_summed = CHECKSUM_NONE;
-	netif_rx(skb);
-}
-
 /**
  *  @brief This function processes received packet and forwards it
  *  to kernel/upper layer
@@ -158,7 +142,7 @@ void lbs_upload_rx_packet(struct lbs_private *priv, struct sk_buff *skb)
 int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 {
 	int ret = 0;
-
+	struct net_device *dev = priv->dev;
 	struct rxpackethdr *p_rx_pkt;
 	struct rxpd *p_rx_pd;
 
@@ -169,15 +153,15 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 
 	lbs_deb_enter(LBS_DEB_RX);
 
+	skb->ip_summed = CHECKSUM_NONE;
+
 	if (priv->monitormode != LBS_MONITOR_OFF)
 		return process_rxed_802_11_packet(priv, skb);
 
 	p_rx_pkt = (struct rxpackethdr *) skb->data;
 	p_rx_pd = &p_rx_pkt->rx_pd;
-	if (p_rx_pd->rx_control & RxPD_MESH_FRAME)
-		SET_MESH_FRAME(skb);
-	else
-		UNSET_MESH_FRAME(skb);
+	if (priv->mesh_dev && (p_rx_pd->rx_control & RxPD_MESH_FRAME))
+		dev = priv->mesh_dev;
 
 	lbs_deb_hex(LBS_DEB_RX, "RX Data: Before chop rxpd", skb->data,
 		 min_t(unsigned int, skb->len, 100));
@@ -262,7 +246,8 @@ int lbs_process_rxed_packet(struct lbs_private *priv, struct sk_buff *skb)
 	priv->stats.rx_bytes += skb->len;
 	priv->stats.rx_packets++;
 
-	lbs_upload_rx_packet(priv, skb);
+	skb->protocol = eth_type_trans(skb, dev);
+	netif_rx(skb);
 
 	ret = 0;
 done:
@@ -404,7 +389,8 @@ static int process_rxed_802_11_packet(struct lbs_private *priv,
 	priv->stats.rx_bytes += skb->len;
 	priv->stats.rx_packets++;
 
-	lbs_upload_rx_packet(priv, skb);
+	skb->protocol = eth_type_trans(skb, priv->rtap_net_dev);
+	netif_rx(skb);
 
 	ret = 0;
 
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index e2141f0..8a1a396 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -2,6 +2,7 @@
   * This file contains the handling of TX in wlan driver.
   */
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 
 #include "hostcmd.h"
 #include "radiotap.h"
@@ -203,7 +204,12 @@ void lbs_send_tx_feedback(struct lbs_private *priv)
 	try_count = (status >> 16) & 0xff;
 	radiotap_hdr->data_retries = (try_count) ?
 	    (1 + priv->txretrycount - try_count) : 0;
-	lbs_upload_rx_packet(priv, priv->currenttxskb);
+
+
+	priv->currenttxskb->protocol = eth_type_trans(priv->currenttxskb,
+						      priv->rtap_net_dev);
+	netif_rx(priv->currenttxskb);
+
 	priv->currenttxskb = NULL;
 
 	if (priv->connect_status == LBS_CONNECTED)
-- 
1.5.3.4

