Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbXLKPLe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 10:11:34 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Dan Williams <dcbw@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jt@hpl.hp.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
In-Reply-To: <20071210.205139.262078026.davem@davemloft.net>
References: <1197307403.18585.10.camel@localhost.localdomain>
	 <20071210.161144.190139513.davem@davemloft.net>
	 <1197346930.16807.7.camel@localhost.localdomain>
	 <20071210.205139.262078026.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 10:01:23 -0500
Message-Id: <1197385283.26363.1.camel@localhost.localdomain> (sfid-20071211_151137_603501_52035F87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-12-10 at 20:51 -0800, David Miller wrote:
> From: Dan Williams <dcbw@redhat.com>
> Date: Mon, 10 Dec 2007 23:22:10 -0500
> 
> > On Mon, 2007-12-10 at 16:11 -0800, David Miller wrote:
> > > From: Dan Williams <dcbw@redhat.com>
> > > Date: Mon, 10 Dec 2007 12:23:23 -0500
> > > 
> > > > Is this an unconditional NAK for any changes to WEXT?
> > > 
> > > Well, it is at least completely proven that you cannot
> > > extend the structures without crapping all over random
> > > areas of the stack space of the user application.
> > > 
> > > So at a minimum you're going to get NAKs for any patch
> > > that does things that way.
> > 
> > So would another WEXT subcommand be acceptable to you?
> 
> I might find using the existing spare space bearable, but
> even that is a stretch.
> 
> We need to completely deprecate WEXT as fast as possible
> and adding new features to it won't help that.

Yeah, but dropping WEXT on the floor is unacceptable when it is the only
thing that is in use today.  We will certainly work to get
nl80211/cfg80211 in shape, but we must live with WEXT.  I will post a
patch that uses the existing space inside the range structure.

Dan


