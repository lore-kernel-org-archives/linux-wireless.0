Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52379 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752982AbdBIV1I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Feb 2017 16:27:08 -0500
Date: Thu, 9 Feb 2017 14:27:06 -0700
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
Message-ID: <20170209212706.GA26734@animalcreek.com> (sfid-20170209_222712_356432_7EEBFEAD)
References: <20161214171010.GA29321@animalcreek.com>
 <CAO7Z3WLpp0YVxXxo6M11PMPu+5OaA1fRhNQNoPJ-b4LRCPrLAg@mail.gmail.com>
 <20161214223123.GA10281@animalcreek.com>
 <20161216045210.GA29196@animalcreek.com>
 <20161216203538.GA12608@animalcreek.com>
 <CAO7Z3W+grhLnP05bPShheuvSet08CoYhFStDpDVgztf=Wz42Fw@mail.gmail.com>
 <20161219030733.GA14962@animalcreek.com>
 <20170208225339.GA26286@animalcreek.com>
 <20170208225651.GB26286@animalcreek.com>
 <CAO7Z3WKxXz1SsvOH8v5Xvy0jSdw1-NU_zXyu0QakR3UHnYgrqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAO7Z3WKxXz1SsvOH8v5Xvy0jSdw1-NU_zXyu0QakR3UHnYgrqA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 09, 2017 at 10:54:08AM -0500, Geoff Lansberry wrote:
> On Wed, Feb 8, 2017 at 5:56 PM, Mark Greer <mgreer@animalcreek.com> wrote:
> >
> > I just realized that the linux-nfc is not CC'd so adding it.
> >
> > On Wed, Feb 08, 2017 at 03:53:39PM -0700, Mark Greer wrote:
> > > On Sun, Dec 18, 2016 at 08:07:33PM -0700, Mark Greer wrote:
> > > > On Sat, Dec 17, 2016 at 04:19:04PM -0500, Geoff Lansberry wrote:
> > > > > Mark,   from our consultant:
> > > > >
> > > > > It isn't important whether the flood script is successful in writing
> > > > > or not. The point of it is to force a segfault by making many
> > > > > requests. It needs to run for several hundred iterations (successful
> > > > > or not) in order to generate the segfault.
> > > >
> > > > So neard crashes even when the write fails??  Okay, I'll let it run for
> > > > a while tomorrow (Monday).
> > >
> > > [Okay, so not exactly "tomorrow" but I did get back to this.]
> > >
> > > Geoff, a few things:
> > >
> > > 1) Any update on these issues?
> 
> Yes - I've discovered the primary trigger of my problems.  I'm using
> some very small tags from Murata, and they don't have a strong signal.
> Sometimes when writing, the tags can get corrupted data written to
> them. When the tag is verified by re-reading it, neard bails out
> because it finds non-utf8 characters.  So far I have found it
> impossible to rewrite a tag once it has been mal-formed.

Okay, that's interesting.  neard still shouldn't bail out so we'll
have to look at that.

> > > 2) Do you have all of the NFC-related patches from the nfc-next master
> > > branch?  In particular, do you have all of Thierry's patches to
> > > net/nfc/digial_*.c dated around June-July 2016?  Without those patches,
> > > I see a panic; with them, I don't.
> 
> No, we don't.  the last patch I've got in our kernel version is yours
> from 7-21-2014.  I'm inquiring with more experienced people to see how
> to address that.

Oh... Then you really need to update.  Look at the master branch in the
nfc-next repo (git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git)

Which kernel version are you using?  If its old, you should update to the
most recent version that you can.  If you *absolutely* can't use a newer
kernel, let me know as I may be able to help.

Also, be sure to use the latest version of neard (currently 0.16).

> > > 3) Assuming you have all of those patches, please revert the one with the
> > > summary line of, "NFC: digital: Set the command pending flag", and tell me
> > > if that stops the "Bogus state" messages.  I don't know which repo/branch
> > > you're using so I can't provide a commit id.
> 
> No to the patches, but I found the commit you are talking about and
> will look at it.   Maybe possible to cherry pick it.

No, don't cherry-pick it.  I was asking you to revert that commit.
Ignore this request for now because the commit is fine, it just seemed
to cover up the issue so I wanted to see if it did for you too.  I will
dig into it more once I finish setting up a new SDCard for my test system
(and get some time to look at it).

Mark
--
