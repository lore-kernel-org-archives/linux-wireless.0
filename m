Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40043 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbcELJdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2016 05:33:06 -0400
Message-ID: <1463045572.13313.21.camel@sipsolutions.net> (sfid-20160512_113332_211218_243417E5)
Subject: Re: [RESEND PATCH 1/3] rfkill: Create "rfkill-airplane-mode" LED
 trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Thu, 12 May 2016 11:32:52 +0200
In-Reply-To: <20160504072936.GB17045@amd>
References: <1462199948-6424-1-git-send-email-jprvita@endlessm.com>
	 <1462199948-6424-2-git-send-email-jprvita@endlessm.com>
	 <20160504072936.GB17045@amd>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-05-04 at 09:29 +0200, Pavel Machek wrote:
> 
> If userspace wants to control the manually, it can do just that --
> control it manually. There should not be a need to "override the
> default policy".

I'm still not buying this.

In the original situation, without these patches, userspace has to have
a list of all LEDs that are supposed to indicate airplane mode.

With this patch only (without patch 2/3), userspace can look up the
default trigger, but then has to change it, causing the necessary
information to be lost immediately when you actually use it - that also
seems like a bad idea.

With the patches, the userspace that cares can also concentrate on
something it already *does* - i.e. dealing with the rfkill API - and
let the rest of the situation be sorted out in itself.


Now, if the LED subsystem had a really good way of specifying LED
intent, and it was widely used, and rfkill didn't already concern
itself with the rfkill status of all devices ... yeah maybe this
wouldn't be needed. As it stands, I still think this is the best way
forward.

johannes
