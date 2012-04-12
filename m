Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966084Ab2DLV6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:11 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/24] iwlwifi: change the default P2P support to "Yes"
Date: Thu, 12 Apr 2012 14:54:21 -0700
Message-Id: <1334267661-14654-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235827_509563_E0335D2F)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig   |   29 +++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 565611e..db6c6e5 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -113,20 +113,21 @@ config IWLWIFI_DEVICE_TESTMODE
 	  generic netlink message via NL80211_TESTMODE channel.
 
 config IWLWIFI_P2P
-       bool "iwlwifi experimental P2P support"
-       depends on IWLWIFI
-       help
-         This option enables experimental P2P support for some devices
-         based on microcode support. Since P2P support is still under
-         development, this option may even enable it for some devices
-         now that turn out to not support it in the future due to
-         microcode restrictions.
-
-         To determine if your microcode supports the experimental P2P
-         offered by this option, check if the driver advertises AP
-         support when it is loaded.
-
-         Say Y only if you want to experiment with P2P.
+	def_bool y
+	bool "iwlwifi experimental P2P support"
+	depends on IWLWIFI
+	help
+	  This option enables experimental P2P support for some devices
+	  based on microcode support. Since P2P support is still under
+	  development, this option may even enable it for some devices
+	  now that turn out to not support it in the future due to
+	  microcode restrictions.
+
+	  To determine if your microcode supports the experimental P2P
+	  offered by this option, check if the driver advertises AP
+	  support when it is loaded.
+
+	  Say Y only if you want to experiment with P2P.
 
 config IWLWIFI_EXPERIMENTAL_MFP
 	bool "support MFP (802.11w) even if uCode doesn't advertise"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 09367d4..500eaa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1564,7 +1564,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	ucode_flags = fw->ucode_capa.flags;
 
 #ifndef CONFIG_IWLWIFI_P2P
-	ucode_flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+	ucode_flags &= ~IWL_UCODE_TLV_FLAGS_P2P;
 #endif
 
 	if (ucode_flags & IWL_UCODE_TLV_FLAGS_PAN) {
-- 
1.7.0.4

