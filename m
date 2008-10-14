Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:44336 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbYJNCh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 22:37:57 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Pavel Roskin <proski@gnu.org>
Subject: [RFC/RFT][PATCH] p54: enable 2.4/5GHz spectrum by eeprom bits.
Date: Tue, 14 Oct 2008 04:42:06 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <48EE20FB.4060700@lwfinger.net> <20081013212039.dy5fki5pck4g0cg4-cebfxv@webmail.spamcop.net> <200810140410.27397.chunkeey@web.de>
In-Reply-To: <200810140410.27397.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810140442.06244.chunkeey@web.de> (sfid-20081014_043801_541295_0265E72B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rather than setting the available bands by looking only at the phy-chip,
we now use bits in the eeprom, which indicates the real capabilities.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Christian Lamparter
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 0180466..48f91f3 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -306,8 +306,8 @@ static int p54_convert_rev1(struct ieee80211_hw *dev,
 	return 0;
 }
 
-static const char *p54_rf_chips[] = { "NULL", "Indigo?", "Duette",
-                              "Frisbee", "Xbow", "Longbow" };
+static const char *p54_rf_chips[] = { "NULL", "Duette3", "Duette2",
+                              "Frisbee", "Xbow", "Longbow", "NULL", "NULL" };
 static int p54_init_xbow_synth(struct ieee80211_hw *dev);
 
 static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
@@ -319,6 +319,7 @@ static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 	void *tmp;
 	int err;
 	u8 *end = (u8 *)eeprom + len;
+	u16 synth;
 	DECLARE_MAC_BUF(mac);
 
 	wrap = (struct eeprom_pda_wrap *) eeprom;
@@ -400,8 +401,8 @@ static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 			tmp = entry->data;
 			while ((u8 *)tmp < entry->data + data_len) {
 				struct bootrec_exp_if *exp_if = tmp;
-				if (le16_to_cpu(exp_if->if_id) == 0xF)
-					priv->rxhw = le16_to_cpu(exp_if->variant) & 0x07;
+				if (le16_to_cpu(exp_if->if_id) == 0xf)
+					synth = le16_to_cpu(exp_if->variant);
 				tmp += sizeof(struct bootrec_exp_if);
 			}
 			break;
@@ -427,22 +428,13 @@ static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		goto err;
 	}
 
-	switch (priv->rxhw) {
-	case 4: /* XBow */
+	priv->rxhw = synth & 0x07;
+	if (priv->rxhw == 4)
 		p54_init_xbow_synth(dev);
-	case 1: /* Indigo? */
-	case 2: /* Duette */
-		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
-	case 3: /* Frisbee */
-	case 5: /* Longbow */
+	if (!(synth & 0x40))
 		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band_2GHz;
-		break;
-	default:
-		printk(KERN_ERR "%s: unsupported RF-Chip\n",
-			wiphy_name(dev->wiphy));
-		err = -EINVAL;
-		goto err;
-	}
+	if (!(synth & 0x80))
+		dev->wiphy->bands[IEEE80211_BAND_5GHZ] = &band_5GHz;
 
 	if (!is_valid_ether_addr(dev->wiphy->perm_addr)) {
 		u8 perm_addr[ETH_ALEN];
