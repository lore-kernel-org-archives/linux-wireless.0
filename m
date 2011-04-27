Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37674 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759764Ab1D0SBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 14:01:11 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH] compat-wireless: backport multicast filter in p54 for kernel < 2.6.35
Date: Wed, 27 Apr 2011 20:00:59 +0200
Message-Id: <1303927259-6983-1-git-send-email-hauke@hauke-m.de> (sfid-20110427_200114_201978_9691405F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interface changed with kernel 2.6.35 and we have to backport these changes.

CC: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/25-multicast-list_head.patch |   45 ++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index f4d8aae..719321a 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -437,6 +437,51 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  int determine_fw_capabilities(struct orinoco_private *priv, char *fw_name,
  			      size_t fw_name_len, u32 *hw_ver);
+--- a/drivers/net/wireless/p54/main.c
++++ b/drivers/net/wireless/p54/main.c
+@@ -308,11 +308,18 @@ out:
+ 	return ret;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ static u64 p54_prepare_multicast(struct ieee80211_hw *dev,
+ 				 struct netdev_hw_addr_list *mc_list)
++#else
++static u64 p54_prepare_multicast(struct ieee80211_hw *dev, int mc_count,
++				 struct dev_addr_list *ha)
++#endif
+ {
+ 	struct p54_common *priv = dev->priv;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	struct netdev_hw_addr *ha;
++#endif
+ 	int i;
+ 
+ 	BUILD_BUG_ON(ARRAY_SIZE(priv->mc_maclist) !=
+@@ -322,12 +329,23 @@ static u64 p54_prepare_multicast(struct
+ 	 * Otherwise the firmware will drop it and ARP will no longer work.
+ 	 */
+ 	i = 1;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	priv->mc_maclist_num = netdev_hw_addr_list_count(mc_list) + i;
+ 	netdev_hw_addr_list_for_each(ha, mc_list) {
+ 		memcpy(&priv->mc_maclist[i], ha->addr, ETH_ALEN);
++#else
++	priv->mc_maclist_num = mc_count + i;
++	while (i <= mc_count) {
++		if (!ha)
++			break;
++		memcpy(&priv->mc_maclist[i], ha->dmi_addr, ETH_ALEN);
++#endif
+ 		i++;
+ 		if (i >= ARRAY_SIZE(priv->mc_maclist))
+ 			break;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
++		ha = ha->next;
++#endif
+ 	}
+ 
+ 	return 1; /* update */
 --- a/drivers/net/wireless/rndis_wlan.c
 +++ b/drivers/net/wireless/rndis_wlan.c
 @@ -1629,7 +1629,11 @@ static void set_multicast_list(struct us
-- 
1.7.1

