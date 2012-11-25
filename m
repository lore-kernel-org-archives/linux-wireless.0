Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ibawizard.net ([82.208.49.253]:43219 "EHLO
	mengele.ibawizard.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2KYW3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 17:29:46 -0500
Date: Sun, 25 Nov 2012 23:29:40 +0100
From: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: Multi-bss operation issue with rt2x00 and hostapd on rt305x
	platform
Message-ID: <20121125222940.GA16095@ibawizard.net> (sfid-20121125_232950_642421_345CA429)
Reply-To: Petr =?iso-8859-2?Q?=A9tetiar?= <ynezz@true.cz>
References: <20121125190019.GQ8292@ibawizard.net> <50B29159.20209@googlemail.com> <CAGXE3d_Wgk5Eo5Y2k-9jr3ULuOeZydmWA_pJVd8ARnKHwSGtgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGXE3d_Wgk5Eo5Y2k-9jr3ULuOeZydmWA_pJVd8ARnKHwSGtgQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa <helmut.schaa@googlemail.com> [2012-11-25 22:53:00]:

> > Mind to use different MAC addresses? The rt2800 hw can only be programmed
> > with a MAC address mask that spans the last 3 bits. In your config this
> > would be
> 
> Ooops, seems I messed up my mailclient :)
> 
> You're using the following MAC addresses for the virtual APs:
> 
> bssid=c4:93:00:11:01:88
> bssid=c6:93:00:11:01:89
> bssid=c6:93:00:11:01:8a
> 
> rt2800 hw can only be configured to mask the last three bits of the
> programmed MAC addresses. In your case the first MAC differs from the
> other in the first byte. Please try if it works when using the same
> first byte.

Indeed, it was quite suspicious to me also, so I did tried that with the
following MACs:

	bssid=c4:93:00:11:01:88
	bssid=c4:93:00:11:01:89
	bssid=c4:93:00:11:01:90

and it wasn't working for the first two, but now I did what you've suggested
and voilà, it works for all three! :) So the working setup is following:

	bssid=c4:93:00:11:01:88
	bssid=c4:93:00:11:01:89
	bssid=c4:93:00:11:01:8a

I don't see a pattern here, why it didn't worked with :88, :89, :90? Just the
last one :90 was working and :88, :89, :8a works fine. There need to be some
hole/spacing? Thanks a lot!

-- ynezz
