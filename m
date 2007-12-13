Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55893 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762776AbXLMG7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:20 -0500
Subject: [PATCH 57/48] libertas: switch to a waitqueue and timer for handling USB firmware load
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2Y-0005rR-SL@shinybook.infradead.org> (sfid-20071213_065941_311189_F7412C70)
Date: Thu, 13 Dec 2007 01:59:26 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 00:07:58 -0500

No need to busy-wait, even if we did have a 100ms delay in the loop.
This makes it easier to support the new 'firmware ready' event which is
in the new firmware, too.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |   38 +++++++++++++++++++++----------
 drivers/net/wireless/libertas/if_usb.h |    5 ++++
 2 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 0a37950..a086653 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -113,7 +113,18 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
 		lbs_deb_usb("Setting boot2 version failed\n");
 }
 
+void if_usb_fw_timeo(unsigned long priv)
+{
+	struct usb_card_rec *cardp = (void *)priv;
 
+	if (cardp->fwdnldover) {
+		lbs_deb_usb("Download complete, no event. Assuming success\n");
+	} else {
+		lbs_pr_err("Download timed out\n");
+		cardp->surprise_removed = 1;
+	}
+	wake_up(&cardp->fw_wq);
+}
 /**
  *  @brief sets the configuration values
  *  @param ifnum	interface number
@@ -138,6 +149,9 @@ static int if_usb_probe(struct usb_interface *intf,
 		goto error;
 	}
 
+	setup_timer(&cardp->fw_timeout, if_usb_fw_timeo, (unsigned long)cardp);
+	init_waitqueue_head(&cardp->fw_wq);
+								     
 	cardp->udev = udev;
 	iface_desc = intf->cur_altsetting;
 
@@ -296,7 +310,7 @@ static void if_usb_disconnect(struct usb_interface *intf)
  *  @param priv		pointer to struct lbs_private
  *  @return 	   	0
  */
-static int if_prog_firmware(struct usb_card_rec *cardp)
+static int if_usb_send_fw_pkt(struct usb_card_rec *cardp)
 {
 	struct FWData *fwdata;
 	struct fwheader *fwheader;
@@ -566,19 +580,21 @@ static void if_usb_receive_fwload(struct urb *urb)
 
 	kfree_skb(skb);
 
+	/* reschedule timer for 200ms hence */
+	mod_timer(&cardp->fw_timeout, jiffies + (HZ/5));
+
 	if (cardp->fwfinalblk) {
 		cardp->fwdnldover = 1;
 		goto exit;
 	}
 
-	if_prog_firmware(cardp);
+	if_usb_send_fw_pkt(cardp);
 
 	if_usb_submit_rx_urb_fwload(cardp);
-exit:
+ exit:
 	kfree(syncfwheader);
 
 	return;
-
 }
 
 #define MRVDRV_MIN_PKT_LEN	30
@@ -911,15 +927,13 @@ restart:
 	cardp->totalbytes = 0;
 	cardp->fwfinalblk = 0;
 
-	if_prog_firmware(cardp);
+	/* Send the first firmware packet... */
+	if_usb_send_fw_pkt(cardp);
 
-	do {
-		lbs_deb_usbd(&cardp->udev->dev,"Wlan sched timeout\n");
-		i++;
-		msleep_interruptible(100);
-		if (cardp->surprise_removed || i >= 20)
-			break;
-	} while (!cardp->fwdnldover);
+	/* ... and wait for the process to complete */
+	wait_event_interruptible(cardp->fw_wq, cardp->surprise_removed || cardp->fwdnldover);
+	
+	del_timer_sync(&cardp->fw_timeout);
 
 	if (!cardp->fwdnldover) {
 		lbs_pr_info("failed to load fw, resetting device!\n");
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index 940a369..224c957 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -1,6 +1,9 @@
 #ifndef _LBS_IF_USB_H
 #define _LBS_IF_USB_H
 
+#include <linux/wait.h>
+#include <linux/timer.h>
+
 /**
   * This file contains definition for USB interface.
   */
@@ -56,6 +59,8 @@ struct usb_card_rec {
 	u8 bulk_out_endpointAddr;
 
 	const struct firmware *fw;
+	struct timer_list fw_timeout;
+	wait_queue_head_t fw_wq;
 	u8 CRC_OK;
 	u32 fwseqnum;
 	u32 lastseqnum;
-- 
1.5.3.4

