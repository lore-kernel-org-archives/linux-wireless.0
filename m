Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:39244 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab1BOJXZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 04:23:25 -0500
Message-ID: <4D5A4609.7070702@neratec.com>
Date: Tue, 15 Feb 2011 10:23:21 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Mahboob Alem <Mahboob.Alem@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Brian Kevin Lee <BrianK.Lee@atheros.com>,
	Kathy Giori <Kathy.Giori@atheros.com>
Subject: Re: Review of moving all DFS parameters to userspace
References: <AANLkTimSV7rHhdjWqfV5ujW6dd==BusmeC8fJOXGxfaT@mail.gmail.com> <20110201173247.GE2560@tuxdriver.com> <4D594CC4.9020906@neratec.com> <AANLkTinCKO_qQ4rnLigYSjnN-MgjrL04qbP4e4mBhQgj@mail.gmail.com>
In-Reply-To: <AANLkTinCKO_qQ4rnLigYSjnN-MgjrL04qbP4e4mBhQgj@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 01:48 AM, Luis R. Rodriguez wrote:
> On Mon, Feb 14, 2011 at 7:39 AM, Zefir Kurtisi
> <zefir.kurtisi@neratec.com> wrote:
>> On 02/01/2011 06:32 PM, John W. Linville wrote:
>>> On Tue, Feb 01, 2011 at 08:38:05AM -0800, Luis R. Rodriguez wrote:
>>>> I though we had reviewed the possibility of moving DFS parameters to
>>>> userspace but it seems that's not the case. We now at least know we
>>>> can keep the DFS regions: US, JP, ETSI, the next step is to determine
>>>> if the DFS parameters for these regions will come from userspace or
>>>> kernelspace. I'm inclined to support starting off with moving this to
>>>> kernelspace just to let us move forward with this support, and once in
>>>> kernel, review the possibility to move this out to userspace.
>>>>
>>>> Thoughts?
>>>
>>> Seems like a reasonable approach for the short term...better than
>>> locking-in userland ABI...
>>>
>>> John
>>
>> Sorry, I was not aware that the userspace DFS approach was already discussed
>> and rejected.
> 
> 19:14 < *nbd> initially the pulse pattern matching will be somewhat hw specific
> 19:14 < *nbd> or at least driver specific
> 
This discussion I most probably missed or forgot...

> So ideally if we can generalize things great, I really did not think
> we'd be able to get there on a first step.
> 
Let's see how far we would need to specialise our generalised approach to make 
it usable in real world environments.
>> I missed two IRC meetings in January and reading [1] sounded
>> to me that potential approaches are still evaluated.
>>
>> Anyhow, I meanwhile posted both approaches (kernel vs. userspace) that are
>> equivalent from functional point, assuming that a HW independent pattern
>> matching is what we need to implement for DFS radar detection.
>>
>> This in fact is still an open issue: Atheros claimed that detection is
>> HW-dependent while we have got up and (maybe not-so-perfectly ;)) running
>> HW-independen radar pattern detection
> 
> That's cool ! However I was told that for some parameters you might
> see some values programmed into hw which won't immediately make sense
> given that the programmed values are there in consideration for a
> hardware quirk of some sort. Mahboob, what parameters were those?
> 
For sure some parameters are HW dependent, e.g. the detection of chirping as 
defined for radar test signal #4 by ETSI 1.5.1. But this can be perfectly 
encapsuled in the driver: assume the HW detected a chirping pulse with 15us 
width. This width would be outside the valid range for pulse pattern #4, but 
since chirping was detected ath9k is quite sure that this was a type 4 pulse 
and reports a pulse event with a width of e.g. 25us. The pattern detector 
itself does not care about chirping - its criteria is solely the time stamp 
and the width of the pulse, so the last provided pulse event will be 
considered for pattern matching.

For the generic approach with pulse detection done in the driver and generic 
pattern matching we assume that HW-dependency will be used to increase the 
reliability of single pulse detections and that those detections are not 
inter-dependent. If otherwise there is a dependency, e.g. you need to know 
the last x pulse events to decide if the current one is also a pulse, then 
the whole DFS thing is for sure driver dependent.

This is what only you at Atheros definitely know.

>> We are still waiting to get Atheros'
>> pattern detector source code to evaluate detection performance and finally
>> prove the benefit of a HW dependent implementation.
> 
> That's being baked with legal.
> 
Does this legal checks include approval that the DFS source code might be 
integrated into ath9k?

>> Until then (and since the DFS activities degraded lastly) we will continue
>> fine-tuning our detectors based on the proposed design
> 
> Driver or userspace?
> 
Both are working on target, on host we are using the userspace one (since we 
still fail to write error-free kernel code ;))

>> and move to the
>> finally chosen architecture as soon as an agreement is reached.
> 
> Sorry for my delay on the first set of patches, I hope to send a v2
> hopefully by tomorrow..
> 
Thanks, see you all on Tuesday.

Zefir
>  Luis

