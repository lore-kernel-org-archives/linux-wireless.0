Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:40808 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760133AbXGaOfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 10:35:10 -0400
Message-ID: <46AF4889.4070902@warmcat.com>
Date: Tue, 31 Jul 2007 15:34:49 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
References: <20070731115446.5717.37617.stgit@localhost> <200707311458.40936.IvDoorn@gmail.com> <46AF3AAE.4010908@warmcat.com> <200707311611.26683.IvDoorn@gmail.com>
In-Reply-To: <200707311611.26683.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> I think I have an idea why mac80211 always reports 1 MBs,
> rt2x00 checks if PREAMBLE was enabled or not. If that is the case it sets
> the rate value to rate->val2
> Mac80211 in turn only compares the value against rate->val which
> means that it won't find the rate and assume the lowest possible rate.
> I'll fix this by always setting the rate->val value instead (It isn't
really
> important for mac80211 to know if the preamble bit was set anyway).

Somehow the rates seem to be correct now after your change to the DROP
bits...

> #define TXRX_CSR0_DROP_CRC				FIELD32(0x00020000)
> #define TXRX_CSR0_DROP_PHYSICAL			FIELD32(0x00040000)
> #define TXRX_CSR0_DROP_CONTROL			FIELD32(0x00080000)
> #define TXRX_CSR0_DROP_NOT_TO_ME		FIELD32(0x00100000)
> #define TXRX_CSR0_DROP_TO_DS				FIELD32(0x00200000)
> #define TXRX_CSR0_DROP_VERSION_ERROR	FIELD32(0x00400000)
> #define TXRX_CSR0_DROP_MULTICAST			FIELD32(0x00800000)
> #define TXRX_CSR0_DROP_BORADCAST		FIELD32(0x01000000)
> #define TXRX_CSR0_DROP_ACK_CTS			FIELD32(0x02000000)
>
> Which means it will only pass multicast, broadcast and ACK_CTS frames. :S
> Always dropping CRC errors is correct, since enabling that will
greatly upset
> any monitoring tool listening to the interface.

Well one day it will be nice if there is a stack-level way to turn it on
and off.  We can also pass in the radiotap part a flag to show if the
packet's CRC was valid or not.  The tools can then either turn on the
filtering before the packets come or filter on good packets only.

> To see if it helps try:
>
> echo 16 > csr_offset
> echo 0x0002b162 > csr_value
>
> This will disable all DROP bits (except for the CRC error) and thus should
> trigger more frames to be received by your interface. In the mean time
I'll search
> why those bits weren't cleared when enabling the interface in monitor
mode.

Yes, that seems to have done it, thanks

15:20:34.157203 54.0 Mb/s 2437 MHz (0x0480) 214dB signal Data IV:1b30
Pad 20 KeyID 0
15:20:34.157206 24.0 Mb/s 2437 MHz (0x0480) 232dB signal Acknowledgment
RA:00:11:50:ad:ce:38 (oui Unknown)
15:20:34.157942 54.0 Mb/s 2437 MHz (0x0480) 232dB signal Data IV:16aa
Pad 20 KeyID 0
15:20:34.157945 36.0 Mb/s 2437 MHz (0x0480) 214dB signal Acknowledgment
RA:00:19:d2:59:8f:d5 (oui Unknown)
15:20:34.161265 54.0 Mb/s 2437 MHz (0x0480) 214dB signal Data IV:1b31
Pad 20 KeyID 0
15:20:34.161268 24.0 Mb/s 2437 MHz (0x0480) 230dB signal Acknowledgment
RA:00:11:50:ad:ce:38 (oui Unknown)
15:20:34.165809 1.0 Mb/s 2437 MHz (0x0480) 218dB signal Beacon (froh)
[1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
15:20:34.165812 54.0 Mb/s 2437 MHz (0x0480) 214dB signal Data IV:1b32
Pad 20 KeyID 0
15:20:34.165815 24.0 Mb/s 2437 MHz (0x0480) 232dB signal Acknowledgment
RA:00:11:50:ad:ce:38 (oui Unknown)
15:20:34.166498 54.0 Mb/s 2437 MHz (0x0480) 232dB signal Data IV:16ab
Pad 20 KeyID 0
15:20:34.166502 36.0 Mb/s 2437 MHz (0x0480) 214dB signal Acknowledgment
RA:00:19:d2:59:8f:d5 (oui Unknown)


> Which version are you using?
> wireless-dev <---
> rt2x00.git
> rt2x00 cvs

-Andy
