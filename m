Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:44482 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933059AbXCHTCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 14:02:32 -0500
Date: Thu, 8 Mar 2007 20:02:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	linux-sparse@vger.kernel.org
Subject: Re: sparse using insane amounts of memory
Message-ID: <20070308190241.GA9792@uranus.ravnborg.org>
References: <1173319356.3546.54.camel@johannes.berg> <1173375270.15842.24.camel@dv> <1173375791.3248.37.camel@johannes.berg> <200703081908.40997.IvDoorn@gmail.com> <Pine.LNX.4.64.0703081023490.10832@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <Pine.LNX.4.64.0703081023490.10832@woody.linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> You can then make it a compile-time failure with something like
> 
> 	extern unsigned int this_doesnt_exist_and_wont_link;
> 
> 	is_contiguous_mask(x) ? (x) : this_doesnt_exist_and_wont_link;
> 
> which returns "x" if it's ok, and an unlinkable expression if it isn't.

Or you can use the already defined macros in kernel.h for this:

/* Force a compilation error if condition is true */
#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))

/* Force a compilation error if condition is true, but also produce a
   result (of value 0 and type size_t), so the expression can be used
   e.g. in a structure initializer (or where-ever else comma expressions
   aren't permitted). */
#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)

	Sam
