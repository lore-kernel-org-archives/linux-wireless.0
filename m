Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15924 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbYEECYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:25 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 17/25] iwlwifi: compile iwl-sta into iwlcore
Date: Mon,  5 May 2008 10:22:44 +0800
Message-Id: <1209954172-3092-18-git-send-email-yi.zhu@intel.com> (sfid-20080505_044416_565514_B9984194)
In-Reply-To: <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves iwl-sta into iwl-core.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.c |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index ab372fc..04da0d2 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_IWLCORE)	+= iwlcore.o
 iwlcore-objs 		= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
-iwlcore-objs 		+= iwl-rx.o iwl-tx.o
+iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
@@ -11,7 +11,7 @@ iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
 iwl3945-$(CONFIG_IWL3945_LEDS) += iwl-3945-led.o
 
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
-iwl4965-objs		:= iwl4965-base.o iwl-4965.o iwl-4965-rs.o iwl-sta.o
+iwl4965-objs		:= iwl4965-base.o iwl-4965.o iwl-4965-rs.o
 
 ifeq ($(CONFIG_IWL5000),y)
 	iwl4965-objs += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 34f5424..f226704 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -170,6 +170,7 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 	else
 		return 0;
 }
+EXPORT_SYMBOL(iwl_send_static_wepkey_cmd);
 
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
 			       struct ieee80211_key_conf *keyconf)
@@ -190,6 +191,7 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 
 	return ret;
 }
+EXPORT_SYMBOL(iwl_remove_default_wep_key);
 
 int iwl_set_default_wep_key(struct iwl_priv *priv,
 			    struct ieee80211_key_conf *keyconf)
@@ -217,6 +219,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 
 	return ret;
 }
+EXPORT_SYMBOL(iwl_set_default_wep_key);
 
 static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 				struct ieee80211_key_conf *keyconf,
@@ -391,6 +394,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(iwl_remove_dynamic_key);
 
 int iwl_set_dynamic_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key, u8 sta_id)
@@ -416,6 +420,7 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 
 	return ret;
 }
+EXPORT_SYMBOL(iwl_set_dynamic_key);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 static void iwl_dump_lq_cmd(struct iwl_priv *priv,
-- 
1.5.3.6

