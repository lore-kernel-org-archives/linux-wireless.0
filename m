Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59032 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab2E3DrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 23:47:20 -0400
Message-ID: <4FC5983D.3080806@candelatech.com> (sfid-20120530_054753_974724_41343DB9)
Date: Tue, 29 May 2012 20:47:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Dave Taht <dave.taht@gmail.com>
CC: cerowrt-devel@lists.bufferbloat.net,
	Christian Lamparter <chunkeey@googlemail.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <4FC2437C.9090106@candelatech.com> <4FC51418.5000104@candelatech.com> <201205292107.42337.chunkeey@googlemail.com> <4FC5647F.4060601@candelatech.com> <CAA93jw6jTDCLh+_=hv6HcvfAuNah33uag7hHnZTMW8=92nvcqA@mail.gmail.com>
In-Reply-To: <CAA93jw6jTDCLh+_=hv6HcvfAuNah33uag7hHnZTMW8=92nvcqA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2012 08:22 PM, Dave Taht wrote:
> On Wed, May 30, 2012 at 1:06 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 05/29/2012 12:07 PM, Christian Lamparter wrote:
>>>
>>> On Tuesday, May 29, 2012 08:23:20 PM Ben Greear wrote:
>>>>
>>>> On 05/27/2012 08:08 AM, Ben Greear wrote:
>>>>>
>>>>> On 05/26/2012 09:39 AM, Sujith Manoharan wrote:
>>>>
>>>> We started testing with two AR9380 NICs today (one AP, the other STA).
>>>> I applied Felix's skb optimization patch, and the ath9k memleak fix patch
>>>> on top of 3.3.7+.
>>>>
>>>> The system has 2GB RAM, but it is 32-bit kernel, so not all
>>>> is available to the networking code...  That said, the OOM
>>>> killer kills VNC and such.
>>>>
>>>> Anyway, I'll try some memleak debugging to see if
>>>> I can find any leaks.  It seems to me that we should
>>>> not actually OOM just by trying to transmit too fast
>>>> on a station interface :P
>>>
>>> well, there's that:
>>> http://comments.gmane.org/gmane.linux.drivers.ath9k.devel/8233
>>>
>>> It might not fix the bug, but it can save you time to confirm
>>> that is not related to this particular skb leak.
>>
>>
>> I ported this to 3.3.7+ and applied it to my kernel
>> trees.  It has tested out fine so far, though it did not
>> actually fix the problem I was having.  That was not
>> a real leak, just always-growing pending queue length,
>> probably due to some issue with our version of pktgen.
>>
>> It is mostly a port-by-hand type of thing since
>> there are lots of conflicts.  Let me know if you'd
>> like me to post my version (and plz confirm your
>> signed-off-by).
>
> please! (and cc cerowrt-devel at lists.bufferbloat.net)
>
> I'm hoping this string of patches will have some bearing on my own
> bug: http://www.bufferbloat.net/issues/379
>
> (while I'm trying to not write a line of code for a while, others on my
>   list are struggling with this)

For your bug, do you get any warnings on a serial console?

What does 'top' show?  Ie, why is the load so high?  Just
flogging the kernel with pkts shouldn't explode the load.

Maybe processes are blocked trying to take a lock..maybe
a networking lock?

Tried enabling lockdep in this scenario, and maybe the
hard/soft deadlock detection logic?

If you back off the traffic, does the system recover?  If so,
maybe your CPU just can't handle the load....

If you think the mac80211 pending queues are backing up, cat out
/debug/ieee*/phy*/queues

That was the symptom I saw today with pktgen, but I think that is probably
more the fault of pktgen and may not be an issue with more normal traffic
flow.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
