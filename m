Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab2FTHiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/12] iwlwifi: fix 11n_disable EEPROM refactoring regression
Date: Wed, 20 Jun 2012 09:38:12 +0200
Message-Id: <1340177894-12992-11-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093856_461372_99714E93)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

My commit 26a7ca9a71a ("iwlwifi: refactor EEPROM reading/parsing")
broke the 11n_disable module parameter's BIT(0) to disable all HT
operation (using the other bits to disable aggregation only was
unaffected). Restore this by overriding the SKU when parsing the
EEPROM if the module parameter is set.

Reported-by: Matthijs Kooijman <matthijs@stdin.nl>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index c87a05c..f10170f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -853,6 +853,9 @@ iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 					     EEPROM_RADIO_CONFIG);
 	data->sku = iwl_eeprom_query16(eeprom, eeprom_size,
 				       EEPROM_SKU_CAP);
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
+		data->sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
+
 	data->eeprom_version = iwl_eeprom_query16(eeprom, eeprom_size,
 						  EEPROM_VERSION);
 
-- 
1.7.10

