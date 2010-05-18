Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37065 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0ERQxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 12:53:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 09:53:35 -0700
Date: Tue, 18 May 2010 09:53:30 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Huub Reuver <h_reuver@mantell.xs4all.nl>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [Oops-report] problem with ath9k at shutdown
Message-ID: <20100518165330.GC4209@tux>
References: <20100516172012.GA8607@chidori>
 <20100517143240.GA2436@tuxdriver.com>
 <20100517165531.GE12203@tux>
 <20100517172403.GB2436@tuxdriver.com>
 <20100518054140.GA15675@navi.boekerij>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20100518054140.GA15675@navi.boekerij>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 17, 2010 at 10:41:40PM -0700, Huub Reuver wrote:
> On Mon, May 17, 2010 at 01:24:04PM -0400, John W. Linville wrote:
> > On Mon, May 17, 2010 at 09:55:31AM -0700, Luis R. Rodriguez wrote:
> > > On Mon, May 17, 2010 at 07:32:41AM -0700, John W. Linville wrote:
> > > > Did you try 2.6.34?  I'm pretty sure we merged a fix for this...
> > > 
> > > Ditto, and I think it was not related to ath9k but mac80211.
> > > 
> > > Was it this maybe?
> > > 
> > > commit a9f042cbe5284f34ccff15f3084477e11b39b17b
> > > Author: Ming Lei <tom.leiming@gmail.com>
> > > Date:   Sun Feb 28 00:56:24 2010 +0800
> > > 
> > >     ath9k: fix lockdep warning when unloading module
> > > 
> > > Johannes had noted:
> > > 
> > > "I think the problem is that the locking for sta_notify changed, and a
> > > patch that was written for the new locking was backported to the old,
> > > irq-disabled, locking."
> > 
> > Yeah, maybe that is what I was thinking about....
> 
> The traces do not look similar to me, but I'm not a programmer.
> 
> I have done a few tests:
> 2.6.32.9 not affected
> 2.6.32.13 affected
> 2.6.33.3 affected
> 2.6.33.4 affected
> 2.6.34 the problem seems to have been fixed.
> 
> Sorry for my slow report and response.
> Thanks for your quick answer, I'll have to switch to 2.6.34 for a 
> production kernel. 

Eh, I am not sure what happened here... this must've been a fix
regression as I do not recall seeing this on earlier 2.6.32.y releases.
Can you try an earlier 2.6.32.y?

  Luis
