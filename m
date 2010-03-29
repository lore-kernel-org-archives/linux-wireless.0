Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:42146 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab0C2Ulo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 16:41:44 -0400
Subject: patch rt2860sta-fix-argument-to-linux_pci_unmap_single.patch added to 2.6.32-stable tree
To: ben@decadent.org.uk, bzolnier@gmail.com, gregkh@suse.de,
	johnhalton@gmail.com, linux-wireless@vger.kernel.org
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Mon, 29 Mar 2010 13:41:57 -0700
In-Reply-To: <1269821357.8653.231.camel@localhost>
Message-ID: <12698953171603@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: rt2860sta: Fix argument to linux_pci_unmap_single()

to the 2.6.32-stable tree.  Its filename is

    rt2860sta-fix-argument-to-linux_pci_unmap_single.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From ben@decadent.org.uk  Mon Mar 29 13:35:12 2010
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 29 Mar 2010 01:09:17 +0100
Subject: rt2860sta: Fix argument to linux_pci_unmap_single()
To: stable@kernel.org
Cc: 575726@bugs.debian.org, linux-wireless <linux-wireless@vger.kernel.org>, John Halton <johnhalton@gmail.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Message-ID: <1269821357.8653.231.camel@localhost>

From: Ben Hutchings <ben@decadent.org.uk>

John Halton wrote in <http://bugs.debian.org/575726>:
> Whenever wpa_supplicant is deactivated (whether by killing the process or
> during a normal shutdown) I am getting a kerneloops that prevents the
> computer from completing shutdown. Here is the relevant syslog output:

The backtrace points to an incorrect call from RTMPFreeTxRxRingMemory()
into linux_pci_unmap_single().  This appears to have been fixed in Linux
2.6.33 by this change:

commit ca97b8388838ee9ea4b4bad04948f8f7f8a607a3
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Tue Sep 22 20:44:07 2009 +0200

    Staging: rt28x0: updates from vendor's V2.1.0.0 drivers

For stable-2.6.32, just fix this one function call.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/common/2860_rtmp_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rt2860/common/2860_rtmp_init.c
+++ b/drivers/staging/rt2860/common/2860_rtmp_init.c
@@ -716,7 +716,7 @@ VOID RTMPFreeTxRxRingMemory(
 	{
 		if ((pAd->RxRing.Cell[index].DmaBuf.AllocVa) && (pAd->RxRing.Cell[index].pNdisPacket))
 		{
-			PCI_UNMAP_SINGLE(pObj->pci_dev, pAd->RxRing.Cell[index].DmaBuf.AllocPa, pAd->RxRing.Cell[index].DmaBuf.AllocSize, PCI_DMA_FROMDEVICE);
+			PCI_UNMAP_SINGLE(pAd, pAd->RxRing.Cell[index].DmaBuf.AllocPa, pAd->RxRing.Cell[index].DmaBuf.AllocSize, PCI_DMA_FROMDEVICE);
 			RELEASE_NDIS_PACKET(pAd, pAd->RxRing.Cell[index].pNdisPacket, NDIS_STATUS_SUCCESS);
 		}
 	}


Patches currently in stable-queue which might be from ben@decadent.org.uk are

