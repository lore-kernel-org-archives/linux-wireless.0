Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8941 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042AbaKEGFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 01:05:23 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <cluo@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [Patch v2 2/5] mwifiex: remove data_complete handler
Date: Wed, 5 Nov 2014 17:04:28 +0530
Message-ID: <1415187271-17914-2-git-send-email-akarwar@marvell.com> (sfid-20141105_070528_739494_D31D5069)
In-Reply-To: <1415187271-17914-1-git-send-email-akarwar@marvell.com>
References: <1415187271-17914-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch removes redundant data complete handler.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h | 1 -
 drivers/net/wireless/mwifiex/txrx.c | 4 ----
 drivers/net/wireless/mwifiex/usb.c  | 6 ------
 3 files changed, 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a9eea9b..df6f877 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -687,7 +687,6 @@ struct mwifiex_if_ops {
 	void (*cleanup_mpa_buf) (struct mwifiex_adapter *);
 	int (*cmdrsp_complete) (struct mwifiex_adapter *, struct sk_buff *);
 	int (*event_complete) (struct mwifiex_adapter *, struct sk_buff *);
-	int (*data_complete) (struct mwifiex_adapter *);
 	int (*init_fw_port) (struct mwifiex_adapter *);
 	int (*dnld_fw) (struct mwifiex_adapter *, struct mwifiex_fw_image *);
 	void (*card_reset) (struct mwifiex_adapter *);
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index 96a2126..a5983fc 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -64,10 +64,6 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 	else
 		ret = mwifiex_process_sta_rx_packet(priv, skb);
 
-	/* Decrement RX pending counter for each packet */
-	if (adapter->if_ops.data_complete)
-		adapter->if_ops.data_complete(adapter);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mwifiex_handle_rx_packet);
diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index 00afcf6..08e9ec0 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -967,11 +967,6 @@ static int mwifiex_usb_cmd_event_complete(struct mwifiex_adapter *adapter,
 	return 0;
 }
 
-static int mwifiex_usb_data_complete(struct mwifiex_adapter *adapter)
-{
-	return 0;
-}
-
 /* This function wakes up the card. */
 static int mwifiex_pm_wakeup_card(struct mwifiex_adapter *adapter)
 {
@@ -993,7 +988,6 @@ static struct mwifiex_if_ops usb_ops = {
 	.dnld_fw =		mwifiex_usb_dnld_fw,
 	.cmdrsp_complete =	mwifiex_usb_cmd_event_complete,
 	.event_complete =	mwifiex_usb_cmd_event_complete,
-	.data_complete =	mwifiex_usb_data_complete,
 	.host_to_card =		mwifiex_usb_host_to_card,
 };
 
-- 
1.8.1.4

