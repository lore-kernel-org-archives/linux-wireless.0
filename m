Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:46193 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbYI3WLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 18:11:52 -0400
Message-ID: <48E2A41D.9010206@lwfinger.net> (sfid-20081001_001156_844970_D409AE42)
Date: Tue, 30 Sep 2008 17:11:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: Artem Antonov <artem.v.antonov@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC/T] b43: to few loop tries in do_dummy_tx
References: <48E11F1E.50705@lwfinger.net>	 <6bc534830809300934w13e88af0me7e19bd287f17af7@mail.gmail.com> <69e28c910809301302w48b3d982r5ddac62e459a1ca8@mail.gmail.com>
In-Reply-To: <69e28c910809301302w48b3d982r5ddac62e459a1ca8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefanik G=E1bor wrote:
>=20
> It would be good to know whether the Windows driver also suffers from
> PHY transmission errors... The "hybrid" Linux driver likely does have
> them, possibly even more than us, judging from its poor performance.
>=20

We didn't see the PHY transmission errors in b43 until fairly
recently. Unfortunately, they are too intermittent to tell if it is a
regression, and more importantly, it would be a bitch to bisect the
code as one would need many weeks of testing before saying that a
particular kernel was good.

When I first got 64-bit dma working on a BCM4311/2, there was always
one such error. That was removed when Michael changed the dma code.
Now I do not get any on most runs, but every once in a while (3 times
since July!), I get a storm of these.

Unlike most of you, I have seen the Broadcom code. There is almost no
error checking in their routines, which is good for us - it makes the
code smaller and the decompilation easier. I will never RE the binary
blob of the hybrid driver for a number of reasons; however, I doubt
that their culture has changed. As to why their driver has such poor
performance, your guess is as good as mine.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
