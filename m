Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:39146 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYE3HxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 03:53:04 -0400
Received: from mta5.sony.co.jp (mta5.Sony.CO.JP [137.153.71.6])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m4U7r0w1019234
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:53:00 +0900 (JST)
Received: from mta5.sony.co.jp (localhost [127.0.0.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4U7r09A027016
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:53:00 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta5.sony.co.jp (R8/Sony) with ESMTP id m4U7r0Rc027004
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:53:00 +0900 (JST)
Date: Fri, 30 May 2008 16:52:55 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] PS3: gelic: Deprecate the private ioctls in the gelic driver
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20080530163019.4741.40F06B3A@sm.sony.co.jp>
References: <20080530163019.4741.40F06B3A@sm.sony.co.jp>
Message-Id: <20080530164650.4750.40F06B3A@sm.sony.co.jp> (sfid-20080530_095308_175845_2F08E58E)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the driver has the standard way to handle PSK, deprecate the old
interface.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/Kconfig              |   13 +++++++++++++
 drivers/net/ps3_gelic_wireless.c |    6 ++++++
 2 files changed, 19 insertions(+)

--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2297,6 +2297,19 @@ config GELIC_WIRELESS
 	  the driver automatically distinguishes the models, you can
 	  safely enable this option even if you have a wireless-less model.
 
+config GELIC_WIRELESS_OLD_PSK_INTERFACE
+       bool "PS3 Wireless private PSK interface (OBSOLETE)"
+       depends on GELIC_WIRELESS
+       help
+          This option retains the obsolete private interface to pass
+          the PSK from user space programs to the driver.  The PSK
+          stands for 'Pre Shared Key' and is used for WPA[2]-PSK
+          (WPA-Personal) environment.
+          If WPA[2]-PSK is used and you need to use old programs that
+          support only this old interface, say Y.  Otherwise N.
+
+          If unsure, say N.
+
 config GIANFAR
 	tristate "Gianfar Ethernet"
 	depends on FSL_SOC
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1375,6 +1375,7 @@ static int gelic_wl_get_mode(struct net_
 	return 0;
 }
 
+#ifdef CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE
 /* SIOCIWFIRSTPRIV */
 static int hex2bin(u8 *str, u8 *bin, unsigned int len)
 {
@@ -1479,6 +1480,7 @@ static int gelic_wl_priv_get_psk(struct 
 	pr_debug("%s:-> %d\n", __func__, data->data.length);
 	return 0;
 }
+#endif
 
 /* SIOCGIWNICKN */
 static int gelic_wl_get_nick(struct net_device *net_dev,
@@ -2329,6 +2331,7 @@ static const iw_handler gelic_wl_wext_ha
 	IW_IOCTL(SIOCGIWNICKN)		= gelic_wl_get_nick,
 };
 
+#ifdef CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE
 static struct iw_priv_args gelic_wl_private_args[] =
 {
 	{
@@ -2350,15 +2353,18 @@ static const iw_handler gelic_wl_private
 	gelic_wl_priv_set_psk,
 	gelic_wl_priv_get_psk,
 };
+#endif
 
 static const struct iw_handler_def gelic_wl_wext_handler_def = {
 	.num_standard		= ARRAY_SIZE(gelic_wl_wext_handler),
 	.standard		= gelic_wl_wext_handler,
 	.get_wireless_stats	= gelic_wl_get_wireless_stats,
+#ifdef CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE
 	.num_private		= ARRAY_SIZE(gelic_wl_private_handler),
 	.num_private_args	= ARRAY_SIZE(gelic_wl_private_args),
 	.private		= gelic_wl_private_handler,
 	.private_args		= gelic_wl_private_args,
+#endif
 };
 
 static struct net_device *gelic_wl_alloc(struct gelic_card *card)

