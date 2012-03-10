Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173007pub.verizon.net ([206.46.173.7]:58964 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2CJSKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 13:10:52 -0500
Received: from vznit170136 ([unknown] [192.168.1.3]) by vms173007.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0O00LCZL63FWD0@vms173007.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sat, 10 Mar 2012 12:10:52 -0600 (CST)
Date: Sat, 10 Mar 2012 12:10:51 -0600 (CST)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <7971088.142916.1331403052068.JavaMail.root@vznit170136> (sfid-20120310_191105_130500_EBA5228A)
Subject: Re: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi Larry,

I ran a few more tests around the subject thread.
Brought up my machine on the Knoppix-6.7.1 DVD, (his latest):

uname -a
Linux Microknoppix 3.0.4 #12 SMP PREEMPT Thu Sep 8 05:27:05 CEST 2011
 i686 GNU/Linux

iwconfig --version
iwconfig Wireless-Tools version 30
 Compatible with Wireless Extension v11 to v22.

 Kernel Currently compiled with Wireless Extension v22.

Please note the same weird version, 30.
There must be a thriving black market for wireless-tools in Germany :)

Whatever driver Knoppix uses, it is in the kernel
(i.e., not as a module) and BTW, 'iwconfig wlan0 essid ...'
 doesn't work either.

lsusb --version
lsusb (usbutils) 0.87

Two odd things:
1. Bus 002 Device 003:
 ID 0bda:8172 Realtek Semiconductor Corp. RTL8191S WLAN Adapter
 
Please note "RTL8191S" above.

2. ls -og /lib/firmware/rtlwifi
 -rw-r--r-- 1 122328 Jan 4 2011 rtl8712u.bin

As opposed to things on my subject machine (3.2.9):
lsusb --version
lsusb (usbutils) 0.73

1. Bus 002 Device 003: ID 0bda:8172 Realtek Semiconductor Corp.
Note: the missing "RTL8191S" could very well be caused by
 my using a lower lsusb version.

2. ls -og /lib/firmware/rtlwifi
 -rw-r--r-- 1 129304 2012-03-04 15:42 rtl8712u.bin
------

The 'menuconfig' on my version, 3.2.9, has only these choices for
RTL staging devices:
 8187SE
 8192U
 8192E
 8712 (8192SU)

No trace of an RTL8191S possibility.

Maybe you can make more heads (or even tails) of it.

Regards,
-- Alex

PS.  Just to prevent any uncalled-for suspicions, this Rosewill device
works smoothly and perfectly on Win XP (very same machine, different
partition) and Win 7.  Surprise, surprise.
