Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47110 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab1C3A4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:56:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 08/34] ath6kl: kill Android specific code
Date: Tue, 29 Mar 2011 17:56:05 -0700
Message-ID: <1301446591-15236-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To get upstream we can't use out of tree defines, kill
all the androidisms. ath6kl won't be usable on Android
unless external patches are supported later or Android
gets their shit together and gets all their crap upstream.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_android.c   |  386 --------------------
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   16 -
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |   18 -
 drivers/staging/ath6kl/os/linux/eeprom.c           |  213 -----------
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |   43 +---
 .../staging/ath6kl/os/linux/include/wlan_config.h  |    4 -
 drivers/staging/ath6kl/os/linux/wireless_ext.c     |   33 --
 7 files changed, 1 insertions(+), 712 deletions(-)
 delete mode 100644 drivers/staging/ath6kl/os/linux/ar6000_android.c

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_android.c b/drivers/staging/ath6kl/os/linux/ar6000_android.c
deleted file mode 100644
index 03352b0..0000000
--- a/drivers/staging/ath6kl/os/linux/ar6000_android.c
+++ /dev/null
@@ -1,386 +0,0 @@
-//------------------------------------------------------------------------------
-// Copyright (c) 2004-2010 Atheros Communications Inc.
-// All rights reserved.
-//
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
-//
-// Author(s): ="Atheros"
-//------------------------------------------------------------------------------
-#include "ar6000_drv.h"
-#include "htc.h"
-#include <linux/vmalloc.h>
-#include <linux/fs.h>
-
-#ifdef CONFIG_HAS_EARLYSUSPEND
-#include <linux/earlysuspend.h>
-#endif
-
-bool enable_mmc_host_detect_change = false;
-static void ar6000_enable_mmchost_detect_change(int enable);
-
-
-char fwpath[256] = "/system/wifi";
-int wowledon;
-unsigned int enablelogcat;
-
-extern struct net_device *ar6000_devices[];
-extern char ifname[];
-
-const char def_ifname[] = "wlan0";
-module_param_string(fwpath, fwpath, sizeof(fwpath), 0644);
-module_param(enablelogcat, uint, 0644);
-module_param(wowledon, int, 0644);
-
-#ifdef CONFIG_HAS_EARLYSUSPEND
-static int screen_is_off;
-static struct early_suspend ar6k_early_suspend;
-#endif
-
-static int (*ar6000_avail_ev_p)(void *, void *);
-
-#if defined(CONFIG_ANDROID_LOGGER) && (!defined(CONFIG_MMC_MSM))
-int logger_write(const enum logidx index,
-                const unsigned char prio,
-                const char __kernel * const tag,
-                const char __kernel * const fmt,
-                ...)
-{
-    int ret = 0;
-    va_list vargs;
-    struct file *filp = (struct file *)-ENOENT;
-    mm_segment_t oldfs;
-    struct iovec vec[3];
-    int tag_bytes = strlen(tag) + 1, msg_bytes;
-    char *msg;      
-    va_start(vargs, fmt);
-    msg = kvasprintf(GFP_ATOMIC, fmt, vargs);
-    va_end(vargs);
-    if (!msg)
-        return -ENOMEM;
-    if (in_interrupt()) {
-        /* we have no choice since aio_write may be blocked */
-        printk(KERN_ALERT "%s", msg);
-        goto out_free_message;
-    }
-    msg_bytes = strlen(msg) + 1;
-    if (msg_bytes <= 1) /* empty message? */
-        goto out_free_message; /* don't bother, then */
-    if ((msg_bytes + tag_bytes + 1) > 2048) {
-        ret = -E2BIG;
-        goto out_free_message;
-    }
-            
-    vec[0].iov_base  = (unsigned char *) &prio;
-    vec[0].iov_len    = 1;
-    vec[1].iov_base   = (void *) tag;
-    vec[1].iov_len    = strlen(tag) + 1;
-    vec[2].iov_base   = (void *) msg;
-    vec[2].iov_len    = strlen(msg) + 1; 
-
-    oldfs = get_fs();
-    set_fs(KERNEL_DS);
-    do {
-        filp = filp_open("/dev/log/main", O_WRONLY, S_IRUSR);
-        if (IS_ERR(filp) || !filp->f_op) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: filp_open /dev/log/main error\n", __FUNCTION__));
-            ret = -ENOENT;
-            break;
-        }
-
-        if (filp->f_op->aio_write) {
-            int nr_segs = sizeof(vec) / sizeof(vec[0]);
-            int len = vec[0].iov_len + vec[1].iov_len + vec[2].iov_len;
-            struct kiocb kiocb;
-            init_sync_kiocb(&kiocb, filp);
-            kiocb.ki_pos = 0;
-            kiocb.ki_left = len;
-            kiocb.ki_nbytes = len;
-            ret = filp->f_op->aio_write(&kiocb, vec, nr_segs, kiocb.ki_pos);
-        }
-        
-    } while (0);
-
-    if (!IS_ERR(filp)) {
-        filp_close(filp, NULL);
-    }
-    set_fs(oldfs);
-out_free_message:
-    kfree(msg);
-    return ret;
-}
-#endif
-
-int android_logger_lv(void *module, int mask)
-{
-    switch (mask) {
-    case ATH_DEBUG_ERR:
-        return 6;
-    case ATH_DEBUG_INFO:
-        return 4;
-    case ATH_DEBUG_WARN:
-        return 5; 
-    case ATH_DEBUG_TRC:        
-        return 3; 
-    default:
-#ifdef DEBUG
-        if (!module) {
-            return 3;
-        } else if (module == &GET_ATH_MODULE_DEBUG_VAR_NAME(driver)) {
-            return (mask <=ATH_DEBUG_MAKE_MODULE_MASK(3)) ? 3 : 2;
-        } else if (module == &GET_ATH_MODULE_DEBUG_VAR_NAME(htc)) {
-            return 2;
-        } else {
-            return 3;
-        }
-#else
-        return 3; /* DEBUG */
-#endif
-    }
-}
-
-static int android_readwrite_file(const char *filename, char *rbuf, const char *wbuf, size_t length)
-{
-    int ret = 0;
-    struct file *filp = (struct file *)-ENOENT;
-    mm_segment_t oldfs;
-    oldfs = get_fs();
-    set_fs(KERNEL_DS);
-    do {
-        int mode = (wbuf) ? O_RDWR : O_RDONLY;
-        filp = filp_open(filename, mode, S_IRUSR);
-        if (IS_ERR(filp) || !filp->f_op) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: file %s filp_open error\n", __FUNCTION__, filename));
-            ret = -ENOENT;
-            break;
-        }
-    
-        if (length==0) {
-            /* Read the length of the file only */
-            struct inode    *inode;
-
-            inode = GET_INODE_FROM_FILEP(filp);
-            if (!inode) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: Get inode from %s failed\n", __FUNCTION__, filename));
-                ret = -ENOENT;
-                break;
-            }
-            ret = i_size_read(inode->i_mapping->host);
-            break;
-        }
-
-        if (wbuf) {
-            if ( (ret=filp->f_op->write(filp, wbuf, length, &filp->f_pos)) < 0) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: Write %u bytes to file %s error %d\n", __FUNCTION__, 
-                                length, filename, ret));
-                break;
-            }
-        } else {
-            if ( (ret=filp->f_op->read(filp, rbuf, length, &filp->f_pos)) < 0) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("%s: Read %u bytes from file %s error %d\n", __FUNCTION__,
-                                length, filename, ret));
-                break;
-            }
-        }
-    } while (0);
-
-    if (!IS_ERR(filp)) {
-        filp_close(filp, NULL);
-    }
-    set_fs(oldfs);
-
-    return ret;
-}
-
-int android_request_firmware(const struct firmware **firmware_p, const char *name,
-                     struct device *device)
-{
-    int ret = 0;
-    struct firmware *firmware;
-    char filename[256];
-    const char *raw_filename = name;
-	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
-    if (!firmware) 
-		return -ENOMEM;
-	sprintf(filename, "%s/%s", fwpath, raw_filename);
-    do {
-        size_t length, bufsize, bmisize;
-
-        if ( (ret=android_readwrite_file(filename, NULL, NULL, 0)) < 0) {
-            break;
-        } else {
-            length = ret;
-        }
-    
-        bufsize = ALIGN(length, PAGE_SIZE);
-        bmisize = A_ROUND_UP(length, 4);
-        bufsize = max(bmisize, bufsize);
-        firmware->data = vmalloc(bufsize);
-        firmware->size = length;
-        if (!firmware->data) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("%s: Cannot allocate buffer for firmware\n", __FUNCTION__));
-            ret = -ENOMEM;
-            break;
-        }
-    
-        if ( (ret=android_readwrite_file(filename, (char*)firmware->data, NULL, length)) != length) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("%s: file read error, ret %d request %d\n", __FUNCTION__, ret, length));
-            ret = -1;
-            break;
-        }
-    
-    } while (0);
-
-    if (ret<0) {
-        if (firmware) {
-            if (firmware->data)
-                vfree(firmware->data);
-            kfree(firmware);
-        }
-        *firmware_p = NULL;
-    } else {
-        ret = 0;
-    }
-    return ret;    
-}
-
-void android_release_firmware(const struct firmware *firmware)
-{
-	if (firmware) {
-        if (firmware->data)
-            vfree(firmware->data);
-        kfree(firmware);
-    }
-}
-
-static int ar6000_android_avail_ev(void *context, void *hif_handle)
-{
-    int ret;
-    ar6000_enable_mmchost_detect_change(0);
-    ret = ar6000_avail_ev_p(context, hif_handle);
-    return ret;
-}
-
-/* Useful for qualcom platform to detect our wlan card for mmc stack */
-static void ar6000_enable_mmchost_detect_change(int enable)
-{
-#ifdef CONFIG_MMC_MSM
-#define MMC_MSM_DEV "msm_sdcc.1"
-    char buf[3];
-    int length;
-
-    if (!enable_mmc_host_detect_change) {
-        return;
-    }
-    length = snprintf(buf, sizeof(buf), "%d\n", enable ? 1 : 0);
-    if (android_readwrite_file("/sys/devices/platform/" MMC_MSM_DEV "/detect_change", 
-                               NULL, buf, length) < 0) {
-        /* fall back to polling */
-        android_readwrite_file("/sys/devices/platform/" MMC_MSM_DEV "/polling", NULL, buf, length);
-    }
-#endif
-}
-
-#ifdef CONFIG_HAS_EARLYSUSPEND
-static void android_early_suspend(struct early_suspend *h)
-{
-    screen_is_off = 1;
-}
-
-static void android_late_resume(struct early_suspend *h)
-{
-    screen_is_off = 0;
-}
-#endif
-
-void android_module_init(OSDRV_CALLBACKS *osdrvCallbacks)
-{
-    if (ifname[0] == '\0')
-        strcpy(ifname, def_ifname);
-#ifdef CONFIG_HAS_EARLYSUSPEND
-    ar6k_early_suspend.suspend = android_early_suspend;
-    ar6k_early_suspend.resume  = android_late_resume;
-    ar6k_early_suspend.level   = EARLY_SUSPEND_LEVEL_BLANK_SCREEN;
-    register_early_suspend(&ar6k_early_suspend);
-#endif
-
-    ar6000_avail_ev_p = osdrvCallbacks->deviceInsertedHandler;
-    osdrvCallbacks->deviceInsertedHandler = ar6000_android_avail_ev;
-
-    ar6000_enable_mmchost_detect_change(1);
-}
-
-void android_module_exit(void)
-{
-#ifdef CONFIG_HAS_EARLYSUSPEND
-    unregister_early_suspend(&ar6k_early_suspend);
-#endif
-    ar6000_enable_mmchost_detect_change(1);
-}
-
-#ifdef CONFIG_PM
-void android_ar6k_check_wow_status(struct ar6_softc *ar, struct sk_buff *skb, bool isEvent)
-{
-    if (
-#ifdef CONFIG_HAS_EARLYSUSPEND
-        screen_is_off && 
-#endif 
-            skb && ar->arConnected) {
-        bool needWake = false;
-        if (isEvent) {
-            if (A_NETBUF_LEN(skb) >= sizeof(u16)) {
-                u16 cmd = *(const u16 *)A_NETBUF_DATA(skb);
-                switch (cmd) {
-                case WMI_CONNECT_EVENTID:
-                case WMI_DISCONNECT_EVENTID:
-                    needWake = true;
-                    break;
-                default:
-                    /* dont wake lock the system for other event */
-                    break;
-                }
-            }
-        } else if (A_NETBUF_LEN(skb) >= sizeof(ATH_MAC_HDR)) {
-            ATH_MAC_HDR *datap = (ATH_MAC_HDR *)A_NETBUF_DATA(skb);
-            if (!IEEE80211_IS_MULTICAST(datap->dstMac)) {
-                switch (A_BE2CPU16(datap->typeOrLen)) {
-                case 0x0800: /* IP */
-                case 0x888e: /* EAPOL */
-                case 0x88c7: /* RSN_PREAUTH */
-                case 0x88b4: /* WAPI */
-                     needWake = true;
-                     break;
-                case 0x0806: /* ARP is not important to hold wake lock */
-                default:
-                    break;
-                }
-            }
-        }
-        if (needWake) {
-            /* keep host wake up if there is any event and packate comming in*/
-            if (wowledon) {
-                char buf[32];
-                int len = sprintf(buf, "on");
-                android_readwrite_file("/sys/power/state", NULL, buf, len);
-
-                len = sprintf(buf, "%d", 127);
-                android_readwrite_file("/sys/class/leds/lcd-backlight/brightness",
-                                       NULL, buf,len);
-            }
-        }
-    }
-}
-#endif /* CONFIG_PM */
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 3dfbb0d..c938537 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -290,14 +290,6 @@ static void disconnect_timer_handler(unsigned long ptr);
 
 void read_rssi_compensation_param(struct ar6_softc *ar);
 
