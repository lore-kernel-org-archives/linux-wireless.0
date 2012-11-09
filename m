Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2KIUHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:07:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 09/13] iwlwifi: remove EEPROM version message by default
Date: Fri,  9 Nov 2012 21:08:08 +0100
Message-Id: <1352491692-28994-10-git-send-email-johannes@sipsolutions.net> (sfid-20121109_210748_627534_CF8CDA49)
In-Reply-To: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
References: <1352491692-28994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the EEPROM reading was successful, don't print
a message by default, the EEPROM version isn't all
that interesting. Change the message to DEBUG_INFO
priority so it can still be obtained.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index f10170f..4a9dc96 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -889,8 +889,8 @@ int iwl_eeprom_check_version(struct iwl_eeprom_data *data,
 {
 	if (data->eeprom_version >= trans->cfg->eeprom_ver ||
 	    data->calib_version >= trans->cfg->eeprom_calib_ver) {
-		IWL_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
-			 data->eeprom_version, data->calib_version);
+		IWL_DEBUG_INFO(trans, "device EEPROM VER=0x%x, CALIB=0x%x\n",
+			       data->eeprom_version, data->calib_version);
 		return 0;
 	}
 
-- 
1.8.0

