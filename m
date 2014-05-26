Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62451 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaEZLxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 07:53:46 -0400
Received: by mail-wg0-f50.google.com with SMTP id x12so7801858wgg.33
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 04:53:44 -0700 (PDT)
MIME-Version: 1.0
Reply-To: andrea.merello@gmail.com
In-Reply-To: <CAN8YU5P5rFjjF9kjLBi0qXwZ1-Zphfi-fbY048wbO9oBmKoULQ@mail.gmail.com>
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
 <1400509775.4273.8.camel@jlt4.sipsolutions.net> <1400510950.4273.9.camel@jlt4.sipsolutions.net>
 <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com>
 <1400515344.4273.19.camel@jlt4.sipsolutions.net> <CAN8YU5P5rFjjF9kjLBi0qXwZ1-Zphfi-fbY048wbO9oBmKoULQ@mail.gmail.com>
From: Andrea Merello <andrea.merello@gmail.com>
Date: Mon, 26 May 2014 13:53:23 +0200
Message-ID: <CAN8YU5OgcuaLv3C=_Lg0E6p1kHqhYZ-PjSgqaTxjJ=EV7VhNaw@mail.gmail.com> (sfid-20140526_135349_487830_BB53E73C)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, Alex Stewart <alex@foogod.com>,
	n0_5p4m_p13453@hotmail.com, Pavel Roskin <proski@gnu.org>,
	agx@sigxcpu.org, Kalle Valo <kalle.valo@iki.fi>, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Johannes, I tested your patch:
Unfortunately it seems it does the same as mine..

In order to test it, I tried to hack the code (with your patch
applied) with only one fixed channel number hardcoded in the scan
command (thus, the scan will repeat for several times, and the SW
believes to scan one channel per time, but I forced the scan command
to stick only on one channel every time).

What's happened is that I still can see the usual huge BSS list, that
includes even BSS from far channels..
Furthermore, by sniffing on a fixed channel with another reference
card, I could see several probe-requests from the at56x703, some with
a very strong signal, and some other with really weaker signal,
possibly suggesting the card is sweeping, and they have been send on
some nearby channel..

Finally I (quickly) tried monitor mode on at56x703, that uses the same
trick to change channel. Maybe it's worth to do more tests on it to
confirm this, BTW It seems that changing channel in monitor mode does
something, and, by looking at a live capture with wireshark, it seems
even that the card finally stays on a channel (altought I can't say if
it does this after a quick sweep)..  But anyway it didn't work as I
expected: I didn't received what I expected, and it seems that, at
least, it sets on the wrong channel.

Indeed there is some confusion about what the scan command with
specified channel does (at least for me)..
If some of the driver's authors (in CC ) that have more knowledge of
the HW/FW can enlight me, then it is maybe possible not only to fix
step-by-step scanning, but also the "monitor" mode (provided that it
does not turn out that it actually works, and that my quick test was
broken..).

If this is not the case (no one knowns/tells) IMHO the two choice are:
- do what we said: parse beacons to extract channel information (and
let monitor mode stay as it is)

- do more investigation trying to fix also monitor mode issue.

I could do some work on this (including opening the dongle to see if I
can put HW probes on the RF chip, to see on with frequency the FW
tunes it when scan commands are sent).

Also AFAIK there is a new firmware in the off-tree Atmel driver, that
AFAIK also support WPA.
If this turns out to be true, then I'm tempted to rework the driver
for using it (hoping the the scan command works better on it).

FYI :
Honestly I'm unsure if it's worth to do these last things:

On one hand it is a very old device, and I think it has few users out
of there.. And probably I could do more interesting things.
On the other hand I have one of this devices and I still use it :) And
indeed no one pay me for my work on Linux drivers, so I have no
deadlines or mandatory jobs to do, and as long as it does amuse me
it's a fair game :)

Andrea

On Mon, May 19, 2014 at 6:05 PM, Andrea Merello
<andrea.merello@gmail.com> wrote:
> Yes, I agree.. I thougth the same thing: parsing
> beacons/probe-response in the driver was also my last resort :)
>
> Andrea
>
> On Mon, May 19, 2014 at 6:02 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Mon, 2014-05-19 at 17:42 +0200, Andrea Merello wrote:
>>
>>> About Johannes patch.. Looks good :) But I already tried to do almost
>>> the same thing in the at79 driver, but I failed, because despite
>>> setting the single channel and performing a bunch of HW scan (one for
>>> each ch), it happened that my HW did several full scans disregarding
>>> the channel setting.
>>
>> Well, if it doesn't work we can go back to the mac80211 solution I
>> suppose. Although the better solution even then might be to at least
>> detect in the driver that we're in the scan, and then attempt to parse
>> the DS information in the driver, so that it works regardless of whether
>> mac80211 has both those long paths or not. That patch would also be
>> simpler.
>>
>> johannes
>>
