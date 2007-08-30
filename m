Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbXH3Nnl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 09:43:41 -0400
Subject: Re: mac80211, iwlwifi and packet injection
From: Dan Williams <dcbw@redhat.com>
To: Andy Green <andy@warmcat.com>
Cc: ian <ischram@telenet.be>,
	Robert =?ISO-8859-1?Q?F=FChricht?=
	<the_master_of_disaster@gmx.at>, linux-wireless@vger.kernel.org
In-Reply-To: <46D5CE9B.8080401@warmcat.com>
References: <20070829161655.7f68542c@doppelhertz>
	 <46D5B8B9.8000803@telenet.be>  <46D5CE9B.8080401@warmcat.com>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 09:37:53 -0400
Message-Id: <1188481073.27590.11.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-08-29 at 20:52 +0100, Andy Green wrote:
> Somebody in the thread at some point said:
> 
> > I'm believe that there are still other places where iwlwifi isn't
> > ready to inject packages into the network though. Would need some
> > work.
> 
> No, there's no general problem.  I just cooked current wireless-dev
> everything and am running it on this Compaq nx7400 with a 3945 chip, it
> has just sent 100,000 packetspams while pinging warmcat.com over an
> associated connection, the injections verified on another box with a zd1211.
> 
> If I run NetworkManager though, it deassociates me after ~60 injections.
>  With NM turned off it is fine.
> 
> BTW NetworkManager-0.6.5-7.fc7 also still tries to do its thing with
> thinking the virtual interface is a second physical device, pushes it
> into Managed, presents it as a second device on the UI, etc.  NM should
> check and see if the network interface resolves to the same wiphy down
> /sys and not do those things to virtual interfaces not in Managed already.

No, NM shouldn't be touching /sys at all.  That's HAL's job.  If there's
a device out there that's an 802.11 device, NM will attempt to control
it.  I don't really see why that's wrong.  What's more wrong is
representing the same underlying device with separate _wireless_
devices.  Normally (atheros, airo) drivers that have "special"
interfaces set other bits on them so they get ignored.  This sucks
though, the raw 802.11 stuff should go through other channels, not have
to create a completely separate device.

I assume what you'd like to do is have NM ignore the fact that you just
turned on some sort of "raw" mode on the device.  Unfortunately, WEXT
doesn't give us the flexibility to OR the modes.  Ideally
"raw"/"monitor" would just be attributes of the device that wouldn't
really affect it's normal operation.

WRT the disconnection, please run 'iwevent' during your packet injection
runs and see if the driver sends you an SIOCGIWAP event filled with
zeros, meaning that the driver disconnected you.  Also please run a few
'iwlist ethX scan' commands about 30 seconds or more apart during that
run, and see what the 'iwevent' says.  My suspicion is that doing scans
during the injection while associated makes the card hiccup, causing NM
to notice the disconnection event and kill the connection (rightly so).

Dan

> One thing though... I am associated on a WPA network when I run these
> tests... is that the case for Robert I wonder?
> 
> -Andy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

