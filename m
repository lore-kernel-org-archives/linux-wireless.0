Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3K3Tf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 14:35:56 -0500
Message-ID: <1385840149.4267.1.camel@jlt4.sipsolutions.net> (sfid-20131130_203616_968023_7FA1BCBA)
Subject: Re: wireless network interfaces and network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Kevin Wilson <wkevils@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 30 Nov 2013 20:35:49 +0100
In-Reply-To: <CAGXs5wVt3okeE6oA_pNV5WnQLv51+bf+n+52s5d7tQkXq_qvNw@mail.gmail.com> (sfid-20131130_145812_659093_751E3F17)
References: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com>
	 <1385817282.5056.0.camel@jlt4.sipsolutions.net>
	 <CAGXs5wVt3okeE6oA_pNV5WnQLv51+bf+n+52s5d7tQkXq_qvNw@mail.gmail.com>
	 (sfid-20131130_145812_659093_751E3F17)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-11-30 at 15:58 +0200, Kevin Wilson wrote:
> Thanks!
> Running:
> iw phy phy0 set netns 3433
> indeed moved wlan0 to the network namespace I created, where process 3433 ran.
> I did not see a way to specify the network namespace name for moving
> wlan0 in this command (at least iw help does not show it and  I am
> using iw 3.4-1 on ubuntu). I did not looked into the source code of iw
> though.

No, that's not supported since all virtual interfaces (e.g. wlan0)
belonging to a device (e.g. phy0) must move namespaces together.
Otherwise you could do

iw wlan0 interface add wlan0b type managed

and then try to move wlan0 while wlan0b stays in the namespace. In
theory that might actually be useful given appropriate resource
reservation and multi-interface/multi-channel capable devices, but it
would require a massive effort to get it right - it's not useful
enough ;)

johannes

