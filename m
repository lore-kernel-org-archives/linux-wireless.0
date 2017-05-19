Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37640 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751684AbdESLdk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 07:33:40 -0400
Message-ID: <1495193617.3274.7.camel@sipsolutions.net> (sfid-20170519_133346_979214_640AD6F2)
Subject: Re: [PATCH 5/7] mac80211: add wide bandwidth channel switch
 announcement to CSA action frames and mesh beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org, benjamin@sipsolutions.net
Date: Fri, 19 May 2017 13:33:37 +0200
In-Reply-To: <20170516092316.15636-6-sw@simonwunderlich.de> (sfid-20170516_112329_694356_1BF36491)
References: <20170516092316.15636-1-sw@simonwunderlich.de>
         <20170516092316.15636-6-sw@simonwunderlich.de>
         (sfid-20170516_112329_694356_1BF36491)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've applied patches 1-4 now.

The subject is a bit long - I was going to change it to

    mac80211: mesh: support sending wide bandwidth CSA
    
    To support HT and VHT channel switch announcements, both beacons
    and action frames must include the corresponding IEs.

but:

> +		   2 + 2 + sizeof(struct
> ieee80211_wide_bw_chansw_ie) +
> +		   2 + sizeof(struct ieee80211_sec_chan_offs_ie) +

The "2 + 2" should have a comment - no that I'm even really sure that
you need the wrapper?

> -		pos = skb_put(skb, 13);
> -		memset(pos, 0, 13);

Removing that is nice - but why do you do this:

> +		bool have_secondary_chan_offset = false;
> +		bool have_wide_bandwidth_cs = false;
> +		int ie_len = 2 + sizeof(struct
> ieee80211_channel_sw_ie) +
> +			     2 + sizeof(struct
> ieee80211_mesh_chansw_params_ie);
> +
> +		switch (csa->settings.chandef.width) {
> +		case NL80211_CHAN_WIDTH_80:
> +		case NL80211_CHAN_WIDTH_80P80:
> +		case NL80211_CHAN_WIDTH_160:
> +			have_wide_bandwidth_cs = true;
> +			ie_len += 2 + 2 +
> +				  sizeof(struct
> ieee80211_wide_bw_chansw_ie);
> +			break;
> +		case NL80211_CHAN_WIDTH_40:
> +			have_secondary_chan_offset = true;
> +			ie_len += 2 + sizeof(struct
> ieee80211_sec_chan_offs_ie);
> +		default:
> +			break;
> +		}
> +		pos = skb_put(skb, ie_len);
> +		memset(pos, 0, ie_len);

I think having multiple calls to skb_put() would be better.

>  		*pos++ = WLAN_EID_CHANNEL_SWITCH;
>  		*pos++ = 3;
>  		*pos++ = 0x0;
> @@ -760,6 +781,28 @@ ieee80211_mesh_build_beacon(struct
> ieee80211_if_mesh *ifmsh)
>  		pos += 2;
>  		put_unaligned_le16(ifmsh->pre_value, pos);
>  		pos += 2;
> +
> +		if (have_secondary_chan_offset) {
> +			enum nl80211_channel_type ct;

You can have one here, and re-initialize pos.

> +			*pos++ = WLAN_EID_SECONDARY_CHANNEL_OFFSET;
> /* EID */
> +			*pos++ = 1;				 
>    /* len */
> +			ct = cfg80211_get_chandef_type(&csa-
> >settings.chandef);
> +			if (ct == NL80211_CHAN_HT40PLUS)
> +				*pos++ =
> IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
> +			else
> +				*pos++ =
> IEEE80211_HT_PARAM_CHA_SEC_BELOW;
> +		}
> +
> +		if (have_wide_bandwidth_cs) {
> +			struct cfg80211_chan_def *chandef;

and likewise here.

That'd also be safer in a way.

johannes
