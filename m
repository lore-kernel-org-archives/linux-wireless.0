Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49152 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1BOCdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 21:33:22 -0500
Message-ID: <4D59E5EB.9000502@openwrt.org>
Date: Tue, 15 Feb 2011 03:33:15 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Mahboob Alem <Mahboob.Alem@atheros.com>,
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

On 2011-02-15 1:48 AM, Luis R. Rodriguez wrote:
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
> So ideally if we can generalize things great, I really did not think
> we'd be able to get there on a first step.
It's good to have the pulse pattern matching code be as generic as
possible, but I would like to keep it in the ath module until we're sure
that there actually is non-Atheros hardware out there that it can be
used for (and preferably has been tested with).

I would strongly prefer if it stays in the kernel though, because
certainly not all drivers are going to need pulse pattern matching code
in the driver or stack (some will do this in firmware), and to have two
completely different reporting mechanisms for radar detection events
seems kind of pointless to me.

But even after moving it to the kernel, it would still be nice to have
the code structured in a way that it can alternatively be compiled with
some wrapper code for running user space tests.

- Felix
