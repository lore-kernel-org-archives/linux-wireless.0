Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4108 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab2I0MSQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 08:18:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/11] brcmfmac: use wait_event_timeout for fw control
 packets over usb.
Date: Thu, 27 Sep 2012 14:17:47 +0200
Message-ID: <1348748277-21460-2-git-send-email-arend@broadcom.com> (sfid-20120927_141822_456112_A38CF56E)
In-Reply-To: <1348748277-21460-1-git-send-email-arend@broadcom.com>
References: <1348748277-21460-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

firmware control packets over usb are async acked. This is
awaited for by using interruptible wait. This can be
interrupted by signal which results in undesirable behavior.
Instead wait_event_timeout is used.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |   46 +++++--------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 5fe6ec7..555ccdd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -160,40 +160,17 @@ static struct brcmf_usbdev_info *brcmf_usb_get_businfo(struct device *dev)
 	return brcmf_usb_get_buspub(dev)->devinfo;
 }
 
-static int brcmf_usb_ioctl_resp_wait(struct brcmf_usbdev_info *devinfo,
-	 uint *condition, bool *pending)
+static int brcmf_usb_ioctl_resp_wait(struct brcmf_usbdev_info *devinfo)
 {
-	DECLARE_WAITQUEUE(wait, current);
-	int timeout = IOCTL_RESP_TIMEOUT;
-
-	/* Convert timeout in millsecond to jiffies */
-	timeout = msecs_to_jiffies(timeout);
-	/* Wait until control frame is available */
-	add_wait_queue(&devinfo->ioctl_resp_wait, &wait);
-	set_current_state(TASK_INTERRUPTIBLE);
-
-	smp_mb();
-	while (!(*condition) && (!signal_pending(current) && timeout)) {
-		timeout = schedule_timeout(timeout);
-		/* Wait until control frame is available */
-		smp_mb();
-	}
-
-	if (signal_pending(current))
-		*pending = true;
-
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&devinfo->ioctl_resp_wait, &wait);
-
-	return timeout;
+	return wait_event_timeout(devinfo->ioctl_resp_wait,
+				  devinfo->ctl_completed,
+				  msecs_to_jiffies(IOCTL_RESP_TIMEOUT));
 }
 
-static int brcmf_usb_ioctl_resp_wake(struct brcmf_usbdev_info *devinfo)
+static void brcmf_usb_ioctl_resp_wake(struct brcmf_usbdev_info *devinfo)
 {
 	if (waitqueue_active(&devinfo->ioctl_resp_wait))
-		wake_up_interruptible(&devinfo->ioctl_resp_wait);
-
-	return 0;
+		wake_up(&devinfo->ioctl_resp_wait);
 }
 
 static void
@@ -322,7 +299,6 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 {
 	int err = 0;
 	int timeout = 0;
-	bool pending;
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 
 	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
@@ -340,9 +316,7 @@ static int brcmf_usb_tx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 		clear_bit(0, &devinfo->ctl_op);
 		return err;
 	}
-
-	timeout = brcmf_usb_ioctl_resp_wait(devinfo, &devinfo->ctl_completed,
-					    &pending);
+	timeout = brcmf_usb_ioctl_resp_wait(devinfo);
 	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
 		brcmf_dbg(ERROR, "Txctl wait timed out\n");
@@ -355,7 +329,6 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 {
 	int err = 0;
 	int timeout = 0;
-	bool pending;
 	struct brcmf_usbdev_info *devinfo = brcmf_usb_get_businfo(dev);
 
 	if (devinfo->bus_pub.state != BCMFMAC_USB_STATE_UP) {
@@ -365,15 +338,14 @@ static int brcmf_usb_rx_ctlpkt(struct device *dev, u8 *buf, u32 len)
 	if (test_and_set_bit(0, &devinfo->ctl_op))
 		return -EIO;
 
+	devinfo->ctl_completed = false;
 	err = brcmf_usb_recv_ctl(devinfo, buf, len);
 	if (err) {
 		brcmf_dbg(ERROR, "fail %d bytes: %d\n", err, len);
 		clear_bit(0, &devinfo->ctl_op);
 		return err;
 	}
-	devinfo->ctl_completed = false;
-	timeout = brcmf_usb_ioctl_resp_wait(devinfo, &devinfo->ctl_completed,
-					    &pending);
+	timeout = brcmf_usb_ioctl_resp_wait(devinfo);
 	err = devinfo->ctl_urb_status;
 	clear_bit(0, &devinfo->ctl_op);
 	if (!timeout) {
-- 
1.7.9.5


