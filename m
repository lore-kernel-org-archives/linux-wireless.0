Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:53106 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751244AbaETTOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 15:14:09 -0400
Message-ID: <1400613243.26709.26.camel@joe-AO725> (sfid-20140520_211413_216813_2B28B9E0)
Subject: [PATCH] staging: realtek: Convert /n to \n
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Tue, 20 May 2014 12:14:03 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use proper line terminations.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c | 2 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   | 2 +-
 drivers/staging/rtl8723au/hal/usb_ops_linux.c | 4 ++--
 drivers/staging/rtl8723au/os_dep/usb_intf.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index d8fc747..d9f60ab 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -558,7 +558,7 @@ static void usb_read_port_complete(struct urb *purb, struct pt_regs *regs)
 			rtw_read_port(adapt, precvpriv->ff_hwaddr, 0, (unsigned char *)precvbuf);
 			break;
 		case -EINPROGRESS:
-			DBG_88E("ERROR: URB IS IN PROGRESS!/n");
+			DBG_88E("ERROR: URB IS IN PROGRESS!\n");
 			break;
 		default:
 			break;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 8ed2ac8..c63e263 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -88,7 +88,7 @@ static u8 rtw_init_intf_priv(struct dvobj_priv *dvobj)
 
 	dvobj->usb_alloc_vendor_req_buf = rtw_zmalloc(MAX_USB_IO_CTL_SIZE);
 	if (dvobj->usb_alloc_vendor_req_buf == NULL) {
-		DBG_88E("alloc usb_vendor_req_buf failed... /n");
+		DBG_88E("alloc usb_vendor_req_buf failed...\n");
 		rst = _FAIL;
 		goto exit;
 	}
diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
index 73b49ac..df2e884 100644
--- a/drivers/staging/rtl8723au/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
@@ -439,7 +439,7 @@ urb_submit:
 		case -EPROTO:
 			break;
 		case -EINPROGRESS:
-			DBG_8723A("ERROR: URB IS IN PROGRESS!/n");
+			DBG_8723A("ERROR: URB IS IN PROGRESS!\n");
 			break;
 		default:
 			break;
@@ -734,7 +734,7 @@ static void usb_read_port_complete(struct urb *purb)
 					    precvbuf);
 			break;
 		case -EINPROGRESS:
-			DBG_8723A("ERROR: URB IS IN PROGRESS!/n");
+			DBG_8723A("ERROR: URB IS IN PROGRESS!\n");
 			break;
 		default:
 			break;
diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c b/drivers/staging/rtl8723au/os_dep/usb_intf.c
index d00ccdc..f78be19 100644
--- a/drivers/staging/rtl8723au/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8723au/os_dep/usb_intf.c
@@ -107,7 +107,7 @@ static int rtw_init_intf_priv(struct dvobj_priv *dvobj)
 	dvobj->usb_alloc_vendor_req_buf = kzalloc(MAX_USB_IO_CTL_SIZE,
 						  GFP_KERNEL);
 	if (dvobj->usb_alloc_vendor_req_buf == NULL) {
-		DBG_8723A("alloc usb_vendor_req_buf failed... /n");
+		DBG_8723A("alloc usb_vendor_req_buf failed...\n");
 		rst = _FAIL;
 		goto exit;
 	}


