Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36524 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdEEMIl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 08:08:41 -0400
Received: by mail-pf0-f196.google.com with SMTP id v14so543278pfd.3
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 05:08:41 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH v2 5/6] mwifiex: do not aggregate tcp ack in usb tx aggregation queue
Date: Fri,  5 May 2017 12:08:19 +0000
Message-Id: <1493986100-24509-5-git-send-email-huxinming820@gmail.com> (sfid-20170505_140845_449296_9B40AA3C)
In-Reply-To: <1493986100-24509-1-git-send-email-huxinming820@gmail.com>
References: <1493986100-24509-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Tcp ack should be send as soon to avoid throuput drop during receive tcp
traffic.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
v2: same as v1
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c |  4 ++++
 drivers/net/wireless/marvell/mwifiex/decl.h     |  1 +
 drivers/net/wireless/marvell/mwifiex/main.c     | 26 +++++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/main.h     |  1 +
 drivers/net/wireless/marvell/mwifiex/usb.c      |  6 ++++--
 5 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index e8ffb26..cbf3bc2 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -194,6 +194,10 @@
 
 	if (tx_info_src->flags & MWIFIEX_BUF_FLAG_TDLS_PKT)
 		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
+
+	if (tx_info_src->flags & MWIFIEX_BUF_FLAG_TCP_ACK)
+		tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_TCP_ACK;
+
 	tx_info_aggr->flags |= MWIFIEX_BUF_FLAG_AGGR_PKT;
 	skb_aggr->priority = skb_src->priority;
 	skb_aggr->tstamp = skb_src->tstamp;
diff --git a/drivers/net/wireless/marvell/mwifiex/decl.h b/drivers/net/wireless/marvell/mwifiex/decl.h
index 188e4c3..0487420 100644
--- a/drivers/net/wireless/marvell/mwifiex/decl.h
+++ b/drivers/net/wireless/marvell/mwifiex/decl.h
@@ -89,6 +89,7 @@
 #define MWIFIEX_BUF_FLAG_EAPOL_TX_STATUS   BIT(3)
 #define MWIFIEX_BUF_FLAG_ACTION_TX_STATUS  BIT(4)
 #define MWIFIEX_BUF_FLAG_AGGR_PKT          BIT(5)
+#define MWIFIEX_BUF_FLAG_TCP_ACK           BIT(6)
 
 #define MWIFIEX_BRIDGED_PKTS_THR_HIGH      1024
 #define MWIFIEX_BRIDGED_PKTS_THR_LOW        128
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index dc79d1a..5c7fbc6 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -851,6 +851,30 @@ struct sk_buff *
 	return skb;
 }
 
+static bool is_piggyback_tcp_ack(struct sk_buff *skb)
+{
+	struct ethhdr *ethh = NULL;
+	struct iphdr  *iph = NULL;
+	struct tcphdr *tcph = NULL;
+
+	ethh = (struct ethhdr *)skb->data;
+	if (ntohs(ethh->h_proto) != ETH_P_IP)
+		return false;
+
+	iph = (struct iphdr *)((u8 *)ethh + sizeof(struct ethhdr));
+	if (iph->protocol != IPPROTO_TCP)
+		return false;
+
+	tcph = (struct tcphdr *)((u8 *)iph + iph->ihl * 4);
+	/* Piggyback ack without payload*/
+	if (*((u8 *)tcph + 13) == 0x10 &&
+	    ntohs(iph->tot_len) <= (iph->ihl + tcph->doff) * 4) {
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * CFG802.11 network device handler for data transmission.
  */
@@ -904,6 +928,8 @@ struct sk_buff *
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 	tx_info->pkt_len = skb->len;
+	if (is_piggyback_tcp_ack(skb))
+		tx_info->flags |= MWIFIEX_BUF_FLAG_TCP_ACK;
 
 	multicast = is_multicast_ether_addr(skb->data);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index a85b89e..a947825 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -49,6 +49,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/of_irq.h>
+#include <linux/tcp.h>
 
 #include "decl.h"
 #include "ioctl.h"
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index f230017..e9c3d43 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -934,6 +934,7 @@ static int mwifiex_usb_aggr_tx_data(struct mwifiex_adapter *adapter, u8 ep,
 	struct urb_context *context = NULL;
 	struct txpd *local_tx_pd =
 		(struct txpd *)((u8 *)skb->data + adapter->intf_hdr_len);
+	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
 	u8 f_send_aggr_buf = 0;
 	u8 f_send_cur_buf = 0;
 	u8 f_precopy_cur_buf = 0;
@@ -989,8 +990,9 @@ static int mwifiex_usb_aggr_tx_data(struct mwifiex_adapter *adapter, u8 ep,
 		}
 	}
 
-	if (local_tx_pd->flags & MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET) {
-		/* Send NULL packet immediately*/
+	if (local_tx_pd->flags & MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET ||
+	    tx_info->flags & MWIFIEX_BUF_FLAG_TCP_ACK) {
+		/* Send NULL data/TCP ACK packet immediately*/
 		if (f_precopy_cur_buf) {
 			if (skb_queue_empty(&port->tx_aggr.aggr_list)) {
 				f_precopy_cur_buf = 0;
-- 
1.9.1
