Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27924 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab0CXV1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 17:27:47 -0400
Subject: [PATCH] compat-wireless: add support for ath9k_htc
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Wed, 24 Mar 2010 17:27:46 -0400
Message-Id: <1269466066.26368.10.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

Be careful, that will only work once ath9k_htc goes to linux-next!

 config.mk             |    2 ++
 patches/05-usb.patch  |   12 ++++++++++++
 scripts/driver-select |    5 +++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 357cae9..a34fcb6 100644
--- a/config.mk
+++ b/config.mk
@@ -373,6 +373,8 @@ CONFIG_AR9170_USB=m
 CONFIG_AR9170_LEDS=y
 endif
 
+CONFIG_ATH9K_HTC=m
+
 # RT2500USB does not require firmware
 CONFIG_RT2500USB=m
 ifneq ($(CONFIG_CRC_CCITT),)
diff --git a/patches/05-usb.patch b/patches/05-usb.patch
index 9ff2e1e..d5c92c4 100644
--- a/patches/05-usb.patch
+++ b/patches/05-usb.patch
@@ -12,3 +12,15 @@ USB opt soft_unbid was added as of 2.6.27.
  };
  
  static int __init p54u_init(void)
+--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
++++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
+@@ -979,7 +979,9 @@ static struct usb_driver ath9k_hif_usb_d
+ 	.reset_resume = ath9k_hif_usb_resume,
+ #endif
+ 	.id_table = ath9k_hif_usb_ids,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
+ 	.soft_unbind = 1,
++#endif
+ };
+ 
+ int ath9k_hif_usb_init(void)
diff --git a/scripts/driver-select b/scripts/driver-select
index 229861e..68bb7ff 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -274,6 +274,11 @@ case $1 in
 		select_driver		CONFIG_ATH_COMMON
 		select_ath_driver	CONFIG_AR9170_USB
 		;;
+	ath9k_htc)
+		disable_bt_usb_ethernet_var
+		select_driver		CONFIG_ATH_COMMON
+		select_ath_driver	CONFIG_ATH9K_HTC
+		;;
 	rtl818x)
 		select_drivers		CONFIG_RTL8180 CONFIG_RTL8187
 		disable_var_02
