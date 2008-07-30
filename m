Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45679 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422AbYG3Tld (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 15:41:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Issue: iwlist scanning sees the network; dhclient can't connect
Date: Wed, 30 Jul 2008 21:41:07 +0200
Cc: "Thiago F. Tavares" <ttavares@halogica.com>,
	linux-wireless@vger.kernel.org
References: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br> <1217446602.25919.5.camel@dv>
In-Reply-To: <1217446602.25919.5.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807302141.07738.mb@bu3sch.de> (sfid-20080730_214137_856327_D449F17C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 30 July 2008 21:36:42 Pavel Roskin wrote:
> On Wed, 2008-07-30 at 16:13 -0300, Thiago F. Tavares wrote:
> > Hello,
> >  
> > I have a problem with the broadcom wireless card (BCM4306 using b43).
> > I'm can list the wireless ESSIDs with "iwlist scanning" command, but I'm
> > can't connect in the LAN. My dhclient or dhcpcd can't receive an IP.
> > When I set a static IP, I can't ping the gateway.
> 
> dhclient is not suitable for wireless networking because it brings the
> interface down briefly and breaks the connection.  So I suggest that you
> use static addresses or a DHCP client that doesn't bring the interface
> down.

dhclient works fine for me. Although it's true that it sometimes
messes with up/down state. But you _can_ use it, if you take some care.

I suggest that you first associate with the wireless network before trying
to get an IP. That might result in slightly better connection qualities
to your AP.

Read the manpage for iwconfig and friends.

-- 
Greetings Michael.
