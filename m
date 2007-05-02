Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4611 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993230AbXEBOWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 10:22:40 -0400
Date: Wed, 2 May 2007 10:11:25 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Compilation error with latest wireless-dev
Message-ID: <20070502141125.GC6187@tuxdriver.com>
References: <4638161D.7020106@lwfinger.net> <20070502023406.0efnk48888owckc8@webmail.spamcop.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070502023406.0efnk48888owckc8@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 02, 2007 at 02:34:06AM -0400, Pavel Roskin wrote:
> Quoting Larry Finger <Larry.Finger@lwfinger.net>:
> 
> > Compiling wireless-dev (commit d2f859f56c9f00f093f943cf810a863a5aa2e10f)
> > results in the following
> > error when building modules:
> >
> > WARNING: "tcf_destroy_chain" [net/mac80211/mac80211.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > make: *** [modules] Error 2
> >
> > In my configuration, net/sched/sch_api.c where tcf_destroy_chain is defined
> > is not compiled. The
> > network-related configuration parameters are:
> 
> Same problem here.  CONFIG_NET_SCH_FIFO was enabled, apparently by
> net/mac80211/Kconfig, but CONFIG_NET_SCHED.  Selecting the later (but none of
> the schedulers) fixed the compile error.

So, should net/mac80211/Kconfig select NET_SCHED instead?  Or should
NET_SCH_FIFO select it?

If the latter, will that cause any circular problems given that
NET_SCHED already selects NET_SCH_FIFO?

Any Kconfig experts have an opinion?

John
-- 
John W. Linville
linville@tuxdriver.com
