Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from correio.ufra.edu.br ([200.129.150.6]:53277 "EHLO
	correio.ufra.edu.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZI0TOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 15:14:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by correio.ufra.edu.br (Postfix) with ESMTP id BA9A57A4A0
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2009 16:17:23 -0300 (BRT)
Received: from correio.ufra.edu.br ([127.0.0.1])
	by localhost (correio.ufra.edu.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id 2l2o-ipXjtmm for <linux-wireless@vger.kernel.org>;
	Sun, 27 Sep 2009 16:17:14 -0300 (BRT)
Received: from [192.168.254.1] (unknown [189.82.241.201])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by correio.ufra.edu.br (Postfix) with ESMTP id 3D88F7A49F
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2009 16:17:14 -0300 (BRT)
Message-ID: <4ABFB98F.3060307@ufra.edu.br>
Date: Sun, 27 Sep 2009 16:14:23 -0300
From: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw on ppc (iBook G4)
References: <4A9BFCCB.6040808@ufra.edu.br>	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>	 <4A9C0ADC.6050607@ufra.edu.br>	 <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>	 <4A9D7DC0.6050701@ufra.edu.br> <3ace41890909221750h7c4beee8ob0ec31fb0657b3fd@mail.gmail.com>
In-Reply-To: <3ace41890909221750h7c4beee8ob0ec31fb0657b3fd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
>
> I found that one of the patches -
> 0004-forward-port-of-an-old-patch-from-the-internet.patch - is buggy,
> and breaks USB 2.0 host... wanna undo that and have another go?
> (that's also the one that adds the 'read failed after 5 attempts",
> etc).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

OK,

Undid the 0004-forward-port-of-an-old-patch-from-the-internet.patch patch.

The vendor driver seems to work fine now.

dmesg:
usb 1-2: new high speed USB device using ehci_hcd and address 3
usb 1-2: New USB device found, idVendor=0411, idProduct=00da
usb 1-2: New USB device strings: Mfr=16, Product=32, SerialNumber=0
usb 1-2: Product: USB2.0 WLAN
usb 1-2: Manufacturer: Buffalo
usb 1-2: configuration #1 chosen from 1 choice

 _____     ____    _    ____
|__  /   _|  _ \  / \  / ___|
  / / | | | | | |/ _ \ \___ \
 / /| |_| | |_| / ___ \ ___) |
/____\__, |____/_/   \_\____/
     |___/
ZD1211B - version 3.0.0.56
vendor_id = 0411
product_id = 00da
USB 2.0 Host
Release Ver = 4810
EEPORM Ver = 4810
Finsih download Firmware. Ready to reboot
PA type: 0
PHYNEWLayout = 1
Airoha AL2230S_RF
OverWrite CR47 = 0x19
zd1205_config: EEP(HWFeature)=0x110
AllowedChannel = 00013fff
Region:73
usbcore: registered new interface driver zd1211b
zd1205_notify_disjoin_event
ADDRCONF(NETDEV_UP): ath0: link is not ready



lsusb:
Bus 001 Device 003: ID 0411:00da MelCo., Inc. WLI-U2-KG54L


lsmod:
Module                  Size  Used by
zd1211b               500924  0



Thanks,

Leonardo
