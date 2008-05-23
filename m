Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758645AbYEWCLM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:11:12 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: remove 4965 prefix from iwl4965_frame
Date: Fri, 23 May 2008 10:08:47 +0800
Message-Id: <1211508569-3163-10-git-send-email-yi.zhu@intel.com> (sfid-20080523_041122_083135_B88ACFD3)
In-Reply-To: <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes 4965 from iwl4965_frame struct and handling functions.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   20 ++++++++++----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 83876a0..922b0a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2016,7 +2016,7 @@ int iwl4965_hw_get_temperature(struct iwl_priv *priv)
 }
 
 unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
-			  struct iwl4965_frame *frame, u8 rate)
+			  struct iwl_frame *frame, u8 rate)
 {
 	struct iwl4965_tx_beacon_cmd *tx_beacon_cmd;
 	unsigned int frame_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9a842fd..60a8f06 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -262,7 +262,7 @@ enum iwl_pwr_src {
 #define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
 #define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
 
-struct iwl4965_frame {
+struct iwl_frame {
 	union {
 		struct ieee80211_hdr frame;
 		struct iwl4965_tx_beacon_cmd beacon;
@@ -696,7 +696,7 @@ extern int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
-				 struct iwl4965_frame *frame, u8 rate);
+				 struct iwl_frame *frame, u8 rate);
 extern void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 				     struct iwl_cmd *cmd,
 				     struct ieee80211_tx_control *ctrl,
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0ad9558..1c45b6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -800,7 +800,7 @@ static int iwl4965_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_fla
 	return iwl_send_cmd(priv, &cmd);
 }
 
-static void iwl4965_clear_free_frames(struct iwl_priv *priv)
+static void iwl_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
 
@@ -810,7 +810,7 @@ static void iwl4965_clear_free_frames(struct iwl_priv *priv)
 	while (!list_empty(&priv->free_frames)) {
 		element = priv->free_frames.next;
 		list_del(element);
-		kfree(list_entry(element, struct iwl4965_frame, list));
+		kfree(list_entry(element, struct iwl_frame, list));
 		priv->frames_count--;
 	}
 
@@ -821,9 +821,9 @@ static void iwl4965_clear_free_frames(struct iwl_priv *priv)
 	}
 }
 
-static struct iwl4965_frame *iwl4965_get_free_frame(struct iwl_priv *priv)
+static struct iwl_frame *iwl_get_free_frame(struct iwl_priv *priv)
 {
-	struct iwl4965_frame *frame;
+	struct iwl_frame *frame;
 	struct list_head *element;
 	if (list_empty(&priv->free_frames)) {
 		frame = kzalloc(sizeof(*frame), GFP_KERNEL);
@@ -838,10 +838,10 @@ static struct iwl4965_frame *iwl4965_get_free_frame(struct iwl_priv *priv)
 
 	element = priv->free_frames.next;
 	list_del(element);
-	return list_entry(element, struct iwl4965_frame, list);
+	return list_entry(element, struct iwl_frame, list);
 }
 
-static void iwl4965_free_frame(struct iwl_priv *priv, struct iwl4965_frame *frame)
+static void iwl_free_frame(struct iwl_priv *priv, struct iwl_frame *frame)
 {
 	memset(frame, 0, sizeof(*frame));
 	list_add(&frame->list, &priv->free_frames);
@@ -892,12 +892,12 @@ static u8 iwl4965_rate_get_lowest_plcp(struct iwl_priv *priv)
 
 static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
 {
-	struct iwl4965_frame *frame;
+	struct iwl_frame *frame;
 	unsigned int frame_size;
 	int rc;
 	u8 rate;
 
-	frame = iwl4965_get_free_frame(priv);
+	frame = iwl_get_free_frame(priv);
 
 	if (!frame) {
 		IWL_ERROR("Could not obtain free frame buffer for beacon "
@@ -912,7 +912,7 @@ static int iwl4965_send_beacon_cmd(struct iwl_priv *priv)
 	rc = iwl_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
 			      &frame->u.cmd[0]);
 
-	iwl4965_free_frame(priv, frame);
+	iwl_free_frame(priv, frame);
 
 	return rc;
 }
@@ -4355,7 +4355,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 	priv->ibss_beacon = NULL;
 
 	/* clear out any free frames */
-	iwl4965_clear_free_frames(priv);
+	iwl_clear_free_frames(priv);
 }
 
 static void iwl4965_down(struct iwl_priv *priv)
-- 
1.5.3.6

