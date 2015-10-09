Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:35223 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbbJISTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 14:19:21 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH] staging: wilc1000: typo in WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
Date: Fri,  9 Oct 2015 21:19:07 +0300
Message-Id: <1444414747-8049-1-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20151009_201938_613561_80DA849E)
In-Reply-To: <20151008184724.GA11027@kroah.com>
References: <20151008184724.GA11027@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looking at the code, it seems that "MEMROY" in the config option
name is a typo. It should be "MEMORY" instead.

Changed the config option name accordingly.

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/Kconfig  | 2 +-
 drivers/staging/wilc1000/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
index 59ccecc..d636f46 100644
--- a/drivers/staging/wilc1000/Kconfig
+++ b/drivers/staging/wilc1000/Kconfig
@@ -19,7 +19,7 @@ config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
 	  during initial time. The driver will also free the buffer
 	  by calling network device stop.
 
-config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
+config WILC1000_DYNAMICALLY_ALLOCATE_MEMORY
         bool "Dynamically allocate memory in real time"
         ---help---
 	  This choice supports dynamic allocation of the memory
diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index f495061..026609a 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -15,7 +15,7 @@ ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
 ccflags-$(CONFIG_WILC1000_PREALLOCATE_AT_LOADING_DRIVER) += -DMEMORY_STATIC \
 								-DWILC_PREALLOC_AT_INSMOD
 
-ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
+ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMORY) += -DWILC_NORMAL_ALLOC
 
 
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
-- 
1.9.1

