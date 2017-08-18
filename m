Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44580 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751861AbdHRPwU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 11:52:20 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@gmail.com>,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= <jprvita@endlessm.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 18 Aug 2017 18:49:12 +0300
Message-Id: <20170818154922.2904-15-luca@coelho.fi> (sfid-20170818_175223_792283_C19A9F6D)
In-Reply-To: <20170818154922.2904-1-luca@coelho.fi>
References: <20170818154922.2904-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 14/24] iwlwifi: Demote messages about fw flags size to info
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: João Paulo Rechi Vita <jprvita@gmail.com>

These messages are not reporting a real error, just the fact that the
firmware knows about more flags than the driver.

Currently these messages are presented to the user during boot if there
is no bootsplash covering the console, even when booting the kernel with
"quiet".

Demoting it to the warn level helps having a clean boot process.

Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index cdb765656115..bd3902f888e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -487,9 +487,9 @@ static void iwl_set_ucode_api_flags(struct iwl_drv *drv, const u8 *data,
 	int i;
 
 	if (api_index >= DIV_ROUND_UP(NUM_IWL_UCODE_TLV_API, 32)) {
-		IWL_ERR(drv,
-			"api flags index %d larger than supported by driver\n",
-			api_index);
+		IWL_WARN(drv,
+			 "api flags index %d larger than supported by driver\n",
+			 api_index);
 		return;
 	}
 
@@ -508,9 +508,9 @@ static void iwl_set_ucode_capabilities(struct iwl_drv *drv, const u8 *data,
 	int i;
 
 	if (api_index >= DIV_ROUND_UP(NUM_IWL_UCODE_TLV_CAPA, 32)) {
-		IWL_ERR(drv,
-			"capa flags index %d larger than supported by driver\n",
-			api_index);
+		IWL_WARN(drv,
+			 "capa flags index %d larger than supported by driver\n",
+			 api_index);
 		return;
 	}
 
-- 
2.14.1
