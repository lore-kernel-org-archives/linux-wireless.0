Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:2697 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZI0UIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 16:08:00 -0400
Received: by ey-out-2122.google.com with SMTP id d26so873322eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2009 13:08:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ABFB98F.3060307@ufra.edu.br>
References: <4A9BFCCB.6040808@ufra.edu.br>
	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>
	 <4A9C0ADC.6050607@ufra.edu.br>
	 <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	 <4A9D7DC0.6050701@ufra.edu.br>
	 <3ace41890909221750h7c4beee8ob0ec31fb0657b3fd@mail.gmail.com>
	 <4ABFB98F.3060307@ufra.edu.br>
Date: Sun, 27 Sep 2009 21:08:02 +0100
Message-ID: <3ace41890909271308r2390421bn3879e7d62f008631@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2009 at 8:14 PM, Leonardo H. Souza Hamada
<leonardo.hamada@ufra.edu.br> wrote:
> Hin-Tak Leung wrote:
>>
>> I found that one of the patches -
>> 0004-forward-port-of-an-old-patch-from-the-internet.patch - is buggy,
>> and breaks USB 2.0 host... wanna undo that and have another go?
>> (that's also the one that adds the 'read failed after 5 attempts",
>> etc).
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> OK,
>
> Undid the 0004-forward-port-of-an-old-patch-from-the-internet.patch patch.
>
> The vendor driver seems to work fine now.
>
> dmesg:
> usb 1-2: new high speed USB device using ehci_hcd and address 3
> usb 1-2: New USB device found, idVendor=0411, idProduct=00da
> usb 1-2: New USB device strings: Mfr=16, Product=32, SerialNumber=0
> usb 1-2: Product: USB2.0 WLAN
> usb 1-2: Manufacturer: Buffalo
> usb 1-2: configuration #1 chosen from 1 choice
>
>  _____     ____    _    ____
> |__  /   _|  _ \  / \  / ___|
>  / / | | | | | |/ _ \ \___ \
>  / /| |_| | |_| / ___ \ ___) |
> /____\__, |____/_/   \_\____/
>     |___/
> ZD1211B - version 3.0.0.56
> vendor_id = 0411
> product_id = 00da
> USB 2.0 Host
> Release Ver = 4810
> EEPORM Ver = 4810
> Finsih download Firmware. Ready to reboot
> PA type: 0
> PHYNEWLayout = 1
> Airoha AL2230S_RF
> OverWrite CR47 = 0x19
> zd1205_config: EEP(HWFeature)=0x110
> AllowedChannel = 00013fff
> Region:73
> usbcore: registered new interface driver zd1211b
> zd1205_notify_disjoin_event
> ADDRCONF(NETDEV_UP): ath0: link is not ready
>
>
>
> lsusb:
> Bus 001 Device 003: ID 0411:00da MelCo., Inc. WLI-U2-KG54L
>
>
> lsmod:
> Module                  Size  Used by
> zd1211b               500924  0
>
>
>
> Thanks,
>
> Leonardo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks for letting me know - I had a better thought at that (or
rather, a big bundle where it came from) - It probably worked around
some bug in 2.22 which has since been fixed. I haven't heard from the
person where this came from why he did what he did, but just as well,
I guess. It served a purpose during the 2.22 period.
