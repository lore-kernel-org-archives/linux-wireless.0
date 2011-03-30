Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47131 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab1C3A5E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:04 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:39 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/34] ath6kl: remove dependency on LINUX and KERNEL_2_6 macros
Date: Tue, 29 Mar 2011 17:56:08 -0700
Message-ID: <1301446591-15236-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Makefile                    |    1 -
 drivers/staging/ath6kl/htc2/AR6000/ar6k.h          |    3 -
 drivers/staging/ath6kl/include/a_config.h          |   22 --------
 drivers/staging/ath6kl/include/a_debug.h           |   28 ----------
 drivers/staging/ath6kl/include/a_drv.h             |   22 --------
 drivers/staging/ath6kl/include/a_osapi.h           |   29 ----------
 drivers/staging/ath6kl/include/a_types.h           |   26 ---------
 drivers/staging/ath6kl/include/ar6000_api.h        |   22 --------
 drivers/staging/ath6kl/include/athendpack.h        |   52 ------------------
 drivers/staging/ath6kl/include/athstartpack.h      |   55 --------------------
 drivers/staging/ath6kl/include/common/bmi_msg.h    |    8 ---
 drivers/staging/ath6kl/include/common/dbglog.h     |    8 ---
 .../staging/ath6kl/include/common/dset_internal.h  |    8 ---
 drivers/staging/ath6kl/include/common/dsetid.h     |    8 ---
 .../staging/ath6kl/include/common/epping_test.h    |    9 ---
 drivers/staging/ath6kl/include/common/gmboxif.h    |    8 ---
 drivers/staging/ath6kl/include/common/htc.h        |    9 ---
 drivers/staging/ath6kl/include/common/regdump.h    |    8 ---
 drivers/staging/ath6kl/include/common/targaddrs.h  |    8 ---
 drivers/staging/ath6kl/include/common/wmi.h        |    8 ---
 drivers/staging/ath6kl/include/common/wmix.h       |    7 ---
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |    4 --
 drivers/staging/ath6kl/wmi/wmi.c                   |    4 --
 23 files changed, 0 insertions(+), 357 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/include/athendpack.h
 delete mode 100644 drivers/staging/ath6kl/include/athstartpack.h

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index 96e4ed9..9903034 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -110,7 +110,6 @@ ifeq ($(CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK),y)
 ccflags-y += -DATH6KL_SKIP_ABI_VERSION_CHECK
 endif
 
-ccflags-y += -DLINUX -DKERNEL_2_6
 ccflags-y += -DTCMD
 ccflags-y += -DSEND_EVENT_TO_APP
 ccflags-y += -DUSER_KEYS
diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
index 1ff2218..e551dbe 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k.h
@@ -42,7 +42,6 @@
 
 //#define MBOXHW_UNIT_TEST 1
 
