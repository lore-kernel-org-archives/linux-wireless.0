Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0057.outbound.protection.outlook.com ([104.47.42.57]:27724
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751827AbdH2OcA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 10:32:00 -0400
Date: Tue, 29 Aug 2017 17:31:47 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 02/27] qtnfmac: make "Channel change" event report full
 channel info
Message-ID: <20170829143146.ersgkofruzdpta6y@bars> (sfid-20170829_163204_748844_F8D3069A)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-3-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825023024.10565-3-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  static int
>  qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
> @@ -358,41 +359,36 @@ qtnf_event_handle_freq_change(struct qtnf_wmac *mac,
>  			      u16 len)
>  {
>  	struct wiphy *wiphy = priv_to_wiphy(mac);
> -	struct cfg80211_chan_def chandef;
> -	struct ieee80211_channel *chan;
> +	struct cfg80211_chan_def chdef;
>  	struct qtnf_vif *vif;
> -	int freq;
>  	int i;

Original variable name 'chandef' was easier to spell on the phone :)

...

> +	qlink_chandef_q2cfg(wiphy, &data->chan, &chdef);
> +
> +	if (!cfg80211_chandef_valid(&chdef)) {
> +		pr_err("MAC%u: bad channel freq1=%u bw=%u\n", mac->macid,
> +		       chdef.center_freq1, chdef.width);
>  		return -EINVAL;
>  	}

Lets keep both freq1 and freq2 in error message.

...

> +void qlink_chandef_q2cfg(struct wiphy *wiphy,
> +			 const struct qlink_chandef *qch,
> +			 struct cfg80211_chan_def *chdef)
> +{
> +	chdef->center_freq1 = le16_to_cpu(qch->center_freq1);
> +	chdef->center_freq2 = le16_to_cpu(qch->center_freq2);
> +	chdef->width = qlink_chanwidth_to_nl(qch->width);
> +
> +	switch (chdef->width) {
> +	case NL80211_CHAN_WIDTH_20_NOHT:
> +	case NL80211_CHAN_WIDTH_20:
> +	case NL80211_CHAN_WIDTH_5:
> +	case NL80211_CHAN_WIDTH_10:
> +		chdef->chan = ieee80211_get_channel(wiphy, chdef->center_freq1);
> +		break;
> +	case NL80211_CHAN_WIDTH_40:
> +	case NL80211_CHAN_WIDTH_80:
> +	case NL80211_CHAN_WIDTH_80P80:
> +	case NL80211_CHAN_WIDTH_160:
> +		chdef->chan = ieee80211_get_channel(wiphy,
> +						    chdef->center_freq1 - 10);

Do we have the same formula for 40MHz and 80MHz center frequency ?
I thought we should be using the channel number for the left-most 20MHz band.

> +		break;
> +	default:
> +		chdef->chan = NULL;
> +		break;
> +	}
> +}

Regards,
Sergey
