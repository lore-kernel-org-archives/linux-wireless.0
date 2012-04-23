Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab2DWVw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:58 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/29] iwlwifi: move driver defines to iwl-drv.h
Date: Mon, 23 Apr 2012 14:47:30 -0700
Message-Id: <1335217660-21950-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235339_672991_A47F3070)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These defines will have to be shared
between modules, but they seem better
placed in iwl-drv.h than iwl-shared.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-drv.h        |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h     |    5 -----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d479dac..0aba378 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -51,6 +51,7 @@
 #include "iwl-agn.h"
 #include "iwl-trans.h"
 #include "iwl-op-mode.h"
+#include "iwl-drv.h"
 
 /******************************************************************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 9ffcd1e..2cbf137 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -63,6 +63,13 @@
 #ifndef __iwl_drv_h__
 #define __iwl_drv_h__
 
+/* for all modules */
+#define DRV_NAME        "iwlwifi"
+#define IWLWIFI_VERSION "in-tree:"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2012 Intel Corporation"
+#define DRV_AUTHOR     "<ilw@linux.intel.com>"
+
+
 /**
  * DOC: Driver system flows - drv component
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 079964b..3f21dd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -68,11 +68,6 @@
 #include <linux/gfp.h>
 #include <net/mac80211.h>
 
-#define DRV_NAME        "iwlwifi"
-#define IWLWIFI_VERSION "in-tree:"
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2012 Intel Corporation"
-#define DRV_AUTHOR     "<ilw@linux.intel.com>"
-
 extern struct iwl_mod_params iwlagn_mod_params;
 
 #define IWL_DISABLE_HT_ALL	BIT(0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 36616e3..b6522ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -68,6 +68,7 @@
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 
+#include "iwl-drv.h"
 #include "iwl-trans.h"
 #include "iwl-shared.h"
 #include "iwl-trans-pcie-int.h"
-- 
1.7.0.4

