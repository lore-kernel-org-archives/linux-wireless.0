Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37209 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946518Ab2LFSRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 13:17:34 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 09/13] qca-swiss-army-knife: simplify initval family handling
Date: Thu,  6 Dec 2012 19:17:23 +0100
Message-Id: <1354817847-23440-10-git-send-email-juhosg@openwrt.org> (sfid-20121206_191745_738501_7F32C53F)
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code contain lots of duplication in order to
print initval arrays for different families. Refactor the
code to get rid of the duplications. This makes the code
a bit clener, and adding support for a new family will be
easier as well.

Aslo update checksums.txt because the initvals for AR9462
are printed before AR9580.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/checksums.txt |   38 ++++----
 tools/initvals/initvals.c    |  199 ++++++++++++++++++------------------------
 2 files changed, 104 insertions(+), 133 deletions(-)

diff --git a/tools/initvals/checksums.txt b/tools/initvals/checksums.txt
index 5f18eb1..f02df5b 100644
--- a/tools/initvals/checksums.txt
+++ b/tools/initvals/checksums.txt
@@ -137,6 +137,25 @@ ca6088034f339ea8f106f7f034d34baafec0c0ca        ar9340Modes_high_ob_db_tx_gain_t
 58caac4e0a0184f6904d4adc7f7be8e528e6d0e3        ar9340_1p0_mac_core
 481b3066bd6b4dfa425027157f7c6252b535ebe4        ar9340Common_wo_xlna_rx_gain_table_1p0
 1b9f617ab8c10ec0760e81fe61d469692f2acc29        ar9340_1p0_soc_preamble
+d9efd1c575ac43d60c310d717c59617a5323c111        ar9462_modes_fast_clock_2p0
+8bf1688079add33889085f3d35a5fab61c33487f        ar9462_pciephy_clkreq_enable_L1_2p0
+8dacf543535b605143b40aef74f7d46af064cb43        ar9462_2p0_baseband_postamble
+d0f7aff1a1ab7e6f6bbda0da067714459341ce5f        ar9462_common_rx_gain_table_2p0
+bc232a96b4c1530bebe654420652a9f080a09db8        ar9462_pciephy_clkreq_disable_L1_2p0
+f4c2241d40995e09f8736ed2ef5eaa5d6f051aa5        ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
+057d1ee3d10321f1cc4d6c19cf1927e2ae56af28        ar9462_2p0_radio_postamble_sys2ant
+481b3066bd6b4dfa425027157f7c6252b535ebe4        ar9462_common_wo_xlna_rx_gain_table_2p0
+dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar9462_2p0_baseband_core_txfir_coeff_japan_2484
+a36b90fcdeeb4071fd090537f008f8091d885581        ar9462_modes_low_ob_db_tx_gain_table_2p0
+7c0a54aaf0f77f5bf048126e43feea746732d43f        ar9462_2p0_soc_postamble
+e87864956a7209224880cff035b4441b0ab3fbcc        ar9462_2p0_baseband_core
+b50d2fe654b069110bdbe06e5065f2aa9b117e3e        ar9462_2p0_radio_postamble
+5a98e71e601539bf31af7b9d18b210ab70f99dae        ar9462_modes_high_ob_db_tx_gain_table_2p0
+fd98d0361e085b102131c2dc07c601e0a7ccdd13        ar9462_2p0_radio_core
+3e60b14761abfa24d758727954d1d5cc398abf7f        ar9462_2p0_soc_preamble
+fc8623151293cc7739d0fb8e2873256749c74930        ar9462_2p0_mac_core
+c8dc777b012068116cd5282aade8eb460f397d20        ar9462_2p0_mac_postamble
+72675fd0f308e6f31502e283119e12469d262f40        ar9462_common_mixed_rx_gain_table_2p0
 c8dc777b012068116cd5282aade8eb460f397d20        ar9485_1_1_mac_postamble
 5d20e4848b97566ad55e0e95458463d622ee5480        ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1
 d9a90632a00a7b417154173b947dfffdeab23e51        ar9485Common_wo_xlna_rx_gain_1_1
@@ -193,22 +212,3 @@ d0f7aff1a1ab7e6f6bbda0da067714459341ce5f        ar9580_1p0_rx_gain_table
 0514ee3b3d014dc7110c616390a2fc5103b057f7        ar9580_1p0_pcie_phy_clkreq_enable_L1
 d0865f0cebcd7df2114a5626a3d0d19b8dae5710        ar9580_1p0_pcie_phy_clkreq_disable_L1
 45047f648d4c6138429f8bbc97680ac07f74ba62        ar9580_1p0_pcie_phy_pll_on_clkreq
