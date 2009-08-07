Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24343 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZHGWl7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/16] iwlwifi: disable powersave mode
Date: Fri,  7 Aug 2009 15:41:52 -0700
Message-Id: <1249684912-22936-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

The enabling of powersaving had a big impact on reliability and
performance. Throughput on n band suffered especially. With power save
support enabled we see significant ping response times, dropped frames, and
reduced throughput. These are captured in the following bug reports:

http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2051
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2053

Disable power save by default, add "iwl_support_ps" module parameter
that can be used to enable it again.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c  |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-power.c |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-power.h |    2 +-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index af73512..90b25b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1567,9 +1567,10 @@ int iwl_setup_mac(struct iwl_priv *priv)
 	hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		    IEEE80211_HW_NOISE_DBM |
 		    IEEE80211_HW_AMPDU_AGGREGATION |
-		    IEEE80211_HW_SPECTRUM_MGMT |
-		    IEEE80211_HW_SUPPORTS_PS |
-		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+		    IEEE80211_HW_SPECTRUM_MGMT;
+	if (iwl_support_ps)
+		hw->flags |= IEEE80211_HW_SUPPORTS_PS |
+			     IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 0b16841..5a7d821 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -1,3 +1,4 @@
+
 /******************************************************************************
  *
  * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
@@ -50,6 +51,13 @@
  */
 
 /*
+ * For now, disable power save function
+ */
+bool iwl_support_ps;
+module_param(iwl_support_ps, bool, S_IRUGO);
+MODULE_PARM_DESC(iwl_support_ps,
+		 "power save support (deprecated) (default disabled)");
+/*
  * For now, keep using power level 1 instead of automatically
  * adjusting ...
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index df6f6a4..fb3ce90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -139,5 +139,5 @@ void iwl_tt_exit(struct iwl_priv *priv);
 void iwl_power_initialize(struct iwl_priv *priv);
 
 extern bool no_sleep_autoadjust;
-
+extern bool iwl_support_ps;
 #endif  /* __iwl_power_setting_h__ */
-- 
1.5.6.3

