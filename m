Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52926 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757516AbdDRWXQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:23:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:27 +0300
Message-Id: <20170418221729.28372-24-luca@coelho.fi> (sfid-20170419_002340_840131_7DCD3B2C)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 23/25] iwlwifi: a000: fix memory offsets and lengths
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Memory offsets and lengths for A000 HW is different
than currently specified.

Fixes: e34d975e40ff ("iwlwifi: Add a000 HW family support")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 1c731b88d08c..097cb45c8ad9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -65,12 +65,12 @@
 #define IWL_A000_TX_POWER_VERSION	0xffff /* meaningless */
 
 /* Memory offsets and lengths */
-#define IWL_A000_DCCM_OFFSET		0x800000
-#define IWL_A000_DCCM_LEN		0x18000
+#define IWL_A000_DCCM_OFFSET		0x800000 /* LMAC1 */
+#define IWL_A000_DCCM_LEN		0x10000 /* LMAC1 */
 #define IWL_A000_DCCM2_OFFSET		0x880000
 #define IWL_A000_DCCM2_LEN		0x8000
 #define IWL_A000_SMEM_OFFSET		0x400000
-#define IWL_A000_SMEM_LEN		0x68000
+#define IWL_A000_SMEM_LEN		0xD0000
 
 #define IWL_A000_JF_FW_PRE	"iwlwifi-Qu-a0-jf-b0-"
 #define IWL_A000_HR_FW_PRE	"iwlwifi-Qu-a0-hr-a0-"
-- 
2.11.0
