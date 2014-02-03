Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:52298 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaBCU6h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:37 -0500
Received: by mail-ee0-f51.google.com with SMTP id b57so3886419eek.24
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:36 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/62] iwlwifi: mvm: don't stop sched scan in restart
Date: Mon,  3 Feb 2014 22:57:20 +0200
Message-Id: <1391461088-8082-14-git-send-email-egrumbach@gmail.com> (sfid-20140203_223008_635432_CFBBD12F)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Don't stop scheduled scan before reporting HW restart;
mac80211 was changed to reschedule it after reconfigure.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 5e4d56e..734b022 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -760,7 +760,7 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 			ieee80211_scan_completed(mvm->hw, true);
 			break;
 		case IWL_MVM_SCAN_SCHED:
-			ieee80211_sched_scan_stopped(mvm->hw);
+			/* Sched scan will be restarted by mac80211. */
 			break;
 		}
 
-- 
1.7.9.5

