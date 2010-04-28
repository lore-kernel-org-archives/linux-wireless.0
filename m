Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50258 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab0D1V24 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 17:28:56 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: refresh patches
Date: Wed, 28 Apr 2010 23:28:44 +0200
Message-Id: <1272490124-31413-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/01-netdev.patch                 |    2 +-
 patches/03-rfkill.patch                 |    2 +-
 patches/04-netns.patch                  |   10 +++++-----
 patches/05-usb.patch                    |    2 +-
 patches/08-rename-iwl4965-config.patch  |    6 +++---
 patches/16-bluetooth.patch              |    2 +-
 patches/18-rename-usb-net-symbols.patch |    2 +-
 patches/20-pcidev.patch                 |    2 +-
 patches/22-multiqueue.patch             |    4 ++--
 patches/25-multicast-list_head.patch    |   10 +++++-----
 patches/26-sdio-quirks.patch            |    4 ++--
 patches/99-change-makefiles.patch       |    3 ++-
 12 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/patches/01-netdev.patch b/patches/01-netdev.patch
index 924376b..01dbbce 100644
--- a/patches/01-netdev.patch
+++ b/patches/01-netdev.patch
@@ -550,7 +550,7 @@ without creating a headache on maintenance of the pathes.
  #define LBS_DEB_LEAVE	0x00000002
 --- a/drivers/net/wireless/mac80211_hwsim.c
 +++ b/drivers/net/wireless/mac80211_hwsim.c
-@@ -1049,16 +1049,22 @@ static struct device_driver mac80211_hws
+@@ -1078,16 +1078,22 @@ static struct device_driver mac80211_hws
  	.name = "mac80211_hwsim"
  };
  
diff --git a/patches/03-rfkill.patch b/patches/03-rfkill.patch
index e17ab09..ef2d8ec 100644
--- a/patches/03-rfkill.patch
+++ b/patches/03-rfkill.patch
@@ -208,7 +208,7 @@ This would do the policing from within mac80211.
  #include <net/cfg80211.h>
 --- a/drivers/net/wireless/ath/ath9k/hw.c
 +++ b/drivers/net/wireless/ath/ath9k/hw.c
-@@ -3183,7 +3183,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
+@@ -2134,7 +2134,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw
  
  	pCap->hw_caps |= ATH9K_HW_CAP_ENHANCEDPM;
  
diff --git a/patches/04-netns.patch b/patches/04-netns.patch
index 5325a19..18f8c85 100644
--- a/patches/04-netns.patch
+++ b/patches/04-netns.patch
@@ -16,7 +16,7 @@ files...
  };
  
  /* internal helper: get rdev and dev */
-@@ -4203,7 +4205,9 @@ static int nl80211_wiphy_netns(struct sk
+@@ -4207,7 +4209,9 @@ static int nl80211_wiphy_netns(struct sk
  
  	err = cfg80211_switch_netns(rdev, net);
   out_put_net:
@@ -65,7 +65,7 @@ files...
  
  		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
  				      "phy80211")) {
-@@ -828,6 +834,7 @@ static struct notifier_block cfg80211_ne
+@@ -829,6 +835,7 @@ static struct notifier_block cfg80211_ne
  	.notifier_call = cfg80211_netdev_notifier_call,
  };
  
@@ -73,7 +73,7 @@ files...
  static void __net_exit cfg80211_pernet_exit(struct net *net)
  {
  	struct cfg80211_registered_device *rdev;
-@@ -845,14 +852,17 @@ static void __net_exit cfg80211_pernet_e
+@@ -846,14 +853,17 @@ static void __net_exit cfg80211_pernet_e
  static struct pernet_operations cfg80211_pernet_ops = {
  	.exit = cfg80211_pernet_exit,
  };
@@ -91,7 +91,7 @@ files...
  
  	err = wiphy_sysfs_init();
  	if (err)
-@@ -887,8 +897,10 @@ out_fail_nl80211:
+@@ -888,8 +898,10 @@ out_fail_nl80211:
  out_fail_notifier:
  	wiphy_sysfs_exit();
  out_fail_sysfs:
@@ -102,7 +102,7 @@ files...
  	return err;
  }
  subsys_initcall(cfg80211_init);
-@@ -900,7 +912,9 @@ static void cfg80211_exit(void)
+@@ -901,7 +913,9 @@ static void cfg80211_exit(void)
  	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
  	wiphy_sysfs_exit();
  	regulatory_exit();
