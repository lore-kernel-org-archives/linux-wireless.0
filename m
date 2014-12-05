Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaLEPRa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 10:17:30 -0500
Message-ID: <1417792644.2352.2.camel@dcbw.local> (sfid-20141205_161733_376022_E0CFD2C9)
Subject: Re: iwlwifi 6235 AGN: hardware limitation on number of stations
 that can connect in ap mode ?
From: Dan Williams <dcbw@redhat.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 05 Dec 2014 09:17:24 -0600
In-Reply-To: <955277702.20141205105522@eikelenboom.it>
References: <955277702.20141205105522@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-12-05 at 10:55 +0100, Sander Eikelenboom wrote:
> Hi Johannes,
> 
> I'm trying to use an Intel Corporation Centrino Advanced-N 6235 (rev 24) with 
> openwrt and hostapd to provide router functionality.
> That all works fine, except that it at max accepts 12 wireless clients.
> I have tried a few kernels (including 3.18-rc7) and versions of openwrt 
> (including trunk) already, but all to no avail.
> 
> So i'm wondering is there a hardware limitation of stations that can connect to 
> this mini-pci card in ap-mode ?
> 
> [   10.621530] iwlwifi 0000:00:05.0: loaded firmware version 18.168.6.1 op_mode iwldvm
> [   10.621546] iwlwifi 0000:00:05.0: CONFIG_IWLWIFI_DEBUG enabled
> [   10.621548] iwlwifi 0000:00:05.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [   10.621549] iwlwifi 0000:00:05.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [   10.621550] iwlwifi 0000:00:05.0: Detected Intel(R) Centrino(R) Advanced-N 6235 AGN, REV=0xB0
> [   10.621976] iwlwifi 0000:00:05.0: L1 Disabled - LTR Disabled
> [   10.640696] cfg80211: Ignoring regulatory request set by core since the driver uses its own custom regulatory domain
> [   10.640832] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> ...
> [   10.654858] lib80211: common routines for IEEE802.11 drivers
> [   10.654859] lib80211_crypt: registered algorithm 'NULL'
> [   10.654864] lib80211_crypt: registered algorithm 'WEP'
> [   10.654866] lib80211_crypt: registered algorithm 'CCMP'
> [   10.654869] lib80211_crypt: registered algorithm 'TKIP'
> ..
> [   31.016196] cfg80211: Calling CRDA to update world regulatory domain
> [   32.253288] iwlwifi 0000:00:05.0: L1 Disabled - LTR Disabled
> [   32.364036] iwlwifi 0000:00:05.0: Radio type=0x2-0x1-0x0
> [   33.008507] iwlwifi 0000:00:05.0: L1 Disabled - LTR Disabled
> [   33.116331] iwlwifi 0000:00:05.0: Radio type=0x2-0x1-0x0
> 
> 
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
> 
> The firmware seems to be the latest available for download.
> 
> If this isn't a hardware limitation, could you give a pointer to the debug 
> values to use so i can get the debug output you would be interested in ?

You might be running into:

dvm/commands.h:#define  IWLAGN_STATION_COUNT    16

I think a couple of those slots are used for book-keeping stuff, which
might be why you run out of them at 12.  Johannes or Emmanuel would know
more though.

Dan

> If it is a hardware limitation, are there any other intel mini-pci adapters that 
> don't have this hardware limitation (or at least a highter one).
> 
> --
> Sander
> 
> 
> lspci:
> 
> 00:05.0 Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)
>         Subsystem: Intel Corporation Centrino Advanced-N 6235 AGN
>         Physical Slot: 5
>         Flags: bus master, fast devsel, latency 0, IRQ 70
>         Memory at f3090000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [c8] Power Management version 3
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [e0] Express Endpoint, MSI 00
>         Kernel driver in use: iwlwifi
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


