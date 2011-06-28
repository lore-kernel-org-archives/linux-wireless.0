Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51585 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab1F1UUs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 16:20:48 -0400
Date: Tue, 28 Jun 2011 13:01:59 -0700
From: Greg KH <greg@kroah.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: Jonas Gorski <jonas.gorski@gmail.com>, gregkh@suse.de,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 12/21] staging: brcm80211: use __BIG_ENDIAN macro in dma.c
Message-ID: <20110628200159.GA26277@kroah.com> (sfid-20110628_222051_891894_EA4FC065)
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
 <1307630701-9170-13-git-send-email-rvossen@broadcom.com>
 <BANLkTi=GGsW4eja0QunMAc5vqqFkmvNxNA@mail.gmail.com>
 <4DF1E973.1030709@broadcom.com>
 <BANLkTi=2d+5UjAnQVatapObA_GuHXzpG3A@mail.gmail.com>
 <20110614175220.GF9280@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110614175220.GF9280@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2011 at 10:52:20AM -0700, Henry Ptasinski wrote:
> On Fri, Jun 10, 2011 at 04:17:04AM -0700, Jonas Gorski wrote:
> > Hi Arend,
> > 
> > On 10 June 2011 11:52, Arend van Spriel <arend@broadcom.com> wrote:
> > > Hi Jonas,
> > >
> > > You are right as with previous mips related patches. Consider this a first
> > > step which does not change functionality but aims to use the proper linux
> > > provided macros instead of our own incarnations.
> > 
> > Actually as far as I can tell this changes (non-)functionality: With
> > the broken big endiness check the driver probably just doesn't work
> > properly on MIPS BE systems, because some endianess conversion is
> > missing*. With the endianess check fixed, the special handling for the
> > Broadcom MIPS get's enabled, potentially crashing the system (or
> > changing random registers), thus making it *more* broken for non BMIPS
> > systems. Therefore I'd rather consider this a regression. Especially
> > since (AFAIK) the BMIPS systems that can take advantage of this aren't
> > supported in Linux (yet).
> > 
> > If it were just making things less efficient, I wouldn't be
> > complaining (at least not that much ;-). If you can say that this is a
> > code path that isn't taken anyway, then my point is moot (for now). I
> > don't know the driver enough to tell that.
> > 
> > Jonas
> > 
> > *assuming brcm80211 depends on this on BE systems and it isn't just an
> > optimization
> 
> 
> Greg,
> 
> Can you drop this patch and take the rest in the series?  The other patches
> don't depend on this one.

Will do.
