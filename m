Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43192 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750756AbdH3Tz6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:55:58 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7UJsQc3006991
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:55:58 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2cnt3m3r9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:55:57 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 1/2] mwifiex: resubmit failed to submit RX URBs in main thread
Date: Thu, 31 Aug 2017 01:21:13 +0530
Message-ID: <1504122674-3379-2-git-send-email-gbhat@marvell.com> (sfid-20170830_215601_633960_E110BD0F)
In-Reply-To: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
References: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: James Cao <jcao@marvell.com>

Current driver has 6 Rx data URBs. Once any packet received
kernel calls our callback, in which the same URB will be
resubmitted after Rx indication. In URB submission function a new
skb will be allocated since the previous one is passed to upper
layer (freed later). Since the skb is from a special pool (not
regular memory), skb allocation may fail when kernel holds a lot
of Rx packets on some low resource platforms. The URB will not be
resubmitted in this no free skb case. If driver fails to resubmit
all 6 URBs, Rx will stop. To cover this scenario check and
resubmit Rx URBs in main thread.

Signed-off-by: James Cao <jcao@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index ee40b73..c78014b 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -247,6 +247,7 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 {
 	int ret = 0;
 	unsigned long flags;
+	struct usb_card_rec *usb_card;
 
 	spin_lock_irqsave(&adapter->main_proc_lock, flags);
 
@@ -278,6 +279,16 @@ int mwifiex_main_process(struct mwifiex_adapter *adapter)
 			break;
 		}
 
+		/* Try to resubmit RX URB if sunmission failed earlier */
+		if (!atomic_read(&adapter->rx_pending) &&
+		    adapter->iface_type == MWIFIEX_USB) {
+			usb_card = adapter->card;
+			if (atomic_read(&usb_card->rx_data_urb_pending) <
+			    MWIFIEX_RX_DATA_URB &&
+			    adapter->if_ops.submit_rem_rx_urbs)
+				adapter->if_ops.submit_rem_rx_urbs(adapter);
+		}
+
 		/* Handle pending interrupt if any */
 		if (adapter->int_status) {
 			if (adapter->hs_activated)
-- 
1.9.1
