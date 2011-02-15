Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56041 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab1BOMQf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 07:16:35 -0500
Message-ID: <4D5A6E9F.3040809@neratec.com>
Date: Tue, 15 Feb 2011 13:16:31 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Mahboob Alem <Mahboob.Alem@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Brian Kevin Lee <BrianK.Lee@atheros.com>,
	Kathy Giori <Kathy.Giori@atheros.com>
Subject: Re: Review of moving all DFS parameters to userspace
References: <AANLkTimSV7rHhdjWqfV5ujW6dd==BusmeC8fJOXGxfaT@mail.gmail.com> <20110201173247.GE2560@tuxdriver.com> <4D594CC4.9020906@neratec.com> <AANLkTinCKO_qQ4rnLigYSjnN-MgjrL04qbP4e4mBhQgj@mail.gmail.com> <4D59E5EB.9000502@openwrt.org>
In-Reply-To: <4D59E5EB.9000502@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 03:33 AM, Felix Fietkau wrote:
> On 2011-02-15 1:48 AM, Luis R. Rodriguez wrote:
>> On Mon, Feb 14, 2011 at 7:39 AM, Zefir Kurtisi
>> <zefir.kurtisi@neratec.com> wrote:
>>> On 02/01/2011 06:32 PM, John W. Linville wrote:
>>>> On Tue, Feb 01, 2011 at 08:38:05AM -0800, Luis R. Rodriguez wrote:
>>>>> I though we had reviewed the possibility of moving DFS parameters to
>>>>> userspace but it seems that's not the case. We now at least know we
>>>>> can keep the DFS regions: US, JP, ETSI, the next step is to determine
>>>>> if the DFS parameters for these regions will come from userspace or
>>>>> kernelspace. I'm inclined to support starting off with moving this to
>>>>> kernelspace just to let us move forward with this support, and once in
>>>>> kernel, review the possibility to move this out to userspace.
>>>>>
>>>>> Thoughts?
>>>>
>>>> Seems like a reasonable approach for the short term...better than
>>>> locking-in userland ABI...
>>>>
>>>> John
>>>
>>> Sorry, I was not aware that the userspace DFS approach was already discussed
>>> and rejected.
>>
>> 19:14 < *nbd> initially the pulse pattern matching will be somewhat hw specific
>> 19:14 < *nbd> or at least driver specific
>>
>> So ideally if we can generalize things great, I really did not think
>> we'd be able to get there on a first step.
> It's good to have the pulse pattern matching code be as generic as
> possible, but I would like to keep it in the ath module until we're sure
> that there actually is non-Atheros hardware out there that it can be
> used for (and preferably has been tested with).
> 
> I would strongly prefer if it stays in the kernel though, because
> certainly not all drivers are going to need pulse pattern matching code
> in the driver or stack (some will do this in firmware), and to have two
> completely different reporting mechanisms for radar detection events
> seems kind of pointless to me.
> 
> But even after moving it to the kernel, it would still be nice to have
> the code structured in a way that it can alternatively be compiled with
> some wrapper code for running user space tests.
> 
> - Felix

I understand your thoughts, but am still not clear on how you suggest to 
proceed with DFS implementation. Do you opt for taking DFS source code 
provided by Atheros (assumed we get it) and integrate it into ath9k, or 
take our proposal into ath9k as starting point?

In the latter case, would it be required to change the proposed interface 
to the detector with some Atheros specific parameters, or is it only to hide 
the (generic) detector from the outside world? With that latter case I 
personally would disagree, since - even if no other driver might ever use 
the generic detector - it does not hurt to make a generic module generally 
available.

We are circuiting this issue now for quite some time and we will continue so 
until we clarify its root cause, i.e. is pattern detection for radar pulse 
detecting chipsets HW-dependent or not. 
Hope we will get it resolved soon, now that Atheros DFS algorithm folks are 
included in the discussion.


See you at the meeting today.
Zefir

