Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab2DWVw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:59 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/29] iwlwifi: clean up some hw file includes
Date: Mon, 23 Apr 2012 14:47:36 -0700
Message-Id: <1335217660-21950-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235314_018814_821C8082)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We can't get rid of everything yet due to
the BT definitions that I'm not quite sure
yet how to handle, but we can get rid of
most unneeded includes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-2000.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-6000.c |    3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 42de5aa..c1aa5f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -28,7 +28,8 @@
 #include <linux/stringify.h>
 #include "iwl-config.h"
 #include "iwl-cfg.h"
-#include "iwl-dev.h" /* still needed */
+#include "iwl-csr.h"
+#include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
 #define IWL1000_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index d3d8c10..9484e3b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -28,7 +28,8 @@
 #include <linux/stringify.h>
 #include "iwl-config.h"
 #include "iwl-cfg.h"
-#include "iwl-dev.h" /* still needed */
+#include "iwl-agn-hw.h"
+#include "iwl-commands.h" /* needed for BT for now */
 
 /* Highest firmware API version supported */
 #define IWL2030_UCODE_API_MAX 6
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 94d465e..67d4ef2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -28,7 +28,8 @@
 #include <linux/stringify.h>
 #include "iwl-config.h"
 #include "iwl-cfg.h"
-#include "iwl-dev.h" /* still needed */
+#include "iwl-agn-hw.h"
+#include "iwl-csr.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 5
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 6db0a40..08afedf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -28,7 +28,8 @@
 #include <linux/stringify.h>
 #include "iwl-config.h"
 #include "iwl-cfg.h"
-#include "iwl-dev.h" /* still needed */
+#include "iwl-agn-hw.h"
+#include "iwl-commands.h" /* needed for BT for now */
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 6
-- 
1.7.0.4

