Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:44599 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3BTWI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 17:08:57 -0500
Received: by mail-wg0-f48.google.com with SMTP id 16so6734265wgi.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 14:08:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5124D7DC.6010708@candelatech.com>
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com>
 <CAGRGNgVY+v9ko0MicEp5ozjrv38TG87sTw78SZhLLEqaK=XQ8Q@mail.gmail.com> <5124D7DC.6010708@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 21 Feb 2013 09:08:35 +1100
Message-ID: <CAGRGNgVJ94_TFs7jrCxegYJMn4M25hSOaJR+i25bo1p4N9p_-g@mail.gmail.com> (sfid-20130220_230901_034546_67758645)
Subject: Re: [PATCH] mac80211: Clean up work-queues on disassociation.
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Thu, Feb 21, 2013 at 1:04 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 02/19/2013 10:23 PM, Julian Calaby wrote:
>>
>> Hi Ben,
>>
>> On Wed, Feb 20, 2013 at 1:11 PM,  <greearb@candelatech.com> wrote:
>>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> The monitor_work and beacon_connection_loss_work items were
>>> not being canceled on disassociation (and not on deletion
>>> either).  This leads to work-items trying to run after memory
>>> has been deleted.
>>>
>>> I could not find a cleaner way to do this because the
>>> cancel_work_sync for these items must be done outside
>>> of the ifmgd->mtx.
>>>
>>> In addition, re-order the quiesce code so that timers are
>>> always stopped before work-items are flushed.  This was
>>> not the problem I saw, but I think it may still be more
>>> correct.
>>>
>>> This fixes the crashes we see in 3.7.9+.  The crash stack
>>> trace itself isn't so helpful, but this warning gives
>>> more useful info:
>>
>>
>> [snip]
>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> ---
>>>
>>> NOTE:  Please do not apply this until it is reviewed by Johannes,
>>> at least.
>>>
>>>   net/mac80211/mlme.c |   68
>>> +++++++++++++++++++++++++++++++++++++++++++++-----
>>>   1 files changed, 61 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>>> index 164ecf0..5a65144 100644
>>> --- a/net/mac80211/mlme.c
>>> +++ b/net/mac80211/mlme.c
>>> @@ -3262,6 +3282,8 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data
>>> *sdata,
>>>          struct ieee80211_mgd_auth_data *auth_data;
>>>          u16 auth_alg;
>>>          int err;
>>> +       bool maybe_cancel_work = false;
>>> +       bool hit_err_clear = false;
>>
>>
>> You could replace these with a single variable.
>
>
> I don't see how.  It seems that we should only cancel the work items
> if we called set_disassoc AND if the subsequent attempts to (re)associate
> failed.
>
> Maybe I missed something?

No, I misread the code. Sorry for the noise.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
