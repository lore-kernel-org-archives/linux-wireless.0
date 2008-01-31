Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:64278 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbYAaQQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 11:16:15 -0500
Received: by an-out-0708.google.com with SMTP id d31so173457and.103
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2008 08:16:14 -0800 (PST)
Message-ID: <40f31dec0801310816p3592bea0od2a19e0b15312e61@mail.gmail.com> (sfid-20080131_161628_566519_F7D33F74)
Date: Thu, 31 Jan 2008 18:16:14 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Port to new bitrate/channel API
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	johannes@sipsolutions.net
In-Reply-To: <43e72e890801310750o38faf05ckb9977e4e5d6341fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080130183824.GA7676@makis.domain.invalid>
	 <43e72e890801310707u8e29468h3de981c0e3c72c52@mail.gmail.com>
	 <40f31dec0801310732q3ac8fb84p875f31e16444c53e@mail.gmail.com>
	 <43e72e890801310750o38faf05ckb9977e4e5d6341fa@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/31, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>:
> On Jan 31, 2008 10:32 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > 2008/1/31, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>:
> > > On Jan 30, 2008 1:38 PM, Nick Kossifidis <mick@madwifi.org> wrote:
> > > > Tested on 5211, 5213+5112, 5213A+2112A and it wors fine.
> > > >
> > > > Also i figured out a way to process rate vallue found on status descriptors,
> > > > it's still buggy but we are getting closer (i think it improved stability a little).
> > > >
> > > > Changes-licensed-under: 3-clause-BSD
> > > > Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> > >
> > > My approach was little more extreme removing ath5k_rate struct and led
> > > stuff completely but well, its not done. Also we definitely still do
> > > dependent on mode stuff a lot and the whole capaibilty stuff is used
> > > inconsistantly. If anything I can base patches on this work.
> > >
> >
> > I also wanted to make a bigger cleanup (i added some TODOs there about
> > removing led stuff -i want to port them to mac80211 leds, not just
> > remove- and most of rate tables -we still need rate code mapping-,
> > other things can be ripped out also) but until i'm done with the exams
> > i don't have much time. Also some cosmetic changes like Jiri noticed
> > would be usefull and i intend to do more cleanups on that way also. I
> > hope i can come back with more stuff quickly ;-)
> >
> > > Nick, just please review the license and files you've changed. Other
> > > than that it looks OK.
> >
> > Ouch you are right !
> >
> > for base.c/base.h
> > Changes-licensed-under: 3-clause-BSD
> >
> > for hw.c/initvals.c/phy.c/ath5k.h
> > Changes-licensed-under: ISC
>
> Thanks. Nick as Jiri pointed out, can you also re-send after checking
> the patch with checkpatch.pl?
>
>   Luis
>

Checkpatch shows up 40 points, most of them because it's over 80 lines
and some of them because there are some missing spaces etc. I'm sure
code is full of those so i believe we should better cleanup the whole
code (also doing some sparse checking btw) once and for all (i told
you in my previous mail that's what i want to do when i'm done with
exams). It's really more easy for me to clean up the whole code after
i'm done with exams than try to locate 40 places in this monster that
might be fixed manually. I just need some time, i thought porting to
the new API was urgent so i gave it full priority, cleanup can wait i
guess (and we have to do it right and cautious).

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
