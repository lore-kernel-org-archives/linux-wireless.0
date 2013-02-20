Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40146 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114Ab3BTOEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 09:04:15 -0500
Message-ID: <5124D7DC.6010708@candelatech.com> (sfid-20130220_150420_306882_B5C67FCC)
Date: Wed, 20 Feb 2013 06:04:12 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Clean up work-queues on disassociation.
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com> <CAGRGNgVY+v9ko0MicEp5ozjrv38TG87sTw78SZhLLEqaK=XQ8Q@mail.gmail.com>
In-Reply-To: <CAGRGNgVY+v9ko0MicEp5ozjrv38TG87sTw78SZhLLEqaK=XQ8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2013 10:23 PM, Julian Calaby wrote:
> Hi Ben,
>
> On Wed, Feb 20, 2013 at 1:11 PM,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The monitor_work and beacon_connection_loss_work items were
>> not being canceled on disassociation (and not on deletion
>> either).  This leads to work-items trying to run after memory
>> has been deleted.
>>
>> I could not find a cleaner way to do this because the
>> cancel_work_sync for these items must be done outside
>> of the ifmgd->mtx.
>>
>> In addition, re-order the quiesce code so that timers are
>> always stopped before work-items are flushed.  This was
>> not the problem I saw, but I think it may still be more
>> correct.
>>
>> This fixes the crashes we see in 3.7.9+.  The crash stack
>> trace itself isn't so helpful, but this warning gives
>> more useful info:
>
> [snip]
>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>
>> NOTE:  Please do not apply this until it is reviewed by Johannes,
>> at least.
>>
>>   net/mac80211/mlme.c |   68 +++++++++++++++++++++++++++++++++++++++++++++-----
>>   1 files changed, 61 insertions(+), 7 deletions(-)
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 164ecf0..5a65144 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -2954,19 +2978,15 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
>>
>>          cancel_work_sync(&ifmgd->request_smps_work);
>>
>> +       sdata_err(sdata, "Cancel-work-sync monitor_work, sta_quiesce.\n");
>
> Debug code?

Err, yes..will remove.

>>   void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
>> @@ -3262,6 +3282,8 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>>          struct ieee80211_mgd_auth_data *auth_data;
>>          u16 auth_alg;
>>          int err;
>> +       bool maybe_cancel_work = false;
>> +       bool hit_err_clear = false;
>
> You could replace these with a single variable.

I don't see how.  It seems that we should only cancel the work items
if we called set_disassoc AND if the subsequent attempts to (re)associate
failed.

Maybe I missed something?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

