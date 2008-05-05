Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbYEECYN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 08/25] iwlwifi-5000: add build_addsta_hcmd handler for 5000 HW
Date: Mon,  5 May 2008 10:22:35 +0800
Message-Id: <1209954172-3092-9-git-send-email-yi.zhu@intel.com> (sfid-20080505_042355_567985_A6841F1C)
In-Reply-To: <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds iwl5000_build_addsta_hcmd handler.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 83ed69d..f9c2274 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -422,10 +422,19 @@ static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 	}
 }
 
+static u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
+{
+	u16 size = (u16)sizeof(struct iwl_addsta_cmd);
+	memcpy(data, cmd, size);
+	return size;
+}
+
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
 static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
+	.build_addsta_hcmd = iwl5000_build_addsta_hcmd,
 #ifdef CONFIG_IWL5000_RUN_TIME_CALIB
 	.gain_computation = iwl5000_gain_computation,
 	.chain_noise_reset = iwl5000_chain_noise_reset,
-- 
1.5.3.6

