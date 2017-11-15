Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45836 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932101AbdKOQw7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 11:52:59 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Thomas Backlund <tmb@mageia.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 15 Nov 2017 18:52:42 +0200
Message-Id: <20171115165242.21675-4-luca@coelho.fi> (sfid-20171115_175310_552783_1E9C7505)
In-Reply-To: <20171115165242.21675-1-luca@coelho.fi>
References: <20171115165242.21675-1-luca@coelho.fi>
Subject: [PATCH 3/3] iwlwifi: fix firmware names for 9000 and A000 series hw
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Backlund <tmb@mageia.org>

iwlwifi 9000 and a0000 series hw contains an extra dash in firmware
file name as seeen in modinfo output for kernel 4.14:

firmware:       iwlwifi-9260-th-b0-jf-b0--34.ucode
firmware:       iwlwifi-9260-th-a0-jf-a0--34.ucode
firmware:       iwlwifi-9000-pu-a0-jf-b0--34.ucode
firmware:       iwlwifi-9000-pu-a0-jf-a0--34.ucode
firmware:       iwlwifi-QuQnj-a0-hr-a0--34.ucode
firmware:       iwlwifi-QuQnj-a0-jf-b0--34.ucode
firmware:       iwlwifi-QuQnj-f0-hr-a0--34.ucode
firmware:       iwlwifi-Qu-a0-jf-b0--34.ucode
firmware:       iwlwifi-Qu-a0-hr-a0--34.ucode

Fix that by dropping the extra adding of '"-"'.

Signed-off-by: Thomas Backlund <tmb@mageia.org>
Cc: stable@vger.kernel.org # 4.13
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
index ea8206515171..705f83b02e13 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
@@ -80,15 +80,15 @@
 #define IWL_A000_HR_A0_FW_PRE	"iwlwifi-QuQnj-a0-hr-a0-"
 
 #define IWL_A000_HR_MODULE_FIRMWARE(api) \
-	IWL_A000_HR_FW_PRE "-" __stringify(api) ".ucode"
+	IWL_A000_HR_FW_PRE __stringify(api) ".ucode"
 #define IWL_A000_JF_MODULE_FIRMWARE(api) \
-	IWL_A000_JF_FW_PRE "-" __stringify(api) ".ucode"
+	IWL_A000_JF_FW_PRE __stringify(api) ".ucode"
 #define IWL_A000_HR_F0_QNJ_MODULE_FIRMWARE(api) \
-	IWL_A000_HR_F0_FW_PRE "-" __stringify(api) ".ucode"
+	IWL_A000_HR_F0_FW_PRE __stringify(api) ".ucode"
 #define IWL_A000_JF_B0_QNJ_MODULE_FIRMWARE(api) \
-	IWL_A000_JF_B0_FW_PRE "-" __stringify(api) ".ucode"
+	IWL_A000_JF_B0_FW_PRE __stringify(api) ".ucode"
 #define IWL_A000_HR_A0_QNJ_MODULE_FIRMWARE(api) \
-	IWL_A000_HR_A0_FW_PRE "-" __stringify(api) ".ucode"
+	IWL_A000_HR_A0_FW_PRE __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_A000		10
 
-- 
2.15.0
