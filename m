Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:47028 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbZGXPw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 11:52:59 -0400
Message-ID: <4A69D8C6.9040103@promwad.com>
Date: Fri, 24 Jul 2009 18:52:38 +0300
From: Ivan Kuten <ivan.kuten@promwad.com>
Reply-To: ivan.kuten@promwad.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WPA2, compat-wireless-2.6.31-rc3, kernel 2.6.28 - rtl8187 -
 association works but no ping
References: <4A682BBD.90101@promwad.com>	<43e72e890907230917w226c4697v41f907623e5f7d8@mail.gmail.com> 	<4A696D33.8050606@promwad.com> <43e72e890907240824n5bcff378m1278eb948055a9a5@mail.gmail.com>
In-Reply-To: <43e72e890907240824n5bcff378m1278eb948055a9a5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> ifconfig:
>>
>> eth0      Link encap:Ethernet  HWaddr 02:80:AD:20:31:EB
>>          inet addr:192.168.5.1  Bcast:192.168.5.255  Mask:255.255.255.0
>>          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>          RX packets:40 errors:0 dropped:0 overruns:0 frame:0
>>          TX packets:188 errors:0 dropped:0 overruns:0 carrier:0
>>          collisions:0 txqueuelen:1000
>>          RX bytes:4077 (3.9 KiB)  TX bytes:17012 (16.6 KiB)
> 
> Note an IP address on eth0, most likely you have a default route using
> eht0 as well. Check with 'ip route'.
> 

No default route. eth0 only for netconsole.
I'm doing udhcpc on wlan0.
Another thing is that WPA-TKIP is working. The problem only with CCMP.
I posted also in wpa_supplicant list with detailed wpa_supplicant log:
http://lists.shmoo.com/pipermail/hostap/2009-July/020026.html

>> wlan0     Link encap:Ethernet  HWaddr 00:12:0E:98:67:FC
>>          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
>>          RX packets:2 errors:0 dropped:0 overruns:0 frame:0
>>          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
>>          collisions:0 txqueuelen:1000
>>          RX bytes:304 (304.0 B)  TX bytes:3932 (3.8 KiB)
>>
>> wmaster0  Link encap:UNSPEC  HWaddr 00-12-0E-98-67-FC-00-00-00-00-00-00-00-00-00-00
>>          UP RUNNING  MTU:0  Metric:1
>>          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>>          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>>          collisions:0 txqueuelen:1000
>>          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
>>
>> Neither dhcp nor setting static IP for wlan0 - no ping.
> 
> Do you have Network Manager on? Please read:
> 

No Network Manager.
Just:
wpa_supplicant -Dwext -iwlan0 -c /home/ACORP.conf -dd &
/sbin/udhcpc -n -q -i wlan0 -s /bin/default.script

> http://wireless.kernel.org/en/users/Documentation/Reporting_bugs
> 
> Specifically the section that describes getting 'iw event -t' log and
> Network Manager.
> 

I'll try with iw event -t.
Is it possible to check via debugfs something like number of received unencrypted packets?

Regards,
Ivan



