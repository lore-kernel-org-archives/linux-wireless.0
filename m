Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14287 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0IKQGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/10] iwlwifi: remember the last uCode sysassert error code
Date: Sat, 11 Sep 2010 09:08:30 -0700
Message-Id: <1284221318-28281-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When sysassert happen, uCode will report the error code,
driver dump the information to dmesg. Here also remember
the last error code for future reference.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    3 +--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c8a2ec8..df2edcc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1278,7 +1278,6 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 		IWL_ERR(priv, "Microcode SW error detected. "
 			" Restarting 0x%X.\n", inta);
 		priv->isr_stats.sw++;
-		priv->isr_stats.sw_err = inta;
 		iwl_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
@@ -1459,7 +1458,6 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		IWL_ERR(priv, "Microcode SW error detected. "
 			" Restarting 0x%X.\n", inta);
 		priv->isr_stats.sw++;
-		priv->isr_stats.sw_err = inta;
 		iwl_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
@@ -2467,6 +2465,7 @@ void iwl_dump_nic_error_log(struct iwl_priv *priv)
 	}
 
 	desc = iwl_read_targ_mem(priv, base + 1 * sizeof(u32));
+	priv->isr_stats.err_code = desc;
 	pc = iwl_read_targ_mem(priv, base + 2 * sizeof(u32));
 	blink1 = iwl_read_targ_mem(priv, base + 3 * sizeof(u32));
 	blink2 = iwl_read_targ_mem(priv, base + 4 * sizeof(u32));
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 0ee8f51..86017ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -575,10 +575,10 @@ static ssize_t iwl_dbgfs_interrupt_read(struct file *file,
 		priv->isr_stats.hw);
 	pos += scnprintf(buf + pos, bufsz - pos, "SW Error:\t\t\t %u\n",
 		priv->isr_stats.sw);
-	if (priv->isr_stats.sw > 0) {
+	if (priv->isr_stats.sw || priv->isr_stats.hw) {
 		pos += scnprintf(buf + pos, bufsz - pos,
 			"\tLast Restarting Code:  0x%X\n",
-			priv->isr_stats.sw_err);
+			priv->isr_stats.err_code);
 	}
 #ifdef CONFIG_IWLWIFI_DEBUG
 	pos += scnprintf(buf + pos, bufsz - pos, "Frame transmitted:\t\t %u\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4dd38b7..504ff0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -945,7 +945,7 @@ enum iwl_pa_type {
 struct isr_statistics {
 	u32 hw;
 	u32 sw;
-	u32 sw_err;
+	u32 err_code;
 	u32 sch;
 	u32 alive;
 	u32 rfkill;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 68e624a..9c90be1 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1730,7 +1730,6 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 		IWL_ERR(priv, "Microcode SW error detected. "
 			"Restarting 0x%X.\n", inta);
 		priv->isr_stats.sw++;
-		priv->isr_stats.sw_err = inta;
 		iwl_irq_handle_error(priv);
 		handled |= CSR_INT_BIT_SW_ERR;
 	}
-- 
1.7.0.4

