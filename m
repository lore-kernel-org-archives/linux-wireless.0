Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:53302 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbYBYQxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 11:53:54 -0500
Received: from smtp2.int-evry.fr (smtp2.int-evry.fr [157.159.10.45])
	by smtp4.int-evry.fr (Postfix) with ESMTP id 7B278350A50
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 17:53:53 +0100 (CET)
Received: from smtp-ext.int-evry.fr (smtp-ext.int-evry.fr [157.159.11.17])
	by smtp2.int-evry.fr (Postfix) with ESMTP id A40873EDB98
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 17:53:51 +0100 (CET)
Received: from ibook (unknown [77.192.17.45])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-ext.int-evry.fr (Postfix) with ESMTP id 97BEE8D16A2
	for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 17:53:51 +0100 (CET)
From: Florian Fainelli <florian.fainelli@telecomint.eu>
Date: Mon, 25 Feb 2008 17:51:53 +0100
Subject: [PATCH] p54: print unknown eeprom fields
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802251751.53729.florian.fainelli@telecomint.eu> (sfid-20080225_165400_264524_86144F47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows p54common to print the
uknown EEPROM fields, which can help
when debugging/testing devices.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
diff --git a/drivers/net/wireless/p54common.c b/drivers/net/wireless/p54common.c
index 5cda49a..ea8cbc9 100644
--- a/drivers/net/wireless/p54common.c
+++ b/drivers/net/wireless/p54common.c
@@ -251,6 +251,10 @@ int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 		case PDR_END:
 			i = len;
 			break;
+		default:
+			printk(KERN_INFO "p54: unknown eeprom code : 0x%x\n",
+				le16_to_cpu(entry->code));
+			break;
 		}
 
 		entry = (void *)entry + (entry_len + 1)*2;
