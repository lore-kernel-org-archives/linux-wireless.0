Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48806 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1BOQPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 11:15:31 -0500
Date: Tue, 15 Feb 2011 11:12:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [RFC] ath9k: Fix ath9k prevents CPU to enter C3 states
Message-ID: <20110215161222.GD2557@tuxdriver.com>
References: <1297785572-27955-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297785572-27955-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Despite the [RFC], I am applying this.  I should have reverted all
of this three weeks ago...

John

On Tue, Feb 15, 2011 at 09:29:32PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> The DMA latency issue is observed only in Intel pinetrail platforms but
> in the driver we had a default PM-QOS value of 55. This caused
> unnecessary power consumption and battery drain in other platforms.
> 	Remove the pm-qos thing in the driver code and address the throughput issue in
> Intel pinetrail platfroms in user space using any one of the scripts in below links:
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/cpudmalatency.c
> http://johannes.sipsolutions.net/files/netlatency.c.txt
> More details can be found in the following bugzilla link:
> https://bugzilla.kernel.org/show_bug.cgi?id=27532
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |    5 -----
>  drivers/net/wireless/ath/ath9k/init.c  |    7 -------
>  drivers/net/wireless/ath/ath9k/main.c  |    8 --------
>  3 files changed, 0 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index ba436cd..0052f64 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -21,7 +21,6 @@
>  #include <linux/device.h>
>  #include <linux/leds.h>
>  #include <linux/completion.h>
> -#include <linux/pm_qos_params.h>
>  
>  #include "debug.h"
>  #include "common.h"
> @@ -57,8 +56,6 @@ struct ath_node;
>  
>  #define A_MAX(a, b) ((a) > (b) ? (a) : (b))
>  
> -#define ATH9K_PM_QOS_DEFAULT_VALUE	55
> -
>  #define TSF_TO_TU(_h,_l) \
>  	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
>  
> @@ -650,7 +647,6 @@ struct ath_softc {
>  
>  	struct ath_ant_comb ant_comb;
>  
> -	struct pm_qos_request_list pm_qos_req;
>  };
>  
>  void ath9k_tasklet(unsigned long data);
> @@ -665,7 +661,6 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
>  extern struct ieee80211_ops ath9k_ops;
>  extern int ath9k_modparam_nohwcrypt;
>  extern int led_blink;
> -extern int ath9k_pm_qos_value;
>  extern bool is_ath9k_unloaded;
>  
>  irqreturn_t ath_isr(int irq, void *dev);
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index e5c1eea..8fed4e4 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -41,9 +41,6 @@ static int ath9k_btcoex_enable;
>  module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
>  MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
>  
> -int ath9k_pm_qos_value = ATH9K_PM_QOS_DEFAULT_VALUE;
> -module_param_named(pmqos, ath9k_pm_qos_value, int, S_IRUSR | S_IRGRP | S_IROTH);
> -MODULE_PARM_DESC(pmqos, "User specified PM-QOS value");
>  
>  bool is_ath9k_unloaded;
>  /* We use the hw_value as an index into our private channel structure */
> @@ -760,9 +757,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
>  	ath_init_leds(sc);
>  	ath_start_rfkill_poll(sc);
>  
> -	pm_qos_add_request(&sc->pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
> -			   PM_QOS_DEFAULT_VALUE);
> -
>  	return 0;
>  
>  error_world:
> @@ -819,7 +813,6 @@ void ath9k_deinit_device(struct ath_softc *sc)
>  	ath9k_ps_restore(sc);
>  
>  	ieee80211_unregister_hw(hw);
> -	pm_qos_remove_request(&sc->pm_qos_req);
>  	ath_rx_cleanup(sc);
>  	ath_tx_cleanup(sc);
>  	ath9k_deinit_softc(sc);
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 4f568b8..1d2c7c3 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1117,12 +1117,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
>  			ath9k_btcoex_timer_resume(sc);
>  	}
>  
> -	/* User has the option to provide pm-qos value as a module
> -	 * parameter rather than using the default value of
> -	 * 'ATH9K_PM_QOS_DEFAULT_VALUE'.
> -	 */
> -	pm_qos_update_request(&sc->pm_qos_req, ath9k_pm_qos_value);
> -
>  	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
>  		common->bus_ops->extn_synch_en(common);
>  
> @@ -1267,8 +1261,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
>  
>  	sc->sc_flags |= SC_OP_INVALID;
>  
> -	pm_qos_update_request(&sc->pm_qos_req, PM_QOS_DEFAULT_VALUE);
> -
>  	mutex_unlock(&sc->mutex);
>  
>  	ath_dbg(common, ATH_DBG_CONFIG, "Driver halt\n");
> -- 
> 1.7.0.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
