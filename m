Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:56774 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728488AbeHPBxs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 21:53:48 -0400
Date: Thu, 16 Aug 2018 00:35:29 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kofi Agor <nenekofi@gmail.com>, Enrico Mioso <mrkiko.rs@gmail.com>,
        Craig Matsuura <cmatsuura@vivint.com>,
        Mathias Kresin <dev@kresin.me>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180815223526.GC1243@makrotopia.org> (sfid-20180816_005936_038463_7B20AC3F)
References: <alpine.LNX.2.21.99.1803280605580.2911@mStation.localdomain>
 <CAOt++SeSQ2j1KuVkbqt77LfznXN7JV0Lx5O8d7-m2VBrz8=85g@mail.gmail.com>
 <alpine.LNX.2.21.99.1803301642110.31428@mStation.localdomain>
 <MWHPR02MB3326233159B021143D7278F5D4A10@MWHPR02MB3326.namprd02.prod.outlook.com>
 <alpine.LNX.2.21.99.1803301931300.5692@mStation.localdomain>
 <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
 <20180417194255.GA17067@redhat.com>
 <CAOt++SeNt=4RUTvAR1y_WjC=a-YyYa3YBSmoAmv+7uK71U+3+A@mail.gmail.com>
 <20180528125039.GA22122@redhat.com>
 <20180815114029.GA1862@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180815114029.GA1862@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, Aug 15, 2018 at 01:40:30PM +0200, Stanislaw Gruszka wrote:
> On Mon, May 28, 2018 at 02:50:39PM +0200, Stanislaw Gruszka wrote:
> > I have some updates here.
> 
> And now more updates. I have 5 patches to test here:
> https://github.com/sgruszka/wireless-drivers-next/commits/rt2800-draft-v2
> 
> as reported by T-Bone here:
> https://bugzilla.kernel.org/show_bug.cgi?id=82751
> first 3 patches made Netgear WN3000RPv3 router workable.
> Another 2 should be further improvement, but were not tested broadly
> and can have some bugs.
> 
> Daniel, could you apply this on your staging tree for testing?

Done and rebased on top of blogic's tree with mac80211 from v4.18-rc7
instead of (outdated) wireless-testing.
Only compile-tested by myself for now, maybe someone can run a build on
actual MT7620 hardware?

Clone the master branch of
https://git.openwrt.org/openwrt/staging/dangole.git
and give it shot and let us know the results.

> Please also remove:
> 600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
> 991-rt2800_change_rx_ampdu_factor.patch
> 992-rt2800_change_ba_size.patch
> 993-rt2800_change_rx_ampdu_density.patch
> Those are not needed and can be harmful with the test patches,
> (especially spurious interrupt one, patches will not apply cleanly 
> with it).

Ack. Hope it doesn't break Rt3883 and/or Rt3663 for which that patch
was added by Gabor Juhos a decade ago...

> 
> Patches should make "Dropping frame due to full tx queue" and
> "Queue 2 failed to flush" errors gone. However if device is somewhat
> wrongly configured by driver at low level (i.e. wrong MAC/BBP/RF
> registers programing) there still will be troubles to have stable
> and fast wireless connection.
> 
> On TODO site, the proper watchdog should be added, but I'm not sure
> how to exactly detect device/firmware hung and how exactly device should
> be rested (by some HW reset by register or by doing full reinitialization).
> 
> Another thing is fixing RATE_PROBE frames which are aggregated with
> other frames and not sent at requested rate. I implemented qsel queue patch
> similar to mt76, but this not work as expected on older Ralink chips.  
> https://github.com/sgruszka/wireless-drivers-next/commit/846d205edd8c36d1b7828fee54bf4cf40bf8cb1a

Which hardware did you try? Just so I can reproduce what's going on
and maybe help fixing it...


Cheers

Daniel

> 
> Any help with those 2 problems are welcome.
>  
> Thanks
> Stanislaw
> 
