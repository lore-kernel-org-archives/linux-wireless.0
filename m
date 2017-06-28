Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36042 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751583AbdF1UQE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:16:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:29 +0300
Message-Id: <20170628201330.9432-31-luca@coelho.fi> (sfid-20170628_221627_566650_20667E7D)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 30/31] iwlwifi: move configuration into sub-directory
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we now support 8 device families, move their configuration
files into a new subdirectory "cfg".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile                   | 4 ++--
 drivers/net/wireless/intel/iwlwifi/{iwl-1000.c => cfg/1000.c} | 0
 drivers/net/wireless/intel/iwlwifi/{iwl-2000.c => cfg/2000.c} | 0
 drivers/net/wireless/intel/iwlwifi/{iwl-5000.c => cfg/5000.c} | 0
 drivers/net/wireless/intel/iwlwifi/{iwl-6000.c => cfg/6000.c} | 0
 drivers/net/wireless/intel/iwlwifi/{iwl-7000.c => cfg/7000.c} | 0
 drivers/net/wireless/intel/iwlwifi/{iwl-8000.c => cfg/8000.c} | 0
 drivers/net/wireless/intel/iwlwifi/{iwl-9000.c => cfg/9000.c} | 0
 drivers/net/wireless/intel/iwlwifi/{iwl-a000.c => cfg/a000.c} | 0
 9 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-1000.c => cfg/1000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-2000.c => cfg/2000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-5000.c => cfg/5000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-6000.c => cfg/6000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-7000.c => cfg/7000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-8000.c => cfg/8000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-9000.c => cfg/9000.c} (100%)
 rename drivers/net/wireless/intel/iwlwifi/{iwl-a000.c => cfg/a000.c} (100%)

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 7733fc41ce98..20bd261223af 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -7,8 +7,8 @@ iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
 iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
 iwlwifi-objs		+= pcie/ctxt-info.o pcie/trans-gen2.o pcie/tx-gen2.o
-iwlwifi-$(CONFIG_IWLDVM) += iwl-1000.o iwl-2000.o iwl-5000.o iwl-6000.o
-iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o iwl-8000.o iwl-9000.o iwl-a000.o
+iwlwifi-$(CONFIG_IWLDVM) += cfg/1000.o cfg/2000.o cfg/5000.o cfg/6000.o
+iwlwifi-$(CONFIG_IWLMVM) += cfg/7000.o cfg/8000.o cfg/9000.o cfg/a000.o
 iwlwifi-objs		+= iwl-trans.o
 iwlwifi-objs		+= fw/notif-wait.o
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-1000.c b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-1000.c
rename to drivers/net/wireless/intel/iwlwifi/cfg/1000.c
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-2000.c b/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-2000.c
rename to drivers/net/wireless/intel/iwlwifi/cfg/2000.c
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-5000.c b/drivers/net/wireless/intel/iwlwifi/cfg/5000.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-5000.c
rename to drivers/net/wireless/intel/iwlwifi/cfg/5000.c
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-6000.c b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-6000.c
rename to drivers/net/wireless/intel/iwlwifi/cfg/6000.c
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-7000.c
rename to drivers/net/wireless/intel/iwlwifi/cfg/7000.c
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-8000.c
rename to drivers/net/wireless/intel/iwlwifi/cfg/8000.c
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-9000.c
rename to drivers/net/wireless/intel/iwlwifi/cfg/9000.c
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
similarity index 100%
rename from drivers/net/wireless/intel/iwlwifi/iwl-a000.c
rename to drivers/net/wireless/intel/iwlwifi/cfg/a000.c
-- 
2.11.0
