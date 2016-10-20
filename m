Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:32821 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935266AbcJTIyk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 04:54:40 -0400
Received: by mail-pf0-f178.google.com with SMTP id 128so32714773pfz.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2016 01:54:39 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH] staging: wilc1000: Remove unused function wilc_lock_timeout
Date: Thu, 20 Oct 2016 14:24:32 +0530
Message-Id: <1476953672-2198-1-git-send-email-binoy.jayan@linaro.org> (sfid-20161020_105459_907576_D8E933A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Semaphore are going away in the future, so remove the unused function
wilc_lock_timeout which calls a semaphore api but has no users.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
---

They following is a patch which removes semaphores from wilc1000.
Its part of a bigger effort to eliminate all semaphores
from the linux kernel.

 drivers/staging/wilc1000/linux_wlan.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 6370a5e..470d59f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -218,17 +218,6 @@ static void deinit_irq(struct net_device *dev)
 	}
 }
 
-int wilc_lock_timeout(struct wilc *nic, void *vp, u32 timeout)
-{
-	/* FIXME: replace with mutex_lock or wait_for_completion */
-	int error = -1;
-
-	if (vp)
-		error = down_timeout(vp,
-				     msecs_to_jiffies(timeout));
-	return error;
-}
-
 void wilc_mac_indicate(struct wilc *wilc, int flag)
 {
 	int status;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
