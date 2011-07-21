Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:50079 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1GUNWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 09:22:34 -0400
Subject: [PATCH ersion=v2] ath6kl: fix suspend and resume
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Thu, 21 Jul 2011 16:22:23 +0300
Message-ID: <20110721132223.10837.60499.stgit@localhost6.localdomain6> (sfid-20110721_152237_640915_2937B146)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current suspend code in ath6kl is not working properly. Most of the
time during response there are sdio errors and sdio stack reloads the
driver.

I was pondering different options how to fix this and decided to take
the simplest route. First remove all the existing suspend/resume code
which was complicated and replace it with code which will leave
the chip powered on but will put it to deep sleep state. Now suspend
works much faster and realiably, the cost being that power consumption
will increase a bit during suspend.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |  127 ----
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   35 -
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |  603 --------------------
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   66 ++
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    8 
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |    7 
 6 files changed, 66 insertions(+), 780 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 5f5d677..156b552 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -50,10 +50,6 @@
 #endif
 
 /* ATHENV */
-#if defined(CONFIG_PM)
-#define dev_to_sdio_func(d)	container_of(d, struct sdio_func, dev)
-#define to_sdio_driver(d)      container_of(d, struct sdio_driver, drv)
-#endif /* CONFIG_PM */
 static void delHifDevice(struct hif_device * device);
 static int Func0_CMD52WriteByte(struct mmc_card *card, unsigned int address, unsigned char byte);
 static int Func0_CMD52ReadByte(struct mmc_card *card, unsigned int address, unsigned char *byte);
@@ -160,72 +156,11 @@ static void ath6kl_hifdev_remove(struct sdio_func *func)
 	delHifDevice(device);
 }
 
-#if defined(CONFIG_PM)
-static int ath6kl_hifdev_suspend(struct device *dev)
-{
-	struct sdio_func *func = dev_to_sdio_func(dev);
-	int status = 0;
-	struct hif_device *device;
-
-	device = ath6kl_get_hifdev(func);
-
-	if (device && device->claimedContext &&
-	    osdrvCallbacks.deviceSuspendHandler) {
-		/* set true first for PowerStateChangeNotify(..) */
-		device->is_suspend = true;
-		status = osdrvCallbacks.
-			deviceSuspendHandler(device->claimedContext);
-		if (status)
-			device->is_suspend = false;
-	}
-
-	CleanupHIFScatterResources(device);
-
-	switch (status) {
-	case 0:
-		return 0;
-	case A_EBUSY:
-		/* Hack for kernel in order to support deep sleep and wow */
-		return -EBUSY;
-	default:
-		return -1;
-	}
-}
-
-static int ath6kl_hifdev_resume(struct device *dev)
-{
-	struct sdio_func *func = dev_to_sdio_func(dev);
-	int status = 0;
-	struct hif_device *device;
-
-	device = ath6kl_get_hifdev(func);
-	if (device && device->claimedContext &&
-	    osdrvCallbacks.deviceSuspendHandler) {
-		status = osdrvCallbacks.
-			deviceResumeHandler(device->claimedContext);
-		if (status == 0)
-			device->is_suspend = false;
-	}
-
-	return status;
-}
-
-static const struct dev_pm_ops ath6kl_hifdev_pmops = {
-	.suspend = ath6kl_hifdev_suspend,
-	.resume = ath6kl_hifdev_resume,
-};
-#endif /* CONFIG_PM */
-
 static struct sdio_driver ath6kl_hifdev_driver = {
 	.name = "ath6kl_hifdev",
 	.id_table = ath6kl_hifdev_ids,
 	.probe = ath6kl_hifdev_probe,
 	.remove = ath6kl_hifdev_remove,
-#if defined(CONFIG_PM)
-	.drv = {
-		.pm = &ath6kl_hifdev_pmops,
-	},
-#endif
 };
 
 /* make sure we only unregister when registered. */
@@ -769,42 +704,6 @@ int
 PowerStateChangeNotify(struct hif_device *device, HIF_DEVICE_POWER_CHANGE_TYPE config)
 {
     int status = 0;
-#if defined(CONFIG_PM)
-	struct sdio_func *func = device->func;
-    int old_reset_val;
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +PowerStateChangeNotify %d\n", config));
-    switch (config) {
-       case HIF_DEVICE_POWER_DOWN:
-       case HIF_DEVICE_POWER_CUT:
-            old_reset_val = reset_sdio_on_unload;
-            reset_sdio_on_unload = 1;
-            status = hifDisableFunc(device, func);
-            reset_sdio_on_unload = old_reset_val;
-            if (!device->is_suspend) {
-                struct mmc_host *host = func->card->host;
-	            host->ios.clock = 0;
-	            host->ios.vdd = 0;
-                host->ios.bus_mode = MMC_BUSMODE_OPENDRAIN;
-                host->ios.chip_select = MMC_CS_DONTCARE;
-                host->ios.power_mode = MMC_POWER_OFF;
-                host->ios.bus_width = MMC_BUS_WIDTH_1;
-                host->ios.timing = MMC_TIMING_LEGACY;
-                host->ops->set_ios(host, &host->ios);
-            }
-            break;
-       case HIF_DEVICE_POWER_UP:
-            if (device->powerConfig == HIF_DEVICE_POWER_CUT) {
-                status = ReinitSDIO(device);
-            }
-            if (status == 0) {
-                status = hifEnableFunc(device, func);
-            }
-            break;
-    } 
-    device->powerConfig = config;
-
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -PowerStateChangeNotify\n"));
-#endif
     return status;
 }
 
