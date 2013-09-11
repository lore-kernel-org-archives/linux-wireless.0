Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:59233 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754312Ab3IKSYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 14:24:53 -0400
Received: by mail-oa0-f47.google.com with SMTP id g12so9715230oah.6
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 11:24:53 -0700 (PDT)
Message-ID: <5230B573.9030800@lwfinger.net> (sfid-20130911_202457_947032_B37ACB50)
Date: Wed, 11 Sep 2013 13:24:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Dan Williams <dcbw@redhat.com>,
	Vincent Thiele <vincentthiele@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: No connection with TP-Link TL-WN823N (rtl8192cu)
References: <CAEZsi7Hde5NyTRgm7Lf_4LvHMAEJouzaqMNUwxr-iSipuEcsyQ@mail.gmail.com>  <522E4315.4040806@lwfinger.net> <1378764913.31180.9.camel@dcbw.foobar.com>  <CAEZsi7FY8HdBcb0p1svijAdFjB0MbrYv_Zft0B_+RQTpGWCnhQ@mail.gmail.com> <1378916091.1693.21.camel@dcbw.foobar.com> <52309B75.3010408@lwfinger.net> <5230A440.5050709@ilande.co.uk>
In-Reply-To: <5230A440.5050709@ilande.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2013 12:11 PM, Mark Cave-Ayland wrote:
> On 11/09/13 17:33, Larry Finger wrote:
>
>>> So the AP is disconnecting the device a couple seconds with reason 4,
>>> which is "Disassociated due to inactivity". My thought is that this
>>> points to a driver bug (Larry?).
>>
>> Possibly, but for reference, my Edimax EW-7811Un has been running for 37
>> hours. During that time, I have had no deauthentications and only 2
>> instances of the "AP lost" reconnections. The latter is what I am
>> currently trying to fix, but at that error rate, it is difficult. I am
>> running the latest 3.11 kernel from wireless testing.
>>
>> The only thing I am doing that is unusual is that I am pinging my router
>> at a 5 second interval using the command
>>
>> ping -i5 192.168.1.1
>>
>> It is possible that I am preventing a power save operation, which is
>> making a difference.
>
> Hi Larry,
>
> For comparison, what does your device report when plugged in? My device reports
> this:
>
> Sep 10 00:28:41 kentang kernel: [90532.399226] usb 4-1.2: new high-speed USB
> device number 26 using ehci-pci
> Sep 10 00:28:41 kentang kernel: [90532.492624] usb 4-1.2: New USB device found,
> idVendor=0bda, idProduct=8176
> Sep 10 00:28:41 kentang kernel: [90532.492627] usb 4-1.2: New USB device
> strings: Mfr=1, Product=2, SerialNumber=3
> Sep 10 00:28:41 kentang kernel: [90532.492629] usb 4-1.2: Manufacturer: Realtek
> Sep 10 00:28:41 kentang kernel: [90532.492630] usb 4-1.2: SerialNumber:
> 00e04c000001
> Sep 10 00:28:41 kentang kernel: [90532.502454] rtl8192cu: Chip version 0x10
> Sep 10 00:28:42 kentang kernel: [90532.581772] rtl8192cu: MAC address:
> 00:0b:81:89:81:b8
> Sep 10 00:28:42 kentang kernel: [90532.581776] rtl8192cu: Board Type 0
>
> Also what type of USB port are you using? I'm plugged direct (no hub) into a
> ehci-pci port on a laptop if that makes a difference to power?

My device has USB ID of 7392:7811. The logged data are as follows:

[    2.844078] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    3.120082] usb 1-4: new high-speed USB device number 3 using ehci-pci
[   22.448552] rtl8192cu: Chip version 0x10
[   22.649915] rtl8192cu: MAC address: 00:1f:1f:c8:8e:cb
[   22.649926] rtl8192cu: Board Type 0

I am plugged into an ehci port on my laptop; however, the power-saving feature I 
discussed refers to the ability of wireless devices to shut down their power 
during a period when no packets are expected. The station (STA) informs the 
access point (AP) that it is going into that mode, and the AP will not send any 
data until the STA is once again ready. Many drivers have the ability to disable 
this feature on module loading, but not rtl8192cu (yet). I am looking into 
adding this code.

Larry

