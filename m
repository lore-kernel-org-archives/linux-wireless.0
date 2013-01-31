Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:55597 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756663Ab3AaD6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 22:58:32 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: do not reconfigure tx buffer size in firmware while associating
Date: Wed, 30 Jan 2013 19:56:01 -0800
Message-Id: <1359604562-23777-1-git-send-email-bzhao@marvell.com> (sfid-20130131_045836_716950_D8BCE0BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's observed that reconfiguration of tx buffer size before
association can cause data path failure in firmware after
associated. Although this is only found with PCIe cards, but
potentially it could happen with any other interfaces as well.

The tx buffer reconfiguration is not really useful in firmware.
Let's remove it for all interfaces.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  |   39 -----------------------------------
 drivers/net/wireless/mwifiex/11n.h  |    2 -
 drivers/net/wireless/mwifiex/join.c |    2 -
 3 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 9cd6216..48cc46b 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -400,45 +400,6 @@ mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 }
 
 /*
- * This function reconfigures the Tx buffer size in firmware.
- *
- * This function prepares a firmware command and issues it, if
- * the current Tx buffer size is different from the one requested.
- * Maximum configurable Tx buffer size is limited by the HT capability
- * field value.
- */
-void
-mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
-		   struct mwifiex_bssdescriptor *bss_desc)
-{
-	u16 max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_2K;
-	u16 tx_buf, curr_tx_buf_size = 0;
-
-	if (bss_desc->bcn_ht_cap) {
-		if (le16_to_cpu(bss_desc->bcn_ht_cap->cap_info) &
-				IEEE80211_HT_CAP_MAX_AMSDU)
-			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_8K;
-		else
-			max_amsdu = MWIFIEX_TX_DATA_BUF_SIZE_4K;
-	}
-
-	tx_buf = min(priv->adapter->max_tx_buf_size, max_amsdu);
-
-	dev_dbg(priv->adapter->dev, "info: max_amsdu=%d, max_tx_buf=%d\n",
-		max_amsdu, priv->adapter->max_tx_buf_size);
-
-	if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_2K)
-		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
-	else if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_4K)
-		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_4K;
-	else if (priv->adapter->curr_tx_buf_size <= MWIFIEX_TX_DATA_BUF_SIZE_8K)
-		curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_8K;
-	if (curr_tx_buf_size != tx_buf)
-		mwifiex_send_cmd_async(priv, HostCmd_CMD_RECONFIGURE_TX_BUFF,
-				       HostCmd_ACT_GEN_SET, 0, &tx_buf);
-}
-
-/*
  * This function checks if the given pointer is valid entry of
  * Tx BA Stream table.
  */
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 46006a5..29a4c02 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -34,8 +34,6 @@ int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd, u16 cmd_action,
 int mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			       struct mwifiex_bssdescriptor *bss_desc,
 			       u8 **buffer);
-void mwifiex_cfg_tx_buf(struct mwifiex_private *priv,
-			struct mwifiex_bssdescriptor *bss_desc);
 void mwifiex_fill_cap_info(struct mwifiex_private *, u8 radio_type,
 			   struct mwifiex_ie_types_htcap *);
 int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index f0a634d..a537297 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -398,8 +398,6 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	pos = (u8 *) assoc;
 
-	mwifiex_cfg_tx_buf(priv, bss_desc);
-
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_ASSOCIATE);
 
 	/* Save so we know which BSS Desc to use in the response handler */
-- 
1.7.0.2

