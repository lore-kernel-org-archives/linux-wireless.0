Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:57515 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab2GHHXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:46 -0400
Received: by lbon10 with SMTP id n10so14564128lbo.41
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:43 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 3/8] wlcore: don't set SDIO_FAILED flag when driver state is off
Date: Sun,  8 Jul 2012 10:23:26 +0300
Message-Id: <1341732211-25871-4-git-send-email-coelho@ti.com> (sfid-20120708_092358_252855_80613BB0)
In-Reply-To: <1341732211-25871-1-git-send-email-coelho@ti.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If some IO read/write fails while the FW is not loaded, a recovery
will not take place. This means the SDIO_FAILED flag will stay in place
forever and prevent further read/writes.

This can happen if a check for STATE_OFF was forgotten in some routine.

Take this opportunity to rename the flag to IO_FAILED, since we support
other buses as well.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/io.h       |   12 ++++++------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 458da55..259149f 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -60,12 +60,12 @@ static inline int __must_check wlcore_raw_write(struct wl1271 *wl, int addr,
 {
 	int ret;
 
-	if (test_bit(WL1271_FLAG_SDIO_FAILED, &wl->flags))
+	if (test_bit(WL1271_FLAG_IO_FAILED, &wl->flags))
 		return -EIO;
 
 	ret = wl->if_ops->write(wl->dev, addr, buf, len, fixed);
-	if (ret)
-		set_bit(WL1271_FLAG_SDIO_FAILED, &wl->flags);
+	if (ret && wl->state != WL1271_STATE_OFF)
+		set_bit(WL1271_FLAG_IO_FAILED, &wl->flags);
 
 	return ret;
 }
@@ -76,12 +76,12 @@ static inline int __must_check wlcore_raw_read(struct wl1271 *wl, int addr,
 {
 	int ret;
 
-	if (test_bit(WL1271_FLAG_SDIO_FAILED, &wl->flags))
+	if (test_bit(WL1271_FLAG_IO_FAILED, &wl->flags))
 		return -EIO;
 
 	ret = wl->if_ops->read(wl->dev, addr, buf, len, fixed);
-	if (ret)
-		set_bit(WL1271_FLAG_SDIO_FAILED, &wl->flags);
+	if (ret && wl->state != WL1271_STATE_OFF)
+		set_bit(WL1271_FLAG_IO_FAILED, &wl->flags);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index a760407..2a0e896 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -238,7 +238,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_RECOVERY_IN_PROGRESS,
 	WL1271_FLAG_VIF_CHANGE_IN_PROGRESS,
 	WL1271_FLAG_INTENDED_FW_RECOVERY,
-	WL1271_FLAG_SDIO_FAILED,
+	WL1271_FLAG_IO_FAILED,
 };
 
 enum wl12xx_vif_flags {
-- 
1.7.10

