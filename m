Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:23000 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbbGFOlB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 10:41:01 -0400
Message-ID: <559A9378.7000006@neratec.com> (sfid-20150706_164107_117027_CA9288B6)
Date: Mon, 06 Jul 2015 16:40:56 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>,
	Wei Zhong <wzhong@google.com>
CC: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: update CA rules for 5600 - 5650 mHz
References: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com> <55966D1B.1040603@neratec.com> <CAHr=VqnpJ_+ovmB3gqm+X9WX98ZeVuO8VZ2cq6OFPcdjy8Rkgg@mail.gmail.com> <5596A3C0.6020303@neratec.com> <20150706132707.GA22962@ubuntu-hedt>
In-Reply-To: <20150706132707.GA22962@ubuntu-hedt>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2015 03:27 PM, Seth Forshee wrote:
> On Fri, Jul 03, 2015 at 05:01:20PM +0200, Zefir Kurtisi wrote:
>> On 07/03/2015 04:20 PM, Wei Zhong wrote:
>> [...]
>> From your other post:
>>>>     >
>>>>     >  -       (5490 - 5730 @ 160), (24), DFS
>>>>     >  +       (5490 - 5590 @ 80), (24), DFS
>>>>
>>>>     I agree. 5590 is more strict than 5600.
>>>>
>>>>  
>>>> On a second thought,  5590 implies channel 116 can't have 40MHz. I think that is
>>>> still allowed per regulation.
>>>>
>>>>
>>
>> No, channel 116 is not usable for HT40 if weather radar channels are disabled,
>> since it can only be combined with channel 120 and that one partially falls into
>> the restricted range.
> 
> It's not necessary to restrict the band down to 5590 or break out the
> rule for channel 116 separately, the software is smart enough to work
> out what's allowed based on the original rule Wei supplied for 5490-5600
> MHz. In fact that rule exactly matches what we used to have in db.txt
> for the US prior to the TDWR restrictions being lifted.
> 

Yes, the SW is smart and sane enough to extract the limitations even if they are
defined less restrictive than required. Which raises the general question of what
needs to be defined as rule and what can be relied on to be handled correctly by
the SW.

Example: why do we need to bother about the max-bw parameter for a rule at all? We
know there is no 160MHz channel within 5490 and 5600, as does the SW. If we wrote
(5490 - 5600 @ 160) instead of (5490 - 5600 @ 80), nothing would change.

To me it sounds not fully consistent to explicitly limit max-bw while relying on
SW to sanitize frequency ranges. Not that it really matters in practice, but it
has a potential to simplify the rules (i.e. provide max-bw parameter only if the
according country defines restrictions and leave SW to handle it otherwise).


Cheers,
Zefir
