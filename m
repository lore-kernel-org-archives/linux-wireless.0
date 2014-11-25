Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48314 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbaKYOol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:44:41 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/5] mwifiex: skip delay main work logic for USB interface.
Date: Tue, 25 Nov 2014 06:43:04 -0800
Message-ID: <1416926586-19286-4-git-send-email-akarwar@marvell.com> (sfid-20141125_154453_908739_872B2757)
In-Reply-To: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
References: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We had introduced delay main work logic to avoid processing
interrupts when Rx pending packet count reaches high threshold.
interrupt processing is restarted later when packet count
reduces lower threashold. This helped to reduce unnecessary
overhead and improve throughput for SD and PCIe chipsets.

As there are no interrupts for USB, we will skip this logic for
USB chipsets.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 0e50120..cf07279 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -149,7 +149,8 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 	/* Check for Rx data */
 	while ((skb = skb_dequeue(&adapter->rx_data_q))) {
 		atomic_dec(&adapter->rx_pending);
-		if (adapter->delay_main_work &&
+		if ((adapter->delay_main_work ||
+		     adapter->iface_type == MWIFIEX_USB) &&
 		    (atomic_read(&adapter->rx_pending) < LOW_RX_PENDING)) {
 			if (adapter->if_ops.submit_rem_rx_urbs)
 				adapter->if_ops.submit_rem_rx_urbs(adapter);
@@ -202,12 +203,15 @@ process_start:
 		    (adapter->hw_status == MWIFIEX_HW_STATUS_NOT_READY))
 			break;
 
-		/* If we process interrupts first, it would increase RX pending
-		 * even further. Avoid this by checking if rx_pending has
-		 * crossed high threshold and schedule rx work queue
-		 * and then process interrupts
+		/* For non-USB interfaces, If we process interrupts first, it
+		 * would increase RX pending even further. Avoid this by
+		 * checking if rx_pending has crossed high threshold and
+		 * schedule rx work queue and then process interrupts.
+		 * For USB interface, there are no interrupts. We already have
+		 * HIGH_RX_PENDING check in usb.c
 		 */
-		if (atomic_read(&adapter->rx_pending) >= HIGH_RX_PENDING) {
+		if (atomic_read(&adapter->rx_pending) >= HIGH_RX_PENDING &&
+		    adapter->iface_type != MWIFIEX_USB) {
 			adapter->delay_main_work = true;
 			if (!adapter->rx_processing)
 				queue_work(adapter->rx_workqueue,
-- 
1.8.1.4

