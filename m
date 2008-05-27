Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:50546 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYE0Eh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 00:37:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
Date: Tue, 27 May 2008 14:37:22 +1000
Cc: Michal Schmidt <mschmidt@redhat.com>,
	Daniel Walker <dwalker@mvista.com>, linville@tuxdriver.com,
	mingo@elte.hu, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, arjan@infradead.org
References: <20080522232103.120033152@mvista.com> <200805271117.23051.rusty@rustcorp.com.au> <20080527021503.GH30894@parisc-linux.org>
In-Reply-To: <20080527021503.GH30894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805271437.23114.rusty@rustcorp.com.au> (sfid-20080527_063802_062614_A91B0F4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 May 2008 12:15:03 Matthew Wilcox wrote:
> On Tue, May 27, 2008 at 11:17:22AM +1000, Rusty Russell wrote:
> > On Tuesday 27 May 2008 03:29:14 Michal Schmidt wrote:
> > > Mutexes are not allowed in interrupt context, not even mutex_trylock.
> >
> > As an aside, does anyone know why?  I know the documentation says so, but
> > it wasn't immediately obvious to me.  I asked before to no response...
>
> Because mutexes have an owner.  In interrupt context, there is no owner.
> This owner is used to do priority boosts as well as debugging.

Shows how little I know, I didn't see priority boosting in my glance thru 
mutex.c.

But it seems like mutex_trylock_irq would be easy to add if needed, if only 
for clarity.

Thanks!
Rusty.
