Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33997 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab1CaQWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:22:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/5] compat-wireless: add support for mwifiex
Date: Thu, 31 Mar 2011 18:22:03 +0200
Message-Id: <1301588527-16615-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for mwifiex into compat-wireless.

This is only compile tested as I do not have such a device.

CC: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                                 |    4 +
 patches/01-netdev.patch                   |   11 ++++
 patches/25-multicast-list_head.patch      |   42 ++++++++++++--
 patches/26-sdio-quirks.patch              |   12 ++++
 patches/29-libertas_sdio_no_suspend.patch |   34 -----------
 patches/29-sdio_no_suspend.patch          |   86 +++++++++++++++++++++++++++++
 scripts/admin-update.sh                   |    1 +
 7 files changed, 151 insertions(+), 39 deletions(-)
 delete mode 100644 patches/29-libertas_sdio_no_suspend.patch
 create mode 100644 patches/29-sdio_no_suspend.patch

diff --git a/config.mk b/config.mk
index 92b5fad..a66fd5a 100644
--- a/config.mk
+++ b/config.mk
@@ -530,6 +530,8 @@ endif #CONFIG_COMPAT_KERNEL_32
 
 endif #CONFIG_CRC7
 
+CONFIG_MWIFIEX_SDIO=m
+
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS_SDIO=n
 NEED_LIBERTAS=n
@@ -609,6 +611,8 @@ CONFIG_COMPAT_WL12XX=m
 CONFIG_WL12XX_HT=y
 endif #CONFIG_CRC7
 
+CONFIG_MWIFIEX=m
+
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS=n
 else #CONFIG_COMPAT_KERNEL_27
diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index dc5ea98..d11f9af 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -265,6 +265,17 @@ without creating a headache on maintenance of the pathes.
  	dev->destructor = free_netdev;
  	ether_setup(dev);
  	dev->tx_queue_len = 0;
+--- a/drivers/net/wireless/mwifiex/main.c
++++ b/drivers/net/wireless/mwifiex/main.c
+@@ -675,7 +675,7 @@ static const struct net_device_ops mwifi
+ static void
+ mwifiex_init_priv_params(struct mwifiex_private *priv, struct net_device *dev)
+ {
+-	dev->netdev_ops = &mwifiex_netdev_ops;
++	netdev_attach_ops(dev, &mwifiex_netdev_ops);
+ 	/* Initialize private structure */
+ 	init_waitqueue_head(&priv->ioctl_wait_q);
+ 	init_waitqueue_head(&priv->cmd_wait_q);
 --- a/drivers/net/wireless/orinoco/main.c
 +++ b/drivers/net/wireless/orinoco/main.c
 @@ -2272,14 +2272,18 @@ int orinoco_if_add(struct orinoco_privat
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 6d25c32..087cb0a 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -329,9 +329,41 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  	return mc_count;
  }
+--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
++++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
+@@ -41,7 +41,11 @@ mwifiex_copy_mcast_addr(struct mwifiex_m
+ 	struct netdev_hw_addr *ha;
+ 
+ 	netdev_for_each_mc_addr(ha, dev)
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 		memcpy(&mlist->mac_list[i++], ha->addr, ETH_ALEN);
++#else
++		memcpy(&mlist->mac_list[i++], ha->dmi_addr, ETH_ALEN);
++#endif
+ 
+ 	return i;
+ }
+--- a/drivers/net/wireless/mwifiex/debugfs.c
++++ b/drivers/net/wireless/mwifiex/debugfs.c
+@@ -235,9 +235,15 @@ mwifiex_info_read(struct file *file, cha
+ 		netdev_for_each_mc_addr(ha, netdev)
+ 			p += sprintf(p, "multicast_address[%d]="
+ 				     "\"%02x:%02x:%02x:%02x:%02x:%02x\"\n", i++,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 				     ha->addr[0], ha->addr[1],
+ 				     ha->addr[2], ha->addr[3],
+ 				     ha->addr[4], ha->addr[5]);
++#else
++				     ha->dmi_addr[0], ha->dmi_addr[1],
++				     ha->dmi_addr[2], ha->dmi_addr[3],
++				     ha->dmi_addr[4], ha->dmi_addr[5]);
++#endif
+ 	}
+ 
+ 	p += sprintf(p, "num_tx_bytes = %lu\n", priv->stats.tx_bytes);
 --- a/drivers/net/wireless/mwl8k.c
 +++ b/drivers/net/wireless/mwl8k.c
