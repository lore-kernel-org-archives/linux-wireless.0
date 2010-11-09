Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42770 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0KINFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 08:05:49 -0500
Received: by yxe1 with SMTP id 1so25803yxe.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 05:05:48 -0800 (PST)
Message-ID: <4CD9474C.5010003@lwfinger.net>
Date: Tue, 09 Nov 2010 07:06:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Yermandu Patapitafious <yermandu.dev@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187/8189
References: <AANLkTim5a_oFXqjMrcbcUipG5FijbUoFkYF6ri6zO7wg@mail.gmail.com>
In-Reply-To: <AANLkTim5a_oFXqjMrcbcUipG5FijbUoFkYF6ri6zO7wg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2010 09:25 PM, Yermandu Patapitafious wrote:
> Hellow people, i buy an notebooks with the rtl8187b card.
> I have heavyly test several ways to connect but the connection can not
> be stabilize a connection.
> I try with wep, wap, without pass. Nothing works with this card.
> 
> Identify card
> 
> # lsusb
> 
> ```
> Bus 002 Device 002: ID 0bda:8189 Realtek Semiconductor Corp. RTL8187B
> Wireless 802.11g 54Mbps Network Adapter
> ```
> 
> I wanna give the atention for ID Card: 0bda:**8189**
> 
> This is not 0bda:8187 or 0bda:8197. Why i saying this? Because i
> research in the web and discover some people can get work with
> 0bda:8187 using linux kernel native module driver. But i can not
> really make connection i think something wrong with this card or
> module or maybe not, i dont know.

Driver rtl8187 should work for this device.

> When i set the AP with pass i got this error:
> 
> # iwconfig wlan0 essid "MyEssid" key s:asciikey
> 
> Error for wireless request "Set Encode" (8B2A) :
>      SET failed on device wlan0 ; Invalid argument.
> 
> Using wep, wap or nopass.

AFAIK, that has never worked.

> I subscribe the ht tps: //qa.  mandriva  .com/ show_bug.cgi?id= 39334
> a bug open related with this problem. Recently we have a notice in
> comment #11 to try use with ndiswrapper
> 
> ```
> 
> ndiswrapper -a 0bda:8197 net8187b
> 
> ```
> But i can not force to use 0bda:8197 instead 0bda:8189:

Your device has the USB ID 0bda:8189. That is built into the device. You cannot
force it to be anything else.

> ```
> # ndiswrapper -a 0bda:8197 net8187b
> Driver 'net8187b' is already used for '0BDA:8197'
> 
> # ndiswrapper -l
> net8187b : driver installed
>         device (0BDA:8189) present (alternate driver: rtl8187)
> ```
> 
> But this can not be donned, it persist to use 8189 and not 8197 as related.
> 
> I don't know anyone else with this same model of card, and how we can
> do more tests. I hope someone can help us.
> 
> Im using
> 
> Linux  2.6.33.7-rt29 #7 SMP PREEMPT RT Tue Nov 2 23:41:52 BRST 2010
> x86_64 Pentium(R) Dual-Core CPU T4200 @ 2.00GHz GenuineIntel GNU/Linux
> 
> I test in the Ubuntu, Mandriva and Arch and no lucky. I try in Gentoo
> too with kernel 2.6.36-wl+ (git version), same issues.

It appears that you are not using NetworkManager. If that is true, then I think
you should be preparing the correct ifcfg file for whatever distro you are
using. The hexadecimal key for WEP should be there. A passphrase almost never
works there. If you want to use WPA or WPA2, then you can use a phrase; however,
you will need to install wpa_supplicant and the appropriate configuration file.

To test is your device is working, get rid of ndiswrapper, allow rtl8187 to
load, and (as root) run the command 'iwlist scan'. If you can see your AP, then
the device is likely OK.

You should pick one of the distros you mention, and post a request for wireless
configuration on their help forum. I do not use any of them, and I'm not
familiar with their specific configuration.

I also recommend using NetworkManager. It makes wireless setup much easier.

Larry
