Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57037 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1BOPhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 10:37:08 -0500
Date: Tue, 15 Feb 2011 09:37:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V2] p54: Fix compile warning
Message-ID: <4d5a9da2.T52RN9mbp1TlCDQm%Larry.Finger@lwfinger.net>
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

V2 - use __maybe_unused instead of conditional compilation

---

Index: wireless-testing/drivers/net/wireless/p54/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/main.c
+++ wireless-testing/drivers/net/wireless/p54/main.c
@@ -611,7 +611,7 @@ EXPORT_SYMBOL_GPL(p54_init_common);
 
 int p54_register_common(struct ieee80211_hw *dev, struct device *pdev)
 {
-	struct p54_common *priv = dev->priv;
+	struct p54_common __maybe_unused *priv = dev->priv;
 	int err;
 
 	err = ieee80211_register_hw(dev);
