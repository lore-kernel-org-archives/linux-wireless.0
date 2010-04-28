Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46629 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0D1M4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 08:56:35 -0400
Received: by bwz19 with SMTP id 19so6313bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 28 Apr 2010 05:56:32 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Antonio Quartulli <ordex@ritirata.org>
Subject: Re: [rt2x00-users] [PATCH 6/9] rt2x00: Finish rt3070 support in rt2800 register initialization.
Date: Wed, 28 Apr 2010 14:56:16 +0200
Cc: Luis Correia <luis.f.correia@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com> <20100427111520.GA10969@ritirata.org> <20100428124736.GA8637@ritirata.org>
In-Reply-To: <20100428124736.GA8637@ritirata.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201004281456.16600.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch 28 April 2010 schrieb Antonio Quartulli:
> On mar, apr 27, 2010 at 01:15:21 +0200, Antonio Quartulli wrote:
> > On lun, apr 26, 2010 at 01:11:20 +0200, Helmut Schaa wrote:
> > > Am Montag 26 April 2010 schrieb Helmut Schaa:
> > > > Am Sonntag 11 April 2010 schrieb Gertjan van Wingerde:
> > > > > rt2x00 had preliminary support for RT3070 based devices, but the support was
> > > > > incomplete.
> > > > > Update the RT3070 register initialization to be similar to the latest Ralink
> > > > > vendor driver.
> > > > > 
> > > > > With this patch my rt3070 based devices start showing a sign of life.
> > > > 
> > > > Gertjan, this patch breaks rx on my 305x SoC device. See inline comments for
> > > > more details.
> > > 
> > > Antonio, did that patch also break rx on your PCI device with rt2872?
> > > If not this is only needed for SoC.
> > Hi, I cloned the wireless-testing git a few minutes ago.
> > My card (rt2x00_set_chip: Info - Chipset detected - rt: 2872, rf: 0003,
> > rev: 0200) on miniPCI works correctly without any kind of problem.
> > No hangs at all.
> 
> Hi all, I found out that after this commit:
> 
> commit 23812383c6b03afef44c4aa642500f8235c3d079
> Author: Helmut Schaa <helmut.schaa@googlemail.com>
> Date:   Mon Apr 26 13:48:45 2010 +0200
> 
>     rt2x00: rt2800lib: Fix rx path on SoC devices
> 
> my card becomes unstable, I mean that the connection lose packets and
> sometimes it disassociates from the AP.
> I also found that the singnal level reported by iwconfig is wrong (it
> reports -191dBm)

Uhhh, are you 100% sure? The patch doesn't touch any PCI code at all.
Maybe the card was unstable before already? Could you please verify again?

Thanks you very much for your testing, it's really appreciated.

Helmut
