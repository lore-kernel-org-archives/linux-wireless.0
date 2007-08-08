Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758958AbXHHHhZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:25 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/28] iwlwifi: replace unnecessary GFP_ATOMIC with GFP_KERNEL
Date: Wed,  8 Aug 2007 15:33:26 +0800
Message-Id: <11865584473732-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584452614-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 8f55f0d..ca4edd2 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -222,7 +222,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 
 	if (id != IWL_CMD_QUEUE_NUM) {
 		txq->txb = kmalloc(sizeof(txq->txb[0]) *
-				   TFD_QUEUE_SIZE_MAX, GFP_ATOMIC);
+				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
 		if (!txq->txb) {
 			IWL_ERROR("kmalloc for auxilary BD "
 				  "structures failed\n");
@@ -1460,7 +1460,7 @@ static struct iwl_frame *iwl_get_free_frame(struct iwl_priv *priv)
 	struct iwl_frame *frame;
 	struct list_head *element;
 	if (list_empty(&priv->free_frames)) {
-		frame = kzalloc(sizeof(*frame), GFP_ATOMIC);
+		frame = kzalloc(sizeof(*frame), GFP_KERNEL);
 		if (!frame) {
 			IWL_ERROR("Could not allocate frame!\n");
 			return NULL;
@@ -5706,19 +5706,19 @@ static int iwl_init_geos(struct iwl_priv *priv)
 	}
 
 	modes = kzalloc(sizeof(struct ieee80211_hw_mode) * mode_count,
-			GFP_ATOMIC);
+			GFP_KERNEL);
 	if (!modes)
 		return -ENOMEM;
 
 	channels = kzalloc(sizeof(struct ieee80211_channel) *
-			   priv->channel_count, GFP_ATOMIC);
+			   priv->channel_count, GFP_KERNEL);
 	if (!channels) {
 		kfree(modes);
 		return -ENOMEM;
 	}
 
 	rates = kzalloc((sizeof(struct ieee80211_rate) * (IWL_MAX_RATES + 1)),
-			GFP_ATOMIC);
+			GFP_KERNEL);
 	if (!rates) {
 		kfree(modes);
 		kfree(channels);
@@ -7014,7 +7014,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 	if (!priv->scan) {
 		priv->scan = kmalloc(sizeof(struct iwl_scan_cmd) +
-				     IWL_MAX_SCAN_SIZE, GFP_ATOMIC);
+				     IWL_MAX_SCAN_SIZE, GFP_KERNEL);
 		if (!priv->scan) {
 			rc = -ENOMEM;
 			goto done;
-- 
1.5.2
