Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17633 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761398AbZJIUXC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:23:02 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/17] iwlwifi/iwl3945: remove data_retry_limit
Date: Fri,  9 Oct 2009 13:20:32 -0700
Message-Id: <1255119634-3060-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Remove the ununsed variable data_retry_limit
from priv.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    3 ---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    4 +---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 5 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index a6944bc..eb874e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -806,9 +806,6 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	} else
 		data_retry_limit = IWL_DEFAULT_TX_RETRY;
 
-	if (priv->data_retry_limit != -1)
-		data_retry_limit = priv->data_retry_limit;
-
 	if (ieee80211_is_mgmt(fc)) {
 		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
 		case cpu_to_le16(IEEE80211_STYPE_AUTH):
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 1e0021f..2ae168a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1524,7 +1524,6 @@ int iwl_init_drv(struct iwl_priv *priv)
 	/* Clear the driver's (not device's) station table */
 	iwl_clear_stations_table(priv);
 
-	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8d087f0..451aa65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1092,7 +1092,6 @@ struct iwl_priv {
 	u8 last_phy_res[100];
 
 	/* Rate scaling data */
-	s8 data_retry_limit;
 	u8 retry_rate;
 
 	wait_queue_head_t wait_command_queue;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 625da63..d0bd7cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -591,9 +591,7 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 	u8 rate_plcp;
 
 	/* Set retry limit on DATA packets and Probe Responses*/
-	if (priv->data_retry_limit != -1)
-		data_retry_limit = priv->data_retry_limit;
-	else if (ieee80211_is_probe_resp(fc))
+	if (ieee80211_is_probe_resp(fc))
 		data_retry_limit = 3;
 	else
 		data_retry_limit = IWL_DEFAULT_TX_RETRY;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 03612b3..515f29b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3797,7 +3797,6 @@ static int iwl3945_init_drv(struct iwl_priv *priv)
 	/* Clear the driver's (not device's) station table */
 	iwl_clear_stations_table(priv);
 
-	priv->data_retry_limit = -1;
 	priv->ieee_channels = NULL;
 	priv->ieee_rates = NULL;
 	priv->band = IEEE80211_BAND_2GHZ;
-- 
1.5.6.3

