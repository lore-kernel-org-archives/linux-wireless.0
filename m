Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:45493 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3LQUpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:33 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so3131974eek.29
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/36] iwlwifi: mvm: set highest rate in VHT MCS Set
Date: Tue, 17 Dec 2013 22:44:37 +0200
Message-Id: <1387313079-28123-34-git-send-email-egrumbach@gmail.com> (sfid-20131217_214542_467411_A40B61FF)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Set the Tx/Rx highest long GI rates in the VHT Supported MCS Set
field according to the chip capabilties.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index ebf629b..a48decc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -290,6 +290,9 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 12 |
 			    IEEE80211_VHT_MCS_NOT_SUPPORTED << 14);
 
+	/* Max rate for Long GI NSS=2 80Mhz is 780Mbps */
+	vht_cap->vht_mcs.rx_highest = cpu_to_le16(780);
+
 	if (num_ants == 1 ||
 	    cfg->rx_with_siso_diversity) {
 		vht_cap->cap |= IEEE80211_VHT_CAP_RX_ANTENNA_PATTERN |
@@ -297,9 +300,12 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		/* this works because NOT_SUPPORTED == 3 */
 		vht_cap->vht_mcs.rx_mcs_map |=
 			cpu_to_le16(IEEE80211_VHT_MCS_NOT_SUPPORTED << 2);
+		/* Max rate for Long GI NSS=1 80Mhz is 390Mbps */
+		vht_cap->vht_mcs.rx_highest = cpu_to_le16(390);
 	}
 
 	vht_cap->vht_mcs.tx_mcs_map = vht_cap->vht_mcs.rx_mcs_map;
+	vht_cap->vht_mcs.tx_highest = vht_cap->vht_mcs.rx_highest;
 }
 
 static void iwl_init_sbands(struct device *dev, const struct iwl_cfg *cfg,
-- 
1.7.9.5

