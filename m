Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0GITXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jul 2010 15:23:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/4] iwlwifi: correct descriptions of advanced ucode errors
Date: Fri,  9 Jul 2010 12:24:38 -0700
Message-Id: <1278703480-13363-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278703480-13363-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

ucode errors were redefined in new ucode images and all new errors
were showing as advanced sysasserts which was misleading. new errors
are not sequential so additional lookup table added.  errors do not
overlap so both are used to support older and newer ucode images.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   36 ++++++++++++++++++++++++++-----
 1 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b5d1939..7391c63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2296,17 +2296,41 @@ static const char *desc_lookup_text[] = {
 	"DEBUG_1",
 	"DEBUG_2",
 	"DEBUG_3",
-	"ADVANCED SYSASSERT"
 };
 
-static const char *desc_lookup(int i)
+static struct { char *name; u8 num; } advanced_lookup[] = {
+	{ "NMI_INTERRUPT_WDG", 0x34 },
+	{ "SYSASSERT", 0x35 },
+	{ "UCODE_VERSION_MISMATCH", 0x37 },
+	{ "BAD_COMMAND", 0x38 },
+	{ "NMI_INTERRUPT_DATA_ACTION_PT", 0x3C },
+	{ "FATAL_ERROR", 0x3D },
+	{ "NMI_TRM_HW_ERR", 0x46 },
+	{ "NMI_INTERRUPT_TRM", 0x4C },
+	{ "NMI_INTERRUPT_BREAK_POINT", 0x54 },
+	{ "NMI_INTERRUPT_WDG_RXF_FULL", 0x5C },
+	{ "NMI_INTERRUPT_WDG_NO_RBD_RXF_FULL", 0x64 },
+	{ "NMI_INTERRUPT_HOST", 0x66 },
+	{ "NMI_INTERRUPT_ACTION_PT", 0x7C },
+	{ "NMI_INTERRUPT_UNKNOWN", 0x84 },
+	{ "NMI_INTERRUPT_INST_ACTION_PT", 0x86 },
+	{ "ADVANCED_SYSASSERT", 0 },
+};
+
+static const char *desc_lookup(u32 num)
 {
-	int max = ARRAY_SIZE(desc_lookup_text) - 1;
+	int i;
+	int max = ARRAY_SIZE(desc_lookup_text);
 
-	if (i < 0 || i > max)
-		i = max;
+	if (num < max)
+		return desc_lookup_text[num];
 
-	return desc_lookup_text[i];
+	max = ARRAY_SIZE(advanced_lookup) - 1;
+	for (i = 0; i < max; i++) {
+		if (advanced_lookup[i].num == num)
+			break;;
+	}
+	return advanced_lookup[i].name;
 }
 
 #define ERROR_START_OFFSET  (1 * sizeof(u32))
-- 
1.7.0.4

