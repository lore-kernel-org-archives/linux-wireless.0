Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52461 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbbAWGJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 01:09:33 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0N65JpA029165
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 22:09:32 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1s2a34vtc8-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 22:09:32 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yogeshp@marvell.com>,
	<nishants@marvell.com>, <frankh@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 1/3] mwifiex: add support for SD8801
Date: Fri, 23 Jan 2015 17:09:17 +0530
Message-ID: <1422013159-3093-1-git-send-email-patila@marvell.com> (sfid-20150123_070936_818742_50BCAD83)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

SD8801 is Marvell's 1x1 802.11bgn offering.
This patch adds Device IDs for SD8801 and also defines card
structure which has definition for register offsets, buffer sizes etc.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c |  5 +++++
 drivers/net/wireless/mwifiex/sdio.h | 15 +++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index a70f1033..cee107f 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -282,6 +282,9 @@ static int mwifiex_sdio_suspend(struct device *dev)
 #define SDIO_DEVICE_ID_MARVELL_8897   (0x912d)
 /* Device ID for SD8887 */
 #define SDIO_DEVICE_ID_MARVELL_8887   (0x9135)
+/* Device ID for SD8801 */
+#define SDIO_DEVICE_ID_MARVELL_8801   (0x9139)
+
 
 /* WLAN IDs */
 static const struct sdio_device_id mwifiex_ids[] = {
@@ -295,6 +298,8 @@ static const struct sdio_device_id mwifiex_ids[] = {
 		.driver_data = (unsigned long) &mwifiex_sdio_sd8897},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8887),
 		.driver_data = (unsigned long)&mwifiex_sdio_sd8887},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, SDIO_DEVICE_ID_MARVELL_8801),
+		.driver_data = (unsigned long)&mwifiex_sdio_sd8801},
 	{},
 };
 
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 895eea0..a4bb0db 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -34,6 +34,7 @@
 #define SD8797_DEFAULT_FW_NAME "mrvl/sd8797_uapsta.bin"
 #define SD8897_DEFAULT_FW_NAME "mrvl/sd8897_uapsta.bin"
 #define SD8887_DEFAULT_FW_NAME "mrvl/sd8887_uapsta.bin"
+#define SD8801_DEFAULT_FW_NAME "mrvl/sd8801_uapsta.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
@@ -474,6 +475,20 @@ static const struct mwifiex_sdio_device mwifiex_sdio_sd8887 = {
 	.auto_tdls = true,
 };
 
+static const struct mwifiex_sdio_device mwifiex_sdio_sd8801 = {
+	.firmware = SD8801_DEFAULT_FW_NAME,
+	.reg = &mwifiex_reg_sd87xx,
+	.max_ports = 16,
+	.mp_agg_pkt_limit = 8,
+	.supports_sdio_new_mode = false,
+	.has_control_mask = true,
+	.tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K,
+	.mp_tx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.mp_rx_agg_buf_size = MWIFIEX_MP_AGGR_BUF_SIZE_16K,
+	.supports_fw_dump = false,
+	.auto_tdls = false,
+};
+
 /*
  * .cmdrsp_complete handler
  */
-- 
1.8.1.4

