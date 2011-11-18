Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59782 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab1KRWA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 17:00:29 -0500
Date: Fri, 18 Nov 2011 16:49:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Julia Lawall <julia@diku.dk>,
	Jesper Andersen <jespera@gmail.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] compat-wireless: avoid pr_fmt build SPAM
Message-ID: <20111118214917.GA29042@tuxdriver.com> (sfid-20111118_230032_989344_F60CE22F)
References: <1321649673-15874-1-git-send-email-linville@tuxdriver.com>
 <1321650012.10266.78.camel@jlt3.sipsolutions.net>
 <CAB=NE6Urei3NSQ05d_4MOUEoBb=tAvy9WE+_5zyc1-j_S+VnDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAB=NE6Urei3NSQ05d_4MOUEoBb=tAvy9WE+_5zyc1-j_S+VnDg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 01:12:51PM -0800, Luis R. Rodriguez wrote:
> On Fri, Nov 18, 2011 at 1:00 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2011-11-18 at 15:54 -0500, John W. Linville wrote:
> >> The way the compat-* header files are included causes the default
> >> pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
> >> Files that define pr_fmt then generate a lot of build SPAM about
> >> pr_fmt being redefined.
> >>
> >> Eliminate the build noise by preemptively undefining pr_fmt in those
> >> files that define it.  This is accomplished by adding a patch to the
> >> patches directory.
> >
> > This patch is going to be relatively painful when files move etc -- is
> > that really worth it? I for one will just drop it in our compat version
> > if it goes in since I don't even have all the files it patches :-)
> 
> This may be a good use case for spatch magic?

Yeah, I was thinking exactly that.  I haven't tried spatch yet,
but it would probably handle this fairly well.

Are you using it anywhere else?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
