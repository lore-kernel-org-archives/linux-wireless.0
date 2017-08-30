Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53938 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750860AbdH3T5A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 15:57:00 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7UJt8rG008298
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:57:00 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2cnty0kt1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 12:57:00 -0700
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 2/2] mwifiex: print URB submit failure error after threshold attemtps
Date: Thu, 31 Aug 2017 01:21:14 +0530
Message-ID: <1504122674-3379-3-git-send-email-gbhat@marvell.com> (sfid-20170830_215703_787667_586A7EB6)
In-Reply-To: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
References: <1504122674-3379-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current driver prints dev_alloc_skb failures everytime while
submitting RX URBs. This failure might be frequent in some
low resource platforms. So, wait for a threshold failure
count before start priting the error. This change is a follow
up for the 'commit 7b368e3d15c3
("mwifiex: resubmit failed to submit RX URBs in main thread")'

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 11 +++++++++--
 drivers/net/wireless/marvell/mwifiex/usb.h |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index f4f2b9b..98f6973 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -300,9 +300,16 @@ static int mwifiex_usb_submit_rx_urb(struct urb_context *ctx, int size)
 	if (card->rx_cmd_ep != ctx->ep) {
 		ctx->skb = dev_alloc_skb(size);
 		if (!ctx->skb) {
-			mwifiex_dbg(adapter, ERROR,
-				    "%s: dev_alloc_skb failed\n", __func__);
+			if (++card->rx_urb_failure_count >
+			    MWIFIEX_RX_URB_FAILURE_THRESHOLD) {
+				mwifiex_dbg(adapter, ERROR,
+					    "%s: dev_alloc_skb failed, failure count = %u\n",
+					    __func__,
+					    card->rx_urb_failure_count);
+			}
 			return -ENOMEM;
+		} else {
+			card->rx_urb_failure_count = 0;
 		}
 	}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h b/drivers/net/wireless/marvell/mwifiex/usb.h
index 37abd22..dc4750b 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.h
+++ b/drivers/net/wireless/marvell/mwifiex/usb.h
@@ -43,6 +43,7 @@
 #define MWIFIEX_TX_DATA_URB	6
 #define MWIFIEX_RX_DATA_URB	6
 #define MWIFIEX_USB_TIMEOUT	100
+#define MWIFIEX_RX_URB_FAILURE_THRESHOLD	20
 
 #define USB8766_DEFAULT_FW_NAME	"mrvl/usb8766_uapsta.bin"
 #define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
@@ -117,6 +118,7 @@ struct usb_card_rec {
 	u8 rx_cmd_interval;
 	int tx_cmd_ep_type;
 	u8 tx_cmd_interval;
+	u32 rx_urb_failure_count;
 };
 
 struct fw_header {
-- 
1.9.1