diff --git a/patches/05-usb.patch b/patches/05-usb.patch
index 823097e..7420d69 100644
--- a/patches/05-usb.patch
+++ b/patches/05-usb.patch
@@ -14,7 +14,7 @@ USB opt soft_unbid was added as of 2.6.27.
  static int __init p54u_init(void)
 --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
 +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
-@@ -970,7 +970,9 @@ static struct usb_driver ath9k_hif_usb_d
+@@ -994,7 +994,9 @@ static struct usb_driver ath9k_hif_usb_d
  	.reset_resume = ath9k_hif_usb_resume,
  #endif
  	.id_table = ath9k_hif_usb_ids,
diff --git a/patches/08-rename-iwl4965-config.patch b/patches/08-rename-iwl4965-config.patch
index 6c73a53..624aed4 100644
--- a/patches/08-rename-iwl4965-config.patch
+++ b/patches/08-rename-iwl4965-config.patch
@@ -5,9 +5,9 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
 
 --- a/drivers/net/wireless/iwlwifi/Makefile
 +++ b/drivers/net/wireless/iwlwifi/Makefile
-@@ -13,7 +13,7 @@ iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o i
- iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o iwl-agn-tx.o
+@@ -14,7 +14,7 @@ iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-
  iwlagn-objs		+= iwl-agn-lib.o
+ iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
  
 -iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 +iwlagn-$(CONFIG_COMPAT_IWL4965) += iwl-4965.o
