Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64097 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758833Ab3LBVAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 16:00:00 -0500
Received: by mail-wi0-f172.google.com with SMTP id en1so5517754wid.5
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 12:59:59 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/13] iwlwifi: mvm: BT Coex - enable Sync to SCO
Date: Mon,  2 Dec 2013 22:59:25 +0200
Message-Id: <1386017965-13641-13-git-send-email-egrumbach@gmail.com> (sfid-20131202_220013_925383_AE0FDEA7)
In-Reply-To: <529CF2D6.1080008@gmail.com>
References: <529CF2D6.1080008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Sync to SCO is a feature that allows to synchronise the
wifi activity with the predictable BT activity in
SCO profile. This allows to reduce the collisions and
improve overall quality.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        |    3 ++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index f0eed69..fba997e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -397,7 +397,8 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 					    BT_VALID_ANT_ISOLATION |
 					    BT_VALID_ANT_ISOLATION_THRS |
 					    BT_VALID_TXTX_DELTA_FREQ_THRS |
-					    BT_VALID_TXRX_MAX_FREQ_0);
+					    BT_VALID_TXRX_MAX_FREQ_0 |
+					    BT_VALID_SYNC_TO_SCO);
 
 	if (mvm->cfg->bt_shared_single_ant)
 		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
index 4ea5e24..af50099 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
@@ -127,6 +127,7 @@ enum iwl_bt_coex_valid_bit_msk {
 	BT_VALID_ANT_ISOLATION_THRS	= BIT(15),
 	BT_VALID_TXTX_DELTA_FREQ_THRS	= BIT(16),
 	BT_VALID_TXRX_MAX_FREQ_0	= BIT(17),
+	BT_VALID_SYNC_TO_SCO		= BIT(18),
 };
 
 /**
-- 
1.7.9.5

