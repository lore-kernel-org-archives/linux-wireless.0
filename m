Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59603 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZA2UPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 15:15:08 -0500
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: "johannes\@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] mac80211: use ps-poll when dynamic power save mode 	is disabled
References: <20090128170215.32025.32389.stgit@tikku>
	<20090128170303.32025.21799.stgit@tikku>
	<8e92b4100901282206r64a07a9dtcc44db645d301b28@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 29 Jan 2009 22:14:35 +0200
In-Reply-To: <8e92b4100901282206r64a07a9dtcc44db645d301b28@mail.gmail.com> (ext Vivek Natarajan's message of "Thu\, 29 Jan 2009 07\:06\:48 +0100")
Message-ID: <87d4e5oono.fsf@nokia.com> (sfid-20090129_211514_224463_C470225C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> On Wed, Jan 28, 2009 at 10:33 PM, Kalle Valo <kalle.valo@nokia.com>
> wrote:
>
>> +                                * Here is assumed that the driver
>> + will be * able to send ps-poll frame and receive a * response even
>> + though power save mode is * enabled, but some drivers might
>> + require * to disable power save here. This needs * to be
>> + investigated.
>
> ath9k too needs power save to be disabled to send or receive any
> frame. Same as broadcom. I hope it is the same for many others too.
> I'm curious about the design of stlc45xx/p54 since it is capable of
> sending/receiving even though power save is enabled. I wonder what
> blocks of the hw are off when ps is enabled since it is capable of
> doing the basic operation of Tx/Rx which is the only thing expected
> from a driver. I seriously doubt if NIC is saving any power at all or
> the hw design is very novel and interesting.

Trust me, stlc4560 is very capable of saving power. For example, I
have managed to get over 7 days of association time with nokia n810
and the proprietary umac solution (display off, no traffic, openwrt AP
at home, occasionally pinging from the network to check that the
device is still connected).

I'm not familiar with the internals of stlc4560, but I can tell you
what I know from while developing a driver for the chipset.

The firmware has a special command to enable power save (LM_OID_PSM).
When the driver sends the command followed by a null frame, the
firmware will go to a power save mode. In this power save mode the
firmware will wake up automatically for beacons (interval is
configurable) and listens for multicast frames after DTIM beacons. It
also seems to stay awake long enough to receive the data frame
following a transmitted ps-poll, but I'm not sure how that logic works
yet.

In addition to the power save command, the firmware interface has a
separate interrupt for waking up firmware (SPI_TARGET_INT_WAKEUP) and
allowing it to sleep again (SPI_TARGET_INT_SLEEP). Whenever driver
wants to upload a frame for transmission, retrieve a received frame
from the buffer or send any command, it must first wakeup the firmware.
And after the driver knows that there isn't anything to do, it must
allow the firmware to sleep again.

When the firmware is sleeping and radio is turned off, the power
consumption is next to minimal. I don't know the exact figures,
though.

My guess is that the firmware awake command is independent from the
radio. For example, if the driver has enabled power save command and
later issued a firmware wakeup command but not followed with a sleep
command, the radio will be turned off between the beacons while the
firmware is still awake. But this is just a guess, I haven't tested
this.

This type of distinction between firmware wakeup and power save isn't
special. I have seen other hardware designs having similar methods.

After reading comments from you and Johannes I'm getting the feeling
that atheros and broadcom have somehow combined the power save and
firmware wakup commands into one. So maybe we should separate this is
in the mac80211 as well? I don't know, I need to think more about
this.

It's getting late for me and I'm sure I missed something, but
hopefully you now got better understanding. And please do ask if
there's anything unclear.

-- 
Kalle Valo
