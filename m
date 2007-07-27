Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mi1.bluebottle.com ([206.188.25.14]:46364 "EHLO
	mi1.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbXG0Geo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 02:34:44 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by mi1.bluebottle.com (8.13.1/8.13.1) with ESMTP id l6R6Yh2j003295
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 23:34:43 -0700
Message-Id: <200707270634.l6R6Yh2j003295@mi1.bluebottle.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Axj <axjslack@bluebottle.com>, linux-wireless@vger.kernel.org
Date: Thu, 26 Jul 2007 23:34:40 -0700
From: Axj <axjslack@bluebottle.com>
Subject: Re: Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com>  <1185355931.3131.13.camel@debian.sh.intel.com>  <200707261511.l6QFB2jK015121@mi0.bluebottle.com> <1185466954.14557.5.camel@dv>
In-Reply-To: <1185466954.14557.5.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've tried the driver 0.1.4 with the new (not so new) linux kernel 2.6.22.1 (against the 2.6.21.5 installed on Slackware 12, and it work without any patch. In fact,  at the moment of compiling kernel the mac80211 subsystem is already in..... now it works (even if no led and no Ad-Hoc). I really don't try 1.0.0. I will do it. Maybe the fact of the led in only because I don't pass the right option to the modprobe (in ipw2200 was "modprobe ipw2200 led=1") but here is not. For the Ad-Hoc, i try to take a look in source, but maybe isn't present this part or I don't find. 

By the way, thank you for the advice and suggestions  


Quoting Pavel Roskin <proski@gnu.org>:

I


> On Thu, 2007-07-26 at 08:10 -0700, Axj wrote:
> 
> > I  saw onother exit of thje driver, 1.0.0, but I don't trust so
> much
> > (at the momente the compination of mac80211 ver 8.0.2 and
> > iwlwifi-0.0.42 work, even if the led doesn't work ad It's
> impossible
> > to set an "Ad-Hoc" connection. )
> 
> Actually, it's direct continuation of the 0.0.x series.  It's
> unfortunate that the complexity of the build system makes you
> mistrust
> the recent code, although I can relate.  I hope it will be
> remedied
> quickly.
> 
> It's possible to compile the 1.0.x driver against recent unpatched
> kernels, even against the standard Fedora 7 kernel, by stripping
> support
> for Intel's rate control algorithm:
> 
> diff --git a/origin/Makefile b/origin/Makefile
> index 8c0bdc7..c5d966f 100644
> --- a/origin/Makefile
> +++ b/origin/Makefile
> @@ -10,7 +10,7 @@
>  # -jpk
>  
>  obj-$(CONFIG_IWL3945)	+= iwl3945.o
> -iwl3945-objs		= base-3945.o iwl-3945.o iwl-3945-rs.o
> +iwl3945-objs		= base-3945.o iwl-3945.o
>  CFLAGS_iwl-3945.o	= -DIWL=3945
>  CFLAGS_iwl-3945-rs.o	= -DIWL=3945
>  CFLAGS_base-3945.o	= -DIWL=3945
> -D"KBUILD_MODNAME=KBUILD_STR(iwl3945)"
> @@ -19,7 +19,7 @@ $(obj)/base-3945.o: $(src)/base.c FORCE
>  	$(call if_changed_rule,cc_o_c)
>  
>  obj-$(CONFIG_IWL4965)	+= iwl4965.o
> -iwl4965-objs		= base-4965.o iwl-4965.o iwl-4965-rs.o
> +iwl4965-objs		= base-4965.o iwl-4965.o
>  CFLAGS_iwl-4965.o	= -DIWL=4965
>  CFLAGS_iwl-4965-rs.o	= -DIWL=4965
>  CFLAGS_base-4965.o	= -DIWL=4965
> -D"KBUILD_MODNAME=KBUILD_STR(iwl4965)"
> diff --git a/origin/base.c b/origin/base.c
> index eda467e..ee6ac8f 100644
> --- a/origin/base.c
> +++ b/origin/base.c
> @@ -6284,7 +6284,6 @@ static void iwl_alive_start(struct iwl_priv
> *priv)
>  		/* Unlock so any user space entry points can call back into
>  		 * the driver without a deadlock... */
>  		mutex_unlock(&priv->mutex);
> -		iwl_rate_control_register();
>  		rc = ieee80211_register_hw(priv->hw);
>  		priv->hw->conf.beacon_int = 100;
>  		mutex_lock(&priv->mutex);
> @@ -6950,7 +6949,6 @@ static void iwl_bg_post_associate(struct
> work_struct *data)
>  				  (priv->phymode == MODE_ATHEROS_TURBO)) ?
>  				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
>  				 CMD_ASYNC);
> -		iwl_rate_scale_init(priv->hw, IWL_AP_ID);
>  
>  		break;
>  
> @@ -6967,7 +6965,6 @@ static void iwl_bg_post_associate(struct
> work_struct *data)
>  				  (priv->phymode == MODE_ATHEROS_TURBO)) ?
>  				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
>  				 CMD_ASYNC);
> -		iwl_rate_scale_init(priv->hw, IWL_STA_ID);
>  		iwl_send_beacon_cmd(priv);
>  
>  		break;
> @@ -7915,8 +7912,7 @@ static ssize_t show_rs_window(struct device
> *d,
>  			      struct device_attribute *attr,
>  			      char *buf)
>  {
> -	struct iwl_priv *priv = d->driver_data;
> -	return iwl_fill_rs_info(priv->hw, buf, IWL_AP_ID);
> +	return 0;
>  }
>  static DEVICE_ATTR(rs_window, S_IRUGO, show_rs_window, NULL);
>  
> @@ -8851,7 +8847,6 @@ static void iwl_pci_remove(struct pci_dev
> *pdev)
>  
>  	if (priv->mac80211_registered) {
>  		ieee80211_unregister_hw(priv->hw);
> -		iwl_rate_control_unregister();
>  	}
>  
>  	/* ieee80211_unregister_hw calls d_stop, which flushes
> 
> 
> -- 
> Regards,
> Pavel Roskin
> 
>

----------------------------------------------------------------------
Finally - A spam blocker that actually works.
http://www.bluebottle.com/tag/4

