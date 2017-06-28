Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36034 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752092AbdF1UPz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:28 +0300
Message-Id: <20170628201330.9432-30-luca@coelho.fi> (sfid-20170628_224510_518519_2F0A7989)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 29/31] iwlwifi: move notification wait into fw/
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the notification wait code into the new fw interaction directory.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile                             | 2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h                            | 2 +-
 .../net/wireless/intel/iwlwifi/{iwl-notif-wait.c => fw/notif-wait.c}    | 2 +-
 .../net/wireless/intel/iwlwifi/{iwl-notif-wait.h => fw/notif-wait.h}    | 0
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                            | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                            | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c                     | 2 +-
 7 files changed, 6 insertions(+), 6 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-notif-wait.c => fw/notif-wait.c} (99%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-notif-wait.h => fw/notif-wait.h} (100%)

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 411cb91c102f..7733fc41ce98 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -3,7 +3,6 @@ obj-$(CONFIG_IWLWIFI)	+= iwlwifi.o
 iwlwifi-objs		+= iwl-io.o
 iwlwifi-objs		+= iwl-drv.o
 iwlwifi-objs		+= iwl-debug.o
-iwlwifi-objs		+= iwl-notif-wait.o
 iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
 iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
@@ -11,6 +10,7 @@ iwlwifi-objs		+= pcie/ctxt-info.o pcie/trans-gen2.o pcie/tx-gen2.o
 iwlwifi-$(CONFIG_IWLDVM) += iwl-1000.o iwl-2000.o iwl-5000.o iwl-6000.o
 iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o iwl-8000.o iwl-9000.o iwl-a000.o
 iwlwifi-objs		+= iwl-trans.o
+iwlwifi-objs		+= fw/notif-wait.o
 
 iwlwifi-objs += $(iwlwifi-m)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
index 025db135b63c..cceb4cd8e501 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
@@ -44,7 +44,7 @@
 #include "iwl-debug.h"
 #include "iwl-agn-hw.h"
 #include "iwl-op-mode.h"
-#include "iwl-notif-wait.h"
+#include "fw/notif-wait.h"
 #include "iwl-trans.h"
 
 #include "led.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
similarity index 99%
rename from drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
rename to drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
index 68412ff2112e..29bb92e3df59 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c
@@ -65,7 +65,7 @@
 #include <linux/export.h>
 
 #include "iwl-drv.h"
-#include "iwl-notif-wait.h"
+#include "notif-wait.h"
 
 
 void iwl_notification_wait_init(struct iwl_notif_wait_data *notif_wait)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h b/drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h
rename to drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 33979b48ac0a..0f0cd6c9ce8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -79,7 +79,7 @@
 
 #include "iwl-op-mode.h"
 #include "iwl-trans.h"
-#include "iwl-notif-wait.h"
+#include "fw/notif-wait.h"
 #include "iwl-eeprom-parse.h"
 #include "fw/file.h"
 #include "iwl-config.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d93f1fcdf879..32233cba6786 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -68,7 +68,7 @@
 #include <linux/vmalloc.h>
 #include <net/mac80211.h>
 
-#include "iwl-notif-wait.h"
+#include "fw/notif-wait.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "fw/img.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 3e4fa853b44d..5a682722adce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -66,7 +66,7 @@
 #include <linux/jiffies.h>
 #include <net/mac80211.h>
 
-#include "iwl-notif-wait.h"
+#include "fw/notif-wait.h"
 #include "iwl-trans.h"
 #include "fw-api.h"
 #include "time-event.h"
-- 
2.11.0
