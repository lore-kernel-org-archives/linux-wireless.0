Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost01.isp.att.net ([204.127.217.101]:62083 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZFDP7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 11:59:39 -0400
Message-ID: <4A27EF6C.8000208@lwfinger.net>
Date: Thu, 04 Jun 2009 10:59:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: always init poll delayed work
References: <1244015729.7176.28.camel@johannes.local>	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>
In-Reply-To: <1244128337.22576.81.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Could you try, without the patch in question, what happens in terms of
> uevents
>  * have everything on
>  * press rfkill button (expect -> hw_blocked transition)
>  * put interface down
>  * press rfkill button (expect -> unblocked transition)
>  * put interface up

I'm running v2.6.30-rc8-25743-g3b2029b from wireless-testing.

This is with interface UP and switch off:

larrylap:/etc/sysconfig/network # cat /sys/class/rfkill/rfkill0/uevent
PHYSDEVPATH=/devices/pci0000:00/0000:00:0d.0/0000:04:00.0/ssb0:0
PHYSDEVBUS=ssb
PHYSDEVDRIVER=b43
RFKILL_NAME=phy0
RFKILL_TYPE=wlan
RFKILL_STATE=2


larrylap:/etc/sysconfig/network # ifdown eth1
    eth1      name: BCM4312 802.11a/b/g
larrylap:/etc/sysconfig/network # cat /sys/class/rfkill/rfkill0/uevent
PHYSDEVPATH=/devices/pci0000:00/0000:00:0d.0/0000:04:00.0/ssb0:0
PHYSDEVBUS=ssb
PHYSDEVDRIVER=b43
RFKILL_NAME=phy0
RFKILL_TYPE=wlan
RFKILL_STATE=2

At this point, radio kill switch turned on:

larrylap:/etc/sysconfig/network # ifup eth1
    eth1      name: BCM4312 802.11a/b/g
    eth1      warning: WPA configured but may be unsupported
    eth1      warning: by this device
    eth1      starting wpa_supplicant
SIOCSIFFLAGS: Unknown error 132
Could not set interface 'eth1' UP
RTNETLINK answers: Unknown error 132
Starting DHCP4 client on eth1. . . .
    eth1      DHCP4 client NOT running
RTNETLINK answers: Unknown error 132
Cannot enable interface eth1.
interface eth1 is not up

larrylap:/etc/sysconfig/network # cat /sys/class/rfkill/rfkill0/uevent
PHYSDEVPATH=/devices/pci0000:00/0000:00:0d.0/0000:04:00.0/ssb0:0
PHYSDEVBUS=ssb
PHYSDEVDRIVER=b43
RFKILL_NAME=phy0
RFKILL_TYPE=wlan
RFKILL_STATE=2

The ERFKILL (132) prevents it from coming up. Again, the switch was on
at this point.

I could not restore service until rmmod/insmod of b43.

Larry
