Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979Ab1LIBZB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:01 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/15] iwlwifi: P2P is not enabled by default
Date: Thu,  8 Dec 2011 16:26:15 -0800
Message-Id: <1323390382-1678-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022533_531037_34B33EA8)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P2P still under development. it will not enabled by default, but user
always can enable it manually for testing.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig   |   16 ++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c |   10 +++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 82c8cca..ae08498 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -111,3 +111,19 @@ config IWLWIFI_DEVICE_TESTMODE
 	  NL80211_TESTMODE. This provide the capabilities of enable user space
 	  validation applications to interacts with the device through the
 	  generic netlink message via NL80211_TESTMODE channel.
+
+config IWLWIFI_P2P
+       bool "iwlwifi experimental P2P support"
+       depends on IWLWIFI
+       help
+         This option enables experimental P2P support for some devices
+         based on microcode support. Since P2P support is still under
+         development, this option may even enable it for some devices
+         now that turn out to not support it in the future due to
+         microcode restrictions.
+
+         To determine if your microcode supports the experimental P2P
+         offered by this option, check if the driver advertises AP
+         support when it is loaded.
+
+         Say Y only if you want to experiment with P2P.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5021cc9..6dd1e10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1036,6 +1036,9 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->inst_evtlog_size =
 			priv->cfg->base_params->max_event_log_size;
 	priv->inst_errlog_ptr = pieces.inst_errlog_ptr;
+#ifndef CONFIG_IWLWIFI_P2P
+	ucode_capa.flags &= ~IWL_UCODE_TLV_FLAGS_PAN;
+#endif
 
 	priv->new_scan_threshold_behaviour =
 		!!(ucode_capa.flags & IWL_UCODE_TLV_FLAGS_NEWSCAN);
@@ -1057,7 +1060,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->sta_key_max_num = STA_KEY_MAX_NUM;
 		priv->shrd->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 	}
-
 	/*
 	 * figure out the offset of chain noise reset and gain commands
 	 * base on the size of standard phy calibration commands table size
@@ -1709,6 +1711,12 @@ static void iwl_debug_config(struct iwl_priv *priv)
 #else
 		"disabled\n");
 #endif
+	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_P2P "
+#ifdef CONFIG_IWLWIFI_P2P
+		"enabled\n");
+#else
+		"disabled\n");
+#endif
 }
 
 int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
-- 
1.7.0.4

