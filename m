Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1982 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1BRCn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 21:43:26 -0500
Message-ID: <4D5DDCBC.2050501@broadcom.com>
Date: Thu, 17 Feb 2011 18:43:08 -0800
From: "Henry Ptasinski" <henryp@broadcom.com>
MIME-Version: 1.0
To: "George Kashperko" <george@znau.edu.ua>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"=?ISO-8859-2?Q?Rafa=B3?= =?ISO-8859-2?Q?_Mi=B3ecki?="
	<zajec5@gmail.com>,
	"=?ISO-8859-2?Q?Michael_?= =?ISO-8859-2?Q?B=FCsch?=" <mb@bu3sch.de>,
	driverdevel <devel@driverdev.osuosl.org>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>
Subject: Re: [RFC] AI support
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
In-Reply-To: <1297958316.5623.27.camel@dev.znau.edu.ua>
Content-Type: text/plain;
 charset=iso-8859-2;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/17/2011 07:58 AM, George Kashperko wrote:
> Here is dmesg for AI on embeddable (BCM4716):
> root@OpenWrt:/# dmesg | grep -E "ssb|b43|[Bb]roadcom"
> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x1F, vendor 0x04BF)
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x11, vendor 0x04BF)
> ssb: Core 2 found: Gigabit MAC (cc 0x82D, rev 0x00, vendor 0x04BF)
> ssb: Core 3 found: MIPS 74K (cc 0x82C, rev 0x01, vendor 0x04A7)
> ssb: Core 4 found: USB 2.0 Host (cc 0x819, rev 0x04, vendor 0x04BF)
> ssb: Core 5 found: PCI-E (cc 0x820, rev 0x0E, vendor 0x04BF)
> ssb: Core 6 found: DDR1/2 memory controller (cc 0x82E, rev 0x01, vendor 0x04BF)
> ssb: Core 7 found: Internal Memory (cc 0x80E, rev 0x07, vendor 0x04BF)
> ssb: Core 8 found: I2S (cc 0x834, rev 0x00, vendor 0x04BF)
> ssb: Found END of erom after 9 cores
> ssb: chipcommon status is 0x800
> ssb: Found rev 5 PMU (capabilities 0x11242C05)
> ssb: Initializing MIPS core...
> ssb: ssb_pmu5_clock: p1=1, p2=1, ndiv=48(0x30), m3=8, fc=960, clock=120
> ssb: set_irq: core 0x0812, irq 3 =>  3
> ssb: set_irq: core 0x082d, irq 4 =>  4
> ssb: set_irq: core 0x0819, irq 5 =>  5
> ssb: after irq reconfiguration
> ssb: core 0x0800, irq : 2(S)* 3  4  5  6  D  I
> ssb: core 0x0812, irq : 2(S)  3* 4  5  6  D  I
> ssb: core 0x082d, irq : 2(S)  3  4* 5  6  D  I
> ssb: core 0x082c, irq : 2(S)  3  4  5  6  D  I*
> ssb: core 0x0819, irq : 2(S)  3  4  5* 6  D  I
> ssb: core 0x0820, irq : 2(S)  3  4  5  6* D  I
> ssb: core 0x082e, irq : 2(S)* 3  4  5  6  D  I
> ssb: core 0x080e, irq : 2(S)  3  4  5  6  D  I*
> ssb: core 0x0834, irq : 2(S)* 3  4  5  6  D  I
> ssb: Sonics Silicon Backplane (AI type) found at address 0x18000000

This just reinforces what Michael said about name confusion.

Michael's proposal of separating SSB and AXI, and decoupling the device 
drivers from the bus routines, is going to be much more maintainable in 
the long run.  AXI is going to be far more widespread than SSB ever was, 
and it would be really unfortunate if we carry the SSB baggage forward.

I've been poking around at disentangling the sb and ai routines in 
drivers/staging/brcm80211/utils/{aiutils,sbutils,siutils}.c.  I don't 
have anything to put out for comments yet, but it's enough to convince 
me that it's the right direction.

- Henry

