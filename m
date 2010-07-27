Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36112 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0G0OPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 10:15:13 -0400
Date: Tue, 27 Jul 2010 10:01:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Confused - bisecting wireless-testing
Message-ID: <20100727140139.GA31694@tuxdriver.com>
References: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 08:27:06PM -0700, Luis R. Rodriguez wrote:
> 04:23  * mcgrof is confused, I just did a git bisect -i on
> wireless-testing on some patch on Fri Jul 2 00:09:49 2010  and ended
> up with a 2.6.34 top level
>           Makefile
> 04:23 < mcgrof> it was git rebase -i ba17bc5e55ba541d2a8765fca53b6883b667ab21
> 04:23 < mcgrof> eh
> 04:24 < mcgrof> how am I supposed to bisect wl now
> 04:24 < mcgrof> the odd thing though is that the top commit is ancient
> 04:24 < mcgrof> http://paste.pocoo.org/show/242077/
> 04:24 < mcgrof> but the other ones are OK
> 
> I realize we should use wireless-2.6.git to bisect stable but I need
> to bisect against recent patches that spans different master- tags
> from you, I figured git bisecting wireless-testing would work now that
> you are using a different method to move your tree forward but am I
> wrong? Should I only bisect between master tags still?

wireless-testing is a nasty mess when it comes to bisection.
I am considering a one-time rebase of wireless-testing after the
next -rc1, now that the current process is working reasonably well.
wireless-testing will continue to have a messy history, but it should
be a bit less nasty after a rebase.

As for right now, it sounds like you should just use wireless-next-2.6
instead?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
