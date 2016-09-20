Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37697 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754789AbcITPTv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 11:19:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8KFAS3j021291
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 08:19:50 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 25h36kkjx2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 08:19:43 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/3] mwifiex: fix race condition causing tx timeout
Date: Tue, 20 Sep 2016 20:49:03 +0530
Message-ID: <1474384744-14096-2-git-send-email-akarwar@marvell.com> (sfid-20160920_171955_137940_204645DA)
In-Reply-To: <1474384744-14096-1-git-send-email-akarwar@marvell.com>
References: <1474384744-14096-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cathy Luo <cluo@marvell.com>

It's been observed that in a corner case mwifiex_usb_tx_complete()
gets called before we exit from mwifiex_usb_host_to_card() after
submitting the urb. 'data_sent' flag remains set in this case. It
blocks further Tx packets and triggers watchdog timeout.

The problem is fixed by setting data_sent and port_block flag at
correct place.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index e8283dc..8fd51e4 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -897,6 +897,13 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 	else
 		atomic_inc(&port->tx_data_urb_pending);
 
+	if (ep != card->tx_cmd_ep &&
+	    atomic_read(&port->tx_data_urb_pending) ==
+					MWIFIEX_TX_DATA_URB) {
+		port->block_status = true;
+		adapter->data_sent = mwifiex_usb_data_sent(adapter);
+	}
+
 	if (usb_submit_urb(tx_urb, GFP_ATOMIC)) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: usb_submit_urb failed\n", __func__);
@@ -905,6 +912,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 		} else {
 			atomic_dec(&port->tx_data_urb_pending);
 			port->block_status = false;
+			adapter->data_sent = false;
 			if (port->tx_data_ix)
 				port->tx_data_ix--;
 			else
@@ -916,9 +924,7 @@ static int mwifiex_usb_host_to_card(struct mwifiex_adapter *adapter, u8 ep,
 		if (ep != card->tx_cmd_ep &&
 		    atomic_read(&port->tx_data_urb_pending) ==
 							MWIFIEX_TX_DATA_URB) {
-			port->block_status = true;
-			ret = -ENOSR;
-			goto done;
+			return -ENOSR;
 		}
 	}
 
-- 
1.9.1