-#include "athstartpack.h"
 PREPACK struct ar6k_irq_proc_registers {
     u8 host_int_status;
     u8 cpu_int_status;
@@ -69,8 +68,6 @@ PREPACK struct ar6k_gmbox_ctrl_registers {
     u8 int_status_enable;
 } POSTPACK;
 
-#include "athendpack.h"
-
 #define AR6K_IRQ_ENABLE_REGS_SIZE sizeof(struct ar6k_irq_enable_registers)
 
 #define AR6K_REG_IO_BUFFER_SIZE     32
diff --git a/drivers/staging/ath6kl/include/a_config.h b/drivers/staging/ath6kl/include/a_config.h
index 4a0083c..f7c0931 100644
--- a/drivers/staging/ath6kl/include/a_config.h
+++ b/drivers/staging/ath6kl/include/a_config.h
@@ -26,28 +26,6 @@
 #ifndef _A_CONFIG_H_
 #define _A_CONFIG_H_
 
-#ifdef UNDER_NWIFI
-#include "../os/windows/include/config.h"
-#endif
-
-#ifdef ATHR_CE_LEGACY
-#include "../os/windows/include/config.h"
-#endif
-
-#if defined(__linux__) && !defined(LINUX_EMULATION)
 #include "../os/linux/include/config_linux.h"
-#endif
-
-#ifdef REXOS
-#include "../os/rexos/include/common/config_rexos.h"
-#endif
-
-#ifdef WIN_NWF
-#include "../os/windows/include/win/config_win.h"
-#endif
-
-#ifdef THREADX
-#include "../os/threadx/include/common/config_threadx.h"
-#endif
 
 #endif
diff --git a/drivers/staging/ath6kl/include/a_debug.h b/drivers/staging/ath6kl/include/a_debug.h
index d433942..51cb633 100644
--- a/drivers/staging/ath6kl/include/a_debug.h
+++ b/drivers/staging/ath6kl/include/a_debug.h
@@ -187,35 +187,7 @@ void a_dump_module_debug_info_by_name(char *module_name);
 void a_module_debug_support_init(void);
 void a_module_debug_support_cleanup(void);
 
-#ifdef UNDER_NWIFI
-#include "../os/windows/include/debug.h"
-#endif
-
-#ifdef ATHR_CE_LEGACY
-#include "../os/windows/include/debug.h"
-#endif
-
-#if defined(__linux__) && !defined(LINUX_EMULATION)
 #include "../os/linux/include/debug_linux.h"
-#endif
-
-#ifdef REXOS
-#include "../os/rexos/include/common/debug_rexos.h"
-#endif
-
-#if defined ART_WIN
-#include "../os/win_art/include/debug_win.h"
-#endif
-
-#ifdef WIN_NWF
-#include <debug_win.h>
-#endif
-
-#ifdef THREADX
-#define ATH_DEBUG_MAKE_MODULE_MASK(index)  (1 << (ATH_DEBUG_MODULE_MASK_SHIFT + (index)))
-#include "../os/threadx/include/common/debug_threadx.h"
-#endif  
-
 
 #ifdef __cplusplus
 }
diff --git a/drivers/staging/ath6kl/include/a_drv.h b/drivers/staging/ath6kl/include/a_drv.h
index 6db10f0..1548604 100644
--- a/drivers/staging/ath6kl/include/a_drv.h
+++ b/drivers/staging/ath6kl/include/a_drv.h
@@ -27,28 +27,6 @@
 #ifndef _A_DRV_H_
 #define _A_DRV_H_
 
-#if defined(__linux__) && !defined(LINUX_EMULATION)
 #include "../os/linux/include/athdrv_linux.h"
-#endif
-
-#ifdef UNDER_NWIFI
-#include "../os/windows/include/athdrv.h"
-#endif
-
-#ifdef ATHR_CE_LEGACY
-#include "../os/windows/include/athdrv.h"
-#endif
-
-#ifdef REXOS
-#include "../os/rexos/include/common/athdrv_rexos.h"
-#endif
-
-#ifdef WIN_NWF
-#include "../os/windows/include/athdrv.h"
-#endif
-
-#ifdef THREADX
-#include "../os/threadx/include/common/athdrv_threadx.h"
-#endif
 
 #endif /* _ADRV_H_ */
diff --git a/drivers/staging/ath6kl/include/a_osapi.h b/drivers/staging/ath6kl/include/a_osapi.h
index 7bdeeea..fd7ae0d 100644
--- a/drivers/staging/ath6kl/include/a_osapi.h
+++ b/drivers/staging/ath6kl/include/a_osapi.h
@@ -27,35 +27,6 @@
 #ifndef _A_OSAPI_H_
 #define _A_OSAPI_H_
 
-#if defined(__linux__) && !defined(LINUX_EMULATION)
 #include "../os/linux/include/osapi_linux.h"
-#endif
-
-#ifdef UNDER_NWIFI
-#include "../os/windows/include/osapi.h"
-#include "../os/windows/include/netbuf.h"
-#endif
-
-#ifdef ATHR_CE_LEGACY
-#include "../os/windows/include/osapi.h"
-#include "../os/windows/include/netbuf.h"
-#endif
-
-#ifdef REXOS
-#include "../os/rexos/include/common/osapi_rexos.h"
-#endif
-
-#if defined ART_WIN
-#include "../os/win_art/include/osapi_win.h"
-#include "../os/win_art/include/netbuf.h"
-#endif
-
-#ifdef WIN_NWF
-#include <osapi_win.h>
-#endif 
-
-#if defined(THREADX)
-#include "../os/threadx/include/common/osapi_threadx.h"
-#endif 
 
 #endif /* _OSAPI_H_ */
