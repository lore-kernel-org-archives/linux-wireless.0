Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47138 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab1C3A5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:08 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:56:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 13/34] ath6kl: remove USER_KEYS define
Date: Tue, 29 Mar 2011 17:56:10 -0700
Message-ID: <1301446591-15236-14-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is always defined so just keep the code.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/Makefile                    |    1 -
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   11 -----------
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    5 -----
 .../staging/ath6kl/os/linux/include/athdrv_linux.h |    2 --
 4 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/ath6kl/Makefile b/drivers/staging/ath6kl/Makefile
index a86dd5a..d7441e7 100644
--- a/drivers/staging/ath6kl/Makefile
+++ b/drivers/staging/ath6kl/Makefile
@@ -110,7 +110,6 @@ ifeq ($(CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK),y)
 ccflags-y += -DATH6KL_SKIP_ABI_VERSION_CHECK
 endif
 
-ccflags-y += -DUSER_KEYS
 ccflags-y += -DNO_SYNC_FLUSH
 ccflags-y += -DHTC_EP_STAT_PROFILING
 ccflags-y += -DWAPI_ENABLE
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 2a5abe0..abde256 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -349,9 +349,7 @@ static void ar6000_cookie_cleanup(struct ar6_softc *ar);
 static void ar6000_free_cookie(struct ar6_softc *ar, struct ar_cookie * cookie);
 static struct ar_cookie *ar6000_alloc_cookie(struct ar6_softc *ar);
 
-#ifdef USER_KEYS
 static int ar6000_reinstall_keys(struct ar6_softc *ar,u8 key_op_ctrl);
-#endif
 
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
 struct net_device *arApNetDev;
@@ -1926,10 +1924,8 @@ ar6000_stop_endpoint(struct net_device *dev, bool keepprofile, bool getdbglogs)
                     ar6000_disconnect_event(ar, DISCONNECT_CMD, ar->arBssid, 0, NULL, 0);
                 }
             }
-#ifdef USER_KEYS
             ar->user_savedkeys_stat = USER_SAVEDKEYS_STAT_INIT;
             ar->user_key_ctrl      = 0;
-#endif
         }
 
          AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("%s(): WMI stopped\n", __func__));
@@ -4347,7 +4343,6 @@ skip_key:
         wireless_send_event(ar->arNetDev, IWEVCUSTOM, &wrqu, buf);
     }
 
-#ifdef USER_KEYS
     if (ar->user_savedkeys_stat == USER_SAVEDKEYS_STAT_RUN &&
         ar->user_saved_keys.keyOk == true)
     {
@@ -4360,7 +4355,6 @@ skip_key:
         }
         ar6000_reinstall_keys(ar, key_op_ctrl);
     }
-#endif /* USER_KEYS */
 
     netif_wake_queue(ar->arNetDev);
 
@@ -4581,13 +4575,11 @@ ar6000_disconnect_event(struct ar6_softc *ar, u8 reason, u8 *bssid,
         reconnect_flag = 0;
     }
 
-#ifdef USER_KEYS
     if (reason != CSERV_DISCONNECT)
     {
         ar->user_savedkeys_stat = USER_SAVEDKEYS_STAT_INIT;
         ar->user_key_ctrl      = 0;
     }
-#endif /* USER_KEYS */
 
     netif_stop_queue(ar->arNetDev);
     A_MEMZERO(ar->arBssid, sizeof(ar->arBssid));
@@ -5713,9 +5705,7 @@ void ap_wapi_rekey_event(struct ar6_softc *ar, u8 type, u8 *mac)
 }
 #endif
 
-#ifdef USER_KEYS
 static int
-
 ar6000_reinstall_keys(struct ar6_softc *ar, u8 key_op_ctrl)
 {
     int status = 0;
@@ -5760,7 +5750,6 @@ _reinstall_keys_out:
 
     return status;
 }
-#endif /* USER_KEYS */
 
 
 void
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 5b053ab..23427cf 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -92,8 +92,6 @@
 #endif
 
 
-#ifdef USER_KEYS
-
 #define USER_SAVEDKEYS_STAT_INIT     0
 #define USER_SAVEDKEYS_STAT_RUN      1
 
@@ -104,7 +102,6 @@ struct USER_SAVEDKEYS {
     CRYPTO_TYPE               keyType;
     bool                    keyOk;
 };
-#endif
 
 #define DBG_INFO        0x00000001
 #define DBG_ERROR       0x00000002
@@ -540,11 +537,9 @@ struct ar6_softc {
     u32 log_cnt;
     u32 dbglog_init_done;
     u32 arConnectCtrlFlags;
-#ifdef USER_KEYS
     s32 user_savedkeys_stat;
     u32 user_key_ctrl;
     struct USER_SAVEDKEYS   user_saved_keys;
-#endif
     USER_RSSI_THOLD rssi_map[12];
     u8 arUserBssFilter;
     u16 ap_profile_flag;    /* AP mode */
diff --git a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
index 065b09b..3d5f01d 100644
--- a/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/athdrv_linux.h
@@ -620,7 +620,6 @@ typedef enum {
  */
 #define AR6000_XIOCTL_WMI_SET_TXOP                      57
 
-#ifdef USER_KEYS
 /*
  * arguments:
  * UINT32 cmd (AR6000_XIOCTL_USER_SETKEYS)
@@ -628,7 +627,6 @@ typedef enum {
  * uses struct ar6000_user_setkeys_info
  */
 #define AR6000_XIOCTL_USER_SETKEYS                      58
-#endif /* USER_KEYS */
 
 #define AR6000_XIOCTL_WMI_SET_KEEPALIVE                 59
 /*
-- 
1.7.0.4

