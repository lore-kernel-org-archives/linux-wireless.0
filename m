Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZA0WZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 17:25:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/7] iwlwifi: iwl3945_send_tx_power must be static
Date: Tue, 27 Jan 2009 14:27:54 -0800
Message-Id: <1233095278-5850-4-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232516_292770_08F43E04)
In-Reply-To: <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
 <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

iwl3945_send_tx_power must be static

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 610ee17..b4b186d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1690,7 +1690,7 @@ static void iwl3945_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_in
  * Configures power settings for all rates for the current channel,
  * using values from channel info struct, and send to NIC
  */
-int iwl3945_send_tx_power(struct iwl_priv *priv)
+static int iwl3945_send_tx_power(struct iwl_priv *priv)
 {
 	int rate_idx, i;
 	const struct iwl_channel_info *ch_info = NULL;
-- 
1.5.4.3

