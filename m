Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61044 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYCKXSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 19:18:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwlwifi: Fix endianity in debug print
Date: Tue, 11 Mar 2008 16:17:19 -0700
Message-Id: <1205277440-14323-6-git-send-email-reinette.chatre@intel.com> (sfid-20080311_231819_663292_BAC37E12)
In-Reply-To: <1205277440-14323-5-git-send-email-reinette.chatre@intel.com>
References: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-2-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-3-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-4-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-5-git-send-email-reinette.chatre@intel.com>
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
index dc55ff2..3401f2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4263,7 +4263,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl4965_priv *priv,
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

