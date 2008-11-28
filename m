Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47146
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbYK1HKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 02:10:32 -0500
Date: Thu, 27 Nov 2008 23:10:32 -0800 (PST)
Message-Id: <20081127.231032.71323554.davem@davemloft.net> (sfid-20081128_081037_583951_4153610E)
To: linux-wireless@vger.kernel.org, shaddy_baddah@hotmail.com
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <BAY104-DAV671C2C6DE8B2A05AD785E99040@phx.gbl>
References: <4916F1C0.1040703@hotmail.com>
	<BAY104-DAV1D226EA8FB16BE36E3C84991A0@phx.gbl>
	<BAY104-DAV671C2C6DE8B2A05AD785E99040@phx.gbl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Date: Fri, 28 Nov 2008 16:34:34 +1100

> It is interesting (at least to me) to note that a change between
> kernel versions 2.6.26 and 2.6.28-rc6 fixed something that allowed
> WPA2 to work on sparc64. At least according to my careful
> verification. Perhaps one day, I'll narrow that change down.

That would be the following set of changes:

commit 0f5cabba49021d36e9f76bd97d7fa0f4a408063f
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Jun 3 07:39:16 2008 -0700

    wext: Create IW_REQUEST_FLAG_COMPAT and set it as needed.
    
    Now low-level WEXT ioctl handlers can do compat handling
    when necessary.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 169a3ec492ddb6b0a8203fccba2ddff077154e26
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Fri Dec 21 03:55:13 2007 -0800

    wext: Remove compat handling from fs/compat_ioctl.c
    
    No longer used.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 87de87d5e47f94b4ea647a5bd1bc8dc1f7930db4
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Jun 3 09:14:03 2008 -0700

    wext: Dispatch and handle compat ioctls entirely in net/wireless/wext.c
    
    Next we can kill the hacks in fs/compat_ioctl.c and also
    dispatch compat ioctls down into the driver and 80211 protocol
    helper layers in order to handle iw_point objects embedded in
    stream replies which need to be translated.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit a67fa76d8be4e24e2d61cd76438a893d4c2886f7
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Jun 3 07:36:30 2008 -0700

    wext: Pull top-level ioctl dispatch logic into helper function.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d2911255590d9ca561a481b9dbebcfcbbf38fa4e
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Fri Dec 21 03:46:01 2007 -0800

    wext: Pass iwreq pointer down into standard/private handlers.
    
    They have no need to see the object as an ifreq.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit ca1e8bb8e4e89e2769e2b39eb29fdcfc5c19cf89
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Fri Dec 21 03:41:45 2007 -0800

    wext: Parameterize the standard/private handlers.
    
    The WEXT standard and private handlers to use are now
    arguments to wireless_process_ioctl().
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 67dd7608078b17f63f29ff2108fc5bf2407ddcec
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Fri Dec 21 03:36:31 2007 -0800

    wext: Pull ioctl permission checking out into helper function.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit d88174e4d295f0880e5f9cb6d42f26b0367c8fd9
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Fri Dec 21 03:33:46 2007 -0800

    wext: Extract private call iw_point handling into seperate functions.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 84149b0fca08f9ec554dfc28dabc39839fdf8a06
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Fri Dec 21 03:27:17 2007 -0800

    wext: Extract standard call iw_point handling into seperate function.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 208887d4cc5a5c1eeb68bd170e21e32b1129cd94
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Fri Dec 21 03:24:24 2007 -0800

    wext: Make adjust_priv_size() take a "struct iw_point *".
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 25519a2a769d42fc2733a8f119682272d99b1304
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Fri Dec 21 03:22:38 2007 -0800

    wext: Remove inline from get_priv_size() and adjust_priv_size().
    
    The compiler inlines when appropriate.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

