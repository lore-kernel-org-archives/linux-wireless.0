Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38478 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab0ISRtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 13:49:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH 3/4] compat-wirelsss: add carl9170
Date: Sun, 19 Sep 2010 19:49:12 +0200
Message-Id: <1284918553-32365-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284918408-32242-1-git-send-email-hauke@hauke-m.de>
References: <1284918408-32242-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for carl9170.

CC: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                            |   12 ++++++++++
 patches/25-multicast-list_head.patch |   38 ++++++++++++++++++++++++++++++++++
 scripts/admin-update.sh              |    1 +
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index a021172..7f73744 100644
--- a/config.mk
+++ b/config.mk
@@ -413,6 +413,18 @@ CONFIG_AR9170_USB=m
 CONFIG_AR9170_LEDS=y
 endif #CONFIG_COMPAT_KERNEL_28
 
+ifndef CONFIG_COMPAT_KERNEL_29
+CONFIG_CARL9170=m
+CONFIG_CARL9170_LEDS=y
+# CONFIG_CARL9170_DEBUGFS=y
+# CONFIG_CARL9170_WPC=y
+endif #CONFIG_COMPAT_KERNEL_29
+
+# This activates a threading fix for usb urb.
+# this is mainline commit: b3e670443b7fb8a2d29831b62b44a039c283e351
+# This fix will be included in some stable releases.
+CONFIG_COMPAT_USB_URB_THREAD_FIX=y
+
 CONFIG_ATH9K_HTC=m
 # CONFIG_ATH9K_HTC_DEBUGFS=y
 
diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index 0f07b5c..5a6bb16 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -227,6 +227,44 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  	}
  
  	return ((u64)(mfilt[1]) << 32) | mfilt[0];
+--- a/drivers/net/wireless/ath/carl9170/main.c
++++ b/drivers/net/wireless/ath/carl9170/main.c
+@@ -810,17 +810,35 @@ out:
+ 	return err;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ static u64 carl9170_op_prepare_multicast(struct ieee80211_hw *hw,
+ 					 struct netdev_hw_addr_list *mc_list)
++#else
++static u64 carl9170_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
++					 struct dev_addr_list *ha)
++#endif
+ {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	struct netdev_hw_addr *ha;
++#else
++	int i;
++#endif
+ 	u64 mchash;
+ 
+ 	/* always get broadcast frames */
+ 	mchash = 1ULL << (0xff >> 2);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
+ 	netdev_hw_addr_list_for_each(ha, mc_list)
+ 		mchash |= 1ULL << (ha->addr[5] >> 2);
++#else
++	for (i = 0; i < mc_count; i++) {
++		if (WARN_ON(!ha))
++			break;
++		mchash |= 1ULL << (ha->dmi_addr[5] >> 2);
++		ha = ha->next;
++	}
++#endif
+ 
+ 	return mchash;
+ }
 --- a/drivers/net/wireless/libertas/main.c
 +++ b/drivers/net/wireless/libertas/main.c
 @@ -242,18 +242,34 @@ static int lbs_add_mcast_addrs(struct cm
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 6ef281d..ac9470d 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -192,6 +192,7 @@ fi
 
 # Drivers that have their own directory
 DRIVERS="drivers/net/wireless/ath"
+DRIVERS="$DRIVERS drivers/net/wireless/ath/carl9170"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/ar9170"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/ath5k"
 DRIVERS="$DRIVERS drivers/net/wireless/ath/ath9k"
-- 
1.7.0.4

