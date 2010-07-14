Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40738 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757766Ab0GNVg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 17:36:28 -0400
Received: by bwz1 with SMTP id 1so224758bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 14:36:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilWtwXuJ8ZA_QHDGURnbTOwlJXivBewSvAr4ncj@mail.gmail.com>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
	<201007122114.09571.helmut.schaa@googlemail.com>
	<AANLkTil9g4VT2tROcjSYu1hGNQ04M5psSzxLfpOGE9DS@mail.gmail.com>
	<201007132115.16101.helmut.schaa@googlemail.com>
	<AANLkTikP6mK-S5kLVrRDiQGX9MAgOt-uyUn0A1Z-593A@mail.gmail.com>
	<AANLkTilWtwXuJ8ZA_QHDGURnbTOwlJXivBewSvAr4ncj@mail.gmail.com>
Date: Wed, 14 Jul 2010 23:36:26 +0200
Message-ID: <AANLkTik_-N2DKSuZpczhVZ4AaextPnb3og1Lt1L-t_x8@mail.gmail.com>
Subject: Re: Rate control & USB
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 14, 2010 at 3:53 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> On Wed, Jul 14, 2010 at 05:51, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
>> On Tue, Jul 13, 2010 at 9:15 PM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>>> Am Dienstag 13 Juli 2010 schrieb Ivo Van Doorn:
>>>> On Mon, Jul 12, 2010 at 9:14 PM, Helmut Schaa
>>>> <helmut.schaa@googlemail.com> wrote:
>>>> > Am Montag 12 Juli 2010 schrieb Ivo Van Doorn:
>>>> >> I am currently looking into the old problem of the mac80211 rate
>>>> >> control algorithms
>>>> >> and USB devices. The Ralink USB devices (and as far as I know, the
>>>> >> other USB devices
>>>> >> as well), do not work well with the PID and Minstrel algorithms. This
>>>> >> is caused by the
>>>> >> fact that USB devices do not report the TX status to mac80211.
>>>> >
>>>> > Ivo, do you know by any chance if the USB devices also have a TX_STA_FIFO
>>>> > register like the PCI variants? Does it contain useful data or just crap?
>>>>
>>>> Well I guess he has the registers (we don't have rt2870 specific specsheets,
>>>> but the register definitions from the original Ralink driver to
>>>> suggest the register
>>>> is there). However, even if it contains valid data, how do you want to match
>>>> the contents of that register with the sent frames in the queue?
>>>
>>> We could stuff a unique packet ID into the TXWI and the TX_STA_FIFO should
>>> contain the same ID alongside the TX status after the frame was processed
>>> by the hw.
>>
>> True, but we would have the same problem in rt2800pci, that the number
>> of bits is too limited to completely identify a queue + queue index correctly.
>
> We could have a table that matches queue and queue index to the
> packet's ID. So if we're sending packet #47 from queue #1, and it gets
> assigned id #9, then we drop that information into the table - so when
> the hardware tells us the status of packet id #9 we can look up which
> queue it is and send it to the right place.

True, but the overhead of having that lookup table is not really worth
it I believe.
This solution depends on the number of bits available, thus it works
only for rt2800usb,
while with a different RC method I am looking for a more generic solution.

> Of course, this means storing a stack of extra data in system memory,
> as well as having the complexity of looking up the queue data when we
> get the status back, but if we've only got limited bits, then that'll
> set a hard limit on the amount of data and time to retrieve, and we
> may not even need all of it unless the hardware's running at full
> capacity. We could reduce it further if we don't need a status of
> *every* packet - we could potentially get away with only storing data
> for, let's say, every fourth packet or something.

Well it should be up to the RC algorithm to indicate for which frames
it at least demands a TX status and for which frames it is less important.

> As we're likely to see similarly crippled devices elsewhere, maybe we
> could incorporate this type of accounting into mac80211 somewhere.

That really depends on which devices actually have the TX status reporting
registers without any mapping to a real packet. I think there are more devices
without TX status reporting and without TX status registers, than those with the
TX status registers.

Ivo
