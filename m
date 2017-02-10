Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35521 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751073AbdBJEVB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 23:21:01 -0500
Date: Thu, 9 Feb 2017 21:20:55 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: Mark Greer <mgreer@animalcreek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Justin Bronder <justin@kuvee.com>,
        linux-nfc <linux-nfc@lists.01.org>,
        Jaret Cantu <jaret.cantu@timesys.com>
Subject: Re: [Patch] NFC: trf7970a:
Message-ID: <20170210042055.GA9104@animalcreek.com> (sfid-20170210_052107_258342_61C47201)
References: <20161214223123.GA10281@animalcreek.com>
 <20161216045210.GA29196@animalcreek.com>
 <20161216203538.GA12608@animalcreek.com>
 <CAO7Z3W+grhLnP05bPShheuvSet08CoYhFStDpDVgztf=Wz42Fw@mail.gmail.com>
 <20161219030733.GA14962@animalcreek.com>
 <20170208225339.GA26286@animalcreek.com>
 <20170208225651.GB26286@animalcreek.com>
 <CAO7Z3WKxXz1SsvOH8v5Xvy0jSdw1-NU_zXyu0QakR3UHnYgrqA@mail.gmail.com>
 <20170209212706.GA26734@animalcreek.com>
 <CAO7Z3W+hS1KuKdA=n=X2cgsEEUtmS51EqFRw8PXMQXPQ5=_XqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAO7Z3W+hS1KuKdA=n=X2cgsEEUtmS51EqFRw8PXMQXPQ5=_XqQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 09, 2017 at 07:41:11PM -0500, Geoff Lansberry wrote:
> On Thu, Feb 9, 2017 at 4:27 PM, Mark Greer <mgreer@animalcreek.com> wrote:
> >
> > On Thu, Feb 09, 2017 at 10:54:08AM -0500, Geoff Lansberry wrote:
> > > On Wed, Feb 8, 2017 at 5:56 PM, Mark Greer <mgreer@animalcreek.com> wrote:
> > > >
> > > > I just realized that the linux-nfc is not CC'd so adding it.
> > > >
> > > > On Wed, Feb 08, 2017 at 03:53:39PM -0700, Mark Greer wrote:
> > > > > On Sun, Dec 18, 2016 at 08:07:33PM -0700, Mark Greer wrote:
> > > > > > On Sat, Dec 17, 2016 at 04:19:04PM -0500, Geoff Lansberry wrote:
> > > > > > > Mark,   from our consultant:
> > > > > > >
> > > > > > > It isn't important whether the flood script is successful in writing
> > > > > > > or not. The point of it is to force a segfault by making many
> > > > > > > requests. It needs to run for several hundred iterations (successful
> > > > > > > or not) in order to generate the segfault.
> > > > > >
> > > > > > So neard crashes even when the write fails??  Okay, I'll let it run for
> > > > > > a while tomorrow (Monday).
> > > > >
> > > > > [Okay, so not exactly "tomorrow" but I did get back to this.]
> > > > >
> > > > > Geoff, a few things:
> > > > >
> > > > > 1) Any update on these issues?
> > >
> > > Yes - I've discovered the primary trigger of my problems.  I'm using
> > > some very small tags from Murata, and they don't have a strong signal.
> > > Sometimes when writing, the tags can get corrupted data written to
> > > them. When the tag is verified by re-reading it, neard bails out
> > > because it finds non-utf8 characters.  So far I have found it
> > > impossible to rewrite a tag once it has been mal-formed.
> >
> > Okay, that's interesting.  neard still shouldn't bail out so we'll
> > have to look at that.
> 
> This is the most critical thing for us right now.  Can you make a
> malformed tag and try it to see if you have the same issue?  What I
> typically see is 0xFE character too early in the string, or similarly
> the length being too long for the string.  If you can do that, then
> try to write or read it via neard.  If you can confirm the quitting
> behavior, that will help a lot.  I can live with the corruption,
> because I can detect it and re-write if it happens.

I don't have such a thing but I can always hack something to write bogus
data.  I may not get to this until next week, though.

> > > > > 2) Do you have all of the NFC-related patches from the nfc-next master
> > > > > branch?  In particular, do you have all of Thierry's patches to
> > > > > net/nfc/digial_*.c dated around June-July 2016?  Without those patches,
> > > > > I see a panic; with them, I don't.
> > >
> > > No, we don't.  the last patch I've got in our kernel version is yours
> > > from 7-21-2014.  I'm inquiring with more experienced people to see how
> > > to address that.
> >
> > Oh... Then you really need to update.  Look at the master branch in the
> > nfc-next repo (git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git)
> 
> Those commits are in the latest ti build,
> https://git.ti.com/ti-linux-kernel/ti-linux-kernel/commits/ti-linux-4.9.y,
>  so I've built that up.

Yes, v4.9.y has everything so that's a good one to work from.

> Unfortunately bricked the board and don't
> have the dev tools to fix it with me.  Bummer, should be back into it
> tomorrow.

:(