-    /* for android builds we call external APIs that handle firmware download and configuration */
-#ifdef ANDROID_ENV
-/* !!!! Interim android support to make it easier to patch the default driver for
- * android use. You must define an external source file ar6000_android.c that handles the following
- * APIs */
-extern void android_module_init(OSDRV_CALLBACKS *osdrvCallbacks);
-extern void android_module_exit(void);
-#endif
 /*
  * HTC service connection handlers
  */
@@ -660,10 +652,6 @@ ar6000_init_module(void)
 
     ar6000_pm_init();
 
-#ifdef ANDROID_ENV
-    android_module_init(&osdrvCallbacks);
-#endif
-
 #ifdef DEBUG
     /* Set the debug flags if specified at load time */
     if(debugflags != 0)
@@ -719,10 +707,6 @@ ar6000_cleanup_module(void)
 
     ar6000_pm_exit();
 
-#ifdef ANDROID_ENV    
-    android_module_exit();
-#endif
-
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("ar6000_cleanup: success\n"));
 }
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_pm.c b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
index 1a90424..b245909 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_pm.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
@@ -36,9 +36,6 @@
 extern unsigned int wmitimeout;
 extern wait_queue_head_t arEvent;
 
-#ifdef ANDROID_ENV
-extern void android_ar6k_check_wow_status(struct ar6_softc *ar, struct sk_buff *skb, bool isEvent);
-#endif
 #undef ATH_MODULE_NAME
 #define ATH_MODULE_NAME pm
 #define  ATH_DEBUG_PM       ATH_DEBUG_MAKE_MODULE_MASK(0)
