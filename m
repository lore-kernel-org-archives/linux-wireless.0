Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:36274 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbXJ0XUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 19:20:35 -0400
Date: Sun, 28 Oct 2007 02:20:33 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH 4/7] ath5k: Add SREV values for newer chips
Message-ID: <20071027232033.GD5973@localhost.domain.invalid> (sfid-20071028_002044_550942_3295DC39)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Add new Silicon Revision values (hex values written on chip) to be able to identify them.

* Give more infos about mac/phy/radio revision during attach.

Changes-licensed-under: 3-clause-BSD
Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 795d7dd..fa9f3ae 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -126,6 +126,18 @@ enum ath5k_radio {
 /*
  * Common silicon revision/version values
  */
+
+enum ath5k_srev_type {
+	AR5K_VERSION_VER,
+	AR5K_VERSION_RAD,
+};
+
+struct ath5k_srev_name {
+	const char		*sr_name;
+	enum ath5k_srev_type	sr_type;
+	u_int			sr_val;
+};
+
 #define AR5K_SREV_UNKNOWN	0xffff
 
 #define AR5K_SREV_VER_AR5210	0x00
@@ -135,7 +147,13 @@ enum ath5k_radio {
 #define AR5K_SREV_VER_AR5211	0x40
 #define AR5K_SREV_VER_AR5212	0x50
 #define AR5K_SREV_VER_AR5213	0x55
-#define AR5K_SREV_VER_UNSUPP	0x60
+#define AR5K_SREV_VER_AR5213A	0x59
+#define AR5K_SREV_VER_AR2424	0xa0
+#define AR5K_SREV_VER_AR5424	0xa3
+#define AR5K_SREV_VER_AR5413	0xa4
+#define AR5K_SREV_VER_AR5414	0xa5
+#define AR5K_SREV_VER_AR5416	0xc0	/* ? */
+#define AR5K_SREV_VER_AR5418	0xca
 
 #define AR5K_SREV_RAD_5110	0x00
 #define AR5K_SREV_RAD_5111	0x10
@@ -145,7 +163,9 @@ enum ath5k_radio {
 #define AR5K_SREV_RAD_5112A	0x35
 #define AR5K_SREV_RAD_2112	0x40
 #define AR5K_SREV_RAD_2112A	0x45
-#define AR5K_SREV_RAD_UNSUPP	0x50
+#define AR5K_SREV_RAD_SC1	0x63	/* Found on 5413/5414 */
+#define AR5K_SREV_RAD_SC2	0xa2	/* Found on 2424/5424 */
+#define AR5K_SREV_RAD_5133	0xc0	/* MIMO found on 5418 */
 
 /* IEEE defs */
 
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 382bb23..821ed44 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -201,6 +201,35 @@ static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
 
+/* Known SREVs */
+static struct ath5k_srev_name srev_names[] = {
+	{ "5210",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5210 },	
+	{ "5311",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311 },
+	{ "5311A",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311A },
+	{ "5311B",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311B },
+	{ "5211",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5211 },
+	{ "5212",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5212 },
+	{ "5213",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5213 },
+	{ "5213A",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5213A },
+	{ "2424",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2424 },
+	{ "5424",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5424 },
+	{ "5413",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5413 },
+	{ "5414",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5414 },
+	{ "5416",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5416 },
+	{ "5418",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5418 },
+	{ "xxxxx",	AR5K_VERSION_VER,	AR5K_SREV_UNKNOWN },
+	{ "5110",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5110 },
+	{ "5111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111 },
+	{ "2111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2111 },
+	{ "5112",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5112 },
+	{ "5112A",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5112A },
+	{ "2112",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112 },
+	{ "2112A",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112A },
+	{ "SChip",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_SC1 },
+	{ "SChip",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_SC2 },
+	{ "5133",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5133 },
+	{ "xxxxx",	AR5K_VERSION_RAD,	AR5K_SREV_UNKNOWN },
+};
 
 /*
  * Prototypes - PCI stack related functions
@@ -392,17 +421,21 @@ module_exit(exit_ath5k_pci);
 \********************/
 
 static const char *
-ath5k_chip_name(u8 mac_version)
+ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
 {
-	switch (mac_version) {
-	case AR5K_AR5210:
-		return "AR5210";
-	case AR5K_AR5211:
-		return "AR5211";
-	case AR5K_AR5212:
-		return "AR5212";
+	const char *name = "xxxxx";
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(srev_names); i++) {
+		if (srev_names[i].sr_type != type)
+			continue;
+		if ((val & 0xff) < srev_names[i + 1].sr_val) {
+			name = srev_names[i].sr_name;
+			break;
+		}
 	}
-	return "Unknown";
+
+	return name;
 }
 
 static int __devinit
@@ -535,10 +568,24 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto err_ah;
 
-	dev_info(&pdev->dev, "%s chip found: mac %d.%d phy %d.%d\n",
-			ath5k_chip_name(id->driver_data), sc->ah->ah_mac_version,
-			sc->ah->ah_mac_revision, sc->ah->ah_phy_revision >> 4,
-			sc->ah->ah_phy_revision & 0xf);
+	dev_info(&pdev->dev, "Atheros AR%s chip found: MAC 0x%x, PHY: 0x%x\n",
+			ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
+					sc->ah->ah_mac_srev,
+					sc->ah->ah_phy_revision);
+
+	if(sc->ah->ah_radio_5ghz_revision && !sc->ah->ah_radio_2ghz_revision){
+		dev_info(&pdev->dev, "RF%s radio found (0x%x)\n",
+			ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
+					sc->ah->ah_radio_5ghz_revision);
+	} else if(sc->ah->ah_radio_5ghz_revision && sc->ah->ah_radio_2ghz_revision){
+		dev_info(&pdev->dev, "RF%s 5GHz radio found (0x%x)\n",
+			ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_5ghz_revision),
+					sc->ah->ah_radio_5ghz_revision);
+		dev_info(&pdev->dev, "RF%s 2GHz radio found (0x%x)\n",
+			ath5k_chip_name(AR5K_VERSION_RAD,sc->ah->ah_radio_2ghz_revision),
+					sc->ah->ah_radio_2ghz_revision);
+	}
+
 
 	/* ready to process interrupts */
 	__clear_bit(ATH_STAT_INVALID, sc->status);


