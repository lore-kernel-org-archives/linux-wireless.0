Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:47190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYE3VTN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 17:19:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 23:19:33 +0200
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1212150713.4117.2.camel@johannes.berg> <200805301720.49327.rjw@sisk.pl> <1212162163.7238.1.camel@johannes.berg>
In-Reply-To: <1212162163.7238.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805302319.34173.rjw@sisk.pl> (sfid-20080530_231917_353524_900255C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, 30 of May 2008, Johannes Berg wrote:
> On Fri, 2008-05-30 at 17:20 +0200, Rafael J. Wysocki wrote:
> > On Friday, 30 of May 2008, Johannes Berg wrote:
> > > On Fri, 2008-05-30 at 16:42 +0200, Michael Buesch wrote:
> > > > On Friday 30 May 2008 16:37:18 Johannes Berg wrote:
> > > > > Odd. Resume itself works just fine here, except when b43 is up. But then
> > > > > again, you might not notice that this is the problem because by default,
> > > > > nothing gets printed on the resume console and then it will indeed hang
> > > > > with a black screen.
> > > > 
> > > > How can I change the printing?
> > > 
> > > Hmm. It seems I might have been wrong here. Rafael, do we still have
> > > console suspend stuff?
> > 
> > Yes, we do.  Use "no_console_suspend" in the kernel command line to change
> > that, but note that it's not generally safe (eg. if you are using netconsole at
> > the same time).
> 
> I see. System reset hard and clock set to 1904, PMU didn't like me :)
> 
> Thing is, I do have no_console_suspend (hardcoded in my boot loader
> config so I forgot), but even with PM-debug I didn't see it hang at b43
> and no useful messages. Not sure what to do, hence asking if anybody has
> the rtc-trace stuff.

It hangs for me either at read_unlock_irqrestore() in b43_op_tx() or somewhere
in ieee80211_tx() (at various places).

Thanks,
Rafael
