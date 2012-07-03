Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46681 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964783Ab2GCQyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:54:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 05/10] qca-swiss-army-knife: simplify initval family handling
Date: Tue,  3 Jul 2012 18:42:50 +0200
Message-Id: <1341333775-14091-6-git-send-email-juhosg@openwrt.org> (sfid-20120703_185448_849638_64FEBF55)
In-Reply-To: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
References: <1341333775-14091-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code contain lots of duplication in order to
print initval arrays for different families. Refactor the
code to get rid of the duplications. This makes the code
a bit clener, and adding support for a new family will be
easier as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 tools/initvals/initvals.c |  182 ++++++++++++++++++++------------------------
 1 files changed, 83 insertions(+), 99 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index 4205b08..f28f2c9 100644
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
@@ -744,115 +752,100 @@ static void ar9462_2p0_hw_print_initvals(bool check)
 	INI_PRINT(ar9462_common_mixed_rx_gain_table_2p0);
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
+	FAM("ar9485"    , "9485"    , "AR9485 1.0", ar9485_hw_print_initvals),
+	FAM("ar9580"    , "9580_1P0", "AR9580 1.0", ar9580_1p0_hw_print_initvals),
+	FAM("ar9462-2p0", "9462_2P0", "AR9462 2.0", ar9462_2p0_hw_print_initvals),
+};
+
+static struct initval_family *find_family(const char *name)
 {
-	printf("Usage: initvals [-w] [-f ar5008 | ar9001 | ar9002 | ar9003-2p2 | ar9330-1p1 | ar9330-1p2 | ar9462-2p0 | ar9485 | ar9580-1p0 ]\n");
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
-			printf("#endif /* INITVALS_9340_1P0_H */\n");
-	} else if (strncmp(family, "ar9485", 6) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9485_H\n");
-			printf("#define INITVALS_9485_H\n");
-			printf("\n");
-			printf("/* AR9485 1.0 */\n");
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
+		if (family->header_def) {
+			printf("#ifndef INITVALS_%s_H\n", family->header_def);
+			printf("#define INITVALS_%s_H\n", family->header_def);
 			printf("\n");
 		}
-		ar9580_1p0_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9580_1P0_H */\n");
-	} else if (strncmp(family, "ar9462-2p0", 10) == 0) {
-		if (!check) {
-			printf("#ifndef INITVALS_9462_2P0_H\n");
-			printf("#define INITVALS_9462_2P0_H\n");
-			printf("\n");
-			printf("/* AR9462 2.0 */\n");
+		if (family->header_ver) {
+			printf("/* %s */\n", family->header_ver);
 			printf("\n");
 		}
-		ar9462_2p0_hw_print_initvals(check);
-		if (!check)
-			printf("#endif /* INITVALS_9462_2P0_H */\n");
 	}
+
+	family->print(check);
+
+	if (!check && family->header_def)
+		printf("#endif /* INITVALS_%s_H */\n", family->header_def);
 }
 
-int main(int argc, char *argv[])
+static void usage()
 {
+	int i;
 
+	printf("Usage: initvals [-w] [-f <family>]\n");
+	printf("valid <family> values:\n");
+	for (i = 0; i < ARRAY_SIZE(families); i++)
+		printf("\t%s\n", families[i].name);
+}
+
+static void print_initvals_family(char *name, bool check)
+{
+	struct initval_family *family;
+
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
-			ar9580_1p0_hw_print_initvals(false);
-			ar9462_2p0_hw_print_initvals(false);
-
+			print_initvals_family_all(false);
 			return 0;
 		}
 
@@ -874,16 +867,7 @@ int main(int argc, char *argv[])
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
-	ar9580_1p0_hw_print_initvals(true);
-	ar9462_2p0_hw_print_initvals(true);
+	print_initvals_family_all(true);
 
 	return 0;
 }
-- 
1.7.2.1

