Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34067 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1F3V3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:29:07 -0400
Date: Thu, 30 Jun 2011 16:28:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: akpm@linux-foundation.org, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192de/phy.c: fix udelay() usage
Message-ID: <4e0cea92.d87Od1Tkbar3iIK/%Larry.Finger@lwfinger.net> (sfid-20110630_232914_748049_DF3C8FA6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: drivers/net/wireless/rtlwifi/rtl8192de/phy.c: fix udelay() usage
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "__bad_udelay" [drivers/net/wireless/rtlwifi/rtl8192de/rtl8192de.ko] undefined!

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -1684,7 +1684,7 @@ static u8 _rtl92d_phy_patha_iqk(struct i
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		("Delay %d ms for One shot, path A LOK & IQK.\n",
 		IQK_DELAY_TIME));
-	udelay(IQK_DELAY_TIME * 1000);
+	mdelay(IQK_DELAY_TIME);
 	/* Check failed */
 	regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK, ("0xeac = 0x%x\n", regeac));
@@ -1755,7 +1755,7 @@ static u8 _rtl92d_phy_patha_iqk_5g_norma
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			("Delay %d ms for One shot, path A LOK & IQK.\n",
 			IQK_DELAY_TIME));
-		udelay(IQK_DELAY_TIME * 1000 * 10);
+		mdelay(IQK_DELAY_TIME * 10);
 		/* Check failed */
 		regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, ("0xeac = 0x%x\n", regeac));
@@ -1808,7 +1808,7 @@ static u8 _rtl92d_phy_pathb_iqk(struct i
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,
 		("Delay %d ms for One shot, path B LOK & IQK.\n",
 		IQK_DELAY_TIME));
-	udelay(IQK_DELAY_TIME * 1000);
+	mdelay(IQK_DELAY_TIME);
 	/* Check failed */
 	regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
 	RTPRINT(rtlpriv, FINIT, INIT_IQK, ("0xeac = 0x%x\n", regeac));
@@ -1875,7 +1875,7 @@ static u8 _rtl92d_phy_pathb_iqk_5g_norma
 		/* delay x ms */
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			("Delay %d ms for One shot, path B LOK & IQK.\n", 10));
-		udelay(IQK_DELAY_TIME * 1000 * 10);
+		mdelay(IQK_DELAY_TIME * 10);
 
 		/* Check failed */
 		regeac = rtl_get_bbreg(hw, 0xeac, BMASKDWORD);
@@ -2206,7 +2206,7 @@ static void _rtl92d_phy_iq_calibrate_5g_
 	 * PHY_REG.txt , and radio_a, radio_b.txt */
 
 	RTPRINT(rtlpriv, FINIT, INIT_IQK, ("IQK for 5G NORMAL:Start!!!\n"));
-	udelay(IQK_DELAY_TIME * 1000 * 20);
+	mdelay(IQK_DELAY_TIME * 20);
 	if (t == 0) {
 		bbvalue = rtl_get_bbreg(hw, RFPGA0_RFMOD, BMASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, ("==>0x%08x\n", bbvalue));
