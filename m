Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40887 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2GKFdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 01:33:14 -0400
Message-ID: <4FFD1014.2000109@qca.qualcomm.com> (sfid-20120711_073317_587128_EB87DB3E)
Date: Wed, 11 Jul 2012 11:03:08 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] nl80211: Avoid checking for empty WoWLAN triggers
References: <1341914875-14647-1-git-send-email-mohammed@qca.qualcomm.com>  <1341918365.4475.9.camel@jlt3.sipsolutions.net>  <4FFC0F22.6040906@qca.qualcomm.com> <1341919201.4475.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341919201.4475.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>>
>> On Tuesday 10 July 2012 04:36 PM, Johannes Berg wrote:
>>> On Tue, 2012-07-10 at 15:37 +0530, Mohammed Shafi Shajakhan wrote:
>>>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>>>
>>>> Previously we would check in nl80211 with an empty
>>>> cfg80211_wowlan structure to check for 'iw phy phyX wowlan enable'
>>>> with empty arguments (or) no triggers and disable WoWLAN.
>>>
>>> No ... that's not how it works. If you enable WoWLAN without any
>>> triggers, then that's what you get: the connection is kept alive but
>>> there are no wakeup sources. If you don't specify the triggers at all
>>> then it's disabled.
>>>
>>
>> If we want to do disable WoWLAN we can use the command 'iw phy phyX
>> wowlan disable' command. Its true that we would 'Keep Alive'
>> the connection, but we would disable the wake up capability via
>> 'set_wakeup' callback, something similar to wowlan disable command.
>> Please let me know if i am missing something (or) the advantage having
>> the connection Keep alive with wowlan enable without triggers.
>
> I don't know if there's any advantage. It could be useful for example to
> get a connection up quicker after resume. I just didn't want to preclude
> that use case.
>

sorry i just missed this thing. rdev->wowlan is made 'false' for empty 
wowlan enable triggers, then we would not call drv_suspend/resume 
callback, this would prevent the device from retaining the connection.
I would just check this with ath9k.


-- 
thanks,
shafi


