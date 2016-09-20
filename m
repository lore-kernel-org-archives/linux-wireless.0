Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42918 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754001AbcITPTd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 11:19:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8KFArPo028808
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 08:19:32 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 25h5bpb4u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 08:19:31 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Shengzhen Li <szli@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/3] mwifiex: fix kernel crash for USB chipsets
Date: Tue, 20 Sep 2016 20:49:02 +0530
Message-ID: <1474384744-14096-1-git-send-email-akarwar@marvell.com> (sfid-20160920_171938_101610_BBB910BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Cathy Luo <cluo@marvell.com>

Following crash issue is observed during TCP traffic stress
test

[ 2253.625439] NMI watchdog: BUG: soft lockup - CPU#3 stuck for 22s!
[kworker/u17:1:5191]
[ 2253.625520] Call Trace:
[ 2253.625527]  [<ffffffffc0b47030>] ? moal_spin_lock+0x30/0x30
[usb8xxx]
[ 2253.625533]  [<ffffffffc0ac3ceb>] ? wlan_wmm_lists_empty+0xb/0xf0
[mlan]
[ 2253.625537]  [<ffffffffc0ab0ea3>] mlan_main_process+0x1b3/0x720
[mlan]
[ 2253.625540]  [<ffffffffc0b337f5>] woal_main_work_queue+0x45/0x80
[usb8xxx]
[ 2253.625543]  [<ffffffff8108aaf0>] process_one_work+0x150/0x3f0
[ 2253.625545]  [<ffffffff8108b1e1>] worker_thread+0x121/0x520
[ 2253.625547]  [<ffffffff8108b0c0>] ? rescuer_thread+0x330/0x330
[ 2253.625549]  [<ffffffff81090222>] kthread+0xd2/0xf0
[ 2253.625551]  [<ffffffff81090150>] ?
kthread_create_on_node+0x1c0/0x1c0
[ 2253.625553]  [<ffffffff8179423c>] ret_from_fork+0x7c/0xb0
[ 2253.625555]  [<ffffffff81090150>] ?
kthread_create_on_node+0x1c0/0x1c0

In mwifiex_usb_tx_complete(), we are updating port->block_status first
and then freeing the skb attached to that URB. We may end up attaching
new skb to URB in a corner case and same will be freed. This results in
the kernel crash. The problem is solved by changing the sequence.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 8a20620..e8283dc 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -273,6 +273,8 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 	} else {
 		mwifiex_dbg(adapter, DATA,
 			    "%s: DATA\n", __func__);
+		mwifiex_write_data_complete(adapter, context->skb, 0,
+					    urb->status ? -1 : 0);
 		for (i = 0; i < MWIFIEX_TX_DATA_PORT; i++) {
 			port = &card->port[i];
 			if (context->ep == port->tx_data_ep) {
@@ -282,8 +284,6 @@ static void mwifiex_usb_tx_complete(struct urb *urb)
 			}
 		}
 		adapter->data_sent = false;
-		mwifiex_write_data_complete(adapter, context->skb, 0,
-					    urb->status ? -1 : 0);
 	}
 
 	if (card->mc_resync_flag)
-- 
1.9.1
