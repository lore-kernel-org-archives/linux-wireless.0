Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58062 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab2IMCdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 22:33:45 -0400
Received: by pbbrr13 with SMTP id rr13so3234905pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2012 19:33:45 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH -next] wireless: ath9k-htc: fix possible use after free
Date: Thu, 13 Sep 2012 10:33:28 +0800
Message-Id: <1347503608-3521-1-git-send-email-ming.lei@canonical.com> (sfid-20120913_043349_565821_B4CC953F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inside ath9k_hif_usb_firmware_fail(), the instance of
'struct struct hif_device_usb' may be freed by
ath9k_hif_usb_disconnect() after

	complete(&hif_dev->fw_done);

But 'hif_dev' is still accessed after the line code
above is executed.

This patch fixes the issue by not accessing 'hif_dev'
after 'complete(&hif_dev->fw_done)' inside
ath9k_hif_usb_firmware_fail().

Cc: ath9k-devel@lists.ath9k.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index ee6e50a..924c461 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1072,14 +1072,15 @@ static void ath9k_hif_usb_dev_deinit(struct hif_device_usb *hif_dev)
  */
 static void ath9k_hif_usb_firmware_fail(struct hif_device_usb *hif_dev)
 {
-	struct device *parent = hif_dev->udev->dev.parent;
+	struct device *dev = &hif_dev->udev->dev;
+	struct device *parent = dev->parent;
 
 	complete(&hif_dev->fw_done);
 
 	if (parent)
 		device_lock(parent);
 
-	device_release_driver(&hif_dev->udev->dev);
+	device_release_driver(dev);
 
 	if (parent)
 		device_unlock(parent);
-- 
1.7.9.5

