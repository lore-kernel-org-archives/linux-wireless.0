Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64646 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYKSXb5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 18:31:57 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/7] iwl3945 : Fix ad-hoc mode for 3945
Date: Wed, 19 Nov 2008 15:32:22 -0800
Message-Id: <1227137548-28718-2-git-send-email-reinette.chatre@intel.com> (sfid-20081120_003217_713520_24B89596)
In-Reply-To: <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch fixes the ad-hoc mode by
1) Removing redundant clear_stations_table which prevented generation of
beacons.
2) Setting assoc_id to 1. It was never set so preventing tx flow
in iwl3945_tx_skb.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c465bb4..104a0b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6333,10 +6333,7 @@ static void iwl3945_post_associate(struct iwl3945_priv *priv)
 
 	case NL80211_IFTYPE_ADHOC:
 
-		/* clear out the station table */
-		iwl3945_clear_stations_table(priv);
-
-		iwl3945_add_station(priv, iwl3945_broadcast_addr, 0, 0);
+		priv->assoc_id = 1;
 		iwl3945_add_station(priv, priv->bssid, 0, 0);
 		iwl3945_sync_sta(priv, IWL_STA_ID,
 				 (priv->band == IEEE80211_BAND_5GHZ) ?
-- 
1.5.4.3

