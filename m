Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43187 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2DRDbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 23:31:34 -0400
Message-ID: <4F8E358F.1020501@candelatech.com> (sfid-20120418_053137_868151_FE76D99D)
Date: Tue, 17 Apr 2012 20:31:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 5/6] mac80211: Add more ethtools stats: survey, rates,
 etc
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>  <1334684807-14026-6-git-send-email-greearb@candelatech.com>  (sfid-20120417_194713_443684_C3723CAF) <1334713300.3725.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334713300.3725.18.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 06:41 PM, Johannes Berg wrote:
> On Tue, 2012-04-17 at 10:46 -0700, greearb@candelatech.com wrote:
>> +	/* Get survey stats for current channel */
>> +	survey.filled = 0;
>> +	if (drv_get_survey(local, 0,&survey) != 0) {
>> +		survey.filled = 0;
>> +		data[i++] = 0;
>> +	} else {
>> +		/* ath9k (and maybe others??) only updates internal stats
>> +		 * when you get channel index 0, so if
>> +		 * we are NOT on channel zero, get the real stats
>> +		 * now.
>> +		 */
>> +		int ch_idx = ieee80211_get_channel_idx(local->hw.wiphy,
>> +			local->oper_channel->center_freq);
>> +		if (ch_idx == 0) {
>> +			data[i++] = survey.channel->center_freq;
>> +		} else {
>> +			survey.filled = 0;
>> +			if (drv_get_survey(local, ch_idx,&survey) != 0) {
>> +				survey.filled = 0;
>> +				data[i++] = 0;
>> +			} else {
>> +				data[i++] = survey.channel->center_freq;
>> +			}
>> +		}
>> +	}
>
> This is completely incomprehensible to me. I don't think the channel
> index is what you think it is?

It is ugly, but as far as I can tell it works.  The survey method
wants an index, not channel number or frequency, from what I can tell
(I just looked at and tested ath9k).

Based on the freq returned as part of the survey results, the logic
above appears to function as I would hope.

That said, a new get-survey() method that took a channel object instead of an
index would make this code cleaner.  Or, we could store the channel
index in the channel object for fast lookup, but I was afraid storing the
index would be too risky in case channels are ever moved around for some reason
or another.

And, I could be missing something yet....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
