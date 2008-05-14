Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47100 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbYENBDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 21:03:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] b43: use the bitrev helpers rather than rolling a private one
Date: Wed, 14 May 2008 03:03:23 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1210708518.6191.0.camel@brick> <200805140124.07982.mb@bu3sch.de> <1210726437.6191.17.camel@brick>
In-Reply-To: <1210726437.6191.17.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805140303.23590.mb@bu3sch.de> (sfid-20080514_030351_913467_1DF912F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 May 2008 02:53:56 Harvey Harrison wrote:
> On Wed, 2008-05-14 at 01:24 +0200, Michael Buesch wrote:
> > On Tuesday 13 May 2008 21:55:18 Harvey Harrison wrote:
> > > The 4-bit reversal flip_4bit is replaced with the bitrev helper
> > > bitrev8 and a 4-bit shift.  The B43_WARN is moved to the location
> > > where a register is read from for checking there.  The other caller
> > > explicitly passes an array index which is guaranteed to be within range
> > > and so a B43_WARN is not added there.
> > > 
> > > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > ACK
> > 
> > But I'd prefer if we had something like the following
> > and use that:
> > 
> > #define bitrev4(x)	(bitrev8(x) >> 4)
> > 
> > This way the confusing (confusing to me :) ) shifts in the code would go away.
> > I have a hard time realizing that
> > bitrev8(x) >> 3
> > does actually mean
> > bitrev4(x) << 1
> > Maybe I'm just stupid, though. :)
> > 
> 
> You're not, this was only valid because x < 16....if bit 4 could be set
> this doesn't work anymore as bitrev8(x) >> 4 would truncate bit 4
> before shifting left.  So there was some subtlety here that makes >> 3
> ok.

I don't understand. These are all 4 bit values.
The old flip helper enforced this with a B43_WARN_ON().

The >>3 actually is

((bitrev8(x) >> 4) << 1)
which is the same as
(bitrev4(x) << 1)

The <<1 is there, because the hardware wants is this way in the register.
The <<1 is not related to the actual flip operation.

> Do you want an incremental patch adding a bitrev4 to phy.c or are you
> going to add it?

Can you just respin this one instead of doing an incremental one?

-- 
Greetings Michael.
