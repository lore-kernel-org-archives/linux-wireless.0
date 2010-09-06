Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54399 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0IFNqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 09:46:45 -0400
MIME-Version: 1.0
In-Reply-To: <20100906120716.GE20903@n2100.arm.linux.org.uk>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
 <1283376410-9999-4-git-send-email-ohad@wizery.com> <AANLkTi=goLEUqM1XQ__PrGu4=Erw2utaNP4qFmSgRta2@mail.gmail.com>
 <20100906120716.GE20903@n2100.arm.linux.org.uk>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 6 Sep 2010 16:46:24 +0300
Message-ID: <AANLkTi=z-cqdwrbXo9pv9WhZkrnb7X+zpVNbJ_-VTJ16@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] wireless: wl12xx: add platform data passing support
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Ido Yariv <ido@wizery.com>, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/9/6 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> We could instead make wl12xx_get_platform_data() return a const pointer
> to its own internal storage instead, or ERR pointers for the various
> failure cases.

Sounds good:

diff --git a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
new file mode 100644
index 0000000..973b110
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
@@ -0,0 +1,28 @@
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/wl12xx.h>
+
+static const struct wl12xx_platform_data *platform_data;
+
+int __init wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
+{
+	if (platform_data)
+		return -EBUSY;
+	if (!data)
+		return -EINVAL;
+
+	platform_data = kmemdup(data, sizeof(*data), GFP_KERNEL);
+	if (!platform_data)
+		return -ENOMEM;
+
+	return 0;
+}
+
+const struct wl12xx_platform_data *wl12xx_get_platform_data(void)
+{
+	if (!platform_data)
+		return ERR_PTR(-ENODEV);
+
+	return platform_data;
+}
+EXPORT_SYMBOL(wl12xx_get_platform_data);


I'll wait a few days to see if there's any other comment, and then
post v6 with this change.

>
