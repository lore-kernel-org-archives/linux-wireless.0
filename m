Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61885 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaBJLrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:47:47 -0500
Received: by mail-wg0-f54.google.com with SMTP id x13so4168362wgg.9
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:47:46 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/18] wlcore: block read/writes to FW during ELP
Date: Mon, 10 Feb 2014 13:47:19 +0200
Message-Id: <1392032854-28126-4-git-send-email-eliad@wizery.com> (sfid-20140210_124751_576441_DC9C9114)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Barak Bercovitz <barak@wizery.com>

When the chip is in ELP mode read/write to FW is invalid and may cause
the lower layers to get stuck. The reads/writes concerning ELP wakeup
are the exception here and are checked for. In addition to blocking the
IO, produce a warning.

Signed-off-by: Barak Bercovitz <barak@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/io.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 07e3d6a..0305729 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -60,7 +60,9 @@ static inline int __must_check wlcore_raw_write(struct wl1271 *wl, int addr,
 {
 	int ret;
 
-	if (test_bit(WL1271_FLAG_IO_FAILED, &wl->flags))
+	if (test_bit(WL1271_FLAG_IO_FAILED, &wl->flags) ||
+	    WARN_ON((test_bit(WL1271_FLAG_IN_ELP, &wl->flags) &&
+		     addr != HW_ACCESS_ELP_CTRL_REG)))
 		return -EIO;
 
 	ret = wl->if_ops->write(wl->dev, addr, buf, len, fixed);
@@ -76,7 +78,9 @@ static inline int __must_check wlcore_raw_read(struct wl1271 *wl, int addr,
 {
 	int ret;
 
-	if (test_bit(WL1271_FLAG_IO_FAILED, &wl->flags))
+	if (test_bit(WL1271_FLAG_IO_FAILED, &wl->flags) ||
+	    WARN_ON((test_bit(WL1271_FLAG_IN_ELP, &wl->flags) &&
+		     addr != HW_ACCESS_ELP_CTRL_REG)))
 		return -EIO;
 
 	ret = wl->if_ops->read(wl->dev, addr, buf, len, fixed);
-- 
1.8.5.2.229.g4448466.dirty

