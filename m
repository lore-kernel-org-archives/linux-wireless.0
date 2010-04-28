Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:62615 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab0D1Rob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 13:44:31 -0400
Date: Wed, 28 Apr 2010 19:23:19 +0200
From: Antonio Quartulli <ordex@ritirata.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Luis Correia <luis.f.correia@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 6/9] rt2x00: Finish rt3070 support in
 rt2800 register initialization.
Message-ID: <20100428172319.GA19393@ritirata.org>
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
 <20100427111520.GA10969@ritirata.org>
 <20100428124736.GA8637@ritirata.org>
 <201004281456.16600.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201004281456.16600.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On mer, apr 28, 2010 at 02:56:16 +0200, Helmut Schaa wrote:
> Am Mittwoch 28 April 2010 schrieb Antonio Quartulli:
> > On mar, apr 27, 2010 at 01:15:21 +0200, Antonio Quartulli wrote:
> > > On lun, apr 26, 2010 at 01:11:20 +0200, Helmut Schaa wrote:
> > > > Am Montag 26 April 2010 schrieb Helmut Schaa:
> > > > > Am Sonntag 11 April 2010 schrieb Gertjan van Wingerde:
> > > > > > rt2x00 had preliminary support for RT3070 based devices, but the support was
> > > > > > incomplete.
> > > > > > Update the RT3070 register initialization to be similar to the latest Ralink
> > > > > > vendor driver.
> > > > > > 
> > > > > > With this patch my rt3070 based devices start showing a sign of life.
> > > > > 
> > > > > Gertjan, this patch breaks rx on my 305x SoC device. See inline comments for
> > > > > more details.
> > > > 
> > > > Antonio, did that patch also break rx on your PCI device with rt2872?
> > > > If not this is only needed for SoC.
> > > Hi, I cloned the wireless-testing git a few minutes ago.
> > > My card (rt2x00_set_chip: Info - Chipset detected - rt: 2872, rf: 0003,
> > > rev: 0200) on miniPCI works correctly without any kind of problem.
> > > No hangs at all.
> > 
> > Hi all, I found out that after this commit:
> > 
> > commit 23812383c6b03afef44c4aa642500f8235c3d079
> > Author: Helmut Schaa <helmut.schaa@googlemail.com>
> > Date:   Mon Apr 26 13:48:45 2010 +0200
> > 
> >     rt2x00: rt2800lib: Fix rx path on SoC devices
> > 
> > my card becomes unstable, I mean that the connection lose packets and
> > sometimes it disassociates from the AP.
> > I also found that the singnal level reported by iwconfig is wrong (it
> > reports -191dBm)
> 
> Uhhh, are you 100% sure? The patch doesn't touch any PCI code at all.
> Maybe the card was unstable before already? Could you please verify again?
> 
> Thanks you very much for your testing, it's really appreciated.
> 

I pull the latest commit on wireless-testing. Now it seems to work well.
I cannot understand what happened. Anyway the signal level is still
wrong because iwconfig shows a positive value instead of a negative one
(the absolute value seems plausible).

On 2.6.34-rc* kernel I still have the same issue I noticed some times
ago:

Apr 28 00:10:18 eagle3 kernel: [ 1359.907914] rt2800pci 0000:06:00.0: firmware: requesting rt2860.bin
Apr 28 00:10:18 eagle3 kernel: [ 1360.033584] phy1 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.26.
Apr 28 00:10:18 eagle3 kernel: [ 1360.043280] phy1 -> rt2800pci_load_firmware: Error - PBF system register not ready.
Apr 28 00:10:18 eagle3 kernel: [ 1360.043793] phy1 -> rt2x00pci_regbusy_read: Error - Indirect register access failed:
	offset=0x00007010, value=0x3dca191a


Regards

-- 
Antonio Quartulli

Ognuno di noi, da solo, non vale nulla 
Ernesto "Che" Guevara
