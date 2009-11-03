Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:44398 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZKCPyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 10:54:39 -0500
MIME-Version: 1.0
In-Reply-To: <1257262588.3420.79.camel@localhost.localdomain>
References: <20091103053156.GA3212@core.coreip.homeip.net>
	 <20091102.224957.32364226.davem@davemloft.net>
	 <20091103065238.GE3212@core.coreip.homeip.net>
	 <1257232587.3420.55.camel@localhost.localdomain>
	 <alpine.LFD.2.01.0911030719430.31845@localhost.localdomain>
	 <1257262588.3420.79.camel@localhost.localdomain>
Date: Tue, 3 Nov 2009 16:54:43 +0100
Message-ID: <c4e36d110911030754t5353f598p69c6ab7bcda97509@mail.gmail.com>
Subject: Re: Please consider reverting 7d930bc33653d5592dc386a76a38f39c2e962344
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/3 Marcel Holtmann <marcel@holtmann.org>:
> Hi Linus,
>
>> > and can we please stop jumping the gun here and going past the subsystem
>> > maintainers. I think this happens a little bit too much lately.
>>
>> NO!
>>
>> Quite frankly, I'm very unhappy indeed with the maintainers when it comes
>> to this bug:
>>
>>  - it was introduced after -rc5
>>
>>  - it's been bisected by multiple people
>>
>>  - I've seen one of the encounters with a person who bisected it, and the
>>    author of the buggy commit just wanted "more information" after having
>>    been told that small commit causes lockups.
>>
>> In other words - the LAST thing we should do is to pat the subsystem
>> maintainers on the back and say "good job".
>>
>> The fact is, when somebody reports a major bug that is fixed by a revert,
>> then I shoudl probably revert _more_ eagerly rather than less!
>>
>> And subsystem maintainers should jump on it, not wait several days.
>
> no questions that it needs fixed, I agree with you. However just blindly
> reverting something, because it fixes it for one or two people, might
> have side effects that causes more problems than the revert would
> actually fix. In this case, let at least give John or Johannes a chance
> to comment on it.
>
> I do love the fact that it gets bisected down to one particular commit.
> That is great and thanks to the people who did that, but let the
> subsystem maintainers know and then have them either provide a fix or
> revert it by them. Sometimes it might take more than one day. And lets
> be honest here, Johannes is one of the most responsive persons when it
> comes to wireless bugs.
>
> Regards

Well for me the issue has been fixed by http://lkml.org/lkml/2009/10/30/68

But it was not easy to decrypt bug after resume in my case....

However doing commit of memcpy where the src could be NULL in -rc5
looks really  suspicious.

Regards

Zdenek
