Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:55186 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbaEMNo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 09:44:57 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so406047wes.32
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2014 06:44:56 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] iwlwifi: mvm: fix off-by-one in scan channels configuration
Date: Tue, 13 May 2014 16:44:44 +0300
Message-Id: <1399988685-14715-2-git-send-email-egrumbach@gmail.com> (sfid-20140513_154505_424440_1B13E8DA)
In-Reply-To: <53722142.6070105@gmail.com>
References: <53722142.6070105@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

tail should be equal to the last valid index, so
decrease it by one.

This error causes in "a gap" in some cases (as well as
some possible out-of-bound write), finally resulting in
ucode assertion.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index cba88a3..c28de54 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -732,7 +732,7 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 	int band_2ghz = mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels;
 	int band_5ghz = mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
 	int head = 0;
-	int tail = band_2ghz + band_5ghz;
+	int tail = band_2ghz + band_5ghz - 1;
 	u32 ssid_bitmap;
 	int cmd_len;
 	int ret;
-- 
1.8.3.2

