Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:37968 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763Ab3FRXlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 19:41:55 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Subject: [PATCH 3/3] mwifiex: channel switch handling for station
Date: Tue, 18 Jun 2013 16:36:58 -0700
Message-ID: <1371598618-26593-3-git-send-email-bzhao@marvell.com> (sfid-20130619_014158_783047_9F8AB7E9)
In-Reply-To: <1371598618-26593-1-git-send-email-bzhao@marvell.com>
References: <1371598618-26593-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

After receiving channel switch announcement from AP, scan and
association on that channel is blocked for DFS_CHAN_MOVE_TIME
(10 seconds). Hence station will be able to connect to the AP,
once it is moved to new channel.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 drivers/net/wireless/mwifiex/fw.h        |  2 ++
 drivers/net/wireless/mwifiex/init.c      |  3 +++
 drivers/net/wireless/mwifiex/main.h      | 20 ++++++++++++++++++++
 drivers/net/wireless/mwifiex/scan.c      | 18 ++++++++++++++++++
 drivers/net/wireless/mwifiex/sta_event.c |  3 +++
 drivers/net/wireless/mwifiex/sta_ioctl.c |  8 ++++++++
 6 files changed, 54 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index b6fbbf6..1b45aa5 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -245,6 +245,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define HT_BW_20    0
 #define HT_BW_40    1
 
+#define DFS_CHAN_MOVE_TIME      10000
+
 #define HostCmd_CMD_GET_HW_SPEC                       0x0003
 #define HostCmd_CMD_802_11_SCAN                       0x0006
 #define HostCmd_CMD_802_11_GET_LOG                    0x000b
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 2fe31dc..caaf4bd 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -133,6 +133,9 @@ int mwifiex_init_priv(struct mwifiex_private *priv)
 
 	priv->scan_block = false;
 
+	priv->csa_chan = 0;
+	priv->csa_expire_time = 0;
+
 	return mwifiex_add_bss_prio_tbl(priv);
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 95a6f52..3da73d3 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -513,6 +513,8 @@ struct mwifiex_private {
 	u32 mgmt_frame_mask;
 	struct mwifiex_roc_cfg roc_cfg;
 	bool scan_aborting;
+	u8 csa_chan;
+	unsigned long csa_expire_time;
 };
 
 enum mwifiex_ba_status {
@@ -1021,6 +1023,24 @@ static inline bool mwifiex_is_skb_mgmt_frame(struct sk_buff *skb)
 	return (*(u32 *)skb->data == PKT_TYPE_MGMT);
 }
 
+/* This function retrieves channel closed for operation by Channel
+ * Switch Announcement.
+ */
+static inline u8
+mwifiex_11h_get_csa_closed_channel(struct mwifiex_private *priv)
+{
+	if (!priv->csa_chan)
+		return 0;
+
+	/* Clear csa channel, if DFS channel move time has passed */
+	if (jiffies > priv->csa_expire_time) {
+		priv->csa_chan = 0;
+		priv->csa_expire_time = 0;
+	}
+
+	return priv->csa_chan;
+}
+
 int mwifiex_init_shutdown_fw(struct mwifiex_private *priv,
 			     u32 func_init_shutdown);
 int mwifiex_add_card(void *, struct semaphore *, struct mwifiex_if_ops *, u8);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 284d68b..c447d9b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -575,6 +575,9 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		return -1;
 	}
 
+	/* Check csa channel expiry before preparing scan list */
+	mwifiex_11h_get_csa_closed_channel(priv);
+
 	chan_tlv_out->header.type = cpu_to_le16(TLV_TYPE_CHANLIST);
 
 	/* Set the temp channel struct pointer to the start of the desired
@@ -604,6 +607,11 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 		while (tlv_idx < max_chan_per_scan &&
 		       tmp_chan_list->chan_number && !done_early) {
 
+			if (tmp_chan_list->chan_number == priv->csa_chan) {
+				tmp_chan_list++;
+				continue;
+			}
+
 			dev_dbg(priv->adapter->dev,
 				"info: Scan: Chan(%3d), Radio(%d),"
 				" Mode(%d, %d), Dur(%d)\n",
@@ -1594,6 +1602,9 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		goto check_next_scan;
 	}
 
+	/* Check csa channel expiry before parsing scan response */
+	mwifiex_11h_get_csa_closed_channel(priv);
+
 	bytes_left = le16_to_cpu(scan_rsp->bss_descript_size);
 	dev_dbg(adapter->dev, "info: SCAN_RESP: bss_descript_size %d\n",
 		bytes_left);
@@ -1746,6 +1757,13 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			struct ieee80211_channel *chan;
 			u8 band;
 
+			/* Skip entry if on csa closed channel */
+			if (channel == priv->csa_chan) {
+				dev_dbg(adapter->dev,
+					"Dropping entry on csa closed channel\n");
+				continue;
+			}
+
 			band = BAND_G;
 			if (chan_band_tlv) {
 				chan_band =
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 0f7b4cf..8155471 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -429,6 +429,9 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_CHANNEL_SWITCH_ANN:
 		dev_dbg(adapter->dev, "event: Channel Switch Announcement\n");
+		priv->csa_expire_time =
+				jiffies + msecs_to_jiffies(DFS_CHAN_MOVE_TIME);
+		priv->csa_chan = priv->curr_bss_params.bss_descriptor.channel;
 		ret = mwifiex_send_cmd_async(priv,
 			HostCmd_CMD_802_11_DEAUTHENTICATE,
 			HostCmd_ACT_GEN_SET, 0,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 498add7..206c3e0 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -281,6 +281,14 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		if (ret)
 			goto done;
 
+		if (mwifiex_11h_get_csa_closed_channel(priv) ==
+							(u8)bss_desc->channel) {
+			dev_err(adapter->dev,
+				"Attempt to reconnect on csa closed chan(%d)\n",
+				bss_desc->channel);
+			goto done;
+		}
+
 		dev_dbg(adapter->dev, "info: SSID found in scan list ... "
 				      "associating...\n");
 
-- 
1.8.2.3

