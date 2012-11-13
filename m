Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:42463
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab2KMGET (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 01:04:19 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] qca-swiss-army-knife: Add macro for TXFIR array
Date: Tue, 13 Nov 2012 11:34:01 +0530
Message-Id: <1352786641-4321-1-git-send-email-sujith@msujith.org> (sfid-20121113_070458_468137_C2463469)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/initvals/ar9485_initvals.h | 2 ++
 tools/initvals/initvals.c        | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/tools/initvals/ar9485_initvals.h b/tools/initvals/ar9485_initvals.h
index 02e4d97..a3710f3 100644
--- a/tools/initvals/ar9485_initvals.h
+++ b/tools/initvals/ar9485_initvals.h
@@ -1060,4 +1060,6 @@ static const u32 ar9485_1_1_mac_core[][2] = {
 	{0x000083d0, 0x000301ff},
 };
 
+#define ar9485_1_1_baseband_core_txfir_coeff_japan_2484 ar9462_2p0_baseband_core_txfir_coeff_japan_2484
+
 #endif /* INITVALS_9485_H */
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index a22c1e9..162a12f 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -223,6 +223,7 @@ typedef long long unsigned int u64;
 #define ar9485_poseidon1_1_pcie_phy_clkreq_disable_L1		ar9485_1_1_pcie_phy_clkreq_disable_L1
 #define ar9485_poseidon1_1_radio_postamble			ar9485_1_1_radio_postamble
 #define ar9485_poseidon1_1_mac_core				ar9485_1_1_mac_core
+#define ar9485_poseidon1_1_baseband_core_txfir_coeff_japan_2484 ar9485_1_1_baseband_core_txfir_coeff_japan_2484
 
 #include "ar9485_1_1.ini"
 
@@ -710,6 +711,9 @@ static void ar9485_hw_print_initvals(bool check)
 	INI_PRINT(ar9485_1_1_pcie_phy_clkreq_disable_L1);
 	INI_PRINT(ar9485_1_1_radio_postamble);
 	INI_PRINT(ar9485_1_1_mac_core);
+
+	INI_PRINT_DUP(ar9485_1_1_baseband_core_txfir_coeff_japan_2484,
+		      ar9462_2p0_baseband_core_txfir_coeff_japan_2484);
 }
 
 static void ar9580_1p0_hw_print_initvals(bool check)
-- 
1.8.0