-d9efd1c575ac43d60c310d717c59617a5323c111        ar9462_modes_fast_clock_2p0
-8bf1688079add33889085f3d35a5fab61c33487f        ar9462_pciephy_clkreq_enable_L1_2p0
-8dacf543535b605143b40aef74f7d46af064cb43        ar9462_2p0_baseband_postamble
-d0f7aff1a1ab7e6f6bbda0da067714459341ce5f        ar9462_common_rx_gain_table_2p0
-bc232a96b4c1530bebe654420652a9f080a09db8        ar9462_pciephy_clkreq_disable_L1_2p0
-f4c2241d40995e09f8736ed2ef5eaa5d6f051aa5        ar9462_pciephy_pll_on_clkreq_disable_L1_2p0
-057d1ee3d10321f1cc4d6c19cf1927e2ae56af28        ar9462_2p0_radio_postamble_sys2ant
-481b3066bd6b4dfa425027157f7c6252b535ebe4        ar9462_common_wo_xlna_rx_gain_table_2p0
-dfaefa89122b4b769bfcf93b4bd9569f2b0ee961        ar9462_2p0_baseband_core_txfir_coeff_japan_2484
-a36b90fcdeeb4071fd090537f008f8091d885581        ar9462_modes_low_ob_db_tx_gain_table_2p0
-7c0a54aaf0f77f5bf048126e43feea746732d43f        ar9462_2p0_soc_postamble
-e87864956a7209224880cff035b4441b0ab3fbcc        ar9462_2p0_baseband_core
-b50d2fe654b069110bdbe06e5065f2aa9b117e3e        ar9462_2p0_radio_postamble
-5a98e71e601539bf31af7b9d18b210ab70f99dae        ar9462_modes_high_ob_db_tx_gain_table_2p0
-fd98d0361e085b102131c2dc07c601e0a7ccdd13        ar9462_2p0_radio_core
-3e60b14761abfa24d758727954d1d5cc398abf7f        ar9462_2p0_soc_preamble
-fc8623151293cc7739d0fb8e2873256749c74930        ar9462_2p0_mac_core
-c8dc777b012068116cd5282aade8eb460f397d20        ar9462_2p0_mac_postamble
-72675fd0f308e6f31502e283119e12469d262f40        ar9462_common_mixed_rx_gain_table_2p0
diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 90ca377..35466bc 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -13,6 +13,14 @@
 typedef uint32_t u32;
 typedef long long unsigned int u64;
 
+struct initval_family {
+	const char *name;
+	const char *header_def;
+	const char *header_ver;
+
+	void (*print)(bool check);
+};
+
 /*
  * compile with -DATHEROS if you want to use the upstream Atheros initvals
  * and have them handy.
@@ -798,129 +806,102 @@ static void ar9565_1p0_hw_print_initvals(bool check)
 	INI_PRINT(ar9565_1p0_modes_high_power_tx_gain_table);
 }
 
-static void usage()
+#define FAM(_name, _def, _ver, _print) {	\
+	.name = _name,				\
+	.header_def = _def,			\
+	.header_ver = _ver,			\
+	.print = _print				\
+}
+
+struct initval_family families[] = {
+	FAM("ar5008"    , NULL      , NULL        , ar5008_hw_print_initvals),
+	FAM("ar9001"    , NULL      , NULL        , ar9001_hw_print_initvals),
+	FAM("ar9002"    , NULL      , NULL        , ar9002_hw_print_initvals),
+	FAM("ar9003-2p2", "9003_2P2", "AR9003 2.2", ar9003_2p2_hw_print_initvals),
+	FAM("ar9330-1p1", "9330_1P1", NULL        , ar9330_1p1_hw_print_initvals),
+	FAM("ar9330-1p2", "9330_1P2", NULL        , ar9330_1p2_hw_print_initvals),
+	FAM("ar9340"    , "9340"    , NULL        , ar9340_hw_print_initvals),
+	FAM("ar9462-2p0", "9462_2P0", "AR9462 2.0", ar9462_2p0_hw_print_initvals),
+	FAM("ar9485"    , "9485"    , "AR9485 1.1", ar9485_hw_print_initvals),
+	FAM("ar9565-1p0", "9565_1P0", "AR9565 1.0", ar9565_1p0_hw_print_initvals),
+	FAM("ar9580"    , "9580_1P0", "AR9580 1.0", ar9580_1p0_hw_print_initvals),
+};
+
+static struct initval_family *find_family(const char *name)
 {
-	printf("Usage: initvals [-w] "
-	       "[-f ar5008 | ar9001 | ar9002 | "
-	       "ar9003-2p2 | ar9330-1p1 | ar9330-1p2 | ar9462-2p0 | ar9485 | ar9580-1p0 | ar9565-1p0 ]\n");
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(families); i++) {
+		struct initval_family *fam;
+
+		fam = &families[i];
+		if (strncmp(fam->name, name, strlen(fam->name)) == 0)
+			return fam;
+	}
+
+	return NULL;
 }
 
-static void print_initvals_family(char *family, bool check)
+static void print_family(struct initval_family *family, bool check)
 {
-	if (!check)
+	if (!check) {
 		print_license();
 
-	if (strncmp(family, "ar5008", 6) == 0)
-		ar5008_hw_print_initvals(check);
-	else if (strncmp(family, "ar9001", 6) == 0)
-		ar9001_hw_print_initvals(check);
-	else if (strncmp(family, "ar9002", 6) == 0)
-		ar9002_hw_print_initvals(check);
-	else if (strncmp(family, "ar9003-2p2", 10) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9003_2P2_H\n");
-			printf("#define INITVALS_9003_2P2_H\n");
-			printf("\n");
-			printf("/* AR9003 2.2 */\n");
-			printf("\n");
-		}
-		ar9003_2p2_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9003_2P2_H */\n");
-	} else if (strncmp(family, "ar9330-1p1", 10) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9330_1P1_H\n");
-			printf("#define INITVALS_9330_1P1_H\n");
-			printf("\n");
-		}
-		ar9330_1p1_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9330_1P1_H */\n");
-	} else if (strncmp(family, "ar9330-1p2", 10) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9330_1P2_H\n");
-			printf("#define INITVALS_9330_1P2_H\n");
-			printf("\n");
-		}
-		ar9330_1p2_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9330_1P2_H */\n");
-	} else if (strncmp(family, "ar9340", 6) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9340_H\n");
-			printf("#define INITVALS_9340_H\n");
-			printf("\n");
-		}
-		ar9340_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9340_H */\n");
-	} else if (strncmp(family, "ar9485", 6) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9485_H\n");
-			printf("#define INITVALS_9485_H\n");
-			printf("\n");
-			printf("/* AR9485 1.1 */\n");
-			printf("\n");
-		}
-		ar9485_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9485_H */\n");
-	} else if (strncmp(family, "ar9580-1p0", 10) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9580_1P0_H\n");
-			printf("#define INITVALS_9580_1P0_H\n");
-			printf("\n");
-			printf("/* AR9580 1.0 */\n");
-			printf("\n");
-		}
-		ar9580_1p0_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9580_1P0_H */\n");
-	} else if (strncmp(family, "ar9462-2p0", 10) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9462_2P0_H\n");
-			printf("#define INITVALS_9462_2P0_H\n");
-			printf("\n");
-			printf("/* AR9462 2.0 */\n");
+		if (family->header_def) {
+			printf("#ifndef INITVALS_%s_H\n", family->header_def);
+			printf("#define INITVALS_%s_H\n", family->header_def);
 			printf("\n");
 		}
-		ar9462_2p0_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9462_2P0_H */\n");
-	} else if (strncmp(family, "ar9565-1p0", 10) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9565_1P0_H\n");
-			printf("#define INITVALS_9565_1P0_H\n");
-			printf("\n");
-			printf("/* AR9565 1.0 */\n");
+
+		if (family->header_ver) {
+			printf("/* %s */\n", family->header_ver);
 			printf("\n");
 		}
-		ar9565_1p0_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9565_1P0_H */\n");
 	}
