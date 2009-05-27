Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58238 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759026AbZE0SFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 14:05:12 -0400
Subject: Re: [PATCH v11] rfkill: rewrite
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Will Keaney <keaneyw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090527080737.GB8134@tuxdriver.com>
References: <1242942720.4212.19.camel@johannes.local>
	 <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com>
	 <20090526131533.GA3932@tuxdriver.com>
	 <20090527025516.GC22235@khazad-dum.debian.net>
	 <20090527080737.GB8134@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 14:04:31 -0400
Message-Id: <1243447471.17301.21.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-27 at 10:07 +0200, John W. Linville wrote:
> On Tue, May 26, 2009 at 11:55:16PM -0300, Henrique de Moraes Holschuh wrote:
> > On Tue, 26 May 2009, John W. Linville wrote:
> > > On Tue, May 26, 2009 at 08:19:29AM -0400, Will Keaney wrote:
> > > > Johannes Berg wrote:
> > > > > This patch completely rewrites the rfkill core to address
> > > > > the following deficiencies:
> > > > >   
> > > > I applied this to a fresh pull of wireless-testing this morning, and
> > > > haven't had any problems from it.  It looks like the soft lockup I
> > > > reported earlier has been fixed.
> > > 
> > > Cool, thanks for the report.
> > > 
> > > I'm leaning towards merging this in time for the 2.6.31 merge
> > > window...who wants to complain? :-)
> > 
> > As long as the missing userspace control functionality (the lack of which is
> > a _serious_ regression for platform drivers) is added before 2.6.31 ships, I
> > have no complains.
> > 
> > Userspace must be able to change the (soft) state using sysfs.  This is
> > not an optional part of rfkill :-)
> 
> Are there any apps that actually use this feature?  It seems like
> that even if there are apps, they need to handle drivers that don't
> support it.

I'd use it NM for the "Enable Wireless" checkbox.  The alternative is
SIOCSIWTXPOW -> off I guess, though it would be nicer to just talk to
one thing in sysfs instead of listen to one and SIWTXPOW to set.

Dan


