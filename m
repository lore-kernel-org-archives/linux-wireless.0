Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:59998 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaL3QTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 11:19:10 -0500
Message-ID: <54A2D07B.607@broadcom.com> (sfid-20141230_171930_141225_45E945A7)
Date: Tue, 30 Dec 2014 17:19:07 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Tuc at Beach House <tuctboh@gmail.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: IBSS or Hostapd, but not both
References: <CAM-0sLw-N1J535xWE=XG-Pn3yi7YBUFhbBKJE0pmEUy9tKDtsA@mail.gmail.com> <54A2C865.8020203@lwfinger.net>
In-Reply-To: <54A2C865.8020203@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/30/14 16:44, Larry Finger wrote:
> On 12/29/2014 01:17 PM, Tuc at Beach House wrote:
>> Hi,
>>
>> Raspberry Pi Model B+, Linux blue 3.12.28+ #709 PREEMPT Mon Sep 8
>> 15:28:00
>> BST 2014 armv6l GNU/Linux, hostapd v2.3 (defconfig), Ralink using
>> rt2800usb
>> driver on either a Wi-Pi or Panda Ultra Wireless N USB Adapter.
>>
>> What I'm trying to accomplish is using a single interface to be an AP on
>> one SSID, and ad-hoc on another SSID. The problem is that I can either do
>> one, or the other, but not both...
>>
>> root@blue:~# iwconfig wlan1
>> wlan1 IEEE 802.11bgn ESSID:off/any
>> Mode:Managed Access Point: Not-Associated Tx-Power=0 dBm
>> Retry long limit:7 RTS thr:off Fragment thr:off
>> Encryption key:off
>> Power Management:on
>>
>> So if I set up ad-hoc, works fine :
>>
>> root@blue:~# iw dev wlan1 interface add wlan10 type ibss
>> root@blue:~# iwconfig wlan10
>> wlan10 IEEE 802.11bgn ESSID:off/any
>> Mode:Ad-Hoc Cell: Not-Associated Tx-Power=0 dBm
>> Retry long limit:7 RTS thr:off Fragment thr:off
>> Encryption key:off
>> Power Management:on
>>
>> root@blue:~# iwconfig wlan10 essid WEDDING
>> root@blue:~# ifconfig wlan10 10.4.4.8 netmask 255.255.255.0
>> root@blue:~# ping -c2 new
>> PING new.wedding.ramolaandscott,com (10.4.4.6) 56(84) bytes of data.
>> 64 bytes from new.wedding.ramolaandscott,com (10.4.4.6): icmp_req=1
>> ttl=64
>> time=3.51 ms
>> 64 bytes from new.wedding.ramolaandscott,com (10.4.4.6): icmp_req=2
>> ttl=64
>> time=1.02 ms
>>
>> --- new.wedding.ramolaandscott,com ping statistics ---
>> 2 packets transmitted, 2 received, 0% packet loss, time 1001ms
>> rtt min/avg/max/mdev = 1.024/2.268/3.512/1.244 ms
>>
>>
>> Now invoke hostapd with the following /etc/hostapd/hostapd.conf :
>>
>> root@blue:~# cat /etc/hostapd/hostapd.conf
>> interface=wlan1
>> ssid=FREE
>> hw_mode=g
>> channel=1
>> root@blue:~# /usr/local/bin/hostapd -dd /etc/hostapd/hostapd.conf
>> (Please see http://pastebin.com/cjqukwyH)
>>
>>
>> But if I reboot and try backwards :
>>
>> root@blue:~# hostapd -dd /etc/hostapd/hostapd.conf
>> (Please see http://pastebin.com/Tdc5dz81)
>>
>>
>> And its fine, but then :
>>
>> root@blue:~# iw dev wlan1 interface add wlan10 type ibss
>> root@blue:~# iwconfig wlan10
>> wlan10 IEEE 802.11bgn ESSID:off/any
>> Mode:Ad-Hoc Cell: Not-Associated Tx-Power=20 dBm
>> Retry long limit:7 RTS thr:off Fragment thr:off
>> Encryption key:off
>> Power Management:on
>>
>> root@blue:~# iwconfig wlan10 essid WEDDING
>> root@blue:~# ifconfig wlan10
>> wlan10 Link encap:Ethernet HWaddr 00:c1:41:07:07:d1
>> BROADCAST MULTICAST MTU:1500 Metric:1
>> RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>> TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>> collisions:0 txqueuelen:1000
>> RX bytes:0 (0.0 B) TX bytes:0 (0.0 B)
>>
>> root@blue:~# ifconfig wlan10 10.4.4.8 netmask 255.255.255.0
>> SIOCSIFFLAGS: Device or resource busy
>> root@blue:~# ifconfig wlan10
>> wlan10 Link encap:Ethernet HWaddr 00:c1:41:07:07:d1
>> inet addr:10.4.4.8 Bcast:10.4.4.255 Mask:255.255.255.0
>> BROADCAST MULTICAST MTU:1500 Metric:1
>> RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>> TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>> collisions:0 txqueuelen:1000
>> RX bytes:0 (0.0 B) TX bytes:0 (0.0 B)
>>
>> root@blue:~# ping -c2 new
>> PING new.wedding.ramolaandscott,com (10.4.4.6) 56(84) bytes of data.
>>
>> --- new.wedding.ramolaandscott,com ping statistics ---
>> 2 packets transmitted, 0 received, 100% packet loss, time 1001ms
>>
>>
>>
>> Any idea where to look or what to do to get them to work and play
>> together?
>
> I am not an expert, but this sounds like a proper application of virtual
> interfaces.

Hi Larry,

The thread started on the hostap mailing list [1]. I have taken part of 
pastebin page [2]:

         Supported interface modes:
                  * IBSS
                  * managed
                  * AP
                  * AP/VLAN
                  * WDS
                  * monitor
                  * mesh point
         software interface modes (can always be added):
                  * AP/VLAN
                  * monitor
         valid interface combinations:
                  * #{ AP, mesh point } <= 8,
                    total <= 8, #channels <= 1

Looks to me that those interface combinations are clearly *not* valid as 
it does list only two of the supported interface modes.

Regards,
Arend

[1] http://thread.gmane.org/gmane.linux.drivers.hostap/31697/focus=31723
[2] http://pastebin.com/RytcqXVZ

> Larry
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

