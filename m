Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vervifontaine.sonycom.com ([80.88.33.193]:58796 "EHLO
	pophost.sonytel.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751877Ab0A1MXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 07:23:38 -0500
From: Hamish Guthrie <hamish.guthrie@sonycom.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, geoffrey.levand@am.sony.com,
	cbe-oss-dev@ozlabs.org, Hamish Guthrie <hamish.guthrie@sonycom.com>
Subject: [PATCH 1/2] ps3_gelic_wireless: Remove PS3 gelic legacy wpa support
Date: Thu, 28 Jan 2010 12:54:09 +0100
Message-Id: <1264679650-14201-2-git-send-email-hamish.guthrie@sonycom.com>
In-Reply-To: <1264679650-14201-1-git-send-email-hamish.guthrie@sonycom.com>
References: <1264679650-14201-1-git-send-email-hamish.guthrie@sonycom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current PS3 gelic wireless driver has support for wireless
extensions. The original PS3 gelic wireless driver exposed a
dedicated API for a dedicated wpa_supplicant driver. This old
API could be enabled with CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE,
however, as this is not being used by any distros, and it is being
removed from the driver and from wpa_supplicant.

Signed-off-by: Hamish Guthrie <hamish.guthrie@sonycom.com>
---
 arch/powerpc/configs/ppc64_defconfig |    1 -
 arch/powerpc/configs/ps3_defconfig   |    1 -
 drivers/net/Kconfig                  |   14 ----
 drivers/net/ps3_gelic_wireless.c     |  137 ----------------------------------
 4 files changed, 0 insertions(+), 153 deletions(-)

diff --git a/arch/powerpc/configs/ppc64_defconfig b/arch/powerpc/configs/ppc64_defconfig
index 7b3804a..80e80ca 100644
--- a/arch/powerpc/configs/ppc64_defconfig
+++ b/arch/powerpc/configs/ppc64_defconfig
@@ -1000,7 +1000,6 @@ CONFIG_TIGON3=y
 CONFIG_SPIDER_NET=m
 CONFIG_GELIC_NET=m
 CONFIG_GELIC_WIRELESS=y
-# CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE is not set
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 # CONFIG_ATL1E is not set
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index 7de127e..32f7058 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -593,7 +593,6 @@ CONFIG_MII=m
 CONFIG_NETDEV_1000=y
 CONFIG_GELIC_NET=y
 CONFIG_GELIC_WIRELESS=y
-# CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE is not set
 # CONFIG_NETDEV_10000 is not set
 
 #
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index dd9a09c..953c3eb 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2356,20 +2356,6 @@ config GELIC_WIRELESS
 	  the driver automatically distinguishes the models, you can
 	  safely enable this option even if you have a wireless-less model.
 
-config GELIC_WIRELESS_OLD_PSK_INTERFACE
-       bool "PS3 Wireless private PSK interface (OBSOLETE)"
-       depends on GELIC_WIRELESS
-       select WEXT_PRIV
-       help
-          This option retains the obsolete private interface to pass
-          the PSK from user space programs to the driver.  The PSK
-          stands for 'Pre Shared Key' and is used for WPA[2]-PSK
-          (WPA-Personal) environment.
-          If WPA[2]-PSK is used and you need to use old programs that
-          support only this old interface, say Y.  Otherwise N.
-
-          If unsure, say N.
-
 config FSL_PQ_MDIO
 	tristate "Freescale PQ MDIO"
 	depends on FSL_SOC
diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 227b141..7571dbb 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -1389,113 +1389,6 @@ static int gelic_wl_get_mode(struct net_device *netdev,
 	return 0;
 }
 
-#ifdef CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE
-/* SIOCIWFIRSTPRIV */
-static int hex2bin(u8 *str, u8 *bin, unsigned int len)
-{
-	unsigned int i;
-	static unsigned char *hex = "0123456789ABCDEF";
-	unsigned char *p, *q;
-	u8 tmp;
-
-	if (len != WPA_PSK_LEN * 2)
-		return -EINVAL;
-
-	for (i = 0; i < WPA_PSK_LEN * 2; i += 2) {
-		p = strchr(hex, toupper(str[i]));
-		q = strchr(hex, toupper(str[i + 1]));
-		if (!p || !q) {
-			pr_info("%s: unconvertible PSK digit=%d\n",
-				__func__, i);
-			return -EINVAL;
-		}
-		tmp = ((p - hex) << 4) + (q - hex);
-		*bin++ = tmp;
-	}
-	return 0;
-};
-
-static int gelic_wl_priv_set_psk(struct net_device *net_dev,
-				 struct iw_request_info *info,
-				 union iwreq_data *data, char *extra)
-{
-	struct gelic_wl_info *wl = port_wl(netdev_priv(net_dev));
-	unsigned int len;
-	unsigned long irqflag;
-	int ret = 0;
-
-	pr_debug("%s:<- len=%d\n", __func__, data->data.length);
-	len = data->data.length - 1;
-	if (len <= 2)
-		return -EINVAL;
-
-	spin_lock_irqsave(&wl->lock, irqflag);
-	if (extra[0] == '"' && extra[len - 1] == '"') {
-		pr_debug("%s: passphrase mode\n", __func__);
-		/* pass phrase */
-		if (GELIC_WL_EURUS_PSK_MAX_LEN < (len - 2)) {
-			pr_info("%s: passphrase too long\n", __func__);
-			ret = -E2BIG;
-			goto out;
-		}
-		memset(wl->psk, 0, sizeof(wl->psk));
-		wl->psk_len = len - 2;
-		memcpy(wl->psk, &(extra[1]), wl->psk_len);
-		wl->psk_type = GELIC_EURUS_WPA_PSK_PASSPHRASE;
-	} else {
-		ret = hex2bin(extra, wl->psk, len);
-		if (ret)
-			goto out;
-		wl->psk_len = WPA_PSK_LEN;
-		wl->psk_type = GELIC_EURUS_WPA_PSK_BIN;
-	}
-	set_bit(GELIC_WL_STAT_WPA_PSK_SET, &wl->stat);
-out:
-	spin_unlock_irqrestore(&wl->lock, irqflag);
-	pr_debug("%s:->\n", __func__);
-	return ret;
-}
-
-static int gelic_wl_priv_get_psk(struct net_device *net_dev,
-				 struct iw_request_info *info,
-				 union iwreq_data *data, char *extra)
-{
-	struct gelic_wl_info *wl = port_wl(netdev_priv(net_dev));
-	char *p;
-	unsigned long irqflag;
-	unsigned int i;
-
-	pr_debug("%s:<-\n", __func__);
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	spin_lock_irqsave(&wl->lock, irqflag);
-	p = extra;
-	if (test_bit(GELIC_WL_STAT_WPA_PSK_SET, &wl->stat)) {
-		if (wl->psk_type == GELIC_EURUS_WPA_PSK_BIN) {
-			for (i = 0; i < wl->psk_len; i++) {
-				sprintf(p, "%02xu", wl->psk[i]);
-				p += 2;
-			}
-			*p = '\0';
-			data->data.length = wl->psk_len * 2;
-		} else {
-			*p++ = '"';
-			memcpy(p, wl->psk, wl->psk_len);
-			p += wl->psk_len;
-			*p++ = '"';
-			*p = '\0';
-			data->data.length = wl->psk_len + 2;
-		}
-	} else
-		/* no psk set */
-		data->data.length = 0;
-	spin_unlock_irqrestore(&wl->lock, irqflag);
-	pr_debug("%s:-> %d\n", __func__, data->data.length);
-	return 0;
-}
-#endif
-
 /* SIOCGIWNICKN */
 static int gelic_wl_get_nick(struct net_device *net_dev,
 				  struct iw_request_info *info,
@@ -2406,40 +2299,10 @@ static const iw_handler gelic_wl_wext_handler[] =
 	IW_IOCTL(SIOCGIWNICKN)		= gelic_wl_get_nick,
 };
 
-#ifdef CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE
-static struct iw_priv_args gelic_wl_private_args[] =
-{
-	{
-		.cmd = GELIC_WL_PRIV_SET_PSK,
-		.set_args = IW_PRIV_TYPE_CHAR |
-		(GELIC_WL_EURUS_PSK_MAX_LEN + 2),
-		.name = "set_psk"
-	},
-	{
-		.cmd = GELIC_WL_PRIV_GET_PSK,
-		.get_args = IW_PRIV_TYPE_CHAR |
-		(GELIC_WL_EURUS_PSK_MAX_LEN + 2),
-		.name = "get_psk"
-	}
-};
-
-static const iw_handler gelic_wl_private_handler[] =
-{
-	gelic_wl_priv_set_psk,
-	gelic_wl_priv_get_psk,
-};
-#endif
-
 static const struct iw_handler_def gelic_wl_wext_handler_def = {
 	.num_standard		= ARRAY_SIZE(gelic_wl_wext_handler),
 	.standard		= gelic_wl_wext_handler,
 	.get_wireless_stats	= gelic_wl_get_wireless_stats,
-#ifdef CONFIG_GELIC_WIRELESS_OLD_PSK_INTERFACE
-	.num_private		= ARRAY_SIZE(gelic_wl_private_handler),
-	.num_private_args	= ARRAY_SIZE(gelic_wl_private_args),
-	.private		= gelic_wl_private_handler,
-	.private_args		= gelic_wl_private_args,
-#endif
 };
 
 static struct net_device * __devinit gelic_wl_alloc(struct gelic_card *card)
-- 
1.6.2.4

