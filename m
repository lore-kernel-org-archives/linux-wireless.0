Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:45138 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbXH2TxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2007 15:53:05 -0400
Message-ID: <46D5CE9B.8080401@warmcat.com>
Date: Wed, 29 Aug 2007 20:52:59 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: ian <ischram@telenet.be>
CC: =?ISO-8859-1?Q?Robert_F=FChricht?= <the_master_of_disaster@gmx.at>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211, iwlwifi and packet injection
References: <20070829161655.7f68542c@doppelhertz> <46D5B8B9.8000803@telenet.be>
In-Reply-To: <46D5B8B9.8000803@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> I'm believe that there are still other places where iwlwifi isn't
> ready to inject packages into the network though. Would need some
> work.

No, there's no general problem.  I just cooked current wireless-dev
everything and am running it on this Compaq nx7400 with a 3945 chip, it
has just sent 100,000 packetspams while pinging warmcat.com over an
associated connection, the injections verified on another box with a zd1211.

If I run NetworkManager though, it deassociates me after ~60 injections.
 With NM turned off it is fine.

BTW NetworkManager-0.6.5-7.fc7 also still tries to do its thing with
thinking the virtual interface is a second physical device, pushes it
into Managed, presents it as a second device on the UI, etc.  NM should
check and see if the network interface resolves to the same wiphy down
/sys and not do those things to virtual interfaces not in Managed already.

One thing though... I am associated on a WPA network when I run these
tests... is that the case for Robert I wonder?

-Andy
