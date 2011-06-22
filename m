Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61264 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938Ab1FVN3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:29:30 -0400
Received: by qyk9 with SMTP id 9so448208qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 06:29:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308747942.29571.2.camel@jlt3.sipsolutions.net>
References: <BANLkTimW6oLjQoEbHGOAnXwbWMYUvK00fw@mail.gmail.com>
	<BANLkTimUc7Gz0AEKKDZinYpGABnDEBMHDA@mail.gmail.com>
	<1308736869.3883.13.camel@jlt3.sipsolutions.net>
	<BANLkTikbn2ABhJm75OZg8EC4LeaukzR=Vw@mail.gmail.com>
	<1308744205.29571.0.camel@jlt3.sipsolutions.net>
	<BANLkTimoUEs1L2yMmXER1woXPaz6f3sqgg@mail.gmail.com>
	<1308747942.29571.2.camel@jlt3.sipsolutions.net>
Date: Wed, 22 Jun 2011 15:29:29 +0200
Message-ID: <BANLkTinQ=PpSSa1iW8Yr+1r_MY1f1ELEfg@mail.gmail.com> (sfid-20110622_152933_299965_64B7FFBE)
Subject: Re: about RCU programming
From: =?ISO-8859-1?Q?Manuel_S=E1ez?= <manuelsaezr@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/22 Johannes Berg <johannes@sipsolutions.net>:
> Please don't top-post.
>
> On Wed, 2011-06-22 at 14:51 +0200, Manuel Sáez wrote:
>> Yes, I probably need some kind of mutex, but I was wondering if it
>> would be enough with some memory barrier, since read and write
>> operations in modern computers are usually atomics.
>>
>> What I pretend to do is that everytime I read one element from the
>> list, the function changes the "head pointer" with the next element ,
>> so the next time the function is called, it will return the next
>> element. When the list reach the last element, it starts again from
>> the beggining. The function should somehow remember the last extracted
>> element each time and consecutively return the next one. I could
>> probably use a counter and iterate the list looking for the next
>> element, but it would be hard to maintain when some elements are added
>> or deleted.
>
> Well ... you'd need to synchronize that offset or whatever, and also
> reset whenever you modify the list, or whatever. It doesn't seem
> feasible. I suggest you try implementing what you want first, and then
> maybe somebody can help you optimise it.
>
> johannes
>
>

Thank you, I will give a try and post the results.
