Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56405 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbaLFISq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2014 03:18:46 -0500
Message-ID: <1417853921.2046.1.camel@sipsolutions.net> (sfid-20141206_091849_745959_F91EF094)
Subject: Re: iwlwifi 6235 AGN: hardware limitation on number of stations
 that can connect in ap mode ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Sat, 06 Dec 2014 09:18:41 +0100
In-Reply-To: <955277702.20141205105522@eikelenboom.it> (sfid-20141205_110059_932860_1A930067)
References: <955277702.20141205105522@eikelenboom.it>
	 (sfid-20141205_110059_932860_1A930067)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sander,

> So i'm wondering is there a hardware limitation of stations that can connect to 
> this mini-pci card in ap-mode ?

Yes, there's a hardware/firmware limitation of 16 "station entries".

> the first clients connect perfectly well but after 12 client have connected, for 
> the 13th i get:
> 
> [  784.301106] wlan0: Allocated STA 00:0d:f0:2e:ee:02
> [  784.301117] wlan0: moving STA 00:0d:f0:2e:ee:02 to state 2
> [  784.301122] wlan0: moving STA 00:0d:f0:2e:ee:02 to state 3
> [  784.301141] iwlwifi 0000:00:05.0: Unable to prepare station 00:0d:f0:2e:ee:02 for addition
> [  784.481399] iwlwifi 0000:00:05.0: Unable to add station 00:0d:f0:2e:ee:02 (-22)
> [  784.647835] wlan0: Destroyed STA 00:0d:f0:2e:ee:02
> [  785.828588] wlan0: Allocated STA 00:0d:f0:2e:ee:02
> [  785.828600] wlan0: moving STA 00:0d:f0:2e:ee:02 to state 2
> [  785.828605] wlan0: moving STA 00:0d:f0:2e:ee:02 to state 3
> [  785.828624] iwlwifi 0000:00:05.0: Unable to prepare station 00:0d:f0:2e:ee:02 for addition
> [  786.044379] iwlwifi 0000:00:05.0: Unable to add station 00:0d:f0:2e:ee:02 (-22)
> [  786.219632] wlan0: Destroyed STA 00:0d:f0:2e:ee:02

Right. I'm not exactly sure why we put -EINVAL rather than -ENOSPC or
something like that, but this is a limitation.

> If it is a hardware limitation, are there any other intel mini-pci adapters that 
> don't have this hardware limitation (or at least a highter one).

With the newer 7260/7265 adapters you might be able to go up to 14 or 15
stations (I haven't checked exactly), but that's not a significant
increase - the fundamental limit of 16 station entries is still there
and at least one is needed for internal tracking for multi-/broadcast
transmit transmit (and another one might be reserved for P2P on those
devices, and I might be forgetting another one perhaps which would mean
13 is the max)

I don't believe that the driver (or even firmware) would be able to work
around this.

johannes

