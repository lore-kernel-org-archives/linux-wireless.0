Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3APW7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:59:19 -0500
Message-ID: <1358377171.15012.45.camel@jlt4.sipsolutions.net> (sfid-20130116_235922_677410_3F3A0B92)
Subject: Re: [PATCHv6 4/6] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 16 Jan 2013 23:59:31 +0100
In-Reply-To: <1357650251-17425-5-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357650251-17425-5-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:

> +static int ieee80211_start_radar_detection(struct wiphy *wiphy,
> +					   struct net_device *dev,
> +					   struct cfg80211_chan_def *chandef)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = sdata->local;
> +	int res;
> +
> +	if (!local->ops->start_radar_detection)
> +		return -EOPNOTSUPP;
> +
> +	/* whatever, but channel contexts should not complain about that one */
> +	sdata->smps_mode = IEEE80211_SMPS_OFF;
> +	sdata->needed_rx_chains = local->rx_chains;
> +
> +	if (ieee80211_vif_use_channel(sdata, chandef,
> +				      IEEE80211_CHANCTX_SHARED))
> +		return -EBUSY;

Should probably return whatever error vif_use_channel() returned?

> +	res = drv_start_radar_detection(local, sdata, chandef);

If the vif is assigned the channel, why also pass it to the
start_radar_detection command? That seems pointless, they can't be
different?


> +++ b/net/mac80211/iface.c
> @@ -826,6 +826,10 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
>  					 u.vlan.list)
>  			dev_close(vlan->dev);
>  		WARN_ON(!list_empty(&sdata->u.ap.vlans));
> +
> +		/* reset DFS channel availability check */
> +		if (local->_oper_channel)
> +			local->_oper_channel->cac_started = false;

That doesn't really belong here, does it? Seems like it should be in
cfg80211. Actually, should it be there at all?

If we allow using the channel for some amount of time after doing the
CAC, even if we haven't been on the channel continuously, then we should
also allow using the channel after stopping the AP for that much time.

IOW -- deactivating should cause the timeout to start running.

Actually that raises another question: If we have "external" radar
detection, say by a different NIC, then shouldn't we still ask the
driver to start radar detection when using the channel? Or is that
implicit, does the driver have to check?

It seems the driver API needs a lot more documentation :-)


> +++ b/net/mac80211/trace.h
> @@ -45,6 +45,35 @@
>  			__entry->center_freq1, __entry->center_freq2,		\
>  			__entry->rx_chains_static, __entry->rx_chains_dynamic
>  
> +#define CHAN_DEF_ENTRY __field(enum ieee80211_band, band)		\

I'll apply my "mac80211: split out chandef tracing macros" patch
instead.


Also: once the CAC is completed, shouldn't the channel context be freed
up in mac80211, or something like that?

johannes

