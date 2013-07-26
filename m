Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab3GZI3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH 18/30] iwlwifi: mvm: Change AM->PSM timeout for EAPOL frames
Date: Fri, 26 Jul 2013 10:28:35 +0200
Message-Id: <1374827327-3464-19-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103019_244841_32037DDF)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Currently after sending EAPOL frame FW transition to power saving mode
within 10 or 100 msec (as specified by power table command). According
to new requirement this timeout for a specific EAPOL frame must be
controlled by the driver by setting tx_pm_timeout field of TX_CMD to 2
(PM_FRAME_ENUM_MGMT). This value corresponds to 32 msec timeout.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index f0e96a9..7694b8f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -123,6 +123,8 @@ static void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
 		 * it
 		 */
 		WARN_ON_ONCE(info->flags & IEEE80211_TX_CTL_AMPDU);
+	} else if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+		tx_cmd->pm_frame_timeout = cpu_to_le16(2);
 	} else {
 		tx_cmd->pm_frame_timeout = 0;
 	}
-- 
1.8.0

