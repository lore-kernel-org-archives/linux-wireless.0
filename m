Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758510Ab0AOVnt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/9] iwlwifi: correct return code for log_event
Date: Fri, 15 Jan 2010 13:43:36 -0800
Message-Id: <1263591821-14867-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
References: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When dumping event log in debugfs, iwl_dump_nic_event_log()
should return the correct error code instead of let the calling
function makes it own assumption.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    5 +++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c780633..eaa309d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1965,7 +1965,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		IWL_ERR(priv,
 			"Invalid event log pointer 0x%08X for %s uCode\n",
 			base, (priv->ucode_type == UCODE_INIT) ? "Init" : "RT");
-		return pos;
+		return -EINVAL;
 	}
 
 	/* event log header */
@@ -2013,7 +2013,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 			bufsz = size * 48;
 		*buf = kmalloc(bufsz, GFP_KERNEL);
 		if (!*buf)
-			return pos;
+			return -ENOMEM;
 	}
 	if ((iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 19c7fab..a7ca06d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -429,8 +429,9 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 	int pos = 0;
 	ssize_t ret = -ENOMEM;
 
-	pos = priv->cfg->ops->lib->dump_nic_event_log(priv, true, &buf, true);
-	if (pos && buf) {
+	ret = pos = priv->cfg->ops->lib->dump_nic_event_log(
+					priv, true, &buf, true);
+	if (buf) {
 		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 		kfree(buf);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 10b0aa8..8bbcc54 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1644,7 +1644,7 @@ int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	base = le32_to_cpu(priv->card_alive.log_event_table_ptr);
 	if (!iwl3945_hw_valid_rtc_data_addr(base)) {
 		IWL_ERR(priv, "Invalid event log pointer 0x%08X\n", base);
-		return pos;
+		return  -EINVAL;
 	}
 
 	/* event log header */
@@ -1693,7 +1693,7 @@ int iwl3945_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 			bufsz = size * 48;
 		*buf = kmalloc(bufsz, GFP_KERNEL);
 		if (!*buf)
-			return pos;
+			return -ENOMEM;
 	}
 	if ((iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS) || full_log) {
 		/* if uCode has wrapped back to top of log,
-- 
1.6.3.3

