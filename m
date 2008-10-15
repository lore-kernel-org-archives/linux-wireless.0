Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38472 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYJOSPn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 14:15:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlwifi: don't update TFD free counter for invalid station
Date: Wed, 15 Oct 2008 11:06:24 -0700
Message-Id: <1224093984-20779-2-git-send-email-reinette.chatre@intel.com> (sfid-20081015_201548_796806_A0958CAE)
In-Reply-To: <1224093984-20779-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224093984-20779-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch makes sure that station table is not accessed
with invalid station id in 4965 TX response path

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 7cf5e2c..b2d8647 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2236,7 +2236,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 				   tx_resp->failure_frame);
 
 		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
-		if (qc)
+		if (qc && likely(sta_id != IWL_INVALID_STATION))
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 
 		if (priv->mac80211_registered &&
@@ -2244,7 +2244,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			ieee80211_wake_queue(priv->hw, txq_id);
 	}
 
-	if (qc)
+	if (qc && likely(sta_id != IWL_INVALID_STATION))
 		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
-- 
1.5.4.3

