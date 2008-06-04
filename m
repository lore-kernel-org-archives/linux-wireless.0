Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27624 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbYFDPYS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:24:18 -0400
Subject: Re: [PATCH] wireless.h: improve userland include-ability
From: Pavel Roskin <proski@gnu.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, kirill@shutemov.name
In-Reply-To: <1212587529.32207.82.camel@pmac.infradead.org>
References: <1212515497-21578-1-git-send-email-linville@tuxdriver.com>
	 <20080603.120515.193703574.davem@davemloft.net>
	 <1212587529.32207.82.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 11:24:15 -0400
Message-Id: <1212593055.13964.15.camel@dv> (sfid-20080604_172421_090871_D7894EE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 14:52 +0100, David Woodhouse wrote:
> On Tue, 2008-06-03 at 12:05 -0700, David Miller wrote:
> > Yeah, go check so me magic userspace tool header to see what magic is
> > needed just to include a core networking header file correctly.
> > 
> > No, thanks.
> 
> Just to clarify: this is only a problem for userspace, and you're
> objecting to that? Just including <linux/wireless.h> within the kernel
> will continue to work.
> 
> We've traditionally got away with saying 'caveat emptor' when userspace
> includes kernel headers -- you _have_ to include the right
> prerequisites, because the kernel doesn't do it for you.

That's true, and several programs do it already.  Changing the includes
would require changes in those programs.  Besides, sys/types.h is still
included, so it's a half-measure.  If we are going to break things,
let's go all the way and disable sys/types.h for userspace, and possibly
some structures that the userspace is not supposed to be using.  But I'm
afraid there is still a lot of stuff the userspace should know,
including IFNAMESIZ.  Alternatively, let's sanitize other headers so
that they can be mixed with libc headers with no consequences.

Hand picking which headers to include in userspace reeks of a hack meant
to satisfy special needs of some userspace software, while risking to
break other userspace code.

Finally, wireless extensions are not under development.  If should be
perfectly safe to take the latest wireless.h, copy it to the userspace
program and rearrange the headers to the heart's content.

> I believe that the main reason for this patch was that <linux/socket.h>
> and <linux/if.h> both have problems when you include them in the same C
> file as the 'proper' glibc equivalent? Is that something we can address,
> instead of just dropping those includes?

I don't see such problems in my software, but if others do, they may be
in a better position to suggest patches.

-- 
Regards,
Pavel Roskin
