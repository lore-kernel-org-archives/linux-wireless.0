Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33530 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932071AbcGFKpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:45:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:33 +0300
Message-Id: <1467801651-1816-38-git-send-email-luca@coelho.fi> (sfid-20160706_124525_233099_065E2595)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 38/56] iwlwifi: remove iwl_ht_params.smps_mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This struct member is never set, so remove it.

Since this is the last thing that needs mac80211.h, also change
the includes to no longer use mac80211.h

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c   | 5 -----
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 6 +++---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c b/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
index b228552..087e579 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rxon.c
@@ -523,11 +523,6 @@ static int iwlagn_rxon_connect(struct iwl_priv *priv,
 		return ret;
 	}
 
-	if (ctx->vif && ctx->vif->type == NL80211_IFTYPE_STATION &&
-	    priv->cfg->ht_params && priv->cfg->ht_params->smps_mode)
-		ieee80211_request_smps(ctx->vif,
-				       priv->cfg->ht_params->smps_mode);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 122e895..64108cc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -66,8 +66,9 @@
 #define __IWL_CONFIG_H__
 
 #include <linux/types.h>
-#include <net/mac80211.h>
-
+#include <linux/netdevice.h>
+#include <linux/ieee80211.h>
+#include <linux/nl80211.h>
 
 enum iwl_device_family {
 	IWL_DEVICE_FAMILY_UNDEFINED,
@@ -192,7 +193,6 @@ struct iwl_base_params {
  * @ht40_bands: bitmap of bands (using %NL80211_BAND_*) that support HT40
  */
 struct iwl_ht_params {
-	enum ieee80211_smps_mode smps_mode;
 	u8 ht_greenfield_support:1,
 	   stbc:1,
 	   ldpc:1,
-- 
2.8.1

