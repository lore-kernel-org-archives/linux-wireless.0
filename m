Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54270 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1948886AbdDYUYY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:24:24 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:31 +0300
Message-Id: <20170425202243.7844-14-luca@coelho.fi> (sfid-20170425_222428_737686_6857CBC5)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: mvm: remove color definition
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We use the full station field as sta_id, and never
use the color.
FW are about to clean the color out, so those defines
are incorrect now (and were redundant before).

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index e79df1c53d68..a20ac4d9e63e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -214,20 +214,6 @@ enum iwl_sta_sleep_flag {
 	STA_SLEEP_STATE_MOREDATA	= BIT(2),
 };
 
-/* STA ID and color bits definitions */
-#define STA_ID_SEED		(0x0f)
-#define STA_ID_POS		(0)
-#define STA_ID_MSK		(STA_ID_SEED << STA_ID_POS)
-
-#define STA_COLOR_SEED		(0x7)
-#define STA_COLOR_POS		(4)
-#define STA_COLOR_MSK		(STA_COLOR_SEED << STA_COLOR_POS)
-
-#define STA_ID_N_COLOR_GET_COLOR(id_n_color) \
-	(((id_n_color) & STA_COLOR_MSK) >> STA_COLOR_POS)
-#define STA_ID_N_COLOR_GET_ID(id_n_color)    \
-	(((id_n_color) & STA_ID_MSK) >> STA_ID_POS)
-
 #define STA_KEY_MAX_NUM (16)
 #define STA_KEY_IDX_INVALID (0xff)
 #define STA_KEY_MAX_DATA_KEY_NUM (4)
-- 
2.11.0
