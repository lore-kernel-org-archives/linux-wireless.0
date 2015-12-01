Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1900 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbbLAKAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:00:04 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/41] iwlwifi: print index in api/capa flags parsing message
Date: Tue,  1 Dec 2015 11:59:02 +0200
Message-Id: <1448963947-24302-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110043_546389_E8C7CAFC)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the API or capabilities index is bigger than the driver expects,
an error message is printed. Make that message print the index and
distinguish between API and capabilities.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index ce65665..16756f0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -451,7 +451,9 @@ static int iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
 	int i;
 
 	if (api_index >= DIV_ROUND_UP(NUM_IWL_UCODE_TLV_API, 32)) {
-		IWL_ERR(drv, "api_index larger than supported by driver\n");
+		IWL_ERR(drv,
+			"api flags index %d larger than supported by driver\n",
+			api_index);
 		/* don't return an error so we can load FW that has more bits */
 		return 0;
 	}
@@ -473,7 +475,9 @@ static int iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
 	int i;
 
 	if (api_index >= DIV_ROUND_UP(NUM_IWL_UCODE_TLV_CAPA, 32)) {
-		IWL_ERR(drv, "api_index larger than supported by driver\n");
+		IWL_ERR(drv,
+			"capa flags index %d larger than supported by driver\n",
+			api_index);
 		/* don't return an error so we can load FW that has more bits */
 		return 0;
 	}
-- 
2.5.0

