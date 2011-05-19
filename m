Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934830Ab1ESVfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 17:35:55 -0400
Date: Thu, 19 May 2011 16:35:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: zajec5@gmail.com, John W Linville <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Fix bogus compilation warning for phy_n
Message-ID: <4dd58d39.ev8WALmbdvCfJmAJ%Larry.Finger@lwfinger.net> (sfid-20110519_233658_391766_B99DDA1C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cross-compiling the 2.6.39 wireless-testing source using GCC version
(SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291] on an x86_64 system,
the following warning is issued:

  CC [M]  drivers/net/wireless/b43/phy_n.o
drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_cal_tx_iq_lo’:
drivers/net/wireless/b43/phy_n.c:3096: warning: ‘last’ may be used
        uninitialized in this function

A quick look at the code shows that the warning is bogus and a gcc bug,
but to ensure clean compilation for all users, mark the offending variable
as uninitialized.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/b43/phy_n.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/b43/phy_n.c
+++ wireless-testing-new/drivers/net/wireless/b43/phy_n.c
@@ -3093,7 +3093,7 @@ static int b43_nphy_cal_tx_iq_lo(struct
 	int freq;
 	bool avoid = false;
 	u8 length;
-	u16 tmp, core, type, count, max, numb, last, cmd;
+	u16 tmp, core, type, count, max, numb, uninitialized_var(last), cmd;
 	const u16 *table;
 	bool phy6or5x;
 
