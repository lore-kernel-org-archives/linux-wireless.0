Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64588 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077Ab3CHAyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 19:54:37 -0500
Received: by mail-oa0-f41.google.com with SMTP id i10so1396617oag.28
        for <linux-wireless@vger.kernel.org>; Thu, 07 Mar 2013 16:54:37 -0800 (PST)
Message-ID: <513936C8.5060908@lwfinger.net> (sfid-20130308_015441_955400_39924D52)
Date: Thu, 07 Mar 2013 18:54:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jenya Y <jenya.gerstmaier@live.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: PROBLEM: linux kernel 3.9 rc1 and rtl8187 wireless, unable to
 connect to any available hotspots.
References: <51380336.6030007@live.com> <BLU0-SMTP15357D4D2469B872AE4355CF1E50@phx.gbl> <5138109D.1040605@lwfinger.net> <BLU0-SMTP18556F96AB7DC8FE9D76DA3F1E50@phx.gbl>
In-Reply-To: <BLU0-SMTP18556F96AB7DC8FE9D76DA3F1E50@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2013 11:16 PM, Jenya Y wrote:
> Larry, thank you for reply.
>
> I set up my router with WPA2 //  the USB ID Device 008: ID 0bda:8187 Realtek
> Semiconductor Corp. RTL8187 Wireless Adapter.
> (I used lsusb in my 3.8.2, I hope it makes no difference, it's the vendor device
> id I suppose...)

*Never* drop the Cc to any mailing list unless you are prepared to pay for 
private consulting!!

I generated a 64-bit version of Linus's current mainline tree. The results for 
carious commands are as follows:

finger@linux-cqp5:~/linux-2.6> sudo iwlist wlan1 scan
wlan1     Scan completed :
           Cell 01 - Address: C0:3F:0E:BE:2B:44
                     Channel:3
                     Frequency:2.422 GHz (Channel 3)
                     Quality=70/70  Signal level=-36 dBm
                     Encryption key:on
                     ESSID:"lwfdjf-n"
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                               24 Mb/s; 36 Mb/s; 54 Mb/s
                     Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
                     Mode:Master
                     Extra:tsf=0000027606801313
                     Extra: Last beacon: 4ms ago
                     IE: Unknown: 00086C7766646A662D6E
                     IE: Unknown: 010882848B962430486C
                     IE: Unknown: 030103
                     IE: Unknown: 2A0100
                     IE: Unknown: 2F0100
                     IE: IEEE 802.11i/WPA2 Version 1
                         Group Cipher : CCMP
                         Pairwise Ciphers (1) : CCMP
                         Authentication Suites (1) : PSK
                     IE: Unknown: 32040C121860
                     IE: Unknown: 
2D1A1E181AFFFF000001000000000000000000000000000000000000
                     IE: Unknown: 3D1603051300000000000000000000000000000000000000
                     IE: Unknown: 
DD790050F204104A00011010440001021041000100103B000103104700103452030A44DB81A930CE71790556FE821021000D4E4554474541522C20496E632E10230008574E44523333303010240008574E4452333330301042000230311054000800060050F204000110110008574E445233333030100800020084
                     IE: Unknown: DD090010180201F0050000
                     IE: Unknown: 
DD180050F2020101800003A4000027A4000042435E0062322F00
                     IE: Unknown: 
DD1E00904C331E181AFFFF000001000000000000000000000000000000000000
                     IE: Unknown: 
DD1A00904C3403051300000000000000000000000000000000000000

finger@linux-cqp5:~/linux-2.6> iwconfig wlan1
wlan1     IEEE 802.11bg  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=48 Mb/s   Tx-Power=20 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-39 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:49   Missed beacon:0

finger@linux-cqp5:~/linux-2.6> ifconfig wlan1
wlan1     Link encap:Ethernet  HWaddr 00:1B:2F:A2:07:CA
           inet addr:192.168.1.115  Bcast:192.168.1.255  Mask:255.255.255.0
           inet6 addr: fe80::21b:2fff:fea2:7ca/64 Scope:Link
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:18 errors:0 dropped:0 overruns:0 frame:0
           TX packets:44 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:6137 (5.9 Kb)  TX bytes:11066 (10.8 Kb)

finger@linux-cqp5:~/linux-2.6> uname -r
3.9.0-rc1-Linus+


finger@linux-cqp5:~/linux-2.6> lsusb
Bus 002 Device 002: ID 0409:005a NEC Corp. HighSpeed Hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 004: ID 0846:6a00 NetGear, Inc. WG111v2 54 Mbps Wireless [RealTek 
RTL8187L]


As you can see, my system connected to a WPA2-encrypted network running 3.9-rc1 
from the mainline tree. I do not know what problem you are having, but I cannot 
reproduce it. My USB ID is different, but the chip is the same.

Larry

