Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35466 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbcFHHlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 03:41:14 -0400
Received: by mail-pa0-f49.google.com with SMTP id hl6so13799pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2016 00:41:14 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	driverdev-devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 1/2] staging: r8723au: pwrctrl_priv: Replace semaphore lock with mutex
Date: Wed,  8 Jun 2016 13:10:54 +0530
Message-Id: <1465371655-6768-2-git-send-email-binoy.jayan@linaro.org> (sfid-20160608_094222_845221_75FF8963)
In-Reply-To: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org>
References: <1465371655-6768-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The semaphore 'lock' in pwrctrl_priv is a simple mutex, so it should
be written as one. Semaphores are going away in the future.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---
 drivers/staging/rtl8723au/core/rtw_pwrctrl.c    | 11 ++++++-----
 drivers/staging/rtl8723au/include/rtw_pwrctrl.h |  3 ++-
 drivers/staging/rtl8723au/os_dep/usb_intf.c     | 11 ++++++-----
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_pwrctrl.c b/drivers/staging/rtl8723au/core/rtw_pwrctrl.c
index 7488a10..2d43958 100644
--- a/drivers/staging/rtl8723au/core/rtw_pwrctrl.c
+++ b/drivers/staging/rtl8723au/core/rtw_pwrctrl.c
@@ -14,6 +14,7 @@
  ******************************************************************************/
 #define _RTW_PWRCTRL_C_
 
+#include <linux/mutex.h>
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <osdep_intf.h>
@@ -27,7 +28,7 @@ void ips_enter23a(struct rtw_adapter *padapter)
 {
 	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
 
-	down(&pwrpriv->lock);
+	mutex_lock(&pwrpriv->mutex_lock);
 
 	pwrpriv->bips_processing = true;
 
@@ -50,7 +51,7 @@ void ips_enter23a(struct rtw_adapter *padapter)
 	}
 	pwrpriv->bips_processing = false;
 
-	up(&pwrpriv->lock);
+	mutex_unlock(&pwrpriv->mutex_lock);
 }
 
 int ips_leave23a(struct rtw_adapter *padapter)
@@ -61,7 +62,7 @@ int ips_leave23a(struct rtw_adapter *padapter)
 	int result = _SUCCESS;
 	int keyid;
 
-	down(&pwrpriv->lock);
+	mutex_lock(&pwrpriv->mutex_lock);
 
 	if (pwrpriv->rf_pwrstate == rf_off && !pwrpriv->bips_processing) {
 		pwrpriv->bips_processing = true;
@@ -106,7 +107,7 @@ int ips_leave23a(struct rtw_adapter *padapter)
 		pwrpriv->bpower_saving = false;
 	}
 
-	up(&pwrpriv->lock);
+	mutex_unlock(&pwrpriv->mutex_lock);
 
 	return result;
 }
@@ -423,7 +424,7 @@ void rtw_init_pwrctrl_priv23a(struct rtw_adapter *padapter)
 {
 	struct pwrctrl_priv *pwrctrlpriv = &padapter->pwrctrlpriv;
 
-	sema_init(&pwrctrlpriv->lock, 1);
+	mutex_init(&pwrctrlpriv->mutex_lock);
 	pwrctrlpriv->rf_pwrstate = rf_on;
 	pwrctrlpriv->ips_enter23a_cnts = 0;
 	pwrctrlpriv->ips_leave23a_cnts = 0;
diff --git a/drivers/staging/rtl8723au/include/rtw_pwrctrl.h b/drivers/staging/rtl8723au/include/rtw_pwrctrl.h
index 599fed9..699b9f3 100644
--- a/drivers/staging/rtl8723au/include/rtw_pwrctrl.h
+++ b/drivers/staging/rtl8723au/include/rtw_pwrctrl.h
@@ -15,6 +15,7 @@
 #ifndef __RTW_PWRCTRL_H_
 #define __RTW_PWRCTRL_H_
 
+#include <linux/mutex.h>
 #include <osdep_service.h>
 #include <drv_types.h>
 
@@ -149,7 +150,7 @@ enum { /*  for ips_mode */
 };
 
 struct pwrctrl_priv {
-	struct semaphore lock;
+	struct mutex mutex_lock;
 	volatile u8 rpwm; /* requested power state for fw */
 	volatile u8 cpwm; /* fw current power state. updated when 1.
 			   * read from HCPWM 2. driver lowers power level
diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c b/drivers/staging/rtl8723au/os_dep/usb_intf.c
index cf83eff..fa7dda5 100644
--- a/drivers/staging/rtl8723au/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8723au/os_dep/usb_intf.c
@@ -14,6 +14,7 @@
  ******************************************************************************/
 #define _HCI_INTF_C_
 
+#include <linux/mutex.h>
 #include <osdep_service.h>
 #include <drv_types.h>
 #include <recv_osdep.h>
@@ -291,7 +292,7 @@ static int rtw_suspend(struct usb_interface *pusb_intf, pm_message_t message)
 	rtw_cancel_all_timer23a(padapter);
 	LeaveAllPowerSaveMode23a(padapter);
 
-	down(&pwrpriv->lock);
+	mutex_lock(&pwrpriv->mutex_lock);
 	/* padapter->net_closed = true; */
 	/* s1. */
 	if (pnetdev) {
@@ -321,7 +322,7 @@ static int rtw_suspend(struct usb_interface *pusb_intf, pm_message_t message)
 	rtw_free_network_queue23a(padapter);
 
 	rtw_dev_unload(padapter);
-	up(&pwrpriv->lock);
+	mutex_unlock(&pwrpriv->mutex_lock);
 
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
 		rtw_cfg80211_indicate_scan_done(
@@ -353,20 +354,20 @@ static int rtw_resume(struct usb_interface *pusb_intf)
 	pnetdev = padapter->pnetdev;
 	pwrpriv = &padapter->pwrctrlpriv;
 
-	down(&pwrpriv->lock);
+	mutex_lock(&pwrpriv->mutex_lock);
 	rtw_reset_drv_sw23a(padapter);
 	pwrpriv->bkeepfwalive = false;
 
 	DBG_8723A("bkeepfwalive(%x)\n", pwrpriv->bkeepfwalive);
 	if (pm_netdev_open23a(pnetdev, true) != 0) {
-		up(&pwrpriv->lock);
+		mutex_unlock(&pwrpriv->mutex_lock);
 		goto exit;
 	}
 
 	netif_device_attach(pnetdev);
 	netif_carrier_on(pnetdev);
 
-	up(&pwrpriv->lock);
+	mutex_unlock(&pwrpriv->mutex_lock);
 
 	if (padapter->pid[1] != 0) {
 		DBG_8723A("pid[1]:%d\n", padapter->pid[1]);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