@@ -921,26 +820,6 @@ static int startup_task(void *param)
     return 0;
 }
 
-#if defined(CONFIG_PM)
-static int enable_task(void *param)
-{
-    struct hif_device *device;
-    device = (struct hif_device *)param;
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: call  from resume_task\n"));
-
-        /* start  up inform DRV layer */
-    if (device && 
-        device->claimedContext && 
-        osdrvCallbacks.devicePowerChangeHandler &&
-        osdrvCallbacks.devicePowerChangeHandler(device->claimedContext, HIF_DEVICE_POWER_UP) != 0)
-    {
-        AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: Device rejected\n"));
-    }
-
-    return 0;
-}
-#endif
-
 void
 HIFAckInterrupt(struct hif_device *device)
 {
@@ -1132,12 +1011,6 @@ static int hifEnableFunc(struct hif_device *device, struct sdio_func *func)
         taskFunc = startup_task;
         taskName = "AR6K startup";
         ret = 0;
-#if defined(CONFIG_PM)
-    } else {
-        taskFunc = enable_task;
-        taskName = "AR6K enable";
-        ret = -ENOMEM;
-#endif /* CONFIG_PM */
     }
     /* create resume thread */
     pTask = kthread_create(taskFunc, (void *)device, taskName);
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 499b7a9..f12d9f6 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -634,11 +634,6 @@ ar6000_init_module(void)
     A_MEMZERO(&osdrvCallbacks,sizeof(osdrvCallbacks));
     osdrvCallbacks.deviceInsertedHandler = ar6000_avail_ev;
     osdrvCallbacks.deviceRemovedHandler = ar6000_unavail_ev;
-#ifdef CONFIG_PM
-    osdrvCallbacks.deviceSuspendHandler = ar6000_suspend_ev;
-    osdrvCallbacks.deviceResumeHandler = ar6000_resume_ev;
-    osdrvCallbacks.devicePowerChangeHandler = ar6000_power_change_ev;
-#endif
 
 #ifdef DEBUG
     /* Set the debug flags if specified at load time */
@@ -1704,14 +1699,6 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
     ar->arWlanPowerState     = WLAN_POWER_STATE_ON;
     ar->arWlanOff            = false;   /* We are in ON state */
-#ifdef CONFIG_PM
-    ar->arWowState           = WLAN_WOW_STATE_NONE;
-    ar->arBTOff              = true;   /* BT chip assumed to be OFF */
-    ar->arBTSharing          = WLAN_CONFIG_BT_SHARING; 
-    ar->arWlanOffConfig      = WLAN_CONFIG_WLAN_OFF;
-    ar->arSuspendConfig      = WLAN_CONFIG_PM_SUSPEND;
-    ar->arWow2Config         = WLAN_CONFIG_PM_WOW2;
-#endif /* CONFIG_PM */
 
     A_INIT_TIMER(&ar->arHBChallengeResp.timer, ar6000_detect_error, dev);
     ar->arHBChallengeResp.seqNum = 0;
@@ -2944,12 +2931,6 @@ ar6000_data_tx(struct sk_buff *skb, struct net_device *dev)
     bool            checkAdHocPsMapping = false,bMoreData = false;
     HTC_TX_TAG        htc_tag = AR6K_DATA_PKT_TAG;
     u8 dot11Hdr = processDot11Hdr;
