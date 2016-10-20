Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34906 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756436AbcJTJgi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 05:36:38 -0400
Received: by mail-pf0-f176.google.com with SMTP id s8so33352657pfj.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2016 02:36:37 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v2] staging: wilc1000: Remove unused function wilc_lock_timeout
Date: Thu, 20 Oct 2016 15:06:30 +0530
Message-Id: <1476956190-7507-1-git-send-email-binoy.jayan@linaro.org> (sfid-20161020_113714_740470_EB628D81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Semaphore are going away in the future, so remove the unused function
wilc_lock_timeout which calls a semaphore api but has no users.

Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---

They following is a patch [v2] which removes semaphores from wilc1000.
Its part of a bigger effort to eliminate all semaphores
from the linux kernel.

Arnd, Thank you for reviewing. Removed the prototype as well.

 drivers/staging/wilc1000/linux_wlan.c         | 11 -----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 -
 2 files changed, 12 deletions(-)

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
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ec6b167..d431673 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -225,7 +225,6 @@ struct WILC_WFI_mon_priv {
 
 void wilc_frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void wilc_mac_indicate(struct wilc *wilc, int flag);
-int wilc_lock_timeout(struct wilc *wilc, void *, u32 timeout);
 void wilc_netdev_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc, struct device *, int io_type, int gpio,
 		     const struct wilc_hif_func *ops);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
