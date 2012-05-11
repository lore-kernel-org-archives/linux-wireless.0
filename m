Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:55484 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760013Ab2EKGgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 02:36:44 -0400
Message-ID: <4FACB379.2000001@tieto.com> (sfid-20120511_083741_390204_42093D07)
Date: Fri, 11 May 2012 08:36:41 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/2] mac80211: move ieee80211_set_channel function
References: <20120510203021.240931880@sipsolutions.net> <20120510203304.679354639@sipsolutions.net>
In-Reply-To: <20120510203304.679354639@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> +static int ieee80211_set_channel(struct wiphy *wiphy,
> +				 struct net_device *netdev,
> +				 struct ieee80211_channel *chan,
> +				 enum nl80211_channel_type channel_type)
> +{
> +	struct ieee80211_local *local = wiphy_priv(wiphy);
> +	struct ieee80211_sub_if_data *sdata = NULL;
> +
> +	if (netdev)
> +		sdata = IEEE80211_DEV_TO_SUB_IF(netdev);
> +
> +	switch (ieee80211_get_channel_mode(local, NULL)) {
> +	case CHAN_MODE_HOPPING:
> +		return -EBUSY;
> +	case CHAN_MODE_FIXED:
> +		if (local->oper_channel != chan)
> +			return -EBUSY;


> +		if (!sdata&&  local->_oper_channel_type == channel_type)
> +			return 0;

Do we need to keep this part? If not we could remove it in your:
   [RFC] mac80211: clean up ieee80211_set_channel


I think we could even remove the whole `ieee80211_get_channel_mode` 
thing now since we enforce interface combinations, right? We just need 
to adjust the interface combinations verification to refuse mixing ibss 
with anything else for the moment. That shouldn't be bad, or is it?


-- 
Pozdrawiam / Best regards, Michal Kazior.
