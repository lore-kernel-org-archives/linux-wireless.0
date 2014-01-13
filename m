Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64986 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaAMUWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:21 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so1296876eek.25
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:20 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/18] iwlwifi: change beamformee STS cap
Date: Mon, 13 Jan 2014 22:21:53 +0200
Message-Id: <1389644517-22807-14-git-send-email-egrumbach@gmail.com> (sfid-20140113_213436_072650_2AF84152)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

All beamformee supporting chips have the ability to support
VHT NDP in up to 4 STSs. So change the published beamformee
STS cap accordingly to 3 as it should be Nsts-1.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 1b61cb5..0c677b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -264,14 +264,13 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 				  struct ieee80211_sta_vht_cap *vht_cap)
 {
 	int num_ants = num_of_ant(data->valid_rx_ant);
-	int bf_sts_cap = num_ants - 1;
 
 	vht_cap->vht_supported = true;
 
 	vht_cap->cap = IEEE80211_VHT_CAP_SHORT_GI_80 |
 		       IEEE80211_VHT_CAP_RXSTBC_1 |
 		       IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE |
-		       bf_sts_cap << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT |
+		       3 << IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT |
 		       7 << IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_SHIFT;
 
 	if (num_ants > 1)
-- 
1.7.9.5

