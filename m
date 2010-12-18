Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52959 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0LRDcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 22:32:13 -0500
Received: by wwa36 with SMTP id 36so1305470wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 19:32:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D0BC0C1.4000809@lwfinger.net>
References: <AANLkTikKtc4uiXN+oHwDr8sPFXZCe3HvTfYSvgZ8uYx0@mail.gmail.com>
	<4D0BADBE.40101@lwfinger.net>
	<AANLkTimvazto71m6SPMYtSAGuQkNpab+kMZcF4buNqYa@mail.gmail.com>
	<4D0BC0C1.4000809@lwfinger.net>
Date: Fri, 17 Dec 2010 22:32:12 -0500
Message-ID: <AANLkTinCWK95_eFb47pFLz2O=+UHMGpeXg9Z_JstFEa=@mail.gmail.com>
Subject: Re: rtl8192 does not see N networks in my building
From: Amos Blanton <amos.blanton@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 17, 2010 at 2:57 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The report I have from Realtek is that a mac80211 driver for that device is
> nearing completion. I originally thought that you were using a staging driver,
> but you must be using a driver from Realtek's site. Do you have the latest? I
> show it to be rtl8192se_linux_2.6.0018.1025.2010. As I recall, that one does not
> work on a 64-bit system.

AFAIK it's whatever ships with Ubuntu 10.10, unless the people at
Zareason installed a different driver before shipping this laptop.
I've searched the package manager but can't find anything related.
Let's see, google says modinfo should tell me. Here's the output:

lightnin@Buford:~$ modinfo r8192se_pci
filename:
/lib/modules/2.6.35-23-generic/kernel/ubuntu/rtl8192se/r8192se_pci.ko
license:        GPL
version:        0017.0507.2010
author:         Copyright(c) 2008 - 2010 Realsil Semiconductor
Corporation <wlanfae@realtek.com>
description:    Linux driver for Realtek RTL819x WiFi cards
srcversion:     64C041B4E539FCBBF8BEA08
alias:          pci:v000010ECd00008174sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008173sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008172sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008171sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008192sv*sd*bc*sc*i*
depends:
vermagic:       2.6.35-23-generic SMP mod_unload modversions
parm:           ifname: Net interface name, wlan%d=default (charp)
parm:           hwwep: Try to use hardware WEP support(default use hw.
set 0 to use software security) (int)
parm:           channels: Channel bitmask for specific locales. NYI (int)


> You need to run iwlist as root to get an active scan. That is why I specified
> the "sudo iwlist scan". Your prompt above looks like the regular user one. If
> I'm wrong there, then something is blocking transmission. Is the module rfkill
> loaded?

Ah, my apologies! I did forget the sudo - sorry about that. I've left
work now but will do a scan on Monday.

Should I try installing an updated version of the driver that is
compatible with 64 bit systems? Where might that be?

Amos

>
> Larry
>