@@ -283,10 +280,6 @@ void ar6000_check_wow_status(struct ar6_softc *ar, struct sk_buff *skb, bool isE
         /* Wow resume from irq interrupt */
         AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: WoW resume from irq thread status %d\n", __func__, ar->arWlanPowerState));
         ar6000_wow_resume(ar);
-    } else {
-#ifdef ANDROID_ENV
-        android_ar6k_check_wow_status(ar, skb, isEvent);
-#endif
     }
 }
 
@@ -373,17 +366,6 @@ ar6000_setup_cut_power_state(struct ar6_softc *ar,  AR6000_WLAN_STATE state)
                                 sizeof(HIF_DEVICE_POWER_CHANGE_TYPE));
 
             if (status == A_PENDING) {
-#ifdef ANDROID_ENV
-                 /* Wait for WMI ready event */
-                u32 timeleft = wait_event_interruptible_timeout(arEvent,
-                            (ar->arWmiReady == true), wmitimeout * HZ);
-                if (!timeleft || signal_pending(current)) {
-                    AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000 : Failed to get wmi ready \n"));
-                    status = A_ERROR;
-                    break;
-                }
-#endif
-                status = 0;
             } else if (status == 0) {
                 ar6000_restart_endpoint(ar->arNetDev);
                 status = 0;
diff --git a/drivers/staging/ath6kl/os/linux/eeprom.c b/drivers/staging/ath6kl/os/linux/eeprom.c
index 4cff9da..96f1724 100644
--- a/drivers/staging/ath6kl/os/linux/eeprom.c
+++ b/drivers/staging/ath6kl/os/linux/eeprom.c
@@ -359,216 +359,3 @@ commit_4bytes(int offset, u32 data)
     request_4byte_write(offset, data);
     wait_for_eeprom_completion();
 }
