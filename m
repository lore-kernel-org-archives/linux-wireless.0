Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbYLSCpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:12 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/43] iwl3945: Getting rid of iwl-3945-led.h
Date: Fri, 19 Dec 2008 10:37:13 +0800
Message-Id: <1229654263-21454-14-git-send-email-yi.zhu@intel.com> (sfid-20081219_034536_797729_9D960AEE)
In-Reply-To: <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

The duplicated LED definitions prevent one from including iwl-dev.h from the
3945 specific C files.
Moreover, we are sharing many definitions between iwl-3945-led.h and
iwl-led.h, so let's just use the iwl one. Note that this file will get more
cleanups once we share a common iwl_priv structure.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Acked-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |   16 +---------------
 drivers/net/wireless/iwlwifi/iwl-led.h      |    4 +++-
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index 749ac03..b697c89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -30,22 +30,8 @@
 struct iwl3945_priv;
 
 #ifdef CONFIG_IWL3945_LEDS
-#define IWL_LED_SOLID 11
-#define IWL_LED_NAME_LEN 31
-#define IWL_DEF_LED_INTRVL __constant_cpu_to_le32(1000)
 
-#define IWL_LED_ACTIVITY       (0<<1)
-#define IWL_LED_LINK           (1<<1)
-
-enum led_type {
-	IWL_LED_TRG_TX,
-	IWL_LED_TRG_RX,
-	IWL_LED_TRG_ASSOC,
-	IWL_LED_TRG_RADIO,
-	IWL_LED_TRG_MAX,
-};
-
-#include <linux/leds.h>
+#include "iwl-led.h"
 
 struct iwl3945_led {
 	struct iwl3945_priv *priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 021e00b..0b50b90 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -30,7 +30,7 @@
 
 struct iwl_priv;
 
-#ifdef CONFIG_IWLWIFI_LEDS
+#if defined(CONFIG_IWLWIFI_LEDS) || defined(CONFIG_IWL3945_LEDS)
 #include <linux/leds.h>
 
 #define IWL_LED_SOLID 11
@@ -47,7 +47,9 @@ enum led_type {
 	IWL_LED_TRG_RADIO,
 	IWL_LED_TRG_MAX,
 };
+#endif
 
+#ifdef CONFIG_IWLWIFI_LEDS
 
 struct iwl_led {
 	struct iwl_priv *priv;
-- 
1.5.3.6

