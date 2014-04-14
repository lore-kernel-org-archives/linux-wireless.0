Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27729 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565AbaDNWdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:33:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/7] mwifiex: increase the number of nodes in command pool
Date: Mon, 14 Apr 2014 15:32:52 -0700
Message-ID: <1397514775-4777-4-git-send-email-bzhao@marvell.com> (sfid-20140415_003411_408951_4AB03583)
In-Reply-To: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
References: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Command nodes are increased from 20 to 50. Now we can always
scan 1 channel per scan command to avoid traffic delay/loss in
connected state. We will get rid of *CHANNEL_PER_SCAN_CMD macros
used due to command node constraints.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ioctl.h |  2 +-
 drivers/net/wireless/mwifiex/scan.c  | 17 ++---------------
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index ee494db..1b57672 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -303,7 +303,7 @@ struct mwifiex_ds_ant_cfg {
 	u32 rx_ant;
 };
 
-#define MWIFIEX_NUM_OF_CMD_BUFFER	20
+#define MWIFIEX_NUM_OF_CMD_BUFFER	50
 #define MWIFIEX_SIZE_OF_CMD_BUFFER	2048
 
 enum {
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 7b3af3d..5c68173 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -29,9 +29,6 @@
 #define MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN   14
 
 #define MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD	4
-#define MWIFIEX_LIMIT_1_CHANNEL_PER_SCAN_CMD	15
-#define MWIFIEX_LIMIT_2_CHANNELS_PER_SCAN_CMD	27
-#define MWIFIEX_LIMIT_3_CHANNELS_PER_SCAN_CMD	35
 
 /* Memory needed to store a max sized Channel List TLV for a firmware scan */
 #define CHAN_TLV_MAX_SIZE  (sizeof(struct mwifiex_ie_types_header)         \
@@ -1055,20 +1052,10 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 
 	/*
 	 * In associated state we will reduce the number of channels scanned per
-	 * scan command to avoid any traffic delay/loss. This number is decided
-	 * based on total number of channels to be scanned due to constraints
-	 * of command buffers.
+	 * scan command to 1 to avoid any traffic delay/loss.
 	 */
-	if (priv->media_connected) {
-		if (chan_num < MWIFIEX_LIMIT_1_CHANNEL_PER_SCAN_CMD)
+	if (priv->media_connected)
 			*max_chan_per_scan = 1;
-		else if (chan_num < MWIFIEX_LIMIT_2_CHANNELS_PER_SCAN_CMD)
-			*max_chan_per_scan = 2;
-		else if (chan_num < MWIFIEX_LIMIT_3_CHANNELS_PER_SCAN_CMD)
-			*max_chan_per_scan = 3;
-		else
-			*max_chan_per_scan = 4;
-	}
 }
 
 /*
-- 
1.8.2.3

