Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:17435 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab0CXTnr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 15:43:47 -0400
Subject: Re: [Proposal]TX flags
From: Pavel Roskin <proski@gnu.org>
To: Bruno Randolf <br1@einfach.org>
Cc: Michael Stahn <m1kes@web.de>, linux-wireless@vger.kernel.org,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <201003242015.21409.br1@einfach.org>
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
	 <201003230942.15718.br1@einfach.org>
	 <loom.20100323T162144-640@post.gmane.org>
	 <201003242015.21409.br1@einfach.org>
Content-Type: text/plain
Date: Wed, 24 Mar 2010 15:43:45 -0400
Message-Id: <1269459825.2631.115.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-24 at 20:15 +0900, Bruno Randolf wrote:
> On Wednesday 24 March 2010 00:50:31 Michael Stahn wrote:
> > > similar to this we would also need to be able to specify that the beacon
> > > TSF should not be overwritten. maybe a general flag like "do not change"
> > > would do?
> > 
> > Is TSF really overwritten at manual injection from userspace?
> 
> Yes, it is, at least on ath5k. And as jouni has pointed out recently this 
> behaviour is expected by hostapd (maybe not for beacons but for probe 
> request/response frames, i dont know).
> 
> Gabor Stefanik proposed a while ago that frames should only be modified by the 
> driver in cooked monitor mode (COOK_FRAMES), that way we could avoid defining 
> new radiotap flags. What's your view on that, Jouni?

Maybe we could create a socket option that would put a _socket_ into a
cooked monitor mode?  A "monitor mode socket" would accept and transmit
packets with radiotap and 802.11 headers and receive the packets that
the interface already receives, also with radiotap and 802.11 headers.
That interface could be optimized for use with hostapd and other similar
programs.  The driver could fill some data from the interface settings.

The monitor mode, on the other hand, could be optimized for the
"hardcore" stuff when the driver interferes as little as possible.  Then
no special flags would be needed to pass the frame as is.

-- 
Regards,
Pavel Roskin
