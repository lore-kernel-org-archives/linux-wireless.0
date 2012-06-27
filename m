Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:60105 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab2F0Haf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 03:30:35 -0400
Message-ID: <4FEAB698.5070309@tieto.com> (sfid-20120627_093039_380917_09F85E8A)
Date: Wed, 27 Jun 2012 09:30:32 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v3] initial channel context implementation
References: <1340714242-20032-1-git-send-email-michal.kazior@tieto.com> <1340718188.14634.47.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340718188.14634.47.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2012-06-26 at 14:37 +0200, Michal Kazior wrote:
>> Hi,
>>
>> Here's another respin of channel context patches.
>>
>> Changes:
>>
>>   - moved ieee80211_chan_mode
>>   - updated chanctx_conf comment
>>   - replaced vif_list with refcount
>>   - added lockdeps
>>   - channel type downgrading support
>>     (when a channel context is unassigned from a vif
>>      channel type is recalculated for the remaining vifs
>>      sharing the same channel context)
>
> Except for that last point which seems to have implementation issues,
> this looks really good too!
>
> How are you planning to proceed from here? I'm happy to pick these up
> even if you're not going to work on using it right away since I think in
> that case I would probably be working on using it pretty soon, but if
> you are planning to work on it that's even better :-)

The next step is to start using channel contexts in mac80211. I was 
thinking of using chanctx->channel instead of hw.conf.channel if 
.assign_vif_chanctx is defined. I expect some issues like using channel 
before it is set.

Hwsim requires .hw_scan and ROC to be implemented to test channel 
contexts. hw_scan should be simple (if we skip a few things..) but 
haven't looked into the ROC case yet. It also requires some changes to 
move channel logic per-vif.

Depending on how things turn out I may start to tackle on mac80211 a bit 
more and hw_scan for hwsim. I may send a few patches on monday.

I'll of course resend this patchset today once I fix the pointed out issues.


-- 
Pozdrawiam / Best regards, Michal Kazior.