-/* ATHENV */
-#ifdef ANDROID_ENV
-void eeprom_ar6000_transfer(struct hif_device *device, char *fake_file, char *p_mac)
-{
-    u32 first_word;
-    u32 board_data_addr;
-    int i;
-
-    printk("%s: Enter\n", __FUNCTION__);
-
-    enable_SI(device);
-    eeprom_type_detect();
-
-    if (fake_file) {
-        /*
-         * Transfer from file to Target RAM.
-         * Fetch source data from file.
-         */
-        mm_segment_t		oldfs;
-        struct file		*filp;
-        struct inode		*inode = NULL;
-        int			length;
-
-        /* open file */
-        oldfs = get_fs();
-        set_fs(KERNEL_DS);
-        filp = filp_open(fake_file, O_RDONLY, S_IRUSR);
-
-        if (IS_ERR(filp)) {
-            printk("%s: file %s filp_open error\n", __FUNCTION__, fake_file);
-            set_fs(oldfs);
-            return;
-        }
-
-        if (!filp->f_op) {
-            printk("%s: File Operation Method Error\n", __FUNCTION__);
-            filp_close(filp, NULL);
-            set_fs(oldfs);
-            return;
-        }
-
-        inode = GET_INODE_FROM_FILEP(filep);
-        if (!inode) {
-            printk("%s: Get inode from filp failed\n", __FUNCTION__);
-            filp_close(filp, NULL);
-            set_fs(oldfs);
-            return;
-        }
-
-        printk("%s file offset opsition: %xh\n", __FUNCTION__, (unsigned)filp->f_pos);
-
-        /* file's size */
-        length = i_size_read(inode->i_mapping->host);
-        printk("%s: length=%d\n", __FUNCTION__, length);
-        if (length != EEPROM_SZ) {
-            printk("%s: The file's size is not as expected\n", __FUNCTION__);
-            filp_close(filp, NULL);
-            set_fs(oldfs);
-            return;
-        }
-
-        /* read data */
-        if (filp->f_op->read(filp, eeprom_data, length, &filp->f_pos) != length) {
-            printk("%s: file read error\n", __FUNCTION__);
-            filp_close(filp, NULL);
-            set_fs(oldfs);
-            return;
-        }
-
-        /* read data out successfully */
-        filp_close(filp, NULL);
-        set_fs(oldfs);
-    } else {
-        /*
-         * Read from EEPROM to file OR transfer from EEPROM to Target RAM.
-         * Fetch EEPROM_SZ Bytes of Board Data, 8 bytes at a time.
-         */
-
-        fetch_8bytes(0, (u32 *)(&eeprom_data[0]));
-
-        /* Check the first word of EEPROM for validity */
-        first_word = *((u32 *)eeprom_data);
-
-        if ((first_word == 0) || (first_word == 0xffffffff)) {
-            printk("Did not find EEPROM with valid Board Data.\n");
-        }
-
-        for (i=8; i<EEPROM_SZ; i+=8) {
-            fetch_8bytes(i, (u32 *)(&eeprom_data[i]));
-        }
-    }
-
-    /* soft mac */
-    if (p_mac) {
-
-        mm_segment_t		oldfs;
-        struct file		*filp;
-        struct inode		*inode = NULL;
-        int			length;
-        
-        /* open file */
-        oldfs = get_fs();
-        set_fs(KERNEL_DS);
-        filp = filp_open(p_mac, O_RDONLY, S_IRUSR);
-        
-        printk("%s try to open file %s\n", __FUNCTION__, p_mac);
-
-        if (IS_ERR(filp)) {
-            printk("%s: file %s filp_open error\n", __FUNCTION__, p_mac);
-            set_fs(oldfs);
-            return;
-        }
-        
-        if (!filp->f_op) {
-            printk("%s: File Operation Method Error\n", __FUNCTION__);
-            filp_close(filp, NULL);
-            set_fs(oldfs);
-            return;
-        }
-        
-        inode = GET_INODE_FROM_FILEP(filep);
-        if (!inode) {
-            printk("%s: Get inode from filp failed\n", __FUNCTION__);
-            filp_close(filp, NULL);
-            set_fs(oldfs);
-            return;
-        }
-        
-        printk("%s file offset opsition: %xh\n", __FUNCTION__, (unsigned)filp->f_pos);
-        
-        /* file's size */
-        length = i_size_read(inode->i_mapping->host);
-        printk("%s: length=%d\n", __FUNCTION__, length);
-        if (length > ATH_SOFT_MAC_TMP_BUF_LEN) {
-            printk("%s: MAC file's size is not as expected\n", __FUNCTION__);
-            filp_close(filp, NULL);
-            set_fs(oldfs);
-            return;
-        }
-        
-        /* read data */
-        if (filp->f_op->read(filp, soft_mac_tmp_buf, length, &filp->f_pos) != length) {
-            printk("%s: file read error\n", __FUNCTION__);
-            filp_close(filp, NULL);
-            set_fs(oldfs);
-            return;
-        }
-
-#if 0
-        /* the data we just read */
-        printk("%s: mac address from the file:\n", __FUNCTION__);
-        for (i = 0; i < length; i++)
-            printk("[%c(0x%x)],", soft_mac_tmp_buf[i], soft_mac_tmp_buf[i]);
-        printk("\n");
-#endif
-
-        /* read data out successfully */
-        filp_close(filp, NULL);
-        set_fs(oldfs);
-
-        /* convert mac address */
-        if (!wmic_ether_aton(soft_mac_tmp_buf, mac_addr)) {
-            printk("%s: convert mac value fail\n", __FUNCTION__);
-            return;
-        }
-
-#if 0
-        /* the converted mac address */
-        printk("%s: the converted mac value\n", __FUNCTION__);
-        for (i = 0; i < ATH_MAC_LEN; i++)
-            printk("[0x%x],", mac_addr[i]);
-        printk("\n");
-#endif
-    }
-    /* soft mac */
-
-    /* Determine where in Target RAM to write Board Data */
-    BMI_read_mem( HOST_INTEREST_ITEM_ADDRESS(hi_board_data), &board_data_addr);
-    if (board_data_addr == 0) {
-        printk("hi_board_data is zero\n");
-    }
-
-    /* soft mac */
-#if 1
-    /* Update MAC address in RAM */
-    if (p_mac) {
-	    update_mac(eeprom_data, EEPROM_SZ, mac_addr);
-    }
-#endif
-#if 0
-    /* mac address in eeprom array */
-    printk("%s: mac values in eeprom array\n", __FUNCTION__);
-    for (i = 10; i < 10 + 6; i++)
-        printk("[0x%x],", eeprom_data[i]);
-    printk("\n");
-#endif
-    /* soft mac */
-
-    /* Write EEPROM data to Target RAM */
-    BMI_write_mem(board_data_addr, ((u8 *)eeprom_data), EEPROM_SZ);
-
-    /* Record the fact that Board Data IS initialized */
-    {
-       u32 one = 1;
-       BMI_write_mem(HOST_INTEREST_ITEM_ADDRESS(hi_board_data_initialized),
-                     (u8 *)&one, sizeof(u32));
-    }
-
-    disable_SI();
-}
-#endif
-/* ATHENV */
-
diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index ff9d06e..07078b4 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -80,31 +80,9 @@
 #define A_MALLOC(size)                  kmalloc((size), GFP_KERNEL)
 #define A_MALLOC_NOWAIT(size)           kmalloc((size), GFP_ATOMIC)
 
