Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966214AbbBCHPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:17 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/19] iwlwifi: mvm: Fix building channels in scan_config_cmd
Date: Tue,  3 Feb 2015 09:14:36 +0200
Message-Id: <1422947678-16917-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081525_033616_7E39BA8A)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Use the chanel hw_value and not the center frequency when
building channel array for scan_config_cmd.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 8b74ce7..7e9aa3c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1683,10 +1683,10 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 
 	band = &mvm->nvm_data->bands[IEEE80211_BAND_2GHZ];
 	for (i = 0; i < band->n_channels; i++, j++)
-		scan_config->channel_array[j] = band->channels[i].center_freq;
+		scan_config->channel_array[j] = band->channels[i].hw_value;
 	band = &mvm->nvm_data->bands[IEEE80211_BAND_5GHZ];
 	for (i = 0; i < band->n_channels; i++, j++)
-		scan_config->channel_array[j] = band->channels[i].center_freq;
+		scan_config->channel_array[j] = band->channels[i].hw_value;
 
 	cmd.data[0] = scan_config;
 	cmd.len[0] = cmd_size;
-- 
1.9.1

