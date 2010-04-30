Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:47124 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758884Ab0D3Rye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 13:54:34 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2601fgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Apr 2010 10:54:32 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Antonio Quartulli <ordex@ritirata.org>
Subject: Re: [rt2x00-users] [PATCH 6/9] rt2x00: Finish rt3070 support in rt2800 register initialization.
Date: Fri, 30 Apr 2010 14:20:38 +0200
Cc: Luis Correia <luis.f.correia@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com> <201004281456.16600.helmut.schaa@googlemail.com> <20100428172319.GA19393@ritirata.org>
In-Reply-To: <20100428172319.GA19393@ritirata.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201004301420.38190.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 28 April 2010 schrieb Antonio Quartulli:
> On mer, apr 28, 2010 at 02:56:16 +0200, Helmut Schaa wrote:
> > Am Mittwoch 28 April 2010 schrieb Antonio Quartulli:
> > > Hi all, I found out that after this commit:
> > > 
> > > commit 23812383c6b03afef44c4aa642500f8235c3d079
> > > Author: Helmut Schaa <helmut.schaa@googlemail.com>
> > > Date:   Mon Apr 26 13:48:45 2010 +0200
> > > 
> > >     rt2x00: rt2800lib: Fix rx path on SoC devices
> > > 
> > > my card becomes unstable, I mean that the connection lose packets and
> > > sometimes it disassociates from the AP.
> > > I also found that the singnal level reported by iwconfig is wrong (it
> > > reports -191dBm)
> > 
> > Uhhh, are you 100% sure? The patch doesn't touch any PCI code at all.
> > Maybe the card was unstable before already? Could you please verify again?
> > 
> > Thanks you very much for your testing, it's really appreciated.
> > 
> 
> I pull the latest commit on wireless-testing. Now it seems to work well.
> I cannot understand what happened. Anyway the signal level is still
> wrong because iwconfig shows a positive value instead of a negative one
> (the absolute value seems plausible).

Hmm, my connection isn't always stable. Either the reception or the
transmission of frames still causes trouble sometimes.

When I force the device to use a fixed rate I can get a pretty stable
connection.

- 11g rates seem to work only when I'm really close to the AP (~1m)
- 11b rates seem to work much better but I can also see retries sometimes.
- 11n rates seem to work as well (but are not used by the default rate control
  algorithm yet).

So, could you please try different fixed rates and see what results you get?

iwconfig wlan0 rate 11M

should do the trick. Replace 11M in subsequent tests with 1M or 6M or 54M to
get different results.

Btw. does anybody know how I can force a fixed rate without Wext?

> On 2.6.34-rc* kernel I still have the same issue I noticed some times
> ago:
> 
> Apr 28 00:10:18 eagle3 kernel: [ 1359.907914] rt2800pci 0000:06:00.0: firmware: requesting rt2860.bin
> Apr 28 00:10:18 eagle3 kernel: [ 1360.033584] phy1 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.26.
> Apr 28 00:10:18 eagle3 kernel: [ 1360.043280] phy1 -> rt2800pci_load_firmware: Error - PBF system register not ready.
> Apr 28 00:10:18 eagle3 kernel: [ 1360.043793] phy1 -> rt2x00pci_regbusy_read: Error - Indirect register access failed:
> 	offset=0x00007010, value=0x3dca191a

Can't help you with these, sorry.

Helmut
