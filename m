Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36465 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760557Ab1LPTTl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:19:41 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 7/7] initvals: add ath9k specific initvals for AR9330 1.2
Date: Fri, 16 Dec 2011 20:19:25 +0100
Message-Id: <1324063165-4349-7-git-send-email-juhosg@openwrt.org> (sfid-20111216_201944_646516_A6AB9F17)
In-Reply-To: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
References: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ar9330_1p2_initvals.h file submitted to ath9k has
been generated manually from the ar9330_12.ini from the
LSDK-WLAN-9.2.0.405.tgz tarball.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
[juhosg@idared initvals-tool]$ ./initvals -f ar9330-1p2 | sha1sum
f35f1fe771cae1e21251713c4efe825658ac1dd5  -
[juhosg@idared initvals-tool]$ make clean all ATHEROS=1
rm -f initvals
gcc -DATHEROS -o initvals initvals.c
[juhosg@idared initvals-tool]$ ./initvals -f ar9330-1p2 | sha1sum
f35f1fe771cae1e21251713c4efe825658ac1dd5  -
[juhosg@idared initvals-tool]$
---
 Makefile   |    4 +++-
 initvals.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7b9ce88..67d09d5 100644
--- a/Makefile
+++ b/Makefile
@@ -10,7 +10,8 @@ ATHEROS_DEPS += \
 	ar9287_1_1.ini		\
 	ar9271.ini		\
 	ar9300_osprey22.ini	\
-	ar9330_11.ini
+	ar9330_11.ini		\
+	ar9330_12.ini
 endif
 
 ATH9K_DEPS += \
@@ -19,6 +20,7 @@ ATH9K_DEPS += \
 	ar9002_initvals.h 	\
 	ar9003_2p2_initvals.h	\
 	ar9330_1p1_initvals.h	\
+	ar9330_1p2_initvals.h	\
 	ar9580_1p0_initvals.h
 
 initvals: $(ATH9K_DEPS) $(ATHEROS_DEPS) initvals.c
diff --git a/initvals.c b/initvals.c
index 6835c7b..5923823 100644
--- a/initvals.c
+++ b/initvals.c
@@ -22,6 +22,7 @@ typedef long long unsigned int u64;
 #include "ar9002_initvals.h"
 #include "ar9003_2p2_initvals.h"
 #include "ar9330_1p1_initvals.h"
+#include "ar9330_1p2_initvals.h"
 #include "ar9485_initvals.h"
 #include "ar9580_1p0_initvals.h"
 
@@ -182,6 +183,26 @@ typedef long long unsigned int u64;
 
 #include "ar9330_11.ini"
 
+#define ar9331_modes_lowest_ob_db_tx_gain_hornet1_2		ar9331_modes_lowest_ob_db_tx_gain_1p2
+#define ar9331_hornet1_2_baseband_postamble			ar9331_1p2_baseband_postamble
+#define ar9331_modes_high_ob_db_tx_gain_hornet1_2		ar9331_modes_high_ob_db_tx_gain_1p2
+#define ar9331_modes_low_ob_db_tx_gain_hornet1_2		ar9331_modes_low_ob_db_tx_gain_1p2
+#define ar9331_hornet1_2_baseband_core_txfir_coeff_japan_2484	ar9331_1p2_baseband_core_txfir_coeff_japan_2484
+#define ar9331_hornet1_2_xtal_25M				ar9331_1p2_xtal_25M
+#define ar9331_hornet1_2_radio_core				ar9331_1p2_radio_core
+#define ar9331_hornet1_2_soc_postamble				ar9331_1p2_soc_postamble
+#define ar9331_common_wo_xlna_rx_gain_hornet1_2			ar9331_common_wo_xlna_rx_gain_1p2
+#define ar9331_hornet1_2_baseband_core				ar9331_1p2_baseband_core
+#define ar9331_modes_high_power_tx_gain_hornet1_2		ar9331_modes_high_power_tx_gain_1p2
+#define ar9331_hornet1_2_mac_postamble				ar9331_1p2_mac_postamble
+#define ar9331_hornet1_2_soc_preamble				ar9331_1p2_soc_preamble
+#define ar9331_hornet1_2_xtal_40M				ar9331_1p2_xtal_40M
+#define ar9331_hornet1_2_mac_core				ar9331_1p2_mac_core
+#define ar9331_common_rx_gain_hornet1_2				ar9331_common_rx_gain_1p2
+#define ar9331_common_tx_gain_offset1_2				ar9331_common_tx_gain_offset1_2
+
+#include "ar9330_12.ini"
+
 #define ar9485Common_poseidon1_0				ar9485Common_1_0
 #define ar9485_poseidon1_0_mac_postamble			ar9485_1_0_mac_postamble
 #define ar9485_poseidon1_0_pcie_phy_pll_on_clkreq_disable_L1	ar9485_1_0_pcie_phy_pll_on_clkreq_disable_L1
