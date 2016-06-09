Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59593 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbcFIMn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 08:43:26 -0400
Message-ID: <1465476194.3442.21.camel@sipsolutions.net> (sfid-20160609_144404_161231_B1E055AF)
Subject: Re: [RESEND PATCH 1/3] rfkill: Create "rfkill-airplane-mode" LED
 trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Thu, 09 Jun 2016 14:43:14 +0200
In-Reply-To: <20160519071639.GB17077@amd>
References: <1462199948-6424-1-git-send-email-jprvita@endlessm.com>
	 <1462199948-6424-2-git-send-email-jprvita@endlessm.com>
	 <20160504072936.GB17045@amd> <1463045572.13313.21.camel@sipsolutions.net>
	 <20160519071639.GB17077@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-05-19 at 09:16 +0200, Pavel Machek wrote:

> > In the original situation, without these patches, userspace has to
> > have a list of all LEDs that are supposed to indicate airplane
> > mode.
> Well, that's situation for many LEDs.

That doesn't make it a *good* situation though.

> > With this patch only (without patch 2/3), userspace can look up the
> > default trigger, but then has to change it, causing the necessary
> > information to be lost immediately when you actually use it - that
> > also seems like a bad idea.
> We should not store "what kind of led this is" in a trigger. 

That's pretty much what I'm arguing though.

> LED
> subsystem seems to use suffix of LED name to do that. So if we
> standartize, lets say "::rfkill" suffix for this, it should work and
> follow existing practice.
[...]
> There is one -- suffix in the LED name.

I don't really think that's a good way, and it doesn't seem to be used
universally, but I suppose it's good enough.

João, that means you should send a patch to add the ::rfkill suffix.

And Pavel should send a patch to document the practice and the existing
suffixes with their meaning ;-)

johannes
