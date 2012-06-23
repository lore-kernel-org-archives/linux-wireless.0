Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:42901 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755771Ab2FWGmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:15 -0400
Received: by lbbgm6 with SMTP id gm6so4926492lbb.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:42:12 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 14/18] wlcore: don't allow SDIO read/writes after failure
Date: Sat, 23 Jun 2012 09:41:25 +0300
Message-Id: <1340433689-24320-15-git-send-email-coelho@ti.com> (sfid-20120623_085130_707324_185C7FB7)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Set a flag and after the first read/write failure is encountered.
This flag will disallow further SDIO read/writes until op_stop() is
executed, which will clear all flags.

This prevents further errors from occurring, since one error usually
indicates that IO operations won't work anymore until the chip is
rebooted.  By blocking more calls, we avoid extra timeouts and having
to wait for them to occur.

[Added second paragraph explaining why the change is needed. -- Luca]

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/io.h       |   22 ++++++++++++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    1 +
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 1cd545b..fef80ad 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -57,14 +57,32 @@ static inline int __must_check wlcore_raw_write(struct wl1271 *wl, int addr,
 						void *buf, size_t len,
 						bool fixed)
 {
-	return wl->if_ops->write(wl->dev, addr, buf, len, fixed);
+	int ret;
+
+	if (test_bit(WL1271_FLAG_SDIO_FAILED, &wl->flags))
+		return -EIO;
+
+	ret = wl->if_ops->write(wl->dev, addr, buf, len, fixed);
+	if (ret)
+		set_bit(WL1271_FLAG_SDIO_FAILED, &wl->flags);
+
+	return ret;
 }
 
 static inline int __must_check wlcore_raw_read(struct wl1271 *wl, int addr,
 					       void *buf, size_t len,
 					       bool fixed)
 {
-	return wl->if_ops->read(wl->dev, addr, buf, len, fixed);
+	int ret;
+
+	if (test_bit(WL1271_FLAG_SDIO_FAILED, &wl->flags))
+		return -EIO;
+
+	ret = wl->if_ops->read(wl->dev, addr, buf, len, fixed);
+	if (ret)
+		set_bit(WL1271_FLAG_SDIO_FAILED, &wl->flags);
+
+	return ret;
 }
 
 static inline int __must_check wlcore_raw_read_data(struct wl1271 *wl, int reg,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index e5a34dd..4273a21 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -247,6 +247,7 @@ enum wl12xx_flags {
 	WL1271_FLAG_RECOVERY_IN_PROGRESS,
 	WL1271_FLAG_VIF_CHANGE_IN_PROGRESS,
 	WL1271_FLAG_INTENDED_FW_RECOVERY,
+	WL1271_FLAG_SDIO_FAILED,
 };
 
 enum wl12xx_vif_flags {
-- 
1.7.10

