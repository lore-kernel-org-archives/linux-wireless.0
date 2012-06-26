Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:56368 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab2FZNoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 09:44:37 -0400
Message-ID: <4FE9BCC3.7070704@tieto.com> (sfid-20120626_154441_085327_E0FCC486)
Date: Tue, 26 Jun 2012 15:44:35 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3 12/13] cfg80211: add channel checking for iface combinations
References: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com>  <1340713818-28549-13-git-send-email-michal.kazior@tieto.com> <1340717368.14634.36.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340717368.14634.36.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2012-06-26 at 14:30 +0200, Michal Kazior wrote:
>
>> +#define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
>
> Might make sense to put this into cfg80211.h, since e.g. hwsim could
> support this many channels?
>
>> +		cfg80211_get_chan_state(rdev, wdev_iter, &ch, &chmode);
>> +
>> +		switch (chmode) {
>> +		case CHAN_MODE_UNDEFINED:
>> +			break;
>> +		case CHAN_MODE_SHARED:
>> +			for (i = 0; i < CFG80211_MAX_NUM_DIFFERENT_CHANNELS; i++)
>> +				if (!used_channels[i] || used_channels[i] == ch)
>> +					break;
>> +
>> +			BUG_ON(i == CFG80211_MAX_NUM_DIFFERENT_CHANNELS);
>
> I'd prefer not to use BUG_ON(), maybe WARN_ON() and return some error?
> It seems it could actually happen with buggy drivers that suddenly go
> above their num_different_channels by switching around themselves or
> something?

Hmm.. Now that I think of it we could probably hit the BUG_ON normally. 
Suppose a driver supports num_different_channels == 
CFG80211_MAX_NUM_DIFFERENT_CHANNELS. If cfg80211_can_use_iftype_chan is 
called with another different channel we will hit the BUG_ON, no?

I think we should either do a WARN_ON_ONCE here, or nothing actually. 
And return -EBUSY of course.


-- 
Pozdrawiam / Best regards, Michal Kazior.