-#if defined(ANDROID_ENV) && defined(CONFIG_ANDROID_LOGGER)
-extern unsigned int enablelogcat;
-extern int android_logger_lv(void* module, int mask);
-enum logidx { LOG_MAIN_IDX = 0 };
-extern int logger_write(const enum logidx idx, 
-                const unsigned char prio,
-                const char __kernel * const tag,
-                const char __kernel * const fmt,
-                ...);
-#define A_ANDROID_PRINTF(mask, module, tags, args...) do {  \
-    if (enablelogcat) \
-        logger_write(LOG_MAIN_IDX, android_logger_lv(module, mask), tags, args); \
-    else \
-        printk(KERN_ALERT args); \
-} while (0)
-#ifdef DEBUG
-#define A_LOGGER_MODULE_NAME(x) #x
-#define A_LOGGER(mask, mod, args...) \
-    A_ANDROID_PRINTF(mask, &GET_ATH_MODULE_DEBUG_VAR_NAME(mod), "ar6k_" A_LOGGER_MODULE_NAME(mod), args);
-#endif 
-#define A_PRINTF(args...) A_ANDROID_PRINTF(ATH_DEBUG_INFO, NULL, "ar6k_driver", args)
-#else
 #define A_LOGGER(mask, mod, args...)    printk(KERN_ALERT args)
 #define A_PRINTF(args...)               printk(KERN_ALERT args)
