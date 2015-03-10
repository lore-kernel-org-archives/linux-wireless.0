Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:52494 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbbCJXQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 19:16:18 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id 577AE28030B
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 00:15:52 +0100 (CET)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com [209.85.192.41])
	by arrakis.dune.hu (Postfix) with ESMTPSA id 6569828C04F
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2015 00:15:47 +0100 (CET)
Received: by qgdz107 with SMTP id z107so6082398qgd.3
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 16:16:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54FF7970.10402@erley.org>
References: <8BC2636B-D1F0-431C-90F4-1290A4158DC2@gmail.com> <54FF7970.10402@erley.org>
From: Jonas Gorski <jogo@openwrt.org>
Date: Wed, 11 Mar 2015 00:15:45 +0100
Message-ID: <CAOiHx=kRLW6Bvrnht=pn7=9zT6Vg2QAcE2JMXrZstOixsL0CmA@mail.gmail.com> (sfid-20150311_001621_444509_5F0A2049)
Subject: Re: Developing a new Driver
To: Pat Erley <pat-lkml@erley.org>
Cc: Huseyin <revanthedarth@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2015 at 12:08 AM, Pat Erley <pat-lkml@erley.org> wrote:
> On 03/10/2015 04:42 PM, Huseyin wrote:
>>
>> Hello everyone,
>>
>> I want to develop a driver for my usb wireless adapter. The device name is
>> AirTies Air 2410, codes are 0x1eda 0x2410. The company’s other usb wireless
>> adapters (for example, AirTies Air 2310, 0x1eda 0x2310) were using ralink
>> rt2800 driver, but this one doesn’t work with it.
>>
>> I opened up the device’s case, I could only find out that the board was
>> plotech e169497, 6 94v-0. I googled but these seem to be too vague and I
>> cannot go any further with it. I couldn’t find any other text on the board.
>>
>> I also contacted the company (AirTies) but they didn’t bother to reply.
>> They provide drivers for windows only.
>>
>> What should be the next step? Reverse-engineering the windows driver (I
>> have no expertise on the subject, and little expertise on windows
>> altogether) or trying to write a new driver using ralink or any other
>> existing driver code? Is it a good idea to guess that the driver I’m going
>> to develop will be similar to rt2800? This way I can make rt2800 recognize
>> my device and try to find out what goes wrong (which, seems to me, would be
>> meaningless if device is using a chipset not related to ralink), and change
>> those parts.
>>
>> I asked a little about the subject in the #kernelnewbies channel, people
>> redirected me to this mail list.
>>
>> When I make rt2800 driver recognize my device, this is what I get:
>>
>> ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x07
>> failed for offset 0x1000 with error -110
>> ieee80211 phy0: rt2800_probe_rt: Error - Invalid RT chipset 0xffff, rev
>> 8800 detected
>> ieee80211 phy0: rt2x00lib_probe_dev: Error - Failed to allocate device
>> usbcore: registered new interface driver rt2800usb
>>
>
> Based on their driver, it's a broadcom chip in there:
>
>
>   inflating:
> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmh43xx.cat
>   inflating:
> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmihvsrv.dll
>   inflating:
> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmihvui.dll
>   inflating:
> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmwlcoi.dll
>   inflating:
> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmwlhigh6.inf
>   inflating:
> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/bcmwlhigh6.sys
>   inflating:
> AirTiesWirelessUSBAdapterSetup_1.0.1.0/Drivers/Air2410-Air2411/VistaDriver/WdfCoInstaller01005.dll
>
> I don't know what the status of broadcom and usb drivers is though.

According to wikidevi[1], it uses BCM4323, which is SSB based, quite
old, and will never be supported by brcmfmac, and probably never by
b43 (one would need to reverse engineer the usb protocol used by
broadcom).


Jonas

[1] https://wikidevi.com/wiki/AirTies_Air_2410
