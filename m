Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbLUUu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:50:57 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/45] iwlwifi: mvm: set default new STA as non-aggregated
Date: Mon, 21 Dec 2015 22:50:04 +0200
Message-Id: <1450731046-2796-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215104_631918_8DA9B02B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When sending the first ADD_STA HCMD for a STA, the %add_modify
field indicates an addition of a STA and not a modification
of one. In such a case, all fields of the HCMD are used to
initialize the corresponding fields in the FW, regardless of
what bits are set in %modify_mask.

Set the %tid_disable_tx field to mvm_sta->tid_disable_agg in
iwl_mvm_sta_send_to_fw(). If the STA is only updated this will
have no effect, but if it is added - it will make sure the
STA starts with the correct queues - if any - configured as
non-aggregated by default (until told otherwise).

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 354acbd..dc3206a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -106,6 +106,7 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		.add_modify = update ? 1 : 0,
 		.station_flags_msk = cpu_to_le32(STA_FLG_FAT_EN_MSK |
 						 STA_FLG_MIMO_EN_MSK),
+		.tid_disable_tx = cpu_to_le16(mvm_sta->tid_disable_agg),
 	};
 	int ret;
 	u32 status;
@@ -622,6 +623,7 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 							     color));
 
 	cmd.tfd_queue_msk = cpu_to_le32(sta->tfd_queue_msk);
+	cmd.tid_disable_tx = cpu_to_le16(0xffff);
 
 	if (addr)
 		memcpy(cmd.addr, addr, ETH_ALEN);
-- 
2.5.0

