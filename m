Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45397 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab0I1Q4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 12:56:30 -0400
Received: by mail-fx0-f46.google.com with SMTP id 14so139095fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 09:56:29 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl12xx: fix non-wl12xx build scenarios
Date: Tue, 28 Sep 2010 18:54:13 +0200
Message-Id: <1285692853-28248-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a linux-next discussion with John, I realized that building
configs like:

CONFIG_MACH_OMAP_ZOOM3=y
CONFIG_WL12XX is not set

will currently break.

The general problem is building configs for wl1271-equipped boards
without building the wl1271 driver itself.

This patch fix this.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Reported-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/wl12xx.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 95deae3..e1d758d 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -32,7 +32,20 @@ struct wl12xx_platform_data {
 	int board_ref_clock;
 };
 
+#ifdef CONFIG_WL12XX_PLATFORM_DATA
+
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
+
+#else /* !CONFIG_WL12XX_PLATFORM_DATA */
+
+static inline int wl12xx_set_platform_data(const struct wl12xx_platform_data *
+									data)
+{
+	return -ENOSYS;
+}
+
+#endif /* !CONFIG_WL12XX_PLATFORM_DATA */
+
 const struct wl12xx_platform_data *wl12xx_get_platform_data(void);
 
 #endif
-- 
1.7.0.4

