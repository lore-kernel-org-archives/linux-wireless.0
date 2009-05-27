Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:40271 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbZE0SUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 14:20:40 -0400
Received: by gxk10 with SMTP id 10so8108593gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 11:20:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2E65E0B1-CD1E-45CB-A64D-585DFEFA1ECF@handheldmedia.us>
References: <394878.84106.qm@web36808.mail.mud.yahoo.com>
	 <4A1BA9F1.5050605@compulab.co.il>
	 <2E65E0B1-CD1E-45CB-A64D-585DFEFA1ECF@handheldmedia.us>
Date: Wed, 27 May 2009 11:20:41 -0700
Message-ID: <45e8e6c40905271120h54b0e5e0rbe3491043c6b935e@mail.gmail.com>
Subject: Re: Suggestions on low-cost Linux/ARM-friendly WiFi module or
	chipset...
From: Andrey Yurovsky <andrey@cozybit.com>
To: Charles Woloszynski <charles.woloszynski@handheldmedia.us>
Cc: Mike Rapoport <mike@compulab.co.il>,
	Jean-Pierre Poulin <jeanpierrepoulin@yahoo.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 4:58 AM, Charles Woloszynski
<charles.woloszynski@handheldmedia.us> wrote:
> Can I follow-up on this question?  I am looking for something similar, but I
> have one additional requirement.  I am looking for something with WDS
> support and 802.11s support (MeshPoint) along with all of the listed
> requirements below...

For USB, the rt2x00 should be working.  There may still be an issue
where a scan has to be issued in order to get the device to beacon.
Also the Marvell 88w8383, if you can get one, can support mac80211 and
Mesh Point operation with the libertas_tf driver and firmware:
http://wireless.kernel.org/en/users/Drivers/libertastf

> I'd also prefer a solution with two antennas for diversity.  I believe I
> cannot use a USB device to host a MP, but if I can, that would be the best
> answer, since I could simply integrate a USB device.

Aside from those two USB devices, I'm not sure.  Also I don't know of
any that support diversity antennas.

> On May 26, 2009, at 4:36 AM, Mike Rapoport wrote:
>
>>
>>
>> Jean-Pierre Poulin wrote:
>>>
>>> Hello,
>>>
>>> May I obtain your recommendation on a Linux + ARM friendly WiFi module or
>>> chipset?
>>
>> There's wi2wi SIP module with Marvell 8686. It is supported by libertas
>> driver.
>>
>>> The solution we’re looking for must have the following features:
>>> - WiFi features: 802.11b + 802.11g with WPA & WEP encryption.
>>> - Driver: Binary driver built for Linux+ARM9 *or* Driver source buildable
>>> for Linux 2.6.28.2
>>> - Electronic Interface: SDIO (strongly) preferred, then parallel bus,
>>> then SPI, and least preferred: USB
>>> - Physical interface: SMD-mounting (strongly) preferred, then SD-card,
>>> then USB stick
>>> - Size: Smaller the better (especially on ‘thickness’), but not critical.
>>> - Power efficiency: Irrelevant / Not critical.
>>> - Cost: Extremely critical!!
>>> - Range: The greater the better, but low-cost is much more important.
>>> - Antenna considerations: Small built-in chip antenna preferred.
>>>  External whip antenna a minus.
>>>
>>> Working backwards on this from the currently available drivers (we’re
>>> building our Linux image ontop OpenWRT for the $2.80 NXP LPC313x), the
>>> following drivers are ‘easily accessible’ in OpenWRT… but we have yet to
>>> find the low-cost manufacturers that can provide the physical WiFi solution
>>> itself…
>>>
>>>
>>> kmod-libertas............................ Marvell 88W8015 Wireless Driver
>>> kmod-mac80211..................... Linux 802.11 Wireless Networking Stack
>>> kmod-mac80211-hwsim........................ mac80211 HW simulation device
>>> kmod-p54-common................................. Prism54 Drivers (COMMON)
>>> kmod-p54-usb....................................... Prism54 Drivers (USB)
>>> kmod-rt2500-usb............. Ralink Drivers for RT2x00 cards (RT2500 USB)
>>> kmod-rt2800-usb............. Ralink Drivers for RT2x00 cards (RT2870 USB)
>>> kmod-rt2x00-lib.................... Ralink Drivers for RT2x00 cards (LIB)
>>> kmod-rt2x00-usb.................... Ralink Drivers for RT2x00 cards (USB)
>>> kmod-rt73-usb................. Ralink Drivers for RT2x00 cards (RT73 USB)
>>> kmod-zd1211rw....................................... Zydas ZD1211 support
>>>
>>> In addition, searching through the list of drivers at Linux Wireless, we
>>> were impressed by the comprehensive selection but – as device prices are not
>>> listed – it is very difficult to ascertain which inexpensive WiFi solution
>>> can run on our board.
>>>
>>> Finally, as the cost of the total WiFi solution is so important, our
>>> ‘upper range’ for cost is about $11 per interface (1K qty), as our ‘plan B’
>>> is simply to insert one of the many $13 USB-WiFi interface (such as those
>>> found on eBay) inside the product enclosure.  Some questions:
>>>
>>> Q1: Given our above-stated needs… which do you recommend: the ‘module
>>> approach’, the ‘chipset approach’ or the ‘insert consumer product’ approach?
>>>
>>> Q2: What is the ‘most famous’ / ‘most supported’ Linux/ARM-friendly
>>> low-cost WiFi solution currently available?
>>>
>>> Q3: Can you recommend some low-cost (Taiwanese / Chinese) WiFi
>>> manufacturers that supplies low-cost Linux-compatible solutions?
>>>
>>> Q4: For reference, what do you think is the cost of the ‘absolute lowest
>>> cost’ WiFi solution currently available?
>>>
>>> Many thanks for any hint / suggestion you can provide!
>>>
>>>  Jean-Pierre
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> Sincerely yours,
>> Mike.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
