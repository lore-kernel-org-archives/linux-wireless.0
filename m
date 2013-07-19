Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54294 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab3GSSQd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 14:16:33 -0400
Received: from zwerg.Speedport_W_723V_1_28_000 ([93.218.114.45]) by
 mail.gmx.com (mrgmx103) with ESMTPSA (Nemesis) id 0MAy40-1UsaFM2YFA-009zTb
 for <linux-wireless@vger.kernel.org>; Fri, 19 Jul 2013 20:16:32 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 2/2] ath9k_htc: reboot firmware if it was loaded
Date: Fri, 19 Jul 2013 20:16:18 +0200
Message-Id: <1374257778-9758-3-git-send-email-linux@rempel-privat.de> (sfid-20130719_201635_434936_A15DBCE0)
In-Reply-To: <1374257778-9758-1-git-send-email-linux@rempel-privat.de>
References: <1374257778-9758-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ath9k_htc will reboot firmware only if interface was
ever started. Which lead to the problem in case where interface
was never started but module need to be reloaded.

This patch will partially fix bug "ath9k_htc: Target is unresponsive"
https://github.com/qca/open-ath9k-htc-firmware/issues/1

Reproduction case:
- plug adapter
- make sure nothing will touch it. Stop Networkmanager or blacklist mac address of this adapter.
- rmmod ath9k_htc; sleep 1; modprobe ath9k_htc

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 2469db5..5205a36 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1295,7 +1295,9 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 
 	usb_set_intfdata(interface, NULL);
 
-	if (!unplugged && (hif_dev->flags & HIF_USB_START))
+	/* If firmware was loaded we should drop it
+	 * go back to first stage bootloader. */
+	if (!unplugged && (hif_dev->flags & HIF_USB_READY))
 		ath9k_hif_usb_reboot(udev);
 
 	kfree(hif_dev);
-- 
1.8.1.2

