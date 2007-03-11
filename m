Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56352
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXCKUbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 16:31:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: wireless extensions vs. 64-bit architectures
Date: Sun, 11 Mar 2007 21:30:05 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>, jt@hpl.hp.com,
	Jouni Malinen <jkm@devicescape.com>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>, Dan Williams <dcbw@redhat.com>
References: <20070307020310.GA20466@bougret.hpl.hp.com> <1173634801.3382.8.camel@johannes.berg> <20070311201148.GA25938@p15091797.pureserver.info>
In-Reply-To: <20070311201148.GA25938@p15091797.pureserver.info>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703112130.05717.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 March 2007 21:11, Ulrich Kunitz wrote:
> > I'm still not convinced that papering over the problem in userspace is a
> > real solution.
> > 
> > johannes
> 
> Just my 2 cents. I support this. What are the options? I see only
> two:
> 
> 1. Use different magic numbers for 32 bit and 64 bit structures. A
>    flag is an alternative, but will be more difficult to debug.
>    Generation of the magic should be easy, use sizeof(unsigned
>    long) as test. User space has to care than for the rest.
> 
> 2. Make the data representation identical in 32 bit and 64 bit.
> 
>    This shouldn't be to difficult, if only u8, u16 and u32 types
>    are used.

>    Pointers should be given as offsets.

Offsets to what?

>    If necessary  
>    align and/or packed attributes could be used.
> 
> If the kernel interface can be changed, I vote for option 2,
> because user space has then to deal with a unique data layout.
> If the wext kernel interface cannot be changed to maintain
> backward compatibility, then I have to admit band-aids in user
> space are needed. However cfg80211 must not suffer from the same issues.

All your suggestions break the userspace ABI on all machines,
which is a thing we _really_ want to avoid.

The right fix is to have a compatibility wrapper in the kernel,
but it turns out to be hard to implement. I don't think we want
to change the structures layout and break ABI.

-- 
Greetings Michael.
