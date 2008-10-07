Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:42774 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbYJGP1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 11:27:48 -0400
Message-ID: <48EB7FF1.9060803@lwfinger.net> (sfid-20081007_172750_246231_5B10D181)
Date: Tue, 07 Oct 2008 08:27:45 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] p54: Fix compilation problem on PPC
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit entitled "p54: Fix sparse warnings" introduced a compile
error on PPC architecture. Thanks to Johannes Berg
<johannes@sipsolutions.net> for reporting this problem.

Signed-off-by: <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.28 material. I hope this comes through OK. I don't have
access to my usual way of submitting patches.

Larry
---

Johannes,

Do you have access to a p54 device, or were you just compile testing?
In my mind, there is still a big question regarding the endianness of
one of the data arrays.

Larry
---

Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -482,7 +482,6 @@ static int p54_parse_eeprom(struct ieee8
 	printk(KERN_ERR "p54: eeprom parse failed!\n");
 	return err;
 }
-EXPORT_SYMBOL_GPL(p54_parse_eeprom);

 static int p54_rssi_to_dbm(struct ieee80211_hw *dev, int rssi)
 {

