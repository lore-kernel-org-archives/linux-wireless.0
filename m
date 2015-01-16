Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41247 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbbAPKw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 05:52:58 -0500
Message-ID: <1421405574.9214.3.camel@sipsolutions.net> (sfid-20150116_115302_757763_79E89BF3)
Subject: Re: [RFCv2 3/6] mac80211: add VHT support for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 16 Jan 2015 11:52:54 +0100
In-Reply-To: <1421404724-32326-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150116_113937_946440_684103C4)
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1421404724-32326-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150116_113937_946440_684103C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-16 at 11:38 +0100, Janusz Dziedzic wrote:
> Add VHT80/VHT160 support for IBSS.
> Drivers could activate this feature by
> setting NL80211_FEATURE_VHT_IBSS flag.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  net/mac80211/ibss.c        | 11 +++++++++++
>  net/mac80211/ieee80211_i.h |  2 ++
>  net/mac80211/util.c        | 35 +++++++++++++++++++++++++++++++++++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 13b8105..1ffcfab 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -188,6 +188,15 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
>  		 */
>  		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
>  						 chandef, 0);
> +
> +		if (chandef->width != NL80211_CHAN_WIDTH_20 &&
> +		    chandef->width != NL80211_CHAN_WIDTH_40 &&
> +		    sband->vht_cap.vht_supported) {
> +			pos = ieee80211_ie_build_vht_cap(pos, &sband->vht_cap,
> +							 sband->vht_cap.cap);
> +			pos = ieee80211_ie_build_vht_oper(pos, &sband->vht_cap,
> +							  chandef);
> +		}
>  	}
>  
>  	if (local->hw.queues >= IEEE80211_NUM_ACS)
> @@ -411,6 +420,8 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>  		cfg80211_chandef_create(&chandef, cbss->channel, chan_type);
>  		break;
>  	case NL80211_CHAN_WIDTH_40:
> +	case NL80211_CHAN_WIDTH_80:
> +	case NL80211_CHAN_WIDTH_160:
>  		cfg80211_chandef_create(&chandef, cbss->channel,
>  					NL80211_CHAN_WIDTH_20_NOHT);
>  		chandef.width = sdata->u.ibss.chandef.width;

Hmm. Must you not get a chandef from cfg80211 so you don't need this
weird roundtrip through chandef_create()?

Anyway this is more of the discussion on patch 1.

johannes

