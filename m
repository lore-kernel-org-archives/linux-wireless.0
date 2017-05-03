Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32939 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751937AbdECLtI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 07:49:08 -0400
Received: by mail-pg0-f68.google.com with SMTP id s62so16366026pgc.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 04:49:07 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 6/6] mwifiex: check next packet length for usb tx aggregation
Date: Wed,  3 May 2017 11:48:43 +0000
Message-Id: <1493812123-12053-6-git-send-email-huxinming820@gmail.com> (sfid-20170503_134913_515175_AFB70DC5)
In-Reply-To: <1493812123-12053-1-git-send-email-huxinming820@gmail.com>
References: <1493812123-12053-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

The next packet length will be used by interface driver, to check if the
next packet still could be aggregated.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c | 8 ++++----
 drivers/net/wireless/marvell/mwifiex/txrx.c     | 4 ++--
 drivers/net/wireless/marvell/mwifiex/wmm.c      | 8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index cbf3bc2..8041f2d 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -254,15 +254,15 @@
 		return 0;
 	}
 
-	if (adapter->iface_type == MWIFIEX_USB) {
-		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
-						   skb_aggr, NULL);
-	} else {
 		if (skb_src)
 			tx_param.next_pkt_len =
 					skb_src->len + sizeof(struct txpd);
 		else
 			tx_param.next_pkt_len = 0;
+	if (adapter->iface_type == MWIFIEX_USB) {
+		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
+						   skb_aggr, &tx_param);
+	} else {
 
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
 						   skb_aggr, &tx_param);
diff --git a/drivers/net/wireless/marvell/mwifiex/txrx.c b/drivers/net/wireless/marvell/mwifiex/txrx.c
index 15e92af..d848933 100644
--- a/drivers/net/wireless/marvell/mwifiex/txrx.c
+++ b/drivers/net/wireless/marvell/mwifiex/txrx.c
@@ -117,7 +117,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		if (adapter->iface_type == MWIFIEX_USB) {
 			ret = adapter->if_ops.host_to_card(adapter,
 							   priv->usb_port,
-							   skb, NULL);
+							   skb, tx_param);
 		} else {
 			ret = adapter->if_ops.host_to_card(adapter,
 							   MWIFIEX_TYPE_DATA,
@@ -185,7 +185,7 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 	if (adapter->iface_type == MWIFIEX_USB) {
 		ret = adapter->if_ops.host_to_card(adapter,
 						   priv->usb_port,
-						   skb, NULL);
+						   skb, tx_param);
 	} else {
 		ret = adapter->if_ops.host_to_card(adapter,
 						   MWIFIEX_TYPE_DATA,
diff --git a/drivers/net/wireless/marvell/mwifiex/wmm.c b/drivers/net/wireless/marvell/mwifiex/wmm.c
index e4ff3b9..75cdd55 100644
--- a/drivers/net/wireless/marvell/mwifiex/wmm.c
+++ b/drivers/net/wireless/marvell/mwifiex/wmm.c
@@ -1363,13 +1363,13 @@ void mwifiex_rotate_priolists(struct mwifiex_private *priv,
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
+	tx_param.next_pkt_len =
+		((skb_next) ? skb_next->len +
+		 sizeof(struct txpd) : 0);
 	if (adapter->iface_type == MWIFIEX_USB) {
 		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
-						   skb, NULL);
+						   skb, &tx_param);
 	} else {
-		tx_param.next_pkt_len =
-			((skb_next) ? skb_next->len +
-			 sizeof(struct txpd) : 0);
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
 						   skb, &tx_param);
 	}
-- 
1.9.1
