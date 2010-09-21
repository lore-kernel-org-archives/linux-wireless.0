Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:40609 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab0IUWGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 18:06:47 -0400
Date: Tue, 21 Sep 2010 23:34:51 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Patch to get iw building on Fedora 8
Message-ID: <20100921213451.GA29134@sig21.net>
References: <4C98DFB6.10902@candelatech.com>
 <m2wrqej2qk.fsf@igel.home>
 <4C991F25.1000102@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C991F25.1000102@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 21, 2010 at 02:09:57PM -0700, Ben Greear wrote:
> On 09/21/2010 12:49 PM, Andreas Schwab wrote:
> >Ben Greear<greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>  writes:
> >
> >>I need this in order to get iw to build on Fedora 8.
> >>
...
> >>+#define  __USE_ISOC99
> >
> >This is wrong.  You must never define internal glibc macros.
> 
> How about this then?
...
> -                       tmpf = strtof(argv[i], &end);
> +                       tmpf = strtod(argv[i], &end);
... 
> Seems you don't have to do anything clever to get strtod to work,
> and I assume it should cast just fine.

I think to use C99 features like strtof() you need to either
add -std=c99 to CFLAGS, or #define _ISOC99_SOURCE
(see /usr/include/features.h).

HTH,
Johannes
