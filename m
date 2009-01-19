Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:58729 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZASNaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 08:30:20 -0500
From: Chr <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54: add missing break in eeprom parser
Date: Mon, 19 Jan 2009 14:30:26 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901191430.26101.chunkeey@web.de> (sfid-20090119_143026_304095_2F10D100)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a obvious memory leak in the eeprom parser.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,

can you please add this patch and "p54: more cryptographic accelerator fixes" to wireless-2.6 as well?
---
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index 6203105..2a515ef 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -545,8 +545,8 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 			}
 			if (err)
 				goto err;
-
-		}
+			}
+			break;
 		case PDR_PRISM_ZIF_TX_IQ_CALIBRATION:
 			priv->iq_autocal = kmalloc(data_len, GFP_KERNEL);
 			if (!priv->iq_autocal) {
