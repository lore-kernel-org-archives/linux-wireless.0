Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2DUGQQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 02:16:16 -0400
Message-ID: <1334988973.3480.0.camel@jlt3.sipsolutions.net> (sfid-20120421_081649_561644_87764F85)
Subject: Re: [PATCH v3 4/4] mac80211: Add more ethtools stats: survey,
 rates, etc
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Sat, 21 Apr 2012 08:16:13 +0200
In-Reply-To: <1334962432-18620-4-git-send-email-greearb@candelatech.com> (sfid-20120421_005430_129157_D00F3C21)
References: <1334962432-18620-1-git-send-email-greearb@candelatech.com>
	 <1334962432-18620-4-git-send-email-greearb@candelatech.com>
	 (sfid-20120421_005430_129157_D00F3C21)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-04-20 at 15:53 -0700, greearb@candelatech.com wrote:

> +	if (last_sta) {
> +		data[i++] = sta->sta_state;
> +
> +		sinfo.filled = 0;
> +		sta_set_sinfo(last_sta, &sinfo);
> +
> +		if (sinfo.filled | STATION_INFO_TX_BITRATE)
> +			data[i] = 100000 *
> +				cfg80211_calculate_bitrate(&sinfo.txrate);
> +		i++;
> +		if (sinfo.filled | STATION_INFO_RX_BITRATE)
> +			data[i] = 100000 *
> +				cfg80211_calculate_bitrate(&sinfo.rxrate);
> +		i++;
> +
> +		if (sinfo.filled | STATION_INFO_SIGNAL_AVG)
> +			data[i] = (u8)sinfo.signal_avg;
> +		i++;

I think you should leave this out unless it's in managed mode because
it'll otherwise just be from a random station.

johannes