-#ifdef CONFIG_PM
-    if (ar->arWowState != WLAN_WOW_STATE_NONE) {
-        A_NETBUF_FREE(skb);
-        return 0;
-    }
-#endif /* CONFIG_PM */
 
     AR_DEBUG_PRINTF(ATH_DEBUG_WLAN_TX,("ar6000_data_tx start - skb=0x%lx, data=0x%lx, len=0x%x\n",
                      (unsigned long)skb, (unsigned long)A_NETBUF_DATA(skb),
@@ -3668,9 +3649,6 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
            /*
             * this is a wmi control msg
             */
-#ifdef CONFIG_PM 
-            ar6000_check_wow_status(ar, skb, true);
-#endif /* CONFIG_PM */
             wmi_control_rx(ar->arWmi, skb);
         } else {
                 WMI_DATA_HDR *dhdr = (WMI_DATA_HDR *)A_NETBUF_DATA(skb);
@@ -3693,9 +3671,6 @@ ar6000_rx(void *Context, struct htc_packet *pPacket)
 			return;
 		}
 
-#ifdef CONFIG_PM 
-                ar6000_check_wow_status(ar, NULL, false);
-#endif /* CONFIG_PM */
                 /*
                  * this is a wmi data packet
                  */
@@ -3912,9 +3887,6 @@ ar6000_deliver_frames_to_nw_stack(void *dev, void *osbuf)
     if(skb) {
         skb->dev = dev;
         if ((skb->dev->flags & IFF_UP) == IFF_UP) {
-#ifdef CONFIG_PM 
-            ar6000_check_wow_status((struct ar6_softc *)ar6k_priv(dev), skb, false);
-#endif /* CONFIG_PM */
             skb->protocol = eth_type_trans(skb, skb->dev);
         /*
          * If this routine is called on a ISR (Hard IRQ) or DSR (Soft IRQ)
@@ -5189,12 +5161,7 @@ ar6000_control_tx(void *devt, void *osbuf, HTC_ENDPOINT_ID eid)
     int         status = 0;
     struct ar_cookie *cookie = NULL;
     int i;
-#ifdef CONFIG_PM
-    if (ar->arWowState != WLAN_WOW_STATE_NONE) {
-        A_NETBUF_FREE(osbuf);
-        return A_EACCES;
-    }
-#endif /* CONFIG_PM */
+
         /* take lock to protect ar6000_alloc_cookie() */
     AR6000_SPIN_LOCK(&ar->arLock, 0);
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_pm.c b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
index 1e0ace8..e43dd5c 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_pm.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
@@ -21,606 +21,3 @@
  *
  */
 
-/*
- * Implementation of system power management
- */
-
-#include "ar6000_drv.h"
-#include <linux/inetdevice.h>
-#include <linux/platform_device.h>
-#include "wlan_config.h"
-
-#define WOW_ENABLE_MAX_INTERVAL 0
-#define WOW_SET_SCAN_PARAMS     0
-
-extern unsigned int wmitimeout;
-extern wait_queue_head_t arEvent;
-
-#undef ATH_MODULE_NAME
-#define ATH_MODULE_NAME pm
-#define  ATH_DEBUG_PM       ATH_DEBUG_MAKE_MODULE_MASK(0)
-
-#ifdef DEBUG
-static struct ath_debug_mask_description pm_debug_desc[] = {
-    { ATH_DEBUG_PM     , "System power management"},
-};
-
-ATH_DEBUG_INSTANTIATE_MODULE_VAR(pm,
-                                 "pm",
-                                 "System Power Management",
-                                 ATH_DEBUG_MASK_DEFAULTS | ATH_DEBUG_PM,
-                                 ATH_DEBUG_DESCRIPTION_COUNT(pm_debug_desc),
-                                 pm_debug_desc);
-
-#endif /* DEBUG */
-
-int ar6000_exit_cut_power_state(struct ar6_softc *ar);
-
-#ifdef CONFIG_PM
-static void ar6k_send_asleep_event_to_app(struct ar6_softc *ar, bool asleep)
-{
-    char buf[128];
-    union iwreq_data wrqu;
-
-    snprintf(buf, sizeof(buf), "HOST_ASLEEP=%s", asleep ? "asleep" : "awake");
-    A_MEMZERO(&wrqu, sizeof(wrqu));
-    wrqu.data.length = strlen(buf);
-    wireless_send_event(ar->arNetDev, IWEVCUSTOM, &wrqu, buf);
-}
-
-static void ar6000_wow_resume(struct ar6_softc *ar)
-{
-    if (ar->arWowState!= WLAN_WOW_STATE_NONE) {
-        u16 fg_start_period = (ar->scParams.fg_start_period==0) ? 1 : ar->scParams.fg_start_period;
-        u16 bg_period = (ar->scParams.bg_period==0) ? 60 : ar->scParams.bg_period;
-        WMI_SET_HOST_SLEEP_MODE_CMD hostSleepMode = {true, false};
-        ar->arWowState = WLAN_WOW_STATE_NONE;
-        if (wmi_set_host_sleep_mode_cmd(ar->arWmi, &hostSleepMode)!= 0) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to setup restore host awake\n"));
-        }
-#if WOW_SET_SCAN_PARAMS
-        wmi_scanparams_cmd(ar->arWmi, fg_start_period,
-                                   ar->scParams.fg_end_period,
-                                   bg_period,
-                                   ar->scParams.minact_chdwell_time,
-                                   ar->scParams.maxact_chdwell_time,
-                                   ar->scParams.pas_chdwell_time,
-                                   ar->scParams.shortScanRatio,
-                                   ar->scParams.scanCtrlFlags,
-                                   ar->scParams.max_dfsch_act_time,
-                                   ar->scParams.maxact_scan_per_ssid);
-#else
-       (void)fg_start_period;
-       (void)bg_period;
-#endif
-
-
-#if WOW_ENABLE_MAX_INTERVAL /* we don't do it if the power consumption is already good enough. */
-        if (wmi_listeninterval_cmd(ar->arWmi, ar->arListenIntervalT, ar->arListenIntervalB) == 0) {
-        }
-#endif
-        ar6k_send_asleep_event_to_app(ar, false);
-        AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("Resume WoW successfully\n"));
-    } else {
-        AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("WoW does not invoked. skip resume"));
-    }
-    ar->arWlanPowerState = WLAN_POWER_STATE_ON;
-}
-
-static void ar6000_wow_suspend(struct ar6_softc *ar)
-{
-#define WOW_LIST_ID 1
-    if (ar->arNetworkType != AP_NETWORK) {
-        /* Setup WoW for unicast & Arp request for our own IP
-        disable background scan. Set listen interval into 1000 TUs
-        Enable keepliave for 110 seconds
-        */
-        struct in_ifaddr **ifap = NULL;
-        struct in_ifaddr *ifa = NULL;
-        struct in_device *in_dev;
-        u8 macMask[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-        int status;
-        WMI_ADD_WOW_PATTERN_CMD addWowCmd = { .filter = { 0 } };
-        WMI_DEL_WOW_PATTERN_CMD delWowCmd;
-        WMI_SET_HOST_SLEEP_MODE_CMD hostSleepMode = {false, true};
-        WMI_SET_WOW_MODE_CMD wowMode = {    .enable_wow = true,
-                                            .hostReqDelay = 500 };/*500 ms delay*/
-
-        if (ar->arWowState!= WLAN_WOW_STATE_NONE) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("System already go into wow mode!\n"));
-            return;
-        }
-
-        ar6000_TxDataCleanup(ar); /* IMPORTANT, otherwise there will be 11mA after listen interval as 1000*/
-
-#if WOW_ENABLE_MAX_INTERVAL /* we don't do it if the power consumption is already good enough. */
-        if (wmi_listeninterval_cmd(ar->arWmi, A_MAX_WOW_LISTEN_INTERVAL, 0) == 0) {
-        }
-#endif
-
-#if WOW_SET_SCAN_PARAMS
-        status = wmi_scanparams_cmd(ar->arWmi, 0xFFFF, 0, 0xFFFF, 0, 0, 0, 0, 0, 0, 0);
-#endif
-        /* clear up our WoW pattern first */
-        delWowCmd.filter_list_id = WOW_LIST_ID;
-        delWowCmd.filter_id = 0;
-        wmi_del_wow_pattern_cmd(ar->arWmi, &delWowCmd);
-
-        /* setup unicast packet pattern for WoW */
-        if (ar->arNetDev->dev_addr[1]) {
-            addWowCmd.filter_list_id = WOW_LIST_ID;
-            addWowCmd.filter_size = 6; /* MAC address */
-            addWowCmd.filter_offset = 0;
-            status = wmi_add_wow_pattern_cmd(ar->arWmi, &addWowCmd, ar->arNetDev->dev_addr, macMask, addWowCmd.filter_size);
-            if (status) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to add WoW pattern\n"));
-            }
-        }
-        /* setup ARP request for our own IP */
-        if ((in_dev = __in_dev_get_rtnl(ar->arNetDev)) != NULL) {
-            for (ifap = &in_dev->ifa_list; (ifa = *ifap) != NULL; ifap = &ifa->ifa_next) {
-                if (!strcmp(ar->arNetDev->name, ifa->ifa_label)) {
-                    break; /* found */
-                }
-            }
-        }
-        if (ifa && ifa->ifa_local) {
-            WMI_SET_IP_CMD ipCmd;
-            memset(&ipCmd, 0, sizeof(ipCmd));
-            ipCmd.ips[0] = ifa->ifa_local;
-            status = wmi_set_ip_cmd(ar->arWmi, &ipCmd);
-            if (status) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to setup IP for ARP agent\n"));
-            }
-        }
-
-#ifndef ATH6K_CONFIG_OTA_MODE
-        wmi_powermode_cmd(ar->arWmi, REC_POWER);
-#endif
-
-        status = wmi_set_wow_mode_cmd(ar->arWmi, &wowMode);
-        if (status) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to enable wow mode\n"));
-        }
-        ar6k_send_asleep_event_to_app(ar, true);
-
-        status = wmi_set_host_sleep_mode_cmd(ar->arWmi, &hostSleepMode);
-        if (status) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to set host asleep\n"));
-        }
-
-        ar->arWowState = WLAN_WOW_STATE_SUSPENDING;
-        if (ar->arTxPending[ar->arControlEp]) {
-            u32 timeleft = wait_event_interruptible_timeout(arEvent,
-            ar->arTxPending[ar->arControlEp] == 0, wmitimeout * HZ);
-            if (!timeleft || signal_pending(current)) {
-               /* what can I do? wow resume at once */
-                AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to setup WoW. Pending wmi control data %d\n", ar->arTxPending[ar->arControlEp]));
-            }
-        }
-
-        status = hifWaitForPendingRecv(ar->arHifDevice);
-
-        ar->arWowState = WLAN_WOW_STATE_SUSPENDED;
-        ar->arWlanPowerState = WLAN_POWER_STATE_WOW;
-    } else {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Not allowed to go to WOW at this moment.\n"));
-    }
-}
-
-int ar6000_suspend_ev(void *context)
-{
-    int status = 0;
-    struct ar6_softc *ar = (struct ar6_softc *)context;
-    s16 pmmode = ar->arSuspendConfig;
-wow_not_connected:
-    switch (pmmode) {
-    case WLAN_SUSPEND_WOW:
-        if (ar->arWmiReady && ar->arWlanState==WLAN_ENABLED && ar->arConnected) {
-            ar6000_wow_suspend(ar);
-            AR_DEBUG_PRINTF(ATH_DEBUG_PM,("%s:Suspend for wow mode %d\n", __func__, ar->arWlanPowerState));
-        } else {
-            pmmode = ar->arWow2Config;
-            goto wow_not_connected;
-        }
-        break;
-    case WLAN_SUSPEND_CUT_PWR:
-        /* fall through */
-    case WLAN_SUSPEND_CUT_PWR_IF_BT_OFF:
-        /* fall through */
-    case WLAN_SUSPEND_DEEP_SLEEP:
-        /* fall through */
-    default:
-        status = ar6000_update_wlan_pwr_state(ar, WLAN_DISABLED, true);
-        if (ar->arWlanPowerState==WLAN_POWER_STATE_ON ||
-            ar->arWlanPowerState==WLAN_POWER_STATE_WOW) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("Strange suspend state for not wow mode %d", ar->arWlanPowerState));
-        }
-        AR_DEBUG_PRINTF(ATH_DEBUG_PM,("%s:Suspend for %d mode pwr %d status %d\n", __func__, pmmode, ar->arWlanPowerState, status));
-        status = (ar->arWlanPowerState == WLAN_POWER_STATE_CUT_PWR) ? 0 : A_EBUSY;
-        break;
-    }
-
-    ar->scan_triggered = 0;
-    return status;
-}
-
-int ar6000_resume_ev(void *context)
-{
-    struct ar6_softc *ar = (struct ar6_softc *)context;
-    u16 powerState = ar->arWlanPowerState;
-
-    AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: enter previous state %d wowState %d\n", __func__, powerState, ar->arWowState));
-    switch (powerState) {
-    case WLAN_POWER_STATE_WOW:
-        ar6000_wow_resume(ar);
-        break;
-    case WLAN_POWER_STATE_CUT_PWR:
-        /* fall through */
-    case WLAN_POWER_STATE_DEEP_SLEEP:
-        ar6000_update_wlan_pwr_state(ar, WLAN_ENABLED, true);
-        AR_DEBUG_PRINTF(ATH_DEBUG_PM,("%s:Resume for %d mode pwr %d\n", __func__, powerState, ar->arWlanPowerState));
-        break;
-    case WLAN_POWER_STATE_ON:
-        break;
-    default:
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Strange SDIO bus power mode!!\n"));
-        break;
-    }
-    return 0;
-}
-
-void ar6000_check_wow_status(struct ar6_softc *ar, struct sk_buff *skb, bool isEvent)
-{
-    if (ar->arWowState!=WLAN_WOW_STATE_NONE) {
-        if (ar->arWowState==WLAN_WOW_STATE_SUSPENDING) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_PM,("\n%s: Received IRQ while we are wow suspending!!!\n\n", __func__));
-            return;
-        }
-        /* Wow resume from irq interrupt */
-        AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: WoW resume from irq thread status %d\n", __func__, ar->arWlanPowerState));
-        ar6000_wow_resume(ar);
-    }
-}
-
-int ar6000_power_change_ev(void *context, u32 config)
-{
-    struct ar6_softc *ar = (struct ar6_softc *)context;
-    int status = 0;
-
-    AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: power change event callback %d \n", __func__, config));
-    switch (config) {
-       case HIF_DEVICE_POWER_UP:
-            ar6000_restart_endpoint(ar->arNetDev);
-            status = 0;
-            break;
-       case HIF_DEVICE_POWER_DOWN:
-       case HIF_DEVICE_POWER_CUT:
-            status = 0;
-            break;
-    }
-    return status;
-}
-
-#endif /* CONFIG_PM */
-
-int
-ar6000_setup_cut_power_state(struct ar6_softc *ar,  AR6000_WLAN_STATE state)
-{
-    int                      status = 0;
-    HIF_DEVICE_POWER_CHANGE_TYPE  config;
-
-    AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: Cut power %d %d \n", __func__,state, ar->arWlanPowerState));
-#ifdef CONFIG_PM
-    AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("Wlan OFF %d BT OFf %d \n", ar->arWlanOff, ar->arBTOff));
-#endif
-    do {
-        if (state == WLAN_ENABLED) {
-            /* Not in cut power state.. exit */
-            if (ar->arWlanPowerState != WLAN_POWER_STATE_CUT_PWR) {
-                break;
-            }
-
-            /* Change the state to ON */
-            ar->arWlanPowerState = WLAN_POWER_STATE_ON;
-
-
-            /* Indicate POWER_UP to HIF */
-            config = HIF_DEVICE_POWER_UP;
-            status = HIFConfigureDevice(ar->arHifDevice,
-                                HIF_DEVICE_POWER_STATE_CHANGE,
-                                &config,
-                                sizeof(HIF_DEVICE_POWER_CHANGE_TYPE));
-
-            if (status == A_PENDING) {
-            } else if (status == 0) {
-                ar6000_restart_endpoint(ar->arNetDev);
-                status = 0;
-            }
-        } else if (state == WLAN_DISABLED) {
-
-
-            /* Already in cut power state.. exit */
-            if (ar->arWlanPowerState == WLAN_POWER_STATE_CUT_PWR) {
-                break;
-            }
-            ar6000_stop_endpoint(ar->arNetDev, true, false);
-
-            config = HIF_DEVICE_POWER_CUT;
-            status = HIFConfigureDevice(ar->arHifDevice,
-                                HIF_DEVICE_POWER_STATE_CHANGE,
-                                &config,
-                                sizeof(HIF_DEVICE_POWER_CHANGE_TYPE));
-
-            ar->arWlanPowerState = WLAN_POWER_STATE_CUT_PWR;
-        }
-    } while (0);
-
-    return status;
-}
-
-int
-ar6000_setup_deep_sleep_state(struct ar6_softc *ar, AR6000_WLAN_STATE state)
-{
-    int status = 0;
-
-    AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("%s: Deep sleep %d %d \n", __func__,state, ar->arWlanPowerState));
-#ifdef CONFIG_PM
-    AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("Wlan OFF %d BT OFf %d \n", ar->arWlanOff, ar->arBTOff));
-#endif
-    do {
-        WMI_SET_HOST_SLEEP_MODE_CMD hostSleepMode;
-
-        if (state == WLAN_ENABLED) {
-            u16 fg_start_period;
-
-            /* Not in deep sleep state.. exit */
-            if (ar->arWlanPowerState != WLAN_POWER_STATE_DEEP_SLEEP) {
-                if (ar->arWlanPowerState != WLAN_POWER_STATE_ON) {
-                    AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Strange state when we resume from deep sleep %d\n", ar->arWlanPowerState));
-                }
-                break;
-            }
-
-            fg_start_period = (ar->scParams.fg_start_period==0) ? 1 : ar->scParams.fg_start_period;
-            hostSleepMode.awake = true;
-            hostSleepMode.asleep = false;
-
-            if ((status=wmi_set_host_sleep_mode_cmd(ar->arWmi, &hostSleepMode)) != 0) {
-                break;
-            }
-
-            /* Change the state to ON */
-            ar->arWlanPowerState = WLAN_POWER_STATE_ON;
-
-                /* Enable foreground scanning */
-                if ((status=wmi_scanparams_cmd(ar->arWmi, fg_start_period,
-                                        ar->scParams.fg_end_period,
-                                        ar->scParams.bg_period,
-                                        ar->scParams.minact_chdwell_time,
-                                        ar->scParams.maxact_chdwell_time,
-                                        ar->scParams.pas_chdwell_time,
-                                        ar->scParams.shortScanRatio,
-                                        ar->scParams.scanCtrlFlags,
-                                        ar->scParams.max_dfsch_act_time,
-                                        ar->scParams.maxact_scan_per_ssid)) != 0)
-                {
-                    break;
-                }
-
-            if (ar->arNetworkType != AP_NETWORK)
-            {
-                if (ar->arSsidLen) {
-                    if (ar6000_connect_to_ap(ar) != 0) {
-                        /* no need to report error if connection failed */
-                        break;
-                    }
-                }
-            }
-        } else if (state == WLAN_DISABLED){
-            WMI_SET_WOW_MODE_CMD wowMode = { .enable_wow = false };
-
-            /* Already in deep sleep state.. exit */
-            if (ar->arWlanPowerState != WLAN_POWER_STATE_ON) {
-                if (ar->arWlanPowerState != WLAN_POWER_STATE_DEEP_SLEEP) {
-                    AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Strange state when we suspend for deep sleep %d\n", ar->arWlanPowerState));
-                }
-                break;
-            }
-
-            if (ar->arNetworkType != AP_NETWORK)
-            {
-                /* Disconnect from the AP and disable foreground scanning */
-                AR6000_SPIN_LOCK(&ar->arLock, 0);
-                if (ar->arConnected == true || ar->arConnectPending == true) {
-                    AR6000_SPIN_UNLOCK(&ar->arLock, 0);
-                    wmi_disconnect_cmd(ar->arWmi);
-                } else {
-                    AR6000_SPIN_UNLOCK(&ar->arLock, 0);
-                }
-            }
-
-            ar->scan_triggered = 0;
-
-            if ((status=wmi_scanparams_cmd(ar->arWmi, 0xFFFF, 0, 0, 0, 0, 0, 0, 0, 0, 0)) != 0) {
-                break;
-            }
-
-            /* make sure we disable wow for deep sleep */
-            if ((status=wmi_set_wow_mode_cmd(ar->arWmi, &wowMode))!= 0)
-            {
-                break;
-            }
-
-            ar6000_TxDataCleanup(ar);
-#ifndef ATH6K_CONFIG_OTA_MODE
-            wmi_powermode_cmd(ar->arWmi, REC_POWER);
-#endif
-
-            hostSleepMode.awake = false;
-            hostSleepMode.asleep = true;
-            if ((status=wmi_set_host_sleep_mode_cmd(ar->arWmi, &hostSleepMode))!= 0) {
-                break;
-            }
-            if (ar->arTxPending[ar->arControlEp]) {
-                u32 timeleft = wait_event_interruptible_timeout(arEvent,
-                                ar->arTxPending[ar->arControlEp] == 0, wmitimeout * HZ);
-                if (!timeleft || signal_pending(current)) {
-                    status = A_ERROR;
-                    break;
-                }
-            }
-            status = hifWaitForPendingRecv(ar->arHifDevice);
-
-            ar->arWlanPowerState = WLAN_POWER_STATE_DEEP_SLEEP;
-        }
-    } while (0);
-
-    if (status) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to enter/exit deep sleep %d\n", state));
-    }
-
-    return status;
-}
-
-int
-ar6000_update_wlan_pwr_state(struct ar6_softc *ar, AR6000_WLAN_STATE state, bool pmEvent)
-{
-    int status = 0;
-    u16 powerState, oldPowerState;
-    AR6000_WLAN_STATE oldstate = ar->arWlanState;
-    bool wlanOff = ar->arWlanOff;
-#ifdef CONFIG_PM
-    bool btOff = ar->arBTOff;
-#endif /* CONFIG_PM */
-
-    if ((state!=WLAN_DISABLED && state!=WLAN_ENABLED)) {
-        return A_ERROR;
-    }
-
-    if (ar->bIsDestroyProgress) {
-        return A_EBUSY;
-    }
-
-    if (down_interruptible(&ar->arSem)) {
-        return A_ERROR;
-    }
-
-    if (ar->bIsDestroyProgress) {
-        up(&ar->arSem);
-        return A_EBUSY;
-    }
-
-    ar->arWlanState = wlanOff ? WLAN_DISABLED : state;
-    oldPowerState = ar->arWlanPowerState;
-    if (state == WLAN_ENABLED) {
-        powerState = ar->arWlanPowerState;
-        AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("WLAN PWR set to ENABLE^^\n"));
-        if (!wlanOff) {
-            if (powerState == WLAN_POWER_STATE_DEEP_SLEEP) {
-                status = ar6000_setup_deep_sleep_state(ar, WLAN_ENABLED);
-            } else if (powerState == WLAN_POWER_STATE_CUT_PWR) {
-                status = ar6000_setup_cut_power_state(ar, WLAN_ENABLED);
-            }
-        }
-#ifdef CONFIG_PM
-        else if (pmEvent && wlanOff) {
-            bool allowCutPwr = ((!ar->arBTSharing) || btOff);
-            if ((powerState==WLAN_POWER_STATE_CUT_PWR) && (!allowCutPwr)) {
-                /* Come out of cut power */
-                ar6000_setup_cut_power_state(ar, WLAN_ENABLED);
-                status = ar6000_setup_deep_sleep_state(ar, WLAN_DISABLED);
-            }
-        }
-#endif /* CONFIG_PM */
-    } else if (state == WLAN_DISABLED) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("WLAN PWR set to DISABLED~\n"));
-        powerState = WLAN_POWER_STATE_DEEP_SLEEP;
-#ifdef CONFIG_PM
-        if (pmEvent) {  /* disable due to suspend */
-            bool suspendCutPwr = (ar->arSuspendConfig == WLAN_SUSPEND_CUT_PWR ||
-                                    (ar->arSuspendConfig == WLAN_SUSPEND_WOW &&
-                                        ar->arWow2Config==WLAN_SUSPEND_CUT_PWR));
-            bool suspendCutIfBtOff = ((ar->arSuspendConfig ==
-                                            WLAN_SUSPEND_CUT_PWR_IF_BT_OFF ||
-                                        (ar->arSuspendConfig == WLAN_SUSPEND_WOW &&
-                                         ar->arWow2Config==WLAN_SUSPEND_CUT_PWR_IF_BT_OFF)) &&
-                                        (!ar->arBTSharing || btOff));
-            if ((suspendCutPwr) ||
-                (suspendCutIfBtOff) ||
-                (ar->arWlanState==WLAN_POWER_STATE_CUT_PWR))
-            {
-                powerState = WLAN_POWER_STATE_CUT_PWR;
-            }
-        } else {
-            if ((wlanOff) &&
-                (ar->arWlanOffConfig == WLAN_OFF_CUT_PWR) &&
-                (!ar->arBTSharing || btOff))
-            {
-                /* For BT clock sharing designs, CUT_POWER depend on BT state */
-                powerState = WLAN_POWER_STATE_CUT_PWR;
-            }
-        }
-#endif /* CONFIG_PM */
-
-        if (powerState == WLAN_POWER_STATE_DEEP_SLEEP) {
-            if (ar->arWlanPowerState == WLAN_POWER_STATE_CUT_PWR) {
-                AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("Load firmware before set to deep sleep\n"));
-                ar6000_setup_cut_power_state(ar, WLAN_ENABLED);
-            }
-            status = ar6000_setup_deep_sleep_state(ar, WLAN_DISABLED);
-        } else if (powerState == WLAN_POWER_STATE_CUT_PWR) {
-            status = ar6000_setup_cut_power_state(ar, WLAN_DISABLED);
-        }
-
-    }
-
-    if (status) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("Fail to setup WLAN state %d\n", ar->arWlanState));
-        ar->arWlanState = oldstate;
-    } else if (status == 0) {
-        WMI_REPORT_SLEEP_STATE_EVENT  wmiSleepEvent, *pSleepEvent = NULL;
-        if ((ar->arWlanPowerState == WLAN_POWER_STATE_ON) && (oldPowerState != WLAN_POWER_STATE_ON)) {
-            wmiSleepEvent.sleepState = WMI_REPORT_SLEEP_STATUS_IS_AWAKE;
-            pSleepEvent = &wmiSleepEvent;
-        } else if ((ar->arWlanPowerState != WLAN_POWER_STATE_ON) && (oldPowerState == WLAN_POWER_STATE_ON)) {
-            wmiSleepEvent.sleepState = WMI_REPORT_SLEEP_STATUS_IS_DEEP_SLEEP;
-            pSleepEvent = &wmiSleepEvent;
-        }
-        if (pSleepEvent) {
-            AR_DEBUG_PRINTF(ATH_DEBUG_PM, ("SENT WLAN Sleep Event %d\n", wmiSleepEvent.sleepState));
-        }
-    }
-    up(&ar->arSem);
-    return status;
-}
-
-int
-ar6000_set_bt_hw_state(struct ar6_softc *ar, u32 enable)
-{
-#ifdef CONFIG_PM
-    bool off = (enable == 0);
-    int status;
-    if (ar->arBTOff == off) {
-        return 0;
-    }
-    ar->arBTOff = off;
-    status = ar6000_update_wlan_pwr_state(ar, ar->arWlanOff ? WLAN_DISABLED : WLAN_ENABLED, false);
-    return status;
-#else
-    return 0;
-#endif
-}
-
-int
-ar6000_set_wlan_state(struct ar6_softc *ar, AR6000_WLAN_STATE state)
-{
-    int status;
-    bool off = (state == WLAN_DISABLED);
-    if (ar->arWlanOff == off) {
-        return 0;
-    }
-    ar->arWlanOff = off;
-    status = ar6000_update_wlan_pwr_state(ar, state, false);
-    return status;
-}
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 5fdda4a..78018cc 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -25,9 +25,11 @@
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <net/netlink.h>
+#include <linux/mmc/pm.h>
+#include <linux/mmc/sdio_func.h>
 
 #include "ar6000_drv.h"
