Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47620 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0BYLDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 06:03:37 -0500
Received: by fxm19 with SMTP id 19so6102184fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 03:03:36 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH] ath_hif_usb: don't oops if fw not found
Date: Thu, 25 Feb 2010 12:03:33 +0100
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002251203.33410.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_hif_usb oopses when the firmware file cannot be found. Fix this by
reordering init_usb_anchor in hif_init_dev so that hif_dev->rx_submitted
is actually initialized when usb_poison_anchored_urbs gets called as a
result of the failed firmware request.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Luis, would you like the oops/backtrace in the commitmessage as well?

 ath/ath9k/ath_hif_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ath/ath9k/ath_hif_usb.c b/ath/ath9k/ath_hif_usb.c
index 481dc67..9ee74c0 100644
--- a/ath/ath9k/ath_hif_usb.c
+++ b/ath/ath9k/ath_hif_usb.c
@@ -898,6 +898,8 @@ static int hif_init_dev(struct hif_device_usb *hif_dev, const char *fw_name)
 {
 	int r;
 
+	init_usb_anchor(&hif_dev->rx_submitted);
+
 	r = request_firmware(&hif_dev->firmware, fw_name, &hif_dev->udev->dev);
 	if (r) {
 		dev_err(&hif_dev->udev->dev, "ath_hif_usb: firmware "
@@ -905,8 +907,6 @@ static int hif_init_dev(struct hif_device_usb *hif_dev, const char *fw_name)
 		goto out;
 	}
 
-	init_usb_anchor(&hif_dev->rx_submitted);
-
 	if (ar9271_alloc_urbs(hif_dev))
 		goto fail_urbs;
 
-- 
1.6.0.2

