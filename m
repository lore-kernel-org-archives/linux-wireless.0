Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35264 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbeIUDMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 23:12:43 -0400
From: Nathan Chancellor <natechancellor@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] staging: wilc1000: Remove unnecessary pointer check
Date: Thu, 20 Sep 2018 14:26:49 -0700
Message-Id: <20180920212648.25181-1-natechancellor@gmail.com> (sfid-20180920_232722_291989_52EE5BF8)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clang warns that the address of a pointer will always evaluated as true
in a boolean context:

drivers/staging/wilc1000/linux_wlan.c:267:20: warning: address of
'vif->ndev->dev' will always evaluate to 'true'
[-Wpointer-bool-conversion]
        if (!(&vif->ndev->dev))
            ~  ~~~~~~~~~~~^~~
1 warning generated.

Since this statement always evaluates to false due to the logical not,
remove it.

Link: https://github.com/ClangBuiltLinux/linux/issues/121
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 49afda669393..323593440e40 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -264,9 +264,6 @@ static int wilc_wlan_get_firmware(struct net_device *dev)
 
 	netdev_info(dev, "loading firmware %s\n", firmware);
 
-	if (!(&vif->ndev->dev))
-		goto fail;
-
 	if (request_firmware(&wilc_firmware, firmware, wilc->dev) != 0) {
 		netdev_err(dev, "%s - firmware not available\n", firmware);
 		ret = -1;
-- 
2.19.0
