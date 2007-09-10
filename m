Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756814AbXIJMON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 08:14:13 -0400
Date: Mon, 10 Sep 2007 13:14:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
Subject: Re: COMMON symbol warnings
Message-ID: <20070910121410.GA5948@infradead.org>
References: <1189100314.28781.112.camel@johannes.berg> <20070908130118.GA11648@infradead.org> <1189422492.4506.54.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1189422492.4506.54.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 10, 2007 at 01:08:12PM +0200, Johannes Berg wrote:
> On Sat, 2007-09-08 at 14:01 +0100, Christoph Hellwig wrote:
> 
> > Yes.  It means a variable is declared in multiple places and the linker
> > merges it for you.  The fix is to make sure these are declared extern in
> > all places but one.
> 
> Interesting. So it's missing in a header file but sparse doesn't warn
> about it like it does with functions that aren't declared nor static?

No.  Say you have the following case:

----------- foo.h ------------
int foo;
----------- foo1.c -----------
#include "foo.h"
----------- foo2.c -----------
#include "foo.h"
--------- Makefile -----------
obj-m += foo.o
foo-y += foo1.o foo2.o


This gives you a foo COMMON symbol.  But at least on i386 the kernel
is compiled with -fno-common so you get a warning like:

/home/hch/test/foo1.o:(.bss+0x0): multiple definition of `foo'
/home/hch/test/foo2.o:(.bss+0x0): first defined here

When adding -fcommon to EXTRA_FLAGS I get what you saw in this thread:

WARNING: "foo" [/home/hch/test/foo] is COMMON symbol

I wonder how the driver build managed to override our global -fno-common
setting.
