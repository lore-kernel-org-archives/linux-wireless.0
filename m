Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43299 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab0JAUeB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 16:34:01 -0400
From: Anand Gadiyar <gadiyar@ti.com>
To: linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Anand Gadiyar <gadiyar@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH] omap: zoom2: fix build break when CONFIG_WL12XX_PLATFORM_DATA=n
Date: Sat,  2 Oct 2010 02:03:56 +0530
Message-Id: <1285965236-17907-1-git-send-email-gadiyar@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix this build break when CONFIG_WL12XX_PLATFORM_DATA is not set.

  LD      .tmp_vmlinux1
arch/arm/mach-omap2/built-in.o: In function `zoom_peripherals_init':
/home/userdata/a0393673/kernels/mainline/linux-2.6/arch/arm/mach-omap2/board-zoom-peripherals.c:333: undefined reference to `wl12xx_set_platform_data'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>
---
There are still many warnings about the function wl12xx_set_platform_data
being unused. Haven't fixed those. Ohad, care to take a look?

 include/linux/wl12xx.h |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/include/linux/wl12xx.h
===================================================================
--- linux-2.6.orig/include/linux/wl12xx.h
+++ linux-2.6/include/linux/wl12xx.h
@@ -32,7 +32,14 @@ struct wl12xx_platform_data {
 	int board_ref_clock;
 };
 
+#ifdef CONFIG_WL12XX_PLATFORM_DATA
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
+#else
+static int wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
+{
+	return 0;
+}
+#endif
 const struct wl12xx_platform_data *wl12xx_get_platform_data(void);
 
 #endif
