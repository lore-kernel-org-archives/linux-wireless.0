Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1E0QIC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:08:02 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/10] iwlagn: change the logging level for aggregation enable check
Date: Fri, 27 May 2011 08:40:31 -0700
Message-Id: <1306510833-32049-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180819_419189_30F1E1F7)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aggregation will not enable if the traffic is lower than the threshold,
this is not an error condition, so change the logging level.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 592b0cf..85e0828 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -426,7 +426,7 @@ static int rs_tl_turn_on_agg_for_tid(struct iwl_priv *priv,
 			ieee80211_stop_tx_ba_session(sta, tid);
 		}
 	} else {
-		IWL_ERR(priv, "Aggregation not enabled for tid %d "
+		IWL_DEBUG_HT(priv, "Aggregation not enabled for tid %d "
 			"because load = %u\n", tid, load);
 	}
 	return ret;
-- 
1.7.0.4

