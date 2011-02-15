Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1BOE2F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 23:28:05 -0500
Date: Mon, 14 Feb 2011 22:28:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Fix compile warning
Message-ID: <4d5a00d2./P3aAY/moiXTWkG7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If any of the p54-based drivers are built with CONFIG_P54_LEDS not
defined, the following warning is generated:

  CC [M]  drivers/net/wireless/p54/main.o
drivers/net/wireless/p54/main.c: In function ‘p54_register_common’:
drivers/net/wireless/p54/main.c:614:21: warning: unused variable ‘priv’

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-testing/drivers/net/wireless/p54/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/main.c
+++ wireless-testing/drivers/net/wireless/p54/main.c
@@ -611,7 +611,9 @@ EXPORT_SYMBOL_GPL(p54_init_common);
 
 int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
 {
+#ifdef CONFIG_P54_LEDS
 	struct p54_common *priv = dev->priv;
+#endif /* CONFIG_P54_LEDS */
 	int err;
 
 	err = ieee80211_register_hw(dev);
