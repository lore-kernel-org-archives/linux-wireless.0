Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58363 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbaHKUku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 16:40:50 -0400
Received: by mail-pa0-f41.google.com with SMTP id rd3so11796418pab.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 13:40:50 -0700 (PDT)
Message-ID: <1407789645.28221.68.camel@chimera> (sfid-20140811_224116_233088_4E2557D6)
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
Date: Mon, 11 Aug 2014 13:40:45 -0700
In-Reply-To: <54DF22CF-59D7-4633-A625-896F58C26A64@holtmann.org>
References: <1407780269.28221.63.camel@chimera>
	 <54DF22CF-59D7-4633-A625-896F58C26A64@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-08-11 at 13:25 -0700, Marcel Holtmann wrote:
> isn't this dangerous to just allow writing to wiphy.perm_addr via
> sysfs. We ran into the same issue with Bluetooth and ROM only devices
> that have to unique address. Doing this via sysfs seems the wrong
> approach. It is messy and full of potential race conditions. I clearly
> opted against the sysfs solution for Bluetooth. Instead we build an
> infrastructure that allowed doing it cleanly via the Bluetooth mgmt
> API. Controllers that have no unique address are brought up as
> unconfigured and userspace clearly knows that it has to take steps to
> get an address programmed into the controller.

My inclination is to agree; however, this does not exist for WiFi and
implementing it would require modifying every single driver.

> And I think something similar should be done for WiFi. It might be
> better to not create the initial wlan0 netdev interface if the
> hardware has not a single unique address available. That way the
> supplicant can just either get one from the flash filesystem or make
> up a proper random one before creating the netdev interface.
> 
The initial wlan0 netdev interface is *not* created, but the PHY records
a MAC address that cannot be overriden at the level that this sysfs node
reads. Perhaps a compromise would be to create a single new syscall to
write to it?

