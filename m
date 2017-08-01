Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41548 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751368AbdHAJku (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:40:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  1 Aug 2017 12:40:38 +0300
Message-Id: <20170801094039.22349-8-luca@coelho.fi> (sfid-20170801_114054_207595_A7CD4F3A)
In-Reply-To: <20170801094039.22349-1-luca@coelho.fi>
References: <20170801094039.22349-1-luca@coelho.fi>
Subject: [PATCH 7/8] iwlwifi: mvm: set the RTS_MIMO_PROT bit in flag mask when sending sta to fw
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

Set the STA_FLG_RTS_MIMO_PROT bit in station_flags_msk of the add sta
command, so that when smps mode changes, the FW will know about it.

In particular, in AP mode, clients are added upon receival of an auth
request, at which point there's no knowledge of the client's smps mode.
When the assoc request arrives, the add_sta command is resent to modify
the station parameters. At this point the driver knows the smps mode,
but since the corresponding bit in the mask is not set, the fw doesn't
update this field so there's no rts protection for mimo.

Fixes: 5bc5aaad407c ("iwlwifi: mvm: set up initial SMPS/NSS station info")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ab66b4394dfc..dcaef7c043ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -121,7 +121,8 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		.mac_id_n_color = cpu_to_le32(mvm_sta->mac_id_n_color),
 		.add_modify = update ? 1 : 0,
 		.station_flags_msk = cpu_to_le32(STA_FLG_FAT_EN_MSK |
-						 STA_FLG_MIMO_EN_MSK),
+						 STA_FLG_MIMO_EN_MSK |
+						 STA_FLG_RTS_MIMO_PROT),
 		.tid_disable_tx = cpu_to_le16(mvm_sta->tid_disable_agg),
 	};
 	int ret;
-- 
2.13.2
