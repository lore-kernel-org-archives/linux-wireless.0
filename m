Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2LNKgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 05:36:11 -0500
Message-ID: <1355481393.9571.8.camel@jlt4.sipsolutions.net> (sfid-20121214_113613_468732_395F199D)
Subject: Re: [PATCH 19/24] regulatory: remove handling of channel bandwidth
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 14 Dec 2012 11:36:33 +0100
In-Reply-To: <1355481353.9571.7.camel@jlt4.sipsolutions.net> (sfid-20121214_113536_414692_12182895)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 <1354812468-15709-20-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6UrhZ1K17Bd=qorjQ6mhpfCTgR4ctehuDu-2v6-2g44qA@mail.gmail.com>
	 (sfid-20121213_231145_417854_2D5BB0A5) <1355481353.9571.7.camel@jlt4.sipsolutions.net>
	 (sfid-20121214_113536_414692_12182895)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 11:35 +0100, Johannes Berg wrote:
> On Thu, 2012-12-13 at 14:11 -0800, Luis R. Rodriguez wrote:
> > On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > >
> > > The channel bandwidth handling isn't really quite right,
> > > it assumes that a 40 MHz channel is really two 20 MHz
> > > channels, which isn't strictly true. This is the way the
> > > regulatory database handling is defined right now though
> > > so remove the logic to handle other channel widths.
> 
> > I didn't see the replacement work in place but I assume its coming
> > through RFCs or already posted so:
> 
> I'm not planning to replace this (dead) code, at least not right now.
> 
> All current users of the function pass 0, which assumes 20 MHz, so
> basically all I'm doing is remove this unused argument and code
> associated with it.
> 
> Now, due to the way the regulatory database works, the argument was
> never actually useful unless somebody wanted to support 5/10 MHz
> channels and had a regulatory domain that only allowed those (and didn't
> allow 20 MHz!)
> 
> For wider bandwidths, the way the regulatory db is currently defined (by
> the way it's always been handled) is that all the secondary channels
> must exist and allow the bandwidth, but that's a little different so I
> also don't see any way this argument would currently be useful.

And "currently" really means "until an entirely new regulatory framework
with different rule interpretation is defined".

johannes

