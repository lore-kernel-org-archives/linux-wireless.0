Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3826 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbXLUO24 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 09:28:56 -0500
Date: Fri, 21 Dec 2007 09:13:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Michael Buesch <mb@bu3sch.de>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211: rc algos broken
Message-ID: <20071221141307.GB19874@tuxdriver.com> (sfid-20071221_142900_155379_39C61C99)
References: <200712202020.51320.mb@bu3sch.de> <200712202035.45909.mb@bu3sch.de> <20071220215150.3ffcafbe@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071220215150.3ffcafbe@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 20, 2007 at 09:51:50PM +0100, Stefano Brivio wrote:
> On Thu, 20 Dec 2007 20:35:45 +0100
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > Grepping the code it seems that nobody is ever calling
> > ieee80211_rate_control_register(). I guess that it kind of a fatal problem. ;)
> 
> Indeed. Really sorry for the breakage, I'm fixing that in a bit.

Stefano,

Thanks for the patches.  I mostly adopted your patch 2/2, but then
I did some Kconfig/Makefile hacking on top.  What I have merged
keeps the rc algorithms built into the mac80211 module instead of
their own modules.  You can include either or both of simple and
pid to be included, or neither if EMBEDDED.  And of course you can
select the default, which is also modifiable via a module option.
I think this is simpler than the other options, and it gets the tree
working again.  I'm still open to some options for building one or
both of the algorithms as a module, but that can be worked-out later.

I have folded my changes back into your patches for the push to davem.
On the 'everything' branch I just included one fix-up patch to minimize
disruption to the 'git pull' developers. :-)  That is currently the
head of the everything branch -- please take a look at it for details
of what I have changed versus your patches.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
