Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38734 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYCJSl1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 14:41:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/7] iwlwifi: Fix endianity in debug print
Date: Mon, 10 Mar 2008 11:35:11 -0700
Message-Id: <1205174112-18962-7-git-send-email-reinette.chatre@intel.com> (sfid-20080310_184150_035363_C6BC420B)
In-Reply-To: <1205174112-18962-6-git-send-email-reinette.chatre@intel.com>
References: <1205174112-18962-1-git-send-email-reinette.chatre@intel.com>
 <1205174112-18962-2-git-send-email-reinette.chatre@intel.com>
 <1205174112-18962-3-git-send-email-reinette.chatre@intel.com>
 <1205174112-18962-4-git-send-email-reinette.chatre@intel.com>
 <1205174112-18962-5-git-send-email-reinette.chatre@intel.com>
 <1205174112-18962-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fix debug print out endianity issue for bitmap
Since u64 and le64 variables are casted to unsigned long long,
after patch 'wireless: correct warnings from using '%llx' for type 'u64'
also bitmaps need to be converted to native endianity

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index b3bf7c1..67091b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4265,7 +4265,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl4965_priv *priv,
 			   "%d, scd_ssn = %d\n",
 			   ba_resp->tid,
 			   ba_resp->seq_ctl,
-			   (unsigned long long)ba_resp->bitmap,
+			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
 			   ba_resp->scd_flow,
 			   ba_resp->scd_ssn);
 	IWL_DEBUG_TX_REPLY("DAT start_idx = %d, bitmap = 0x%llx \n",
-- 
1.5.3.4

