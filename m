Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36078 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbaHKVEi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 17:04:38 -0400
Received: by mail-pa0-f46.google.com with SMTP id lj1so11822028pab.33
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 14:04:37 -0700 (PDT)
Message-ID: <1407791075.28221.74.camel@chimera> (sfid-20140811_230459_434484_072527F6)
Subject: Re: [PATCH] allow setting wiphy.perm_addr after driver probe
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Network Development <netdev@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Date: Mon, 11 Aug 2014 14:04:35 -0700
In-Reply-To: <37210DB5-2911-4FA3-9299-7701C5003945@holtmann.org>
References: <1407780269.28221.63.camel@chimera>
	 <54DF22CF-59D7-4633-A625-896F58C26A64@holtmann.org>
	 <1407789645.28221.68.camel@chimera>
	 <37210DB5-2911-4FA3-9299-7701C5003945@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-08-11 at 13:56 -0700, Marcel Holtmann wrote:
> The initial wlan0 can be removed as every other netdev attached to the
> wiphy. It can also be as easily re-created.
> 
> Since the wiphy does not have a valid MAC address, my proposal here
> would be to just not create the wlan0 in the first place. This means
> that the wiphy can be still discovered via nl80211.

I repeat, currently wlan0 is *not* created.

> It also means that the wlan0 netdev needs to be created by userspace
> now. And a valid NL80211_ATTR_MAC be provided. Similar to what is
> already done for P2P devices at the moment. That should just solve the
> problem.

The creation of wlan0 already comes from userspace, but the PHY has its
own MAC.

> We really do not want to announce a netdev when registering the wiphy
> device and then having to mess with its MAC address via sysfs somehow.
> This all needs to be properly reflected over RTNL.
> 
Again, no netdev is announced. There just isn't a way to set the MAC of
the wiphy device itself.

How about this: What if the driver were to leave the MAC at all zeros
initially, and sysfs could set that if and only if it's all zeros at the
time?

