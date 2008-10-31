Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47715 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYJaCFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 22:05:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 19:05:39 -0700
Date: Thu, 30 Oct 2008 19:05:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Tomas Winkler <tomasw@gmail.com>,
	reinette chatre <reinette.chatre@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [MEMO] ftrace suckage++
Message-ID: <20081031020537.GJ21459@tesla> (sfid-20081031_030545_220556_35511E65)
References: <43e72e890810301445r665a0139g752fb1c97069fe59@mail.gmail.com> <alpine.DEB.1.10.0810302149330.21031@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.1.10.0810302149330.21031@gandalf.stny.rr.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 06:54:00PM -0700, Steven Rostedt wrote:
> 
> On Thu, 30 Oct 2008, Luis R. Rodriguez wrote:
> 
> > As johannes pointed out to me the culprit to the e1000e corruption was
> > determined to be ftrace related [1]. Well it seems I hit an oops with
> > ftrace using iwlagn after a simple load of the module using
> > wireless-testing. I'm not sure if john's tree yet has ftrace fixes.
> > Both Fedora 10 and Ubuntu 8.10 had dynamic ftrace enabled so users on
> > these first kernels and using compat-wireless may run into this so
> > just putting this out there. I'll can check for this flag in
> > compat-wireless for now and bitch/exit if its enabled unless someone
> > has a better idea.
> >
> > [1] http://lwn.net/Articles/303390/
> >
> > Oops, using wireless-testing and iwlagn with these options enabled:
> >
> > CONFIG_HAVE_FTRACE=y
> > CONFIG_HAVE_DYNAMIC_FTRACE=y
> > CONFIG_FTRACE=y
> > CONFIG_DYNAMIC_FTRACE=y
> >
> 
> Yes, ftrace in 2.6.27 is known to be broken. That's why 2.6.27.1 labeled
> it as such. What is currently in Linus's 2.6.28 git tree is a completely
> rewritten version of the dynamic ftracer, which addresses all of the
> issues that caused breakage in the 2.6.27 release.
> 
> Do not use the 2.6.27 dynamic ftracer, it is known bad. 2.6.28 is fine. If
> you find issues with what is currently in 2.6.28, please let me know.
> There is currently some, "make allyesconfig" breakage that ftrace caused
> on archs other than x86,ppc and sparc, but patches to fix them are
> in queue to Linus.

OK then in that case if *and only if* on 27 and if dynamic tracer is enabled
I'll set compat stuff to simply bail out at compile time.

Thanks,

  Luis
