Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:46230 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752399AbeC0RnS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 13:43:18 -0400
Date: Tue, 27 Mar 2018 19:43:04 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mathias Kresin <dev@kresin.me>, Enrico Mioso <mrkiko.rs@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180327174302.GB1206@makrotopia.org> (sfid-20180327_194333_885175_AE594F6D)
References: <20180123132234.GC2520@redhat.com>
 <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com>
 <20180301153006.GJ1233@makrotopia.org>
 <20180307122701.GA10584@redhat.com>
 <20180307122935.GB10584@redhat.com>
 <d462681a-6a85-f76c-85a0-4e51b8529606@kresin.me>
 <20180326103551.GA2069@redhat.com>
 <24f8f4a2-b355-a1b3-d07a-940fc1e50fcc@kresin.me>
 <20180327171815.GA31338@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180327171815.GA31338@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Tue, Mar 27, 2018 at 07:18:16PM +0200, Stanislaw Gruszka wrote:
> On Tue, Mar 27, 2018 at 09:46:36AM +0200, Mathias Kresin wrote:
> > > Could you test just RX AMPDU patches, i.e.
> > > 
> > > rt2800_change_rx_ampdu_factor.patch
> > > rt2800_change_rx_ampdu_density.patch
> > > 
> > > I have somewhat positive results on RX performance on some devices
> > > with those. Perhaps you could confirm that :-)
> > 
> > This time I've done the test with HT20 only, to not annoy my neighbours.
> > 
> > The test setup is the following:
> > 
> > ath9k (STA) <=> (AP) o2 Box 6431 (RJ45) <=> desktop
> > 
> > With the patches applied the bandwidth is somewhat around 10 MBit/sec lower.
> > Even if I was able to reliable reproduce it, I'm not sure if it is within
> > the measuring tolerance.
> 
> Ok. I think when BBP/RF is correctly programmed patches will downgrade
> performance. For not well optimized devices patches might
> improve things , but this is not preferred solution. For 30+ client
> scenario I suggest to just disable HT (11n) in OpenWRT config.
> 
> Additionally since those errors do not happen frequently perhaps there
> is possibility to create watchdog and reset the device when problems
> start to happen.
> 
> FWIW: I'm running wt3020 (mt7620 device) as my home router for 3 weeks now
> and do not see any errors (I have 4 client devices). Performance measured
> by iperf is not good though - about 40 Mbit/s .

That's great news! Are you running OpenWrt or some self-baked
vanilla Linux with some of the OpenWrt patchery on top?
Also note that Tomislav Požega started porting more of the Rt6352
calibration routines, I'd be happy if you could review those as well
so they can go upstream right away:

https://github.com/openwrt/openwrt/pull/626

Just in case you are not aware of it, here is my staging tree with some
experimental changes for MT7620 including the fixes/work-arounds you
suggested as well as @psyborg55's patches:

https://git.openwrt.org/?p=openwrt/staging/dangole.git;a=summary


Cheers


Daniel
