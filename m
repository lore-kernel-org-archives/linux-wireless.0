Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35955 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2IJLZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 07:25:00 -0400
Message-ID: <1347276337.4272.19.camel@jlt4.sipsolutions.net> (sfid-20120910_132505_386731_AD2F4B54)
Subject: Re: [PATCH v3 6/7] mac80211: add ap channel switch command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 10 Sep 2012 13:25:37 +0200
In-Reply-To: <1344426823-1795-7-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-7-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static int
> +ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
> +				struct net_device *dev,
> +				struct ieee80211_ap_ch_switch *ap_ch_switch)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = sdata->local;
> +
> +	if (!local->ops->channel_switch)
> +		return -EOPNOTSUPP;
> +
> +	if (!ap_ch_switch || !ap_ch_switch->channel)
> +		return -EINVAL;
> +
> +	drv_ap_channel_switch(local, ap_ch_switch);
> +	return 0;

errors are not possible?

> +void ieee80211_ap_ch_switch_done(struct ieee80211_vif *vif,
> +				 struct ieee80211_channel *new_channel,
> +				 enum nl80211_channel_type type)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_local *local = sdata->local;
> +
> +	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
> +		return;
> +
> +	/* update the device channel directly */
> +	mutex_lock(&local->mtx);
> +	local->oper_channel = local->hw.conf.channel = new_channel;
> +	local->_oper_channel_type = type;
> +	mutex_unlock(&local->mtx);
> +
> +	cfg80211_ch_switch_notify(sdata->dev, new_channel->center_freq, type);
> +	trace_api_ap_ch_switch_done(sdata, new_channel->center_freq);

tracing last seems very strange

johannes

