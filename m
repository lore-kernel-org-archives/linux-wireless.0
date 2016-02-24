Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38567 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365AbcBXJBz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 04:01:55 -0500
Message-ID: <1456304509.2050.15.camel@sipsolutions.net> (sfid-20160224_100454_727382_86A65B50)
Subject: Re: [PATCHv2 09/10] rfkill: Userspace control for airplane mode
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
Date: Wed, 24 Feb 2016 10:01:49 +0100
In-Reply-To: <20160223214501.GA22501@amd>
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
	 <1456159001-20307-10-git-send-email-jprvita@endlessm.com>
	 <20160223204525.GC16961@amd> <1456260914.9910.34.camel@sipsolutions.net>
	 <20160223214501.GA22501@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 22:45 +0100, Pavel Machek wrote:

> Well "the airplane mode" is well defined. It means no intentional
> transmitting at radio frequencies.
> 
> The fact that you are allowed to use WIFI on certain flights does not
> change anything.

Nope, not that simple. Pick up any (contemporary) smartphone and watch
what happens with the airplane mode indicator (the little airplane
icon) when you enable wifi after enabling airplane mode. It stays
there.

Clearly the same logic could then apply to an actual LED (on a system
that's less size-constrained, e.g. a laptop or tablet.)

Thus, the display of "in airplane mode" *does* have policy, and clearly
there's precedent for not disabling the icon or LED when wifi is
enabled, but the kernel shouldn't really impose that. Now, the kernel
has a "safe" default which does what you thought was the "well defined"
airplane mode, but at the same time it's obviously not good enough.

And evidently, the Asus system that this was originally proposed for
has such an LED.

> I see that "airplane mode" trigger might be a tiny bit
> useful... dunno, for a LED near the airplane mode switch, when vendor
> replaced hardware toggle with a key. But policy should have nothing
> to do with that. If you argue additional "policy daemon" is needed
> for that... forget it, that's overdesigned.

See above.

> (Besides, finding all LEDs with given trigger is trivial
> operation. Besides... there should never be more than one).

That *might* actually work. But once a tool has detached the trigger
the information is gone; and tools would have to do that to control the
LED, making recovery from any kind of error difficult.

In any case, I've applied those patches already.

As far as the LED subsystem is concerned, all of this is just another
trigger anyway.

johannes
