Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26340 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932Ab0GQOxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 10:53:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/3] iwlwifi: more statistics counter for agn in debugfs
Date: Sat, 17 Jul 2010 07:55:15 -0700
Message-Id: <1279378516-31290-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279378516-31290-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279378516-31290-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Display "wait_for_silence_timeout_cnt" for _agn devices
in debugfs as part of uCode statistics

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index 75d6bfc..5e5c512 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -813,6 +813,13 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 			 delta_dbg->burst_count, max_dbg->burst_count);
 	pos += scnprintf(buf + pos, bufsz - pos,
 			 "  %-30s %10u  %10u  %10u  %10u\n",
+			 "wait_for_silence_timeout_count:",
+			 le32_to_cpu(dbg->wait_for_silence_timeout_cnt),
+			 accum_dbg->wait_for_silence_timeout_cnt,
+			 delta_dbg->wait_for_silence_timeout_cnt,
+			 max_dbg->wait_for_silence_timeout_cnt);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "  %-30s %10u  %10u  %10u  %10u\n",
 			 "sleep_time:",
 			 le32_to_cpu(general->sleep_time),
 			 accum_general->sleep_time,
-- 
1.7.0.4

