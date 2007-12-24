Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:33064 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbXLXW3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 17:29:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: Strange mac80211 oops
Date: Mon, 24 Dec 2007 23:28:55 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200712242237.28913.mb@bu3sch.de> <1198532736.4103.44.camel@johannes.berg> <1198533423.4103.46.camel@johannes.berg>
In-Reply-To: <1198533423.4103.46.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200712242328.56060.mb@bu3sch.de> (sfid-20071224_222952_123781_68587F36)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 24 December 2007 22:57:03 Johannes Berg wrote:
> On Mon, 2007-12-24 at 22:45 +0100, Johannes Berg wrote:
> > > [   98.415423] ------------[ cut here ]------------
> > > [   98.415627] Badness at e221c924 [verbose debug info unavailable]
> > 
> > > [   98.416905] NIP [e221c924] __ieee80211_rx+0x48c/0xd44 [mac80211]
> > 
> > ieee80211_rx_monitor() is inlined into __ieee80211_rx() and that +0x48c
> > is quite a high number, so I'm guessing it's this:
> > 
> >         /*
> >          * Drivers are required to align the payload data to a four-byte
> >          * boundary, so the last two bits of the address where it starts
> >          * may not be set. The header is required to be directly before
> >          * the payload data, padding like atheros hardware adds which is
> >          * inbetween the 802.11 header and the payload is not supported,
> >          * the driver is required to move the 802.11 header further back
> >          * in that case.
> >          */
> >         hdrlen = ieee80211_get_hdrlen(rx.fc);
> >         WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
> 
> Yup, that's what it is, Michael sent me the assembly, __ieee80211_rx
> starts at 0x1990 and we find at 0x1990+0x48c == 0x1e1c
> 
> 
>     1df8:       48 00 00 01     bl      1df8 <__ieee80211_rx+0x468>
>                         1df8: R_PPC_REL24       ieee80211_get_hdrlen
>     1dfc:       80 18 00 a0     lwz     r0,160(r24)
>     1e00:       7c 00 1a 14     add     r0,r0,r3
>     1e04:       70 09 00 03     andi.   r9,r0,3
>     1e08:       41 a2 00 2c     beq+    1e34 <__ieee80211_rx+0x4a4>
>     1e0c:       3d 20 00 00     lis     r9,0
>                         1e0e: R_PPC_ADDR16_HA   .sbss
>     1e10:       80 09 00 00     lwz     r0,0(r9)
>                         1e12: R_PPC_ADDR16_LO   .sbss
>     1e14:       7c 00 00 34     cntlzw  r0,r0
>     1e18:       54 00 d9 7e     rlwinm  r0,r0,27,5,31
>     1e1c:       0f 00 00 00     twnei   r0,0
> 
> which is exactly the WARN_ON_ONCE above.

So zd1211rw-mac80211 is pushing some unaligned data up the RX path, hm.

-- 
Greetings Michael.
