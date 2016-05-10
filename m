Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40860 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752026AbcEJUa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 16:30:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 10 May 2016 23:06:20 +0300
Message-Id: <1462910797-20303-24-git-send-email-luca@coelho.fi> (sfid-20160510_223059_988209_793D27B1)
In-Reply-To: <1462910797-20303-1-git-send-email-luca@coelho.fi>
References: <1462910585.25219.7.camel@coelho.fi>
 <1462910797-20303-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 24/41] iwlwifi: Fix firmware name maximum length definition
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Previous patch had changed firmware name convention for
new generation product. The firmware name is now longer
than the former convention. Adapt max firmware name length
to the new convention.

Fixes: e1ba684f762b ("iwlwifi: 8000: fix MODULE_FIRMWARE input")
Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index c9f0e0b..82434c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -117,7 +117,7 @@ struct iwl_drv {
 	const struct iwl_cfg *cfg;
 
 	int fw_index;                   /* firmware we're trying to load */
-	char firmware_name[32];         /* name of firmware file to load */
+	char firmware_name[64];         /* name of firmware file to load */
 
 	struct completion request_firmware_complete;
 
-- 
2.8.1

