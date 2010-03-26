Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:60975 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753338Ab0CZKvU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:51:20 -0400
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
To: chunkeey@web.de, linux-wireless@vger.kernel.org
Cc: Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH] setup correct int pipe type in ar9170_usb_exec_cmd
Date: Fri, 26 Mar 2010 11:44:33 +0100
Message-Id: <1269600273-7974-1-git-send-email-valentin.longchamp@epfl.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An int urb is constructed but we fill it in with a bulk pipe type.

Commit f661c6f8c67bd55e93348f160d590ff9edf08904 implemented a pipe type
check when CONFIG_USB_DEBUG is enabled. The check failed for all the ar9170
usb transfers and the driver could not configure the wifi dongle.

This went unnoticed until now because most people don't have
CONFIG_USB_DEBUG enabled.

Signed-off-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
---
 drivers/net/wireless/ath/ar9170/usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/usb.c b/drivers/net/wireless/ath/ar9170/usb.c
index 4e30197..dbde2de 100644
--- a/drivers/net/wireless/ath/ar9170/usb.c
+++ b/drivers/net/wireless/ath/ar9170/usb.c
@@ -416,7 +416,7 @@ static int ar9170_usb_exec_cmd(struct ar9170 *ar, enum ar9170_cmd cmd,
 	spin_unlock_irqrestore(&aru->common.cmdlock, flags);
 
 	usb_fill_int_urb(urb, aru->udev,
-			 usb_sndbulkpipe(aru->udev, AR9170_EP_CMD),
+			 usb_sndintpipe(aru->udev, AR9170_EP_CMD),
 			 aru->common.cmdbuf, plen + 4,
 			 ar9170_usb_tx_urb_complete, NULL, 1);
 
-- 
1.6.3.3

