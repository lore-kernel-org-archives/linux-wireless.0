Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58871 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3KOVFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 16:05:33 -0500
Date: Fri, 15 Nov 2013 16:05:20 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: Kees Cook <keescook@chromium.org>
Cc: Daniel Borkmann <dborkman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	shemminger@networkplumber.org, Florian Weimer <fweimer@redhat.com>,
	netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] random: seed random_int_secret at least poorly at
 core_initcall time
Message-ID: <20131115210520.GA16722@thunk.org> (sfid-20131115_220539_130076_BBBF5B1E)
References: <cover.1384160397.git.dborkman@redhat.com>
 <2ea03f60bb65429cbe5d74a6d356fde3eefcf06c.1384160397.git.dborkman@redhat.com>
 <20131111134357.GC10104@thunk.org>
 <20131112000307.GB14929@order.stressinduktion.org>
 <20131112115350.GA14077@thunk.org>
 <20131112131627.GD14929@order.stressinduktion.org>
 <20131112134603.GE14929@order.stressinduktion.org>
 <20131114025448.GB31602@thunk.org>
 <CAGXu5j+ySEdQBXKkspYC=svfekBja2Z_2tcWSAOEbvyiMLf=aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5j+ySEdQBXKkspYC=svfekBja2Z_2tcWSAOEbvyiMLf=aA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 15, 2013 at 10:33:04AM -0800, Kees Cook wrote:
> 
> When the static stack canary was mentioned during the ARM summit, I
> dug around a little bit and saw that at very early boot, yes, it was
> always the same, but after boot finished, it was different from boot
> to boot. I didn't get far enough to figure out what was changing it
> later on.

I've been in Seoul this past week, so I haven't had a chance look more
closely at this, but what's not clear to me what the impact will be of
having a static statck canary during early boot.  Does that mean the
stack canary for the certain kernel threads and the pid 1 are always
constant, since their stacks are getting set up before we're actually
able to initialize the stack canary with something random?

     		       	     	    	 - Ted
