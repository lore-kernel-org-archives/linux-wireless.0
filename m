Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:58783 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932070AbeEWMnY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 08:43:24 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: RE: [PATCHv2 0/5] Runtime PM support for wlcore
Date: Wed, 23 May 2018 12:43:18 +0000
Message-ID: <a5eb26fc5db445f2a6473df1306da735@ti.com> (sfid-20180523_144332_327342_2F1FFCF8)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> >
> > Here's a modified version of your patch, does that put wlcore to
> > idle with wowlan during suspend for you?
> >
>=20
> Still no joy.
> It suspends/resumes ok but leaves the firmware disabled from entering ELP=
.

Spent some time on it today and looks like adding calls to pm_generic_runti=
me_suspend ()
And pm_generic_runtime_resume is helping and all seems to work well.
See the modified version of your patch below.
Let me know what you think.

Best Regards,
Eyal

8< ------------------------------
diff --git a/drivers/net/wireless/ti/wlcore/main.c
b/drivers/net/wireless/ti/wlcore/main.c
index 4c297aa..9859e5a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1001,24 +1001,6 @@ static int wlcore_fw_wakeup(struct wl1271 *wl)
     return wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP)=
;
 }

-static int wlcore_fw_sleep(struct wl1271 *wl)
-{
-    int ret;
-
-    mutex_lock(&wl->mutex);
-    ret =3D wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP);
-    if (ret < 0) {
-        wl12xx_queue_recovery_work(wl);
-        goto out;
-    }
-    set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
-out:
-    mutex_unlock(&wl->mutex);
-    mdelay(WL1271_SUSPEND_SLEEP);
-
-    return 0;
-}
-
 static int wl1271_setup(struct wl1271 *wl)
 {
     wl->raw_fw_status =3D kzalloc(wl->fw_status_len, GFP_KERNEL);
@@ -1742,6 +1724,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 {
     struct wl1271 *wl =3D hw->priv;
     struct wl12xx_vif *wlvif;
+    unsigned long flags;
     int ret;

     wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=3D%d", !!wow);
@@ -1800,19 +1783,6 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw=
,
     /* flush any remaining work */
     wl1271_debug(DEBUG_MAC80211, "flushing remaining works");

-    /*
-     * disable and re-enable interrupts in order to flush
-     * the threaded_irq
-     */
-    wlcore_disable_interrupts(wl);
-
-    /*
-     * set suspended flag to avoid triggering a new threaded_irq
-     * work. no need for spinlock as interrupts are disabled.
-     */
-    set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
-
-    wlcore_enable_interrupts(wl);
     flush_work(&wl->tx_work);

     /*
@@ -1822,13 +1792,14 @@ static int wl1271_op_suspend(struct ieee80211_hw *h=
w,
     cancel_delayed_work(&wl->tx_watchdog_work);

     /*
-     * Use an immediate call for allowing the firmware to go into power
-     * save during suspend.
-     * Using a workque for this last write was only hapenning on resume
-     * leaving the firmware with power save disabled during suspend,
-     * while consuming full power during wowlan suspend.
+     * set suspended flag to avoid triggering a new threaded_irq
+     * work.
      */
-    wlcore_fw_sleep(wl);
+    spin_lock_irqsave(&wl->wl_lock, flags);
+    set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+    spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+    pm_generic_runtime_suspend(wl->dev);

     return 0;
 }
@@ -1845,6 +1816,8 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
              wl->wow_enabled);
     WARN_ON(!wl->wow_enabled);

+    pm_generic_runtime_resume(wl->dev);
+
     /*
      * re-enable irq_work enqueuing, and call irq_work directly if
      * there is a pending work.
