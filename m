Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49166 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0GMG7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 02:59:48 -0400
Received: by bwz1 with SMTP id 1so2806bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 23:59:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201007122114.09571.helmut.schaa@googlemail.com>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
	<201007122114.09571.helmut.schaa@googlemail.com>
Date: Tue, 13 Jul 2010 08:59:46 +0200
Message-ID: <AANLkTil9g4VT2tROcjSYu1hGNQ04M5psSzxLfpOGE9DS@mail.gmail.com>
Subject: Re: Rate control & USB
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 12, 2010 at 9:14 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Montag 12 Juli 2010 schrieb Ivo Van Doorn:
>> I am currently looking into the old problem of the mac80211 rate
>> control algorithms
>> and USB devices. The Ralink USB devices (and as far as I know, the
>> other USB devices
>> as well), do not work well with the PID and Minstrel algorithms. This
>> is caused by the
>> fact that USB devices do not report the TX status to mac80211.
>
> Ivo, do you know by any chance if the USB devices also have a TX_STA_FIFO
> register like the PCI variants? Does it contain useful data or just crap?

Well I guess he has the registers (we don'[t have rt2870 specific specsheets,
but the register definitions from the original Ralink driver to
suggest the register
is there). However, even if it contains valid data, how do you want to match
the contents of that register with the sent frames in the queue?

And another downside, is that the above only applies to rt2800usb, and not
for rt73usb and rt2500usb, which neither have the TX status register, and were
replaced with statistics registers (which I want to read for the batch
TX status).

Ivo
