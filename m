Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:54611 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3DXRde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 13:33:34 -0400
Received: by mail-lb0-f181.google.com with SMTP id r11so1975799lbv.26
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 10:33:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALvqYaRrjMtPE72PGR-Zzuj11CL=E6+ruC+E1wGPO3m5wgdOhg@mail.gmail.com>
References: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com>
	<CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com>
	<5177F100.1070803@lwfinger.net>
	<CALvqYaQt+nL-PxSeEUNpsG9SWV+--S64ksr1UR+8TPg5dVPKXA@mail.gmail.com>
	<51780C92.4000208@lwfinger.net>
	<CALvqYaRrjMtPE72PGR-Zzuj11CL=E6+ruC+E1wGPO3m5wgdOhg@mail.gmail.com>
Date: Wed, 24 Apr 2013 19:27:38 +0200
Message-ID: <CALvqYaT==e4U43dxtyX55A9CNgWh9apHMrj89=bBybutyJOoiw@mail.gmail.com> (sfid-20130424_193338_016976_9ABCCD0A)
Subject: Re: Fwd: Realtek 8192CU not working
From: Michael Stahn <michael.stahn.42@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

okay now it gets a little awkward: un/reloading the driver seems to
fix the authentication-problem (ip gets assigned), but no ping
succeeds..
http://bpaste.net/show/93913/

2013/4/24 Michael Stahn <michael.stahn.42@gmail.com>:
> I'm using a i686 Architecture on AMD E2-1800 APU with Radeon(tm) HD
> Graphics AuthenticAMD GNU/Linux with linux 3.7.10. CONFIG_USB_DEBUG
> was allready set. I've used an USB 3.0 port previously and now
> rechecked everything with a USB2.0 port. The result is nearly the
> same: first connection succeeds (ping response), doing a manual
> reconnect to the AP leads to the same error. I've done several
> ifconfig down/ups at the end with no change.
> dmesg gives: http://bpaste.net/show/93912/
>
> 2013/4/24 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 04/24/2013 11:20 AM, Michael Stahn wrote:
>>>
>>> I've just recompiled the kernel and executed the following procedure:
>>> modprobe rtl8192cu -> plugin in Wlan-Stick -> connect wlan via
>>> Networkmanager (no connection was established, credentials are
>>> correct) -> unplug Stick. Attachment contains the dmes-output.
>>
>>
>> Please do not drop the Cc to the Linux wireless mailing list unless you are
>> requested to send something of a sensitive nature. Always use "Reply to
>> all".
>>
>> [  448.211707] rtl8192cu: MAC auto ON okay!
>> [  448.248820] rtl8192cu: Tx queue select: 0x05
>> [  448.615206] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> [  464.990166] ehci_hcd 0000:00:16.2: detected XactErr len 0/15360 retry 1
>> [  464.990540] ehci_hcd 0000:00:16.2: detected XactErr len 0/15360 retry 2
>> [  464.990613] hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0004
>> [  464.990642] ehci_hcd 0000:00:16.2: GetStatus port:2 status 001002 0  ACK
>> POWER sig=se0 CSC
>> [  464.990661] hub 3-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
>> [  464.990672] usb 3-2: USB disconnect, device number 3
>>
>> That error is something in the USB hub driver. What is your architecture?
>>
>> To get a little more detail, please rebuild your kernel with
>> CONFIG_USB_DEBUG set and post the full log on some paste site. I will likely
>> need to have the help of the USB expert on this matter, but we need more
>> details first.
>>
>> Larry
>>
