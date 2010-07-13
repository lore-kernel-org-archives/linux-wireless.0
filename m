Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53306 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0GMTQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 15:16:04 -0400
Received: by bwz1 with SMTP id 1so483454bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jul 2010 12:16:03 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: Rate control & USB
Date: Tue, 13 Jul 2010 21:15:16 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com> <201007122114.09571.helmut.schaa@googlemail.com> <AANLkTil9g4VT2tROcjSYu1hGNQ04M5psSzxLfpOGE9DS@mail.gmail.com>
In-Reply-To: <AANLkTil9g4VT2tROcjSYu1hGNQ04M5psSzxLfpOGE9DS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007132115.16101.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 13 Juli 2010 schrieb Ivo Van Doorn:
> On Mon, Jul 12, 2010 at 9:14 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
> > Am Montag 12 Juli 2010 schrieb Ivo Van Doorn:
> >> I am currently looking into the old problem of the mac80211 rate
> >> control algorithms
> >> and USB devices. The Ralink USB devices (and as far as I know, the
> >> other USB devices
> >> as well), do not work well with the PID and Minstrel algorithms. This
> >> is caused by the
> >> fact that USB devices do not report the TX status to mac80211.
> >
> > Ivo, do you know by any chance if the USB devices also have a TX_STA_FIFO
> > register like the PCI variants? Does it contain useful data or just crap?
> 
> Well I guess he has the registers (we don't have rt2870 specific specsheets,
> but the register definitions from the original Ralink driver to
> suggest the register
> is there). However, even if it contains valid data, how do you want to match
> the contents of that register with the sent frames in the queue?

We could stuff a unique packet ID into the TXWI and the TX_STA_FIFO should
contain the same ID alongside the TX status after the frame was processed
by the hw.

> And another downside, is that the above only applies to rt2800usb, and not
> for rt73usb and rt2500usb, which neither have the TX status register, and were
> replaced with statistics registers (which I want to read for the batch
> TX status).

Ok, that's a valid argument ...

Helmut
