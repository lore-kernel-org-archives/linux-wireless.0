Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62184 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0GNByB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 21:54:01 -0400
Received: by iwn7 with SMTP id 7so6470939iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jul 2010 18:54:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikP6mK-S5kLVrRDiQGX9MAgOt-uyUn0A1Z-593A@mail.gmail.com>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
	<201007122114.09571.helmut.schaa@googlemail.com> <AANLkTil9g4VT2tROcjSYu1hGNQ04M5psSzxLfpOGE9DS@mail.gmail.com>
	<201007132115.16101.helmut.schaa@googlemail.com> <AANLkTikP6mK-S5kLVrRDiQGX9MAgOt-uyUn0A1Z-593A@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 14 Jul 2010 11:53:40 +1000
Message-ID: <AANLkTilWtwXuJ8ZA_QHDGURnbTOwlJXivBewSvAr4ncj@mail.gmail.com>
Subject: Re: Rate control & USB
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 14, 2010 at 05:51, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> On Tue, Jul 13, 2010 at 9:15 PM, Helmut Schaa
> <helmut.schaa@googlemail.com> wrote:
>> Am Dienstag 13 Juli 2010 schrieb Ivo Van Doorn:
>>> On Mon, Jul 12, 2010 at 9:14 PM, Helmut Schaa
>>> <helmut.schaa@googlemail.com> wrote:
>>> > Am Montag 12 Juli 2010 schrieb Ivo Van Doorn:
>>> >> I am currently looking into the old problem of the mac80211 rate
>>> >> control algorithms
>>> >> and USB devices. The Ralink USB devices (and as far as I know, the
>>> >> other USB devices
>>> >> as well), do not work well with the PID and Minstrel algorithms. This
>>> >> is caused by the
>>> >> fact that USB devices do not report the TX status to mac80211.
>>> >
>>> > Ivo, do you know by any chance if the USB devices also have a TX_STA_FIFO
>>> > register like the PCI variants? Does it contain useful data or just crap?
>>>
>>> Well I guess he has the registers (we don't have rt2870 specific specsheets,
>>> but the register definitions from the original Ralink driver to
>>> suggest the register
>>> is there). However, even if it contains valid data, how do you want to match
>>> the contents of that register with the sent frames in the queue?
>>
>> We could stuff a unique packet ID into the TXWI and the TX_STA_FIFO should
>> contain the same ID alongside the TX status after the frame was processed
>> by the hw.
>
> True, but we would have the same problem in rt2800pci, that the number
> of bits is too limited to completely identify a queue + queue index correctly.

We could have a table that matches queue and queue index to the
packet's ID. So if we're sending packet #47 from queue #1, and it gets
assigned id #9, then we drop that information into the table - so when
the hardware tells us the status of packet id #9 we can look up which
queue it is and send it to the right place.

Of course, this means storing a stack of extra data in system memory,
as well as having the complexity of looking up the queue data when we
get the status back, but if we've only got limited bits, then that'll
set a hard limit on the amount of data and time to retrieve, and we
may not even need all of it unless the hardware's running at full
capacity. We could reduce it further if we don't need a status of
*every* packet - we could potentially get away with only storing data
for, let's say, every fourth packet or something.

As we're likely to see similarly crippled devices elsewhere, maybe we
could incorporate this type of accounting into mac80211 somewhere.

Of course, this could just be a huge stack of overhead for a problem
that could be solved much more elegantly, but yeah.

*hands over $0.02*

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
