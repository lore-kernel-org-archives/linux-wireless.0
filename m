Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47834 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2JUQlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 12:41:13 -0400
Message-ID: <50842569.5000602@ti.com> (sfid-20121021_184116_548970_83D57E01)
Date: Sun, 21 Oct 2012 18:40:09 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<assaf@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>  <1350226137-13704-2-git-send-email-victorg@ti.com> <1350414099.10177.13.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350414099.10177.13.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/10/2012 21:01, Johannes Berg wrote:
> On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:
>
>> + * @radar_detect_timeout: this timeout indicates the end of the channel
>> + *	availability check for radar channels (in jiffies), only after this
>> + *	period the user may initiate the tx on the channel.
>> + * @cac_type: indicates that channel availability check is started for this
>> + *	channel type.
>
> You're missing docs for cac_started
>

missed that..

> I'll fix it if I don't have any comments on the other patches and the
> answer to my question below doesn't mean a change:
>
>> +++ b/net/wireless/nl80211.c
>> @@ -1411,6 +1411,7 @@ static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
>>   			result = -EINVAL;
>>   			break;
>>   		}
>> +		channel->cac_started = false;
>
> Why this? If the device supports channel contexts then maybe one vif
> could set the channel and the other could be doing radar detection? But
> anyway this only presets the channel, so nothing will happen until the
> AP interface is started? So basically I don't understand this at all.

Here we just clearing the cac_started flag, this was previously done in 
the ieee80211_do_stop() for the "sdata->wdev.preset_chan", but as we 
didn't want to modify cfg80211 fields from mac I suggested to move it here.

I"ll try to clarify things a bit, the channel availability check (CAC) 
could be started during:
1. AP init phase - when AP is configured on DFS channel.
2. As a result of a channel switch - AP moved to a DFS channel.

In both cases we set the cac_started flag from the 
nl80211_start_radar_detection() and clear it:
1. As a result of radar event.
2. In __nl80211_set_channel() - to cover the case when the CAC was 
initiated on a "preset_chan" (during AP init phase) and the IF was 
removed before the AP was even started (local->oper_channel wasn't set yet).


-- 
Thanks,
Victor.
