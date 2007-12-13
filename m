Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762779AbXLMG71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:27 -0500
Subject: [PATCH 64/48] libertas: wait for 'firmware ready' event from firmware after loading
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2j-0005s8-V9@shinybook.infradead.org> (sfid-20071213_070634_391102_E9961370)
Date: Thu, 13 Dec 2007 01:59:37 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 13:15:25 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/host.h   |    1 +
 drivers/net/wireless/libertas/if_usb.c |   26 +++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 4828bbf..b23af19 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -304,5 +304,6 @@ enum cmd_mesh_access_opts {
 #define MACREG_INT_CODE_RSSI_HIGH               28
 #define MACREG_INT_CODE_SNR_HIGH                29
 #define MACREG_INT_CODE_MESH_AUTO_STARTED       35
+#define MACREG_INT_CODE_FIRMWARE_READY          48
 
 #endif
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 6cd6c96..c94b6df 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -230,6 +230,7 @@ static int if_usb_probe(struct usb_interface *intf,
 		goto err_prog_firmware;
 
 	cardp->priv = priv;
+	cardp->priv->fw_ready = 1;
 
 	if (lbs_add_mesh(priv, &udev->dev))
 		goto err_add_mesh;
@@ -241,10 +242,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	priv->hw_read_event_cause = if_usb_read_event_cause;
 	priv->boot2_version = udev->descriptor.bcdDevice;
 
-	/* Delay 200 ms to waiting for the FW ready */
 	if_usb_submit_rx_urb(cardp);
-	msleep_interruptible(200);
-	priv->fw_ready = 1;
 
 	if (lbs_start_card(priv))
 		goto err_start_card;
@@ -514,6 +512,21 @@ static void if_usb_receive_fwload(struct urb *urb)
 		return;
 	}
 
+	if (cardp->fwdnldover) {
+		__le32 *tmp = (__le32 *)(skb->data + IPFIELD_ALIGN_OFFSET);
+
+		if (tmp[0] == cpu_to_le32(CMD_TYPE_INDICATION) &&
+		    tmp[1] == cpu_to_le32(MACREG_INT_CODE_FIRMWARE_READY)) {
+			lbs_pr_info("Firmware ready event received\n");
+			wake_up(&cardp->fw_wq);
+		} else {
+			lbs_deb_usb("Waiting for confirmation; got %x %x\n", le32_to_cpu(tmp[0]),
+				    le32_to_cpu(tmp[1]));
+			if_usb_submit_rx_urb_fwload(cardp);
+		}
+		kfree_skb(skb);
+		return;
+	}
 	if (cardp->bootcmdresp <= 0) {
 		memcpy (&bootcmdresp, skb->data + IPFIELD_ALIGN_OFFSET,
 			sizeof(bootcmdresp));
@@ -529,7 +542,8 @@ static void if_usb_receive_fwload(struct urb *urb)
 			if (bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_REQUEST) ||
 			    bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_DATA) ||
 			    bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_INDICATION)) {
-				lbs_pr_info("Firmware already seems alive; resetting\n");
+				if (!cardp->bootcmdresp)
+					lbs_pr_info("Firmware already seems alive; resetting\n");
 				cardp->bootcmdresp = -1;
 			} else {
 				lbs_pr_info("boot cmd response wrong magic number (0x%x)\n",
@@ -590,8 +604,9 @@ static void if_usb_receive_fwload(struct urb *urb)
 
 	if_usb_send_fw_pkt(cardp);
 
-	if_usb_submit_rx_urb_fwload(cardp);
  exit:
+	if_usb_submit_rx_urb_fwload(cardp);
+
 	kfree(syncfwheader);
 
 	return;
@@ -934,6 +949,7 @@ restart:
 	wait_event_interruptible(cardp->fw_wq, cardp->surprise_removed || cardp->fwdnldover);
 	
 	del_timer_sync(&cardp->fw_timeout);
+	usb_kill_urb(cardp->rx_urb);
 
 	if (!cardp->fwdnldover) {
 		lbs_pr_info("failed to load fw, resetting device!\n");
-- 
1.5.3.4

