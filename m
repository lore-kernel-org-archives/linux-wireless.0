Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1DSN5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:57:24 -0400
Subject: Re: [PATCH 1/2] staging: brcm80211: removed #ifdef __mips__
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Roland Vossen <rvossen@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <1303220960.27432.11.camel@maggie>
References: <1303197225-4263-1-git-send-email-rvossen@broadcom.com>
	 <1303197225-4263-2-git-send-email-rvossen@broadcom.com>
	 <1303215002.27432.5.camel@maggie>  <4DAD920A.9080500@broadcom.com>
	 <1303220960.27432.11.camel@maggie>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 15:57:17 +0200
Message-ID: <1303221437.3603.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-19 at 15:49 +0200, Michael Büsch wrote:
> On Tue, 2011-04-19 at 15:45 +0200, Roland Vossen wrote: 
> > Hello guys,
> > 
> > Greg, please drop this patch set. Rest of this email is FYI only.
> > 
> > Michael:
> > 
> > > Are you sure? __mips__ is automagically defined by GCC, if compiling
> > > for MIPS. Maybe it should be converted to some CONFIG_... symbol.
> > > But removal seems wrong.
> > 
> > You are right. The majority of the removed #ifdef __mips__ code has to 
> > do with write flushing. To accomplish this, it performs a R_REG after a 
> > W_REG. I assumed that writeb() and friends guarantee ordering and write 
> > flushing, but after some reading I learned that this is not the case.
> > 
> > I will rework the code and submit a new patch set.
> > 
> > For some background info: this patch was a reaction on an email from 
> > John Linville to us. John wrote:
> > 
> > <quote>
> > I took a quick run through a pull of staging from today.  I made a few
> > notes, but a lot of them would seem to relate to the utils stuff you
> > mention above.  One general comment would be that there still seems
> > to be a lot of MIPS-specific stuff buried in the code, in particular
> > a lot of "#ifdef __mips__" stuff that if necessary should at least
> > be hidden inside the W_REG macro.
> > </quote>
> 
> You should probably create a new macro W_REG_FLUSH or something like
> that, which enforces ordering by reading back the register, if required.
> That avoids ugly #ifdefs in the code.

I don't see how write flushing would be MIPS specific anyway? It's a
function of the bus (PCI), not the host architecture, no?

johannes


