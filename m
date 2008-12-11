Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48143 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYLKCNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 21:13:34 -0500
Date: Wed, 10 Dec 2008 19:59:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Fix for change in STA handling in mac80211
Message-ID: <49407404.WzMzB28hDBCaCLlQ%Larry.Finger@lwfinger.net> (sfid-20081211_031340_832983_5B332120)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After commit ca247d5f50acd4fc6fdc1dec770e726b0d7eda60 "mac80211: only create
default STA interface if supported", rtl8187 stopped working because the
add_interface callback was not called. For reasons that I do not understand,
the IFTYPE_ADHOC bit, as well as the IFTYPE_STATION bit, must be set in the
interface_modes variable.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This should be added to wireless-testing as soon as possible.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1429,7 +1429,10 @@ static int __devinit rtl8187_probe(struc
 	 * XXX: Once this driver supports anything that requires
 	 *	beacons it must implement IEEE80211_TX_CTL_ASSIGN_SEQ.
 	 */
-	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	dev->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+
 
 	if ((id->driver_info == DEVICE_RTL8187) && priv->is_rtl8187b)
 		printk(KERN_INFO "rtl8187: inconsistency between id with OEM"
