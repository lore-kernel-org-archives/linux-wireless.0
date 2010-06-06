Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427Ab0FFG4n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jun 2010 02:56:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/23] iwlwifi: beacon internal time unit
Date: Sat,  5 Jun 2010 23:56:26 -0700
Message-Id: <1275807398-18184-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
References: <1275807398-18184-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

use TIME_UNIT define for beacon internal calculation

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 718ffa3..56bcf0e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -506,11 +506,11 @@ void iwl_setup_rxon_timing(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	}
 
 	beacon_int = iwl_adjust_beacon_interval(beacon_int,
-				priv->hw_params.max_beacon_itrvl * 1024);
+				priv->hw_params.max_beacon_itrvl * TIME_UNIT);
 	priv->rxon_timing.beacon_interval = cpu_to_le16(beacon_int);
 
 	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
-	interval_tm = beacon_int * 1024;
+	interval_tm = beacon_int * TIME_UNIT;
 	rem = do_div(tsf, interval_tm);
 	priv->rxon_timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
 
-- 
1.7.0.4

