Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:51371 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727534AbeHJPt7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 11:49:59 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        Wen Gong <wgong@codeaurora.org>, ath10k@lists.infradead.org,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Change sk_pacing_shift in ieee80211_hw for best tx throughput
In-Reply-To: <5B6C0A3C.3020908@broadcom.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <4dbcc269-1f2b-b165-fe9e-8704fd77d1c5@bowerswilkins.com> <5B6C0A3C.3020908@broadcom.com>
Date: Fri, 10 Aug 2018 15:20:09 +0200
Message-ID: <87k1oye4ty.fsf@toke.dk> (sfid-20180810_152015_379862_9B0B4B1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 8/8/2018 9:00 PM, Peter Oh wrote:
>>
>>
>> On 08/08/2018 03:40 AM, Wen Gong wrote:
>>> Add a field for ath10k to adjust the sk_pacing_shift, mac80211 set
>>> the default value to 8, and ath10k will change it to 6. Then mac80211
>>> will use the changed value 6 as sk_pacing_shift since 6 is the best
>>> value for tx throughput by test result.
>> I don't think you can convince people with the numbers unless you
>> provide latency along with the numbers and also measurement result on
>> different chipsets as Michal addressed (QCA4019, QCA9984, etc.) From
>> users view point, I also agree on Toke that we cannot scarify latency
>> for the small throughput improvement.
>
> Yeah. The wireless industry (admittedly that is me too :-p ) has been 
> focused on just throughput long enough.

Tell me about it ;)

> All the preaching about bufferbloat from Dave and others is (just)
> starting to sink in here and there.

Yeah, I've noticed; this is good!

> Now as for the value of the sk_pacing_shift I think we agree it
> depends on the specific device so in that sense the api makes sense,
> but I think there are a lot of variables so I was wondering if we
> could introduce a sysctl parameter for it. Does that make sense?

I'm not sure a sysctl parameter would make sense; for one thing, it
would be global for the host, while different network interfaces will
probably need different values. And for another, I don't think it's
something a user can reasonably be expected to set correctly, and I
think it *is* actually possible to pick a value that works well at the
driver level.

-Toke
