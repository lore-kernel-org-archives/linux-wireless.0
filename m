Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbJYMBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Assaf Krauss <assaf.krauss@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/16] iwlwifi: mvm: Allow setting ctrl-chnl-position in FTM responder
Date: Sun, 25 Oct 2015 14:01:07 +0200
Message-Id: <1445774476-24792-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130137_931228_8CC7719D)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch enables the debugfs user to configure an FTM responder
with the appropriate control channel position.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 398bef6..7904b41 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -715,11 +715,30 @@ static ssize_t iwl_dbgfs_tof_responder_params_write(struct ieee80211_vif *vif,
 		goto out;
 	}
 
-	data = iwl_dbgfs_is_match("ctrl_ch_position=", buf);
+	data = iwl_dbgfs_is_match("center_freq=", buf);
 	if (data) {
+		struct iwl_tof_responder_config_cmd *cmd =
+			&mvm->tof_data.responder_cfg;
+
 		ret = kstrtou32(data, 10, &value);
-		if (ret == 0)
-			mvm->tof_data.responder_cfg.ctrl_ch_position = value;
+		if (ret == 0 && value) {
+			enum ieee80211_band band = (cmd->channel_num <= 14) ?
+						   IEEE80211_BAND_2GHZ :
+						   IEEE80211_BAND_5GHZ;
+			struct ieee80211_channel chn = {
+				.band = band,
+				.center_freq = ieee80211_channel_to_frequency(
+					cmd->channel_num, band),
+				};
+			struct cfg80211_chan_def chandef = {
+				.chan =  &chn,
+				.center_freq1 =
+					ieee80211_channel_to_frequency(value,
+								       band),
+			};
+
+			cmd->ctrl_ch_position = iwl_mvm_get_ctrl_pos(&chandef);
+		}
 		goto out;
 	}
 
-- 
2.1.4

