Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60919
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbYFDPC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:02:58 -0400
Date: Wed, 04 Jun 2008 08:02:37 -0700 (PDT)
Message-Id: <20080604.080237.66646394.davem@davemloft.net> (sfid-20080604_170300_777047_D47F0333)
To: dwmw2@infradead.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kirill@shutemov.name
Subject: Re: [PATCH] wireless.h: improve userland include-ability
From: David Miller <davem@davemloft.net>
In-Reply-To: <1212587529.32207.82.camel@pmac.infradead.org>
References: <1212515497-21578-1-git-send-email-linville@tuxdriver.com>
	<20080603.120515.193703574.davem@davemloft.net>
	<1212587529.32207.82.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 04 Jun 2008 14:52:09 +0100

> On Tue, 2008-06-03 at 12:05 -0700, David Miller wrote:
> > Yeah, go check so me magic userspace tool header to see what magic is
> > needed just to include a core networking header file correctly.
> > 
> > No, thanks.
> 
> Just to clarify: this is only a problem for userspace, and you're
> objecting to that?

Yes.

> I'm happy enough to change that, but it means seeing stuff like...
> 	#ifndef __KERNEL__
> 	#include <sys/foo.h>
> 	#endif 
> ... in kernel headers. Is that what you're intending, or am I
> misunderstanding your objection?

I think this kind of construct shouldn't be necessary in the first
place.

> I believe that the main reason for this patch was that <linux/socket.h>
> and <linux/if.h> both have problems when you include them in the same C
> file as the 'proper' glibc equivalent? Is that something we can address,
> instead of just dropping those includes?

You will need to find a way to make it work cleanly if you want
me to take the change in :-)
