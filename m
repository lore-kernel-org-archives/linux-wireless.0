Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45224 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab0DVJau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 05:30:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 02:30:50 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19408.5931.990166.775249@gargle.gargle.HOWL>
Date: Thu, 22 Apr 2010 15:00:19 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k_htc: Really fix device hotunplug
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All commands to the target are disabled when the device
is unplugged, but a normal module unload has to be
differentiated from this case, as we could still receive
data in the RX endpoint. Fix this by checking if the
device is attached or not.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 6e34852..ea92758 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -913,7 +913,8 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 		(struct hif_device_usb *) usb_get_intfdata(interface);
 
 	if (hif_dev) {
-		ath9k_htc_hw_deinit(hif_dev->htc_handle, true);
+		ath9k_htc_hw_deinit(hif_dev->htc_handle,
+		    (udev->state == USB_STATE_NOTATTACHED) ? true : false);
 		ath9k_htc_hw_free(hif_dev->htc_handle);
 		ath9k_hif_usb_dev_deinit(hif_dev);
 		usb_set_intfdata(interface, NULL);
-- 
1.7.0.5