@@ -504,6 +525,28 @@ static void ar9330_1p1_hw_print_initvals(bool check)
 	INI_PRINT_ONEDIM(ar9331_1p1_chansel_xtal_40M);
 }
 
+static void ar9330_1p2_hw_print_initvals(bool check)
+{
+	u64 chksum;
+
+	INI_PRINT(ar9331_modes_lowest_ob_db_tx_gain_1p2);
+	INI_PRINT(ar9331_1p2_baseband_postamble);
+	INI_PRINT(ar9331_modes_high_ob_db_tx_gain_1p2);
+	INI_PRINT(ar9331_modes_low_ob_db_tx_gain_1p2);
+	INI_PRINT(ar9331_1p2_baseband_core_txfir_coeff_japan_2484);
+	INI_PRINT(ar9331_1p2_xtal_25M);
+	INI_PRINT(ar9331_1p2_radio_core);
+	INI_PRINT(ar9331_1p2_soc_postamble);
+	INI_PRINT(ar9331_common_wo_xlna_rx_gain_1p2);
+	INI_PRINT(ar9331_1p2_baseband_core);
+	INI_PRINT(ar9331_modes_high_power_tx_gain_1p2);
+	INI_PRINT(ar9331_1p2_mac_postamble);
+	INI_PRINT(ar9331_1p2_soc_preamble);
+	INI_PRINT(ar9331_1p2_xtal_40M);
+	INI_PRINT(ar9331_1p2_mac_core);
+	INI_PRINT(ar9331_common_rx_gain_1p2);
+}
+
 static void ar9485_hw_print_initvals(bool check)
 {
 	u64 chksum;
@@ -558,7 +601,7 @@ static void ar9580_1p0_hw_print_initvals(bool check)
 
 static void usage()
 {
-	printf("Usage: initvals [-w] [-f ar5008 | ar9001 | ar9002 | ar9003-2p2 | ar9300-1p1 | ar9485 | ar9580-1p0 ]\n");
+	printf("Usage: initvals [-w] [-f ar5008 | ar9001 | ar9002 | ar9003-2p2 | ar9300-1p1 | ar9300-1p2 | ar9485 | ar9580-1p0 ]\n");
 }
 
 print_initvals_family(char *family, bool check)
@@ -592,6 +635,15 @@ print_initvals_family(char *family, bool check)
 		ar9330_1p1_hw_print_initvals(check);
 		if (!check)
 			printf("#endif /* INITVALS_9330_1P1_H */\n");
+	} else if (strncmp(family, "ar9330-1p2", 10) == 0) {
+		if (!check) {
+			printf("#ifndef INITVALS_9330_1P2_H\n");
+			printf("#define INITVALS_9330_1P2_H\n");
+			printf("\n");
+		}
+		ar9330_1p2_hw_print_initvals(check);
+		if (!check)
+			printf("#endif /* INITVALS_9330_1P2_H */\n");
 	} else if (strncmp(family, "ar9485", 6) == 0) {
 		if (!check) {
 			printf("#ifndef INITVALS_9485_H\n");
@@ -630,6 +682,7 @@ int main(int argc, void *argv[])
 			ar9002_hw_print_initvals(false);
 			ar9003_2p2_hw_print_initvals(false);
 			ar9330_1p1_hw_print_initvals(false);
+			ar9330_1p2_hw_print_initvals(false);
 			ar9485_hw_print_initvals(false);
 			ar9580_1p0_hw_print_initvals(false);
 
@@ -659,6 +712,7 @@ int main(int argc, void *argv[])
 	ar9002_hw_print_initvals(true);
 	ar9003_2p2_hw_print_initvals(true);
 	ar9330_1p1_hw_print_initvals(true);
+	ar9330_1p2_hw_print_initvals(true);
 	ar9485_hw_print_initvals(true);
 	ar9580_1p0_hw_print_initvals(true);
 
-- 
1.7.2.1

