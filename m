Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:26261 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYIYVK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 17:10:26 -0400
Received: by nf-out-0910.google.com with SMTP id d3so259808nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 14:10:24 -0700 (PDT)
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH RFC] mac80211: notify mac80211 about rfkill events
Date: Thu, 25 Sep 2008 23:10:21 +0200
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, hmh@hmh.eng.br, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
References: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809252310.21320.IvDoorn@gmail.com> (sfid-20080925_231030_659935_3804C101)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Currently mac80211 is not notified about rfill state of low level driver
> and doesn't now when it's disconnected and when to restart connection
> There also there is conflict or no synchronization between 'wext txpower
> disable' and rfkill events coming from rfkill subsystem
> 
> This patch is just a sketch of possible solution, it probably even doesn't
> compile

I am not sure if registring a notifier would be the best solution,
persionally I was thinking of implementing the rfkill structure into ieee80211_local
and make it listen to events directly.

Through a small callback function drivers can easily report their rfkill events
to mac80211 which in turn will call rfkill_force_state().

On the other hand, perhaps notifications might work better, depends on what
the drivers like better.

> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/main.c |   34 ++++++++++++++++++++++++++++++++++
>  net/mac80211/wext.c |   18 +++++++++++++++---
>  2 files changed, 49 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index d608c44..df2dd7d 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -21,6 +21,7 @@
>  #include <linux/wireless.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/bitmap.h>
> +#include <linux/rfkill.h>
>  #include <net/net_namespace.h>
>  #include <net/cfg80211.h>
>  
> @@ -704,6 +705,33 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL(ieee80211_tx_status);
>  
> +static int ieee80211_rfkill_notifier(struct notifier_block *nb, unsigned long eventid,
> +					void *data)
> +{
> +	struct rfkill *rfkill = (struct rfkill *)data;
> +	struct ieee80211_hw *hw = rfkill->data;
> +	struct ieee80211_local *local = hw_to_local(hw);
> +
> +	switch (eventid) {
> +	case RFKILL_STATE_CHANGED:
> +		hw->conf.radio_enabled =
> +			(rfkill->state == RFKILL_STATE_UNBLOCKED);
> +		printk(KERN_DEBUG "%s %d RADIO %d\n", __func__, __LINE__, hw->conf.radio_enabled);
> +		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
> +		ieee80211_hw_config(local);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +struct notifier_block ieee80211_rfkill_notifier_nb = {
> +	.notifier_call	= ieee80211_rfkill_notifier,
> +	.priority	= 0,
> +};
> +
>  struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
>  					const struct ieee80211_ops *ops)
>  {
> @@ -932,6 +960,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>  
>  	ieee80211_led_init(local);
>  
> +	if (local->hw.rfkill)
> +		register_rfkill_notifier(&ieee80211_rfkill_notifier_nb);
> +
>  	return 0;
>  
>  fail_wep:
> @@ -961,6 +992,9 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
>  	tasklet_kill(&local->tx_pending_tasklet);
>  	tasklet_kill(&local->tasklet);
>  
> +	if (local->hw.rfkill)
> +		unregister_rfkill_notifier(&ieee80211_rfkill_notifier_nb);
> +
>  	rtnl_lock();
>  
>  	/*
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 7e0d53a..6b96edf 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -16,6 +16,7 @@
>  #include <linux/etherdevice.h>
>  #include <linux/if_arp.h>
>  #include <linux/wireless.h>
> +#include <linux/rfkill.h>
>  #include <net/iw_handler.h>
>  #include <asm/uaccess.h>
>  
> @@ -684,9 +685,20 @@ static int ieee80211_ioctl_siwtxpower(struct net_device *dev,
>  	}
>  
>  	if (local->hw.conf.radio_enabled != !(data->txpower.disabled)) {
> -		local->hw.conf.radio_enabled = !(data->txpower.disabled);
> -		need_reconfig = 1;
> -		ieee80211_led_radio(local, local->hw.conf.radio_enabled);
> +		if (!local->hw.rfkill) {
> +			local->hw.conf.radio_enabled = !(data->txpower.disabled);
> +			need_reconfig = 1;
> +			ieee80211_led_radio(local, local->hw.conf.radio_enabled);
> +		} else {
> +			if (data->txpower.disabled)
> +				rfkill_force_state(local->hw.rfkill,
> +					RFKILL_STATE_SOFT_BLOCKED);

As mentioned in a discussion on the list a few days ago, SOFT_BLOCKED
is not for 'iwconfig txpower off' commands or any other commands coming
from userspace. Those are not HW triggered rfkill events.

That means that the only change needed in ieee80211_ioctl_siwtxpower() is
only allowing the enabling of the radio when RFKILL is not set to BLOCKED.

> +			else
> +				/* XXXX: do we make sure there is no HW RFKILL? */
> +				rfkill_force_state(local->hw.rfkill,
> +					RFKILL_STATE_UNBLOCKED);
> +		}
> +		return 0;
>  	}
>  
>  	if (need_reconfig) {

Ivo
