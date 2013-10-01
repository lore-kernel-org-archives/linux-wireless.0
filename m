Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3JALa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:30:26 -0400
Message-ID: <1380627023.14430.34.camel@jlt4.sipsolutions.net> (sfid-20131001_133030_007020_F7F2AEAD)
Subject: Re: [PATCH 5/5] mac80211: process mesh channel switching using
 beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Tue, 01 Oct 2013 13:30:23 +0200
In-Reply-To: <1379115372-28426-6-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130914_013635_982078_9678C34E)
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1379115372-28426-6-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20130914_013635_982078_9678C34E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-09-13 at 16:36 -0700, Chun-Yeow Yeoh wrote:

>  	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
>  					   ifibss->chandef.chan->band,
>  					   sta_flags, ifibss->bssid,
> -					   &params.count, &mode,
> +					   &params.count, &mode, &ttl,
>  					   &params.chandef);

I think it'd be worth doing some refactoring here to have an output
struct ... the parameters to this function are getting unreal. :)

> +	if (!cfg80211_chandef_usable(sdata->local->hw.wiphy, &params.chandef,
> +				     IEEE80211_CHAN_DISABLED)) {
> +		sdata_info(sdata,
> +			   "mesh STA %pM switches to unsupported channel (%d MHz, width:%d, CF1/2: %d/%d MHz), aborting\n",
> +			   sdata->vif.addr,
> +			   params.chandef.chan->center_freq,
> +			   params.chandef.width,
> +			   params.chandef.center_freq1,
> +			   params.chandef.center_freq2);
> +	}

Seems like you should *do* something here, like return false?

johannes

