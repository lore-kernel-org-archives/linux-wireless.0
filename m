Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:47726 "HELO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750991Ab2FGEOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 00:14:41 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/3] mwifiex: scan less channels per scan command to improve Tx traffic
Date: Wed,  6 Jun 2012 21:12:42 -0700
Message-Id: <1339042362-30317-4-git-send-email-bzhao@marvell.com> (sfid-20120607_061444_145751_39199D0D)
In-Reply-To: <1339042362-30317-1-git-send-email-bzhao@marvell.com>
References: <1339042362-30317-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently 4 channels are scanned per scan command. if scan request
is issued by user during Tx traffic, radio will be out of channel
for "4 * per_chan_scan_time" for each scan command and will not be
able to receive Rx packets. This adds delay in data traffic. We can
minimize it by reducing number of channels scanned per scan command
in this scenario.

We can not always scan 1 channel per scan command due to limitation
of number of command buffers. So we add code to decide number of
channels scanned per scan command in associated state.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ea2f1bd..efaf26c 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -28,7 +28,10 @@
 /* The maximum number of channels the firmware can scan per command */
 #define MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN   14
 
-#define MWIFIEX_CHANNELS_PER_SCAN_CMD            4
+#define MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD	4
+#define MWIFIEX_LIMIT_1_CHANNEL_PER_SCAN_CMD	15
+#define MWIFIEX_LIMIT_2_CHANNELS_PER_SCAN_CMD	27
+#define MWIFIEX_LIMIT_3_CHANNELS_PER_SCAN_CMD	35
 
 /* Memory needed to store a max sized Channel List TLV for a firmware scan */
 #define CHAN_TLV_MAX_SIZE  (sizeof(struct mwifiex_ie_types_header)         \
@@ -471,7 +474,7 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
  * This routine is used for any scan that is not provided with a
  * specific channel list to scan.
  */
-static void
+static int
 mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 				 const struct mwifiex_user_scan_cfg
 							*user_scan_in,
@@ -528,6 +531,7 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 		}
 
 	}
+	return chan_idx;
 }
 
 /*
@@ -727,6 +731,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	u32 num_probes;
 	u32 ssid_len;
 	u32 chan_idx;
+	u32 chan_num;
 	u32 scan_type;
 	u16 scan_dur;
 	u8 channel;
@@ -850,7 +855,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	if (*filtered_scan)
 		*max_chan_per_scan = MWIFIEX_MAX_CHANNELS_PER_SPECIFIC_SCAN;
 	else
-		*max_chan_per_scan = MWIFIEX_CHANNELS_PER_SCAN_CMD;
+		*max_chan_per_scan = MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD;
 
 	/* If the input config or adapter has the number of Probes set,
 	   add tlv */
@@ -962,13 +967,28 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 			dev_dbg(adapter->dev,
 				"info: Scan: Scanning current channel only\n");
 		}
-
+		chan_num = chan_idx;
 	} else {
 		dev_dbg(adapter->dev,
 			"info: Scan: Creating full region channel list\n");
-		mwifiex_scan_create_channel_list(priv, user_scan_in,
-						 scan_chan_list,
-						 *filtered_scan);
+		chan_num = mwifiex_scan_create_channel_list(priv, user_scan_in,
+							    scan_chan_list,
+							    *filtered_scan);
+	}
+
+	/*
+	 * In associated state we will reduce the number of channels scanned per
+	 * scan command to avoid any traffic delay/loss. This number is decided
+	 * based on total number of channels to be scanned due to constraints
+	 * of command buffers.
+	 */
+	if (priv->media_connected) {
+		if (chan_num < MWIFIEX_LIMIT_1_CHANNEL_PER_SCAN_CMD)
+			*max_chan_per_scan = 1;
+		else if (chan_num < MWIFIEX_LIMIT_2_CHANNELS_PER_SCAN_CMD)
+			*max_chan_per_scan = 2;
+		else if (chan_num < MWIFIEX_LIMIT_3_CHANNELS_PER_SCAN_CMD)
+			*max_chan_per_scan = 3;
 	}
 }
 
-- 
1.7.0.2

