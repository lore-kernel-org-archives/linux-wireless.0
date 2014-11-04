Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39590 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbaKDL6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 06:58:05 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Subject: [PATCH 3/5] mwifiex: fix out of memory issue observed for USB chipsets
Date: Tue, 4 Nov 2014 03:57:01 -0800
Message-ID: <1415102223-7118-3-git-send-email-akarwar@marvell.com> (sfid-20141104_125809_353680_6C216FC1)
In-Reply-To: <1415102223-7118-1-git-send-email-akarwar@marvell.com>
References: <1415102223-7118-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some platforms, system goes out of memory during heavy
Rx traffic with our USB chipsets.

In case of SDIO/PCIe, after receiving 50 packets in Rx queue
we stop processing interrupts till packets pending fall below
low threshold i.e 20. We don't have similar logic for USB,
so if host platform is slow, we would hit a case where firmware
keeps on pushing packets at high speed than driver/kernel can
process.

We will stop submitting URBs for Rx data when pending packet
count reaches high threshold and restart them when enough
packets are consumed to solve the problem.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=85071
Reported-by: Marek Belisko <marek.belisko@gmail.com>
Tested-by: Marek Belisko <marek.belisko@gmail.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c |  2 ++
 drivers/net/wireless/mwifiex/main.h |  1 +
 drivers/net/wireless/mwifiex/usb.c  | 23 ++++++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index cb23ca3..2a5a59b 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -146,6 +146,8 @@ static int mwifiex_process_rx(struct mwifiex_adapter *adapter)
 		atomic_dec(&adapter->rx_pending);
 		if (adapter->delay_main_work &&
 		    (atomic_read(&adapter->rx_pending) < LOW_RX_PENDING)) {
+			if (adapter->if_ops.submit_rem_rx_urbs)
+				adapter->if_ops.submit_rem_rx_urbs(adapter);
 			adapter->delay_main_work = false;
 			queue_work(adapter->workqueue, &adapter->main_work);
 		}
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index df6f877..5feaffb 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -693,6 +693,7 @@ struct mwifiex_if_ops {
 	void (*fw_dump)(struct mwifiex_adapter *);
 	int (*clean_pcie_ring) (struct mwifiex_adapter *adapter);
 	void (*iface_work)(struct work_struct *work);
+	void (*submit_rem_rx_urbs)(struct mwifiex_adapter *adapter);
 };
 
 struct mwifiex_adapter {
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 08e9ec0..6cc8519 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -222,7 +222,13 @@ setup_for_next:
 	else
 		size = MWIFIEX_RX_DATA_BUF_SIZE;
 
-	mwifiex_usb_submit_rx_urb(context, size);
+	if (card->rx_cmd_ep == context->ep) {
+		mwifiex_usb_submit_rx_urb(context, size);
+	} else {
+		context->skb = NULL;
+		if (atomic_read(&adapter->rx_pending) <= HIGH_RX_PENDING)
+			mwifiex_usb_submit_rx_urb(context, size);
+	}
 
 	return;
 }
@@ -978,6 +984,20 @@ static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+static void mwifiex_usb_submit_rem_rx_urbs(struct mwifiex_adapter *adapter)
+{
+	struct usb_card_rec *card = (struct usb_card_rec *)adapter->card;
+	int i;
+	struct urb_context *ctx;
+
+	for (i = 0; i < MWIFIEX_RX_DATA_URB; i++) {
+		if (card->rx_data_list[i].skb)
+			continue;
+		ctx = &card->rx_data_list[i];
+		mwifiex_usb_submit_rx_urb(ctx, MWIFIEX_RX_DATA_BUF_SIZE);
+	}
+}
+
 static struct mwifiex_if_ops usb_ops = {
 	.register_dev =		mwifiex_register_dev,
 	.unregister_dev =	mwifiex_unregister_dev,
@@ -989,6 +1009,7 @@ static struct mwifiex_if_ops usb_ops = {
 	.cmdrsp_complete =	mwifiex_usb_cmd_event_complete,
 	.event_complete =	mwifiex_usb_cmd_event_complete,
 	.host_to_card =		mwifiex_usb_host_to_card,
+	.submit_rem_rx_urbs =	mwifiex_usb_submit_rem_rx_urbs,
 };
 
 /* This function initializes the USB driver module.
-- 
1.8.1.4

