Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62935 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0KIDZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 22:25:01 -0500
Received: by iwn10 with SMTP id 10so654315iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 19:25:00 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 9 Nov 2010 01:25:00 -0200
Message-ID: <AANLkTim5a_oFXqjMrcbcUipG5FijbUoFkYF6ri6zO7wg@mail.gmail.com>
Subject: RTL8187/8189
From: Yermandu Patapitafious <yermandu.dev@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Yermandu Patapitafious <yermandu.dev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hellow people, i buy an notebooks with the rtl8187b card.
I have heavyly test several ways to connect but the connection can not
be stabilize a connection.
I try with wep, wap, without pass. Nothing works with this card.

Identify card

# lsusb

```
Bus 002 Device 002: ID 0bda:8189 Realtek Semiconductor Corp. RTL8187B
Wireless 802.11g 54Mbps Network Adapter
```

I wanna give the atention for ID Card: 0bda:**8189**

This is not 0bda:8187 or 0bda:8197. Why i saying this? Because i
research in the web and discover some people can get work with
0bda:8187 using linux kernel native module driver. But i can not
really make connection i think something wrong with this card or
module or maybe not, i dont know.

When i set the AP with pass i got this error:

# iwconfig wlan0 essid "MyEssid" key s:asciikey

Error for wireless request "Set Encode" (8B2A) :
     SET failed on device wlan0 ; Invalid argument.

Using wep, wap or nopass.

?

I subscribe the ht tps: //qa.  mandriva  .com/ show_bug.cgi?id= 39334
a bug open related with this problem. Recently we have a notice in
comment #11 to try use with ndiswrapper

```

ndiswrapper -a 0bda:8197 net8187b

```
But i can not force to use 0bda:8197 instead 0bda:8189:

```
# ndiswrapper -a 0bda:8197 net8187b
Driver 'net8187b' is already used for '0BDA:8197'

# ndiswrapper -l
net8187b : driver installed
        device (0BDA:8189) present (alternate driver: rtl8187)
```

But this can not be donned, it persist to use 8189 and not 8197 as related.

I don't know anyone else with this same model of card, and how we can
do more tests. I hope someone can help us.

Im using

Linux  2.6.33.7-rt29 #7 SMP PREEMPT RT Tue Nov 2 23:41:52 BRST 2010
x86_64 Pentium(R) Dual-Core CPU T4200 @ 2.00GHz GenuineIntel GNU/Linux

I test in the Ubuntu, Mandriva and Arch and no lucky. I try in Gentoo
too with kernel 2.6.36-wl+ (git version), same issues.


Links:

lsusb-verbose.log:  ht tp pastebin . ca/1985873
Windows 7 X64 driver: ht tp  filebin . ca /ogzobt/ Win7X64.tar.gz
lsmod : paste.pocoo .org/ show/288123

RTL8187b mandriva bug: ht  tps: //  qa.  mandriva  .com/
show_bug.cgi?id  =39334


So pp that's it.

Regards,
yermandu
