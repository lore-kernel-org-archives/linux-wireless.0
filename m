Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45869 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab1IVXBU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 19:01:20 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/12] iwlagn: make iwl_scan_cancel_timeout void
Date: Thu, 22 Sep 2011 15:14:57 -0700
Message-Id: <1316729700-1770-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110923_010133_111283_ABF4F834)
In-Reply-To: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316729700-1770-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The return value of iwl_scan_cancel_timeout()
isn't used anywhere, so let's just remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8ed72e8..e55ffad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -318,7 +318,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
  ******************************************************************************/
 void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
-int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
+void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 void iwl_force_scan_end(struct iwl_priv *priv);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		    struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 74204ec..d9596ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -169,7 +169,7 @@ int iwl_scan_cancel(struct iwl_priv *priv)
  * @ms: amount of time to wait (in milliseconds) for scan to abort
  *
  */
-int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
+void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 {
 	unsigned long timeout = jiffies + msecs_to_jiffies(ms);
 
@@ -184,8 +184,6 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 			break;
 		msleep(20);
 	}
-
-	return test_bit(STATUS_SCAN_HW, &priv->shrd->status);
 }
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
-- 
1.7.0.4

