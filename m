Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39790
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761435AbXHIJz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 05:55:56 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif config
Date: Thu, 9 Aug 2007 11:54:49 +0200
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
References: <200708071744.40287.mb@bu3sch.de> <200708090220.32981.mb@bu3sch.de> <20070808172843.f98cb2de.akpm@linux-foundation.org>
In-Reply-To: <20070808172843.f98cb2de.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708091154.50193.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 August 2007 02:28:43 Andrew Morton wrote:
> On Thu, 9 Aug 2007 02:20:32 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Thursday 09 August 2007, Andrew Morton wrote:
> > > Still confused.
> > > 
> > > I pull
> > > git+ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git#mm-master
> > > into -mm.  Could be that John puts other things into other trees which do
> > > not appear in #mm-master, I don't know.
> > > 
> > > Given that you are the developer and maintainer of ssb it is appropriate
> > > (especially at this stage) that you run a tree.  Just a plain old quilt
> > > tree like
> > > http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/
> > > would be fine.
> > > 
> > > If that tree is relative to some tree which John is running then that's OK,
> > > as long as someone tells me where to get that tree from.
> > > 
> > > Or just merge all of SSB via John's tree.  I don't think it matters that
> > > it's not strictly a wireless thing.  
> > 
> > I can live with doing it through John.
> > And as bcm43xx depends on ssb we are doomed to go through
> > John's tree.
> > So if you always pull John's tree, you'll be up to date with
> > wireless + ssb.
> > 
> > So if you drop everything b44, bcm43xx and ssb related
> > and pull John's tree, it will compile again.
> 
> But I pull John's tree daily, and I don't receive all that ssb stuff.  I
> assume his is not including it in the #mm-master branch.
> 
> > So, my question: How is the mainline merge going to happen?
> > Do you handle that, or do I have to generate some split-out
> > patches for ssb (I have a script for that).
> 
> If the master version of ssb is in one of John's branches then he can ask
> Linus to merge that branch into mainline.

Ok, I see. A rebase of wireless-dev is needed anyway, so this
should not be a problem.
So John, when you rebase your tree, can you make a seperate branch
for the ssb stuff? I can supply you with the initial broken out
patch to start it.

-- 
Greetings Michael.
