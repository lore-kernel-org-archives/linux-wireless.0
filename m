Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab1GTQAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 12:00:09 -0400
Subject: RE: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Daniel Drake <dsd@laptop.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Wed, 20 Jul 2011 11:03:49 -0500
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FFBB25D6@SC-VEXCH1.marvell.com>
References: <20110717170310.CAD139D401C@zog.reactivated.net>
	 <477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com>
	 <CAGq3pz6DbsHG9JY8oZqaeRp4=EC1-sKunSuF2Q1+tfBoYbcyLg@mail.gmail.com>
	 <477F20668A386D41ADCC57781B1F704307FFBB244E@SC-VEXCH1.marvell.com>
	 <CAGq3pz4cTSZj+_MwJrxG=Ri1zELKbx2i9Hz==3_=t+aho_Y+Xg@mail.gmail.com>
	 <477F20668A386D41ADCC57781B1F704307FFBB25D6@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1311177831.21004.0.camel@dcbw.foobar.com> (sfid-20110720_180013_988599_D37EE115)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-19 at 19:33 -0700, Bing Zhao wrote:
> Hi Daniel,
> 
> > > To enable deep sleep mode:
> > > iwconfig wlan0 power period 0
> > >
> > > To enable auto deep sleep mode with idle time period set to 5 seconds:
> > > iwconfig wlan0 power period 5
> > >
> > > To disable deep sleep/auto deep sleep mode:
> > > iwconfig wlan0 power period -1
> > 
> > Paul pointed out that indeed, in old kernels, this functionality was
> > hooked up to the power wireless extension.
> > 
> > In recent kernels, this is not the case - its not hooked up to
> > anything. The commands you write above will fail.
> 
> Yeah. I didn't know that the entire wext has been removed from libertas.
> 
> Anyway, for users who need this feature we can add a module parameter to enable it with the patch below. Please let me know what you think.

I'd rather we figure out some nl80211/cfg80211 knob for this rather than
a module parameter; we can certainly add calls and attributes to nl80211
if we need to.

Dan

> Thanks,
> Bing
> 
> ---
> drivers/net/wireless/libertas/dev.h  |    2 +-
>  drivers/net/wireless/libertas/main.c |   50 +++++++++++++++-------------------
>  2 files changed, 23 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index 76d018b..472a5e3 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -77,7 +77,7 @@ struct lbs_private {
>  	int is_auto_deep_sleep_enabled;
>  	int wakeup_dev_required;
>  	int is_activity_detected;
> -	int auto_deep_sleep_timeout; /* in ms */
> +	int auto_deep_sleep_timeout; /* in seconds */
>  	wait_queue_head_t ds_awake_q;
>  	struct timer_list auto_deepsleep_timer;
>  
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index a839de0..cc8c1b5 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -40,6 +40,11 @@ unsigned int lbs_disablemesh;
>  EXPORT_SYMBOL_GPL(lbs_disablemesh);
>  module_param_named(libertas_disablemesh, lbs_disablemesh, int, 0644);
>  
> +static unsigned int lbs_auto_deep_sleep;	/* in seconds */
> +module_param_named(libertas_auto_deep_sleep, lbs_auto_deep_sleep, int, 0644);
> +MODULE_PARM_DESC(libertas_auto_deep_sleep,
> +		"timeout value for auto deep sleep timer (default 0: disabled");
> +
>  
>  /*
>   * This global structure is used to send the confirm_sleep command as
> @@ -680,36 +685,10 @@ static void auto_deepsleep_timer_fn(unsigned long data)
>  		}
>  	}
>  	mod_timer(&priv->auto_deepsleep_timer , jiffies +
> -				(priv->auto_deep_sleep_timeout * HZ)/1000);
> +					priv->auto_deep_sleep_timeout * HZ);
>  	lbs_deb_leave(LBS_DEB_CMD);
>  }
>  
> -int lbs_enter_auto_deep_sleep(struct lbs_private *priv)
> -{
> -	lbs_deb_enter(LBS_DEB_SDIO);
> -
> -	priv->is_auto_deep_sleep_enabled = 1;
> -	if (priv->is_deep_sleep)
> -		priv->wakeup_dev_required = 1;
> -	mod_timer(&priv->auto_deepsleep_timer ,
> -			jiffies + (priv->auto_deep_sleep_timeout * HZ)/1000);
> -
> -	lbs_deb_leave(LBS_DEB_SDIO);
> -	return 0;
> -}
> -
> -int lbs_exit_auto_deep_sleep(struct lbs_private *priv)
> -{
> -	lbs_deb_enter(LBS_DEB_SDIO);
> -
> -	priv->is_auto_deep_sleep_enabled = 0;
> -	priv->auto_deep_sleep_timeout = 0;
> -	del_timer(&priv->auto_deepsleep_timer);
> -
> -	lbs_deb_leave(LBS_DEB_SDIO);
> -	return 0;
> -}
> -
>  static int lbs_init_adapter(struct lbs_private *priv)
>  {
>  	int ret;
> @@ -725,7 +704,15 @@ static int lbs_init_adapter(struct lbs_private *priv)
>  	priv->psmode = LBS802_11POWERMODECAM;
>  	priv->psstate = PS_STATE_FULL_POWER;
>  	priv->is_deep_sleep = 0;
> -	priv->is_auto_deep_sleep_enabled = 0;
> +
> +	if (lbs_auto_deep_sleep > 0) {
> +		priv->is_auto_deep_sleep_enabled = 1;
> +		priv->auto_deep_sleep_timeout = lbs_auto_deep_sleep;
> +	} else {
> +		priv->is_auto_deep_sleep_enabled = 0;
> +		priv->auto_deep_sleep_timeout = 0;
> +	}
> +
>  	priv->deep_sleep_required = 0;
>  	priv->wakeup_dev_required = 0;
>  	init_waitqueue_head(&priv->ds_awake_q);
> @@ -963,6 +950,13 @@ int lbs_start_card(struct lbs_private *priv)
>  
>  	lbs_debugfs_init_one(priv, dev);
>  
> +	/* Start the timer if auto deep sleep is enabled */
> +	if (priv->is_auto_deep_sleep_enabled && priv->auto_deep_sleep_timeout) {
> +		priv->is_activity_detected = 0;
> +		mod_timer(&priv->auto_deepsleep_timer,
> +			jiffies + priv->auto_deep_sleep_timeout * HZ);
> +	}
> +
>  	netdev_info(dev, "Marvell WLAN 802.11 adapter\n");
>  
>  	ret = 0;
> ---
> 


