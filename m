Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56976 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbaJaFJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 01:09:33 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <huxm@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>, <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 1/2] mwifiex: channel statistics support for mwifiex
Date: Fri, 31 Oct 2014 16:08:26 +0530
Message-ID: <1414751907-4957-2-git-send-email-patila@marvell.com> (sfid-20141031_060936_879899_166CAE89)
In-Reply-To: <1414751907-4957-1-git-send-email-patila@marvell.com>
References: <1414751907-4957-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to record channel statistics during
scan. With extended scan, scan results are returned as events from
FW while channel statistics are part of scan command response.
We store these channel statistics in adapter.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Xinmin Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c    | 19 ++++++++
 drivers/net/wireless/mwifiex/decl.h        | 10 ++++
 drivers/net/wireless/mwifiex/fw.h          | 16 +++++++
 drivers/net/wireless/mwifiex/main.c        |  6 +++
 drivers/net/wireless/mwifiex/main.h        |  6 ++-
 drivers/net/wireless/mwifiex/scan.c        | 76 +++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  2 +-
 7 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 0dd6729..80b1a54 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2840,6 +2840,25 @@ static const struct wiphy_coalesce_support mwifiex_coalesce_support = {
 	.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN,
 };
 
+int mwifiex_init_channel_scan_gap(struct mwifiex_adapter *adapter)
+{
+	u32 n_channels_bg, n_channels_a = 0;
+
+	n_channels_bg = mwifiex_band_2ghz.n_channels;
+
+	if (adapter->config_bands & BAND_A)
+		n_channels_a = mwifiex_band_5ghz.n_channels;
+
+	adapter->num_in_chan_stats = max_t(u32, n_channels_bg, n_channels_a);
+	adapter->chan_stats = vmalloc(sizeof(*adapter->chan_stats) *
+				      adapter->num_in_chan_stats);
+
+	if (!adapter->chan_stats)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * This function registers the device with CFG802.11 subsystem.
  *
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index e0d00a7..f53e5b5 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -185,4 +185,14 @@ struct mwifiex_arp_eth_header {
 	u8 ar_tha[ETH_ALEN];
 	u8 ar_tip[4];
 } __packed;
+
+struct mwifiex_chan_stats {
+	u8 chan_num;
+	u8 bandcfg;
+	u8 flags;
+	s8 noise;
+	u16 total_bss;
+	u16 cca_scan_dur;
+	u16 cca_busy_dur;
+} __packed;
 #endif /* !_MWIFIEX_DECL_H_ */
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 1eb6173..7f922a8 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -172,6 +172,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_TDLS_IDLE_TIMEOUT  (PROPRIETARY_TLV_BASE_ID + 194)
 #define TLV_TYPE_SCAN_CHANNEL_GAP   (PROPRIETARY_TLV_BASE_ID + 197)
 #define TLV_TYPE_API_REV            (PROPRIETARY_TLV_BASE_ID + 199)
+#define TLV_TYPE_CHANNEL_STATS      (PROPRIETARY_TLV_BASE_ID + 198)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -611,6 +612,16 @@ struct uap_rxpd {
 	u8 reserved1;
 };
 
+struct mwifiex_fw_chan_stats {
+	u8 chan_num;
+	u8 bandcfg;
+	u8 flags;
+	s8 noise;
+	__le16 total_bss;
+	__le16 cca_scan_dur;
+	__le16 cca_busy_dur;
+} __packed;
+
 enum mwifiex_chan_scan_mode_bitmasks {
 	MWIFIEX_PASSIVE_SCAN = BIT(0),
 	MWIFIEX_DISABLE_CHAN_FILT = BIT(1),
@@ -660,6 +671,11 @@ struct mwifiex_ie_types_scan_chan_gap {
 	__le16 chan_gap;
 } __packed;
 
+struct mwifiex_ietypes_chanstats {
+	struct mwifiex_ie_types_header header;
+	struct mwifiex_fw_chan_stats chanstats[0];
+} __packed;
+
 struct mwifiex_ie_types_wildcard_ssid_params {
 	struct mwifiex_ie_types_header header;
 	u8 max_ssid_length;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index d5070c4..f26420d 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -122,6 +122,7 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 		}
 	}
 
+	vfree(adapter->chan_stats);
 	kfree(adapter);
 	return 0;
 }
@@ -447,6 +448,11 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 		goto err_init_fw;
 	}
 
