Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59819 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaBCUjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:39:41 -0500
Received: by mail-ee0-f41.google.com with SMTP id e51so1765561eek.28
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:39:40 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 8/8] iwlwifi: mvm: don't allow A band if SKU forbids it
Date: Mon,  3 Feb 2014 22:39:22 +0200
Message-Id: <1391459962-7381-8-git-send-email-egrumbach@gmail.com> (sfid-20140203_214002_254014_AACE1C31)
In-Reply-To: <52EFFCE8.6070505@gmail.com>
References: <52EFFCE8.6070505@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The driver wasn't reading the NVM properly. While this
didn't lead to any issue until now, it seems that there
is an old version of the NVM in the wild.
In this version, the A band channels appear to be valid
but the SKU capabilities (another field of the NVM) says
that A band isn't supported at all.
With this specific version of the NVM, the driver would
think that A band is supported while the HW / firmware
don't. This leads to asserts.

Cc: <stable@vger.kernel.org> [3.10+]
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index f06f4cb..725e954 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -182,6 +182,11 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 	for (ch_idx = 0; ch_idx < IWL_NUM_CHANNELS; ch_idx++) {
 		ch_flags = __le16_to_cpup(nvm_ch_flags + ch_idx);
+
+		if (ch_idx >= NUM_2GHZ_CHANNELS &&
+		    !data->sku_cap_band_52GHz_enable)
+			ch_flags &= ~NVM_CHANNEL_VALID;
+
 		if (!(ch_flags & NVM_CHANNEL_VALID)) {
 			IWL_DEBUG_EEPROM(dev,
 					 "Ch. %d Flags %x [%sGHz] - No traffic\n",
-- 
1.7.9.5

