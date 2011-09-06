Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26707 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab1IFRPN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/10] iwlagn: remove lines from the wrong place
Date: Tue,  6 Sep 2011 09:31:24 -0700
Message-Id: <1315326685-22213-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191529_705139_BF4707D8)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Few lines for program bt_ch_announce being place in the wrong place. Remove those.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index f7b5750..126e5a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -846,9 +846,6 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 		return pos;
 	}
 
-	/* enable/disable bt channel inhibition */
-	priv->bt_ch_announce = iwlagn_mod_params.bt_ch_announce;
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (!(iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS) && !full_log)
 		size = (size > DEFAULT_DUMP_EVENT_LOG_ENTRIES)
-- 
1.7.0.4

