Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab2DRBmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:42:14 -0400
Message-ID: <1334713300.3725.18.camel@jlt3.sipsolutions.net> (sfid-20120418_034216_345735_3886074D)
Subject: Re: [PATCH v2 5/6] mac80211: Add more ethtools stats: survey,
 rates, etc
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 18:41:40 -0700
In-Reply-To: <1334684807-14026-6-git-send-email-greearb@candelatech.com> (sfid-20120417_194713_443684_C3723CAF)
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>
	 <1334684807-14026-6-git-send-email-greearb@candelatech.com>
	 (sfid-20120417_194713_443684_C3723CAF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 10:46 -0700, greearb@candelatech.com wrote:
> +	/* Get survey stats for current channel */
> +	survey.filled = 0;
> +	if (drv_get_survey(local, 0, &survey) != 0) {
> +		survey.filled = 0;
> +		data[i++] = 0;
> +	} else {
> +		/* ath9k (and maybe others??) only updates internal stats
> +		 * when you get channel index 0, so if
> +		 * we are NOT on channel zero, get the real stats
> +		 * now.
> +		 */
> +		int ch_idx = ieee80211_get_channel_idx(local->hw.wiphy,
> +			local->oper_channel->center_freq);
> +		if (ch_idx == 0) {
> +			data[i++] = survey.channel->center_freq;
> +		} else {
> +			survey.filled = 0;
> +			if (drv_get_survey(local, ch_idx, &survey) != 0) {
> +				survey.filled = 0;
> +				data[i++] = 0;
> +			} else {
> +				data[i++] = survey.channel->center_freq;
> +			}
> +		}
> +	}

This is completely incomprehensible to me. I don't think the channel
index is what you think it is?

johannes

