Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:51166 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab1CWOJq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 10:09:46 -0400
Subject: Re: [RFC] drivers: brcmaxi: provide amba axi functionality in
 separate module
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	"george@znau.edu.ua" <george@znau.edu.ua>,
	"zajec5@gmail.com" <zajec5@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <op.vsst8mfl3ri7v4@arend-laptop> (sfid-20110323_145439_175877_7D16E3D0)
References: <1300738586-7157-1-git-send-email-arend@broadcom.com>
	 <1300738586-7157-2-git-send-email-arend@broadcom.com>
	 <20110321132848.e4e846a5.rdunlap@xenotime.net>
	 <op.vsslrqf23ri7v4@arend-laptop> <1300888183.18815.5.camel@Nokia-N900>
	 <op.vsst8mfl3ri7v4@arend-laptop> (sfid-20110323_145439_175877_7D16E3D0)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 15:09:34 +0100
Message-ID: <1300889374.20830.1.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-23 at 14:54 +0100, Arend van Spriel wrote: 
> On Wed, 23 Mar 2011 14:49:43 +0100, Michael Büsch <mb@bu3sch.de> wrote:
> 
> >
> >> void foobar(void *r, u32 val)
> >> {
> >>     volatile u32 dummy;
> >>
> >>     WR_REG(r, val);
> >>     dummy = RD_REG(r);
> >> }
> >>
> >> The register read is necessary to assure the register write is properly
> >> flushed out in hardware. Could removing the volatile for the dummy
> >> variable cause removal of the register read due to code optimization.
> >
> > It shouldn't optimize the read away as long as the RD_REG uses a  
> > volatile pointer internally. Which is the case if you use readl/w/b or  
> > ioread... to implement RD_REG
> 
> Well, RD_REG(r) is a macro which translates to readb((volatile u8*)r). Are  
> you referring to that being a volatile pointer or do you mean that inside  
> the accessor function readb the 'r' parameter is treated as a volatile  
> pointer.

readb uses volatile internally. That should be enough to ensure that
the read does actually happen.

-- 
Greetings Michael.

