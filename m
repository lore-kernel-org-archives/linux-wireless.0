Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37520 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754087AbcIOPRu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 11:17:50 -0400
Subject: Re: [PATCH v2 08/21] ath10k: make firmware text debug messages more
 verbose.
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
 <1462986153-16318-9-git-send-email-greearb@candelatech.com>
 <87sht2efiu.fsf@kamboji.qca.qualcomm.com> <57D9677E.5030704@candelatech.com>
 <87oa3pb6rd.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <7da59ba9-e048-7211-99b3-f288863a66ac@candelatech.com> (sfid-20160915_171810_944714_D6B95989)
Date: Thu, 15 Sep 2016 08:17:48 -0700
MIME-Version: 1.0
In-Reply-To: <87oa3pb6rd.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2016 07:02 AM, Valo, Kalle wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 09/14/2016 07:12 AM, Valo, Kalle wrote:
>>> greearb@candelatech.com writes:
>>>
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> There are not many of these messages producted by the
>>>> firmware, but they are generally fairly useful, so print
>>>> them at info level.
>>>>
>>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>>> ---
>>>>   drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>>>> index 1758b4a..d9e4b77 100644
>>>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>>>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>>>> @@ -4050,7 +4050,7 @@ void ath10k_wmi_event_debug_print(struct ath10k *ar, struct sk_buff *skb)
>>>>   	/* the last byte is always reserved for the null character */
>>>>   	buf[i] = '\0';
>>>>
>>>> -	ath10k_dbg(ar, ATH10K_DBG_WMI_PRINT, "wmi print '%s'\n", buf);
>>>> +	ath10k_info(ar, "wmi print '%s'\n", buf);
>>>
>>> Useful to whom and how? I understand that for firmware developers this
>>> is very valuable information and that's why we have a special debug
>>> level for it. But I suspect that for normal users these are just
>>> confusing and unnecessarily spam the log.
>>
>> CT firmare will print out some memory usage info on firmware boot, and that can
>> allow a discerning individual to tune their vdev, peer, rate-ctrl, and other
>> object usage in order to make best use of resources in the firmware.
>>
>> These few lines can greatly aid debugging certain types of crashes and performance
>> loss in the firmware, so having them readily available in 'dmesg' or similar
>> for bug reports from the field helps me.
>>
>> Stock firmware will also print out some resource usage info.  It is just
>> a few lines on firmware boot, but it is quite useful in my experience.
>
> I'm sure it's useful for you, but we have quite a few firmware versions
> to support. We do not know what kind of messages they print.

And how does that matter?  You think you can break something by printing
a string the logs?

Even if you do see problems, you can hide the logging messages again.

It's not like it is even 'secret', it is trivial for someone to print out
this info with a patch like mine.

I have tested this on 10.1, 10.2, 10.4.3 firmware.  Mine are similar to those
usptreams with regard to what they print out in this manner.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
