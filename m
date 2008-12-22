Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbYLVDil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:41 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/10] iwl3945: adding utils ops
Date: Mon, 22 Dec 2008 11:31:15 +0800
Message-Id: <1229916683-9772-3-git-send-email-yi.zhu@intel.com> (sfid-20081222_043853_401694_4D88A9AE)
In-Reply-To: <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kolekar, Abhijeet <abhijeet.kolekar@intel.com>

The patch implements iwl_hcmd_utils_ops for 3945.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 24cdc5c..a0aea81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2377,6 +2377,19 @@ int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl3945_tx_queue *txq
 	return 0;
 }
 
+/*
+ * HCMD utils
+ */
+static u16 iwl3945_get_hcmd_size(u8 cmd_id, u16 len)
+{
+	switch (cmd_id) {
+	case REPLY_RXON:
+		return (u16) sizeof(struct iwl3945_rxon_cmd);
+	default:
+		return len;
+	}
+}
+
 /**
  * iwl3945_init_hw_rate_table - Initialize the hardware rate fallback table
  */
@@ -2694,8 +2707,13 @@ static struct iwl_lib_ops iwl3945_lib = {
 	},
 };
 
+static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
+	.get_hcmd_size = iwl3945_get_hcmd_size,
+};
+
 static struct iwl_ops iwl3945_ops = {
 	.lib = &iwl3945_lib,
+	.utils = &iwl3945_hcmd_utils,
 };
 
 static struct iwl_cfg iwl3945_bg_cfg = {
-- 
1.5.3.6

