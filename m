Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63856 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab1G1Xrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 19:47:39 -0400
Received: by fxh19 with SMTP id 19so1724908fxh.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 16:47:38 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Martin Partridge" <martin_partridge@btconnect.com>
Subject: Re: help
Date: Fri, 29 Jul 2011 01:47:26 +0200
Cc: linux-wireless@vger.kernel.org
References: <op.vzcrpnuuhgplxr@melanie>
In-Reply-To: <op.vzcrpnuuhgplxr@melanie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201107290147.26919.chunkeey@googlemail.com> (sfid-20110729_014752_959678_49554EA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, July 29, 2011 01:33:13 AM Martin Partridge wrote:
> I don't understand the last 2 steps, i'm running fedora (ok i lie its  
> Fuduntu, but to all intents and purposes its fedora) Kernel version:  
> 2.6.39.3-1.fc14.i686
recent enough. 

> i'm using a WG511v2 PCMCIA card, i've downloaded the correct firmware,  
> renamed it and modprobed everything as instructed, the bit i'm having  
> trouble with is this bit:
> 
> Enabling p54
> 
> To enable p54, you must first enable mac80211:
> 
> Networking Support --->
>    Wireless  --->
>      <M> cfg80211 - wireless configuration API
>      <M> Generic IEEE 802.11 Networking Stack (mac80211)
> 
> You can then enable p54 in the kernel configuration under
> 
> Device Drivers  --->
>    [*] Network device support  --->
>          Wireless LAN --->
>            [*] Wireless LAN (IEEE 802.11)
>            <M>   Softmac Prism54 support
>            <M>     Prism54 USB support
>            <M>     Prism54 PCI support
>            <M>     Prism54 SPI (stlc45xx) support
> 
> where do i type this, or what does it mean? I i don't have a 'networking  
> support' menu and it's not a program, where do i find this? is it a conf  
> file? I'm no stranger to linux but this is perplexing, the card works fine  
> on windows, but i can't get it work now. I have a kernel config file in  
> /etc/sysconfig but its a bit bare, as shown below:
> 
> # UPDATEDEFAULT specifies if new-kernel-pkg should make
> # new kernels the default
> UPDATEDEFAULT=yes
> 
> # DEFAULTKERNEL specifies the default kernel package type
> DEFAULTKERNEL=kernel
> 
> That's the whole thing.
> 
> How do i enable p54 and mac80211, i'm not sure and its bloody annoying.
Ah you see, you don't need to do that. This step is only necessary if you
make your own kernel [from scratch] and you haven't enabled p54 yet. But
since your using fedora's default 2.6.39.3-1.fc14.i686 kernel, I hope they
have taken care of it and provided you with a fitting p54common and p54pci
modules.

In fact, the device should show up right away soon as you insert the pcmcia
card into the slot. Check networkmanager/wicd/ifconfig -a/iw list for any
new devices. If it doesn't show up, you might want to post your `dmesg`,
[releavant p54 extract] syslog right here. I also have a WG511v2 so it should
work pretty much out of the box.

Regards,
	Chr
