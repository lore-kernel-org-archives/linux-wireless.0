Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:43338 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZLNNxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 08:53:39 -0500
Received: by ey-out-2122.google.com with SMTP id d26so866167eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 05:53:38 -0800 (PST)
Message-ID: <4B26435F.5020002@gmail.com>
Date: Mon, 14 Dec 2009 13:53:35 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] orinoco: fix GFP_KERNEL in orinoco_set_key with interrupts
 disabled
References: <200912101955.01325.arvidjaar@mail.ru> <4B213F4D.2000707@gmail.com> <200912102156.32029.arvidjaar@mail.ru>
In-Reply-To: <200912102156.32029.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On Thursday 10 of December 2009 21:34:53 Dave wrote:
>> Andrey Borzenkov wrote:
>>> I had to resurrect old notebook and immediately hit this under
>>> 2.6.32:
>>>
>>> [   77.254109] WARNING: at
>>> /home/bor/src/linux-git/kernel/lockdep.c:2465 lockdep
>>> _trace_alloc+0x9a/0xa0()
>>>
>>> Until orinoco_lock can be converted from spinlock into mutex, this
>>> patch is the most simple solution.
>> Thank you Andrey. The patch is correct (though it could clean up the
>> misdirected comment 4 or 5 lines above).
> 
> Do you want me to resubmit with this cleanup?
> 
>> Is it worth pushing this to stable?
> 
> I think yes. Sleeping under spinlock with interrupts disabled is not fun 
> even if it is very unlikely.

If I understand it right, we want to cc the patch to stable@kernel.org.
So if you could take care of that comment and resubmit with cc (and
something in the title so John can tell we'd like this in 2.6.33 as
well), everyone's happy

<festive>
and Santa distributes the patch to all the good little kernels and
kernelettes
</festive>


Dave.
