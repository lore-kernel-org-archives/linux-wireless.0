Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab0KPQGm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:06:42 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/18] iwlagn: remove a bogus AGG_OFF check
Date: Tue, 16 Nov 2010 08:01:41 -0800
Message-Id: <1289923311-14920-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1289923311-14920-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even if this check were to happen, using the
txq_id here (which is a HW queue) would lead
to confusion in mac80211. Luckily, it doesn't
seem like this can ever happen.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    8 ++------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 19da3e5..1940079 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2238,12 +2238,8 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
-			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)) {
-				if (agg->state == IWL_AGG_OFF)
-					iwl_wake_queue(priv, txq_id);
-				else
-					iwl_wake_queue(priv, txq->swq_id);
-			}
+			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
+				iwl_wake_queue(priv, txq->swq_id);
 		}
 	} else {
 		info->status.rates[0].count = tx_resp->failure_frame + 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c6f65fd..2ba83b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -445,12 +445,8 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 
 			if (priv->mac80211_registered &&
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
-			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)) {
-				if (agg->state == IWL_AGG_OFF)
-					iwl_wake_queue(priv, txq_id);
-				else
-					iwl_wake_queue(priv, txq->swq_id);
-			}
+			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
+				iwl_wake_queue(priv, txq->swq_id);
 		}
 	} else {
 		BUG_ON(txq_id != txq->swq_id);
-- 
1.7.0.4