diff --git a/drivers/staging/ath6kl/include/a_types.h b/drivers/staging/ath6kl/include/a_types.h
index 18f4cfe..4b6783f 100644
--- a/drivers/staging/ath6kl/include/a_types.h
+++ b/drivers/staging/ath6kl/include/a_types.h
@@ -27,32 +27,6 @@
 #ifndef _A_TYPES_H_
 #define _A_TYPES_H_
 
-#if defined(__linux__) && !defined(LINUX_EMULATION)
 #include "../os/linux/include/athtypes_linux.h"
-#endif
-
-#ifdef UNDER_NWIFI
-#include "../os/windows/include/athtypes.h"
-#endif
-
-#ifdef ATHR_CE_LEGACY
-#include "../os/windows/include/athtypes.h"
-#endif
-
-#ifdef REXOS
-#include "../os/rexos/include/common/athtypes_rexos.h"
-#endif
-
-#if defined ART_WIN
-#include "../os/win_art/include/athtypes_win.h"
-#endif
-
-#ifdef WIN_NWF
-#include <athtypes_win.h>
-#endif
-
-#ifdef THREADX
-#include "../os/threadx/include/common/athtypes_threadx.h"
-#endif
 
 #endif /* _ATHTYPES_H_ */
diff --git a/drivers/staging/ath6kl/include/ar6000_api.h b/drivers/staging/ath6kl/include/ar6000_api.h
index 1e1d92a..e946080 100644
--- a/drivers/staging/ath6kl/include/ar6000_api.h
+++ b/drivers/staging/ath6kl/include/ar6000_api.h
@@ -26,29 +26,7 @@
 #ifndef _AR6000_API_H_
 #define _AR6000_API_H_
 
-#if defined(__linux__) && !defined(LINUX_EMULATION)
 #include "../os/linux/include/ar6xapi_linux.h"
-#endif
-
-#ifdef UNDER_NWIFI
-#include "../os/windows/include/ar6xapi.h"
-#endif
-
-#ifdef ATHR_CE_LEGACY
-#include "../os/windows/include/ar6xapi.h"
-#endif
-
-#ifdef REXOS
-#include "../os/rexos/include/common/ar6xapi_rexos.h"
-#endif
-
-#if defined ART_WIN
-#include "../os/win_art/include/ar6xapi_win.h"
-#endif
-
-#ifdef WIN_NWF
-#include "../os/windows/include/ar6xapi.h"
-#endif
 
 #endif /* _AR6000_API_H */
 
