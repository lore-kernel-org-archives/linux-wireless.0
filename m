Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44843 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZIWAuO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 20:50:14 -0400
Received: by fxm18 with SMTP id 18so227519fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2009 17:50:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A9D7DC0.6050701@ufra.edu.br>
References: <4A9BFCCB.6040808@ufra.edu.br>
	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>
	 <4A9C0ADC.6050607@ufra.edu.br>
	 <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	 <4A9D7DC0.6050701@ufra.edu.br>
Date: Wed, 23 Sep 2009 01:50:16 +0100
Message-ID: <3ace41890909221750h7c4beee8ob0ec31fb0657b3fd@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 1, 2009 at 9:02 PM, Leonardo H. Souza Hamada
<leonardo.hamada@ufra.edu.br> wrote:

> Hin-Tak Leung wrote:
>> I have a bunch of patches which bring the 2.22 vendor driver up to
>> 2.6.29 and 3.0 the vendor driver up to 2.6.30:
>> http://htl10.users.sourceforge.net/patchsets/
>> It doesn't fix the rw driver, but might be good enough for you?
>>
>
> I have downloaded the vendor driver and applied your patchset.
>
> Inserted the vendor  { USB_DEVICE(0x0411, 0x00DA) }, in
> ar2524drv/src/zdusb.c
>
> Recompiled as zd1211REV_B
>
> dmesg for vendor driver:
> udev: starting version 145
>
>  _____     ____    _    ____
> |__  /   _|  _ \  / \  / ___|
>  / / | | | | | |/ _ \ \___ \
>  / /| |_| | |_| / ___ \ ___) |
> /____\__, |____/_/   \_\____/
>     |___/
> zd1211 - version 3.0.0.56
> vendor_id = 0411
> product_id = 00da
> USB 2.0 Host
> Release Ver = 4810
> EEPORM Ver = 4330
> Finsih download Firmware. Ready to reboot
> Finsih download Firmware. Ready to reboot
> Finsih download Firmware. Ready to reboot
> ohci1394 0002:20:0e.0: enabling device (0000 -> 0002)
> zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
> zd1211_readl retry OK
> ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40]
> MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
> PA type: 2
> Airoha AL2230S_RF
> Overwrite CR157 = 0x0
> Overwrite CR47 = 0x10019
> zd1205_config: EEP(HWFeature)=0xF7D0
> AllowedChannel = 00013fff
> Region:0
> zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
> zd1211_readl retry OK
> usbcore: registered new interface driver zd1211
>
>
> I am able to do iwlist ath0 scanning, a list of acess point appears but
> sometimes this fails.
> iwlist ath0 scanning:
> ath0      Scan completed :
>          Cell 01 - Address: 00:21:91:0E:0B:F7
>                    ESSID:"adminWF10"
>                    Mode:Master
>                    Frequency=2.412 GHz (Channel 1)
>                    Quality=46/100  Signal level=-74 dBm  Noise
> level=-96 dBm
>                    Encryption key:off
>                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
>                              12 Mb/s; 24 Mb/s; 36 Mb/s; 9 Mb/s; 18 Mb/s
>                              48 Mb/s; 54 Mb/s
>                    Extra:bcn_int=100
>          Cell 02 - Address: 00:1D:0F:D1:4D:D2
>                    ESSID:"LGAA_P_CENTRAL_WF01"
>                    Mode:Master
>                    Frequency=2.437 GHz (Channel 6)
>                    Quality=43/100  Signal level=-76 dBm  Noise
> level=-96 dBm
>                    Encryption key:off
>                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
>                              12 Mb/s; 24 Mb/s; 36 Mb/s; 9 Mb/s; 18 Mb/s
>                              48 Mb/s; 54 Mb/s
>                    Extra:bcn_int=100
>          Cell 03 - Address: 00:1B:11:87:A7:0C
>                    ESSID:"ponto-acesso-mutsuo"
>                    Mode:Master
>                    Frequency=2.437 GHz (Channel 6)
>                    Quality=43/100  Signal level=-76 dBm  Noise
> level=-96 dBm
>                    Encryption key:off
>                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
>                              9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
>                              48 Mb/s; 54 Mb/s
>                    Extra:bcn_int=100
>
>
> Scan again, it fails and works seemingly in an unknown manner.
> iwlist ath0 scanning
> ath0      Failed to read scan data : Resource temporarily unavailable
>
>
> Some message in dmesg of relevance:
> ...
> zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
> zd1211_readl retry OK
> zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
> zd1211_readl retry OK
> zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
> zd1211_readl retry OK
> zd1211_USB_PACKAGE_READ_REGISTER: warning, restarting INT EP
> zd1211_readl retry OK
> ....(many times over)
>
> and
>
> 1211_readl failed for 5 attempts...Very Serious<3>1211_readl failed for
> 5 attempts...Very Serious<3>1211_readl failed for 5 attempts...Very
> Serious<3>1211_readl failed for 5 attempts...Very Serious<3>1211_readl
> failed for 5 attempts...Very Serious<3>1211_readl failed for 5
> attempts...Very Serious<3>1211_readl failed for 5 attempts...Very
> Serious<3>1211_readl failed for 5 attempts...Very Serious<3>1211_readl
> failed for 5 attempts...Very Serious<3>1211_readl failed for 5
> attempts...Very Serious<3>1211_readl failed for 5 attempts...Very
> Serious<3>1211_readl failed for 5 attempts...Very Serious<3>1211_readl
> failed for 5 attempts...Very Serious<3>1211_readl failed for 5
> attempts...Very Serious<3>1211_readl failed for 5 attempts...Very
> Serious<7>zd1205_notify_disjoin_event
>
> Giving up .... for now.

I found that one of the patches -
0004-forward-port-of-an-old-patch-from-the-internet.patch - is buggy,
and breaks USB 2.0 host... wanna undo that and have another go?
(that's also the one that adds the 'read failed after 5 attempts",
etc).
