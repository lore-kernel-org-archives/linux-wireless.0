Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36539 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbZKTUFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/19] iwlwifi: fix reserved2 field in iwl4965_addsta
Date: Fri, 20 Nov 2009 12:05:01 -0800
Message-Id: <1258747510-21233-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

reserved2 field in "struct iwl4965_addsta_cmd" is __le16.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 61ecd90..386513b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1820,7 +1820,7 @@ static u16 iwl4965_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 	addsta->add_immediate_ba_ssn = cmd->add_immediate_ba_ssn;
 	addsta->sleep_tx_count = cmd->sleep_tx_count;
 	addsta->reserved1 = cpu_to_le16(0);
-	addsta->reserved2 = cpu_to_le32(0);
+	addsta->reserved2 = cpu_to_le16(0);
 
 	return (u16)sizeof(struct iwl4965_addsta_cmd);
 }
-- 
1.5.6.3

