Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:65350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab0EJW2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:25 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/47] iwl3945: use iwl3945_add_bcast_station
Date: Mon, 10 May 2010 15:27:45 -0700
Message-Id: <1273530498-11876-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwl3945 should not use iwl_add_local_station(..., false)
because that would leave the IWL_STA_UCODE_INPROGRESS flag
set for the station, which is not desirable. Instead it
can use iwl3945_add_bcast_station() here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 04cedef..4f20cca 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3293,7 +3293,7 @@ void iwl3945_config_ap(struct iwl_priv *priv)
 		/* restore RXON assoc */
 		priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 		iwlcore_commit_rxon(priv);
-		iwl_add_local_station(priv, iwl_bcast_addr, false);
+		iwl3945_add_bcast_station(priv);
 	}
 	iwl3945_send_beacon_cmd(priv);
 
-- 
1.6.3.3

