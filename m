Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab0I3Wq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:46:26 -0400
Subject: Re: [RFC 1/2] genetlink: introduce pre_doit/post_doit hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	tgraf@suug.ch
In-Reply-To: <1285886690.5137.28.camel@jlt3.sipsolutions.net>
References: <20100930211013.472957770@sipsolutions.net>
	 <20100930211131.021309930@sipsolutions.net>
	 <AANLkTik9+zA4PPPx=q6CRM-sgOjjECJdtJTgkCG9pGAY@mail.gmail.com>
	 <1285886690.5137.28.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 00:47:01 +0200
Message-ID: <1285886821.5137.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 00:44 +0200, Johannes Berg wrote:
> On Fri, 2010-10-01 at 08:41 +1000, Julian Calaby wrote:
> 
> > >  d) include two private pointers in each info
> > >    struct passed between all these operations
> > >    including doit(). (It's two because I'll
> > >    need two in nl80211 -- can be extended.)
> > 
> > Stupid question:
> > 
> > Why not have a priv struct rather than an arbitrary array of two pointers?
> 
> It'd have to be dynamically allocated, and the "arbitrary" array of two
> pointers can be on the stack.

Maybe I should elaborate -- a priv struct basically means just a single
pointer, and then I'd have to allocate something to hold two pointers in
nl80211 and assign it to that single pointer.

johannes

