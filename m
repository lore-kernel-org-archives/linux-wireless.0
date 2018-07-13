Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55312 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbeGMRgj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 13:36:39 -0400
Subject: Re: [PATCH] ath10k: fix vdev-start timeout on error
To: =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>
References: <1531501683-32299-1-git-send-email-greearb@candelatech.com>
 <CABvG-CUdxFE8NiFfUKyeApm9dXqNWtGUWUBV1q8Fn3WF7zUnuQ@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, kvalo@codeaurora.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <4f4470db-d044-ef1c-4cc9-aab6bbc812f4@candelatech.com> (sfid-20180713_192109_536820_9F1AC28C)
Date: Fri, 13 Jul 2018 10:21:04 -0700
MIME-Version: 1.0
In-Reply-To: <CABvG-CUdxFE8NiFfUKyeApm9dXqNWtGUWUBV1q8Fn3WF7zUnuQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2018 10:17 AM, Michał Kazior wrote:
> On 13 July 2018 at 19:08,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The vdev-start-response message should cause the
>> completion to fire, even in the error case.  Otherwise,
>> the user still gets no useful information and everything
>> is blocked until the timeout period.
>>
>> Add some warning text to print out the invalid status
>> code to aid debugging.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/wmi.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>> index a60de71..ec4cd1e 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -3443,12 +3443,18 @@ void ath10k_wmi_event_vdev_start_resp(struct ath10k *ar, struct sk_buff *skb)
>>         ret = ath10k_wmi_pull_vdev_start(ar, skb, &arg);
>>         if (ret) {
>>                 ath10k_warn(ar, "failed to parse vdev start event: %d\n", ret);
>> -               return;
>> +               goto out;
>>         }
>>
>> -       if (WARN_ON(__le32_to_cpu(arg.status)))
>> -               return;
>> +       if (WARN_ON_ONCE(__le32_to_cpu(arg.status))) {
>> +               ath10k_warn(ar, "vdev-start-response reports status error: %d\n",
>> +                           __le32_to_cpu(arg.status));
>> +               /* Setup is done one way or another though, so we should still
>> +                * do the completion, so don't return here.
>> +                */
>> +       }
>>
>> +out:
>>         complete(&ar->vdev_setup_done);
>
> With this the waiter can no longer tell if vdev_start succeeded or
> not. It'll always think it succeeded even if arg.status or parsing
> failed. Waiter instead of erroring out will continue to play out happy
> scenario and may end up crashing firmware.
>
> Not stalling is nice, but I'd argue the status should be propagated
> back to the waiter so it can error-check.

So, maybe set ar->last_wmi_error = __le32_to_cpu(arg.status) before calling
the complete and change the code that waits for vdev_setup_done to check that
error code?

Or, maybe we need an error code specific to this call, ar->last_wmi_vdev_start_status?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
