Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0JJIQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 04:16:47 -0400
Subject: Re: phyX enumeration conflict
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Greear <greearb@candelatech.com>,
	rainbow lum <rainbowlum@gmail.com>
In-Reply-To: <1286698152.3547.4.camel@jlt3.sipsolutions.net>
References: <201010082159.59262.chunkeey@googlemail.com>
	 <1286698152.3547.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 10:16:44 +0200
Message-ID: <1286698604.3547.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-10 at 10:09 +0200, Johannes Berg wrote:

> The commit failed to take into account that allocated wireless devices
> (wiphys) are not added into the device list upon allocation, but only
> when they are registered. Therefore, it opened up a race between
> allocating and registering a name, so that if two processes allocate and
> register concurrently ("alloc, alloc, register, register" rather than
> "alloc, register, alloc, register") the code will attempt to use the
> same name twice.

And as for the actual feature, as far as I'm concerned the discussion
ends here because we otherwise need to use something as complex as idr.
A udev rule can't break the kernel and works just as well, even if
you'll have to use a different namespace, i.e. not "phy%d" -- use say
"wiphy%d" instead.

johannes

