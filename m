Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53495 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbYDOEQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/12] iwlwifi: make Makefile more concise
Date: Mon, 14 Apr 2008 21:16:12 -0700
Message-Id: <1208232974-3828-11-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051627_573311_5E01E804)
In-Reply-To: <1208232974-3828-10-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-8-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-9-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also change CONFIG_IWLCORE_RFKILL to CONFIG_IWLWIFI_RFKILL to
be more consistent with other config variables.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig      |    2 +-
 drivers/net/wireless/iwlwifi/Makefile     |   29 ++++++++---------------------
 drivers/net/wireless/iwlwifi/iwl-4965.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.h |    2 +-
 4 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index bcaa61b..f844b73 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -6,7 +6,7 @@ config IWLWIFI_LEDS
 	bool
 	default n
 
-config IWLCORE_RFKILL
+config IWLWIFI_RFKILL
 	boolean "IWLWIFI RF kill support"
 	depends on IWLCORE
 	select RFKILL
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 741ea34..4f3e88b 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,26 +1,13 @@
-obj-$(CONFIG_IWLCORE)	+= iwlcore.o
-iwlcore-objs 		= iwl-core.o iwl-eeprom.o iwl-hcmd.o
-
-ifeq ($(CONFIG_IWLWIFI_DEBUGFS),y)
-	iwlcore-objs += iwl-debugfs.o
-endif
-
-ifeq ($(CONFIG_IWLWIFI_LEDS),y)
-	iwlcore-objs += iwl-led.o
-endif
-
-ifeq ($(CONFIG_IWLCORE_RFKILL),y)
-	iwlcore-objs += iwl-rfkill.o
-endif
+obj-$(CONFIG_IWLCORE)	:= iwlcore.o
+iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o
+iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
+iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
+iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
-iwl3945-objs		= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
-
-ifeq ($(CONFIG_IWL3945_LEDS),y)
-	iwl3945-objs += iwl-3945-led.o
-endif
-
+iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
+iwl3945-$(CONFIG_IWL3945_LEDS) += iwl-3945-led.o
 
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
-iwl4965-objs		= iwl4965-base.o iwl-4965.o iwl-4965-rs.o iwl-sta.o
+iwl4965-objs		:= iwl4965-base.o iwl-4965.o iwl-4965-rs.o iwl-sta.o
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index daf157a..17c4bcf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -1034,7 +1034,7 @@ struct iwl_priv {
 	 * 4965's initialize alive response contains some calibration data. */
 	struct iwl4965_init_alive_resp card_alive_init;
 	struct iwl4965_alive_resp card_alive;
-#ifdef CONFIG_IWLCORE_RFKILL
+#ifdef CONFIG_IWLWIFI_RFKILL
 	struct iwl_rfkill_mngr rfkill_mngr;
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.h b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
index e7aa51a..a7f04b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.h
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
@@ -34,7 +34,7 @@ struct iwl_priv;
 #include <linux/input.h>
 
 
-#ifdef CONFIG_IWLCORE_RFKILL
+#ifdef CONFIG_IWLWIFI_RFKILL
 struct iwl_rfkill_mngr {
 	struct rfkill *rfkill;
 	struct input_dev *input_dev;
-- 
1.5.3.4

