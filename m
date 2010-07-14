Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:29996 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753129Ab0GNBet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 21:34:49 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0439301286
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 10:34:47 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/2] ath5k: move reset to mac80211 workqueue
Date: Wed, 14 Jul 2010 10:35:43 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com
References: <1279035161-10802-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1279035161-10802-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201007141035.43330.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed July 14 2010 00:32:40 Bob Copeland wrote:
> We currently trigger a reset via a tasklet when certain error
> conditions are detected so that the card will (eventually)
> restart.  Unfortunately this makes locking complicated since
> reset can also be called in process context (e.g. for channel
> change).  Currently nothing protects against concurrent resets,
> which can be the source of corruption bugs.
> 
> Reset takes too long to spinlock the whole thing, so this
> patch moves deferred resets into the mac80211 workqueue to
> enable use of sc->lock mutex.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c  |   38
> +++++++++++++++++-------------- drivers/net/wireless/ath/ath5k/base.h  |  
>  3 +-
>  drivers/net/wireless/ath/ath5k/debug.c |    2 +-
>  3 files changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index 20328bd..b290cc6 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -388,7 +388,7 @@ static int 	ath5k_init(struct ath5k_softc *sc);
>  static int 	ath5k_stop_locked(struct ath5k_softc *sc);
>  static int 	ath5k_stop_hw(struct ath5k_softc *sc);
>  static irqreturn_t ath5k_intr(int irq, void *dev_id);
> -static void 	ath5k_tasklet_reset(unsigned long data);
> +static void ath5k_reset_work(struct work_struct *work);
> 
>  static void 	ath5k_tasklet_calibrate(unsigned long data);
> 
> @@ -831,11 +831,12 @@ ath5k_attach(struct pci_dev *pdev, struct
> ieee80211_hw *hw)
> 
>  	tasklet_init(&sc->rxtq, ath5k_tasklet_rx, (unsigned long)sc);
>  	tasklet_init(&sc->txtq, ath5k_tasklet_tx, (unsigned long)sc);
> -	tasklet_init(&sc->restq, ath5k_tasklet_reset, (unsigned long)sc);
>  	tasklet_init(&sc->calib, ath5k_tasklet_calibrate, (unsigned long)sc);
>  	tasklet_init(&sc->beacontq, ath5k_tasklet_beacon, (unsigned long)sc);
>  	tasklet_init(&sc->ani_tasklet, ath5k_tasklet_ani, (unsigned long)sc);
> 
> +	INIT_WORK(&sc->reset_work, ath5k_reset_work);
> +
>  	ret = ath5k_eeprom_read_mac(ah, mac);
>  	if (ret) {
>  		ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
> @@ -2294,8 +2295,8 @@ err_unmap:
>   * frame contents are done as needed and the slot time is
>   * also adjusted based on current state.
>   *
> - * This is called from software irq context (beacontq or restq
> - * tasklets) or user context from ath5k_beacon_config.
> + * This is called from software irq context (beacontq tasklets)
> + * or user context from ath5k_beacon_config.
>   */
>  static void
>  ath5k_beacon_send(struct ath5k_softc *sc)
> @@ -2328,7 +2329,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>  				sc->bmisscount);
>  			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
>  				  "stuck beacon, resetting\n");
> -			tasklet_schedule(&sc->restq);
> +			ieee80211_queue_work(sc->hw, &sc->reset_work);
>  		}
>  		return;
>  	}
> @@ -2684,7 +2685,6 @@ ath5k_stop_hw(struct ath5k_softc *sc)
> 
>  	tasklet_kill(&sc->rxtq);
>  	tasklet_kill(&sc->txtq);
> -	tasklet_kill(&sc->restq);
>  	tasklet_kill(&sc->calib);
>  	tasklet_kill(&sc->beacontq);
>  	tasklet_kill(&sc->ani_tasklet);
> @@ -2737,7 +2737,7 @@ ath5k_intr(int irq, void *dev_id)
>  			 */
>  			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
>  				  "fatal int, resetting\n");
> -			tasklet_schedule(&sc->restq);
> +			ieee80211_queue_work(sc->hw, &sc->reset_work);
>  		} else if (unlikely(status & AR5K_INT_RXORN)) {
>  			/*
>  			 * Receive buffers are full. Either the bus is busy or
> @@ -2752,7 +2752,7 @@ ath5k_intr(int irq, void *dev_id)
>  			if (ah->ah_mac_srev < AR5K_SREV_AR5212) {
>  				ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
>  					  "rx overrun, resetting\n");
> -				tasklet_schedule(&sc->restq);
> +				ieee80211_queue_work(sc->hw, &sc->reset_work);
>  			}
>  			else
>  				tasklet_schedule(&sc->rxtq);
> @@ -2799,14 +2799,6 @@ ath5k_intr(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
> 
> -static void
> -ath5k_tasklet_reset(unsigned long data)
> -{
> -	struct ath5k_softc *sc = (void *)data;
> -
> -	ath5k_reset(sc, sc->curchan);
> -}
> -
>  /*
>   * Periodically recalibrate the PHY to account
>   * for temperature/environment changes.
> @@ -2830,7 +2822,7 @@ ath5k_tasklet_calibrate(unsigned long data)
>  		 * to load new gain values.
>  		 */
>  		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
> -		ath5k_reset(sc, sc->curchan);
> +		ieee80211_queue_work(sc->hw, &sc->reset_work);
>  	}
>  	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
>  		ATH5K_ERR(sc, "calibration of channel %u failed\n",
> @@ -2934,6 +2926,8 @@ drop_packet:
>  /*
>   * Reset the hardware.  If chan is not NULL, then also pause rx/tx
>   * and change to the given channel.
> + *
> + * This should be called with sc->lock.
>   */
>  static int
>  ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
> @@ -2990,6 +2984,16 @@ err:
>  	return ret;
>  }
> 
> +static void ath5k_reset_work(struct work_struct *work)
> +{
> +	struct ath5k_softc *sc = container_of(work, struct ath5k_softc,
> +		reset_work);
> +
> +	mutex_lock(&sc->lock);
> +	ath5k_reset(sc, sc->curchan);
> +	mutex_unlock(&sc->lock);
> +}
> +
>  static int ath5k_start(struct ieee80211_hw *hw)
>  {
>  	return ath5k_init(hw->priv);
> diff --git a/drivers/net/wireless/ath/ath5k/base.h
> b/drivers/net/wireless/ath/ath5k/base.h index 56221bc..86c90f4 100644
> --- a/drivers/net/wireless/ath/ath5k/base.h
> +++ b/drivers/net/wireless/ath/ath5k/base.h
> @@ -47,6 +47,7 @@
>  #include <linux/if_ether.h>
>  #include <linux/leds.h>
>  #include <linux/rfkill.h>
> +#include <linux/workqueue.h>
> 
>  #include "ath5k.h"
>  #include "debug.h"
> @@ -189,7 +190,7 @@ struct ath5k_softc {
>  	unsigned int		led_pin,	/* GPIO pin for driving LED */
>  				led_on;		/* pin setting for LED on */
> 
> -	struct tasklet_struct	restq;		/* reset tasklet */
> +	struct work_struct	reset_work;	/* deferred chip reset */
> 
>  	unsigned int		rxbufsize;	/* rx size based on mtu */
>  	struct list_head	rxbuf;		/* receive buffer */
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c
> b/drivers/net/wireless/ath/ath5k/debug.c index 8c63886..ebb9c23 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -279,7 +279,7 @@ static ssize_t write_file_reset(struct file *file,
>  {
>  	struct ath5k_softc *sc = file->private_data;
>  	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "debug file triggered reset\n");
> -	tasklet_schedule(&sc->restq);
> +	ieee80211_queue_work(sc->hw, &sc->reset_work);
>  	return count;
>  }

please get this into 2.6.36...

Acked-by: Bruno Randolf <br1@einfach.org>
