Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60515 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYJQWW0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 18:22:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Daiker <daikerjohn@gmail.com>
Subject: Re: [PATCH] b43: reduce checkpatch.pl errors
Date: Sat, 18 Oct 2008 00:22:03 +0200
Cc: stefano.brivio@polimi.it, linux-wireless@vger.kernel.org
References: <48F8E479.30304@gmail.com> <200810172345.52581.mb@bu3sch.de> <48F90A84.60902@gmail.com>
In-Reply-To: <48F90A84.60902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810180022.03587.mb@bu3sch.de> (sfid-20081018_002230_778066_F54DB94E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 October 2008 23:58:28 John Daiker wrote:
> Michael Buesch wrote:
> > On Friday 17 October 2008 23:36:36 John Daiker wrote:
> >   
> >> -		if (1 /*FIXME: the last PSpoll frame was sent successfully */ )
> >> +		if (1) /*FIXME: the last PSpoll frame was sent successfully */ {
> >>     
> >
> > Well, go for this, if you're really forced to fix this. ;)
> >
> >   
> >>> One additional thing I'd like you to do.
> >>> Do a b43 compile before and after applying the patch.
> >>> Keep the b43.ko files for both runs and do an md5sum on them.
> >>> Add the results to the commit log. The sums _must_ match.
> >>> If they don't, please send the changes that change the actual
> >>> binary code in seperate patches.
> >>>   
> >>>       
> >> Will do this next time with updated patch, among other things.
> >>     
> >
> > Thanks. Also make sure to enable all kconfig options.
> > (also remove the BROKEN dependencies that some options have,
> > if you are changing files related to these options.)
> I'm assuming you're debugging and forcing PIO over DMA?
> For the BROKEN things, can I just remove 'BROKEN' from the Kconfig 
> depends line?

Yeah, just enable all that stuff to make sure the binary code isn't changed.
You can just temporarly remove the "depends on BROKEN" and enable
the option. It will compile fine. It's just runtime broken.

-- 
Greetings Michael.
