Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbbHDU7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/37] iwlwifi: mvm: add wide firmware command support for debug triggers
Date: Tue,  4 Aug 2015 23:43:26 +0300
Message-Id: <1438721007-23283-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230716_816362_7C29A459)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add support for extended command id in triggers handling.
Extended command id header contains group id in addition to command id.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a424d95..6957d02 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -703,12 +703,13 @@ static inline void iwl_mvm_rx_check_trigger(struct iwl_mvm *mvm,
 		if (!cmds_trig->cmds[i].cmd_id)
 			break;
 
-		if (cmds_trig->cmds[i].cmd_id != pkt->hdr.cmd)
+		if (cmds_trig->cmds[i].cmd_id != pkt->hdr.cmd ||
+		    cmds_trig->cmds[i].group_id != pkt->hdr.group_id)
 			continue;
 
 		iwl_mvm_fw_dbg_collect_trig(mvm, trig,
-					    "CMD 0x%02x received",
-					    pkt->hdr.cmd);
+					    "CMD 0x%02x.%02x received",
+					    pkt->hdr.group_id, pkt->hdr.cmd);
 		break;
 	}
 }
-- 
2.1.4

