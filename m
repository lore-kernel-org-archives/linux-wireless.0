Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:40443 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbeHJV7l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 17:59:41 -0400
Received: by mail-qt0-f196.google.com with SMTP id h4-v6so11455687qtj.7
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2018 12:28:28 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] Change sk_pacing_shift in ieee80211_hw for best tx
 throughput
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        Wen Gong <wgong@codeaurora.org>, ath10k@lists.infradead.org,
        johannes@sipsolutions.net
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <4dbcc269-1f2b-b165-fe9e-8704fd77d1c5@bowerswilkins.com>
 <5B6C0A3C.3020908@broadcom.com> <87k1oye4ty.fsf@toke.dk>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B6DE758.8040605@broadcom.com> (sfid-20180810_212831_114774_8703BD65)
Date: Fri, 10 Aug 2018 21:28:24 +0200
MIME-Version: 1.0
In-Reply-To: <87k1oye4ty.fsf@toke.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/10/2018 3:20 PM, Toke Høiland-Jørgensen wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 8/8/2018 9:00 PM, Peter Oh wrote:
>>>
>>>
>>> On 08/08/2018 03:40 AM, Wen Gong wrote:
>>>> Add a field for ath10k to adjust the sk_pacing_shift, mac80211 set
>>>> the default value to 8, and ath10k will change it to 6. Then mac80211
>>>> will use the changed value 6 as sk_pacing_shift since 6 is the best
>>>> value for tx throughput by test result.
>>> I don't think you can convince people with the numbers unless you
>>> provide latency along with the numbers and also measurement result on
>>> different chipsets as Michal addressed (QCA4019, QCA9984, etc.) From
>>> users view point, I also agree on Toke that we cannot scarify latency
>>> for the small throughput improvement.
>>
>> Yeah. The wireless industry (admittedly that is me too :-p ) has been
>> focused on just throughput long enough.
>
> Tell me about it ;)
>
>> All the preaching about bufferbloat from Dave and others is (just)
>> starting to sink in here and there.
>
> Yeah, I've noticed; this is good!
>
>> Now as for the value of the sk_pacing_shift I think we agree it
>> depends on the specific device so in that sense the api makes sense,
>> but I think there are a lot of variables so I was wondering if we
>> could introduce a sysctl parameter for it. Does that make sense?
>
> I'm not sure a sysctl parameter would make sense; for one thing, it
> would be global for the host, while different network interfaces will
> probably need different values. And for another, I don't think it's
> something a user can reasonably be expected to set correctly, and I
> think it *is* actually possible to pick a value that works well at the
> driver level.

I not sure either. Do you think a user could come up with something like 
this (found here [1]):

sysctl -w net.core.rmem_max=8388608
sysctl -w net.core.wmem_max=8388608
sysctl -w net.core.rmem_default=65536
sysctl -w net.core.wmem_default=65536
sysctl -w net.ipv4.tcp_rmem='4096 87380 8388608'
sysctl -w net.ipv4.tcp_wmem='4096 65536 8388608'
sysctl -w net.ipv4.tcp_mem='8388608 8388608 8388608'
sysctl -w net.ipv4.route.flush=1

Now the page listing this config claims this is for use "on Linux 2.4+ 
for high-bandwidth applications". Beats me if it still is correct in 4.17.

Anyway, sysctl is nice for parameterizing code that is built-in the 
kernel so you don't need to rebuild it. mac80211 tends to be a module in 
most distros so maybe sysctl is not a good fit. So lets agree on that.

Picking a value at driver level may be possible, but a driver tends to 
support a number of different devices. So how do you see the picking 
work. Some static table with entries for the different devices?

Regards,
Arend

[1] https://wwwx.cs.unc.edu/~sparkst/howto/network_tuning.php
