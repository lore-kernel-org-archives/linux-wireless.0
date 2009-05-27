Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43536 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758394AbZE0OFL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 10:05:11 -0400
Date: Wed, 27 May 2009 11:05:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Will Keaney <keaneyw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v11] rfkill: rewrite
Message-ID: <20090527140509.GB14440@khazad-dum.debian.net>
References: <1242942720.4212.19.camel@johannes.local> <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com> <20090526131533.GA3932@tuxdriver.com> <20090527025516.GC22235@khazad-dum.debian.net> <20090527080737.GB8134@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090527080737.GB8134@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 27 May 2009, John W. Linville wrote:
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

It is somewhat common on user scripts that are tied to hotkeys by thinkpad
users.  It may also have found its way to some thinkpad-specific utilities
and applets.

I have been telling these people to switch to rfkill for one year, now.
2.6.30 has code that will pester them into doing it, so the numbers will
climb a bit (because I intend to remove the non-rfkil-way of doing things
in 2010, two years after it was first deprecated).

I don't know if there are any generic apps using it.  But I do know I have
users of that feature.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
