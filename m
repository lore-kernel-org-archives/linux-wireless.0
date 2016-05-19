Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45421 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbcESHQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 03:16:42 -0400
Date: Thu, 19 May 2016 09:16:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Subject: Re: [RESEND PATCH 1/3] rfkill: Create "rfkill-airplane-mode" LED
 trigger
Message-ID: <20160519071639.GB17077@amd> (sfid-20160519_091703_103643_D92C0718)
References: <1462199948-6424-1-git-send-email-jprvita@endlessm.com>
 <1462199948-6424-2-git-send-email-jprvita@endlessm.com>
 <20160504072936.GB17045@amd>
 <1463045572.13313.21.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1463045572.13313.21.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 2016-05-12 11:32:52, Johannes Berg wrote:
> On Wed, 2016-05-04 at 09:29 +0200, Pavel Machek wrote:
> > 
> > If userspace wants to control the manually, it can do just that --
> > control it manually. There should not be a need to "override the
> > default policy".
> 
> I'm still not buying this.
> 
> In the original situation, without these patches, userspace has to have
> a list of all LEDs that are supposed to indicate airplane mode.

Well, that's situation for many LEDs.

> With this patch only (without patch 2/3), userspace can look up the
> default trigger, but then has to change it, causing the necessary
> information to be lost immediately when you actually use it - that also
> seems like a bad idea.

We should not store "what kind of led this is" in a trigger. LED
subsystem seems to use suffix of LED name to do that. So if we
standartize, lets say "::rfkill" suffix for this, it should work and
follow existing practice.

> Now, if the LED subsystem had a really good way of specifying LED
> intent, and it was widely used, and rfkill didn't already concern
> itself with the rfkill status of all devices ... yeah maybe this
> wouldn't be needed. As it stands, I still think this is the best way
> forward.

There is one -- suffix in the LED name.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
