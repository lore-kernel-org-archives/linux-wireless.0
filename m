Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37292 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1FVMvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 08:51:54 -0400
Received: by qyk29 with SMTP id 29so2670358qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 05:51:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308744205.29571.0.camel@jlt3.sipsolutions.net>
References: <BANLkTimW6oLjQoEbHGOAnXwbWMYUvK00fw@mail.gmail.com>
	<BANLkTimUc7Gz0AEKKDZinYpGABnDEBMHDA@mail.gmail.com>
	<1308736869.3883.13.camel@jlt3.sipsolutions.net>
	<BANLkTikbn2ABhJm75OZg8EC4LeaukzR=Vw@mail.gmail.com>
	<1308744205.29571.0.camel@jlt3.sipsolutions.net>
Date: Wed, 22 Jun 2011 14:51:53 +0200
Message-ID: <BANLkTimoUEs1L2yMmXER1woXPaz6f3sqgg@mail.gmail.com> (sfid-20110622_145157_867307_D05B375D)
Subject: Re: about RCU programming
From: =?ISO-8859-1?Q?Manuel_S=E1ez?= <manuelsaezr@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I probably need some kind of mutex, but I was wondering if it
would be enough with some memory barrier, since read and write
operations in modern computers are usually atomics.

What I pretend to do is that everytime I read one element from the
list, the function changes the "head pointer" with the next element ,
so the next time the function is called, it will return the next
element. When the list reach the last element, it starts again from
the beggining. The function should somehow remember the last extracted
element each time and consecutively return the next one. I could
probably use a counter and iterate the list looking for the next
element, but it would be hard to maintain when some elements are added
or deleted.

Best regards


2011/6/22 Johannes Berg <johannes@sipsolutions.net>:
> On Wed, 2011-06-22 at 13:54 +0200, Manuel Sáez wrote:
>> Thank you for your answer. I have actually read some articles like this ones:
>>
>> http://lwn.net/Articles/262464/
>> http://lwn.net/Articles/263130/
>>
>> I think I understood how I should normally use it, but not how it
>> really works. I found lots of code snippets in internet and it seems
>> to be very easy to use, but when I try to get more information it gets
>> more complicated. Although the code is wrong, do you think it could be
>> possible what I want to do? I mean, could it be possible in theory to
>> "shift" the header in order to make a ring buffer.
>
> I haven't understood what you want to do, but "shifting" anything would
> seem to me to be a write operation.
>
> johannes
>
>
