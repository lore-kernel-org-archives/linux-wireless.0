Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:60960 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbXGHSaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 14:30:00 -0400
Message-ID: <46912D23.3010401@warmcat.com>
Date: Sun, 08 Jul 2007 19:29:55 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com> <46910F3F.8010201@warmcat.com> <20070708181524.GA12389@deine-taler.de> <200707082018.23045.mb@bu3sch.de>
In-Reply-To: <200707082018.23045.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Sunday 08 July 2007 20:15:24 Ulrich Kunitz wrote:
>> On 07-07-08 17:22 Andy Green wrote:
>>
>>> I rebooted into the new kernel and did this only
>>>
>>> # iwconfig wlan0 mode monitor
>>> # ifconfig wlan0 up
>>> # iwconfig wlan0 channel 6
>>> # tcpdump -i wlan0
>>>
>>> But all I could see were beacons, this is despite I am ssh-d into that
>>> box over the same channel 6 network with WPA and should surely be seeing
>>> the encrypted packets?
>> I assume you were connected over a different interface. It appears
>> that the code, which enables the reception of all packets hasn't
>> been called or is wrong. Currently you will see only packets that
>> are sent to the interface. Promiscous mode is also interesting,
>> but shouldn't have any importance in monitor mode, which the
>> iwconfig manual describes as passing all packets on the frequency.

That's right, I actually use eth0 on the test box which ends up at an AP
in bridge mode, and this laptop is coming in to the test box via the AP
(and then eth0).

ZD1211 - usb - [test box] -- eth0 -- [AP] -- wireless -- [main laptop]

The ZD1211 should definitely be in a place to see the traffic between
the main laptop and the eth0 side of the test box since it is also set
to ch6, it is only 3 - 4 metres from the AP.

I wonder if there is some kind of filtering enabled with the firmware or
the hardware, only packets with both the AP MAC and the wlan0 MAC are
allowed somehow.  And beacons.

>>> Then I decided to start wpa_supplicant (this
>>> is an FC6 box so it was service wpa_supplicant start) and I got this oops:
>>>
>>> ...
>>> EIP is at zd_mac_config_interface+0xc/0x35 [zd1211rw_mac80211]
>>> ...
>> I believe Jon Smirl reported the same bug. But I didn't quite
>> understand how to provoke it.
> 
> I think it's the NULL pointer dereference of the mac address pointer,
> if there's only a monitor interface. The address pointer can be NULL.

Right, that is the situation: there is only a single default interface
wlan0 and it has been placed into Monitor mode.  Then you start
wpa_supplicant to provoke the Oops.

-Andy

