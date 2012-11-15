Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:7980 "EHLO
	HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993257Ab2KOMJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 07:09:41 -0500
Message-ID: <50A4DB80.2020209@posedge.com> (sfid-20121115_130944_305008_126E6067)
Date: Thu, 15 Nov 2012 17:39:36 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: VHT support, take 2
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>  (sfid-20121109_211702_930840_209B43F6) <1352492493.28302.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352492493.28302.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2012 01:51 AM, Johannes Berg wrote:
> On Fri, 2012-11-09 at 21:17 +0100, Johannes Berg wrote:
>
>> What I intend to do next is this have a patch to parse the VHT
>> operation IE in mac80211 (or have a helper in cfg80211?) to
>> select the VHT channel configuration in MLME code.
>>
>> I'm kinda hoping the posedge folks will come back with the
>> regulatory code so I don't have to worry about that ...
>> *hint hint* :-)

vht regulatory code already posted long back. After went through several 
back n forth emails from Luis Rodriguez, accepted the patch.
But not commited anywhere.
Now I have to change that to match to new structs like chan_def etc from 
the vht channel work patches you posted 5 days back.

Also helper funcs to replace chan->flags bit checking to dynamically 
check channel through regulatory

>>
>> After that, I'll need to work on the remaining hostapd code,
>> that should just need channel configuration etc. now. Then I
>> think it just needs a good test run.
>>
>> I'm not interested in VHT IBSS, so I'm not going to do anything
>> there, nor VHT mesh.
>>
>> The other thing would be rate control, e.g. minstrel_vht, but
>> I'm not sure we can use minstrel at all, so I'll probalby not
>> work on minstrel myself.
>
> Oh and then of course there's also a whole bunch of action frame
> handling that will be needed in mac80211, but I'm not really sure yet
> what that actually is.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