diff --git a/drivers/staging/ath6kl/include/athendpack.h b/drivers/staging/ath6kl/include/athendpack.h
deleted file mode 100644
index 1b94050..0000000
--- a/drivers/staging/ath6kl/include/athendpack.h
+++ /dev/null
@@ -1,52 +0,0 @@
-//------------------------------------------------------------------------------
-// <copyright file="athendpack.h" company="Atheros">
-//    Copyright (c) 2004-2010 Atheros Corporation.  All rights reserved.
-// 
-//
-// Permission to use, copy, modify, and/or distribute this software for any
-// purpose with or without fee is hereby granted, provided that the above
-// copyright notice and this permission notice appear in all copies.
-//
-// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-//
-//
-//------------------------------------------------------------------------------
-//==============================================================================
-// end compiler-specific structure packing
-//
-// Author(s): ="Atheros"
-//==============================================================================
-#ifdef VXWORKS
-#endif /* VXWORKS */
-
-#if defined(LINUX) || defined(__linux__)
-#endif /* LINUX */
-
-#ifdef QNX
-#endif /* QNX */
-
-#ifdef INTEGRITY
-#include "integrity/athendpack_integrity.h"
-#endif /* INTEGRITY */
-
-#ifdef NUCLEUS
-#endif /* NUCLEUS */
-
-
-#ifdef UNDER_NWIFI
-#include "../os/windows/include/athendpack.h"
-#endif
-
-#ifdef ATHR_CE_LEGACY
-#include "../os/windows/include/athendpack.h"
-#endif /* WINCE */
-
-#ifdef WIN_NWF
-#include <athendpack_win.h>
-#endif 
diff --git a/drivers/staging/ath6kl/include/athstartpack.h b/drivers/staging/ath6kl/include/athstartpack.h
deleted file mode 100644
index 1c45f66..0000000
--- a/drivers/staging/ath6kl/include/athstartpack.h
+++ /dev/null
@@ -1,55 +0,0 @@
-//------------------------------------------------------------------------------
-// <copyright file="athstartpack.h" company="Atheros">
-//    Copyright (c) 2004-2010 Atheros Corporation.  All rights reserved.
-// 
-//
-// Permission to use, copy, modify, and/or distribute this software for any
-// purpose with or without fee is hereby granted, provided that the above
-// copyright notice and this permission notice appear in all copies.
-//
-// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-//
-//
-//------------------------------------------------------------------------------
-//==============================================================================
-// start compiler-specific structure packing
-//
-// Author(s): ="Atheros"
-//==============================================================================
-#ifdef VXWORKS
-#endif /* VXWORKS */
-
-#if defined(LINUX) || defined(__linux__)
-#endif /* LINUX */
-
-#ifdef QNX
-#endif /* QNX */
-
-#ifdef INTEGRITY
-#include "integrity/athstartpack_integrity.h"
-#endif /* INTEGRITY */
-
-#ifdef NUCLEUS
-#endif /* NUCLEUS */
-
-#ifdef UNDER_NWIFI
-#include "../os/windows/include/athstartpack.h"
-#endif
-
-#ifdef ATHR_CE_LEGACY
-#include "../os/windows/include/athstartpack.h"
-#endif /* WINCE */
-
-#ifdef WIN_NWF
-#include <athstartpack_win.h>
-#endif
-
-#ifdef THREADX
-#include "../os/threadx/include/common/osapi_threadx.h"
-#endif 
diff --git a/drivers/staging/ath6kl/include/common/bmi_msg.h b/drivers/staging/ath6kl/include/common/bmi_msg.h
index e76624c..84e8db5 100644
--- a/drivers/staging/ath6kl/include/common/bmi_msg.h
+++ b/drivers/staging/ath6kl/include/common/bmi_msg.h
@@ -22,10 +22,6 @@
 #ifndef __BMI_MSG_H__
 #define __BMI_MSG_H__
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 /*
  * Bootloader Messaging Interface (BMI)
  *
@@ -234,8 +230,4 @@ PREPACK struct bmi_target_info {
          * Note: Not supported on all versions of ROM firmware.
          */
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
 #endif /* __BMI_MSG_H__ */
