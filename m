Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27309 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbYJ2VF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 17:05:26 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/7] iwlwifi: trivial removal of some 4965 remaining from iwl-agn-rs.h
Date: Wed, 29 Oct 2008 14:05:44 -0700
Message-Id: <1225314349-11139-3-git-send-email-reinette.chatre@intel.com> (sfid-20081029_220535_209851_35DF515C)
In-Reply-To: <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch removes 4965 prefix from comments and one function
in iwl-agn-rs.h

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-sta.c    |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index ccfafcf..adcbf53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -294,7 +294,7 @@ static inline u8 first_antenna(u8 mask)
 }
 
 
-static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
+static inline u8 iwl_get_prev_ieee_rate(u8 rate_index)
 {
 	u8 rate = iwl_rates[rate_index].prev_ieee;
 
@@ -304,11 +304,11 @@ static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 }
 
 /**
- * iwl4965_rate_control_register - Register the rate control algorithm callbacks
+ * iwl_rate_control_register - Register the rate control algorithm callbacks
  *
  * Since the rate control algorithm is hardware specific, there is no need
  * or reason to place it as a stand alone module.  The driver can call
- * iwl4965_rate_control_register in order to register the rate control callbacks
+ * iwl_rate_control_register in order to register the rate control callbacks
  * with the mac80211 subsystem.  This should be performed prior to calling
  * ieee80211_register_hw
  *
@@ -316,7 +316,7 @@ static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 extern int iwlagn_rate_control_register(void);
 
 /**
- * iwl4965_rate_control_unregister - Unregister the rate control callbacks
+ * iwl_rate_control_unregister - Unregister the rate control callbacks
  *
  * This should be called after calling ieee80211_unregister_hw, but before
  * the driver is unloaded.
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 88928ef..bc7d5c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -877,7 +877,7 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, int is_ap)
 
 		link_cmd.rs_table[i].rate_n_flags =
 			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
-		r = iwl4965_get_prev_ieee_rate(r);
+		r = iwl_get_prev_ieee_rate(r);
 	}
 
 	link_cmd.general_params.single_stream_ant_msk =
-- 
1.5.4.3

