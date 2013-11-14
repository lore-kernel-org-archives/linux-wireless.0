Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58347 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3KNCzD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 21:55:03 -0500
Date: Wed, 13 Nov 2013 21:54:48 -0500
From: Theodore Ts'o <tytso@mit.edu>
To: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net,
	shemminger@networkplumber.org, fweimer@redhat.com,
	netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
	linux-wireless@vger.kernel.org, keescook@chromium.org
Subject: Re: [PATCH] random: seed random_int_secret at least poorly at
 core_initcall time
Message-ID: <20131114025448.GB31602@thunk.org> (sfid-20131114_035511_639098_449751A4)
References: <cover.1384160397.git.dborkman@redhat.com>
 <2ea03f60bb65429cbe5d74a6d356fde3eefcf06c.1384160397.git.dborkman@redhat.com>
 <20131111134357.GC10104@thunk.org>
 <20131112000307.GB14929@order.stressinduktion.org>
 <20131112115350.GA14077@thunk.org>
 <20131112131627.GD14929@order.stressinduktion.org>
 <20131112134603.GE14929@order.stressinduktion.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131112134603.GE14929@order.stressinduktion.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 02:46:03PM +0100, Hannes Frederic Sowa wrote:
> > It is needed by fork to set up the stack canary. And this actually gets
> > called before the secret is initialized.
> 
> Maybe we could use this for the time being and use the seeding method
> of kaslr as soon as it hits the tree?

Hmm, from what I can tell even early_initcall() is going to be early
enough.  The stack canary is set up by boot_init_stack_canary(), which
is run very, very early in start_kerne() --- way before
early_initcalls, or even before interrupts are enabled.  So adding
random_int_secret_init_early() as a core_initcall is still too late.

I wonder if we need to do something in common with what Kees has been
considering for the kaslr code, since it's a similar issue --- we need
random number way earlier than we can really afford to initialize
/dev/random.

						- Ted

P.S.  Unless I'm missing something (and I hope I am), it would appear
that the stack canary is going to easily predictable by an attacker on
non-x86 platforms that don't have RDRAND.  Has someone tested whether
or not the stack canary isn't constant across ARM or pre-Sandy Bridge
x86 systems?

