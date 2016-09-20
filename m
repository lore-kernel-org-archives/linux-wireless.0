Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37695 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754535AbcITPTu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 11:19:50 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8KFAXZv021303
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 08:19:49 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 25h36kkjx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 08:19:44 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] mwifiex: code rearrangement in mwifiex_usb_host_to_card()
Date: Tue, 20 Sep 2016 20:49:04 +0530
Message-ID: <1474384744-14096-3-git-send-email-akarwar@marvell.com> (sfid-20160920_171953_333321_6858509B)
In-Reply-To: <1474384744-14096-1-git-send-email-akarwar@marvell.com>
References: <1474384744-14096-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch helps get rid of goto statement and improves readability.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 8fd51e4..73eb084 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -841,7 +841,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	struct usb_tx_data_port *port = NULL;
 	u8 *data = (u8 *)skb->data;
 	struct urb *tx_urb;
-	int idx, ret;
+	int idx, ret = -EINPROGRESS;
 
 	if (adapter->is_suspended) {
 		mwifiex_dbg(adapter, ERROR,
@@ -865,8 +865,9 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 				if (atomic_read(&port->tx_data_urb_pending)
 				    >= MWIFIEX_TX_DATA_URB) {
 					port->block_status = true;
-					ret = -EBUSY;
-					goto done;
+					adapter->data_sent =
+						mwifiex_usb_data_sent(adapter);
+					return -EBUSY;
 				}
 				if (port->tx_data_ix >= MWIFIEX_TX_DATA_URB)
 					port->tx_data_ix = 0;
@@ -902,6 +903,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 					MWIFIEX_TX_DATA_URB) {
 		port->block_status = true;
 		adapter->data_sent = mwifiex_usb_data_sent(adapter);
+		ret = -ENOSR;
 	}
 
 	if (usb_submit_urb(tx_urb, GFP_ATOMIC)) {
@@ -918,22 +920,9 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 			else
 				port->tx_data_ix = MWIFIEX_TX_DATA_URB;
 		}
-
-		return -1;
-	} else {
-		if (ep != card->tx_cmd_ep &&
-		    atomic_read(&port->tx_data_urb_pending) ==
-							MWIFIEX_TX_DATA_URB) {
-			return -ENOSR;
-		}
+		ret = -1;
 	}
 
-	return -EINPROGRESS;
-
-done:
-	if (ep != card->tx_cmd_ep)
-		adapter->data_sent = mwifiex_usb_data_sent(adapter);
-
 	return ret;
 }
 
-- 
1.9.1
