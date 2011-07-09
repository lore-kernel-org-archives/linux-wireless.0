Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1GISQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 14:16:02 -0400
Date: Sat, 09 Jul 2011 13:15:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: dcb314@hotmail.com, george0505@realtek.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Fix duplicate if test
Message-ID: <4e189ade.j4swrYauTmJhQVet%Larry.Finger@lwfinger.net> (sfid-20110709_201636_890950_72D30851)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A typo causes routine rtl92cu_phy_rf6052_set_cck_txpower() to test the
same condition twice. The problem was found using cppcheck-1.49, and the
proper fix was verified against the pre-mac80211 version of the code.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable <stable@kernel.org>  [back to 2.6.39]
---

John,

Obviously, this is a bug in 3.0 and 2.6.39, but it has a minor impact.
I think we should just push it to 3.1 and let stable get it for the
earlier versions, but as usual, it is your call.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -104,7 +104,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(
 			tx_agc[RF90_PATH_A] = 0x10101010;
 			tx_agc[RF90_PATH_B] = 0x10101010;
 		} else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
-			   TXHIGHPWRLEVEL_LEVEL1) {
+			   TXHIGHPWRLEVEL_LEVEL2) {
 			tx_agc[RF90_PATH_A] = 0x00000000;
 			tx_agc[RF90_PATH_B] = 0x00000000;
 		} else{
