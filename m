Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:6615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab0H0Q4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 22/27] iwlagn: send beacon before committing associated RXON
Date: Fri, 27 Aug 2010 09:59:50 -0700
Message-Id: <1282928395-32762-23-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer AGN microcode requires know the beacon
before starting the AP so that it can start
beaconing right away. Implement that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 79aff1f..8e07228 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3559,6 +3559,8 @@ void iwl_config_ap(struct iwl_priv *priv, struct ieee80211_vif *vif)
 				ctx->staging.flags &=
 					~RXON_FLG_SHORT_SLOT_MSK;
 		}
+		/* need to send beacon cmd before committing assoc RXON! */
+		iwl_send_beacon_cmd(priv);
 		/* restore RXON assoc */
 		ctx->staging.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv, ctx);
-- 
1.7.0.4

