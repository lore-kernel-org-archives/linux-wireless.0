Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44446 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0LQT6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 14:58:03 -0500
Received: by wyb28 with SMTP id 28so1031551wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 11:58:02 -0800 (PST)
Message-ID: <4D0BC0C1.4000809@lwfinger.net>
Date: Fri, 17 Dec 2010 13:57:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Amos Blanton <amos.blanton@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192 does not see N networks in my building
References: <AANLkTikKtc4uiXN+oHwDr8sPFXZCe3HvTfYSvgZ8uYx0@mail.gmail.com>	<4D0BADBE.40101@lwfinger.net> <AANLkTimvazto71m6SPMYtSAGuQkNpab+kMZcF4buNqYa@mail.gmail.com>
In-Reply-To: <AANLkTimvazto71m6SPMYtSAGuQkNpab+kMZcF4buNqYa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/17/2010 01:40 PM, Amos Blanton wrote:
> Here's lspci output:
> 
> $ lspci -nn | grep Realtek
> 01:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
> RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)
> 02:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
> 03)
> 03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8111/8168B PCI Express Gigabit Ethernet controller [10ec:8168] (rev
> 06)
> lightnin@Buford:~$

The report I have from Realtek is that a mac80211 driver for that device is
nearing completion. I originally thought that you were using a staging driver,
but you must be using a driver from Realtek's site. Do you have the latest? I
show it to be rtl8192se_linux_2.6.0018.1025.2010. As I recall, that one does not
work on a 64-bit system.

> iwlist:
> lightnin@Buford:~$ iwlist scan
> lo        Interface doesn't support scanning.
> 
> eth1      Interface doesn't support scanning.
> 
> eth0      Interface doesn't support scanning.
> 
> wlan0     No scan results

You need to run iwlist as root to get an active scan. That is why I specified
the "sudo iwlist scan". Your prompt above looks like the regular user one. If
I'm wrong there, then something is blocking transmission. Is the module rfkill
loaded?

Larry
