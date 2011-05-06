Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54054 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab1EFS2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 14:28:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/7] iwlagn: remove frame pre-allocation
Date: Fri,  6 May 2011 11:04:36 -0700
Message-Id: <1304705080-29349-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110506_202849_685230_73BFF904)
In-Reply-To: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1304705080-29349-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The frame pre-allocation is quite a bit of complex
code, all to avoid a single allocation. Remove it
and consolidate the beacon sending code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |  137 ++++++--------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h |   13 ---
 2 files changed, 25 insertions(+), 125 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 09fe841..3ecc319 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -102,70 +102,6 @@ void iwl_update_chain_flags(struct iwl_priv *priv)
 	}
 }
 
-static void iwl_clear_free_frames(struct iwl_priv *priv)
-{
-	struct list_head *element;
-
-	IWL_DEBUG_INFO(priv, "%d frames on pre-allocated heap on clear.\n",
-		       priv->frames_count);
-
-	while (!list_empty(&priv->free_frames)) {
-		element = priv->free_frames.next;
-		list_del(element);
-		kfree(list_entry(element, struct iwl_frame, list));
-		priv->frames_count--;
-	}
-
-	if (priv->frames_count) {
-		IWL_WARN(priv, "%d frames still in use.  Did we lose one?\n",
-			    priv->frames_count);
-		priv->frames_count = 0;
-	}
-}
-
-static struct iwl_frame *iwl_get_free_frame(struct iwl_priv *priv)
-{
-	struct iwl_frame *frame;
-	struct list_head *element;
-	if (list_empty(&priv->free_frames)) {
-		frame = kzalloc(sizeof(*frame), GFP_KERNEL);
-		if (!frame) {
-			IWL_ERR(priv, "Could not allocate frame!\n");
-			return NULL;
-		}
-
-		priv->frames_count++;
-		return frame;
-	}
-
-	element = priv->free_frames.next;
-	list_del(element);
-	return list_entry(element, struct iwl_frame, list);
-}
-
-static void iwl_free_frame(struct iwl_priv *priv, struct iwl_frame *frame)
-{
-	memset(frame, 0, sizeof(*frame));
-	list_add(&frame->list, &priv->free_frames);
-}
-
-static u32 iwl_fill_beacon_frame(struct iwl_priv *priv,
-				 struct ieee80211_hdr *hdr,
-				 int left)
-{
-	lockdep_assert_held(&priv->mutex);
-
-	if (!priv->beacon_skb)
-		return 0;
-
-	if (priv->beacon_skb->len > left)
-		return 0;
-
-	memcpy(hdr, priv->beacon_skb->data, priv->beacon_skb->len);
-
-	return priv->beacon_skb->len;
-}
-
 /* Parse the beacon frame to find the TIM element and set tim_idx & tim_size */
 static void iwl_set_beacon_tim(struct iwl_priv *priv,
 			       struct iwl_tx_beacon_cmd *tx_beacon_cmd,
@@ -193,13 +129,18 @@ static void iwl_set_beacon_tim(struct iwl_priv *priv,
 		IWL_WARN(priv, "Unable to find TIM Element in beacon\n");
 }
 
-static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
-				       struct iwl_frame *frame)
+int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 {
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_TX_BEACON,
+		.flags = CMD_SIZE_HUGE,
+	};
 	u32 frame_size;
 	u32 rate_flags;
 	u32 rate;
+	int err;
+
 	/*
 	 * We have to set up the TX command, the TX Beacon command, and the
 	 * beacon contents.
@@ -212,17 +153,19 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 		return 0;
 	}
 
-	/* Initialize memory */
-	tx_beacon_cmd = &frame->u.beacon;
-	memset(tx_beacon_cmd, 0, sizeof(*tx_beacon_cmd));
+	if (WARN_ON(!priv->beacon_skb))
+		return -EINVAL;
+
+	/* Allocate beacon memory */
+	tx_beacon_cmd = kzalloc(sizeof(*tx_beacon_cmd) + priv->beacon_skb->len,
+				GFP_KERNEL);
+	if (!tx_beacon_cmd)
+		return -ENOMEM;
+
+	frame_size = priv->beacon_skb->len;
 
 	/* Set up TX beacon contents */
-	frame_size = iwl_fill_beacon_frame(priv, tx_beacon_cmd->frame,
-				sizeof(frame->u) - sizeof(*tx_beacon_cmd));
-	if (WARN_ON_ONCE(frame_size > MAX_MPDU_SIZE))
-		return 0;
-	if (!frame_size)
-		return 0;
+	memcpy(tx_beacon_cmd->frame, priv->beacon_skb->data, frame_size);
 
 	/* Set up TX command fields */
 	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
@@ -245,41 +188,16 @@ static unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 	tx_beacon_cmd->tx.rate_n_flags = iwl_hw_set_rate_n_flags(rate,
 			rate_flags);
 
-	return sizeof(*tx_beacon_cmd) + frame_size;
-}
+	/* Submit command */
+	cmd.len = sizeof(*tx_beacon_cmd) + frame_size;
+	cmd.data = tx_beacon_cmd;
 
-int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
-{
-	struct iwl_frame *frame;
-	unsigned int frame_size;
-	int rc;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_TX_BEACON,
-		.flags = CMD_SIZE_HUGE,
-	};
-
-	frame = iwl_get_free_frame(priv);
-	if (!frame) {
-		IWL_ERR(priv, "Could not obtain free frame buffer for beacon "
-			  "command.\n");
-		return -ENOMEM;
-	}
-
-	frame_size = iwl_hw_get_beacon_cmd(priv, frame);
-	if (!frame_size) {
-		IWL_ERR(priv, "Error configuring the beacon command\n");
-		iwl_free_frame(priv, frame);
-		return -EINVAL;
-	}
-
-	cmd.len = frame_size;
-	cmd.data = &frame->u.cmd[0];
-
-	rc = iwl_send_cmd_sync(priv, &cmd);
+	err = iwl_send_cmd_sync(priv, &cmd);
 
-	iwl_free_frame(priv, frame);
+	/* Free temporary storage */
+	kfree(tx_beacon_cmd);
 
-	return rc;
+	return err;
 }
 
 static inline dma_addr_t iwl_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
@@ -2356,9 +2274,6 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	dev_kfree_skb(priv->beacon_skb);
 	priv->beacon_skb = NULL;
-
-	/* clear out any free frames */
-	iwl_clear_free_frames(priv);
 }
 
 static void iwl_down(struct iwl_priv *priv)
@@ -3416,8 +3331,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	spin_lock_init(&priv->sta_lock);
 	spin_lock_init(&priv->hcmd_lock);
 
-	INIT_LIST_HEAD(&priv->free_frames);
-
 	mutex_init(&priv->mutex);
 
 	priv->ieee_channels = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 3d28ad2..2fd752a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -238,15 +238,6 @@ struct iwl_channel_info {
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
 #define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
 
-struct iwl_frame {
-	union {
-		struct ieee80211_hdr frame;
-		struct iwl_tx_beacon_cmd beacon;
-		u8 raw[IEEE80211_FRAME_LEN];
-		u8 cmd[360];
-	} u;
-	struct list_head list;
-};
 
 #define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
 #define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
@@ -1188,10 +1179,6 @@ struct iwl_priv {
 	struct ieee80211_rate *ieee_rates;
 	struct iwl_cfg *cfg;
 
-	/* temporary frame storage list */
-	struct list_head free_frames;
-	int frames_count;
-
 	enum ieee80211_band band;
 
 	void (*pre_rx_handler)(struct iwl_priv *priv,
-- 
1.7.0.4

