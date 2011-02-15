Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38305 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1BOAtF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 19:49:05 -0500
Received: by vws16 with SMTP id 16so3481161vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 16:49:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D594CC4.9020906@neratec.com>
References: <AANLkTimSV7rHhdjWqfV5ujW6dd==BusmeC8fJOXGxfaT@mail.gmail.com>
 <20110201173247.GE2560@tuxdriver.com> <4D594CC4.9020906@neratec.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 14 Feb 2011 16:48:43 -0800
Message-ID: <AANLkTinCKO_qQ4rnLigYSjnN-MgjrL04qbP4e4mBhQgj@mail.gmail.com>
Subject: Re: Review of moving all DFS parameters to userspace
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Mahboob Alem <Mahboob.Alem@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Brian Kevin Lee <BrianK.Lee@atheros.com>,
	Kathy Giori <Kathy.Giori@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 7:39 AM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> On 02/01/2011 06:32 PM, John W. Linville wrote:
>> On Tue, Feb 01, 2011 at 08:38:05AM -0800, Luis R. Rodriguez wrote:
>>> I though we had reviewed the possibility of moving DFS parameters to
>>> userspace but it seems that's not the case. We now at least know we
>>> can keep the DFS regions: US, JP, ETSI, the next step is to determine
>>> if the DFS parameters for these regions will come from userspace or
>>> kernelspace. I'm inclined to support starting off with moving this to
>>> kernelspace just to let us move forward with this support, and once in
>>> kernel, review the possibility to move this out to userspace.
>>>
>>> Thoughts?
>>
>> Seems like a reasonable approach for the short term...better than
>> locking-in userland ABI...
>>
>> John
>
> Sorry, I was not aware that the userspace DFS approach was already discussed
> and rejected.

19:14 < *nbd> initially the pulse pattern matching will be somewhat hw specific
19:14 < *nbd> or at least driver specific

So ideally if we can generalize things great, I really did not think
we'd be able to get there on a first step.

> I missed two IRC meetings in January and reading [1] sounded
> to me that potential approaches are still evaluated.
>
> Anyhow, I meanwhile posted both approaches (kernel vs. userspace) that are
> equivalent from functional point, assuming that a HW independent pattern
> matching is what we need to implement for DFS radar detection.
>
> This in fact is still an open issue: Atheros claimed that detection is
> HW-dependent while we have got up and (maybe not-so-perfectly ;)) running
> HW-independen radar pattern detection

That's cool ! However I was told that for some parameters you might
see some values programmed into hw which won't immediately make sense
given that the programmed values are there in consideration for a
hardware quirk of some sort. Mahboob, what parameters were those?

> We are still waiting to get Atheros'
> pattern detector source code to evaluate detection performance and finally
> prove the benefit of a HW dependent implementation.

That's being baked with legal.

> Until then (and since the DFS activities degraded lastly) we will continue
> fine-tuning our detectors based on the proposed design

Driver or userspace?

> and move to the
> finally chosen architecture as soon as an agreement is reached.

Sorry for my delay on the first set of patches, I hope to send a v2
hopefully by tomorrow..

 Luis
