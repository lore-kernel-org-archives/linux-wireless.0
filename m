Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50076 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbbLJMnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 07:43:22 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Kosuke Tatsukawa <tatsu@ab.jp.nec.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 09/13] brcmfmac: fix waitqueue_active without memory barrier in brcmfmac driver
Date: Thu, 10 Dec 2015 13:43:08 +0100
Message-ID: <1449751392-32569-10-git-send-email-arend@broadcom.com> (sfid-20151210_134330_534278_E5AF6D67)
In-Reply-To: <1449751392-32569-1-git-send-email-arend@broadcom.com>
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>

brcmf_msgbuf_ioctl_resp_wake() seems to be missing a memory barrier
which might cause the waker to not notice the waiter and miss sending a
wake_up as in the following figure.

  brcmf_msgbuf_ioctl_resp_wake		    brcmf_msgbuf_ioctl_resp_wait
------------------------------------------------------------------------
if (waitqueue_active(&msgbuf->ioctl_resp_wait))
/* The CPU might reorder the test for
   the waitqueue up here, before
   prior writes complete */
   	   	     	 	       /* wait_event_timeout */
				        /* __wait_event_timeout */
					 /* ___wait_event */
					 prepare_to_wait_event(&wq, &__wait,
					   state);
					 if (msgbuf->ctl_completed)
					 ...
msgbuf->ctl_completed = true;
					 schedule_timeout(__ret))
------------------------------------------------------------------------

There are three other place in drivers/net/wireless/brcm80211/brcmfmac/
which have similar code.  The attached patch removes the call to
waitqueue_active() leaving just wake_up() behind.  This fixes the
problem because the call to spin_lock_irqsave() in wake_up() will be an
ACQUIRE operation.

I found this issue when I was looking through the linux source code
for places calling waitqueue_active() before wake_up*(), but without
preceding memory barriers, after sending a patch to fix a similar
issue in drivers/tty/n_tty.c  (Details about the original issue can be
found here: https://lkml.org/lkml/2015/9/28/849).

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 3 +--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 6 ++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c    | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 44e618f..5df9138 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -473,8 +473,7 @@ static int brcmf_msgbuf_ioctl_resp_wait(struct brcmf_msgbuf *msgbuf)
 static void brcmf_msgbuf_ioctl_resp_wake(struct brcmf_msgbuf *msgbuf)
 {
 	msgbuf->ctl_completed = true;
-	if (waitqueue_active(&msgbuf->ioctl_resp_wait))
-		wake_up(&msgbuf->ioctl_resp_wait);
+	wake_up(&msgbuf->ioctl_resp_wait);
 }
 
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 9fa3a3a..ceb2a75 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1678,8 +1678,7 @@ static int brcmf_sdio_dcmd_resp_wait(struct brcmf_sdio *bus, uint *condition,
 
 static int brcmf_sdio_dcmd_resp_wake(struct brcmf_sdio *bus)
 {
-	if (waitqueue_active(&bus->dcmd_resp_wait))
-		wake_up_interruptible(&bus->dcmd_resp_wait);
+	wake_up_interruptible(&bus->dcmd_resp_wait);
 
 	return 0;
 }
@@ -2003,8 +2002,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 static void
 brcmf_sdio_wait_event_wakeup(struct brcmf_sdio *bus)
 {
-	if (waitqueue_active(&bus->ctrl_wait))
-		wake_up_interruptible(&bus->ctrl_wait);
+	wake_up_interruptible(&bus->ctrl_wait);
 	return;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index ccde559..23eaf0f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -196,8 +196,7 @@ static int brcmf_usb_ioctl_resp_wait(struct brcmf_usbdev_info *devinfo)
 
 static void brcmf_usb_ioctl_resp_wake(struct brcmf_usbdev_info *devinfo)
 {
-	if (waitqueue_active(&devinfo->ioctl_resp_wait))
-		wake_up(&devinfo->ioctl_resp_wait);
+	wake_up(&devinfo->ioctl_resp_wait);
 }
 
 static void
-- 
1.9.1