-
+#include "../../hif/sdio/linux_sdio/include/hif_internal.h"
 
 extern A_WAITQUEUE_HEAD arEvent;
 extern unsigned int wmitimeout;
@@ -1788,6 +1790,65 @@ static int ar6k_flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
+				 struct cfg80211_wowlan *wow)
+{
+	struct ar6_softc *ar = wiphy_priv(wiphy);
+	struct hif_device *hif_dev = ar->arHifDevice;
+	struct sdio_func *func = hif_dev->func;
+	mmc_pm_flag_t flags;
+	int ret;
+
+	flags = sdio_get_host_pm_caps(func);
+
+	if (!(flags & MMC_PM_KEEP_POWER))
+		/* as host doesn't support keep power we need to bail out */
+		return -EINVAL;
+
+	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+
+	if (ret) {
+		printk(KERN_ERR "ath6kl: set sdio pm flags failed: %d\n",
+		       ret);
+		return ret;
+	}
+
+	switch (ar->smeState) {
+	case SME_CONNECTING:
+		cfg80211_connect_result(ar->arNetDev, ar->arBssid, NULL, 0,
+					NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
+		break;
+	case SME_CONNECTED:
+	default:
+		/*
+		 * FIXME: oddly enough smeState is in DISCONNECTED during
+		 * suspend, why? Need to send disconnected event in that
+		 * state.
+		 */
+		cfg80211_disconnected(ar->arNetDev, 0, NULL, 0, GFP_KERNEL);
+		break;
+	}
+
+	if (ar->arConnected || ar->arConnectPending)
+		wmi_disconnect_cmd(ar->arWmi);
+
+	ar->smeState = SME_DISCONNECTED;
+
+	/* disable scanning */
+	if (wmi_scanparams_cmd(ar->arWmi, 0xFFFF, 0, 0, 0, 0, 0, 0, 0,
+			       0, 0) != 0)
+		printk(KERN_WARNING "ath6kl: failed to disable scan "
+		       "during suspend\n");
+
+	ar6k_cfg80211_scanComplete_event(ar, A_ECANCELED);
+
+	return 0;
+}
+#endif
+
 static struct
 cfg80211_ops ar6k_cfg80211_ops = {
     .change_virtual_intf = ar6k_cfg80211_change_iface,
@@ -1813,6 +1874,9 @@ cfg80211_ops ar6k_cfg80211_ops = {
     .del_pmksa = ar6k_del_pmksa,
     .flush_pmksa = ar6k_flush_pmksa,
     CFG80211_TESTMODE_CMD(ar6k_testmode_cmd)
+#ifdef CONFIG_PM
+    .suspend = ar6k_cfg80211_suspend,
+#endif
 };
 
 struct wireless_dev *
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 05cc774..2240da9 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -627,14 +627,6 @@ struct ar6_softc {
     u32 smeState;
     u16 arWlanPowerState;
     bool                  arWlanOff;
-#ifdef CONFIG_PM
-    u16 arWowState;
-    bool                  arBTOff;
-    bool                  arBTSharing;
-    u16 arSuspendConfig;
-    u16 arWlanOffConfig;
-    u16 arWow2Config;
-#endif
     u8 scan_triggered;
     WMI_SCAN_PARAMS_CMD     scParams;
 #define AR_MCAST_FILTER_MAC_ADDR_SIZE  4
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h b/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
index 184dbdb..063a8ec 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
@@ -171,13 +171,6 @@ int ar6000_update_wlan_pwr_state(struct ar6_softc *ar, AR6000_WLAN_STATE state,
 int ar6000_set_wlan_state(struct ar6_softc *ar, AR6000_WLAN_STATE state);
 int ar6000_set_bt_hw_state(struct ar6_softc *ar, u32 state);
 
-#ifdef CONFIG_PM
-int ar6000_suspend_ev(void *context);
-int ar6000_resume_ev(void *context);
-int ar6000_power_change_ev(void *context, u32 config);
-void ar6000_check_wow_status(struct ar6_softc *ar, struct sk_buff *skb, bool isEvent);
-#endif
-
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
 int ar6000_add_ap_interface(struct ar6_softc *ar, char *ifname);
 int ar6000_remove_ap_interface(struct ar6_softc *ar);

