Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38155
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab1D2UyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:54:12 -0400
Date: Fri, 29 Apr 2011 13:53:39 -0700 (PDT)
Message-Id: <20110429.135339.200375209.davem@davemloft.net> (sfid-20110429_225421_361031_E48FAB10)
To: kvalo@adurom.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: fix rtnl even race in register_netdevice()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110429172634.27130.25375.stgit@x201>
References: <20110429172634.27130.25375.stgit@x201>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 29 Apr 2011 20:26:34 +0300

> From: Kalle Valo <kalle.valo@atheros.com>
> 
> There's a race in register_netdevice so that the rtnl event is sent before
> the device is actually ready. This was visible with flimflam, chrome os
> connection manager:
> 
> 00:21:35 roska flimflamd[2598]: src/udev.c:add_net_device()
> 00:21:35 roska flimflamd[2598]: connman_inet_ifname: SIOCGIFNAME(index
>    4): No such device
> 00:21:45 roska flimflamd[2598]: src/rtnl.c:rtnl_message() buf
>    0xbfefda3c len 1004
> 00:21:45 roska flimflamd[2598]: src/rtnl.c:rtnl_message()
>    NEWLINK len 1004 type 16 flags 0x0000 seq 0
> 
> So the kobject is visible in udev before the device is ready.
> 
> (ignore the 10 s delay, I added that to reproduce the issue easily)
> 
> The issue is reported here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=15606
> 
> The fix is to call netdev_register_kobject() after the device is added
> to the list.
> 
> Signed-off-by: Kalle Valo <kalle.valo@atheros.com>

This is not correct.

If you move the kobject registry around, you have to change the
error handling cleanup to match.

This change will leave the netdevice on all sorts of lists, it will
also leak a reference to the device.

I also think this points a fundamental problem with this change, in
that you can't register the kobject after the device is added to
the various lists in list_netdevice().

Once it's in those lists, any thread of control can find the device
and those threads of control may try to get at the data backed by
the kobject and therefore they really expect it to be there by
then.

What you can do instead is try to delay the NETREG_REGISTERED
setting, and block the problematic notifications by testing
reg_state or similar.
