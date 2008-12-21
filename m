Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50200 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYLUWgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 17:36:33 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT] p54: regulatory domain hint
Date: Sun, 21 Dec 2008 23:36:30 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812212336.31267.chunkeey@web.de> (sfid-20081221_233637_257920_52437B65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a sub-routine that parses the default country eeprom entry
and forwards the obtained Alpha2 identifier to the regulatory sub-system.

Luis,

I've a question about the regulatory domain numbers. (ref: 802.11-2007 14.8.2.2)
As far as I can see zd1211rw driver (zd_mac.c) uses them to determine the country as well.
So, how should I/we deal with this?

Would you support a common helper function with a fixed list - like the one in zd_mac.c (or in this patch) -
which takes regDomain values and converts them into alpha2?
Or do you have a secret plan instead?

Regards,
	Chr
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-21 22:31:57.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-21 22:42:04.000000000 +0100
@@ -128,6 +128,20 @@ static struct ieee80211_supported_band b
 	.n_bitrates = ARRAY_SIZE(p54_arates),
 };
 
+const static struct {
+	u8 reg;
+	char alpha2[2];
+} p54_reg_to_alpha2[] = {
+	{ PDR_COUNTRY_REGDOMAIN_FCC, "US" },
+	{ PDR_COUNTRY_REGDOMAIN_IC, "CA" },
+	{ PDR_COUNTRY_REGDOMAIN_ETSI, "DE" },	/* Generic ETSI, use most restrictive */
+	{ PDR_COUNTRY_REGDOMAIN_SPAIN, "ES" },
+	{ PDR_COUNTRY_REGDOMAIN_FRANCE, "FR" },
+	{ PDR_COUNTRY_REGDOMAIN_MKK13, "JP" },
+	{ PDR_COUNTRY_REGDOMAIN_MKK, "JP" },
+	{ PDR_COUNTRY_REGDOMAIN_CHINA, "CN" },
+};
+
 int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 {
 	struct p54_common *priv = dev->priv;
@@ -365,6 +379,37 @@ static void p54_parse_rssical(struct iee
 	}
 }
 
+static void p54_parse_default_country(struct ieee80211_hw *dev,
+				      void *data, int len)
+{
+	struct pda_country *country;
+	int i;
+
+	if (len != sizeof(*country)) {
+		printk(KERN_ERR "%s: invalid default country eeprom entry"
+				 " len:%d.\n",
+		       wiphy_name(dev->wiphy), len);
+
+		print_hex_dump_bytes("country:", DUMP_PREFIX_NONE,
+				     data, len);
+
+		printk(KERN_ERR "%s: please report this issue.\n",
+			wiphy_name(dev->wiphy));
+		return;
+	}
+
+	country = (struct pda_country *) data;
+	if (country->flags == PDR_COUNTRY_CERT_CODE_PSEUDO)
+		regulatory_hint(dev->wiphy, country->alpha2);
+	else {
+		for (i = 0; i < ARRAY_SIZE(p54_reg_to_alpha2); i++) {
+			if (country->regdomain == p54_reg_to_alpha2[i].reg)
+				regulatory_hint(dev->wiphy, (char *)
+						p54_reg_to_alpha2[i].alpha2);
+		}
+	}
+}
+
 static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
@@ -453,6 +498,9 @@ static int p54_parse_eeprom(struct ieee8
 			memcpy(priv->iq_autocal, entry->data, data_len);
 			priv->iq_autocal_len = data_len / sizeof(struct pda_iq_autocal_entry);
 			break;
+		case PDR_DEFAULT_COUNTRY:
+			p54_parse_default_country(dev, entry->data, data_len);
+			break;
 		case PDR_INTERFACE_LIST:
 			tmp = entry->data;
 			while ((u8 *)tmp < entry->data + data_len) {
@@ -487,7 +535,6 @@ static int p54_parse_eeprom(struct ieee8
 		case PDR_UTF8_OEM_NAME:
 		case PDR_UTF8_PRODUCT_NAME:
 		case PDR_COUNTRY_LIST:
-		case PDR_DEFAULT_COUNTRY:
 		case PDR_ANTENNA_GAIN:
 		case PDR_PRISM_INDIGO_PA_CALIBRATION_DATA:
 		case PDR_REGULATORY_POWER_LIMITS:
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-21 20:44:12.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-21 22:14:44.000000000 +0100
@@ -180,6 +180,12 @@ struct pda_rssi_cal_entry {
 	__le16 add;
 } __attribute__ ((packed));
 
+struct pda_country {
+	u8 regdomain;
+	u8 alpha2[2];
+	u8 flags;
+} __attribute__ ((packed));
+
 /*
  * this defines the PDR codes used to build PDAs as defined in document
  * number 553155. The current implementation mirrors version 1.1 of the
@@ -229,6 +235,17 @@ struct pda_rssi_cal_entry {
 #define PDR_PER_CHANNEL_BASEBAND_REGISTERS	0x8001
 
 /* PDR definitions for default country & country list */
+
+/* RegDomains as in 802.11-2007, 14.8.2.2 Table 14-23 */
+#define PDR_COUNTRY_REGDOMAIN_FCC	0x10
+#define PDR_COUNTRY_REGDOMAIN_IC	0x20
+#define PDR_COUNTRY_REGDOMAIN_ETSI	0x30
+#define PDR_COUNTRY_REGDOMAIN_SPAIN	0x31
+#define PDR_COUNTRY_REGDOMAIN_FRANCE	0x32
+#define PDR_COUNTRY_REGDOMAIN_MKK	0x40    /* channel 14 only */
+#define PDR_COUNTRY_REGDOMAIN_MKK13	0x41    /* channel 1 to 13 */
+#define PDR_COUNTRY_REGDOMAIN_CHINA	0x50
+
 #define PDR_COUNTRY_CERT_CODE		0x80
 #define PDR_COUNTRY_CERT_CODE_REAL	0x00
 #define PDR_COUNTRY_CERT_CODE_PSEUDO	0x80
