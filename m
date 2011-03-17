Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab1CQS7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:13 -0400
Received: by mail-iy0-f174.google.com with SMTP id 26so3126341iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:13 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 3/9] mwl8k: add support for block ack commands
Date: Thu, 17 Mar 2011 11:58:43 -0700
Message-Id: <1300388329-15380-3-git-send-email-brian@cozybit.com>
In-Reply-To: <1300388329-15380-1-git-send-email-brian@cozybit.com>
References: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |  156 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 156 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9db66d5..944ad03 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -135,6 +135,14 @@ struct mwl8k_tx_queue {
 	struct sk_buff **skb;
 };
 
+struct mwl8k_ampdu_stream {
+	struct ieee80211_sta *sta;
+	u8 tid;
+	u8 state;
+	u8 idx;
+	u8 txq_idx; /* index of this stream in priv->txq */
+};
+
 struct mwl8k_priv {
 	struct ieee80211_hw *hw;
 	struct pci_dev *pdev;
@@ -360,6 +368,7 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 #define MWL8K_CMD_SET_NEW_STN		0x1111		/* per-vif */
 #define MWL8K_CMD_UPDATE_ENCRYPTION	0x1122		/* per-vif */
 #define MWL8K_CMD_UPDATE_STADB		0x1123
+#define MWL8K_CMD_BASTREAM		0x1125
 
 static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 {
@@ -399,6 +408,7 @@ static const char *mwl8k_cmd_name(__le16 cmd, char *buf, int bufsize)
 		MWL8K_CMDNAME(SET_NEW_STN);
 		MWL8K_CMDNAME(UPDATE_ENCRYPTION);
 		MWL8K_CMDNAME(UPDATE_STADB);
+		MWL8K_CMDNAME(BASTREAM);
 	default:
 		snprintf(buf, bufsize, "0x%x", cmd);
 	}
@@ -3176,6 +3186,152 @@ static int mwl8k_cmd_bss_start(struct ieee80211_hw *hw,
 }
 
 /*
+ * CMD_BASTREAM.
+ */
+
+/*
+ * UPSTREAM is tx direction
+ */
+#define BASTREAM_FLAG_DIRECTION_UPSTREAM	0x00
+#define BASTREAM_FLAG_IMMEDIATE_TYPE		0x01
+
+enum {
+	MWL8K_BA_CREATE,
+	MWL8K_BA_UPDATE,
+	MWL8K_BA_DESTROY,
+	MWL8K_BA_FLUSH,
+	MWL8K_BA_CHECK,
+} ba_stream_action_type;
+
+
+struct mwl8k_create_ba_stream {
+	__le32	flags;
+	__le32	idle_thrs;
+	__le32	bar_thrs;
+	__le32	window_size;
+	u8	peer_mac_addr[6];
+	u8	dialog_token;
+	u8	tid;
+	u8	queue_id;
+	u8	param_info;
+	__le32	ba_context;
+	u8	reset_seq_no_flag;
+	__le16	curr_seq_no;
+	u8	sta_src_mac_addr[6];
+} __packed;
+
+struct mwl8k_destroy_ba_stream {
+	__le32	flags;
+	__le32	ba_context;
+} __packed;
+
+struct mwl8k_cmd_bastream {
+	struct mwl8k_cmd_pkt	header;
+	__le32	action;
+	union {
+		struct mwl8k_create_ba_stream	create_params;
+		struct mwl8k_destroy_ba_stream	destroy_params;
+	};
+} __packed;
+
+static int
+mwl8k_check_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream)
+{
+	struct mwl8k_cmd_bastream *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_BASTREAM);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+
+	cmd->action = cpu_to_le32(MWL8K_BA_CHECK);
+
+	cmd->create_params.queue_id = stream->idx;
+	memcpy(&cmd->create_params.peer_mac_addr[0], stream->sta->addr,
+	       ETH_ALEN);
+	cmd->create_params.tid = stream->tid;
+
+	cmd->create_params.flags =
+		cpu_to_le32(BASTREAM_FLAG_IMMEDIATE_TYPE) |
+		cpu_to_le32(BASTREAM_FLAG_DIRECTION_UPSTREAM);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+
+	kfree(cmd);
+
+	return rc;
+}
+
+static int
+mwl8k_create_ba(struct ieee80211_hw *hw, struct mwl8k_ampdu_stream *stream,
+		u8 buf_size)
+{
+	struct mwl8k_cmd_bastream *cmd;
+	int rc;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return -ENOMEM;
+
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_BASTREAM);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+
+	cmd->action = cpu_to_le32(MWL8K_BA_CREATE);
+
+	cmd->create_params.bar_thrs = cpu_to_le32((u32)buf_size);
+	cmd->create_params.window_size = cpu_to_le32((u32)buf_size);
+	cmd->create_params.queue_id = stream->idx;
+
+	memcpy(cmd->create_params.peer_mac_addr, stream->sta->addr, ETH_ALEN);
+	cmd->create_params.tid = stream->tid;
+	cmd->create_params.curr_seq_no = cpu_to_le16(0);
+	cmd->create_params.reset_seq_no_flag = 1;
+
+	cmd->create_params.param_info =
+		(stream->sta->ht_cap.ampdu_factor &
+		 IEEE80211_HT_AMPDU_PARM_FACTOR) |
+		((stream->sta->ht_cap.ampdu_density << 2) &
+		 IEEE80211_HT_AMPDU_PARM_DENSITY);
+
+	cmd->create_params.flags =
+		cpu_to_le32(BASTREAM_FLAG_IMMEDIATE_TYPE |
+					BASTREAM_FLAG_DIRECTION_UPSTREAM);
+
+	rc = mwl8k_post_cmd(hw, &cmd->header);
+
+	wiphy_debug(hw->wiphy, "Created a BA stream for %pM : tid %d\n",
+		stream->sta->addr, stream->tid);
+	kfree(cmd);
+
+	return rc;
+}
+
+static void mwl8k_destroy_ba(struct ieee80211_hw *hw,
+			     struct mwl8k_ampdu_stream *stream)
+{
+	struct mwl8k_cmd_bastream *cmd;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (cmd == NULL)
+		return;
+
+	cmd->header.code = cpu_to_le16(MWL8K_CMD_BASTREAM);
+	cmd->header.length = cpu_to_le16(sizeof(*cmd));
+	cmd->action = cpu_to_le32(MWL8K_BA_DESTROY);
+
+	cmd->destroy_params.ba_context = cpu_to_le32(stream->idx);
+	mwl8k_post_cmd(hw, &cmd->header);
+
+	wiphy_debug(hw->wiphy, "Deleted BA stream index %d\n", stream->idx);
+
+	kfree(cmd);
+}
+
+/*
  * CMD_SET_NEW_STN.
  */
 struct mwl8k_cmd_set_new_stn {
-- 
1.7.1.1

