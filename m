Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab0I1SWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 14:22:47 -0400
Received: by bwz11 with SMTP id 11so4378260bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Sep 2010 11:22:45 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl12xx: fix non-wl12xx build scenarios
Date: Tue, 28 Sep 2010 20:20:28 +0200
Message-Id: <1285698028-21034-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1285697383.4728.10.camel@powerslave>
References: <1285697383.4728.10.camel@powerslave>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support building wl1271-equipped boards without building the
wl1271 driver itself, e.g.:

CONFIG_MACH_OMAP_ZOOM3=y
CONFIG_WL12XX is not set

Reported-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 include/linux/wl12xx.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 95deae3..4f902e1 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -32,7 +32,20 @@ struct wl12xx_platform_data {
 	int board_ref_clock;
 };
 
+#ifdef CONFIG_WL12XX_PLATFORM_DATA
+
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
+
+#else
+
+static inline
+int wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
+{
+	return -ENOSYS;
+}
+
+#endif
+
 const struct wl12xx_platform_data *wl12xx_get_platform_data(void);
 
 #endif
-- 
1.7.0.4

