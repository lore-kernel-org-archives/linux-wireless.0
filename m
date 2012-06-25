Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46266 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab2FYHAW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 03:00:22 -0400
Message-ID: <4FE80C84.8080106@tieto.com> (sfid-20120625_090025_405506_6F8AEF9E)
Date: Mon, 25 Jun 2012 09:00:20 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFCv2 12/13] cfg80211: add channel checking for iface combinations
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>  <1340172859-18146-13-git-send-email-michal.kazior@tieto.com> <1340291033.4489.37.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340291033.4489.37.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
>
>> +		case CHAN_MODE_SHARED:
>> +			for (i = 0; i<  num_max_channels; i++)
>> +				if (!used_channels[i] || used_channels[i] == ch)
>> +					break;
>> +
>> +			if (i == num_max_channels) {
>> +				kfree(used_channels);
>> +				return -ENOMEM;
>> +			}
>
> Maybe use -EBUSY? -ENOMEM doesn't seem to make much sense? Or maybe I'm
> misunderstanding that? You allocated a pretty large number before (one
> for each possible channel) so we can't really run into it anyway I
> think?
>
> Or ... maybe we should just do something like
>
>   * force num_different_channels to be less than a constant we define,
>     say #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10 by checking in
>     wiphy registration -- if somebody needs more .... they can change
>     the constant but that seems very unlikely
>   * use a channel array with that size on the stack here, then we don't
>     even need to alloc memory

I just get too generic sometimes. Sounds good to me.


-- 
Pozdrawiam / Best regards, Michal Kazior.
