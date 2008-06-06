Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yorgi.telenet-ops.be ([195.130.133.69]:35912 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbYFFVHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 17:07:01 -0400
Received: from zoltar.telenet-ops.be (zoltar.telenet-ops.be [195.130.132.57])
	by yorgi.telenet-ops.be (Postfix) with ESMTP id C747A588AF8
	for <linux-wireless@vger.kernel.org>; Fri,  6 Jun 2008 23:06:59 +0200 (CEST)
Message-ID: <4849A6D4.2090904@yahoo.co.uk> (sfid-20080606_230707_420371_3F6C1F7F)
Date: Fri, 06 Jun 2008 23:06:28 +0200
From: Ivo Couckuyt <iv0co@yahoo.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb	adapter
References: <47AF79DA.10204@yahoo.co.uk>	 (sfid-20080220_180121_070641_4FFC2208) <1203532811.17534.79.camel@johannes.berg>
In-Reply-To: <1203532811.17534.79.camel@johannes.berg>
Content-Type: multipart/mixed;
 boundary="------------050000060604000503020009"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050000060604000503020009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry for the late reply, i just thought i install kernel 2.6.25 r4 and 
try again.

It is somewhat better and worse, when modprobing p54usb i got a small 
hang/hickup accompanied with the following error in dmesg
ehci_hcd 0000:00:02.2: HC died; cleaning up

afterwards the kernel fails (refuses ?) to detect the device again. so I 
no longer get a kernel oops but even modprobbing doesnt work anymore.
see attachment for full dmesg. any ideas, testing i an do now ?

kind regards,
Ivo Couckuyt

Johannes Berg wrote:
>> I followed the guidelines for a bug report.
>> If there is anything else needed, I'll be happy to do all the testing 
>> needed.
>>
>> [1.] One line summary of the problem:
>> p54usb driver crashes on trying to associate with an ap with the 
>> CPWUA054 usb adapter
>>
>> [2.] Full description of the problem/report:
>> What works:
>> modprobe p54usb
>> dmesg (displays my adapter correctly)
>> ifconfig up wlan0
>> dmesg (using the right firmware 2.5.6.0)
>>
>> but trying to associate to my accesspoint (using wpa_supplicant) causes 
>> a hard-lock up (keyboard leds blinking).
>> Before locking up it spams loads of 'RX: unknown frame received phy1' 
>> messages on kmsg/dmesg.
>>     
>
> Please switch to a VT (e.g. VT 1, usually by pressing ctrl-alt-f1) and
> associate by hand (e.g. iwconfig wlan0 essid "your ssid") and take a
> picture of the oops that comes out.
>
> johannes
>   

--------------050000060604000503020009
Content-Type: text/plain;
 name="2.6.25_irq"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.25_irq"

usb 1-1: new high speed USB device using ehci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
p54: LM86 firmware
p54: FW rev 2.5.6.0 - Softmac protocol 3.0
ehci_hcd 0000:00:02.2: HC died; cleaning up
irq 11: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.25-gentoo-r4-BARTON #1
 [<c0149ee7>] __report_bad_irq+0x27/0x90
 [<c014a218>] note_interrupt+0x2c8/0x300
 [<c01493e1>] ? handle_IRQ_event+0x31/0x70
 [<c014aced>] handle_level_irq+0xdd/0x110
 [<c0105e26>] do_IRQ+0x46/0x80
 [<c010415f>] common_interrupt+0x23/0x28
 [<c01493c7>] ? handle_IRQ_event+0x17/0x70
 [<c014ac8a>] handle_level_irq+0x7a/0x110
 [<c0105e26>] do_IRQ+0x46/0x80
 [<c010415f>] common_interrupt+0x23/0x28
 [<c0120e92>] ? __do_softirq+0x42/0xb0
 [<c0120f35>] do_softirq+0x35/0x40
 [<c01210f4>] irq_exit+0x44/0x50
 [<c0105e2b>] do_IRQ+0x4b/0x80
 [<c010415f>] common_interrupt+0x23/0x28
 [<c0102b9d>] ? default_idle+0x4d/0x80
 [<c0102b50>] ? default_idle+0x0/0x80
 [<c0102af3>] cpu_idle+0x33/0x90
 [<c03caadc>] rest_init+0x5c/0x60
 =======================
handlers:
[<c02fef00>] (usb_hcd_irq+0x0/0x60)
[<c02fef00>] (usb_hcd_irq+0x0/0x60)
Disabling IRQ #11
usb 1-1: USB disconnect, address 4
usb 1-5: USB disconnect, address 3
usbcore: registered new interface driver prism54usb

--------------050000060604000503020009--
