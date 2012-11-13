Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64480 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab2KMVEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 16:04:44 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so773358bkw.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 13:04:43 -0800 (PST)
Message-ID: <1352840676.8169.3.camel@user64-MCP7A> (sfid-20121113_220448_366265_86352669)
Subject: [PATCH] staging: vt6656: iwctl_giwaplist/device_ioctl : use off
 stack buffers.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Nov 2012 21:04:36 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calls ioctl SIOCGIWAPLIST use off stack buffers.

clears up warning messages.
main_usb.c:2015:1: warning: the frame size of 1888 bytes is larger than 1024 bytes [-Wframe-larger-than=]
iwctl.c:683:1: warning: the frame size of 1280 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |   73 +++++++++++++++++++++----------------
 drivers/staging/vt6656/main_usb.c |   46 +++++++++++++----------
 2 files changed, 68 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 706e2a6..a914d20 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -632,47 +632,56 @@ int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
  * Wireless Handler: get ap list
  */
 int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *wrq, char *extra)
+		struct iw_point *wrq, u8 *extra)
 {
+	struct sockaddr *sock;
+	struct iw_quality *qual;
+	PSDevice pDevice = netdev_priv(dev);
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	PKnownBSS pBSS = &pMgmt->sBSSList[0];
 	int ii;
 	int jj;
-	int rc = 0;
-	struct sockaddr sock[IW_MAX_AP];
-	struct iw_quality qual[IW_MAX_AP];
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST \n");
-	// Only super-user can see AP list
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST\n");
+	/* Only super-user can see AP list */
 
-	if (!capable(CAP_NET_ADMIN)) {
-		rc = -EPERM;
-		return rc;
-	}
+	if (pBSS == NULL)
+		return -ENODEV;
 
-	if (wrq->pointer) {
-		PKnownBSS pBSS = &(pMgmt->sBSSList[0]);
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
 
-		for (ii = 0, jj= 0; ii < MAX_BSS_NUM; ii++) {
-			pBSS = &(pMgmt->sBSSList[ii]);
-			if (!pBSS->bActive)
-				continue;
-			if (jj >= IW_MAX_AP)
-				break;
-			memcpy(sock[jj].sa_data, pBSS->abyBSSID, 6);
-			sock[jj].sa_family = ARPHRD_ETHER;
-			qual[jj].level = pBSS->uRSSI;
-			qual[jj].qual = qual[jj].noise = 0;
-			qual[jj].updated = 2;
-			jj++;
-		}
+	if (!wrq->pointer)
+		return -EINVAL;
+
+	sock = kzalloc(sizeof(struct sockaddr) * IW_MAX_AP, GFP_KERNEL);
+	qual = kzalloc(sizeof(struct iw_quality) * IW_MAX_AP, GFP_KERNEL);
+	if (sock == NULL || qual == NULL)
+		return -ENOMEM;
 
-		wrq->flags = 1; // Should be defined
-		wrq->length = jj;
-		memcpy(extra, sock, sizeof(struct sockaddr) * jj);
-		memcpy(extra + sizeof(struct sockaddr) * jj, qual, sizeof(struct iw_quality) * jj);
+	for (ii = 0, jj = 0; ii < MAX_BSS_NUM; ii++) {
+		if (!pBSS[ii].bActive)
+			continue;
+		if (jj >= IW_MAX_AP)
+			break;
+		memcpy(sock[jj].sa_data, pBSS[ii].abyBSSID, 6);
+		sock[jj].sa_family = ARPHRD_ETHER;
+		qual[jj].level = pBSS[ii].uRSSI;
+		qual[jj].qual = qual[jj].noise = 0;
+		qual[jj].updated = 2;
+		jj++;
 	}
-	return rc;
+
+	wrq->flags = 1; /* Should be defined */
+	wrq->length = jj;
+	memcpy(extra, sock, sizeof(struct sockaddr) * jj);
+	memcpy(extra + sizeof(struct sockaddr) * jj, qual,
+		sizeof(struct iw_quality) * jj);
+
+	kfree(sock);
+	kfree(qual);
+
+	return 0;
 }
 
 /*
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index d8cb093..f3c44ae 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1555,12 +1555,12 @@ static struct net_device_stats *device_get_stats(struct net_device *dev) {
 
 
 static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    PSCmdRequest        pReq;
-    //BOOL                bCommit = FALSE;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	PSCmdRequest pReq;
+	u8 *buffer;
 	struct iwreq *wrq = (struct iwreq *) rq;
-	int                 rc =0;
+	int rc = 0;
 
     if (pMgmt == NULL) {
         rc = -EFAULT;
@@ -1797,20 +1797,28 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		break;
 
 	case SIOCGIWAPLIST:
-	    {
-            char buffer[IW_MAX_AP * (sizeof(struct sockaddr) + sizeof(struct iw_quality))];
-
-		    if (wrq->u.data.pointer) {
-		        rc = iwctl_giwaplist(dev, NULL, &(wrq->u.data), buffer);
-		        if (rc == 0) {
-                    if (copy_to_user(wrq->u.data.pointer,
-					                buffer,
-					               (wrq->u.data.length * (sizeof(struct sockaddr) +  sizeof(struct iw_quality)))
-				        ))
-				    rc = -EFAULT;
-		        }
-            }
-        }
+		if (wrq->u.data.pointer) {
+			buffer = kzalloc((sizeof(struct sockaddr) +
+				sizeof(struct iw_quality)) * IW_MAX_AP,
+					GFP_KERNEL);
+			if (buffer == NULL) {
+				rc = -ENOMEM;
+				break;
+			}
+
+			rc = iwctl_giwaplist(dev, NULL, &(wrq->u.data), buffer);
+			if (rc < 0) {
+				kfree(buffer);
+				break;
+			}
+
+			if (copy_to_user(wrq->u.data.pointer, buffer,
+				wrq->u.data.length * (sizeof(struct sockaddr)
+					+ sizeof(struct iw_quality))))
+				rc = -EFAULT;
+
+			kfree(buffer);
+		}
 		break;
 
 
-- 
1.7.10.4


