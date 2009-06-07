Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:33979 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZFGQ3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 12:29:50 -0400
Message-ID: <4A2BEAFF.7090109@lwfinger.net>
Date: Sun, 07 Jun 2009 11:29:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Markus <sparcoular@t-online.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: bcm43xx 5.10.38.35 firmware
References: <loom.20090607T124008-575@post.gmane.org> <4A2BBD98.4040708@lwfinger.net> <loom.20090607T140512-723@post.gmane.org>
In-Reply-To: <loom.20090607T140512-723@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Markus wrote:
> Larry Finger <Larry.Finger@...> writes:
> 
>> Markus wrote:
>>> Hello,
>>>
>>>
>>> after MacOSX Airport firmware update 5.10.38.35
>>>
>>> (bcm43xx/ Macbook Core2Duo SR)
>>>
>>> I cannot connect to my Wlan-Router anymore.
>>>
>>>
>>> The b43-module gets modprobed without errors
>>>
>>> and nm-applet shows my Access-Points SSID.
>>>
>>> Alas, it won't establish a connection to it.
>>>
>>>
>>> Any clues?
>> Please post all items in dmesg that pertain to ssb or b43 using
>>
>> dmesg | egrep "ssb|b43"
>>
>> Larry
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@...
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --------------------------
> 
> dmesg | egrep "ssb|b43"
> 
> 
> [  101.205300] b43-pci-bridge 0000:02:00.0: PCI
> INT A -> GSI 16 (level, low) -> IRQ 16
> 
> [  101.205322] b43-pci-bridge 0000:02:00.0: setting
> latency timer to 64
> 
> [  101.272313] ssb: Sonics Silicon Backplane found
> on PCI device 0000:02:00.0
> 
> 
> ----------------
> 
> lspci | egrep BCM
> 
> 
> 02:00.0 Network controller: Broadcom Corporation
>  BCM4328 802.11a/b/g/n (rev 03)
> 
> 
> ---------------------------
> 
> BTW I don't know if the b43 official Kernel Module ever worked
> 
> with my WIFI Controller. I'm using Ubuntu and as with kernel
> 
> 2.28 I could enable the proprietary Broadcom Driver via
> 
> the "Restricted Drivers Manager". And that Driver doesn't seem
> 
>  to work now anymore.
> 
> 
> 
> The above command outputs are nevertheless produced using
> Kernel 2.6.30 and the official b43 module.
> 
> Is my BCM-Chip supported by the official driver anyway? 
> 
> 
> 
> iwconfig can't find a wireless-supporting device either.
> 
> Only eth0, loopback and the (fw-controller?)
> 
> The proprietary driver lists eth1 in addition to that.

As it says in the wiki, an interface with the 0x4328 ID is not
supported. You need to use the Broadcom wl driver, which is
proprietary. I suppose that this was the "Restricted Driver" from
Ubuntu. Your other option would be to get the driver from Broadcom and
build it on your system.

We are in the process of doing the reverse engineering on the N-PHY
devices, but it does not have high priority at the moment.

Larry