-#endif /* ANDROID */
+
 #define A_PRINTF_LOG(args...)           printk(args)
 #define A_SPRINTF(buf, args...)			sprintf (buf, args)
 
@@ -210,17 +188,8 @@ extern unsigned int panic_on_assert;
 #define A_ASSERT(expr)
 #endif /* DEBUG */
 
-#ifdef ANDROID_ENV
-struct firmware;
-int android_request_firmware(const struct firmware **firmware_p, const char *filename,
-                     struct device *device);
-void android_release_firmware(const struct firmware *firmware);
-#define A_REQUEST_FIRMWARE(_ppf, _pfile, _dev) android_request_firmware(_ppf, _pfile, _dev)
-#define A_RELEASE_FIRMWARE(_pf) android_release_firmware(_pf)
-#else
 #define A_REQUEST_FIRMWARE(_ppf, _pfile, _dev) request_firmware(_ppf, _pfile, _dev)
 #define A_RELEASE_FIRMWARE(_pf) release_firmware(_pf)
-#endif 
 
 /*
  * Initialization of the network buffer subsystem
@@ -364,17 +333,7 @@ static inline void *A_ALIGN_TO_CACHE_LINE(void *ptr) {
 #define A_MEMZERO(addr, len)            memset((addr), 0, (len))
 #define A_MALLOC(size)                  malloc(size)
 
-#ifdef ANDROID
-#ifndef err
-#include <errno.h>
-#define err(_s, args...) do { \
-    fprintf(stderr, "%s: line %d ", __FILE__, __LINE__); \
-    fprintf(stderr, args); fprintf(stderr, ": %d\n", errno); \
-    exit(_s); } while (0)
-#endif
-#else
 #include <err.h>
-#endif
 
 #endif /* __KERNEL__ */
 
