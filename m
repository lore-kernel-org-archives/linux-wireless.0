Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f200.google.com ([209.85.210.200]:59541 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0BSSKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:10:18 -0500
Received: by yxe38 with SMTP id 38so304108yxe.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 10:10:17 -0800 (PST)
Message-ID: <4B7ED405.4090501@lwfinger.net>
Date: Fri, 19 Feb 2010 12:10:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	=?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs definitions
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>	 <1266591292.15178.1.camel@jlt3.sipsolutions.net>	 <4B7EB31D.2000603@lwfinger.net>	 <1266596602.15178.2.camel@jlt3.sipsolutions.net>	 <4B7EBF0A.1060907@lwfinger.net> <1266598974.3754.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266598974.3754.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/19/2010 11:02 AM, Johannes Berg wrote:
> On Fri, 2010-02-19 at 10:40 -0600, Larry Finger wrote:
> 
>> Rafał is taking exams now, but said in one of our last communications
>> that he
>> was finishing up some radio code. After that, he expected some signs
>> of life.
> 
> Neat.
> 
>> What PHY revision do you have? Between 2 and 3 there were a lot of
>> changes
>> including a new radio version. Rafał has a 2, thus he has been
>> concentrating on
>> that one.
>>
>> Do you have any log messages on the SSB adjustments?
> 
> [    5.861375] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x17, vendor 0x4243)
> [    5.861390] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x10, vendor 0x4243)
> [    5.861402] ssb: Core 2 found: PCI-E (cc 0x820, rev 0x0B, vendor 0x4243)
> [    5.861414] ssb: Core 3 found: PCI (cc 0x804, rev 0x0E, vendor 0x4243)
> [    5.861427] ssb: Core 4 found: USB 2.0 Device (cc 0x81A, rev 0x05, vendor 0x4243)
> [    5.861439] ssb: Core 5 found: UNKNOWN (cc 0x8FF, rev 0x00, vendor 0x4243)
> [    5.861452] ssb: Core 6 found: Internal Memory (cc 0x80E, rev 0x03, vendor 0x4243)
> [    5.900494] ssb: Found rev 2 PMU (capabilities 0x04583002)
> [    5.900500] ssb: ERROR: PLL init unknown for device 4322
> [    5.900844] ssb: ERROR: PMU resource config unknown for device 4322
> [    5.909764] ssb: SPROM revision 8 detected.
> ...
> [    6.378717] b43-phy0: Broadcom 4322 WLAN found (core revision 16)
> [    6.482611] b43-phy0 debug: Found PHY: Analog 8, Type 4, Revision 4
> [    6.482638] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2056, Revision 3

I just submitted a patch for the errors above that I've had here for a long time.

A Rev 8 SPROM has all the entities found in Rev 4 plus some additions. If R4 can
support an mimo N PHY, R8 certainly can.

Larry

