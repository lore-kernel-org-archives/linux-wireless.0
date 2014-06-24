Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63614 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaFXTwg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:36 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1303723wib.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:35 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/27] iwlwifi: remove MCS32 support declaration
Date: Tue, 24 Jun 2014 22:51:59 +0300
Message-Id: <1403639541-4621-5-git-send-email-egrumbach@gmail.com> (sfid-20140624_220201_018472_078AC57E)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

MCS32 is currently not supported, so don't
declare support for it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index c44cf11..07ff7e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -779,7 +779,6 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 	if (cfg->ht_params->ht40_bands & BIT(band)) {
 		ht_info->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 		ht_info->cap |= IEEE80211_HT_CAP_SGI_40;
-		ht_info->mcs.rx_mask[4] = 0x01;
 		max_bit_rate = MAX_BIT_RATE_40_MHZ;
 	}
 
-- 
1.8.3.2

