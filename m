Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbYG1PB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 11:01:56 -0400
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Dan Williams <dcbw@redhat.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200807281600.39103.mb@bu3sch.de>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <200807281544.33509.mb@bu3sch.de> <1217253397.6364.2.camel@localhost>
	 <200807281600.39103.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 10:59:34 -0400
Message-Id: <1217257174.28198.27.camel@localhost.localdomain> (sfid-20080728_170201_708567_9D9743F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-28 at 16:00 +0200, Michael Buesch wrote:
> On Monday 28 July 2008 15:56:37 Luis Carlos Cobo wrote:
> > On Mon, 2008-07-28 at 15:44 +0200, Michael Buesch wrote:
> > > Well, I think that really is pretty weird and it is confusing to the
> > > user to see that pseudo random MAC that changes suddenly when the device is
> > > initialized. For the human user (so everybody but me), it would be better
> > > to have the MAC all-zeros until the firmware loaded. So it would be obvious
> > > that the MAC is not set, yet. I think userspace
> > 
> > The problem is that all-zeroes is actually a valid mac address, owned by
> > Xerox (http://standards.ieee.org/regauth/oui/oui.txt) Not that it will
> > probably cause us any problem, but a multicast address is afaik an
> > invalid mac for a device. Should we go for 01:allzeros?
> 
> If that's really a problem, yes. 01:00:00:00:00:00 is still better
> than a pseudo random MAC, IMO. It's immediately obvious to the user
> that the MAC currently is not set.

How about 44:44:44:44:44:44 like orinoco uses for bogus BSSID?  If we
can, let's not keep creating yet more bogus MAC addresses.

Dan


