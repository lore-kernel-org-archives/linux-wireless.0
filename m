Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:54065 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1HOFI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 01:08:29 -0400
From: Lin Tony-B19295 <B19295@freescale.com>
To: Hauke Mehrtens <hauke@hauke-m.de>,
	"mcgrof@gmail.com" <mcgrof@gmail.com>,
	"lrodriguez@atheros.com" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
Date: Mon, 15 Aug 2011 05:06:32 +0000
Message-ID: <97D3A72708D04647A5AC84A04996E5B5193114@039-SN1MPN1-002.039d.mgd.msft.net> (sfid-20110815_070850_054303_C966850A)
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Where can I get corresponding firmware?

tony

> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Hauke Mehrtens
> Sent: Thursday, August 11, 2011 6:59 PM
> To: mcgrof@gmail.com; lrodriguez@atheros.com
> Cc: linux-wireless@vger.kernel.org; Hauke Mehrtens
> Subject: [PATCH 1/2] compat-wireless: ath6kl moved to main area.
> 
> ath6kl is now in the kernel main area and not in staging any more.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  Makefile                                |    1 -
>  config.mk                               |   15 +++------
>  patches/01-netdev.patch                 |   17 +++++++++--
>  patches/34-backport-bin_attribute.patch |   47 -------------------------
> ------
>  scripts/admin-update.sh                 |    4 +-
>  5 files changed, 21 insertions(+), 63 deletions(-)  delete mode 100644
> patches/34-backport-bin_attribute.patch
> 
> diff --git a/Makefile b/Makefile
> index 9c95292..463a56c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -33,7 +33,6 @@ obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
>  obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/ssb/ drivers/bcma/
> drivers/misc/eeprom/
> 
>  ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
> -obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/ath6kl/
>  obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/brcm80211/  endif
> 
> diff --git a/config.mk b/config.mk
> index 786891d..27d4daf 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -570,24 +570,19 @@ CONFIG_IWM=m
>  CONFIG_BT_HCIBTSDIO=m
>  CONFIG_BT_MRVL_SDIO=m
> 
> +ifndef CONFIG_COMPAT_KERNEL_2_6_27
> +CONFIG_ATH6KL=m
> +# CONFIG_ATH6KL_DEBUG=y
> +endif #CONFIG_COMPAT_KERNEL_2_6_27
> +
>  ifdef CONFIG_COMPAT_STAGING
>  ifdef CONFIG_WIRELESS_EXT
> -# CONFIG_ATH6KL_DISABLE_TARGET_DBGLOGS is not set -#
> CONFIG_ATH6KL_ENABLE_COEXISTENCE is not set -#
> CONFIG_ATH6KL_ENABLE_HOST_DEBUG is not set -
> CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
> -# CONFIG_ATH6KL_HCI_BRIDGE is not set
> -# CONFIG_ATH6KL_HTC_RAW_INTERFACE is not set -#
> CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK is not set -
> CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
> -CONFIG_ATH6K_LEGACY=m
> 
>  CONFIG_BRCMFMAC=m
> 
>  endif #CONFIG_WIRELESS_EXT
>  endif #CONFIG_COMPAT_STAGING
> 
> -
>  endif #CONFIG_MMC
> 
>  CONFIG_RTLWIFI=m
> diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch index
> f8395c8..d500584 100644
> --- a/patches/01-netdev.patch
> +++ b/patches/01-netdev.patch
> @@ -32,6 +32,17 @@ without creating a headache on maintenance of the
> pathes.
>   	net->watchdog_timeo = TX_TIMEOUT_JIFFIES;
>   	net->ethtool_ops = &usbnet_ethtool_ops;
> 
> +--- a/drivers/net/wireless/ath/ath6kl/main.c
> ++++ b/drivers/net/wireless/ath/ath6kl/main.c
> +@@ -1325,7 +1325,7 @@ static struct net_device_ops ath6kl_netd
> +
> + void init_netdev(struct net_device *dev)  {
> +-	dev->netdev_ops = &ath6kl_netdev_ops;
> ++	netdev_attach_ops(dev, &ath6kl_netdev_ops);
> + 	dev->watchdog_timeo = ATH6KL_TX_TIMEOUT;
> +
> + 	dev->needed_headroom = ETH_HLEN;
>  --- a/drivers/net/wireless/rndis_wlan.c
>  +++ b/drivers/net/wireless/rndis_wlan.c
>  @@ -3439,7 +3439,7 @@ static int rndis_wlan_bind(struct usbnet @@ -217,7
> +228,7 @@ without creating a headache on maintenance of the pathes.
>   	wdev->netdev = ndev;
>  --- a/drivers/net/wireless/libertas/main.c
>  +++ b/drivers/net/wireless/libertas/main.c
> -@@ -836,7 +836,7 @@ struct lbs_private *lbs_add_card(void *c
> +@@ -916,7 +916,7 @@ struct lbs_private *lbs_add_card(void *c
>   	wdev->netdev = dev;
>   	priv->dev = dev;
> 
> @@ -228,7 +239,7 @@ without creating a headache on maintenance of the
> pathes.
>   	dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
>  --- a/drivers/net/wireless/libertas/mesh.c
>  +++ b/drivers/net/wireless/libertas/mesh.c
> -@@ -1011,7 +1011,7 @@ static int lbs_add_mesh(struct lbs_priva
> +@@ -1018,7 +1018,7 @@ static int lbs_add_mesh(struct lbs_priva
>   	mesh_dev->ieee80211_ptr = mesh_wdev;
>   	priv->mesh_dev = mesh_dev;
> 
> @@ -256,7 +267,7 @@ without creating a headache on maintenance of the
> pathes.
>   #define LBS_DEB_LEAVE	0x00000002
>  --- a/drivers/net/wireless/mac80211_hwsim.c
>  +++ b/drivers/net/wireless/mac80211_hwsim.c
> -@@ -1230,7 +1230,7 @@ static const struct net_device_ops hwsim
> +@@ -1236,7 +1236,7 @@ static const struct net_device_ops hwsim
> 
>   static void hwsim_mon_setup(struct net_device *dev)
>   {
> diff --git a/patches/34-backport-bin_attribute.patch b/patches/34-
> backport-bin_attribute.patch
> deleted file mode 100644
> index 1ca0b4d..0000000
> --- a/patches/34-backport-bin_attribute.patch
> +++ /dev/null
> @@ -1,47 +0,0 @@
> ---- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> -+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> -@@ -317,12 +317,20 @@ static void ar6000_refill_amsdu_rxbufs(s
> - static void ar6000_cleanup_amsdu_rxbufs(struct ar6_softc *ar);
> -
> - static ssize_t
> -+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34))
> - ar6000_sysfs_bmi_read(struct file *fp, struct kobject *kobj,
> -+#else
> -+ar6000_sysfs_bmi_read(struct kobject *kobj, #endif
> -                       struct bin_attribute *bin_attr,
> -                       char *buf, loff_t pos, size_t count);
> -
> - static ssize_t
> -+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34))
> - ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
> -+#else
> -+ar6000_sysfs_bmi_write(struct kobject *kobj, #endif
> -                        struct bin_attribute *bin_attr,
> -                        char *buf, loff_t pos, size_t count);
> -
> -@@ -755,7 +763,11 @@ static struct bin_attribute bmi_attr = {
> - };
> -
> - static ssize_t
> -+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34))
> - ar6000_sysfs_bmi_read(struct file *fp, struct kobject *kobj,
> -+#else
> -+ar6000_sysfs_bmi_read(struct kobject *kobj, #endif
> -                       struct bin_attribute *bin_attr,
> -                       char *buf, loff_t pos, size_t count)
> - {
> -@@ -782,7 +794,11 @@ ar6000_sysfs_bmi_read(struct file *fp, s
> - }
> -
> - static ssize_t
> -+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,34))
> - ar6000_sysfs_bmi_write(struct file *fp, struct kobject *kobj,
> -+#else
> -+ar6000_sysfs_bmi_write(struct kobject *kobj, #endif
> -                        struct bin_attribute *bin_attr,
> -                        char *buf, loff_t pos, size_t count)
> - {
> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh index
> 3040275..87b7e5f 100755
> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -218,6 +218,7 @@ fi
>  DRIVERS="drivers/net/wireless/ath"
>  DRIVERS="$DRIVERS drivers/net/wireless/ath/carl9170"
>  DRIVERS="$DRIVERS drivers/net/wireless/ath/ath5k"
> +DRIVERS="$DRIVERS drivers/net/wireless/ath/ath6kl"
>  DRIVERS="$DRIVERS drivers/net/wireless/ath/ath9k"
>  DRIVERS="$DRIVERS drivers/ssb"
>  DRIVERS="$DRIVERS drivers/bcma"
> @@ -247,8 +248,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/orinoco"
>  DRIVERS="$DRIVERS drivers/net/wireless/mwifiex"
> 
>  # Staging drivers
> -STAGING_DRIVERS="drivers/staging/ath6kl"
> -STAGING_DRIVERS="$STAGING_DRIVERS drivers/staging/brcm80211"
> +STAGING_DRIVERS="drivers/staging/brcm80211"
> 
>  # Ethernet drivers
>  DRIVERS="$DRIVERS drivers/net/atl1c"
> --
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html


