Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-forward2.uio.no ([129.240.10.71]:43461 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab2JJKPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 06:15:39 -0400
Received: from exim by mail-out2.uio.no with local-bsmtp (Exim 4.75)
	(envelope-from <Jon.Wikne@cern.ch>)
	id 1TLska-0006oy-AX
	for linux-wireless@vger.kernel.org; Wed, 10 Oct 2012 11:38:48 +0200
Message-ID: <50754224.7060506@cern.ch> (sfid-20121010_121543_740091_E1CD2D6C)
Date: Wed, 10 Oct 2012 11:38:44 +0200
From: Jon Wikne <Jon.Wikne@cern.ch>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Mysterious hangs - cfg80211 - ath9k
References: <4FE03291.5030202@cern.ch> <CAD2nsn1U0UHjrDp7vh7rfvTP=BLB3FA+zLV9sgt1_T7gVvAYgg@mail.gmail.com> <4FE0CA6C.3080002@cern.ch> <4FEC6447.7010007@cern.ch> <CAD2nsn3L6K6obTzpvnjetrWuGk+e+nKV=RsdQfYk3iVCsej66Q@mail.gmail.com> <4FEC7B66.5060409@cern.ch> <CAD2nsn0dF5E6-9Q-ULufpigHoy8=_dzXToU1rDP_pEMMXvuxXQ@mail.gmail.com>
In-Reply-To: <CAD2nsn0dF5E6-9Q-ULufpigHoy8=_dzXToU1rDP_pEMMXvuxXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/29/2012 08:19 AM, Mohammed Shafi wrote:
>>
>> OK, done. I don't know when the error might reappear, but I will copy
>> the /sys/kernel/debug/ieee80211/phy0/ tree and put on some server for
>> forensics when it does. There is a lot of info there which I do not
>> know how to interpret.
>>
>
> ok, you can also post the complete logs, once the issues appears with ath9k
> debug messages

Thanks.

It has been some months since I have had the possibility to pursue
this issue now. The reason is that the problem occurs only shortly
after a DHCP "lease" is renewed, and not _always_ but seemingly
random. This means that when using this system on networks with long
DHCP lease times, as I mostly do, the problem appears only rarely.
However, with _short_ lease times, like the about 1500 seconds
typically at the CERN WLAN network, the "Calling CRDA" hang appears
more frequently, and does represent a significant problem.

Anyway, since June I have:

1) Upgraded to compat-wireless-2012-05-10, just in case the problem
had been solved. No luck there! ;-)

2) Applied:

modprobe -v ath9k debug=0x601
mount -t debugfs debugfs /sys/kernel/debug/

when using the driver.

When the problem occurs, I still se no other WLAN related messages in
the ordinary log files than:

Oct  9 23:02:55 redcat kernel: wlan0: authenticate with 00:20:a6:b0:c1:0e
Oct  9 23:02:55 redcat kernel: wlan0: send auth to 00:20:a6:b0:c1:0e 
(try 1/3)
Oct  9 23:02:55 redcat kernel: wlan0: authenticated
Oct  9 23:02:55 redcat kernel: ath9k 0000:03:00.0: wlan0: disabling HT 
as WMM/QoS is not supported by the AP
Oct  9 23:02:55 redcat kernel: ath9k 0000:03:00.0: wlan0: disabling VHT 
as WMM/QoS is not supported by the AP
Oct  9 23:02:55 redcat kernel: wlan0: associate with 00:20:a6:b0:c1:0e 
(try 1/3)
Oct  9 23:02:55 redcat kernel: wlan0: RX AssocResp from 
00:20:a6:b0:c1:0e (capab=0x421 status=0 aid=5)
Oct  9 23:02:55 redcat kernel: wlan0: associated
Oct  9 23:02:55 redcat dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 
port 67 (xid=0x7913599d)
Oct  9 23:02:55 redcat dhclient: DHCPACK from 137.138.16.6 (xid=0x7913599d)
Oct  9 23:02:55 redcat avahi-daemon[3736]: New relevant interface 
wlan0.IPv4 for mDNS.
Oct  9 23:02:55 redcat avahi-daemon[3736]: Joining mDNS multicast group 
on interface wlan0.IPv4 with address 128.141.230.110.
Oct  9 23:02:55 redcat avahi-daemon[3736]: Registering new address 
record for 128.141.230.110 on wlan0.
Oct  9 23:02:55 redcat NET[12486]: /sbin/dhclient-script : updated 
/etc/resolv.conf
Oct  9 23:02:55 redcat dhclient: bound to 128.141.230.110 -- renewal in 
1590 seconds.
Oct  9 23:29:25 redcat dhclient: DHCPREQUEST on wlan0 to 137.138.16.6 
port 67 (xid=0x7913599d)
Oct  9 23:29:25 redcat dhclient: DHCPACK from 137.138.16.6 (xid=0x7913599d)
Oct  9 23:29:25 redcat dhclient: bound to 128.141.230.110 -- renewal in 
1488 seconds.
Oct  9 23:54:13 redcat dhclient: DHCPREQUEST on wlan0 to 137.138.16.6 
port 67 (xid=0x7913599d)
Oct  9 23:54:13 redcat dhclient: DHCPACK from 137.138.16.6 (xid=0x7913599d)
Oct  9 23:54:13 redcat dhclient: bound to 128.141.230.110 -- renewal in 
1579 seconds.
Oct  9 23:57:00 redcat kernel: cfg80211: Calling CRDA to update world 
regulatory domain

After the last message here, the WLAN hangs. There is also a message
about the DRDA in dmesg, but nothing else.

Subsequently, as for WLAN related messages, I see only:

Oct 10 00:20:32 redcat dhclient: DHCPREQUEST on wlan0 to 137.138.16.6 
port 67 (xid=0x7913599d)
Oct 10 00:21:19 redcat last message repeated 4 times
Oct 10 00:22:23 redcat last message repeated 5 times

until I restart WLAN, i.e.

/sbin/ifdown wlan0
/sbin/ifup wlan0

I have prepared two files with the content of all the files in the
directory

/sys/kernel/debug/ieee80211/phy0/ath9k/

for "forensics", one when the system functions normally, and one when
the problem is there. These can be downloaded here:

http://shaimina.wikne.no/jon/ath9k/

The only (to me) obvious difference is in:

/sys/kernel/debug/ieee80211/phy0/ath9k/stations

which is practically blank when the CRDA error is present.

To me, it might seem that the WLAN chip (AR9285 in my case) has been
effectively turned off....

Please CC me if posting a reply. I'm not on the list.

Regards,
-- Jon Wikne
