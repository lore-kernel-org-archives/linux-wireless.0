Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58585 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbZATWIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 17:08:16 -0500
Date: Tue, 20 Jan 2009 17:08:10 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Greg KH <greg@kroah.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Paul Hickey <paul@christianpatriot.us>,
	"stable@kernel.org" <stable@kernel.org>,
	Kyle McMartin <kyle@mcmartin.ca>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [stable] Failed Build of modules for 2.6.27.9-159
Message-ID: <20090120220810.GE17452@bombadil.infradead.org> (sfid-20090120_230822_801381_5C2DD3AA)
References: <1232319854.4596.1.camel@localhost.localdomain> <20090119191138.GA4018@tesla> <1232404986.3641.2.camel@localhost.localdomain> <20090120000336.GB4018@tesla> <1232433738.3696.3.camel@localhost.localdomain> <20090120194243.GC19581@tesla> <20090120200515.GA5077@kroah.com> <20090120201316.GG19581@tesla> <20090120201613.GA5313@kroah.com> <20090120211630.GJ19581@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090120211630.GJ19581@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 20, 2009 at 01:16:30PM -0800, Luis R. Rodriguez wrote:
> As Michael pointed out -- its tough, in fact I am not sure how to do this with
> static inlines. Advice on how to do this is welcomed. I have no clue.
> 

In this case, where a header will be providing a static inline, and you
need to provide a stub function, and you're unable to test on a typedef,
you'll have to use a weak function.

kyle@phobos ~ $ cat foo.c
#include "bar.h"
#include "compat.h"

int main(void) {
	int a = 0;

	a = foo(a);

	return a;
}

kyle@phobos ~ $ cat compat.h
int __attribute__((weak)) foo(int x);

kyle@phobos ~ $ cat bar.h
static inline int foo(int a) {
	return a;
}

kyle@phobos ~ $ cat compat.c
int __attribute__((weak)) foo(int a)
{
	return a+1;
}

kyle@phobos ~ $ gcc -Wall -O2 -o foo foo.c compat.c
kyle@phobos ~ $ ./foo
kyle@phobos ~ $ echo $?
0

Seems to work ok and not whinge about the double definition.

> > > BTW are you saying the above practice of adding new stuff to headers
> > > is OK too? I wish it wasn't...
> > 
> > Sure it's ok, distros can do whatever they want in their kernels, are
> > you telling them that they are now not allowed to do that?  :)
> 
> Heh they can do what they want, but I think it can create issues and I personally
> frown upon it. So I will at least bitch about it and maybe I'll create a bug report
> to see if it gets washed away.
> 

*sigh* I don't know, and don't really want to argue about it. ;-) People
with backports are pretty much always going to get screwed. What's the
use case for wireless-testing backports? bugfixes or new features? Could
we improve the stable process to help wireless stuff get into 2.6.$(x-1)
more easily so this won't happen in the future?

regards, Kyle