@@ -16,7 +16,7 @@ CONFIG_IWL4965 has to be set to y, to build correctly.
  iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -3761,10 +3761,10 @@ static void __devexit iwl_pci_remove(str
+@@ -3723,10 +3723,10 @@ static void __devexit iwl_pci_remove(str
  
  /* Hardware specific file defines the PCI IDs table for that hardware module */
  static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
diff --git a/patches/16-bluetooth.patch b/patches/16-bluetooth.patch
index 0fb9732..eac00df 100644
--- a/patches/16-bluetooth.patch
+++ b/patches/16-bluetooth.patch
@@ -595,7 +595,7 @@ here still, but for now we keep this here.
  		return -EPERM;
  
  	sock->ops = &l2cap_sock_ops;
-@@ -1767,7 +1775,11 @@ static int l2cap_sock_setsockopt_old(str
+@@ -1770,7 +1778,11 @@ static int l2cap_sock_setsockopt_old(str
  	return err;
  }
  
diff --git a/patches/18-rename-usb-net-symbols.patch b/patches/18-rename-usb-net-symbols.patch
index 7369817..548a7a4 100644
--- a/patches/18-rename-usb-net-symbols.patch
+++ b/patches/18-rename-usb-net-symbols.patch
@@ -28,7 +28,7 @@ Remove this patch if these symbols are backported.
 +obj-$(CONFIG_USB_COMPAT_USBNET)	+= usbnet.o
  obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
  obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
- 
+ obj-$(CONFIG_USB_IPHETH)	+= ipheth.o
 --- a/drivers/net/usb/cdc_ether.c
 +++ b/drivers/net/usb/cdc_ether.c
 @@ -33,7 +33,7 @@
diff --git a/patches/20-pcidev.patch b/patches/20-pcidev.patch
index cb7f1ca..e892dcc 100644
--- a/patches/20-pcidev.patch
+++ b/patches/20-pcidev.patch
@@ -4,7 +4,7 @@ compat_is_pcie() when needed.
 
 --- a/drivers/net/wireless/ath/ath9k/pci.c
 +++ b/drivers/net/wireless/ath/ath9k/pci.c
-@@ -79,7 +79,11 @@ static void ath_pci_bt_coex_prep(struct 
+@@ -80,7 +80,11 @@ static void ath_pci_bt_coex_prep(struct 
  	struct pci_dev *pdev = to_pci_dev(sc->dev);
  	u8 aspm;
  
diff --git a/patches/22-multiqueue.patch b/patches/22-multiqueue.patch
index f6bd3e0..39f481a 100644
--- a/patches/22-multiqueue.patch
+++ b/patches/22-multiqueue.patch
@@ -96,7 +96,7 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  
 --- a/net/mac80211/tx.c
 +++ b/net/mac80211/tx.c
-@@ -1563,6 +1563,10 @@ static void ieee80211_xmit(struct ieee80
+@@ -1571,6 +1571,10 @@ static void ieee80211_xmit(struct ieee80
  				return;
  			}
  
@@ -107,7 +107,7 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  	ieee80211_set_qos_hdr(local, skb);
  	ieee80211_tx(sdata, skb, false);
  	rcu_read_unlock();
-@@ -2032,8 +2036,15 @@ void ieee80211_tx_pending(unsigned long 
+@@ -2040,8 +2044,15 @@ void ieee80211_tx_pending(unsigned long 
  
  		if (skb_queue_empty(&local->pending[i]))
  			list_for_each_entry_rcu(sdata, &local->interfaces, list)
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index bd8f2bd..9d125cf 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -174,7 +174,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  static void ath5k_configure_filter(struct ieee80211_hw *hw,
  		unsigned int changed_flags,
  		unsigned int *new_flags,
-@@ -3105,20 +3109,42 @@ unlock:
+@@ -3108,20 +3112,42 @@ unlock:
  }
  
  static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
@@ -217,7 +217,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
  		pos &= 0x3f;
  		mfilt[pos / 32] |= (1 << (pos % 32));
-@@ -3127,6 +3153,9 @@ static u64 ath5k_prepare_multicast(struc
+@@ -3130,6 +3156,9 @@ static u64 ath5k_prepare_multicast(struc
  		* neet to inform below to not reset the mcast */
  		/* ath5k_hw_set_mcast_filterindex(ah,
  		 *      ha->addr[5]); */
@@ -266,7 +266,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
 --- a/drivers/net/wireless/libertas_tf/main.c
 +++ b/drivers/net/wireless/libertas_tf/main.c
-@@ -369,20 +369,36 @@ static int lbtf_op_config(struct ieee802
+@@ -418,20 +418,36 @@ static int lbtf_op_config(struct ieee802
  }
  
  static u64 lbtf_op_prepare_multicast(struct ieee80211_hw *hw,
@@ -393,7 +393,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	if (cmd != NULL) {
 --- a/drivers/net/wireless/orinoco/hw.c
 +++ b/drivers/net/wireless/orinoco/hw.c
-@@ -1063,7 +1063,11 @@ int __orinoco_hw_set_multicast_list(stru
+@@ -1089,7 +1089,11 @@ int __orinoco_hw_set_multicast_list(stru
  		netdev_for_each_mc_addr(ha, dev) {
  			if (i == mc_count)
  				break;
@@ -576,7 +576,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	return hash.low | ((u64)hash.high << 32);
 --- a/include/net/mac80211.h
 +++ b/include/net/mac80211.h
-@@ -1631,7 +1631,11 @@ struct ieee80211_ops {
+@@ -1642,7 +1642,11 @@ struct ieee80211_ops {
  				 struct ieee80211_bss_conf *info,
  				 u32 changed);
  	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
diff --git a/patches/26-sdio-quirks.patch b/patches/26-sdio-quirks.patch
index 0b43be5..2fec33d 100644
--- a/patches/26-sdio-quirks.patch
+++ b/patches/26-sdio-quirks.patch
@@ -2,7 +2,7 @@ The quirks attribute is not available on older kernels.
 
 --- a/drivers/net/wireless/libertas/if_sdio.c
 +++ b/drivers/net/wireless/libertas/if_sdio.c
-@@ -1026,6 +1026,7 @@ static int if_sdio_probe(struct sdio_fun
+@@ -1003,6 +1003,7 @@ static int if_sdio_probe(struct sdio_fun
  	if (ret)
  		goto disable;
  
@@ -10,7 +10,7 @@ The quirks attribute is not available on older kernels.
  	/* For 1-bit transfers to the 8686 model, we need to enable the
  	 * interrupt flag in the CCCR register. Set the MMC_QUIRK_LENIENT_FN0
  	 * bit to allow access to non-vendor registers. */
-@@ -1044,6 +1045,7 @@ static int if_sdio_probe(struct sdio_fun
+@@ -1021,6 +1022,7 @@ static int if_sdio_probe(struct sdio_fun
  		if (ret)
  			goto release_int;
  	}
diff --git a/patches/99-change-makefiles.patch b/patches/99-change-makefiles.patch
index 8a60060..67aac65 100644
--- a/patches/99-change-makefiles.patch
+++ b/patches/99-change-makefiles.patch
@@ -13,7 +13,7 @@ only the wireless stuff.
  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
 --- a/drivers/net/usb/Makefile
 +++ b/drivers/net/usb/Makefile
-@@ -2,25 +2,7 @@
+@@ -2,26 +2,7 @@
  # Makefile for USB Network drivers
  #
  
@@ -38,6 +38,7 @@ only the wireless stuff.
  obj-$(CONFIG_USB_COMPAT_USBNET)	+= usbnet.o
 -obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
 -obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
+-obj-$(CONFIG_USB_IPHETH)	+= ipheth.o
  
 --- a/drivers/net/wireless/Makefile
 +++ b/drivers/net/wireless/Makefile
-- 
1.6.3.3

