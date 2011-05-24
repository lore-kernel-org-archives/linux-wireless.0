Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42061 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab1EXBiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 21:38:55 -0400
Date: Mon, 23 May 2011 20:38:52 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192se: Synchronize IRQ after disabling it
Message-ID: <4ddb0c2c.lUvN52nSGTJ6F/K5%Larry.Finger@lwfinger.net> (sfid-20110524_033857_214955_E7AAADE7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As suggested by Mike McCormack <mikem@ring3k.org> for rtl8192ce, make sure any IRQ
handlers running on other CPUs complete.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1226,6 +1226,7 @@ void rtl92se_disable_interrupt(struct ie
 	rtl_write_dword(rtlpriv, INTA_MASK + 4, 0);
 
 	rtlpci->irq_enabled = false;
+	synchronize_irq(rtlpci->pdev->irq);
 }
 
 
