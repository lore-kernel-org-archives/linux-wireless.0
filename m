Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:55765 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbZBVUSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 15:18:25 -0500
Date: Sun, 22 Feb 2009 20:18:22 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
Message-ID: <20090222201821.GA21375@silver.sucs.org> (sfid-20090222_211829_748328_7CCDF159)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org> <20090222144742.GA6078@nowhere> <20090222170201.GA27360@silver.sucs.org> <20090222171032.GD6003@nowhere> <49A1A72A.50102@gmail.com> <20090222194236.GA6060@nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090222194236.GA6060@nowhere>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2009 at 08:42:37PM +0100, Frederic Weisbecker wrote:
> On Sun, Feb 22, 2009 at 08:27:38PM +0100, Jiri Slaby wrote:
> > On 22.2.2009 18:10, Frederic Weisbecker wrote:
> >> I have some troubles with kmemcheck, so I give up for now.
> >> Well, by reading the kmemcheck documentation, it tells that there can be some false
> >> positives so...
> >
> > This has nothing to do with kmemcheck.
> >
> >> Since we are not sure this is a real bug, I'm not sure it would be interesting.
> >
> > There is no false positive possibility with these checkers, so this is  
> > pretty much interesting, because it is a bug.
> 
> 
> If so, Documentation/kmemcheck.txt really needs an update.

kmemcheck is different to the slab object lifetime debugger (which is
what reported this error). kmemcheck may have turned up in the trace
because it was compiled in (and it ties into slab/slub) but wasn't
turned on (it can be dynamically toggled via sysfs).

kmemcheck keeps a shadow of the memory and via the shadow memory it
records whether the memory has been written to yet. I believe
kmemcheck's problem is that it can't know when allocated but
uninitialised memory is being used on purpose/not really being used
(e.g. when gcc does a 32 bit read when only 16 bits have been used but
throws the upper 16 bits away). There may be other cases such as when a
previously uninitialised buffer is used but the buffer is actually used
by an mmaped device...

My understanding is that the slab debugger writes poison about the place
(e.g. to memory that has been freed and at the start/end of allocations)
and then checks to see if someone has scribbled on it. This case is more
coarse as it only deals with allocation rather than initialisation (and
if you scribble the same value as the poison pattern you go undetected)
but I believe this is what Jiri is referring to as a "no false positive
possibility" case - it's never right to write to unallocated memory.

(fixed up Bob's email address on the cc)

-- 
Sitsofe | http://sucs.org/~sits/
