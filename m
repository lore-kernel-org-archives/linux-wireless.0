Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:36444 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGFJgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:45 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so3057146wev.34
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:44 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/40] iwlwifi: mvm: BT Coex - add High Band retention
Date: Sun,  6 Jul 2014 12:35:51 +0300
Message-Id: <1404639376-3792-15-git-send-email-egrumbach@gmail.com> (sfid-20140706_115955_175584_775EE963)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Tell the firmware if TTC should be enabled when switching
to High Band.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 95b86cf..8d8f18a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -587,6 +587,8 @@ int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 			cpu_to_le32(BT_COEX_MPLUT_BOOST_ENABLED);
 	}
 
+	bt_cmd->enabled_modules |= cpu_to_le32(BT_COEX_HIGH_BAND_RET);
+
 	if (mvm->cfg->bt_shared_single_ant)
 		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant,
 		       sizeof(iwl_single_shared_ant));
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
index 98becb9..fea817d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h
@@ -220,6 +220,7 @@ enum iwl_bt_coex_enabled_modules {
 	BT_COEX_MPLUT_BOOST_ENABLED	= BIT(1),
 	BT_COEX_SYNC2SCO_ENABLED	= BIT(2),
 	BT_COEX_CORUN_ENABLED		= BIT(3),
+	BT_COEX_HIGH_BAND_RET		= BIT(4),
 }; /* BT_COEX_MODULES_ENABLE_E_VER_1 */
 
 /**
-- 
1.8.3.2

