Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19787 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab1KYUIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 15:08:19 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 6/7] iwlwifi: show the configuration option
Date: Fri, 25 Nov 2011 11:11:47 -0800
Message-Id: <1322248308-5113-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111125_210825_241391_03621E7E)
In-Reply-To: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1322248308-5113-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not sure it is the best way to do it, but many times we want to know what the
configuration options were enabled for the compiled driver.
Let's just log the options during load time; so there were be no confusion.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8e571c3..db0d3a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1682,6 +1682,35 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 
 
 
+static void iwl_debug_config(struct iwl_priv *priv)
+{
+	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEBUG "
+#ifdef CONFIG_IWLWIFI_DEBUG
+		"enabled\n");
+#else
+		"disabled\n");
+#endif
+	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEBUGFS "
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		"enabled\n");
+#else
+		"disabled\n");
+#endif
+	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEVICE_TRACING "
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+		"enabled\n");
+#else
+		"disabled\n");
+#endif
+
+	dev_printk(KERN_INFO, bus(priv)->dev, "CONFIG_IWLWIFI_DEVICE_SVTOOL "
+#ifdef CONFIG_IWLWIFI_DEVICE_SVTOOL
+		"enabled\n");
+#else
+		"disabled\n");
+#endif
+}
+
 int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 		struct iwl_cfg *cfg)
 {
@@ -1717,6 +1746,9 @@ int iwl_probe(struct iwl_bus *bus, const struct iwl_trans_ops *trans_ops,
 
 	SET_IEEE80211_DEV(hw, bus(priv)->dev);
 
+	/* what debugging capabilities we have */
+	iwl_debug_config(priv);
+
 	IWL_DEBUG_INFO(priv, "*** LOAD DRIVER ***\n");
 	priv->cfg = cfg;
 
-- 
1.7.0.4

