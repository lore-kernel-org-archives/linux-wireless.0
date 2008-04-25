Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms6.Sony.CO.JP ([211.125.136.204]:39366 "EHLO ms6.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbYDYFHp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 01:07:45 -0400
Received: from mta6.sony.co.jp (mta6.Sony.CO.JP [137.153.71.9])
 by ms6.sony.co.jp (R8/Sony) with ESMTP id m3P57ggQ020215
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:42 +0900 (JST)
Received: from mta6.sony.co.jp (localhost [127.0.0.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m3P57gO2014792
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:42 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m3P57gAG014787
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:42 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.4.141.32]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id m3P57gP18335 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:42 +0900 (JST)
Received: from [43.4.146.40] (bluenote.sm.sony.co.jp [43.4.146.40])
	by imail.sm.sony.co.jp (8.12.11/3.7W) with ESMTP id m3P57fDA025275
	for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:41 +0900 (JST)
Date: Fri, 25 Apr 2008 14:05:40 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] RFC: PS3: gelic: Deprecate the private ioctls in the gelic driver
In-Reply-To: <20080424204950.03DD.40F06B3A@sm.sony.co.jp>
References: <20080424204950.03DD.40F06B3A@sm.sony.co.jp>
Message-Id: <20080425140039.03FB.40F06B3A@sm.sony.co.jp> (sfid-20080425_070827_686494_D49C2B19)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the driver has the standard way to handle PSK, deprecate the old
PSK interface.

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

