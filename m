Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934429Ab1IOTcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:06 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Fry, Donald H" <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/27] iwlagn: fix modinfo display for 135 ucode.
Date: Thu, 15 Sep 2011 11:46:37 -0700
Message-Id: <1316112414-6341-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213216_433203_F736FDE6)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fry, Donald H <donald.h.fry@intel.com>

The modinfo report for 135 ucode is iwlwifi-135-IWL135_UCODE_API_MAX.ucode
Change to show the value of the define:  iwlwifi-135-6.ucode

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 913f2a2..0579398 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -75,7 +75,7 @@
 #define IWL105_MODULE_FIRMWARE(api) IWL105_FW_PRE __stringify(api) ".ucode"
 
 #define IWL135_FW_PRE "iwlwifi-135-"
-#define IWL135_MODULE_FIRMWARE(api) IWL135_FW_PRE #api ".ucode"
+#define IWL135_MODULE_FIRMWARE(api) IWL135_FW_PRE __stringify(api) ".ucode"
 
 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
-- 
1.7.0.4

