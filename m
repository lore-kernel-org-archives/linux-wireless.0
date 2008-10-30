Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:44575 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772AbYJ3AyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 20:54:10 -0400
Message-ID: <490905AC.9030800@lwfinger.net> (sfid-20081030_015413_038749_DE770821)
Date: Wed, 29 Oct 2008 17:54:04 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT PATCH 6/6] rtl8187: Reduce channel switch delay
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>
In-Reply-To: <49088F7D.8020102@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest vendor driver (rtl8187B_linux_26.1036.0708.2008) has a 10 msec
delay after the call to set a new channel, but not before.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -870,7 +870,6 @@ static int rtl8187_config(struct ieee802
 	 */
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF,
 			  reg | RTL818X_TX_CONF_LOOPBACK_MAC);
-	msleep(10);
 	priv->rf->set_chan(dev, conf);
 	msleep(10);
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);



