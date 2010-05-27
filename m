Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:11173 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752146Ab0E0Alc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 20:41:32 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-05467887
	for <linux-wireless@vger.kernel.org>; Thu, 27 May 2010 09:41:28 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCHv2] mac80211: Fix basic rates for created IBSS networks
Date: Thu, 27 May 2010 09:41:30 +0900
References: <1274878088-22785-1-git-send-email-juuso.oikarinen@nokia.com> <1274879624.5277.1917.camel@wimaxnb.nmp.nokia.com> <1274883276.3658.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1274883276.3658.15.camel@jlt3.sipsolutions.net>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005270941.30654.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 May 2010 23:14:36 you wrote:
> Needs to be split up (setting bss_conf and the bss_change flag is a
> separate bugfix) and tested but this is what I think it should be like.

thanks for this!

> +	} else {
> +		/*
> +		 * If no rates were explicitly configured,
> +		 * use the mandatory rate set for 11b or
> +		 * 11a for maximum compatibility.
> +		 */
> +		struct ieee80211_supported_band *sband =
> +			wiphy->bands[ibss.channel->band];
> +		int j;
> +		u32 flag = ibss.channel->band == IEEE80211_BAND_5GHZ ?
> +				IEEE80211_RATE_MANDATORY_A :
> +				IEEE80211_RATE_MANDATORY_B;
> +
> +		for (j = 0; j < sband->n_bitrates; j++) {
> +			if (sband->bitrates[j].flags & flag)
> +				ibss.basic_rates |= j;
> +		}
> +	}

couldn't we use ieee80211_mandatory_rates() here?

bruno
