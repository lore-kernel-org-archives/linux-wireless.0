Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab0JUFrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 01:47:11 -0400
Date: Thu, 21 Oct 2010 07:46:58 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org,
	kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [patch] Staging: bcm: use get_user() to access user pointers
Message-ID: <20101021054657.GE5985@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some places that dereference user pointers directly instead
of using get_user().

Please especially check my changes to IOCTL_BCM_GET_CURRENT_STATUS.  The
original code modified the struct which "arg" was pointing to.  I think
this was a bug in the original code and that we only wanted to write to
the OutputBuffer. Also with the original code you could read as much 
memory as you wanted so I had to put a cap on OutputLength.  The only
value of OutputLength that makes sense is sizeof(LINK_STATE) so now if
OutputLength is not sizeof(LINK_STATE) it returns -EINVAL.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't have this hardware.  Compile tested only.

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 77fdfe2..fead9c5 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1001,13 +1001,15 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		}
 #endif
 		case IOCTL_BE_BUCKET_SIZE:
-			Adapter->BEBucketSize = *(PULONG)arg;
-			Status = STATUS_SUCCESS;
+			Status = 0;
+			if (get_user(Adapter->BEBucketSize, (unsigned long __user *)arg))
+				Status = -EFAULT;
 			break;
 
 		case IOCTL_RTPS_BUCKET_SIZE:
-			Adapter->rtPSBucketSize = *(PULONG)arg;
-			Status = STATUS_SUCCESS;
+			Status = 0;
+			if (get_user(Adapter->rtPSBucketSize, (unsigned long __user *)arg))
+				Status = -EFAULT;
 			break;
 		case IOCTL_CHIP_RESET:
 	    {
@@ -1028,11 +1030,15 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		case IOCTL_QOS_THRESHOLD:
 		{
 			USHORT uiLoopIndex;
-			for(uiLoopIndex = 0 ; uiLoopIndex < NO_OF_QUEUES ; uiLoopIndex++)
-			{
-				Adapter->PackInfo[uiLoopIndex].uiThreshold = *(PULONG)arg;
+
+			Status = 0;
+			for (uiLoopIndex = 0; uiLoopIndex < NO_OF_QUEUES; uiLoopIndex++) {
+				if (get_user(Adapter->PackInfo[uiLoopIndex].uiThreshold,
+						(unsigned long __user *)arg)) {
+					Status = -EFAULT;
+					break;
+				}
 			}
-			Status = STATUS_SUCCESS;
 			break;
 		}
 
@@ -1093,7 +1099,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		}
 		case IOCTL_BCM_GET_CURRENT_STATUS:
 		{
-			LINK_STATE *plink_state = NULL;
+			LINK_STATE plink_state;
+
 			/* Copy Ioctl Buffer structure */
 			if(copy_from_user(&IoBuffer, argp, sizeof(IOCTL_BUFFER)))
 			{
@@ -1101,13 +1108,19 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 				Status = -EFAULT;
 				break;
 			}
-			plink_state = (LINK_STATE*)arg;
-			plink_state->bIdleMode = (UCHAR)Adapter->IdleMode;
-			plink_state->bShutdownMode = Adapter->bShutStatus;
-			plink_state->ucLinkStatus = (UCHAR)Adapter->LinkStatus;
-			if(copy_to_user(IoBuffer.OutputBuffer,
-				(PUCHAR)plink_state, (UINT)IoBuffer.OutputLength))
-			{
+			if (IoBuffer.OutputLength != sizeof(plink_state)) {
+				Status = -EINVAL;
+				break;
+			}
+
+			if (copy_from_user(&plink_state, (void __user *)arg, sizeof(plink_state))) {
+				Status = -EFAULT;
+				break;
+			}
+			plink_state.bIdleMode = (UCHAR)Adapter->IdleMode;
+			plink_state.bShutdownMode = Adapter->bShutStatus;
+			plink_state.ucLinkStatus = (UCHAR)Adapter->LinkStatus;
+			if (copy_to_user(IoBuffer.OutputBuffer, &plink_state, IoBuffer.OutputLength)) {
 				BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Copy_to_user Failed..\n");
 				Status = -EFAULT;
 				break;
@@ -1331,7 +1344,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 						BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0,"Copy From User space failed. status :%d", Status);
 						return -EFAULT;
 					}
-					uiSectorSize = *((PUINT)(IoBuffer.InputBuffer)); /* FIXME: unchecked __user access */
+					if (get_user(uiSectorSize, (unsigned int __user *)IoBuffer.InputBuffer))
+						return -EFAULT;
+
 					if((uiSectorSize < MIN_SECTOR_SIZE) || (uiSectorSize > MAX_SECTOR_SIZE))
 					{
 
