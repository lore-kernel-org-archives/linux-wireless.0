Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43060 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752540AbZC3UwT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 16:52:19 -0400
Date: Mon, 30 Mar 2009 17:52:15 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dirk Opfer <Dirk@opfer-online.de>,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090330205215.GD23749@khazad-dum.debian.net> (sfid-20090330_225222_863819_248BA58B)
References: <1238349195.24972.5.camel@johannes.local> <1238406057.24972.23.camel@johannes.local> <200903301039.52153.inaky@linux.intel.com> <1238435143.5970.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238435143.5970.21.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Mar 2009, Johannes Berg wrote:
> On Mon, 2009-03-30 at 10:39 -0700, Inaky Perez-Gonzalez wrote:
> > On Monday 30 March 2009, Johannes Berg wrote:
> > >
> > >  * wimax
> > >    -> need help, seems to report rfkill states to input device?
> > >       don't understand
> > 
> > Not really. 
> > 
> > What it does is if the device exposes a hw rfkill key, export that 
> > key as an input device, as well as using it to report the state
> > change. 
> > 
> > So there are three main entry points:
> > 
> > wimax_report_rfkill_hw() -- device driver report to stack
> >   
> >    device reports a change in the hw rfkill key; switch the radio to
> >    whichever state AND report a key event through the input layer
> 
> But reporting the key through the input layer is wrong, afaict.

Reporting the key through the input layer is correct if, and _only_ if, it
is REALLY a button/key, AND nothing else is doing it.

It is NOT to be done in anything that could be, for example, an input pin
that is tied to a GPIO output in the embedded controller of a laptop that
will be driven by a platform driver.

And if it could be both and you can't be certain, you need dmi whitelisting
or a module parameter to know which one.  And default to NOT issuing input
events.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
