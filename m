Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53121 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734Ab0JEVMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 17:12:38 -0400
Message-ID: <4CAB94C5.6050602@candelatech.com>
Date: Tue, 05 Oct 2010 14:12:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: memory clobber in rx path, maybe related to ath9k.
References: <4CAB59B2.5050106@candelatech.com> <AANLkTikhGCTS8kJgpDzjudyBTk-rkyXY33UO7kB0+Cc-@mail.gmail.com> <4CAB5F3D.9060201@candelatech.com> <AANLkTimV3GrwU+9PPtirT4sCzveLY2egr3PRQhfDBET1@mail.gmail.com> <4CAB627F.8020804@candelatech.com> <AANLkTi=sT5QJe4V8gFGjF-nzx0uJAMLG_XG2715qrEEd@mail.gmail.com> <4CAB64AD.4080105@candelatech.com> <AANLkTi=3dHbB5tmQDp3Ba54-DqQydVCkNdFo1vKbfaGY@mail.gmail.com> <4CAB6B08.4050801@candelatech.com>
In-Reply-To: <4CAB6B08.4050801@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/05/2010 11:14 AM, Ben Greear wrote:
> On 10/05/2010 10:55 AM, Luis R. Rodriguez wrote:
>> On Tue, Oct 5, 2010 at 10:47 AM, Ben Greear<greearb@candelatech.com>
>> wrote:
>
>>>> Please do, you can use the log2n approach, should take you 7 tries,
>>>> each by a power of 2, start at the middle of course.
>>>
>>> Sure...will be a few minutes.
>>>
>>> If it's any sane bug, then hopefully I can hit it with a small
>>> number.
>>>
>>> Out of curiosity, is there any particular number of STAs> 1 you guys
>>> test with?
>>
>> We don't test this :)
>
> Heh, I sort of supposed so :)
>
> Anyway, I started with one, doubled each time,
> and when I added the 4 to bring the system to
> 8 STA, it crapped itself.
>
> I ran 64kbps UDP data streams on pairs of STA interfaces
> for 5 minutes between STA increments. I didn't get a chance to
> start any traffic for the 4 that I had just added.
>
> Earlier, I wasn't running any traffic at all, but of course
> there is still noise on the network.
>
> Note I'm running 'iwconfig foo' and 'cat /proc/net/wireless' in
> the background as well, and that may have something to do with
> things.

I tried with the wmb() patch, and the problem still exists, so
it must be something else.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

