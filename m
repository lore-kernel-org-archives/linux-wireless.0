Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5C449B2B;
	Mon,  7 Sep 2026 09:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772225; cv=none; b=AGX5qMPG3lHQD944JKeaogEYCgInzKrcIC7sZ1K8jLuAYsehG1XFWhliU2S1Sc0BLfzkGSgAtx9l8pNG/ji/8Ns01C41Fvzw8u9NtkERnNxUqKbueyHNK7AYGabZLdYUpZ0EjpBmSClaGIRaXGoLy/VwUfbp/hBkNmw3mhUmLhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772225; c=relaxed/simple;
	bh=roVB1YyvOHDzourAJL+8yzY10KYNevFGzbF5hvxfCTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQXRssDEPgqywF95X0Kdvw/otuAxaFTePI4cxyzT9YDyFhuonyxIYNR13bV5hhQQtRjtRbqXeqX4hMS1INyFwLSBuVWJQ9PLaoNaNReqcEZ9fasoQcuo00+GDfV7ELkyfl6kHTEBYkTOZkT+D5+lgWzDo8Qglc0nC7avIKWJ0Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ck6fDWhm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ck6fDWhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD071F00A3A;
	Mon,  7 Sep 2026 09:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788772223;
	bh=0PTXH8W20ZyoeViUs3nxicCtaP/fM9lwo8ORJUMduDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ck6fDWhmbLP1YgsRsRuTXHe/4iAJ/igArbL6LZOygJxCWOmoM8zca1XGojZXMTg7w
	 pAH0yLC3VYhWaILiQemRDd5ZZKrWRDBpTv6/po5aZ+W3lLonSZ3BjQJpgUWW4oX9E7
	 7xlQg/X9YCou573+ejK8NgDQtggDVbsXBdDgiOwHAgTir+oYxG2W6bDnBlnhr3ecGD
	 EK6N+o/5dRbqYY4dMiDNFXKl7vgFWWcuquI6dqggPqOmNffEFxgUKsDGfpSaPSmTii
	 HB2OtAIziidum01Xmu3pz8+8WqxT26L9Z9/nrzq17aLSmiky6RHF/LZn7vxtx83P01
	 BQZBSHmFVpJzw==
From: Arnd Bergmann <arnd@kernel.org>
To: Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Kent Gibson <warthog618@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 2/2 v7] gpiolib: remove linux/gpio.h
Date: Mon,  7 Sep 2026 11:09:56 +0200
Message-ID: <20260907090956.2825703-3-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907090956.2825703-1-arnd@kernel.org>
References: <20260907090956.2825703-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

After all other drivers have converted to linux/gpio/consumer.h
or linux/gpio/legacy.h, remove the final leftover bits here.

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS                                  |  1 -
 arch/mips/txx9/rbtx4927/setup.c              |  2 +-
 arch/sh/boards/mach-rsk/devices-rsk7203.c    |  2 +-
 drivers/gpio/TODO                            |  4 +---
 drivers/gpio/gpiolib-cdev.c                  |  2 +-
 drivers/gpio/gpiolib-legacy.c                |  3 +--
 drivers/gpio/gpiolib.c                       |  2 +-
 drivers/net/wireless/morsemicro/mm81x/hw.c   |  1 -
 drivers/net/wireless/morsemicro/mm81x/yaps.c |  1 -
 include/linux/gpio.h                         | 22 --------------------
 10 files changed, 6 insertions(+), 34 deletions(-)
 delete mode 100644 include/linux/gpio.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a19da74d00c..ee06d678cd59 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11255,7 +11255,6 @@ F:	Documentation/devicetree/bindings/gpio/
 F:	Documentation/driver-api/gpio/
 F:	drivers/gpio/
 F:	include/dt-bindings/gpio/
-F:	include/linux/gpio.h
 F:	include/linux/gpio/
 K:	(devm_)?gpio_(request|free|direction|get|set)
 K:	GPIOD_FLAGS_BIT_NONEXCLUSIVE
diff --git a/arch/mips/txx9/rbtx4927/setup.c b/arch/mips/txx9/rbtx4927/setup.c
index 223889c03186..fdbe2bd87979 100644
--- a/arch/mips/txx9/rbtx4927/setup.c
+++ b/arch/mips/txx9/rbtx4927/setup.c
@@ -48,7 +48,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio/machine.h>
 #include <linux/leds.h>
 #include <asm/io.h>
