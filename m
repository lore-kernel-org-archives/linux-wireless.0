Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34331 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbYLZUuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 15:50:39 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: regulatory domain hints
Date: Fri, 26 Dec 2008 21:50:33 +0100
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812262150.33455.chunkeey@web.de> (sfid-20081226_215058_617203_00A63722)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a sub-routine that parses the default country eeprom entry
and forwards the obtained Alpha2 identifier to the regulatory sub-system.

Note: I dropped the p54 specific regdomain<->alpha2 conversion code for now.
But it will be added as soon as there's the common library function is ready.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-12-26 17:54:47.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-12-26 21:17:42.000000000 +0100
@@ -365,6 +365,36 @@ static void p54_parse_rssical(struct iee
 	}
 }
 
+static void p54_parse_default_country(struct ieee80211_hw *dev,
+				      void *data, int len)
+{
+	struct pda_country *country;
+
+	if (len != sizeof(*country)) {
+		printk(KERN_ERR "%s: found possible invalid default country "
+				"eeprom entry. (entry size: %d)\n",
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
+		/* TODO:
+		 * write a shared/common function that converts
+		 * "Regulatory domain codes" (802.11-2007 14.8.2.2)
+		 * into ISO/IEC 3166-1 alpha2 for regulatory_hint.
+		 */
+	}
+}
+
 static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
@@ -453,6 +483,9 @@ static int p54_parse_eeprom(struct ieee8
 			memcpy(priv->iq_autocal, entry->data, data_len);
 			priv->iq_autocal_len = data_len / sizeof(struct pda_iq_autocal_entry);
 			break;
+		case PDR_DEFAULT_COUNTRY:
+			p54_parse_default_country(dev, entry->data, data_len);
+			break;
 		case PDR_INTERFACE_LIST:
 			tmp = entry->data;
 			while ((u8 *)tmp < entry->data + data_len) {
@@ -487,7 +520,6 @@ static int p54_parse_eeprom(struct ieee8
 		case PDR_UTF8_OEM_NAME:
 		case PDR_UTF8_PRODUCT_NAME:
 		case PDR_COUNTRY_LIST:
-		case PDR_DEFAULT_COUNTRY:
 		case PDR_ANTENNA_GAIN:
 		case PDR_PRISM_INDIGO_PA_CALIBRATION_DATA:
 		case PDR_REGULATORY_POWER_LIMITS:
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-12-26 17:54:34.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-12-26 21:19:13.000000000 +0100
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
