Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33949 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYFDNwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 09:52:13 -0400
Subject: Re: [PATCH] wireless.h: improve userland include-ability
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kirill@shutemov.name
In-Reply-To: <20080603.120515.193703574.davem@davemloft.net>
References: <1212515497-21578-1-git-send-email-linville@tuxdriver.com>
	 <20080603.120515.193703574.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 14:52:09 +0100
Message-Id: <1212587529.32207.82.camel@pmac.infradead.org> (sfid-20080604_155219_719826_F1767E86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-03 at 12:05 -0700, David Miller wrote:
> Yeah, go check so me magic userspace tool header to see what magic is
> needed just to include a core networking header file correctly.
> 
> No, thanks.

Just to clarify: this is only a problem for userspace, and you're
objecting to that? Just including <linux/wireless.h> within the kernel
will continue to work.

We've traditionally got away with saying 'caveat emptor' when userspace
includes kernel headers -- you _have_ to include the right
prerequisites, because the kernel doesn't do it for you.

I'm happy enough to change that, but it means seeing stuff like...
	#ifndef __KERNEL__
	#include <sys/foo.h>
	#endif 
... in kernel headers. Is that what you're intending, or am I
misunderstanding your objection?

I believe that the main reason for this patch was that <linux/socket.h>
and <linux/if.h> both have problems when you include them in the same C
file as the 'proper' glibc equivalent? Is that something we can address,
instead of just dropping those includes?

-- 
dwmw2