+
+	family->print(check);
+
+	if (!check && family->header_def)
+		printf("#endif /* INITVALS_%s_H */\n", family->header_def);
 }
 
-int main(int argc, char *argv[])
+static void usage()
+{
+	int i;
+
+	printf("Usage: initvals [-w] [-f <family>]\n");
+	printf("valid <family> values:\n");
+	for (i = 0; i < ARRAY_SIZE(families); i++)
+		printf("\t%s\n", families[i].name);
+}
+
+static void print_initvals_family(char *name, bool check)
 {
+	struct initval_family *family;
 
+	family = find_family(name);
+	if (!family)
+		return;
+
+	print_family(family, check);
+}
+
+static void print_initvals_family_all(bool check)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(families); i++)
+		print_family(&families[i], check);
+}
+
+int main(int argc, char *argv[])
+{
 	if (argc > 1) {
 		if (argc == 2) {
 			if (strncmp(argv[1], "-w", 2) != 0)
 				return -1;
 
-			ar5008_hw_print_initvals(false);
-			ar9001_hw_print_initvals(false);
-			ar9002_hw_print_initvals(false);
-			ar9003_2p2_hw_print_initvals(false);
-			ar9330_1p1_hw_print_initvals(false);
-			ar9330_1p2_hw_print_initvals(false);
-			ar9340_hw_print_initvals(false);
-			ar9485_hw_print_initvals(false);
-			ar9565_1p0_hw_print_initvals(false);
-			ar9580_1p0_hw_print_initvals(false);
-			ar9462_2p0_hw_print_initvals(false);
-
+			print_initvals_family_all(false);
 			return 0;
 		}
 
@@ -942,17 +923,7 @@ int main(int argc, char *argv[])
 		return 0;
 	}
 
-	ar5008_hw_print_initvals(true);
-	ar9001_hw_print_initvals(true);
-	ar9002_hw_print_initvals(true);
-	ar9003_2p2_hw_print_initvals(true);
-	ar9330_1p1_hw_print_initvals(true);
-	ar9330_1p2_hw_print_initvals(true);
-	ar9340_hw_print_initvals(true);
-	ar9485_hw_print_initvals(true);
-	ar9565_1p0_hw_print_initvals(true);
-	ar9580_1p0_hw_print_initvals(true);
-	ar9462_2p0_hw_print_initvals(true);
+	print_initvals_family_all(true);
 
 	return 0;
 }
-- 
1.7.10

