Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:55735 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1IVQZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 12:25:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1R6m5C-0000kM-CT
	for linux-wireless@vger.kernel.org; Thu, 22 Sep 2011 18:25:06 +0200
Received: from h205n2fls304o1036.telia.com ([81.227.195.205])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 18:25:06 +0200
Received: from void by h205n2fls304o1036.telia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 18:25:06 +0200
To: linux-wireless@vger.kernel.org
From: Edwin <void@edwin.nimell.com>
Subject: Re: [Bug?] Machine hangs, rtl8192se possible cause
Date: Thu, 22 Sep 2011 16:06:13 +0000 (UTC)
Message-ID: <loom.20110922T174352-81@post.gmane.org> (sfid-20110922_182512_436752_30AA489B)
References: <CAFdoEiT54o+NQKO=dAcOXgyf6GJ1E51w_H_p7PJyRmynz8Sbzg@mail.gmail.com>	<4E36C693.6000705@lwfinger.net> <CAFdoEiRBPMx0C+YXwd4-Q=_nHpOb+r2+GspwujZrPh6S4tDwEQ@mail.gmail.com> <4E3772C5.70606@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@...> writes:

> 
> On 08/01/2011 06:10 PM, Jaroslaw Fedewicz wrote:
> >
> > I'm using a fairly recent version of kernel from git (I think from
> > before yesterday). The mysterious hangs were there from the beginning,
> > but it also might be partly because ATI driver was messed up too at
> > these times. Later, ati appeared fixed but the hangs wouldn't go away.
> 
> If that git tree is linux-2.6, or its new name, from Linus, then you have the 
> latest source.
> 
> > I don't think it's a panic proper, though. Nothing ever gets logged
> > along the lines of "panic". Even if I happen to have a text mode
> > console, it just freezes. If I have a panic or an oops proper, I'm
> > also kicked out of X11 to see it by the KMS. But not in this case.
> >
> > (Also, the laptop has neither Caps Lock nor Num Lock nor Scroll Lock
> > LEDs, so I can't see if they blink.)
> 
> A kernel panic never logs anything to the disk. The only place you will see it 
> is on the logging console, or in netconsole output.
> 
> > What raised my suspicions is that I've never seen this happen when
> > rtl8192se wasn't compiled at all or was not loaded.
> >
> > The most problematic thing is that it does not hang right away. Most
> > of the time, I see the machine go into the catatonia after quite a
> > while, and as it is not the laptop I do most of my work on, I usually
> > see it hanged when screen PM has already kicked in. So I cannot really
> > read what the log might say on the matter.
> >
> > I cannot also trigger the freeze reliably. Most of the time it happens
> > "when you are not looking at it", and it usually happens either during
> > or just after high load averages and low to none network activity (a
> > typical scenario: build a firefox from sources, go outside, come home
> > 4 hours later, the laptop is turned on but dead by hanging; no
> > messages as the screen is obviously off; a less typical scenario is to
> > freeze during startup).
> >
> > I'm the last person ever to suggest anything on the subject, but could
> > it be a problem in the card's power management?
> 
> Not likely. I have three different cards with differing configurations that I 
> have run for extended periods without seeing your problem. One of them is the 
> same as yours.
> 
> Until you get some kind of dump from the system, I'm not sure what can be done.
> 
> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hi,

Did you ever find any solution to this issue? Because I got very similar
problems with my laptop, which is the same as Fedewicz'.

Although the issues started to appear after I upgraded from kernel 2.6.something
to kernel 3.0.4-1. Before that I only had issues causing the laptop to freeze
after resuming form suspend or hibernation, if the rtl8192se module wasn't
unloaded before issuing pm-suspend.

I might add that the freezes have just occurred when I'm on my school's network,
using WPA2 with PEAP and MSCHAPv2. I have yet to see it freeze when connected to
a unsecured network, but that might just be an coincidence.

I don't know if I'm able to get any dumps. And I can't try to do a magic sysrq
either, as the laptop is missing the SysRq-key...

Regards,
Edwin

