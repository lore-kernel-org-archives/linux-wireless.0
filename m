Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41078 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbbCFIVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 03:21:43 -0500
Date: Fri, 6 Mar 2015 09:21:40 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] staging: rtl8723au: Remove unnecessary OOM message
Message-ID: <20150306082140.GA9740@sloth> (sfid-20150306_092202_096444_9BB4020E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reduces the kernel size by removing error messages that duplicate
the normal OOM message.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr)

@@
identifier f,print,l;
expression e;
constant char[] c;
@@

e = \(kzalloc\|kmalloc\|devm_kzalloc\|devm_kmalloc\)(...);
if (e == NULL) {
  <+...
-  print(...,c,...);
  ... when any
(
  goto l;
|
  return ...;
)
  ...+> }

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c      | 8 ++------
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 8 ++------
 drivers/staging/rtl8723au/hal/usb_ops_linux.c     | 6 +-----
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 5 -----
 4 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 7b56411..38f5b7f 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -462,10 +462,8 @@ static void SetFwRsvdPagePkt(struct rtw_adapter *padapter, bool bDLFinished)
 	DBG_8723A("%s\n", __func__);
 
 	ReservedPagePacket = kzalloc(1000, GFP_KERNEL);
-	if (ReservedPagePacket == NULL) {
-		DBG_8723A("%s: alloc ReservedPagePacket fail!\n", __func__);
+	if (ReservedPagePacket == NULL)
 		return;
-	}
 
 	pHalData = GET_HAL_DATA(padapter);
 	pxmitpriv = &padapter->xmitpriv;
@@ -669,10 +667,8 @@ static void SetFwRsvdPagePkt_BTCoex(struct rtw_adapter *padapter)
 	DBG_8723A("+%s\n", __func__);
 
 	ReservedPagePacket = kzalloc(1024, GFP_KERNEL);
-	if (ReservedPagePacket == NULL) {
-		DBG_8723A("%s: alloc ReservedPagePacket fail!\n", __func__);
+	if (ReservedPagePacket == NULL)
 		return;
-	}
 
 	pHalData = GET_HAL_DATA(padapter);
 	pxmitpriv = &padapter->xmitpriv;
diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index a5eadd4..6d50b09 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -401,10 +401,8 @@ hal_ReadEFuse_WiFi(struct rtw_adapter *padapter,
 	}
 
 	efuseTbl = kmalloc(EFUSE_MAP_LEN_8723A, GFP_KERNEL);
-	if (efuseTbl == NULL) {
-		DBG_8723A("%s: alloc efuseTbl fail!\n", __func__);
+	if (efuseTbl == NULL)
 		return;
-	}
 	/*  0xff will be efuse default value instead of 0x00. */
 	memset(efuseTbl, 0xFF, EFUSE_MAP_LEN_8723A);
 
@@ -494,10 +492,8 @@ hal_ReadEFuse_BT(struct rtw_adapter *padapter,
 	}
 
 	efuseTbl = kmalloc(EFUSE_BT_MAP_LEN, GFP_KERNEL);
-	if (efuseTbl == NULL) {
-		DBG_8723A("%s: efuseTbl malloc fail!\n", __func__);
+	if (efuseTbl == NULL)
 		return;
-	}
 	/*  0xff will be efuse default value instead of 0x00. */
 	memset(efuseTbl, 0xFF, EFUSE_BT_MAP_LEN);
 
diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
index a6d16ad..f1e9202 100644
--- a/drivers/staging/rtl8723au/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
@@ -256,12 +256,8 @@ static void usb_read_interrupt_complete(struct urb *purb)
 				c2w = kmalloc(sizeof(struct evt_work),
 						GFP_ATOMIC);
 
-				if (!c2w) {
-					printk(KERN_WARNING "%s: unable to "
-					       "allocate work buffer\n",
-					       __func__);
+				if (!c2w)
 					goto urb_submit;
-				}
 
 				c2w->adapter = padapter;
 				INIT_WORK(&c2w->work, rtw_evt_work);
diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index 537bd82..40bdf4b 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -1327,8 +1327,6 @@ static int rtw_cfg80211_set_probe_req_wpsp2pie(struct rtw_adapter *padapter,
 			pmlmepriv->wps_probe_req_ie = kmemdup(wps_ie, wps_ie[1],
 							      GFP_KERNEL);
 			if (pmlmepriv->wps_probe_req_ie == NULL) {
-				DBG_8723A("%s()-%d: kmalloc() ERROR!\n",
-					  __func__, __LINE__);
 				return -EINVAL;
 			}
 			pmlmepriv->wps_probe_req_ie_len = wps_ie[1];
@@ -2619,8 +2617,6 @@ static int rtw_cfg80211_add_monitor_if(struct rtw_adapter *padapter, char *name,
 	/*  wdev */
 	mon_wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!mon_wdev) {
-		DBG_8723A("%s(%s): allocate mon_wdev fail\n", __func__,
-			  padapter->pnetdev->name);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -3275,7 +3271,6 @@ int rtw_wdev_alloc(struct rtw_adapter *padapter, struct device *dev)
 	/*  wdev */
 	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
 	if (!wdev) {
-		DBG_8723A("Couldn't allocate wireless device\n");
 		ret = -ENOMEM;
 		goto free_wiphy;
 	}
-- 
1.9.1

