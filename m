Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33366 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbbJJMmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2015 08:42:01 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, chris.park@atmel.com, tony.cho@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH] staging: wilc1000: remove WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
Date: Sat, 10 Oct 2015 15:41:54 +0300
Message-Id: <1444480914-20269-1-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20151010_144229_851147_A82DB68C)
In-Reply-To: <20151009182326.GV7340@mwanda>
References: <20151009182326.GV7340@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The config option in the subject may be removed, because,
indeed, it only serves as the 'n' value for
CONFIG_WILC1000_PREALLOCATE_AT_LOADING_DRIVER

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/Kconfig  | 15 ++-------------
 drivers/staging/wilc1000/Makefile |  3 ---
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
index 59ccecc..2701a01 100644
--- a/drivers/staging/wilc1000/Kconfig
+++ b/drivers/staging/wilc1000/Kconfig
@@ -6,27 +6,16 @@ config WILC1000
 	---help---
 	  This module only support IEEE 802.11n WiFi.
 
-choice
-        prompt "Memory Allocation"
-        depends on WILC1000
-        default WILC1000_PREALLOCATE_AT_LOADING_DRIVER
-
 config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
 	bool "Preallocate memory at loading driver"
+	depends on WILC1000
+	default y
 	---help---
 	  This choice supports static allocation of the memory
 	  for the receive buffer. The driver will allocate the RX buffer
 	  during initial time. The driver will also free the buffer
 	  by calling network device stop.
 
-config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
-        bool "Dynamically allocate memory in real time"
-        ---help---
-	  This choice supports dynamic allocation of the memory
-	  for the receive buffer. The driver will allocate the RX buffer
-	  when it is required.
-endchoice
-
 choice
 	prompt "Bus Type"
 	depends on WILC1000
diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index f495061..eb8f51d 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -15,9 +15,6 @@ ccflags-y += -I$(src)/ -D__CHECK_ENDIAN__ -DWILC_ASIC_A0 \
 ccflags-$(CONFIG_WILC1000_PREALLOCATE_AT_LOADING_DRIVER) += -DMEMORY_STATIC \
 								-DWILC_PREALLOC_AT_INSMOD
 
-ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
-
-
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_msgqueue.o \
 			coreconfigurator.o host_interface.o \
-- 
1.9.1

