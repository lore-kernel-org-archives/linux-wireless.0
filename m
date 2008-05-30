Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:45722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYE3PWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 11:22:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: suspend vs. b43
Date: Fri, 30 May 2008 17:23:23 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1212150713.4117.2.camel@johannes.berg> <200805301606.25556.mb@bu3sch.de> <1212158238.4117.4.camel@johannes.berg>
In-Reply-To: <1212158238.4117.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805301723.24192.rjw@sisk.pl> (sfid-20080530_172238_227210_3058CA3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, 30 of May 2008, Johannes Berg wrote:
> On Fri, 2008-05-30 at 16:06 +0200, Michael Buesch wrote:
> > On Friday 30 May 2008 14:31:53 Johannes Berg wrote:
> > > Since a while ago I've had trouble resuming when b43 was connected to an
> > > AP while suspended.
> > > 
> > > I did a test today where this was the only difference, but I failed to
> > > see whether ssb or b43 were causing the problem.
> > > 
> > > Does anyone have a machine with b43 in it that can suspend and supports
> > > the RTC-trace feature so we can narrow it down? Even reproducing might
> > > help to make sure it's not just something weird with my powerbook.
> > 
> > Resume is pretty broken since some time for me.
> > It sometimes works fine and sometimes just hangs with a black screen.
> > I have no idea what's going on.
> 
> Odd. Resume itself works just fine here, except when b43 is up.

I can confirm that.  It looks like a deadlock with mac80211 or something
similar to my untrained eye.

> But then again, you might not notice that this is the problem because by
> default, nothing gets printed on the resume console and then it will indeed
> hang with a black screen.

Please use "no_console_suspend", as I said in the other message.

Thanks,
Rafael
