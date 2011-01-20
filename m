Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40635 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1ATTDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 14:03:09 -0500
Received: by wwi17 with SMTP id 17so1836882wwi.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 11:03:08 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Fwd: [Linux Wireless] Update of "en/users/Drivers/carl9170" by PaulFertser
Date: Thu, 20 Jan 2011 20:02:49 +0100
Cc: Paul Fertser <fercerpav@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <20110120183210.13527.33808@he.sipsolutions.net> <20110120184336.GK3333@home.lan> <AANLkTimFGzFgjNWs4QyHuyGixgCiDm_uAb_z4t4m7nD8@mail.gmail.com>
In-Reply-To: <AANLkTimFGzFgjNWs4QyHuyGixgCiDm_uAb_z4t4m7nD8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201101202002.49840.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 January 2011 19:50:43 Luis R. Rodriguez wrote:
> On Thu, Jan 20, 2011 at 10:43 AM, Paul Fertser <fercerpav@gmail.com> wrote:
> > On Thu, Jan 20, 2011 at 10:37:20AM -0800, Luis R. Rodriguez wrote:
> >> Huh?
> >
> > Christian asked me to add that info to the wiki, is something i wrote wrong?
> 
> It is unclear to me, are you saying carl9170 does not support QoS and
> aggregation?

It's not only carl9170, it's AR9170 (the chip) .

Take a look into the original firmware:

<http://git.kernel.org/?p=linux/kernel/git/mcgrof/ar9170-fw.git;a=blob;f=STA/hostif.c;h=aa277d14ee5ec4c222b83975d7dc2d5c66dbf91c;hb=2e3574ce10c74a82047a06b046855de14d969948#l107>

107					/* TxQ number */
108					//txqNum = (buf[2] >> 13);
109					//if (txqNum > 4)
110					{
111						txqNum = 0;
112					}
113 
114					zfDmaPutPacket(&zgTxQ[txqNum], desc);
115					/* Trigger WLAN TX DMA */
116					zm_wl_dma_trigger_reg = (1 << txqNum);

So yes, someone took a shortcut along the way.

Regards,
	Chr
