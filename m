Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:39591 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761303AbYB2Xyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Feb 2008 18:54:55 -0500
Date: Fri, 29 Feb 2008 15:51:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	gordonfarquharson@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: pull request: wireless-2.6 2008-02-27
Message-Id: <20080229155149.9575f2d0.randy.dunlap@oracle.com> (sfid-20080229_235459_328739_A8B68E0A)
In-Reply-To: <200803010013.11458.mb@bu3sch.de>
References: <20080228014125.GI3078@tuxdriver.com>
	<20080229162629.GB3234@tuxdriver.com>
	<1204302853.3938.40.camel@johannes.berg>
	<200803010013.11458.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 1 Mar 2008 00:13:11 +0100 Michael Buesch wrote:

> On Friday 29 February 2008 17:34:13 Johannes Berg wrote:
> > 
> > On Fri, 2008-02-29 at 11:26 -0500, John W. Linville wrote:
> > > On Fri, Feb 29, 2008 at 01:16:59PM +0100, Michael Buesch wrote:
> > > 
> > > > I'm wondering if we can't simply pass a commandline parameter to file2alias
> > > > that tells it whether we are crosscompiling. It should simply omit the sanity check
> > > 
> > > Sounds reasonable to me.
> > 
> > In fact, file2alias shouldn't need a command line argument ...
> 
> Well, if...
> 
> > > > in that case. Is there any easy and reliable way to find out whether we
> > > > are crosscompiling from a makefile (I don't know the makefile core that much)?
> > > 
> > > Non-empty CROSS_COMPILE definition?
> > 
> > ... it can just check whether CROSS_COMPILE is set in its environment.
> > No?
> 
> Is that exported to the environment?

Certainly, in top-level Makefile:

export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS


---
~Randy
