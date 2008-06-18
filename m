Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59463
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755213AbYFRWiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 18:38:52 -0400
Date: Wed, 18 Jun 2008 15:38:53 -0700 (PDT)
Message-Id: <20080618.153853.245557085.davem@davemloft.net> (sfid-20080619_003856_344440_5838CB3E)
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, rjw@sisk.pl, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.26 (resend)] mac80211: detect driver tx bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080618203714.GA20451@tuxdriver.com>
References: <1213534540.3803.5.camel@johannes.berg>
	<1213785045.1312.12.camel@johannes.berg>
	<20080618203714.GA20451@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 18 Jun 2008 16:37:14 -0400

> On Wed, Jun 18, 2008 at 12:30:45PM +0200, Johannes Berg wrote:
> > When a driver rejects a frame in it's ->tx() callback, it must also
> > stop queues, otherwise mac80211 can go into a loop here. Detect this
> > situation and abort the loop after five retries, warning about the
> > driver bug.
> > 
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > This is a port of the patch to 2.6.26 which seems to suffer from the
> > same problem and could well be the cause of some of the mac80211 softlockup
> > warnings on kerneloops.org.
> > 
> > Dave, with John on vacation until the 22nd, would you push this to Linus
> > with the next net update instead of it going through John's tree first?
> 
> This is fine with me.  Otherwise I'll try to get to it in the next
> day or so.

I'll toss it into my tree, don't worry about it.
