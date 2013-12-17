Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:48203 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab3LQUov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:51 -0500
Received: by mail-ee0-f43.google.com with SMTP id c13so3130137eek.30
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:50 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/36] iwlwifi: publish STBC support in HT
Date: Tue, 17 Dec 2013 22:44:07 +0200
Message-Id: <1387313079-28123-4-git-send-email-egrumbach@gmail.com> (sfid-20131217_214456_819039_D3E083D3)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Not all chips support STBC so allow this to be
another config parameter per chip type. If STBC
is supported then publish it in the HT caps.

Since 7260/7265/3160 chips support it - set the stbc
support bit.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c         |    1 +
 drivers/net/wireless/iwlwifi/iwl-config.h       |    2 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |    7 +++++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 3c34a72..5efc6d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -108,6 +108,7 @@ static const struct iwl_base_params iwl7000_base_params = {
 };
 
 static const struct iwl_ht_params iwl7000_ht_params = {
+	.stbc = true,
 	.use_rts_for_aggregation = true, /* use rts/cts protection */
 	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 0b91624..e05440f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -162,12 +162,14 @@ struct iwl_base_params {
 };
 
 /*
+ * @stbc: support Tx STBC and 1*SS Rx STBC
  * @use_rts_for_aggregation: use rts/cts protection for HT traffic
  * @ht40_bands: bitmap of bands (using %IEEE80211_BAND_*) that support HT40
  */
 struct iwl_ht_params {
 	enum ieee80211_smps_mode smps_mode;
 	const bool ht_greenfield_support; /* if used set to true */
+	const bool stbc;
 	bool use_rts_for_aggregation;
 	u8 ht40_bands;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index f4a6d31..4380c16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -751,6 +751,13 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 	ht_info->ht_supported = true;
 	ht_info->cap = IEEE80211_HT_CAP_DSSSCCK40;
 
+	if (cfg->ht_params->stbc) {
+		ht_info->cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+
+		if (tx_chains > 1)
+			ht_info->cap |= IEEE80211_HT_CAP_TX_STBC;
+	}
+
 	if (iwlwifi_mod_params.amsdu_size_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
-- 
1.7.9.5

