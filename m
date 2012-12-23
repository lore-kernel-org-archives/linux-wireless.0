Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51590 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2LWN2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2012 08:28:13 -0500
Received: by mail-ee0-f54.google.com with SMTP id c13so3116483eek.27
        for <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2012 05:28:12 -0800 (PST)
Message-ID: <50D706D9.80006@gmail.com> (sfid-20121223_142818_761646_B47A76BD)
Date: Sun, 23 Dec 2012 16:27:53 +0300
From: Sergey Isachenko <vortexius@gmail.com>
MIME-Version: 1.0
To: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Missinng dependency for debugfs in driver ath9k
Content-Type: multipart/mixed;
 boundary="------------060802090807070306050806"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060802090807070306050806
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello i have problem with making your driver in linux kernel:

psix linux # LANG=C make -j5
make[1]: Nothing to be done for `all'.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
make[1]: Nothing to be done for `relocs'.
  CALL    scripts/checksyscalls.sh
<stdin>:1223:2: warning: #warning syscall finit_module not implemented
[-Wcpp]
  CHK     include/generated/compile.h
  CHK     kernel/config_data.h
make[3]: `arch/x86/realmode/rm/realmode.bin' is up to date.
  CC      drivers/power/power_supply_core.o
  CC      drivers/power/power_supply_sysfs.o
  CC      drivers/net/wireless/ath/ath9k/debug.o
  CC      drivers/rtc/rtc-lib.o
  CC      drivers/power/power_supply_leds.o
  CC      drivers/thermal/thermal_sys.o
  LD      drivers/scsi/pcmcia/built-in.o
  CC      drivers/scsi/scsi.o
  LD      drivers/power/power_supply.o
  LD      drivers/power/built-in.o
  CC      drivers/rtc/class.o
  CC      drivers/rtc/interface.o
drivers/net/wireless/ath/ath9k/debug.c: In function 'ath9k_sta_add_debugfs':
drivers/net/wireless/ath/ath9k/debug.c:1589:4: error: 'struct ath_node'
has no member named 'node_stat'
drivers/net/wireless/ath/ath9k/debug.c: In function
'ath9k_sta_remove_debugfs':
drivers/net/wireless/ath/ath9k/debug.c:1599:19: error: 'struct ath_node'
has no member named 'node_stat'
make[5]: *** [drivers/net/wireless/ath/ath9k/debug.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath9k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
  CC      drivers/rtc/rtc-dev.o
  CC      drivers/scsi/hosts.o
  CC      drivers/scsi/scsi_ioctl.o
  CC      drivers/rtc/rtc-proc.o
  CC      drivers/rtc/rtc-sysfs.o
  CC      drivers/thermal/step_wise.o
  CC      drivers/scsi/constants.o
  CC      drivers/rtc/rtc-cmos.o
  CC      drivers/scsi/scsicam.o
  CC      drivers/scsi/scsi_error.o
  LD      drivers/thermal/built-in.o
  CC      drivers/scsi/scsi_lib.o
  CC      drivers/scsi/scsi_lib_dma.o
  LD      drivers/rtc/rtc-core.o
  LD      drivers/rtc/built-in.o
  CC      drivers/scsi/scsi_scan.o
  CC      drivers/scsi/scsi_sysfs.o
  CC      drivers/scsi/scsi_devinfo.o
  CC      drivers/scsi/scsi_sysctl.o
  CC      drivers/scsi/scsi_proc.o
  CC      drivers/scsi/scsi_trace.o
  CC      drivers/scsi/scsi_pm.o
  CC      drivers/scsi/sd.o
  CC      drivers/scsi/sr.o
  CC      drivers/scsi/sr_ioctl.o
  CC      drivers/scsi/sr_vendor.o
  CC      drivers/scsi/scsi_transport_spi.o
  CC      drivers/scsi/sg.o
  LD      drivers/scsi/scsi_mod.o
  LD      drivers/scsi/sd_mod.oou
  LD      drivers/scsi/sr_mod.o
  LD      drivers/scsi/built-in.o
make: *** [drivers] Error 2



I write the patch for you team. patch in attachments.
Thank you.

P.S. srry my terrible English.

Sergey Isachenko.

--------------060802090807070306050806
Content-Type: text/x-patch;
 name="0001-debugfs-fix-missing-dependency-on-DEBUGFS.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-debugfs-fix-missing-dependency-on-DEBUGFS.patch"

>From 5975a832b400344b2438bc640b530fb5a8d8a80a Mon Sep 17 00:00:00 2001
From: Sergey Isachenko <vortexius@gmail.com>
Date: Sat, 22 Dec 2012 12:42:56 +0300
Subject: [PATCH] debugfs: fix missing dependency on DEBUGFS

---
 drivers/net/wireless/ath/ath9k/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 5fc15bf..8469e52 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -55,11 +55,12 @@ config ATH9K_AHB
 	  wireless MAC. Say N if unsure.
 
 config ATH9K_DEBUGFS
-	bool "Atheros ath9k debugging"
+	bool "Atheros ath9k debugging via debugfs"
 	depends on ATH9K && DEBUG_FS
+	select MAC80211_DEBUGFS
 	---help---
 	  Say Y, if you need access to ath9k's statistics for
-	  interrupts, rate control, etc.
+	  interrupts, rate control, etc via debugfs.
 
 	  Also required for changing debug message flags at run time.
 
-- 
1.8.0.2


--------------060802090807070306050806--
