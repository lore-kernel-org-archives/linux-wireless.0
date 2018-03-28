Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753256AbeC1SN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 14:13:56 -0400
Date: Wed, 28 Mar 2018 20:13:46 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Mathias Kresin <dev@kresin.me>, Enrico Mioso <mrkiko.rs@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180328181344.GA26016@redhat.com> (sfid-20180328_201400_865033_AF7D6644)
References: <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com>
 <20180301153006.GJ1233@makrotopia.org>
 <20180307122701.GA10584@redhat.com>
 <20180307122935.GB10584@redhat.com>
 <d462681a-6a85-f76c-85a0-4e51b8529606@kresin.me>
 <20180326103551.GA2069@redhat.com>
 <24f8f4a2-b355-a1b3-d07a-940fc1e50fcc@kresin.me>
 <20180327171815.GA31338@redhat.com>
 <20180327174302.GB1206@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180327174302.GB1206@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Mar 27, 2018 at 07:43:04PM +0200, Daniel Golle wrote:
> That's great news! Are you running OpenWrt or some self-baked
> vanilla Linux with some of the OpenWrt patchery on top?

Just what OpenWRT/LEDE provides, but self compiled form git tree
to allow test patches.

> Also note that Tomislav Požega started porting more of the Rt6352
> calibration routines, I'd be happy if you could review those as well
> so they can go upstream right away:
> 
> https://github.com/openwrt/openwrt/pull/626

I didn't get into details, but first remark is that vendor drivers
have lot of stuff that are unused (i.e. are intended to chip versions
that do not get into market) and that stuff is masked by #ifdefs. So
it's needs to be determined if code is really needed. Also some 
stuff is needed only on particular revision of the chip.

Another general thing is that rt2800lib become terrible big and
hard to navigate. Perhaps RT6352 code should be moved into new file ? 

> Just in case you are not aware of it, here is my staging tree with some
> experimental changes for MT7620 including the fixes/work-arounds you
> suggested as well as @psyborg55's patches:
> 
> https://git.openwrt.org/?p=openwrt/staging/dangole.git;a=summary

I'm using it since 5 days :-)

Thanks
Stanislaw
