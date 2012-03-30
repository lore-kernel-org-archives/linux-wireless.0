Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab2C3UeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 16:34:07 -0400
Message-ID: <1333139642.7679.7.camel@jlt3.sipsolutions.net> (sfid-20120330_223410_739762_16583610)
Subject: Re: [PATCH 2/2] compat: explicitly export generated variables
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 22:34:02 +0200
In-Reply-To: <CAB=NE6XXzwKjFCbV=zi7DaPtpa4aqttB4EMTqaKSzhPMHwJd1A@mail.gmail.com> (sfid-20120330_223142_126396_7FBFC053)
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
	 <1333105904.3908.13.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XXzwKjFCbV=zi7DaPtpa4aqttB4EMTqaKSzhPMHwJd1A@mail.gmail.com>
	 (sfid-20120330_223142_126396_7FBFC053)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-30 at 13:30 -0700, Luis R. Rodriguez wrote:
> On Fri, Mar 30, 2012 at 4:11 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > Doing the blanket "export" statement at the beginning
> > of the generated file confuses the kernel's Makefiles
> > and causes extreme build slowdowns.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> 
> Nice, how did you figure this out BTW!?

Random monkey approach ;-)

I noticed it was slow and saw that it was due to some weird shit from
the kernel Makefile.lib being executed when it shouldn't be.

Since I have the compat *result* in git, I could easily see the diff
between the old compat.git/compat-wireless.git and the new versions. And
then I basically tried to identify the changes that caused this problem,
my best guess was that it had to be the Makefile so I gradually changed
that back to the previous version until the problem went away ... and
then identified which changes were responsible.

johannes

