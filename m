Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:30285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab2B0XTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:19:09 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 21/24] iwlwifi: iwl-trans.h doesn't need all these includes
Date: Mon, 27 Feb 2012 14:07:45 -0800
Message-Id: <1330380468-17674-22-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120228_001926_224363_5493461B)
In-Reply-To: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330380468-17674-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We can use forward declaration for the relevant struct since they
aren't dereferenced in the header file.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.h      |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index ca0fa9c..9f8b239 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -76,6 +76,7 @@
 #include "iwl-eeprom.h"
 #include "iwl-agn-hw.h"
 #include "iwl-core.h"
+#include "iwl-ucode.h"
 
 static int iwl_trans_rx_alloc(struct iwl_trans *trans)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 08d93b9..4e7e6c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -63,12 +63,9 @@
 #ifndef __iwl_trans_h__
 #define __iwl_trans_h__
 
-#include <linux/debugfs.h>
-#include <linux/skbuff.h>
+#include <linux/ieee80211.h>
 
 #include "iwl-shared.h"
-#include "iwl-commands.h"
-#include "iwl-ucode.h"
 #include "iwl-debug.h"
 
 /**
@@ -109,6 +106,9 @@
 struct iwl_priv;
 struct iwl_shared;
 struct iwl_op_mode;
+struct fw_img;
+struct sk_buff;
+struct dentry;
 
 /**
  * DOC: Host command section
-- 
1.7.0.4

