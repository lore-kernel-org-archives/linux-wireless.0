Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58977 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753369AbcLNRKM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 12:10:12 -0500
Date: Wed, 14 Dec 2016 10:10:10 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Justin Bronder <justin@kuvee.com>
Subject: Re: [Patch] NFC: trf7970a:
Message-ID: <20161214171010.GA29321@animalcreek.com> (sfid-20161214_181015_808347_D31A8009)
References: <1461008921-15100-1-git-send-email-geoff@kuvee.com>
 <20160422000119.GA21754@animalcreek.com>
 <20161213220545.GA29317@animalcreek.com>
 <CAO7Z3WJwf80mCqubSYTeK=BHN9sd=mzmL9th4Su-E25de6TmAg@mail.gmail.com>
 <20161214155743.GA22282@animalcreek.com>
 <CAO7Z3WKqhS5Q6qAaDs8364KP5-7ma=b_ic2B10=njngMmp5noQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAO7Z3WKqhS5Q6qAaDs8364KP5-7ma=b_ic2B10=njngMmp5noQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2016 at 11:17:33AM -0500, Geoff Lansberry wrote:
> On Wed, Dec 14, 2016 at 10:57 AM, Mark Greer <mgreer@animalcreek.com> wrote:
> >
> > On Tue, Dec 13, 2016 at 08:50:04PM -0500, Geoff Lansberry wrote:
> > > Hi Mark -  Thanks for getting back to me.   It's funny that you ask,
> > > because we are currently chasing a segfault that is happening in neard, but
> > > may end up back in the trf7970a driver.   Have you ever heard on anyone
> > > having segfault problems related to the trf7970a hardware drivers?
> >
> > No.  Mind sharing more info on that segfault?
> >
> > > I'll get you an update later tonight or tomorrow.
> >
> > Okay, thanks.
> >
> > Mark
> > --
> 
> Mark - The segfault issue is only happening on writing, The work on
> the segfault is being done by a consultant, but here is his statement
> on how to recreate it on our build:
> 
> I am able to reliably force neard to segfault by flooding it with
> write requests. I have attached a python script called flood.py that
> can be used to do this. The script uses utilities that ship with
> neard.
> 
> The segfault does not appear deterministic. It usually happens within
> 1000 writes, but the time can varying greatly. The logs output from
> neard are inconsistent between crashes, which suggests this may be a
> timing or race condition related issue.
> 
> I have been running neard manually to obtain the log information and a
> core file for debugging (attached). I run neard as,
> 
>   $ /usr/lib/neard/nfc/neard -d -n
> 
> In a separate terminal I run,
> 
>   $ python flood.py
> 
> And the resulting core file provides the following backtrace,
> 
> (gdb) bt
> #0  0xb6caed64 in ?? ()
> #1  0x0001ed7c in data_recv (resp=0x5bd90 "", length=17, data=0x58348)
> at plugins/nfctype2.c:156
> #2  0x00024ecc in execute_recv_cb (user_data=0x5bd88) at src/adapter.c:979
> #3  0xb6e70d60 in ?? ()
> Backtrace stopped: previous frame identical to this frame (corrupt stack?)
> (gdb)
> 
> The line at nfctype2.c:156 contains a memcpy operation.

Thanks Geoff.

What are the values of the arguments to memcpy()?

I will look at it later today/tomorrow but if you have another NFC device
to test with, it would help isolate whether it is neard or the trf7970a
driver.  The driver shouldn't be able to make neard crash like this but
who knows.

You could also try testing older versions of neard to see if they also
fail and if not, start bisecting from there.  Maybe test a different
tag type too.

Mark
--
