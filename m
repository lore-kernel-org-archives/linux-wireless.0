Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47978 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753187AbdAZJgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 04:36:54 -0500
Message-ID: <1485423406.11038.6.camel@sipsolutions.net> (sfid-20170126_103659_082067_F2FFC141)
Subject: Re: [RFC 2/3] cfg80211: Disallow moving out of operating DFS
 channel in non-ETSI
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Jan 2017 10:36:46 +0100
In-Reply-To: <1485343870-23601-3-git-send-email-vthiagar@qti.qualcomm.com>
References: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1485343870-23601-3-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static bool cfg80211_off_channel_oper_allowed(struct wireless_dev
> *wdev)
> +{
> +	if (!cfg80211_beaconing_iface_active(wdev))
> +		return true;
> +
> +	if (!(wdev->chandef.chan->flags & IEEE80211_CHAN_RADAR))
> +		return true;

That could use some locking assertions. Maybe also in the
cfg80211_beaconing_iface_active() function you introduced in the
previous patch.

> +	if (!cfg80211_off_channel_oper_allowed(wdev)) {
> +		struct ieee80211_channel *chan;
> +
> +		if (request->n_channels != 1) {
> +			err = -EBUSY;
> +			goto out_free;
> +		}
> +
> +		chan = request->channels[0];
> +		if (chan->center_freq != wdev->chandef.chan-
> >center_freq) {
> +			err = -EBUSY;
> +			goto out_free;
> +		}
> +	}

I'm not convinced you even hold the relevant locks here, though off the
top of my head I'm not even sure which are needed.

>  	i = 0;
>  	if (n_ssids) {
>  		nla_for_each_nested(attr, info-
> >attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
> @@ -9053,6 +9079,7 @@ static int nl80211_remain_on_channel(struct
> sk_buff *skb,
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>  	struct wireless_dev *wdev = info->user_ptr[1];
>  	struct cfg80211_chan_def chandef;
> +	const struct cfg80211_chan_def *compat_chandef;
>  	struct sk_buff *msg;
>  	void *hdr;
>  	u64 cookie;
> @@ -9081,6 +9108,14 @@ static int nl80211_remain_on_channel(struct
> sk_buff *skb,
>  	if (err)
>  		return err;
>  
> +	if (!(cfg80211_off_channel_oper_allowed(wdev) ||
> +	      cfg80211_chandef_identical(&wdev->chandef, &chandef)))

I'd prefer to write that as !off_channel && !chandef_identical, seems
easier to understand here.

johannes