diff --git a/arch/sh/boards/mach-rsk/devices-rsk7203.c b/arch/sh/boards/mach-rsk/devices-rsk7203.c
index e6b05d4588b7..eb56b57812bd 100644
--- a/arch/sh/boards/mach-rsk/devices-rsk7203.c
+++ b/arch/sh/boards/mach-rsk/devices-rsk7203.c
@@ -10,7 +10,7 @@
 #include <linux/interrupt.h>
 #include <linux/smsc911x.h>
 #include <linux/input.h>
-#include <linux/gpio.h>
+#include <linux/gpio/legacy.h>
 #include <linux/gpio_keys.h>
 #include <linux/leds.h>
 #include <asm/machvec.h>
diff --git a/drivers/gpio/TODO b/drivers/gpio/TODO
index 7ce80fde1f17..4fce4a7e4704 100644
--- a/drivers/gpio/TODO
+++ b/drivers/gpio/TODO
@@ -52,9 +52,7 @@ Work items:
   base can be made dynamic (set to -1) if CONFIG_GPIO_SYSFS is disabled.
 
 - When this work is complete (will require some of the items in the
-  following ongoing work as well) we can delete the old global
-  numberspace accessors from <linux/gpio.h> and eventually delete
-  <linux/gpio.h> altogether.
+  following ongoing work as well) we can delete <linux/gpio/legacy.h>.
 
 -------------------------------------------------------------------------------
 
diff --git a/drivers/gpio/gpiolib-cdev.c b/drivers/gpio/gpiolib-cdev.c
index 9f3b628d5793..1c2c94387b77 100644
--- a/drivers/gpio/gpiolib-cdev.c
+++ b/drivers/gpio/gpiolib-cdev.c
@@ -11,7 +11,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/file.h>
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
 #include <linux/hte.h>
 #include <linux/interrupt.h>
diff --git a/drivers/gpio/gpiolib-legacy.c b/drivers/gpio/gpiolib-legacy.c
index ef3f2ef30cf2..33e5a45e720b 100644
--- a/drivers/gpio/gpiolib-legacy.c
+++ b/drivers/gpio/gpiolib-legacy.c
@@ -7,8 +7,7 @@
 
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
-
-#include <linux/gpio.h>
+#include <linux/gpio/legacy.h>
 
 #include "gpiolib.h"
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index ef8ccaf17c9c..c9c517488e0a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -29,7 +29,7 @@
 #include <linux/string.h>
 #include <linux/string_choices.h>
 
-#include <linux/gpio.h>
+#include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
 #include <linux/gpio/machine.h>
 
diff --git a/drivers/net/wireless/morsemicro/mm81x/hw.c b/drivers/net/wireless/morsemicro/mm81x/hw.c
index 9293f4094db1..e48eaf151faa 100644
--- a/drivers/net/wireless/morsemicro/mm81x/hw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/hw.c
@@ -7,7 +7,6 @@
 #include <linux/stringify.h>
 #include <linux/types.h>
 #include <linux/unaligned.h>
-#include <linux/gpio.h>
 #include "hif.h"
 #include "mac.h"
 #include "bus.h"
diff --git a/drivers/net/wireless/morsemicro/mm81x/yaps.c b/drivers/net/wireless/morsemicro/mm81x/yaps.c
index e98a2a58726f..252116425bc3 100644
--- a/drivers/net/wireless/morsemicro/mm81x/yaps.c
+++ b/drivers/net/wireless/morsemicro/mm81x/yaps.c
@@ -2,7 +2,6 @@
 /*
  * Copyright (c) 2017-2026 Morse Micro
  */
-#include <linux/gpio.h>
 #include <linux/random.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
deleted file mode 100644
index b0d4942a65de..000000000000
--- a/include/linux/gpio.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * NOTE: This header *must not* be included.
- *
- * If you're implementing a GPIO driver, only include <linux/gpio/driver.h>
- * If you're implementing a GPIO consumer, only include <linux/gpio/consumer.h>
- * If you're using the legacy interfaces, include <linux/gpio/legacy.h>
- */
-
-#ifndef __LINUX_GPIO_H
-#define __LINUX_GPIO_H
-
-#include <linux/types.h>
-#ifdef CONFIG_GPIOLIB
-#include <linux/gpio/consumer.h>
-#endif
-
-#ifdef CONFIG_GPIOLIB_LEGACY
-#include <linux/gpio/legacy.h>
-#endif /* CONFIG_GPIOLIB_LEGACY */
-
-#endif /* __LINUX_GPIO_H */
-- 
2.53.0

