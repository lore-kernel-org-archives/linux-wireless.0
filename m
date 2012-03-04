Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab2CDUnG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:06 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 048/101] iwlwifi: clean up iwl-core.h inclusions
Date: Sun,  4 Mar 2012 11:29:02 -0800
Message-Id: <1330889395-533-49-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214553_505290_58F32FDE)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The transport doesn't need to include iwl-core.h any more.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    3 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c    |    1 -
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 33a933b..f145621 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -30,8 +30,7 @@
 #include <linux/wait.h>
 #include <linux/gfp.h>
 
-/*TODO: Remove include to iwl-core.h*/
-#include "iwl-core.h"
+#include "iwl-prph.h"
 #include "iwl-io.h"
 #include "iwl-trans-pcie-int.h"
 #include "iwl-op-mode.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ef4e122..6090e98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -75,7 +75,6 @@
 #include "iwl-shared.h"
 #include "iwl-eeprom.h"
 #include "iwl-agn-hw.h"
-#include "iwl-core.h"
 
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
-- 
1.7.0.4

