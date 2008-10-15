Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44050 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbYJOBZ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 21:25:58 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: enable 2.4/5GHz spectrum by eeprom bits.
Date: Wed, 15 Oct 2008 03:30:06 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>,
	John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810150330.07228.chunkeey@web.de> (sfid-20081015_032604_434100_ABAFC00D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a crash/badness in wireless-next / wireless-testing:
Badness at /home/proski/src/linux-2.6/net/mac80211/rx.c:2200
NIP: c02bc850 LR: c02ab268 CTR: 00000000
REGS: ef01fcc0 TRAP: 0700   Tainted: G        W  (2.6.27-wl)
MSR: 00029032 <EE,ME,IR,DR>  CR: 22004084  XER: 20000000
TASK = c1a58800[1778] 'p54pci' THREAD: ef01e000
[...]
NIP [c02bc850] __ieee80211_rx+0x17c/0x638
LR [c02ab268] ieee80211_tasklet_handler+0x104/0x120
Call Trace:
[ef01fd70] [c1a0c020] 0xc1a0c020 (unreliable)
[ef01fdb0] [c02ab268] ieee80211_tasklet_handler+0x104/0x120
[...]

the problem was that some older cards are mis-identified and didn't support
5GHz rates, while they have the right MAC & Synth chip.

This patch changes the way how p54 decides if it should enable 11a channels
or not.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
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
