Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab2IGIUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:20:45 -0400
Message-ID: <1347006078.4256.6.camel@jlt4.sipsolutions.net> (sfid-20120907_102050_673811_2C99503D)
Subject: Re: [PATCH/RFC] rfkill: prevent unnecessary event generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Vitaly Wool <vitaly.wool@sonymobile.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 10:21:18 +0200
In-Reply-To: <CAMJBoFMd2sLEScY3j2-wsWQh3Mv_nArPC904dzJ+j-16+pdkgQ@mail.gmail.com> (sfid-20120907_085419_412505_9AEB3D7E)
References: <5048ADFC.1010708@sonymobile.com>
	 <20120906224448.GA16676@khazad-dum.debian.net>
	 <CAMJBoFMd2sLEScY3j2-wsWQh3Mv_nArPC904dzJ+j-16+pdkgQ@mail.gmail.com>
	 (sfid-20120907_085419_412505_9AEB3D7E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 08:54 +0200, Vitaly Wool wrote:
> Hi Henrique,
> 
> On Fri, Sep 7, 2012 at 12:44 AM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> >
> > On Thu, 06 Sep 2012, Vitaly Wool wrote:
> > > Prevent unnecessary rfkill event generation when the state has
> > > not actually changed. These events have to be delivered to
> > > relevant userspace processes, causing these processes to wake
> > > up and do something while they could as well have slept. This
> > > obviously results in more CPU usage, longer time-to-sleep-again
> > > and therefore higher power consumption.
> >
> > Could this supress the first event when a switch is registered? Would that
> > be a concern?
> 
> I'm not sure I got your question, but just in case, rfkill is
> initialized to all zeroes so rfkill->state is 0 and on each consequent
> _real_ change there (prev != curr) == true and the event will be
> generated.

But maybe applications were expecting an event for registration? Or do
we get that anyway maybe?

johannes

