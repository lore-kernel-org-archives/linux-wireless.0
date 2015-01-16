Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41230 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbbAPKtd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:49:33 -0500
Message-ID: <1421405364.9214.1.camel@sipsolutions.net> (sfid-20150116_114936_093335_F7E171BE)
Subject: Re: [RFCv2 1/6] mac80211: ibss, fix chandef setup for HT40
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Jan 2015 11:49:24 +0100
In-Reply-To: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_113940_469889_05CC4050)
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150116_113940_469889_05CC4050)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-16 at 11:38 +0100, Janusz Dziedzic wrote:
> In some cases when used HT40+/HT40-, center_freq1
> was configured incorrectly. Next this couse

couse?

> @@ -407,10 +407,15 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  	switch (sdata->u.ibss.chandef.width) {
>  	case NL80211_CHAN_WIDTH_20_NOHT:
>  	case NL80211_CHAN_WIDTH_20:
> -	case NL80211_CHAN_WIDTH_40:
>  		chan_type = cfg80211_get_chandef_type(&sdata->u.ibss.chandef);
>  		cfg80211_chandef_create(&chandef, cbss->channel, chan_type);
>  		break;

Sorry, I don't see the bug. "Sometimes"?

cfg80211_get_chandef_type() will return HT40+/- correctly according to
the chandef, and then you'll use it again to create the chandef - should be OK.

> +       case NL80211_CHAN_WIDTH_40:
> +               cfg80211_chandef_create(&chandef, cbss->channel,
> +                                       NL80211_CHAN_WIDTH_20_NOHT);
> +               chandef.width = sdata->u.ibss.chandef.width;
> +               chandef.center_freq1 =
> sdata->u.ibss.chandef.center_freq1;
> +               break;

Please don't mix chantype stuff and chandef stuff ... just create the
chandef manually if you must. I really think the code above should have
worked though, unless it's using the wrong inputs somehow.

johannes


