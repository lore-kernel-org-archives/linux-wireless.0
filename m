Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:49167 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2F1LlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 07:41:16 -0400
Message-ID: <4FEC42D9.5040605@tieto.com> (sfid-20120628_134119_952827_44FC4F26)
Date: Thu, 28 Jun 2012 13:41:13 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] respect channels in iface combinations
References: <1340878025-2695-1-git-send-email-michal.kazior@tieto.com>  <1340879319.4491.38.camel@jlt3.sipsolutions.net>  <4FEC3BEC.2070906@tieto.com> <1340882283.4491.42.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340882283.4491.42.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-06-28 at 13:11 +0200, Michal Kazior wrote:
>> Johannes Berg wrote:
>>> On Thu, 2012-06-28 at 12:06 +0200, Michal Kazior wrote:
>>>> Hi,
>>>>
>>>> The patchset introduces channel tracking per interface which is needed
>>>> to start enforcing num_different_channels in interface combinations.
>>>> Changes to monitor mode behaviour is also required for sane channel
>>>> accounting (considering how mac80211 handles monitor interfaces).
>>>>
>>>> This prepares cfg80211 for multi-channel operation.
>>>
>>> This didn't apply cleanly on mac80211-next due to preset_chan in
>>> net/wireless/cfg80211.h. I think it's just context, but if you developed
>>> this without the start_ap series I wonder how stop_ap makes much sense?
>>>
>>> I'm a bit confused now?
>>
>> This is strange. I did develop it with the start_ap patches (my base is
>> master-2012-06-14 on wireless-next). I may be missing a few from your
>> mac80211 repo though.
>
> Yeah I thought you had. I know what happened - you don't have the "pass
> channel" patches. Could you check & rebase?

Yeah. The conflict on preset_chan is because I'm missing Felix's patch 
,,cfg80211: fix regression in multi-vif AP start''.

On the other hand I've had a conflict on my ,,cfg80211: respect iface 
combinations when starting operation'' while rebasing to mac80211-next. 
mac80211-next is missing my earlier patch ,,cfg80211: check iface 
combinations only when iface is running'' which is already in wireless-next.

Should I resend it rebased on mac80211-next?


-- 
Pozdrawiam / Best regards, Michal Kazior.

