Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.yrkesakademin.fi ([85.134.45.194]:45900 "EHLO
        mx1.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdKNKiQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 05:38:16 -0500
From: Thomas Backlund <tmb@mageia.org>
To: <linux-wireless@vger.kernel.org>
CC: Thomas Backlund <tmb@mageia.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] iwlwifi: fix firmware names for 9xxx and a0 series hw
Date: Tue, 14 Nov 2017 12:37:51 +0200
Message-ID: <20171114103751.7761-1-tmb@mageia.org> (sfid-20171114_113841_652358_27CAE842)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlwifi 9xxx and a0 series hw contains an extra dash in firmware file name
as seeen in modinfo output for kernel 4.14:

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
cc: Luca Coelho <luciano.coelho@intel.com>
cc: stable@vger.kernel.org

---
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index e8b5ff42f5a8..0b3fe4971fc9 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -77,13 +77,13 @@
 #define  IWL9260A_FW_PRE "iwlwifi-9260-th-a0-jf-a0-"
 #define  IWL9260B_FW_PRE "iwlwifi-9260-th-b0-jf-b0-"
 #define IWL9000_MODULE_FIRMWARE(api) \
-	IWL9000_FW_PRE "-" __stringify(api) ".ucode"
+	IWL9000_FW_PRE __stringify(api) ".ucode"
 #define IWL9000RFB_MODULE_FIRMWARE(api) \
-	IWL9000RFB_FW_PRE "-" __stringify(api) ".ucode"
+	IWL9000RFB_FW_PRE __stringify(api) ".ucode"
 #define IWL9260A_MODULE_FIRMWARE(api) \
-	IWL9260A_FW_PRE "-" __stringify(api) ".ucode"
+	IWL9260A_FW_PRE __stringify(api) ".ucode"
 #define IWL9260B_MODULE_FIRMWARE(api) \
-	IWL9260B_FW_PRE "-" __stringify(api) ".ucode"
+	IWL9260B_FW_PRE __stringify(api) ".ucode"
 
 #define NVM_HW_SECTION_NUM_FAMILY_9000		10
 
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
index a440140ed8dd..7eade165b747 100644
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
2.14.3
