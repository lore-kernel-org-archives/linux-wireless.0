Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49727 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbbBMJio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 04:38:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t1D9YSY4030549
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2015 01:38:43 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1shdtj078k-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2015 01:38:43 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: fix usb tx data payload offset issue
Date: Fri, 13 Feb 2015 20:38:16 +0530
Message-ID: <1423840096-14165-1-git-send-email-patila@marvell.com> (sfid-20150213_104018_930835_83F2A3F6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

Commit 84b313b35f8158d7 ("mwifiex: make tx packet 64 byte DMA aligned")
induced payload offset issue for USB interface.

There is no USB interface header for tx packets, so there's no need to
pull interface length while processing tx skb.

This patch fixes this issue.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/txrx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index ac93557..ea4549f 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -80,11 +80,13 @@ EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
 int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 		       struct mwifiex_tx_param *tx_param)
 {
-	int ret = -1;
+	int hroom, ret = -1;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u8 *head_ptr;
 	struct txpd *local_tx_pd = NULL;
 
+	hroom = (adapter->iface_type == MWIFIEX_USB) ? 0 : INTF_HEADER_LEN;
+
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
 		head_ptr = mwifiex_process_uap_txpd(priv, skb);
 	else
@@ -92,11 +94,9 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 
 	if (head_ptr) {
 		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA)
-			local_tx_pd =
-				(struct txpd *) (head_ptr + INTF_HEADER_LEN);
+			local_tx_pd = (struct txpd *)(head_ptr + hroom);
 		if (adapter->iface_type == MWIFIEX_USB) {
 			adapter->data_sent = true;
-			skb_pull(skb, INTF_HEADER_LEN);
 			ret = adapter->if_ops.host_to_card(adapter,
 							   MWIFIEX_USB_EP_DATA,
 							   skb, NULL);
-- 
1.8.1.4

