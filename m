Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34258 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1IWD67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 23:58:59 -0400
Date: Thu, 22 Sep 2011 22:59:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: Fix unitialized struct
Message-ID: <4e7c0406.Bjq3rbwImv6FetjE%Larry.Finger@lwfinger.net> (sfid-20110923_055903_712516_810E702B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver rtl8192cu assigns a new struct rtl_tcb_desc object, but fails to
clear it.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@kernel.org>  [2.6.39+]
---

John,

s material is for 3.1.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
@@ -863,6 +863,7 @@ static void _rtl_usb_tx_preprocess(struc
 	u8 tid = 0;
 	u16 seq_number = 0;
 
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	if (ieee80211_is_auth(fc)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("MAC80211_LINKING\n"));
 		rtl_ips_nic_on(hw);