diff --git a/drivers/staging/ath6kl/os/linux/include/wlan_config.h b/drivers/staging/ath6kl/os/linux/include/wlan_config.h
index 2de5cef..98951bb 100644
--- a/drivers/staging/ath6kl/os/linux/include/wlan_config.h
+++ b/drivers/staging/ath6kl/os/linux/include/wlan_config.h
@@ -56,11 +56,7 @@
  * If the firmware successly roams within the disconnect timeout
  * it sends a new connect event
  */
-#ifdef ANDROID_ENV
-#define WLAN_CONFIG_DISCONNECT_TIMEOUT 3
-#else
 #define WLAN_CONFIG_DISCONNECT_TIMEOUT 10
-#endif /* ANDROID_ENV */ 
 
 /*
  * This configuration item disables 11n support. 
diff --git a/drivers/staging/ath6kl/os/linux/wireless_ext.c b/drivers/staging/ath6kl/os/linux/wireless_ext.c
index 4b77943..5af09f1 100644
--- a/drivers/staging/ath6kl/os/linux/wireless_ext.c
+++ b/drivers/staging/ath6kl/os/linux/wireless_ext.c
@@ -2499,39 +2499,6 @@ ar6000_ioctl_siwscan(struct net_device *dev,
         }
     }
 
-#ifdef ANDROID_ENV
-#if WIRELESS_EXT >= 18
-    if (data->pointer && (data->length == sizeof(struct iw_scan_req)))
-    {
-        if ((data->flags & IW_SCAN_THIS_ESSID) == IW_SCAN_THIS_ESSID)
-        {
-            struct iw_scan_req req;
-            if (copy_from_user(&req, data->pointer, sizeof(struct iw_scan_req)))
-                return -EIO;
-            if (wmi_probedSsid_cmd(ar->arWmi, 1, SPECIFIC_SSID_FLAG, req.essid_len, req.essid) != 0)
-                return -EIO;
-            ar->scanSpecificSsid = true;
-        }
-        else
-        {
-            if (ar->scanSpecificSsid) {
-                if (wmi_probedSsid_cmd(ar->arWmi, 1, DISABLE_SSID_FLAG, 0, NULL) != 0)
-                    return -EIO;
-                 ar->scanSpecificSsid = false;
-            }
-        }
-    }
-    else
-    {
-        if (ar->scanSpecificSsid) {
-            if (wmi_probedSsid_cmd(ar->arWmi, 1, DISABLE_SSID_FLAG, 0, NULL) != 0)
-                return -EIO;
-             ar->scanSpecificSsid = false;
-        }
-    }
-#endif
-#endif /* ANDROID_ENV */
-
     if (wmi_startscan_cmd(ar->arWmi, WMI_LONG_SCAN, false, false, \
                           0, 0, 0, NULL) != 0) {
         ret = -EIO;
-- 
1.7.0.4

