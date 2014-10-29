Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40775 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbaJ2LvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:21 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so1309363wiv.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:51:20 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Max Stepanov <Max.Stepanov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/25] iwlwifi: mvm: add MVM_FW_BCAST_FILTER_PASS_ALL option
Date: Wed, 29 Oct 2014 13:50:35 +0200
Message-Id: <1414583446-11032-14-git-send-email-egrumbach@gmail.com> (sfid-20141029_131321_462132_A563F0F0)
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Max Stepanov <Max.Stepanov@intel.com>

The MVM_FW_BCAST_FILTER_PASS_ALL option defined in iwl-dbg-cfg.ini
configuration file allows to enable/disable FW broadcast filtering.

If MVM_FW_BCAST_FILTER_PASS_ALL is not defined in iwl-dbg-cfg.ini or
its value is 0, the mvm broadcast filtering is enabled.

Setting MVM_FW_BCAST_FILTER_PASS_ALL=1 in iwl-dbg-cfg.ini blocks sending
of BCAST_FILTER_CMD to FW.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 3 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index f288783..a2b473d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -92,10 +92,11 @@
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
 #define IWL_MVM_BT_COEX_CORUNNING		0
 #define IWL_MVM_BT_COEX_MPLUT			1
+#define IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS	30
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
+#define IWL_MVM_FW_BCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_QUOTA_THRESHOLD			8
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 #define IWL_MVM_RS_DISABLE_MIMO			0
-#define IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS	30
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index b17877c..9fc843e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1382,6 +1382,9 @@ bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
 		.cmd = cmd,
 	};
 
+	if (IWL_MVM_FW_BCAST_FILTER_PASS_ALL)
+		return false;
+
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->max_bcast_filters = ARRAY_SIZE(cmd->filters);
 	cmd->max_macs = ARRAY_SIZE(cmd->macs);
-- 
1.9.1

