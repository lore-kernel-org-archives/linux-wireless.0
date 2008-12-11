Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19329 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765AbYLKScp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:32:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/6] iwlwifi: remove includes of iwl-helpers.h where not needed
Date: Thu, 11 Dec 2008 10:33:39 -0800
Message-Id: <1229020421-4823-5-git-send-email-reinette.chatre@intel.com> (sfid-20081211_193251_860602_BECEFAC2)
In-Reply-To: <1229020421-4823-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1229020421-4823-1-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-2-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-3-git-send-email-reinette.chatre@intel.com>
 <1229020421-4823-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes includes of iwl-helpers.h where not needed

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    2 --
 drivers/net/wireless/iwlwifi/iwl-led.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-power.c   |    1 -
 drivers/net/wireless/iwlwifi/iwl-rfkill.c  |    2 --
 drivers/net/wireless/iwlwifi/iwl-sta.c     |    2 --
 7 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 1fdf5f4..025fb78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -38,7 +38,6 @@
 #include "iwl-dev.h"
 #include "iwl-sta.h"
 #include "iwl-core.h"
-#include "iwl-helpers.h"
 
 #define RS_NAME "iwl-agn-rs"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a520e47..664a983 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -498,6 +498,10 @@ struct iwl_sensitivity_ranges {
 
 #define IWL_FAT_CHANNEL_52 BIT(IEEE80211_BAND_5GHZ)
 
+#define KELVIN_TO_CELSIUS(x) ((x)-273)
+#define CELSIUS_TO_KELVIN(x) ((x)+273)
+
+
 /**
  * struct iwl_hw_params
  * @max_txq_num: Max # Tx queues supported
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index d4d2829..ca4f638 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -32,8 +32,6 @@
 
 #include <linux/ctype.h>
 
-#define KELVIN_TO_CELSIUS(x) ((x)-273)
-#define CELSIUS_TO_KELVIN(x) ((x)+273)
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index e8ce188..dce32ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -41,7 +41,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-helpers.h"
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 static const char *led_type_str[] = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index be8eb95..75ca6a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -39,7 +39,6 @@
 #include "iwl-commands.h"
 #include "iwl-debug.h"
 #include "iwl-power.h"
-#include "iwl-helpers.h"
 
 /*
  * Setting power level allow the card to go to sleep when not busy
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 7894f2d..4b69da3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -34,8 +34,6 @@
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
-#include "iwl-helpers.h"
-
 
 /* software rf-kill from user */
 static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 06e1808..91a1376 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -33,8 +33,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-sta.h"
-#include "iwl-helpers.h"
-
 
 #define IWL_STA_DRIVER_ACTIVE BIT(0) /* driver entry is active */
 #define IWL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
-- 
1.5.4.3

