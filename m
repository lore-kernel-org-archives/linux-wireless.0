Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52558 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaGVT1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2014 15:27:13 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so115892wgg.24
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2014 12:27:11 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/20] iwlwifi: mvm: use C99 initializers for add_sta
Date: Tue, 22 Jul 2014 22:26:35 +0300
Message-Id: <1406057211-31752-4-git-send-email-egrumbach@gmail.com> (sfid-20140722_212718_964377_693F22A4)
In-Reply-To: <53CEB854.9000008@gmail.com>
References: <53CEB854.9000008@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Instead of code the fixed values, use a C99 initializer.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 8128139..5445934 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -98,23 +98,21 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			   bool update)
 {
 	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
-	struct iwl_mvm_add_sta_cmd add_sta_cmd;
+	struct iwl_mvm_add_sta_cmd add_sta_cmd = {
+		.sta_id = mvm_sta->sta_id,
+		.mac_id_n_color = cpu_to_le32(mvm_sta->mac_id_n_color),
+		.add_modify = update ? 1 : 0,
+		.station_flags_msk = cpu_to_le32(STA_FLG_FAT_EN_MSK |
+						 STA_FLG_MIMO_EN_MSK),
+	};
 	int ret;
 	u32 status;
 	u32 agg_size = 0, mpdu_dens = 0;
 
-	memset(&add_sta_cmd, 0, sizeof(add_sta_cmd));
-
-	add_sta_cmd.sta_id = mvm_sta->sta_id;
-	add_sta_cmd.mac_id_n_color = cpu_to_le32(mvm_sta->mac_id_n_color);
 	if (!update) {
 		add_sta_cmd.tfd_queue_msk = cpu_to_le32(mvm_sta->tfd_queue_msk);
 		memcpy(&add_sta_cmd.addr, sta->addr, ETH_ALEN);
 	}
-	add_sta_cmd.add_modify = update ? 1 : 0;
-
-	add_sta_cmd.station_flags_msk |= cpu_to_le32(STA_FLG_FAT_EN_MSK |
-						     STA_FLG_MIMO_EN_MSK);
 
 	switch (sta->bandwidth) {
 	case IEEE80211_STA_RX_BW_160:
-- 
1.8.3.2

