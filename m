Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64298 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1F3Vot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:44:49 -0400
Date: Thu, 30 Jun 2011 16:44:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] rtlwifi: rtl8192de: Remove irq_enabled boolean
Message-ID: <4e0cee4f.pS2lhGs66g9mS0sR%Larry.Finger@lwfinger.net> (sfid-20110630_234452_585955_20DE3226)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepare rtl8192de for the removal of irq_enaqbled.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This material is for 3.1.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1221,7 +1221,6 @@ void rtl92de_enable_interrupt(struct iee
 
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
 	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
-	rtlpci->irq_enabled = true;
 }
 
 void rtl92de_disable_interrupt(struct ieee80211_hw *hw)
@@ -1231,7 +1230,6 @@ void rtl92de_disable_interrupt(struct ie
 
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
-	rtlpci->irq_enabled = false;
 	synchronize_irq(rtlpci->pdev->irq);
 }
 
