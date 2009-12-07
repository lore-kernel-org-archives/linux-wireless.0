Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50359 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934852AbZLGJr5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 04:47:57 -0500
Message-ID: <4B1CCF51.2040304@openwrt.org>
Date: Mon, 07 Dec 2009 10:48:01 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: 8an@praha12.net
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
References: <200912061820.26320.8an@praha12.net> <200912062000.26851.8an@praha12.net> <4B1C041A.3090708@openwrt.org> <200912062123.13098.8an@praha12.net>
In-Reply-To: <200912062123.13098.8an@praha12.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lukáš Turek wrote:
> On 6.12.2009 20:20 Felix Fietkau wrote:
>> In 2.4 GHz, regular slot time is 20 usec, unless short slot is enabled.
>> 2.4 GHz with short slot and 5 GHz both use 9 usec.
> Yes, but where the short slot time gets enabled? According to the standard 
> (don't have the reference now) all stations in 802.11g network should switch 
> to 20 usec slot time when 802.11b-only station connects. But I can't find 
> this anywhere in the driver, the only write to AR5K_DCU_GBL_IFS_SLOT is in 
> initvals.c - it seems it's not implemented yet.
> 
> After some more digging I found that the function ath5k_hw_clocktoh is wrong, 
> there are more possible clock rates than 40 and 80, this is in FreeBSD 
> driver:
>                                      /* 11a Turbo  11b  11g  108g */
> static const uint8_t CLOCK_RATE[]  = { 40,  80,   22,  44,   88  };
> 
> Now the values in initvals.c finally make sense:
> 
> 	a/XR	aTurbo	b	g (DYN)	gTurbo
> hex	0x168	0x1e0	0x1b8	0x18c	0x1e0
> clocks	360	480	440	396	480
> usec	9	6	20	9	6
> 
> Unfortunately I still don't know how to calculate the ACK timeout for 
> different slot time than 9. The formula in athctrl is
>   2 * slot_time + 3
> and I don't know where the '3' comes from. Any ideas?
I went through 802.11-2007 again to figure out how this is supposed to
be calculated. The document states:

aSIFSTime is:	aRxRFDelay + aRxPLCPDelay + aMACProcessingDelay +
		aRxTxTurnaroundTime.
aSlotTime is:	aCCATime + aRxTxTurnaroundTime + aAirPropagationTime +
		aMACProcessingDelay.
ACKTimeout is:	aSIFSTime + aSlotTime + aPHY-RX-START-Delay

SIFS is usually 10 usec and aAirPropagationTime is the propagation for
the round trip, not just one way. It defaults to 1 usec.

Also, Coverage Class = aAirPropagationTime * 3 usec
So a more correct formula might be:
	int slot_time = slot_time_base + coverage_class * 3;
	int ack_timeout = slot_time + 10 + 3;

I'm still not sure about the offset of 3 for ack_timeout, but since it's
a small constant, it probably won't matter too much.

Of course, the distance settting code in iw probably also needs
changing, as it needs to accomodate for aAirPropagationTime being the
round trip time, not one-way.

- Felix
