Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965401Ab2CPPQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 11:16:24 -0400
Subject: Re: [PATCH] iwlwifi: do not nulify ctx->vif on reset
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120316143730.GA11278@redhat.com>
References: <1331651434-4370-1-git-send-email-sgruszka@redhat.com>
	 <1331651730.3329.6.camel@jlt3.sipsolutions.net>
	 <20120314062549.GA2788@redhat.com>
	 <1331708304.3376.0.camel@jlt3.sipsolutions.net>
	 <20120314070748.GB2788@redhat.com> <20120314081424.GC2788@redhat.com>
	 <20120316143730.GA11278@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 16:16:18 +0100
Message-ID: <1331910978.6753.23.camel@jlt3.sipsolutions.net> (sfid-20120316_161628_621653_1EBAA7C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 15:37 +0100, Stanislaw Gruszka wrote:

> > To reproduce problems, I'm doing "ping -f 192.168.1.1" on one console
> > and run script [1] on other console.
> 
> So what we do here? Patch fix possible crash on firmware restart.

Still working on it. I am still recovering from being sick and spending
much of the last couple of days in bed.

> We have a few places where ctx->vif is dereferences without a NULL
> check. Perhaps those places should be verified instead. What protects
> to dereference ctx->vif after iwl_mac_remove_interface() ?

Exactly my point -- if a place uses ctx->vif then it's quite possibly a
bug anyway, even not considering restart.

> Regarding restart, this apparently is broken - hung the adapter such the
> module reload is needed. To mitigate the problems You just disable
> watchdog on various adapters.
> 
> I do not think restart should be fixed. I think better would be disable
> restart by default (set fw_restart=0) and start to solve real problems :-)

> This is of course not easy, but perhaps could be done using tracing.

I don't think this is an option since it's essentially also a safety-net
or workaround for microcode bugs. Preparing and testing microcode for
release is a rather long process so we can't re-release for all bug
fixes, as nice as that'd be. Sometimes we can't even get a simple fix
developed when the versions have diverged.

> It
> offer a nice feature that allow to enable and disable logging on
> runtime, (tracing_on(), tracing_off() functions). So offer a compile
> option to make IWL_DEBUG use trace_printk(), start tracing on module
> load, disable it on microcode error or queue stuck. All of that should
> help with debugging inimitable problems, as ftrace log data into memory
> and use ring buffer, hence allow to see (lot of) latest actions before
> the problem occurs. I could write the patches, but since you are
> constantly refactoring the iwlwifi driver better if you will do this.
> How about that?

I don't think we can do this, there'd be a ton of data in it (all TX/RX)
and most of that isn't relevant -- quite likely that the relevant data
is out of the buffers already by the time we need it.

johannes

