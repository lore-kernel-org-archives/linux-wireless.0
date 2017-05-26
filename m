Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33334 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966991AbdEZPDa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 11:03:30 -0400
Received: by mail-pf0-f194.google.com with SMTP id f27so3362271pfe.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 May 2017 08:03:29 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH] rsi: use subdirectory for firmware file
Date: Fri, 26 May 2017 20:31:31 +0530
Message-Id: <1495810891-2914-1-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170526_170406_992666_CCCDCFDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux-firmware maintainers prefer to have a subdirectory for
firmware files. Code is changed here to pick firmware file from
a subdirectory. Firmware file with a new loading mechanism will
be submitted inside rsi directory.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index d49dbaa..3d24e8e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -22,7 +22,7 @@
 /* FLASH Firmware */
 static struct ta_metadata metadata_flash_content[] = {
 	{"flash_content", 0x00010000},
-	{"rs9113_wlan_qspi.rps", 0x00010000},
+	{"rsi/rs9113_wlan_qspi.rps", 0x00010000},
 };
 
 /**
-- 
2.7.4
