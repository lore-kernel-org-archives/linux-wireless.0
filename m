Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59787 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab2AaTqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 14:46:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: wey-yi.w.guy@intel.com, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: make "Tx aggregation enabled on ra =" be at DEBUG level
Date: Tue, 31 Jan 2012 14:40:49 -0500
Message-Id: <1328038849-12620-1-git-send-email-linville@tuxdriver.com> (sfid-20120131_204634_024154_77FFFF72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Average users either don't care or they think that message indicates a
problem...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a8c6880..20d418c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -620,7 +620,7 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	sta_priv->lq_sta.lq.agg_params.agg_frame_cnt_limit =
 		sta_priv->max_agg_bufsize;
 
-	IWL_INFO(priv, "Tx aggregation enabled on ra = %pM tid = %d\n",
+	IWL_DEBUG(priv, "Tx aggregation enabled on ra = %pM tid = %d\n",
 		 sta->addr, tid);
 
 	return iwl_send_lq_cmd(priv, ctx,
-- 
1.7.4.4

