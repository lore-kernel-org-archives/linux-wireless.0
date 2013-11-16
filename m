Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from order.stressinduktion.org ([87.106.68.36]:46569 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3KPHka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Nov 2013 02:40:30 -0500
Date: Sat, 16 Nov 2013 08:40:29 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Kees Cook <keescook@chromium.org>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Daniel Borkmann <dborkman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	shemminger@networkplumber.org, Florian Weimer <fweimer@redhat.com>,
	netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] random: seed random_int_secret at least poorly at core_initcall time
Message-ID: <20131116074029.GA16541@order.stressinduktion.org> (sfid-20131116_084036_163114_8EA93D38)
References: <cover.1384160397.git.dborkman@redhat.com> <2ea03f60bb65429cbe5d74a6d356fde3eefcf06c.1384160397.git.dborkman@redhat.com> <20131111134357.GC10104@thunk.org> <20131112000307.GB14929@order.stressinduktion.org> <20131112115350.GA14077@thunk.org> <20131112131627.GD14929@order.stressinduktion.org> <20131112134603.GE14929@order.stressinduktion.org> <20131114025448.GB31602@thunk.org> <20131114041829.GA26901@order.stressinduktion.org> <CAGXu5jJJtjvAqROzsekOd9Y5wbiw=G9ToNryOfP8auhQRrYORw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGXu5jJJtjvAqROzsekOd9Y5wbiw=G9ToNryOfP8auhQRrYORw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 15, 2013 at 10:42:28AM -0800, Kees Cook wrote:
> On Wed, Nov 13, 2013 at 8:18 PM, Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
> > On Wed, Nov 13, 2013 at 09:54:48PM -0500, Theodore Ts'o wrote:
> >> On Tue, Nov 12, 2013 at 02:46:03PM +0100, Hannes Frederic Sowa wrote:
> >> > > It is needed by fork to set up the stack canary. And this actually gets
> >> > > called before the secret is initialized.
> >> >
> >> > Maybe we could use this for the time being and use the seeding method
> >> > of kaslr as soon as it hits the tree?
> >>
> >> Hmm, from what I can tell even early_initcall() is going to be early
> >> enough.  The stack canary is set up by boot_init_stack_canary(), which
> >> is run very, very early in start_kerne() --- way before
> >> early_initcalls, or even before interrupts are enabled.  So adding
> >> random_int_secret_init_early() as a core_initcall is still too late.
> >
> > Actually I tried to protect the tsk->stack_canary = get_random_int()
> > in fork.c. It sets up the per-task canary.
> 
> I haven't looked closely yet at how the stack canary gets plumbed, but
> what do things outside of process context end up using?

Early on boot __stack_chk_guard gets initialized. The address of this symbol
is looked up by gcc to assemble the stack guard checks.

Only on ARM with !CONFIG_SMP the __stack_chk_guard is switched as soon
as a new process context is entered. This is not possible if the kernel
is compiled for CONFIG_SMP and the kernel will fallback to the one global
__stack_chk_guard canary.

