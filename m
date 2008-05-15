Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14443 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbYEOF4V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:21 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 06/26] iwlwifi: rename iwl4965_tx_info to iwl_tx_info
Date: Thu, 15 May 2008 13:53:58 +0800
Message-Id: <1210830858-3410-7-git-send-email-yi.zhu@intel.com> (sfid-20080515_075625_975123_72359773)
In-Reply-To: <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames iwl4965_tx_info to iwl_tx_info.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cf99224..ae18a80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -118,7 +118,7 @@ struct iwl_queue {
 #define MAX_NUM_OF_TBS          (20)
 
 /* One for each TFD */
-struct iwl4965_tx_info {
+struct iwl_tx_info {
 	struct ieee80211_tx_status status;
 	struct sk_buff *skb[MAX_NUM_OF_TBS];
 };
@@ -141,7 +141,7 @@ struct iwl_tx_queue {
 	struct iwl_tfd_frame *bd;
 	struct iwl_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
-	struct iwl4965_tx_info *txb;
+	struct iwl_tx_info *txb;
 	int need_update;
 	int sched_retry;
 	int active;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2e7e616..6e70405 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1868,7 +1868,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	idx = get_cmd_index(q, q->write_ptr, 0);
 
 	/* Set up driver data for this TFD */
-	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl4965_tx_info));
+	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
 	txq->txb[q->write_ptr].skb[0] = skb;
 	memcpy(&(txq->txb[q->write_ptr].status.control),
 	       ctl, sizeof(struct ieee80211_tx_control));
@@ -2306,7 +2306,7 @@ static int iwl4965_get_measurement(struct iwl_priv *priv,
 #endif
 
 static void iwl4965_txstatus_to_ieee(struct iwl_priv *priv,
-				 struct iwl4965_tx_info *tx_sta)
+				     struct iwl_tx_info *tx_sta)
 {
 
 	tx_sta->status.ack_signal = 0;
-- 
1.5.3.6

