Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7545 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbXGCPWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:22:41 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:22:35 +0200
Subject: [PATCH] libertas: remove adapter->pkttxctrl
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031722.35148.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable was initialized to 0 and nowhere else changed, so basically
the per-packet TX control wasn't used.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    2 --
 drivers/net/wireless/libertas/main.c |    1 -
 drivers/net/wireless/libertas/tx.c   |    4 ----
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 2ec2b9a..3eae896 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -376,8 +376,6 @@ struct _wlan_adapter {
 
 	struct cmd_ds_802_11_get_log logmsg;
 
-	u32 pkttxctrl;
-
 	u16 txrate;
 	u8 fw_ready;
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index f0c2df9..070e5da 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1061,7 +1061,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	adapter->intcounter = 0;
 
 	adapter->currenttxskb = NULL;
-	adapter->pkttxctrl = 0;
 
 	memset(&adapter->tx_queue_ps, 0, NR_TX_QUEUE*sizeof(struct sk_buff*));
 	adapter->tx_queue_idx = 0;
diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
index f5f54ed..85f7bfb 100644
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -20,7 +20,6 @@
  */
 static int SendSinglePacket(wlan_private * priv, struct sk_buff *skb)
 {
-	wlan_adapter *adapter = priv->adapter;
 	int ret = 0;
 	struct txpd localtxpd;
 	struct txpd *plocaltxpd = &localtxpd;
@@ -46,9 +45,6 @@ static int SendSinglePacket(wlan_private * priv, struct sk_buff *skb)
 	/* offset of actual data */
 	plocaltxpd->tx_packet_location = cpu_to_le32(sizeof(struct txpd));
 
-	/* TxCtrl set by user or default */
-	plocaltxpd->tx_control = cpu_to_le32(adapter->pkttxctrl);
-
 	p802x_hdr = skb->data;
 
 	/* copy destination address from 802.3 header */
-- 
1.5.2.1

