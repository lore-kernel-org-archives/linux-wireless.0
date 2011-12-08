Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45190 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab1LIAug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 19:50:36 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3.2] iwlwifi: do not set the sequence control bit is not needed
Date: Thu,  8 Dec 2011 15:52:00 -0800
Message-Id: <1323388320-13825-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_015040_226746_DF3D9236)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the IEEE80211_TX_CTL_ASSIGN_SEQ flag from mac80211, then decide how to
set the TX_CMD_FLG_SEQ_CTL_MSK bit. Setting the wrong bit in BAR frame whill
make the firmware to increment the sequence number which is incorrect and
cause unknown behavior.

CC: stable@vger.kernel.org #3.0+
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch will be also available from wireless branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git

 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 35a6b71..df1540c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -91,7 +91,10 @@ static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
 		tx_cmd->tid_tspec = qc[0] & 0xf;
 		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	} else {
-		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+		if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+		else
+			tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
 	}
 
 	iwlagn_tx_cmd_protection(priv, info, fc, &tx_flags);
-- 
1.7.0.4

