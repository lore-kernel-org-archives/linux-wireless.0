Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2CBTWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 14:22:47 -0500
Date: Fri, 02 Mar 2012 13:22:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] rtlwifi: Remove extraneous value return
Message-ID: <4f511e06.+x7NykIn4d9VxOtA%Larry.Finger@lwfinger.net> (sfid-20120302_202250_419588_DE24B18F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In usb.c, routine _rtl_usb_init_sw() always returns 0, and rtl_usb_probe()
never checks the returned value. Thus we can change _rtl_usb_init_sw() to
a void routine. In addition, remove the underscore at the beginning of the
name of the routine.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch also needs no priority.

Larry
---

 usb.c |    5 ++---                                                                                                                                          
 1 file changed, 2 insertions(+), 3 deletions(-)                                                                                                             ---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -362,7 +362,7 @@ static int _rtl_usb_init(struct ieee8021
 	return err;
 }
 
-static int _rtl_usb_init_sw(struct ieee80211_hw *hw)
+static void rtl_usb_init_sw(struct ieee80211_hw *hw)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -397,7 +397,6 @@ static int _rtl_usb_init_sw(struct ieee8
 	/* HIMR_EX - turn all on */
 	rtlusb->irq_mask[1] = 0xFFFFFFFF;
 	rtlusb->disableHWSM =  true;
-	return 0;
 }
 
 #define __RADIO_TAP_SIZE_RSV	32
@@ -983,7 +982,7 @@ int __devinit rtl_usb_probe(struct usb_i
 	err = _rtl_usb_init(hw);
 	if (err)
 		goto error_out;
-	err = _rtl_usb_init_sw(hw);
+	rtl_usb_init_sw(hw);
 	/* Init mac80211 sw */
 	err = rtl_init_core(hw);
 	if (err) {
