Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264Ab3DPNjx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 09:39:53 -0400
Date: Tue, 16 Apr 2013 15:40:54 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] iwlwifi: remove redundant argument from
 iwl_dump_nic_event_log
Message-ID: <20130416134053.GB20024@redhat.com> (sfid-20130416_153957_222576_4090C954)
References: <20130416133828.GA20024@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130416133828.GA20024@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can check buf against NULL instead of having additional bool
variable.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h     | 2 +-
 drivers/net/wireless/iwlwifi/dvm/debugfs.c | 4 ++--
 drivers/net/wireless/iwlwifi/dvm/main.c    | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index e575b9b..48545ab 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -172,7 +172,7 @@ int iwl_calib_set(struct iwl_priv *priv,
 		  const struct iwl_calib_hdr *cmd, int len);
 void iwl_calib_free_results(struct iwl_priv *priv);
 int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
-			    char **buf, bool display);
+			    char **buf);
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
 
 /* lib */
diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index cb6dd58..17f04de 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2240,7 +2240,7 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 	char *buf = NULL;
 	ssize_t ret;
 
-	ret = iwl_dump_nic_event_log(priv, true, &buf, true);
+	ret = iwl_dump_nic_event_log(priv, true, &buf);
 	if (ret < 0)
 		goto err;
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
@@ -2269,7 +2269,7 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	if (sscanf(buf, "%d", &event_log_flag) != 1)
 		return -EFAULT;
 	if (event_log_flag == 1)
-		iwl_dump_nic_event_log(priv, true, NULL, false);
+		iwl_dump_nic_event_log(priv, true, NULL);
 
 	return count;
 }
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index b9e3517..74d7572 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1795,7 +1795,7 @@ static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
 #define DEFAULT_DUMP_EVENT_LOG_ENTRIES (20)
 
 int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
-			    char **buf, bool display)
+			    char **buf)
 {
 	u32 base;       /* SRAM byte address of event log header */
 	u32 capacity;   /* event log capacity in # entries */
@@ -1866,7 +1866,7 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 		size);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-	if (display) {
+	if (buf) {
 		if (full_log)
 			bufsz = capacity * 48;
 		else
@@ -1962,7 +1962,7 @@ static void iwl_nic_error(struct iwl_op_mode *op_mode)
 		priv->fw->fw_version);
 
 	iwl_dump_nic_error_log(priv);
-	iwl_dump_nic_event_log(priv, false, NULL, false);
+	iwl_dump_nic_event_log(priv, false, NULL);
 
 	iwlagn_fw_error(priv, false);
 }
-- 
1.7.11.7

