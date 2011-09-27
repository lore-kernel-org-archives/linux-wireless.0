Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:56890 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab1I0Fdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 01:33:45 -0400
Received: by bkaq10 with SMTP id q10so6065871bka.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 22:33:42 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Add support for HW channel switch
From: Luciano Coelho <coelho@ti.com>
To: "Levi, Shahar" <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAHiDVwksE1pjwij9cJDbFjQ_6XVdk2X=ULPpvL4KBnJzqJVLUg@mail.gmail.com>
References: <1315476093-27583-1-git-send-email-shahar_levi@ti.com>
	 <1316698619.2157.628.camel@cumari> <1316775583.2157.728.camel@cumari>
	 <CAHiDVwkeMTYdVubk=YPp6XTfNtmr2+mTwuX-ED0TcmzmrvEfUw@mail.gmail.com>
	 <1317018322.2171.17.camel@cumari>
	 <CAHiDVwksE1pjwij9cJDbFjQ_6XVdk2X=ULPpvL4KBnJzqJVLUg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 08:33:34 +0300
Message-ID: <1317101614.2171.87.camel@cumari> (sfid-20110927_073348_424066_0ECE7165)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 13:29 +0300, Levi, Shahar wrote: 
> On Mon, Sep 26, 2011 at 9:25 AM, Luciano Coelho <coelho@ti.com> wrote:
> > On Sun, 2011-09-25 at 19:08 +0300, Levi, Shahar wrote:
> >> On Fri, Sep 23, 2011 at 1:59 PM, Luciano Coelho <coelho@ti.com> wrote:
> >> > I'm leaving this patch out for now until I understand this better.
> >> Do you prefer me to set v2 without that line or you could fix that in
> >> the apply stage?
> >
> > No need to send v2.  It seems that Victor will need this change for
> > something else he's working on, so I guess he can take it over once it
> > is needed.  I don't want to include this unless we have a good reason to
> > do it.
> There is a good reason to include this:
> a) It solve STA calibration issue in the FW in case of SW channel
> switch (Rx issues)

This is a good reason (fixing a bug) and should be mentioned in the
commit description.  Do we have more detailed information on this?


> b) This is FW support for channel switch with one command instead of
> using several commands: rate_policies, roc \ join...

This is an optimization and not entirely mandatory.  This is the only
thing I thought this patch was addressing (the commit message was not
very descriptive, so I could only assume).  At this stage (ie. close to
the merge window), I didn't want to assume the risk of a change just for
to optimize things a bit.  And, since I had my doubts about the block_tx
value, I decided not to include it.


> Our latest version pass full test cycle with that fix that solve CS issues.

Okay, once I get the answer from the firmware team about the block_tx
value, I'll fix up this patch and apply it.

Thanks for the explanantions.

-- 
Cheers,
Luca.

