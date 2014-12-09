Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:38930 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbaLIK0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2014 05:26:47 -0500
Date: Tue, 9 Dec 2014 11:26:41 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <1077310936.20141209112641@eikelenboom.it> (sfid-20141209_112651_094785_3E83A6F2)
To: Johannes Berg <johannes@sipsolutions.net>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: iwlwifi 6235 AGN: hardware limitation on number of stations that can connect in ap mode ?
In-Reply-To: <1417853921.2046.1.camel@sipsolutions.net>
References: <955277702.20141205105522@eikelenboom.it> (sfid-20141205_110059_932860_1A930067) <1417853921.2046.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Saturday, December 6, 2014, 9:18:41 AM, you wrote:

> Hi Sander,

>> So i'm wondering is there a hardware limitation of stations that can connect to 
>> this mini-pci card in ap-mode ?

> Yes, there's a hardware/firmware limitation of 16 "station entries".

>> the first clients connect perfectly well but after 12 client have connected, for 
>> the 13th i get:
>> 
>> [  784.301106] wlan0: Allocated STA 00:0d:f0:2e:ee:02
>> [  784.301117] wlan0: moving STA 00:0d:f0:2e:ee:02 to state 2
>> [  784.301122] wlan0: moving STA 00:0d:f0:2e:ee:02 to state 3
>> [  784.301141] iwlwifi 0000:00:05.0: Unable to prepare station 00:0d:f0:2e:ee:02 for addition
>> [  784.481399] iwlwifi 0000:00:05.0: Unable to add station 00:0d:f0:2e:ee:02 (-22)
>> [  784.647835] wlan0: Destroyed STA 00:0d:f0:2e:ee:02
>> [  785.828588] wlan0: Allocated STA 00:0d:f0:2e:ee:02
>> [  785.828600] wlan0: moving STA 00:0d:f0:2e:ee:02 to state 2
>> [  785.828605] wlan0: moving STA 00:0d:f0:2e:ee:02 to state 3
>> [  785.828624] iwlwifi 0000:00:05.0: Unable to prepare station 00:0d:f0:2e:ee:02 for addition
>> [  786.044379] iwlwifi 0000:00:05.0: Unable to add station 00:0d:f0:2e:ee:02 (-22)
>> [  786.219632] wlan0: Destroyed STA 00:0d:f0:2e:ee:02

> Right. I'm not exactly sure why we put -EINVAL rather than -ENOSPC or
> something like that, but this is a limitation.

>> If it is a hardware limitation, are there any other intel mini-pci adapters that 
>> don't have this hardware limitation (or at least a highter one).

> With the newer 7260/7265 adapters you might be able to go up to 14 or 15
> stations (I haven't checked exactly), but that's not a significant
> increase - the fundamental limit of 16 station entries is still there
> and at least one is needed for internal tracking for multi-/broadcast
> transmit transmit (and another one might be reserved for P2P on those
> devices, and I might be forgetting another one perhaps which would mean
> 13 is the max)

> I don't believe that the driver (or even firmware) would be able to work
> around this.

> johannes

Johannes / Dan,

Thanks for the info and fast reply, very useful and appreciated !

It makes clear what i have to try and verify with other hardware/drivers,
to see if i can get better results with that, unfortunately it's not something
that is clearly communicated since it is a niche and most router chips are 
integrated, so it stays unclear if a same chipset is used on routers will behave 
the same on a mini-pcie card (the driver of course does if openwrt and thus 
linux can be used, but the hardware + firmware could be different.

Any how, thanks again !

--
Sander




