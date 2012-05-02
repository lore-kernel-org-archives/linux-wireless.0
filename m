Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38586 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab2EBT3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 15:29:42 -0400
Received: by obbtb18 with SMTP id tb18so1363501obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2012 12:29:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEefFCdcGVp3MS4GrJCavMb87RKAXkhO7CmettD1_G=xHQ@mail.gmail.com>
References: <4F956DD2.2020309@gmail.com>
	<CAB3XZEefFCdcGVp3MS4GrJCavMb87RKAXkhO7CmettD1_G=xHQ@mail.gmail.com>
Date: Wed, 2 May 2012 21:29:41 +0200
Message-ID: <CAMJBoFN7qhwwmYgmoaks2kue-ERVvRonKWGvyERtym==A6qDPA@mail.gmail.com> (sfid-20120502_212945_926743_6CFD3B05)
Subject: Re: [PATCH/RFC] mac80211: wake queues if ieee80211_suspend failed
From: Vitaly Wool <vitalywool@gmail.com>
To: Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

On Mon, Apr 23, 2012 at 5:30 PM, Eliad Peller <eliad@wizery.com> wrote:
> hi Vitaly,
>
> On Mon, Apr 23, 2012 at 5:57 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
>> Sometimes I'm seeing that after a rejected suspend which was
>> rejected by the driver's suspend routine, the device can not
>> associate to any AP any more. Investigation shows that it's
>> due to the fact that the queues are left stopped with the
>> reason IEEE80211_QUEUE_STOP_REASON_SUSPEND.
>>
>> With that known, it looks like we need to wake queues on an
>> unsuccessful suspend attempt explicitly.
>>
>> ---
>>  net/mac80211/pm.c           |    2 ++
>>  1 file changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
>> index 844cefb..fd57913 100644
>> --- a/net/mac80211/pm.c
>> +++ b/net/mac80211/pm.c
>> @@ -96,6 +96,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct
>> cfg80211_wowlan *wowlan)
>>                int err = drv_suspend(local, wowlan);
>>                if (err) {
>>                        local->quiescing = false;
>> +                       ieee80211_wake_queues_by_reason(hw,
>> +
>> IEEE80211_QUEUE_STOP_REASON_SUSPEND);
>>                        return err;
>>                }
>
> it seems right.
> looks like there's a similar issue with WLAN_STA_BLOCK_BA being set
> for all the stations and not cleared on error..

thanks for the feedback. Johannes, any objections/additions? Should I
resubmit the patch?

Thanks,
   Vitaly