-@@ -2165,15 +2165,21 @@ struct mwl8k_cmd_mac_multicast_adr {
+@@ -2466,15 +2466,21 @@ struct mwl8k_cmd_mac_multicast_adr {
  
  static struct mwl8k_cmd_pkt *
  __mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw, int allmulti,
@@ -353,7 +385,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  	if (allmulti || mc_count > priv->num_mcaddrs) {
  		allmulti = 1;
-@@ -2194,13 +2200,27 @@ __mwl8k_cmd_mac_multicast_adr(struct iee
+@@ -2495,13 +2501,27 @@ __mwl8k_cmd_mac_multicast_adr(struct iee
  	if (allmulti) {
  		cmd->action |= cpu_to_le16(MWL8K_ENABLE_RX_ALL_MULTICAST);
  	} else if (mc_count) {
@@ -381,7 +413,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		}
  	}
  
-@@ -4130,7 +4150,11 @@ mwl8k_bss_info_changed(struct ieee80211_
+@@ -4642,7 +4662,11 @@ mwl8k_bss_info_changed(struct ieee80211_
  }
  
  static u64 mwl8k_prepare_multicast(struct ieee80211_hw *hw,
@@ -393,7 +425,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  {
  	struct mwl8k_cmd_pkt *cmd;
  
-@@ -4141,7 +4165,11 @@ static u64 mwl8k_prepare_multicast(struc
+@@ -4653,7 +4677,11 @@ static u64 mwl8k_prepare_multicast(struc
  	 * we'll end up throwing this packet away and creating a new
  	 * one in mwl8k_configure_filter().
  	 */
@@ -405,7 +437,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  	return (unsigned long)cmd;
  }
-@@ -4263,7 +4291,11 @@ static void mwl8k_configure_filter(struc
+@@ -4775,7 +4803,11 @@ static void mwl8k_configure_filter(struc
  	 */
  	if (*total_flags & FIF_ALLMULTI) {
  		kfree(cmd);
diff --git a/patches/26-sdio-quirks.patch b/patches/26-sdio-quirks.patch
index a802a25..5c78d87 100644
--- a/patches/26-sdio-quirks.patch
+++ b/patches/26-sdio-quirks.patch
@@ -18,3 +18,15 @@ The quirks attribute is not available on older kernels.
  
  	card->ioport = sdio_readb(func, IF_SDIO_IOPORT, &ret);
  	if (ret)
+--- a/drivers/net/wireless/mwifiex/sdio.c
++++ b/drivers/net/wireless/mwifiex/sdio.c
+@@ -60,7 +60,9 @@ mwifiex_sdio_probe(struct sdio_func *fun
+ 
+ 	card->func = func;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
++#endif
+ 
+ 	sdio_claim_host(func);
+ 	ret = sdio_enable_func(func);
diff --git a/patches/29-libertas_sdio_no_suspend.patch b/patches/29-libertas_sdio_no_suspend.patch
deleted file mode 100644
index 287452a..0000000
--- a/patches/29-libertas_sdio_no_suspend.patch
+++ /dev/null
@@ -1,34 +0,0 @@
-Starting with commit 66fceb69b72ff7e9cd8da2ca70033982d5376e0e
-"libertas: Added callback functions to support SDIO suspend/resume."
-libertas uses new functions from the in kernel sdio framework for
-suspend and resume that are not backported.
-
---- a/drivers/net/wireless/libertas/if_sdio.c
-+++ b/drivers/net/wireless/libertas/if_sdio.c
-@@ -1196,6 +1196,7 @@ static void if_sdio_remove(struct sdio_f
- 	lbs_deb_leave(LBS_DEB_SDIO);
- }
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static int if_sdio_suspend(struct device *dev)
- {
- 	struct sdio_func *func = dev_to_sdio_func(dev);
-@@ -1250,15 +1251,18 @@ static const struct dev_pm_ops if_sdio_p
- 	.suspend	= if_sdio_suspend,
- 	.resume		= if_sdio_resume,
- };
-+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
- 
- static struct sdio_driver if_sdio_driver = {
- 	.name		= "libertas_sdio",
- 	.id_table	= if_sdio_ids,
- 	.probe		= if_sdio_probe,
- 	.remove		= if_sdio_remove,
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- 	.drv = {
- 		.pm = &if_sdio_pm_ops,
- 	},
-+#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
- };
- 
- /*******************************************************************/
diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
new file mode 100644
index 0000000..e196159
--- /dev/null
+++ b/patches/29-sdio_no_suspend.patch
@@ -0,0 +1,86 @@
+Starting with commit 66fceb69b72ff7e9cd8da2ca70033982d5376e0e
+"libertas: Added callback functions to support SDIO suspend/resume."
+libertas uses new functions from the in kernel sdio framework for
+suspend and resume that are not backported.
+
+--- a/drivers/net/wireless/libertas/if_sdio.c
++++ b/drivers/net/wireless/libertas/if_sdio.c
+@@ -1196,6 +1196,7 @@ static void if_sdio_remove(struct sdio_f
+ 	lbs_deb_leave(LBS_DEB_SDIO);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static int if_sdio_suspend(struct device *dev)
+ {
+ 	struct sdio_func *func = dev_to_sdio_func(dev);
+@@ -1250,15 +1251,18 @@ static const struct dev_pm_ops if_sdio_p
+ 	.suspend	= if_sdio_suspend,
+ 	.resume		= if_sdio_resume,
+ };
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ 
+ static struct sdio_driver if_sdio_driver = {
+ 	.name		= "libertas_sdio",
+ 	.id_table	= if_sdio_ids,
+ 	.probe		= if_sdio_probe,
+ 	.remove		= if_sdio_remove,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	.drv = {
+ 		.pm = &if_sdio_pm_ops,
+ 	},
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ };
+ 
+ /*******************************************************************/
+--- a/drivers/net/wireless/mwifiex/sdio.c
++++ b/drivers/net/wireless/mwifiex/sdio.c
+@@ -107,6 +107,7 @@ mwifiex_sdio_remove(struct sdio_func *fu
+ 	}
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ /*
+  * SDIO suspend.
+  *
+@@ -214,6 +215,7 @@ static int mwifiex_sdio_resume(struct de
+ 
+ 	return 0;
+ }
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ 
+ /* Device ID for SD8787 */
+ #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
+@@ -226,10 +228,12 @@ static const struct sdio_device_id mwifi
+ 
+ MODULE_DEVICE_TABLE(sdio, mwifiex_ids);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static const struct dev_pm_ops mwifiex_sdio_pm_ops = {
+ 	.suspend = mwifiex_sdio_suspend,
+ 	.resume = mwifiex_sdio_resume,
+ };
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ 
+ static struct sdio_driver mwifiex_sdio = {
+ 	.name = "mwifiex_sdio",
+@@ -238,7 +242,9 @@ static struct sdio_driver mwifiex_sdio =
+ 	.remove = mwifiex_sdio_remove,
+ 	.drv = {
+ 		.owner = THIS_MODULE,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 		.pm = &mwifiex_sdio_pm_ops,
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ 	}
+ };
+ 
+@@ -1741,8 +1747,10 @@ mwifiex_sdio_cleanup_module(void)
+ 	if (!adapter || !adapter->priv_num)
+ 		goto exit;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	if (adapter->is_suspended)
+ 		mwifiex_sdio_resume(adapter->dev);
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ 
+ 	for (i = 0; i < adapter->priv_num; i++)
+ 		if ((GET_BSS_ROLE(adapter->priv[i]) == MWIFIEX_BSS_ROLE_STA) &&
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 58f3750..0a1225e 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -242,6 +242,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/wl12xx"
 DRIVERS="$DRIVERS drivers/net/wireless/wl1251"
 DRIVERS="$DRIVERS drivers/net/wireless/iwmc3200wifi"
 DRIVERS="$DRIVERS drivers/net/wireless/orinoco"
+DRIVERS="$DRIVERS drivers/net/wireless/mwifiex"
 
 # Staging drivers
 STAGING_DRIVERS="drivers/staging/ath6kl"
-- 
1.7.1

