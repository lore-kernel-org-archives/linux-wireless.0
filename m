Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46918 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaAMUW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:28 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so800026eek.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:27 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/18] iwlwifi: mvm: don't use highest rate in VHT MCS Set
Date: Mon, 13 Jan 2014 22:21:57 +0200
Message-Id: <1389644517-22807-18-git-send-email-egrumbach@gmail.com> (sfid-20140113_213436_230735_7E5CAA93)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Keeping this as 0 is ok according to spec section 9.7.11
as this means the limits are according to the Tx/Rx
supported MCS x NSS bitmap. Initially we've set these as
there were concerns of interop issues but these turned out
to be false.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 0c677b4..f06f4cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -289,9 +289,6 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 12 |
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 14);
 
-	/* Max rate for Long GI NSS=2 80Mhz is 780Mbps */
-	vht_cap->vht_mcs.rx_highest = cpu_to_le16(780);
-
 	if (num_ants == 1 ||
 	    cfg->rx_with_siso_diversity) {
 		vht_cap->cap |= IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
@@ -299,12 +296,9 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		/* this works because NOT_SUPPORTED == 3 */
 		vht_cap->vht_mcs.rx_mcs_map |=
 			cpu_to_le16(IEEE80211_VHT_MCS_NOT_SUPPORTED << 2);
-		/* Max rate for Long GI NSS=1 80Mhz is 390Mbps */
-		vht_cap->vht_mcs.rx_highest = cpu_to_le16(390);
 	}
 
 	vht_cap->vht_mcs.tx_mcs_map = vht_cap->vht_mcs.rx_mcs_map;
-	vht_cap->vht_mcs.tx_highest = vht_cap->vht_mcs.rx_highest;
 }
 
 static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
-- 
1.7.9.5

