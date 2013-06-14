Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab3FNNQO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 09:16:14 -0400
Date: Fri, 14 Jun 2013 15:18:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20130614131829.GA5125@redhat.com> (sfid-20130614_151617_857513_65E54C3C)
References: <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com>
 <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com>
 <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 14, 2013 at 01:50:58PM +0100, Pedro Francisco wrote:
> >> >> Could you try this experimental patch? (...)
> >> >
> >> > I am trying the iwlegacy powersave patch along with CPU scheduler BFS
> >> > and IO scheduler BFQ.
> >> >
> >> > I've got this today: (...)
> >> >
> >> > (...)
> >> I also got a SYSASSERT:
> >> (...)
> >>
> >> I disabled powersave (but kept running the same kernel) and none of
> >> the errors appeared again.
> >
> > Yes, this seems to be iwlegacy PS issue and has to be fixed before
> > this patch could be applied.
> 
> But is it a driver-only issue? I had assumed it was some sort of
> fireware+driver issue...
Looks like driver issue or firmware issue that can be workaround in 
the driver.

> Will running with debug on help? Or is it easily reproducible on any
> iwl3945 / iwl4465 ?
> 
> Because in my case (iwl3945) it happens after boot, no prior suspend
> to RAM is required to trigger the issues.
I can reproduce microcode error on iwl4965 by reloading modules. Looks
like we put device in sleep mode and it can not be properly booted when
driver initalize. I did not yet test patch on iwl3945. When I'll do
this, I think I'll be able to reproduce problems you discovered. If not
I'll ask for more debug info.

Thanks
Stanislaw
