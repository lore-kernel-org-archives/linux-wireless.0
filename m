Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4644 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2FTQr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 12:47:29 -0400
Date: Wed, 20 Jun 2012 11:47:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192se: Fix gcc 4.7.x warning
Message-ID: <4fe1fe9e.3UDPiX7pR6hIcQZf%Larry.Finger@lwfinger.net> (sfid-20120620_184740_202343_D1192944)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With gcc 4.7.x, the following warning is issued as the routine that sets
the array has the possibility of not initializing the values:
 
  CC [M]  drivers/net/wireless/rtlwifi/rtl8192se/phy.o
drivers/net/wireless/rtlwifi/rtl8192se/phy.c: In function ‘rtl92s_phy_set_txpower’:
drivers/net/wireless/rtlwifi/rtl8192se/phy.c:1268:23: warning: ‘ofdmpowerLevel[0]’ may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This problem exists for all versions of rtl8192se, but earlier compiler
versions did not detect it. For that reason, I am recommending this patch
be applied to 3.6.

Larry

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -1247,6 +1247,9 @@ static void _rtl92s_phy_get_txpower_inde
 		/* Read HT 40 OFDM TX power */
 		ofdmpowerLevel[0] = rtlefuse->txpwrlevel_ht40_2s[0][index];
 		ofdmpowerLevel[1] = rtlefuse->txpwrlevel_ht40_2s[1][index];
+	} else {
+		ofdmpowerLevel[0] = 0;
+		ofdmpowerLevel[1] = 0;
 	}
 }
 
