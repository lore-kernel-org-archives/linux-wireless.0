Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3HPKdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 06:33:18 -0400
Message-ID: <1376649188.15299.11.camel@jlt4.sipsolutions.net> (sfid-20130816_123337_020685_0D000277)
Subject: Re: [PATCHv2 4/6] mac80211: add support for CSA in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 16 Aug 2013 12:33:08 +0200
In-Reply-To: <1376058920-17779-5-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1376058920-17779-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1376058920-17779-5-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-09 at 16:35 +0200, Simon Wunderlich wrote:
> Ths

This ;-)


> +	case NL80211_IFTYPE_ADHOC:
> +		if (!sdata->vif.bss_conf.ibss_joined)
> +			return -EINVAL;
> +
> +		if (params->chandef.width != sdata->u.ibss.chandef.width)
> +			return -EINVAL;
> +
> +		switch (params->chandef.width) {
> +		case NL80211_CHAN_WIDTH_40:
> +			if (cfg80211_get_chandef_type(&params->chandef) !=
> +			    cfg80211_get_chandef_type(&sdata->u.ibss.chandef))
> +				return -EINVAL;

Is that really correct? It seems that you should be able to switch from
HT40- to HT40+ and vice versa when switching the channel?

And why disallow switching bandwidth (was above this code)? That doesn't
seem right either?

> +/* must hold sdata lock */

pretty useless comment if you have the assert in the function :)

> +	rcu_read_lock();
> +	ies = rcu_dereference(cbss->ies);
> +	tsf = ies->tsf;
> +	rcu_read_unlock();
> +	cfg80211_put_bss(sdata->local->hw.wiphy, cbss);
> +
> +	old_presp = rcu_dereference_protected(ifibss->presp,
> +					  lockdep_is_held(&sdata->wdev.mtx));
> +
> +	presp = ieee80211_ibss_build_presp(sdata,
> +					   sdata->vif.bss_conf.beacon_int,
> +					   sdata->vif.bss_conf.basic_rates,
> +					   capability, tsf, &ifibss->chandef,
> +					   NULL, csa_settings);

This is pretty odd - why does the TSF have to go here? It needs to be
set by the device when transmitting anyway, no?

> +static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
> +{

Is this some refactoring that should be separate? I don't see how it's
really related to CSA? Maybe I'm missing something?

johannes

