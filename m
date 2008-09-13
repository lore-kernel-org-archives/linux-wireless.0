Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:45800 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYIMLWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 07:22:12 -0400
Received: by ey-out-2122.google.com with SMTP id 6so541628eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 13 Sep 2008 04:22:10 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, jt@hpl.hp.com, simon@thekelleys.org.uk,
	jussi.kivilinna@mbnet.fi, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH] wireless: Read scan flags correctly on x86-64
Date: Sat, 13 Sep 2008 12:22:05 +0100
Message-Id: <1221304925-13057-1-git-send-email-kilroyd@googlemail.com> (sfid-20080913_132217_778303_A0181885)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SIOCSIWSCAN handler is passed data in an iw_point structure. Some
drivers erronously use an iw_param instead.

On 32 bit architectures the difference isn't noticed as the flags
parameter tends to be the only one used by scan handlers and is at the
same offset.

On 64 bit architectures the pointer in the iw_point structure means the
flag parameter is at different offsets in these structures.

Thanks to Jean Tourrilhes for tracking this down for orinoco, and Pavel
Roskin for confirming the fix and identifying other suspect handlers.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---

This is a latent bug in airo, atmel and orinoco drivers on 2.6.27-rcs.
The addition of ESSID specific scanning to the orinoco driver triggers
the bug in wireless-next.

---
 drivers/net/wireless/airo.c       |    2 +-
 drivers/net/wireless/atmel.c      |    2 +-
 drivers/net/wireless/orinoco.c    |    2 +-
 drivers/net/wireless/rndis_wlan.c |    3 +--
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index ae58a12..370133e 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -7107,7 +7107,7 @@ static int airo_get_aplist(struct net_device *dev,
  */
 static int airo_set_scan(struct net_device *dev,
 			 struct iw_request_info *info,
-			 struct iw_param *vwrq,
+			 struct iw_point *dwrq,
 			 char *extra)
 {
 	struct airo_info *ai = dev->priv;
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index bd35bb0..695a119 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -2257,7 +2257,7 @@ static int atmel_get_freq(struct net_device *dev,
 
 static int atmel_set_scan(struct net_device *dev,
 			  struct iw_request_info *info,
-			  struct iw_param *vwrq,
+			  struct iw_point *dwrq,
 			  char *extra)
 {
 	struct atmel_private *priv = netdev_priv(dev);
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 9a2fcc0..5090477 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -5291,7 +5291,7 @@ static int orinoco_ioctl_getrid(struct net_device *dev,
 /* Trigger a scan (look for other cells in the vicinity) */
 static int orinoco_ioctl_setscan(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *srq,
+				 struct iw_point *srq,
 				 char *extra)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 00e965b..2b41489 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1627,7 +1627,6 @@ static int rndis_iw_set_encode_ext(struct net_device *dev,
 static int rndis_iw_set_scan(struct net_device *dev,
     struct iw_request_info *info, union iwreq_data *wrqu, char *extra)
 {
-	struct iw_param *param = &wrqu->param;
 	struct usbnet *usbdev = dev->priv;
 	union iwreq_data evt;
 	int ret = -EINVAL;
@@ -1635,7 +1634,7 @@ static int rndis_iw_set_scan(struct net_device *dev,
 
 	devdbg(usbdev, "SIOCSIWSCAN");
 
-	if (param->flags == 0) {
+	if (wrqu->data.flags == 0) {
 		tmp = ccpu2(1);
 		ret = rndis_set_oid(usbdev, OID_802_11_BSSID_LIST_SCAN, &tmp,
 								sizeof(tmp));
-- 
1.5.6.4

