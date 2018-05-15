Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:40861 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752537AbeEOQRm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 12:17:42 -0400
Received: by mail-it0-f65.google.com with SMTP id j186-v6so3053527ita.5
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 09:17:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180515161315.1997-3-tony@atomide.com>
References: <20180515161315.1997-1-tony@atomide.com> <20180515161315.1997-3-tony@atomide.com>
From: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date: Tue, 15 May 2018 18:17:39 +0200
Message-ID: <CAOf5uwkT4Vg1kQn5k=_z9XjXOLWbA0vioqH6KSdikZbCwyaYbA@mail.gmail.com> (sfid-20180515_181752_641754_568DCD22)
Subject: Re: [PATCH 2/2] wlcore: Add support runtime PM
To: Tony Lindgren <tony@atomide.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, May 15, 2018 at 6:13 PM, Tony Lindgren <tony@atomide.com> wrote:
> We can update wlcore to use PM runtime by adding functions for
> wlcore_runtime_suspend() and wlcore_runtime_resume() and replacing
> calls to wl1271_ps_elp_wakeup() and wl1271_ps_elp_sleep() with calls
> to pm_runtime_get_sync() and pm_runtime_put().
>
> Note that the new wlcore_runtime_suspend() and wlcore_runtime_resume()
> functions are based on simplified versions of wl1271_ps_elp_sleep() and
> wl1271_ps_elp_wakeup(). We don't want to use the old functions as we
> can now take advantage of the runtime PM usage count. And we don't need
> the old elp_work at all. And we can also remove WL1271_FLAG_ELP_REQUESTED
> that is no longer needed.
>
> Then eventually should allow us to use pm_runtime_autosuspend in
> further patches instead of the custom handling. And we should be able
> to start using Linux generic wakeirqs for the padconf interrupt.
>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  drivers/net/wireless/ti/wl18xx/debugfs.c    |  26 +-
>  drivers/net/wireless/ti/wlcore/debugfs.c    |  79 ++--
>  drivers/net/wireless/ti/wlcore/main.c       | 403 ++++++++++++++------
>  drivers/net/wireless/ti/wlcore/ps.c         | 146 -------
>  drivers/net/wireless/ti/wlcore/ps.h         |   3 -
>  drivers/net/wireless/ti/wlcore/scan.c       |   9 +-
>  drivers/net/wireless/ti/wlcore/sysfs.c      |  10 +-
>  drivers/net/wireless/ti/wlcore/testmode.c   |  17 +-
>  drivers/net/wireless/ti/wlcore/tx.c         |   9 +-
>  drivers/net/wireless/ti/wlcore/vendor_cmd.c |  26 +-
>  drivers/net/wireless/ti/wlcore/wlcore.h     |   1 -
>  drivers/net/wireless/ti/wlcore/wlcore_i.h   |   1 -
>  12 files changed, 401 insertions(+), 329 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
> --- a/drivers/net/wireless/ti/wl18xx/debugfs.c
> +++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
> @@ -20,6 +20,8 @@
>   *
>   */
>
> +#include <linux/pm_runtime.h>
> +
>  #include "../wlcore/debugfs.h"
>  #include "../wlcore/wlcore.h"
>  #include "../wlcore/debug.h"
> @@ -276,15 +278,17 @@ static ssize_t radar_detection_write(struct file *file,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl18xx_cmd_radar_detection_debug(wl, channel);
>         if (ret < 0)
>                 count = ret;
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>         return count;
> @@ -315,15 +319,17 @@ static ssize_t dynamic_fw_traces_write(struct file *file,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>

Can you just change ps_elp_wakeup with
       ret = pm_runtime_get_sync(wl->dev);
       if (ret < 0) {
               pm_runtime_put_noidle(wl->dev);
                 goto out;
       }

>         ret = wl18xx_acx_dynamic_fw_traces(wl);
>         if (ret < 0)
>                 count = ret;
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);

and elp_sleep with this one

>  out:
>         mutex_unlock(&wl->mutex);
>         return count;
> @@ -374,9 +380,11 @@ static ssize_t radar_debug_mode_write(struct file *file,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_for_each_wlvif_ap(wl, wlvif) {
>                 wlcore_cmd_generic_cfg(wl, wlvif,
> @@ -384,7 +392,7 @@ static ssize_t radar_debug_mode_write(struct file *file,
>                                        wl->radar_debug_mode, 0);
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);

Michael

>  out:
>         mutex_unlock(&wl->mutex);
>         return count;
> diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
> --- a/drivers/net/wireless/ti/wlcore/debugfs.c
> +++ b/drivers/net/wireless/ti/wlcore/debugfs.c
> @@ -26,6 +26,7 @@
>  #include <linux/skbuff.h>
>  #include <linux/slab.h>
>  #include <linux/module.h>
> +#include <linux/pm_runtime.h>
>
>  #include "wlcore.h"
>  #include "debug.h"
> @@ -65,9 +66,11 @@ void wl1271_debugfs_update_stats(struct wl1271 *wl)
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         if (!wl->plt &&
>             time_after(jiffies, wl->stats.fw_stats_update +
> @@ -76,7 +79,7 @@ void wl1271_debugfs_update_stats(struct wl1271 *wl)
>                 wl->stats.fw_stats_update = jiffies;
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -118,14 +121,17 @@ static void chip_op_handler(struct wl1271 *wl, unsigned long value,
>                 return;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
> +
>                 return;
> +       }
>
>         chip_op = arg;
>         chip_op(wl);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  }
>
>
> @@ -292,9 +298,11 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         /* In case we're already in PSM, trigger it again to set new timeout
>          * immediately without waiting for re-association
> @@ -305,7 +313,7 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
>                         wl1271_ps_set_mode(wl, wlvif, STATION_AUTO_PS_MODE);
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -359,9 +367,11 @@ static ssize_t forced_ps_write(struct file *file,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         /* In case we're already in PSM, trigger it again to switch mode
>          * immediately without waiting for re-association
> @@ -374,7 +384,7 @@ static ssize_t forced_ps_write(struct file *file,
>                         wl1271_ps_set_mode(wl, wlvif, ps_mode);
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -838,15 +848,17 @@ static ssize_t rx_streaming_interval_write(struct file *file,
>
>         wl->conf.rx_streaming.interval = value;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_for_each_wlvif_sta(wl, wlvif) {
>                 wl1271_recalc_rx_streaming(wl, wlvif);
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>         return count;
> @@ -893,15 +905,17 @@ static ssize_t rx_streaming_always_write(struct file *file,
>
>         wl->conf.rx_streaming.always = value;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_for_each_wlvif_sta(wl, wlvif) {
>                 wl1271_recalc_rx_streaming(wl, wlvif);
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>         return count;
> @@ -940,15 +954,17 @@ static ssize_t beacon_filtering_write(struct file *file,
>
>         mutex_lock(&wl->mutex);
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_for_each_wlvif(wl, wlvif) {
>                 ret = wl1271_acx_beacon_filter_opt(wl, wlvif, !!value);
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>         return count;
> @@ -1019,16 +1035,18 @@ static ssize_t sleep_auth_write(struct file *file,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl1271_acx_sleep_auth(wl, value);
>         if (ret < 0)
>                 goto out_sleep;
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>         return count;
> @@ -1083,7 +1101,7 @@ static ssize_t dev_mem_read(struct file *file,
>          * Don't fail if elp_wakeup returns an error, so the device's memory
>          * could be read even if the FW crashed
>          */
> -       wl1271_ps_elp_wakeup(wl);
> +       pm_runtime_get_sync(wl->dev);
>
>         /* store current partition and switch partition */
>         memcpy(&old_part, &wl->curr_part, sizeof(old_part));
> @@ -1102,7 +1120,7 @@ static ssize_t dev_mem_read(struct file *file,
>                 goto part_err;
>
>  part_err:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  skip_read:
>         mutex_unlock(&wl->mutex);
> @@ -1164,7 +1182,7 @@ static ssize_t dev_mem_write(struct file *file, const char __user *user_buf,
>          * Don't fail if elp_wakeup returns an error, so the device's memory
>          * could be read even if the FW crashed
>          */
> -       wl1271_ps_elp_wakeup(wl);
> +       pm_runtime_get_sync(wl->dev);
>
>         /* store current partition and switch partition */
>         memcpy(&old_part, &wl->curr_part, sizeof(old_part));
> @@ -1183,7 +1201,7 @@ static ssize_t dev_mem_write(struct file *file, const char __user *user_buf,
>                 goto part_err;
>
>  part_err:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  skip_write:
>         mutex_unlock(&wl->mutex);
> @@ -1247,8 +1265,9 @@ static ssize_t fw_logger_write(struct file *file,
>         }
>
>         mutex_lock(&wl->mutex);
> -       ret = wl1271_ps_elp_wakeup(wl);
> +       ret = pm_runtime_get_sync(wl->dev);
>         if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 count = ret;
>                 goto out;
>         }
> @@ -1257,7 +1276,7 @@ static ssize_t fw_logger_write(struct file *file,
>
>         ret = wl12xx_cmd_config_fwlog(wl);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -26,6 +26,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
> +#include <linux/pm_runtime.h>
>
>  #include "wlcore.h"
>  #include "debug.h"
> @@ -43,6 +44,7 @@
>
>  #define WL1271_BOOT_RETRIES 3
>  #define WL1271_SUSPEND_SLEEP 100
> +#define WL1271_WAKEUP_TIMEOUT 500
>
>  static char *fwlog_param;
>  static int fwlog_mem_blocks = -1;
> @@ -153,9 +155,11 @@ static void wl1271_rx_streaming_enable_work(struct work_struct *work)
>         if (!wl->conf.rx_streaming.interval)
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl1271_set_rx_streaming(wl, wlvif, true);
>         if (ret < 0)
> @@ -166,7 +170,7 @@ static void wl1271_rx_streaming_enable_work(struct work_struct *work)
>                   jiffies + msecs_to_jiffies(wl->conf.rx_streaming.duration));
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -183,16 +187,18 @@ static void wl1271_rx_streaming_disable_work(struct work_struct *work)
>         if (!test_bit(WLVIF_FLAG_RX_STREAMING_STARTED, &wlvif->flags))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl1271_set_rx_streaming(wl, wlvif, false);
>         if (ret)
>                 goto out_sleep;
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -229,9 +235,11 @@ static void wlcore_rc_update_work(struct work_struct *work)
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         if (ieee80211_vif_is_mesh(vif)) {
>                 ret = wl1271_acx_set_ht_capabilities(wl, &wlvif->rc_ht_cap,
> @@ -243,7 +251,7 @@ static void wlcore_rc_update_work(struct work_struct *work)
>         }
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -539,15 +547,16 @@ static int wlcore_irq_locked(struct wl1271 *wl)
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         while (!done && loopcount--) {
>                 /*
>                  * In order to avoid a race with the hardirq, clear the flag
> -                * before acknowledging the chip. Since the mutex is held,
> -                * wl1271_ps_elp_wakeup cannot be called concurrently.
> +                * before acknowledging the chip.
>                  */
>                 clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
>                 smp_mb__after_atomic();
> @@ -641,7 +650,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
>                         wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         return ret;
> @@ -818,6 +827,7 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen)
>  static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
>  {
>         u32 end_of_log = 0;
> +       int error;
>
>         if (wl->quirks & WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED)
>                 return;
> @@ -829,8 +839,11 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
>          * Do not send a stop fwlog command if the fw is hanged or if
>          * dbgpins are used (due to some fw bug).
>          */
> -       if (wl1271_ps_elp_wakeup(wl))
> +       error = pm_runtime_get_sync(wl->dev);
> +       if (error < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 return;
> +       }
>         if (!wl->watchdog_recovery &&
>             wl->conf.fwlog.output != WL12XX_FWLOG_OUTPUT_DBG_PINS)
>                 wl12xx_cmd_stop_fwlog(wl);
> @@ -925,9 +938,11 @@ static void wl1271_recovery_work(struct work_struct *work)
>         if (wl->state == WLCORE_STATE_OFF || wl->plt)
>                 goto out_unlock;
>
> -       error = wl1271_ps_elp_wakeup(wl);
> -       if (error < 0)
> +       error = pm_runtime_get_sync(wl->dev);
> +       if (error < 0) {
>                 wl1271_warning("Enable for recovery failed");
> +               pm_runtime_put_noidle(wl->dev);
> +       }
>
>         if (!test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags)) {
>                 if (wl->conf.fwlog.output == WL12XX_FWLOG_OUTPUT_HOST)
> @@ -971,7 +986,7 @@ static void wl1271_recovery_work(struct work_struct *work)
>          */
>         wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out_unlock:
>         wl->watchdog_recovery = false;
> @@ -1190,7 +1205,6 @@ int wl1271_plt_stop(struct wl1271 *wl)
>         wl1271_flush_deferred_work(wl);
>         cancel_work_sync(&wl->netstack_work);
>         cancel_work_sync(&wl->recovery_work);
> -       cancel_delayed_work_sync(&wl->elp_work);
>         cancel_delayed_work_sync(&wl->tx_watchdog_work);
>
>         mutex_lock(&wl->mutex);
> @@ -1740,8 +1754,9 @@ static int __maybe_unused wl1271_op_suspend(struct ieee80211_hw *hw,
>
>         mutex_lock(&wl->mutex);
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> +       ret = pm_runtime_get_sync(wl->dev);
>         if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 mutex_unlock(&wl->mutex);
>                 return ret;
>         }
> @@ -1771,6 +1786,7 @@ static int __maybe_unused wl1271_op_suspend(struct ieee80211_hw *hw,
>                 goto out_sleep;
>
>  out_sleep:
> +       pm_runtime_put_noidle(wl->dev);
>         mutex_unlock(&wl->mutex);
>
>         if (ret < 0) {
> @@ -1795,7 +1811,6 @@ static int __maybe_unused wl1271_op_suspend(struct ieee80211_hw *hw,
>
>         wlcore_enable_interrupts(wl);
>         flush_work(&wl->tx_work);
> -       flush_delayed_work(&wl->elp_work);
>
>         /*
>          * Cancel the watchdog even if above tx_flush failed. We will detect
> @@ -1863,9 +1878,11 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
>                 goto out_sleep;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_for_each_wlvif(wl, wlvif) {
>                 if (wlcore_is_p2p_mgmt(wlvif))
> @@ -1884,7 +1901,7 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
>                 goto out_sleep;
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         wl->wow_enabled = false;
> @@ -1951,7 +1968,6 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
>         cancel_delayed_work_sync(&wl->scan_complete_work);
>         cancel_work_sync(&wl->netstack_work);
>         cancel_work_sync(&wl->tx_work);
> -       cancel_delayed_work_sync(&wl->elp_work);
>         cancel_delayed_work_sync(&wl->tx_watchdog_work);
>
>         /* let's notify MAC80211 about the remaining pending TX frames */
> @@ -2066,13 +2082,15 @@ static void wlcore_channel_switch_work(struct work_struct *work)
>         vif = wl12xx_wlvif_to_vif(wlvif);
>         ieee80211_chswitch_done(vif, false);
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_cmd_stop_channel_switch(wl, wlvif);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -2134,14 +2152,16 @@ static void wlcore_pending_auth_complete_work(struct work_struct *work)
>         if (!time_after(time_spare, wlvif->pending_auth_reply_time))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         /* cancel the ROC if active */
>         wlcore_update_inconn_sta(wl, wlvif, NULL, false);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -2543,9 +2563,11 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
>         wl12xx_get_vif_count(hw, vif, &vif_count);
>
>         mutex_lock(&wl->mutex);
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out_unlock;
> +       }
>
>         /*
>          * in some very corner case HW recovery scenarios its possible to
> @@ -2628,7 +2650,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
>         else
>                 wl->sta_count++;
>  out:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out_unlock:
>         mutex_unlock(&wl->mutex);
>
> @@ -2683,9 +2705,11 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
>
>         if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
>                 /* disable active roles */
> -               ret = wl1271_ps_elp_wakeup(wl);
> -               if (ret < 0)
> +               ret = pm_runtime_get_sync(wl->dev);
> +               if (ret < 0) {
> +                       pm_runtime_put_noidle(wl->dev);
>                         goto deinit;
> +               }
>
>                 if (wlvif->bss_type == BSS_TYPE_STA_BSS ||
>                     wlvif->bss_type == BSS_TYPE_IBSS) {
> @@ -2703,7 +2727,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
>                                 goto deinit;
>                 }
>
> -               wl1271_ps_elp_sleep(wl);
> +               pm_runtime_put(wl->dev);
>         }
>  deinit:
>         wl12xx_tx_reset_wlvif(wl, wlvif);
> @@ -3127,9 +3151,11 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         /* configure each interface */
>         wl12xx_for_each_wlvif(wl, wlvif) {
> @@ -3139,7 +3165,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
>         }
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -3208,9 +3234,11 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_for_each_wlvif(wl, wlvif) {
>                 if (wlcore_is_p2p_mgmt(wlvif))
> @@ -3253,7 +3281,7 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
>          */
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -3460,13 +3488,15 @@ static int wlcore_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>                 goto out_wake_queues;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out_wake_queues;
> +       }
>
>         ret = wlcore_hw_set_key(wl, cmd, vif, sta, key_conf);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out_wake_queues:
>         if (might_change_spare)
> @@ -3606,9 +3636,11 @@ static void wl1271_op_set_default_key_idx(struct ieee80211_hw *hw,
>                 goto out_unlock;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out_unlock;
> +       }
>
>         wlvif->default_key = key_idx;
>
> @@ -3622,7 +3654,7 @@ static void wl1271_op_set_default_key_idx(struct ieee80211_hw *hw,
>         }
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out_unlock:
>         mutex_unlock(&wl->mutex);
> @@ -3640,7 +3672,7 @@ void wlcore_regdomain_config(struct wl1271 *wl)
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> +       ret = pm_runtime_get_sync(wl->dev);
>         if (ret < 0)
>                 goto out;
>
> @@ -3650,7 +3682,7 @@ void wlcore_regdomain_config(struct wl1271 *wl)
>                 goto out;
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -3684,9 +3716,11 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         /* fail if there is any role in ROC */
>         if (find_first_bit(wl->roc_map, WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES) {
> @@ -3697,7 +3731,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
>
>         ret = wlcore_scan(hw->priv, vif, ssid, len, req);
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -3724,9 +3758,11 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
>         if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         if (wl->scan.state != WL1271_SCAN_STATE_DONE) {
>                 ret = wl->ops->scan_stop(wl, wlvif);
> @@ -3747,7 +3783,7 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
>         ieee80211_scan_completed(wl->hw, &info);
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -3772,9 +3808,11 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl->ops->sched_scan_start(wl, wlvif, req, ies);
>         if (ret < 0)
> @@ -3783,7 +3821,7 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
>         wl->sched_vif = wlvif;
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>         return ret;
> @@ -3803,13 +3841,15 @@ static int wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl->ops->sched_scan_stop(wl, wlvif);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -3828,15 +3868,17 @@ static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl1271_acx_frag_threshold(wl, value);
>         if (ret < 0)
>                 wl1271_warning("wl1271_op_set_frag_threshold failed: %d", ret);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -3857,16 +3899,18 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_for_each_wlvif(wl, wlvif) {
>                 ret = wl1271_acx_rts_threshold(wl, wlvif, value);
>                 if (ret < 0)
>                         wl1271_warning("set rts threshold failed: %d", ret);
>         }
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -4613,9 +4657,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>         if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         if ((changed & BSS_CHANGED_TXPOWER) &&
>             bss_conf->txpower != wlvif->power_level) {
> @@ -4632,7 +4678,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>         else
>                 wl1271_bss_info_changed_sta(wl, vif, bss_conf, changed);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -4671,9 +4717,11 @@ static void wlcore_op_change_chanctx(struct ieee80211_hw *hw,
>
>         mutex_lock(&wl->mutex);
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl12xx_for_each_wlvif(wl, wlvif) {
>                 struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
> @@ -4696,7 +4744,7 @@ static void wlcore_op_change_chanctx(struct ieee80211_hw *hw,
>                 }
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -4725,9 +4773,11 @@ static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
>         if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wlvif->band = ctx->def.chan->band;
>         wlvif->channel = channel;
> @@ -4743,7 +4793,7 @@ static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
>                 wlvif->radar_enabled = true;
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -4774,9 +4824,11 @@ static void wlcore_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
>         if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         if (wlvif->radar_enabled) {
>                 wl1271_debug(DEBUG_MAC80211, "Stop radar detection");
> @@ -4784,7 +4836,7 @@ static void wlcore_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
>                 wlvif->radar_enabled = false;
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -4841,9 +4893,11 @@ wlcore_op_switch_vif_chanctx(struct ieee80211_hw *hw,
>
>         mutex_lock(&wl->mutex);
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         for (i = 0; i < n_vifs; i++) {
>                 struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vifs[i].vif);
> @@ -4853,7 +4907,7 @@ wlcore_op_switch_vif_chanctx(struct ieee80211_hw *hw,
>                         goto out_sleep;
>         }
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -4884,9 +4938,11 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
>         if (!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         /*
>          * the txop is confed in units of 32us by the mac80211,
> @@ -4905,7 +4961,7 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
>                                  0, 0);
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -4929,16 +4985,18 @@ static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl12xx_acx_tsf_info(wl, wlvif, &mactime);
>         if (ret < 0)
>                 goto out_sleep;
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -5244,13 +5302,15 @@ static int wl12xx_op_sta_state(struct ieee80211_hw *hw,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl12xx_update_sta_state(wl, wlvif, sta, old_state, new_state);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>         if (new_state < old_state)
> @@ -5299,9 +5359,11 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
>
>         ba_bitmap = &wl->links[hlid].ba_bitmap;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl1271_debug(DEBUG_MAC80211, "mac80211 ampdu: Rx tid %d action %d",
>                      tid, action);
> @@ -5374,7 +5436,7 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
>                 ret = -EINVAL;
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -5408,16 +5470,18 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
>         if (wlvif->bss_type == BSS_TYPE_STA_BSS &&
>             !test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
>
> -               ret = wl1271_ps_elp_wakeup(wl);
> -               if (ret < 0)
> +               ret = pm_runtime_get_sync(wl->dev);
> +               if (ret < 0) {
> +                       pm_runtime_put_noidle(wl->dev);
>                         goto out;
> +               }
>
>                 wl1271_set_band_rate(wl, wlvif);
>                 wlvif->basic_rate =
>                         wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
>                 ret = wl1271_acx_sta_rate_policies(wl, wlvif);
>
> -               wl1271_ps_elp_sleep(wl);
> +               pm_runtime_put(wl->dev);
>         }
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -5447,9 +5511,11 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         /* TODO: change mac80211 to pass vif as param */
>
> @@ -5471,7 +5537,7 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
>         }
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -5538,9 +5604,11 @@ static void wlcore_op_channel_switch_beacon(struct ieee80211_hw *hw,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl->ops->channel_switch(wl, wlvif, &ch_switch);
>         if (ret)
> @@ -5549,7 +5617,7 @@ static void wlcore_op_channel_switch_beacon(struct ieee80211_hw *hw,
>         set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> @@ -5590,9 +5658,11 @@ static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl12xx_start_dev(wl, wlvif, chan->band, channel);
>         if (ret < 0)
> @@ -5602,7 +5672,7 @@ static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
>         ieee80211_queue_delayed_work(hw, &wl->roc_complete_work,
>                                      msecs_to_jiffies(duration));
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>         return ret;
> @@ -5644,13 +5714,15 @@ static int wlcore_roc_completed(struct wl1271 *wl)
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = __wlcore_roc_completed(wl);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -5725,9 +5797,11 @@ static void wlcore_op_sta_statistics(struct ieee80211_hw *hw,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out_sleep;
> +       }
>
>         ret = wlcore_acx_average_rssi(wl, wlvif, &rssi_dbm);
>         if (ret < 0)
> @@ -5737,7 +5811,7 @@ static void wlcore_op_sta_statistics(struct ieee80211_hw *hw,
>         sinfo->signal = rssi_dbm;
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>  out:
>         mutex_unlock(&wl->mutex);
> @@ -6306,7 +6380,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
>         skb_queue_head_init(&wl->deferred_rx_queue);
>         skb_queue_head_init(&wl->deferred_tx_queue);
>
> -       INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
>         INIT_WORK(&wl->netstack_work, wl1271_netstack_work);
>         INIT_WORK(&wl->tx_work, wl1271_tx_work);
>         INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
> @@ -6581,6 +6654,100 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
>         complete_all(&wl->nvs_loading_complete);
>  }
>
> +static int __maybe_unused wlcore_runtime_suspend(struct device *dev)
> +{
> +       struct wl1271 *wl = dev_get_drvdata(dev);
> +       struct wl12xx_vif *wlvif;
> +       int error;
> +
> +       /* We do not enter elp sleep in PLT mode */
> +       if (wl->plt)
> +               return -EINVAL;
> +
> +       /* Nothing to do if no ELP mode requested */
> +       if (wl->sleep_auth != WL1271_PSM_ELP)
> +               return 0;
> +
> +       wl12xx_for_each_wlvif(wl, wlvif) {
> +               if (!test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags) &&
> +                   test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
> +                       return -EBUSY;
> +       }
> +
> +       wl1271_debug(DEBUG_PSM, "chip to elp");
> +       error = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP);
> +       if (error < 0) {
> +               wl12xx_queue_recovery_work(wl);
> +
> +               return error;
> +       }
> +
> +       set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
> +
> +       return 0;
> +}
> +
> +static int __maybe_unused wlcore_runtime_resume(struct device *dev)
> +{
> +       struct wl1271 *wl = dev_get_drvdata(dev);
> +       DECLARE_COMPLETION_ONSTACK(compl);
> +       unsigned long flags;
> +       int ret;
> +       unsigned long start_time = jiffies;
> +       bool pending = false;
> +
> +       /* Nothing to do if no ELP mode requested */
> +       if (!test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
> +               return 0;
> +
> +       wl1271_debug(DEBUG_PSM, "waking up chip from elp");
> +
> +       spin_lock_irqsave(&wl->wl_lock, flags);
> +       if (test_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
> +               pending = true;
> +       else
> +               wl->elp_compl = &compl;
> +       spin_unlock_irqrestore(&wl->wl_lock, flags);
> +
> +       ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
> +       if (ret < 0) {
> +               wl12xx_queue_recovery_work(wl);
> +               goto err;
> +       }
> +
> +       if (!pending) {
> +               ret = wait_for_completion_timeout(&compl,
> +                       msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
> +               if (ret == 0) {
> +                       wl1271_error("ELP wakeup timeout!");
> +                       wl12xx_queue_recovery_work(wl);
> +                       ret = -ETIMEDOUT;
> +                       goto err;
> +               }
> +       }
> +
> +       clear_bit(WL1271_FLAG_IN_ELP, &wl->flags);
> +
> +       wl1271_debug(DEBUG_PSM, "wakeup time: %u ms",
> +                    jiffies_to_msecs(jiffies - start_time));
> +       goto out;
> +
> +err:
> +       spin_lock_irqsave(&wl->wl_lock, flags);
> +       wl->elp_compl = NULL;
> +       spin_unlock_irqrestore(&wl->wl_lock, flags);
> +       return ret;
> +
> +out:
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops wlcore_pm_ops = {
> +       SET_RUNTIME_PM_OPS(wlcore_runtime_suspend,
> +                          wlcore_runtime_resume,
> +                          NULL)
> +};
> +
>  int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
>  {
>         struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
> @@ -6608,6 +6775,9 @@ int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
>                 wlcore_nvs_cb(NULL, wl);
>         }
>
> +       wl->dev->driver->pm = &wlcore_pm_ops;
> +       pm_runtime_enable(wl->dev);
> +
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(wlcore_probe);
> @@ -6617,6 +6787,9 @@ int wlcore_remove(struct platform_device *pdev)
>         struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
>         struct wl1271 *wl = platform_get_drvdata(pdev);
>
> +       pm_runtime_disable(wl->dev);
> +       wl->dev->driver->pm = NULL;
> +
>         if (pdev_data->family && pdev_data->family->nvs_name)
>                 wait_for_completion(&wl->nvs_loading_complete);
>         if (!wl->initialized)
> diff --git a/drivers/net/wireless/ti/wlcore/ps.c b/drivers/net/wireless/ti/wlcore/ps.c
> --- a/drivers/net/wireless/ti/wlcore/ps.c
> +++ b/drivers/net/wireless/ti/wlcore/ps.c
> @@ -26,152 +26,6 @@
>  #include "tx.h"
>  #include "debug.h"
>
> -#define WL1271_WAKEUP_TIMEOUT 500
> -
> -#define ELP_ENTRY_DELAY  30
> -#define ELP_ENTRY_DELAY_FORCE_PS  5
> -
> -void wl1271_elp_work(struct work_struct *work)
> -{
> -       struct delayed_work *dwork;
> -       struct wl1271 *wl;
> -       struct wl12xx_vif *wlvif;
> -       int ret;
> -
> -       dwork = to_delayed_work(work);
> -       wl = container_of(dwork, struct wl1271, elp_work);
> -
> -       wl1271_debug(DEBUG_PSM, "elp work");
> -
> -       mutex_lock(&wl->mutex);
> -
> -       if (unlikely(wl->state != WLCORE_STATE_ON))
> -               goto out;
> -
> -       /* our work might have been already cancelled */
> -       if (unlikely(!test_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags)))
> -               goto out;
> -
> -       if (test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
> -               goto out;
> -
> -       wl12xx_for_each_wlvif(wl, wlvif) {
> -               if (!test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags) &&
> -                   test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
> -                       goto out;
> -       }
> -
> -       wl1271_debug(DEBUG_PSM, "chip to elp");
> -       ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP);
> -       if (ret < 0) {
> -               wl12xx_queue_recovery_work(wl);
> -               goto out;
> -       }
> -
> -       set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
> -
> -out:
> -       mutex_unlock(&wl->mutex);
> -}
> -
> -/* Routines to toggle sleep mode while in ELP */
> -void wl1271_ps_elp_sleep(struct wl1271 *wl)
> -{
> -       struct wl12xx_vif *wlvif;
> -       u32 timeout;
> -
> -       /* We do not enter elp sleep in PLT mode */
> -       if (wl->plt)
> -               return;
> -
> -       if (wl->sleep_auth != WL1271_PSM_ELP)
> -               return;
> -
> -       /* we shouldn't get consecutive sleep requests */
> -       if (WARN_ON(test_and_set_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags)))
> -               return;
> -
> -       wl12xx_for_each_wlvif(wl, wlvif) {
> -               if (!test_bit(WLVIF_FLAG_IN_PS, &wlvif->flags) &&
> -                   test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
> -                       return;
> -       }
> -
> -       timeout = wl->conf.conn.forced_ps ?
> -                       ELP_ENTRY_DELAY_FORCE_PS : ELP_ENTRY_DELAY;
> -       ieee80211_queue_delayed_work(wl->hw, &wl->elp_work,
> -                                    msecs_to_jiffies(timeout));
> -}
> -EXPORT_SYMBOL_GPL(wl1271_ps_elp_sleep);
> -
> -int wl1271_ps_elp_wakeup(struct wl1271 *wl)
> -{
> -       DECLARE_COMPLETION_ONSTACK(compl);
> -       unsigned long flags;
> -       int ret;
> -       unsigned long start_time = jiffies;
> -       bool pending = false;
> -
> -       /*
> -        * we might try to wake up even if we didn't go to sleep
> -        * before (e.g. on boot)
> -        */
> -       if (!test_and_clear_bit(WL1271_FLAG_ELP_REQUESTED, &wl->flags))
> -               return 0;
> -
> -       /* don't cancel_sync as it might contend for a mutex and deadlock */
> -       cancel_delayed_work(&wl->elp_work);
> -
> -       if (!test_bit(WL1271_FLAG_IN_ELP, &wl->flags))
> -               return 0;
> -
> -       wl1271_debug(DEBUG_PSM, "waking up chip from elp");
> -
> -       /*
> -        * The spinlock is required here to synchronize both the work and
> -        * the completion variable in one entity.
> -        */
> -       spin_lock_irqsave(&wl->wl_lock, flags);
> -       if (test_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags))
> -               pending = true;
> -       else
> -               wl->elp_compl = &compl;
> -       spin_unlock_irqrestore(&wl->wl_lock, flags);
> -
> -       ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
> -       if (ret < 0) {
> -               wl12xx_queue_recovery_work(wl);
> -               goto err;
> -       }
> -
> -       if (!pending) {
> -               ret = wait_for_completion_timeout(
> -                       &compl, msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
> -               if (ret == 0) {
> -                       wl1271_error("ELP wakeup timeout!");
> -                       wl12xx_queue_recovery_work(wl);
> -                       ret = -ETIMEDOUT;
> -                       goto err;
> -               }
> -       }
> -
> -       clear_bit(WL1271_FLAG_IN_ELP, &wl->flags);
> -
> -       wl1271_debug(DEBUG_PSM, "wakeup time: %u ms",
> -                    jiffies_to_msecs(jiffies - start_time));
> -       goto out;
> -
> -err:
> -       spin_lock_irqsave(&wl->wl_lock, flags);
> -       wl->elp_compl = NULL;
> -       spin_unlock_irqrestore(&wl->wl_lock, flags);
> -       return ret;
> -
> -out:
> -       return 0;
> -}
> -EXPORT_SYMBOL_GPL(wl1271_ps_elp_wakeup);
> -
>  int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>                        enum wl1271_cmd_ps_mode mode)
>  {
> diff --git a/drivers/net/wireless/ti/wlcore/ps.h b/drivers/net/wireless/ti/wlcore/ps.h
> --- a/drivers/net/wireless/ti/wlcore/ps.h
> +++ b/drivers/net/wireless/ti/wlcore/ps.h
> @@ -29,9 +29,6 @@
>
>  int wl1271_ps_set_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>                        enum wl1271_cmd_ps_mode mode);
> -void wl1271_ps_elp_sleep(struct wl1271 *wl);
> -int wl1271_ps_elp_wakeup(struct wl1271 *wl);
> -void wl1271_elp_work(struct work_struct *work);
>  void wl12xx_ps_link_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
>                           u8 hlid, bool clean_queues);
>  void wl12xx_ps_link_end(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
> diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
> --- a/drivers/net/wireless/ti/wlcore/scan.c
> +++ b/drivers/net/wireless/ti/wlcore/scan.c
> @@ -22,6 +22,7 @@
>   */
>
>  #include <linux/ieee80211.h>
> +#include <linux/pm_runtime.h>
>
>  #include "wlcore.h"
>  #include "debug.h"
> @@ -67,16 +68,18 @@ void wl1271_scan_complete_work(struct work_struct *work)
>         wl->scan.req = NULL;
>         wl->scan_wlvif = NULL;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags)) {
>                 /* restore hardware connection monitoring template */
>                 wl1271_cmd_build_ap_probe_req(wl, wlvif, wlvif->probereq);
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>         if (wl->scan.failed) {
>                 wl1271_info("Scan completed due to error.");
> diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
> --- a/drivers/net/wireless/ti/wlcore/sysfs.c
> +++ b/drivers/net/wireless/ti/wlcore/sysfs.c
> @@ -19,6 +19,8 @@
>   *
>   */
>
> +#include <linux/pm_runtime.h>
> +
>  #include "wlcore.h"
>  #include "debug.h"
>  #include "ps.h"
> @@ -68,12 +70,14 @@ static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
>         if (unlikely(wl->state != WLCORE_STATE_ON))
>                 goto out;
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         wl1271_acx_sg_enable(wl, wl->sg_enabled);
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>
>   out:
>         mutex_unlock(&wl->mutex);
> diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
> --- a/drivers/net/wireless/ti/wlcore/testmode.c
> +++ b/drivers/net/wireless/ti/wlcore/testmode.c
> @@ -22,6 +22,7 @@
>   */
>  #include "testmode.h"
>
> +#include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <net/genetlink.h>
>
> @@ -97,9 +98,11 @@ static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wl1271_cmd_test(wl, buf, buf_len, answer);
>         if (ret < 0) {
> @@ -141,7 +144,7 @@ static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
>         }
>
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -169,9 +172,11 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>         if (!cmd) {
> @@ -205,7 +210,7 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
>  out_free:
>         kfree(cmd);
>  out_sleep:
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
> --- a/drivers/net/wireless/ti/wlcore/tx.c
> +++ b/drivers/net/wireless/ti/wlcore/tx.c
> @@ -24,6 +24,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/etherdevice.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/spinlock.h>
>
>  #include "wlcore.h"
> @@ -868,9 +869,11 @@ void wl1271_tx_work(struct work_struct *work)
>         int ret;
>
>         mutex_lock(&wl->mutex);
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wlcore_tx_work_locked(wl);
>         if (ret < 0) {
> @@ -878,7 +881,7 @@ void wl1271_tx_work(struct work_struct *work)
>                 goto out;
>         }
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>  }
> diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.c b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
> --- a/drivers/net/wireless/ti/wlcore/vendor_cmd.c
> +++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
> @@ -8,6 +8,8 @@
>   * version 2 as published by the Free Software Foundation.
>   */
>
> +#include <linux/pm_runtime.h>
> +
>  #include <net/mac80211.h>
>  #include <net/netlink.h>
>
> @@ -55,14 +57,16 @@ wlcore_vendor_cmd_smart_config_start(struct wiphy *wiphy,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wlcore_smart_config_start(wl,
>                         nla_get_u32(tb[WLCORE_VENDOR_ATTR_GROUP_ID]));
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -87,13 +91,15 @@ wlcore_vendor_cmd_smart_config_stop(struct wiphy *wiphy,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wlcore_smart_config_stop(wl);
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> @@ -131,16 +137,18 @@ wlcore_vendor_cmd_smart_config_set_group_key(struct wiphy *wiphy,
>                 goto out;
>         }
>
> -       ret = wl1271_ps_elp_wakeup(wl);
> -       if (ret < 0)
> +       ret = pm_runtime_get_sync(wl->dev);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(wl->dev);
>                 goto out;
> +       }
>
>         ret = wlcore_smart_config_set_group_key(wl,
>                         nla_get_u32(tb[WLCORE_VENDOR_ATTR_GROUP_ID]),
>                         nla_len(tb[WLCORE_VENDOR_ATTR_GROUP_KEY]),
>                         nla_data(tb[WLCORE_VENDOR_ATTR_GROUP_KEY]));
>
> -       wl1271_ps_elp_sleep(wl);
> +       pm_runtime_put(wl->dev);
>  out:
>         mutex_unlock(&wl->mutex);
>
> diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
> --- a/drivers/net/wireless/ti/wlcore/wlcore.h
> +++ b/drivers/net/wireless/ti/wlcore/wlcore.h
> @@ -348,7 +348,6 @@ struct wl1271 {
>         enum nl80211_band band;
>
>         struct completion *elp_compl;
> -       struct delayed_work elp_work;
>
>         /* in dBm */
>         int power_level;
> diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
> --- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
> +++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
> @@ -233,7 +233,6 @@ enum wl12xx_flags {
>         WL1271_FLAG_TX_QUEUE_STOPPED,
>         WL1271_FLAG_TX_PENDING,
>         WL1271_FLAG_IN_ELP,
> -       WL1271_FLAG_ELP_REQUESTED,
>         WL1271_FLAG_IRQ_RUNNING,
>         WL1271_FLAG_FW_TX_BUSY,
>         WL1271_FLAG_DUMMY_PACKET_PENDING,
> --
> 2.17.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
| Michael Nazzareno Trimarchi                     Amarula Solutions BV |
| COO  -  Founder                                      Cruquiuskade 47 |
| +31(0)851119172                                 Amsterdam 1018 AM NL |
|                  [`as] http://www.amarulasolutions.com               |