diff --git a/drivers/staging/ath6kl/include/common/dbglog.h b/drivers/staging/ath6kl/include/common/dbglog.h
index 3a3d00d..e5ef939 100644
--- a/drivers/staging/ath6kl/include/common/dbglog.h
+++ b/drivers/staging/ath6kl/include/common/dbglog.h
@@ -24,10 +24,6 @@
 #ifndef _DBGLOG_H_
 #define _DBGLOG_H_
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 #ifdef __cplusplus
 extern "C" {
 #endif
@@ -127,8 +123,4 @@ PREPACK struct dbglog_config_s {
 }
 #endif
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
 #endif /* _DBGLOG_H_ */
diff --git a/drivers/staging/ath6kl/include/common/dset_internal.h b/drivers/staging/ath6kl/include/common/dset_internal.h
index 6947533..e3ecd8e 100644
--- a/drivers/staging/ath6kl/include/common/dset_internal.h
+++ b/drivers/staging/ath6kl/include/common/dset_internal.h
@@ -25,10 +25,6 @@
 #ifndef __DSET_INTERNAL_H__
 #define __DSET_INTERNAL_H__
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 /*
  * Internal dset definitions, common for DataSet layer.
  */
@@ -56,8 +52,4 @@ typedef PREPACK struct dset_descriptor_s {
                                               Dataset descriptor for BPatch. */
 } POSTPACK dset_descriptor_t;
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
 #endif /* __DSET_INTERNAL_H__ */
diff --git a/drivers/staging/ath6kl/include/common/dsetid.h b/drivers/staging/ath6kl/include/common/dsetid.h
index 090e309..cc797ba 100644
--- a/drivers/staging/ath6kl/include/common/dsetid.h
+++ b/drivers/staging/ath6kl/include/common/dsetid.h
@@ -25,10 +25,6 @@
 #ifndef __DSETID_H__
 #define __DSETID_H__
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 /* Well-known DataSet IDs */
 #define DSETID_UNUSED                     0x00000000
 #define DSETID_BOARD_DATA                 0x00000001 /* Cal and board data */
@@ -127,8 +123,4 @@ PREPACK struct patch_s {
  */
 #define DSETID_BPATCH_FLAG                0x80000000
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
 #endif /* __DSETID_H__ */
diff --git a/drivers/staging/ath6kl/include/common/epping_test.h b/drivers/staging/ath6kl/include/common/epping_test.h
index 5c40d8a..c9520ed 100644
--- a/drivers/staging/ath6kl/include/common/epping_test.h
+++ b/drivers/staging/ath6kl/include/common/epping_test.h
@@ -25,10 +25,6 @@
 #ifndef EPPING_TEST_H_
 #define EPPING_TEST_H_
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
     /* alignment to 4-bytes */
 #define EPPING_ALIGNMENT_PAD  (((sizeof(struct htc_frame_hdr) + 3) & (~0x3)) - sizeof(struct htc_frame_hdr))
 
@@ -112,9 +108,4 @@ typedef PREPACK struct {
 #define HCI_TRANSPORT_STREAM_NUM  16  /* this number is higher than the define WMM AC classes so we
                                          can use this to distinguish packets */
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-    
-    
 #endif /*EPPING_TEST_H_*/
diff --git a/drivers/staging/ath6kl/include/common/gmboxif.h b/drivers/staging/ath6kl/include/common/gmboxif.h
index dd9afbd..ea11c14 100644
--- a/drivers/staging/ath6kl/include/common/gmboxif.h
+++ b/drivers/staging/ath6kl/include/common/gmboxif.h
@@ -23,10 +23,6 @@
 #ifndef __GMBOXIF_H__
 #define __GMBOXIF_H__
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 /* GMBOX interface definitions */
     
 #define AR6K_GMBOX_CREDIT_COUNTER       1   /* we use credit counter 1 to track credits */
@@ -70,9 +66,5 @@ typedef PREPACK struct {
 #define MBOX_SIG_HCI_BRIDGE_PWR_SAV_OFF   4
 
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
 #endif /* __GMBOXIF_H__ */
 
diff --git a/drivers/staging/ath6kl/include/common/htc.h b/drivers/staging/ath6kl/include/common/htc.h
index b9d4495..85cbfa8 100644
--- a/drivers/staging/ath6kl/include/common/htc.h
+++ b/drivers/staging/ath6kl/include/common/htc.h
@@ -24,10 +24,6 @@
 #ifndef __HTC_H__
 #define __HTC_H__
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 #define A_OFFSETOF(type,field) (unsigned long)(&(((type *)NULL)->field))
 
 #define ASSEMBLE_UNALIGNED_UINT16(p,highbyte,lowbyte) \
@@ -227,10 +223,5 @@ typedef PREPACK struct {
     u8 LookAhead[4];     /* 4 byte lookahead */
 } POSTPACK HTC_BUNDLED_LOOKAHEAD_REPORT;
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
-
 #endif /* __HTC_H__ */
 
diff --git a/drivers/staging/ath6kl/include/common/regdump.h b/drivers/staging/ath6kl/include/common/regdump.h
index aa64821..614dfa1 100644
--- a/drivers/staging/ath6kl/include/common/regdump.h
+++ b/drivers/staging/ath6kl/include/common/regdump.h
@@ -24,10 +24,6 @@
 #ifndef __REGDUMP_H__
 #define __REGDUMP_H__
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 #if defined(AR6001)
 #include "AR6001/AR6001_regdump.h"
 #endif
@@ -52,8 +48,4 @@ PREPACK struct register_dump_s {
 } POSTPACK;
 #endif /* __ASSEMBLER__ */
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
 #endif /* __REGDUMP_H__ */
diff --git a/drivers/staging/ath6kl/include/common/targaddrs.h b/drivers/staging/ath6kl/include/common/targaddrs.h
index 794ae21..e921b30 100644
--- a/drivers/staging/ath6kl/include/common/targaddrs.h
+++ b/drivers/staging/ath6kl/include/common/targaddrs.h
@@ -22,10 +22,6 @@
 #ifndef __TARGADDRS_H__
 #define __TARGADDRS_H__
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 #if defined(AR6002)
 #include "AR6002/addrs.h"
 #endif
@@ -238,8 +234,4 @@ PREPACK struct host_interest_s {
 
 #endif /* !__ASSEMBLER__ */
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
 #endif /* __TARGADDRS_H__ */
diff --git a/drivers/staging/ath6kl/include/common/wmi.h b/drivers/staging/ath6kl/include/common/wmi.h
index d3de3cc..363e935 100644
--- a/drivers/staging/ath6kl/include/common/wmi.h
+++ b/drivers/staging/ath6kl/include/common/wmi.h
@@ -34,10 +34,6 @@
 #ifndef _WMI_H_
 #define _WMI_H_
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 #include "wmix.h"
 #include "wlan_defs.h"
 
@@ -3122,10 +3118,6 @@ typedef PREPACK struct {
  * End of AP mode definitions
  */
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
-
 #ifdef __cplusplus
 }
 #endif
diff --git a/drivers/staging/ath6kl/include/common/wmix.h b/drivers/staging/ath6kl/include/common/wmix.h
index 5ebb828..38c2970 100644
--- a/drivers/staging/ath6kl/include/common/wmix.h
+++ b/drivers/staging/ath6kl/include/common/wmix.h
@@ -40,10 +40,6 @@
 extern "C" {
 #endif
 
-#ifndef ATH_TARGET
-#include "athstartpack.h"
-#endif
-
 #include "dbglog.h"
 
 /*
@@ -268,9 +264,6 @@ typedef PREPACK struct {
     u32 count;
 } POSTPACK WMIX_PROF_COUNT_EVENT;
 
-#ifndef ATH_TARGET
-#include "athendpack.h"
-#endif
 
 #ifdef __cplusplus
 }
diff --git a/drivers/staging/ath6kl/wlan/include/ieee80211.h b/drivers/staging/ath6kl/wlan/include/ieee80211.h
index 532ab0e..cf47d06 100644
--- a/drivers/staging/ath6kl/wlan/include/ieee80211.h
+++ b/drivers/staging/ath6kl/wlan/include/ieee80211.h
@@ -23,8 +23,6 @@
 #ifndef _NET80211_IEEE80211_H_
 #define _NET80211_IEEE80211_H_
 
-#include "athstartpack.h"
-
 /*
  * 802.11 protocol definitions.
  */
@@ -396,6 +394,4 @@ enum ieee80211_authmode {
 
 #define IEEE80211_PS_MAX_QUEUE    50 /*Maximum no of buffers that can be queues for PS*/
 
-#include "athendpack.h"
-
 #endif /* _NET80211_IEEE80211_H_ */
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 153ca1f..aad0c97 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -265,8 +265,6 @@ const u8 up_to_ac[]= {
                 WMM_AC_VO,
             };
 
-#include "athstartpack.h"
-
 /* This stuff is used when we want a simple layer-3 visibility */
 typedef PREPACK struct _iphdr {
     u8 ip_ver_hdrlen;          /* version and hdr length */
@@ -284,8 +282,6 @@ typedef PREPACK struct _iphdr {
     u8 ip_dst[4];
 } POSTPACK iphdr;
 
-#include "athendpack.h"
-
 static s16 rssi_event_value = 0;
 static s16 snr_event_value = 0;
 
-- 
1.7.0.4

