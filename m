Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:49124 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab3DXQrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 12:47:18 -0400
Received: by mail-ia0-f178.google.com with SMTP id j38so1801066iad.37
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 09:47:17 -0700 (PDT)
Message-ID: <51780C92.4000208@lwfinger.net> (sfid-20130424_184721_962417_9602E9AF)
Date: Wed, 24 Apr 2013 11:47:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Stahn <michael.stahn.42@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Realtek 8192CU not working
References: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com> <CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com> <5177F100.1070803@lwfinger.net> <CALvqYaQt+nL-PxSeEUNpsG9SWV+--S64ksr1UR+8TPg5dVPKXA@mail.gmail.com>
In-Reply-To: <CALvqYaQt+nL-PxSeEUNpsG9SWV+--S64ksr1UR+8TPg5dVPKXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2013 11:20 AM, Michael Stahn wrote:
> I've just recompiled the kernel and executed the following procedure:
> modprobe rtl8192cu -> plugin in Wlan-Stick -> connect wlan via
> Networkmanager (no connection was established, credentials are
> correct) -> unplug Stick. Attachment contains the dmes-output.

Please do not drop the Cc to the Linux wireless mailing list unless you are 
requested to send something of a sensitive nature. Always use "Reply to all".

[  448.211707] rtl8192cu: MAC auto ON okay!
[  448.248820] rtl8192cu: Tx queue select: 0x05
[  448.615206] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  464.990166] ehci_hcd 0000:00:16.2: detected XactErr len 0/15360 retry 1
[  464.990540] ehci_hcd 0000:00:16.2: detected XactErr len 0/15360 retry 2
[  464.990613] hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0004
[  464.990642] ehci_hcd 0000:00:16.2: GetStatus port:2 status 001002 0  ACK 
POWER sig=se0 CSC
[  464.990661] hub 3-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[  464.990672] usb 3-2: USB disconnect, device number 3

That error is something in the USB hub driver. What is your architecture?

To get a little more detail, please rebuild your kernel with CONFIG_USB_DEBUG 
set and post the full log on some paste site. I will likely need to have the 
help of the USB expert on this matter, but we need more details first.

Larry

