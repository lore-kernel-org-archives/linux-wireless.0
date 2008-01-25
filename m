Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4242 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYAYUDh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 15:03:37 -0500
Date: Fri, 25 Jan 2008 14:50:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080125195037.GE14687@tuxdriver.com> (sfid-20080125_200355_477420_592DA354)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de> <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> <20080125194807.GD14687@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080125194807.GD14687@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2008 at 02:48:07PM -0500, John W. Linville wrote:

> http://kerneltrap.org/mailarchive/linux-netdev/2007/11/24/442496
> 
> Quoth Herbert Xu:
> 
> "OK.  Let me clarify this a bit more.  We require at least one
> of the following rules to be met:
> 
> * the IPv4/IPv6 header is aligned by 8 bytes on reception;
> * or the platform provides unaligned exception handlers.

> (Hmmm..."aligned by 8 bytes", so our warning and my iwlwifi patch
> may still not be right...)

http://kerneltrap.org/mailarchive/linux-netdev/2007/11/25/443558

More from Herbert:

"Sorry I was wrong about the 8 bytes requirement.  Although the
IPv6 protocol does try to maintain an 8-byte alignment the Linux
stack never does anything that requires that.

So 4 bytes is enough."

Phew!

John
-- 
John W. Linville
linville@tuxdriver.com
