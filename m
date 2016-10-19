Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50206 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S944474AbcJSPS0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:26 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:52 +0300
Message-Id: <20161019100755.23874-8-luca@coelho.fi> (sfid-20161019_171830_890575_37D69A64)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 07/10] iwlwifi: mvm: tell the firmware about the AID of the peer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

When a peer associates, the firmware will soon want to know
its AID to be able to compute the TIM IE by itself.
In DQA, the firmware has all the information it needs to
update the TIM internally. The only missing part is the
AID.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 82ee786..636c8b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -202,6 +202,7 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		cpu_to_le32(agg_size << STA_FLG_MAX_AGG_SIZE_SHIFT);
 	add_sta_cmd.station_flags |=
 		cpu_to_le32(mpdu_dens << STA_FLG_AGG_MPDU_DENS_SHIFT);
+	add_sta_cmd.assoc_id = cpu_to_le16(sta->aid);
 
 	if (sta->wme) {
 		add_sta_cmd.modify_mask |= STA_MODIFY_UAPSD_ACS;
-- 
2.9.3
