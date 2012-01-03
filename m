Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:57751 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203Ab2ACW2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 17:28:08 -0500
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 3B38A207C2
	for <linux-wireless@vger.kernel.org>; Tue,  3 Jan 2012 17:28:08 -0500 (EST)
Date: Tue, 3 Jan 2012 14:27:31 -0800
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2011-12-15
Message-ID: <20120103222731.GA26544@kroah.com> (sfid-20120103_232825_700432_D831FC82)
References: <20111215191523.GA2561@tuxdriver.com>
 <CACna6rw736JdkoM8zKxorCFd5oy08QTwWZ6PutoJPSr3ZN8hTg@mail.gmail.com>
 <20111215213822.GB2561@tuxdriver.com>
 <CACna6rz3qDpw4eJOoCXx7=z1719v7kS-Ou-WUseR9_vB-O2dag@mail.gmail.com>
 <CACna6rxO2dC=Y3nv-d-w89MqyM0j0aumk=r5Yh_KEg=MwOcvEQ@mail.gmail.com>
 <20120103205226.GA17131@kroah.com>
 <CACna6rwjrg6m3SEBxfYWgRSTN5_4-TuA0tdG6P2pFuUvwvvjZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwjrg6m3SEBxfYWgRSTN5_4-TuA0tdG6P2pFuUvwvvjZA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 03, 2012 at 11:06:59PM +0100, Rafał Miłecki wrote:
> W dniu 3 stycznia 2012 21:52 użytkownik Greg KH <greg@kroah.com> napisał:
> > On Mon, Dec 26, 2011 at 12:36:59AM +0100, Rafał Miłecki wrote:
> >> W dniu 16 grudnia 2011 07:40 użytkownik Rafał Miłecki
> >> <zajec5@gmail.com> napisał:
> >> > W dniu 15 grudnia 2011 22:38 użytkownik John W. Linville
> >> > <linville@tuxdriver.com> napisał:
> >> >> On Thu, Dec 15, 2011 at 09:04:29PM +0100, Rafał Miłecki wrote:
> >> >>> 2011/12/15 John W. Linville <linville@tuxdriver.com>:
> >> >>> > commit 42a3b63bb2ca4996a3d1210a004eae2333f1119e
> >> >>> >
> >> >>> > Dave,
> >> >>> >
> >> >>> > Here are a few more fixes intended for the 3.2 release.  They are
> >> >>> > all small and narrowly focused.
> >> >>>
> >> >>> John, I've made a mistake and didn't use [PATCH 3.2] header to make it
> >> >>> clean my patch is fix. Could you take a look at
> >> >>> [PATCH] bcma: support for suspend and resume
> >> >>> please?
> >> >>>
> >> >>> It's not one-liner, but fixes lock ups, which I believe - we really
> >> >>> want to avoid.
> >> >>
> >> >> It's late in the release cycle, and Dave specifically asked me to slow down.
> >> >>
> >> >> Are these suspend/resume lockups a regression?  Or have they always
> >> >> been there?  Do they happen to everyone?
> >> >
> >> > The bug is present since first days of bcma. That's why I even decided
> >> > to add stable to CC.
> >> >
> >> > Personally I've tested that only on 1 machine (I don't have more
> >> > suspendable machines with mini PCIe slot). However all Macbook 8.1/8.2
> >> > users have to remove b43 & bcma before suspending [0], they complain
> >> > about that since ever.
> >> >
> >> > Arend: I know you're also complaining for suspend in bcma. Can you
> >> > comment on this?
> >> >
> >> > [0] http://ubuntuforums.org/showthread.php?t=1695746
> >>
> >> User nephyrin on #bcm-users has confirmed this patch fixes
> >> suspend&resume for him. Without this patch he got deadlock without
> >> seeing any kernel panic logs - quite an ugly case.
> >>
> >> I still think this patch may be worth taking as fix and backporting too.
> >
> > What patch specifically?  What is the git commit id of it in Linus's
> > tree?  Without that information, telling stable@ about it is
> > pointless...
> 
> Sorry Greg, it's about
> 
> commit 775ab52142b02237a54184238e922251c59a2b5c
> Author: Rafał Miłecki <zajec5@gmail.com>
> Date:   Fri Dec 9 22:16:07 2011 +0100
> 
>     bcma: support for suspend and resume
> 
>     bcma used to lock up machine without enabling PCI or initializing CC.
> 
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> it's located in wireless-testing:
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> 
> John didn't pass this to Linus yet.

Then there's nothing I can do about it.

As it's properly tagged, I'll pick it up when it gets to Linus.

thanks,

greg k-h
