Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9447 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbbIRNdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 09:33:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8IDPBmV030912
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:07 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1wy3qm7eqm-2
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2015 06:33:07 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 11/16] mwifiex: fix tx data_sent issue for usb interface
Date: Fri, 18 Sep 2015 06:32:13 -0700
Message-ID: <1442583138-2979-12-git-send-email-akarwar@marvell.com> (sfid-20150918_153314_197023_CBEC34DF)
In-Reply-To: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
References: <1442583138-2979-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch fix missing tx data_sent flag update for usb interface.
Except USB interface, data_sent flag has been updated in specific
file such as sdio.c and pcie.c. So only USB interface type need check
when TX data completed.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 4 ++--
 drivers/net/wireless/mwifiex/sta_tx.c   | 6 +++++-
 drivers/net/wireless/mwifiex/txrx.c     | 8 ++++----
 drivers/net/wireless/mwifiex/wmm.c      | 4 ++--
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 6cb0d33..ce22cc8 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -300,7 +300,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
-		if (adapter->iface_type != MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->data_sent = false;
 		mwifiex_dbg(adapter, ERROR, "%s: host_to_card failed: %#x\n",
 			    __func__, ret);
@@ -308,7 +308,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		mwifiex_write_data_complete(adapter, skb_aggr, 1, ret);
 		return 0;
 	case -EINPROGRESS:
-		if (adapter->iface_type != MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->data_sent = false;
 		break;
 	case 0:
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 355ac59..7a4d5f4 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -174,6 +174,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 	local_tx_pd->bss_type = priv->bss_type;
 
 	if (adapter->iface_type == MWIFIEX_USB) {
+		adapter->data_sent = true;
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
 						   skb, NULL);
 	} else {
@@ -191,7 +192,8 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		adapter->dbg.num_tx_host_to_card_failure++;
 		break;
 	case -1:
-		adapter->data_sent = false;
+		if (adapter->iface_type == MWIFIEX_USB)
+			adapter->data_sent = false;
 		dev_kfree_skb_any(skb);
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: host_to_card failed: ret=%d\n",
@@ -206,6 +208,8 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 		adapter->tx_lock_flag = true;
 		break;
 	case -EINPROGRESS:
+		if (adapter->iface_type == MWIFIEX_USB)
+			adapter->data_sent = false;
 		adapter->tx_lock_flag = true;
 		break;
 	default:
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 98f097d..6ef030a 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -142,7 +142,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
-		if (adapter->iface_type != MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->data_sent = false;
 		mwifiex_dbg(adapter, ERROR,
 			    "mwifiex_write_data_async failed: 0x%X\n",
@@ -151,7 +151,7 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
-		if (adapter->iface_type != MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->data_sent = false;
 		break;
 	case 0:
@@ -222,7 +222,7 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 		mwifiex_dbg(adapter, ERROR, "data: -EBUSY is returned\n");
 		break;
 	case -1:
-		if (adapter->iface_type != MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->data_sent = false;
 		mwifiex_dbg(adapter, ERROR,
 			    "mwifiex_write_data_async failed: 0x%X\n", ret);
@@ -230,7 +230,7 @@ static int mwifiex_host_to_card(struct mwifiex_adapter *adapter,
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
-		if (adapter->iface_type != MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->data_sent = false;
 		break;
 	case 0:
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 8e30fb3..8a3f59e 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1356,14 +1356,14 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 				       ra_list_flags);
 		break;
 	case -1:
-		if (adapter->iface_type != MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->data_sent = false;
 		mwifiex_dbg(adapter, ERROR, "host_to_card failed: %#x\n", ret);
 		adapter->dbg.num_tx_host_to_card_failure++;
 		mwifiex_write_data_complete(adapter, skb, 0, ret);
 		break;
 	case -EINPROGRESS:
-		if (adapter->iface_type != MWIFIEX_PCIE)
+		if (adapter->iface_type == MWIFIEX_USB)
 			adapter->data_sent = false;
 		break;
 	case 0:
-- 
1.8.1.4

