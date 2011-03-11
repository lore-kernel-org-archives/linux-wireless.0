Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29975 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379Ab1CKC4i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:38 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:56:15 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 15/20] ath6kl: remove-typedef AR_VIRTUAL_INTERFACE_T
Date: Thu, 10 Mar 2011 18:55:42 -0800
Message-ID: <1299812147-12069-16-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove-typedef -s AR_VIRTUAL_INTERFACE_T \
	"struct ar_virtual_interface" drivers/staging/ath6kl/

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   12 ++++++------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 3397995..e52a88a 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -6402,10 +6402,10 @@ static void DoHTCSendPktsTest(AR_SOFTC_T *ar, int MapNo, HTC_ENDPOINT_ID eid, st
 
 int ar6000_start_ap_interface(AR_SOFTC_T *ar)
 {
-    AR_VIRTUAL_INTERFACE_T *arApDev;
+    struct ar_virtual_interface *arApDev;
 
     /* Change net_device to point to AP instance */
-    arApDev = (AR_VIRTUAL_INTERFACE_T *)ar->arApDev;
+    arApDev = (struct ar_virtual_interface *)ar->arApDev;
     ar->arNetDev = arApDev->arNetDev;
 
     return 0;
@@ -6413,10 +6413,10 @@ int ar6000_start_ap_interface(AR_SOFTC_T *ar)
 
 int ar6000_stop_ap_interface(AR_SOFTC_T *ar)
 {
-    AR_VIRTUAL_INTERFACE_T *arApDev;
+    struct ar_virtual_interface *arApDev;
 
     /* Change net_device to point to sta instance */
-    arApDev = (AR_VIRTUAL_INTERFACE_T *)ar->arApDev;
+    arApDev = (struct ar_virtual_interface *)ar->arApDev;
     if (arApDev) {
         ar->arNetDev = arApDev->arStaNetDev;
     }
@@ -6428,9 +6428,9 @@ int ar6000_stop_ap_interface(AR_SOFTC_T *ar)
 int ar6000_create_ap_interface(AR_SOFTC_T *ar, char *ap_ifname)
 {
     struct net_device *dev;
-    AR_VIRTUAL_INTERFACE_T *arApDev;
+    struct ar_virtual_interface *arApDev;
 
-    dev = alloc_etherdev(sizeof(AR_VIRTUAL_INTERFACE_T));
+    dev = alloc_etherdev(sizeof(struct ar_virtual_interface));
     if (dev == NULL) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000_create_ap_interface: can't alloc etherdev\n"));
         return A_ERROR;
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 0beba09..2c6f873 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -625,11 +625,11 @@ typedef struct ar6_softc {
 } AR_SOFTC_T;
 
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
-typedef struct {
+struct ar_virtual_interface {
     struct net_device       *arNetDev;    /* net_device pointer */
     AR_SOFTC_T              *arDev;       /* ar device pointer */
     struct net_device       *arStaNetDev; /* net_device pointer */
-} AR_VIRTUAL_INTERFACE_T;
+};
 #endif /* CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT */
 
 #ifdef ATH6K_CONFIG_CFG80211
@@ -645,7 +645,7 @@ static inline void *ar6k_priv(struct net_device *dev)
 
     if (arApNetDev == dev) {
         /* return arDev saved in virtual interface context */
-        AR_VIRTUAL_INTERFACE_T *arVirDev;
+        struct ar_virtual_interface *arVirDev;
         arVirDev = netdev_priv(dev);
         return arVirDev->arDev;   
     } else {
-- 
1.7.4.15.g7811d

