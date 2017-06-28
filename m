Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36022 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751848AbdF1UPv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:15:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:27 +0300
Message-Id: <20170628201330.9432-29-luca@coelho.fi> (sfid-20170628_221558_888679_834D4C50)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 28/31] iwlwifi: create new subdirectory for FW interaction
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a lot of mvm code that really should be more generic
and part of the iwlwifi module. Start by making a place to
keep such code - in the new "fw" subdirectory - and already
move the firmware related header files there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h                   |  2 +-
 drivers/net/wireless/intel/iwlwifi/{iwl-fw-api.h => fw/api.h}  |  0
 .../intel/iwlwifi/{iwl-fw-error-dump.h => fw/error-dump.h}     |  0
 .../net/wireless/intel/iwlwifi/{iwl-fw-file.h => fw/file.h}    |  0
 drivers/net/wireless/intel/iwlwifi/{iwl-fw.h => fw/img.h}      | 10 +++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                   |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h                 |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c               |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h                |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c              |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                   |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                |  2 +-
 14 files changed, 17 insertions(+), 17 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-api.h => fw/api.h} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-error-dump.h => fw/error-dump.h} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw-file.h => fw/file.h} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-fw.h => fw/img.h} (98%)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
index 8148df61a916..025db135b63c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/dev.h
@@ -38,7 +38,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 
-#include "iwl-fw.h"
+#include "fw/img.h"
 #include "iwl-eeprom-parse.h"
 #include "iwl-csr.h"
 #include "iwl-debug.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-api.h b/drivers/net/wireless/intel/iwlwifi/fw/api.h
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-fw-api.h
rename to drivers/net/wireless/intel/iwlwifi/fw/api.h
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
rename to drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
rename to drivers/net/wireless/intel/iwlwifi/fw/file.h
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
similarity index 98%
rename from drivers/net/wireless/intel/iwlwifi/iwl-fw.h
rename to drivers/net/wireless/intel/iwlwifi/fw/img.h
index d323b70b510a..e6bc9cb60700 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -64,12 +64,12 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
 
-#ifndef __iwl_fw_h__
-#define __iwl_fw_h__
+#ifndef __iwl_fw_img_h__
+#define __iwl_fw_img_h__
 #include <linux/types.h>
 
-#include "iwl-fw-file.h"
-#include "iwl-fw-error-dump.h"
+#include "file.h"
+#include "error-dump.h"
 
 /**
  * enum iwl_ucode_type
@@ -339,4 +339,4 @@ iwl_get_ucode_image(const struct iwl_fw *fw, enum iwl_ucode_type ucode_type)
 	return &fw->img[ucode_type];
 }
 
-#endif  /* __iwl_fw_h__ */
+#endif  /* __iwl_fw_img_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index b5ebd0fcfbf6..6fdb5921e17f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -76,7 +76,7 @@
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
 #include "iwl-agn-hw.h"
-#include "iwl-fw.h"
+#include "fw/img.h"
 #include "iwl-config.h"
 #include "iwl-modparams.h"
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 57db6250a329..eb6842abb4c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -74,9 +74,9 @@
 
 #include "iwl-debug.h"
 #include "iwl-config.h"
-#include "iwl-fw.h"
+#include "fw/img.h"
 #include "iwl-op-mode.h"
-#include "iwl-fw-api.h"
+#include "fw/api.h"
 
 /**
  * DOC: Transport layer - what is it ?
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 78dde0a8d358..61a5e34140db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -73,7 +73,7 @@
 #include "sta.h"
 #include "iwl-io.h"
 #include "debugfs.h"
-#include "iwl-fw-error-dump.h"
+#include "fw/error-dump.h"
 
 static ssize_t iwl_dbgfs_ctdp_budget_read(struct file *file,
 					  char __user *user_buf,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
index e9f1be9da7d4..4a5287a0c617 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
@@ -65,8 +65,8 @@
 
 #ifndef __mvm_fw_dbg_h__
 #define __mvm_fw_dbg_h__
-#include "iwl-fw-file.h"
-#include "iwl-fw-error-dump.h"
+#include "fw/file.h"
+#include "fw/error-dump.h"
 #include "mvm.h"
 
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c5445be36701..80c42ef981c0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -70,7 +70,7 @@
 
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
-#include "iwl-fw.h"
+#include "fw/img.h"
 #include "iwl-debug.h"
 #include "iwl-csr.h" /* for iwl_mvm_rx_card_state_notif */
 #include "iwl-io.h" /* for iwl_mvm_rx_card_state_notif */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1cfb4c72199a..bcde1ba0f1c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -84,7 +84,7 @@
 #include "iwl-eeprom-parse.h"
 #include "iwl-phy-db.h"
 #include "testmode.h"
-#include "iwl-fw-error-dump.h"
+#include "fw/error-dump.h"
 #include "iwl-prph.h"
 #include "iwl-nvm-parse.h"
 #include "fw-dbg.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index e1f7d273d0bd..33979b48ac0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -81,7 +81,7 @@
 #include "iwl-trans.h"
 #include "iwl-notif-wait.h"
 #include "iwl-eeprom-parse.h"
-#include "iwl-fw-file.h"
+#include "fw/file.h"
 #include "iwl-config.h"
 #include "sta.h"
 #include "fw-api.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index c1ce92f5306d..d93f1fcdf879 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -71,7 +71,7 @@
 #include "iwl-notif-wait.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
-#include "iwl-fw.h"
+#include "fw/img.h"
 #include "iwl-debug.h"
 #include "iwl-drv.h"
 #include "iwl-modparams.h"
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 5778ba2278d1..a7d0b5c5e4a0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -80,7 +80,7 @@
 #include "iwl-prph.h"
 #include "iwl-scd.h"
 #include "iwl-agn-hw.h"
-#include "iwl-fw-error-dump.h"
+#include "fw/error-dump.h"
 #include "internal.h"
 #include "iwl-fh.h"
 
-- 
2.11.0
