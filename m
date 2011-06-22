Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51037 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVNFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:05:44 -0400
Subject: Re: about RCU programming
From: Johannes Berg <johannes@sipsolutions.net>
To: Manuel =?ISO-8859-1?Q?S=E1ez?= <manuelsaezr@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTimoUEs1L2yMmXER1woXPaz6f3sqgg@mail.gmail.com> (sfid-20110622_145216_381376_53209AA9)
References: <BANLkTimW6oLjQoEbHGOAnXwbWMYUvK00fw@mail.gmail.com>
	 <BANLkTimUc7Gz0AEKKDZinYpGABnDEBMHDA@mail.gmail.com>
	 <1308736869.3883.13.camel@jlt3.sipsolutions.net>
	 <BANLkTikbn2ABhJm75OZg8EC4LeaukzR=Vw@mail.gmail.com>
	 <1308744205.29571.0.camel@jlt3.sipsolutions.net>
	 <BANLkTimoUEs1L2yMmXER1woXPaz6f3sqgg@mail.gmail.com>
	 (sfid-20110622_145216_381376_53209AA9)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 15:05:42 +0200
Message-ID: <1308747942.29571.2.camel@jlt3.sipsolutions.net> (sfid-20110622_150552_802042_B3EF1CE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please don't top-post.

On Wed, 2011-06-22 at 14:51 +0200, Manuel Sáez wrote:
> Yes, I probably need some kind of mutex, but I was wondering if it
> would be enough with some memory barrier, since read and write
> operations in modern computers are usually atomics.
> 
> What I pretend to do is that everytime I read one element from the
> list, the function changes the "head pointer" with the next element ,
> so the next time the function is called, it will return the next
> element. When the list reach the last element, it starts again from
> the beggining. The function should somehow remember the last extracted
> element each time and consecutively return the next one. I could
> probably use a counter and iterate the list looking for the next
> element, but it would be hard to maintain when some elements are added
> or deleted.

Well ... you'd need to synchronize that offset or whatever, and also
reset whenever you modify the list, or whatever. It doesn't seem
feasible. I suggest you try implementing what you want first, and then
maybe somebody can help you optimise it.

johannes