+	if (mwifiex_init_channel_scan_gap(adapter)) {
+		dev_err(adapter->dev, "could not init channel stats table\n");
+		goto err_init_fw;
+	}
+
 	rtnl_lock();
 	/* Create station interface by default */
 	wdev = mwifiex_add_virtual_intf(adapter->wiphy, "mlan%d",
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index f55658d..cb39319 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -845,6 +845,9 @@ struct mwifiex_adapter {
 	u8 curr_mem_idx;
 	bool scan_chan_gap_enabled;
 	struct sk_buff_head rx_data_q;
+	struct mwifiex_chan_stats *chan_stats;
+	u32 num_in_chan_stats;
+	int survey_idx;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
@@ -1031,7 +1034,8 @@ void mwifiex_set_11ac_ba_params(struct mwifiex_private *priv);
 int mwifiex_cmd_802_11_scan_ext(struct mwifiex_private *priv,
 				struct host_cmd_ds_command *cmd,
 				void *data_buf);
-int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv);
+int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *resp);
 int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
 					 void *buf);
 
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ca64d4c..3a17821 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1755,6 +1755,7 @@ static void mwifiex_complete_scan(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 
+	adapter->survey_idx = 0;
 	if (adapter->curr_cmd->wait_q_enabled) {
 		adapter->cmd_wait_q.status = 0;
 		if (!priv->scan_request) {
@@ -1976,10 +1977,53 @@ int mwifiex_cmd_802_11_scan_ext(struct mwifiex_private *priv,
 	return 0;
 }
 
+static void
+mwifiex_update_chan_statistics(struct mwifiex_private *priv,
+			       struct mwifiex_ietypes_chanstats *tlv_stat)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 i, num_chan;
+	struct mwifiex_fw_chan_stats *fw_chan_stats;
+	struct mwifiex_chan_stats chan_stats;
+
+	fw_chan_stats = (void *)((u8 *)tlv_stat +
+			      sizeof(struct mwifiex_ie_types_header));
+	num_chan = le16_to_cpu(tlv_stat->header.len) /
+					      sizeof(struct mwifiex_chan_stats);
+
+	for (i = 0 ; i < num_chan; i++) {
+		chan_stats.chan_num = fw_chan_stats->chan_num;
+		chan_stats.bandcfg = fw_chan_stats->bandcfg;
+		chan_stats.flags = fw_chan_stats->flags;
+		chan_stats.noise = fw_chan_stats->noise;
+		chan_stats.total_bss = le16_to_cpu(fw_chan_stats->total_bss);
+		chan_stats.cca_scan_dur =
+				       le16_to_cpu(fw_chan_stats->cca_scan_dur);
+		chan_stats.cca_busy_dur =
+				       le16_to_cpu(fw_chan_stats->cca_busy_dur);
+		dev_dbg(adapter->dev,
+			"chan=%d, noise=%d, total_network=%d scan_duration=%d, busy_duration=%d\n",
+			chan_stats.chan_num,
+			chan_stats.noise,
+			chan_stats.total_bss,
+			chan_stats.cca_scan_dur,
+			chan_stats.cca_busy_dur);
+		memcpy(&adapter->chan_stats[adapter->survey_idx++], &chan_stats,
+		       sizeof(struct mwifiex_chan_stats));
+		fw_chan_stats++;
+	}
+}
+
 /* This function handles the command response of extended scan */
-int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv)
+int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv,
+				struct host_cmd_ds_command *resp)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
+	struct host_cmd_ds_802_11_scan_ext *ext_scan_resp;
+	struct mwifiex_ie_types_header *tlv;
+	struct mwifiex_ietypes_chanstats *tlv_stat;
+	u16 buf_left, type, len;
+
 	struct host_cmd_ds_command *cmd_ptr;
 	struct cmd_ctrl_node *cmd_node;
 	unsigned long cmd_flags, scan_flags;
@@ -1987,6 +2031,36 @@ int mwifiex_ret_802_11_scan_ext(struct mwifiex_private *priv)
 
 	dev_dbg(priv->adapter->dev, "info: EXT scan returns successfully\n");
 
+	ext_scan_resp = &resp->params.ext_scan;
+
+	tlv = (void *)ext_scan_resp->tlv_buffer;
+	buf_left = le16_to_cpu(resp->size) - (sizeof(*ext_scan_resp) + S_DS_GEN
+					      - 1);
+
+	while (buf_left >= sizeof(struct mwifiex_ie_types_header)) {
+		type = le16_to_cpu(tlv->type);
+		len = le16_to_cpu(tlv->len);
+
+		if (buf_left < (sizeof(struct mwifiex_ie_types_header) + len)) {
+			dev_err(adapter->dev,
+				"error processing scan response TLVs");
+			break;
+		}
+
+		switch (type) {
+		case TLV_TYPE_CHANNEL_STATS:
+			tlv_stat = (void *)tlv;
+			mwifiex_update_chan_statistics(priv, tlv_stat);
+			break;
+		default:
+			break;
+		}
+
+		buf_left -= len + sizeof(struct mwifiex_ie_types_header);
+		tlv = (void *)((u8 *)tlv + len +
+			       sizeof(struct mwifiex_ie_types_header));
+	}
+
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, cmd_flags);
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, scan_flags);
 	if (list_empty(&adapter->scan_pending_q)) {
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 4aad446..b65e101 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -983,7 +983,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		adapter->curr_cmd->wait_q_enabled = false;
 		break;
 	case HostCmd_CMD_802_11_SCAN_EXT:
-		ret = mwifiex_ret_802_11_scan_ext(priv);
+		ret = mwifiex_ret_802_11_scan_ext(priv, resp);
 		adapter->curr_cmd->wait_q_enabled = false;
 		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
-- 
1.8.1.4

