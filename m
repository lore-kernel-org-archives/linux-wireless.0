Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59089 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2H1PCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 11:02:17 -0400
Received: by eaac11 with SMTP id c11so1578845eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2012 08:02:16 -0700 (PDT)
Subject: Re: ath9k AR9287 freeze linux system
From: =?ISO-8859-1?Q?Lu=EDs_D=EDaz_Gonz=E1lez?= <luis.hlodwig@gmail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAD2nsn0cyiFj-obgtZt1JDt7f9o_+Yk0i3uZAt8DweLKKPxeRQ@mail.gmail.com>
References: <1346146736.3087.12.camel@inferno>
	 <CAD2nsn0uis8_GnNnR2p84TkDmphPoHe9LGTn2TNNZ18tCBxkog@mail.gmail.com>
	 <1346161526.3808.5.camel@inferno>
	 <CAD2nsn0cyiFj-obgtZt1JDt7f9o_+Yk0i3uZAt8DweLKKPxeRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Aug 2012 17:01:52 +0200
Message-ID: <1346166112.3412.14.camel@inferno> (sfid-20120828_170252_166747_CA7FC0D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tested the patch, great job, thanks a lot. All works great.
I think that coexistence between wifi and bluetooth never worked
better. :-)

luis


El mar, 28-08-2012 a las 19:28 +0530, Mohammed Shafi escribió:
> On Tue, Aug 28, 2012 at 7:15 PM, Luís Díaz González
> <luis.hlodwig@gmail.com> wrote:
> > El mar, 28-08-2012 a las 19:08 +0530, Mohammed Shafi escribió:
> >> Hi,
> >>
> >> On Tue, Aug 28, 2012 at 3:08 PM, Luís Díaz González
> >> <luis.hlodwig@gmail.com> wrote:
> >> > The last two releases compat-wireless (2012-08-26 and 2012-08-27) freeze
> >> > my linux system.
> >>
> >> thanks for reporting.
> >> *Please provide some information/call trace if you can get(you can
> >> attach a photograph of the trace :) )
> >> *like what did you do(sending traffic, suspend resume, keep the
> >> station idle?) to see the freeze.
> >> *I would try to recreate in my ubuntu 2.6.32.. kernel.
> >> *are you using btcoex in the driver sudo modprobe ath9k btcoex_enable=1  ?
> >
> > Yes, I'm using btcoex, when I disabled it, all works again.
> 
> please try the attached patch sent today,
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/96629
> you have go to your compat-wireless folder
> cd compat-wireless...
> then do patch -p1 <  /home/myname/fix-bt.patch
> 
> assuming the patch is in /home/myname/fix-bt.patch
> 
> do
> make clean && make && sudo make install
> 
> sudo make unload
> sudo modprobe -v ath9k btcoex_enable=1
> 
> 
> 
> >
> >>
> >>
> >> >
> >> > I'm not a developer, I'm a simple user
> >> >
> >> > Debian Squeeze 2.6.32
> >> > wireless card  AR9287
> >> >
> >> >
> >> > thanks,
> >> > luis
> >> >
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> >>
> >
> >
> 
> 
> 


