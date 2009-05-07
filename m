Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:56307 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZEGUqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2009 16:46:19 -0400
Date: Thu, 7 May 2009 22:47:47 +0200
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Simulate medium behavior
Message-ID: <20090507204747.GB6684@newton.monom.org>
References: <20090422092159.GA24586@toronto053.server4you.de> <1240393088.21756.3.camel@johannes.local> <20090422113556.GB24586@toronto053.server4you.de> <20090507184007.GA6684@newton.monom.org> <1241722972.7590.34.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1241722972.7590.34.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes

On Thu, May 07, 2009 at 09:02:52PM +0200, Johannes Berg wrote:
> Hi Daniel,
> 
> > > > http://thread.gmane.org/gmane.linux.kernel.wireless.general/25001
> > > 
> > > No, I haven't. Yep, my solution is really too simple.  I like the
> > > virtual air grouping. I'll implement it.
> > 
> > After a bit studying how to use configfs (and getting a bit lost)
> > I found netconsole.c which uses configfs. So this version is a copy&past
> > thing. Of course, this needs more work. 
> > 
> > Is this what do did have in mind?
> 
> Very cool. We had a patch at some point to add configfs support to hwsim
> but it seems it got lost :(
> 
> But I don't think your configfs support is optimal since you need to
> create those dirs for phy0 and put the name in etc. even when phy0
> already exists. 

Yes, that was also what I thought. If I understood it correctly that is
exactly the main difference between configfs and debugfs. In configfs 
the userspace has the owner ship of the 'objects' (mkdir, rmdir) whereas
in debugfs the kernel controls the lifetime of the 'objects'.

> I'm sorry to have wasted your time with the configfs
> suggestion, but I think with how hwsim _currently_ behaves, without
> configfs support for creating new radios etc., putting this into debugfs
> would be nicer, since debugfs already has a dir for this from
> cfg80211/mac80211...

No problem. I was able to learn something :) Ok, I'll cook up the next 
version. 

> > +config MAC80211_HWSIM_VGROUP
> > +	bool "enable virtual air grouping"
> > +	depends on MAC80211_HWSIM
> > +	default y
> > +	help
> > +	  This option enables virtual air grouping.
> > +
> > +	  If unsure, say N.
> 
> I also wouldn't make it configurable, just make it default to group == 1
> so that it behaves as it was.

Good point.

Thanks for your comments!

cheers, 
daniel


