Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60716 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab2CGDWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 22:22:53 -0500
Received: by obbuo6 with SMTP id uo6so6300869obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 19:22:52 -0800 (PST)
Message-ID: <4F56D489.9060207@lwfinger.net> (sfid-20120307_042256_968801_5651B842)
Date: Tue, 06 Mar 2012 21:22:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: alupu@verizon.net
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u staging in kernel 3.2.9
References: <31991817.2926129.1331079358141.JavaMail.root@vznit170116>
In-Reply-To: <31991817.2926129.1331079358141.JavaMail.root@vznit170116>
Content-Type: multipart/mixed;
 boundary="------------080308070404040309070803"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080308070404040309070803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here are the details for my system, which is 64-bit. I'm running kernel 3.3-rc5 
with wireless-tools version 30. Apparently my kernel has V22 - that seems 
surprising.

If I use 'iwconfig wlanX essid blah-blah' followed by 'iwconfig wlanX key 
restricted xxxxxxxxxxxxxx', then it does not work, but it does when I combine 
the essid and key on a single line.

What would be the ifconfig command to start the interface with DHCP? In my 
distro, we have an ifup command that reads a configuration file. That script is 
too complicated to see what it does.

Larry




--------------080308070404040309070803
Content-Type: text/plain;
 name="r8712u_config"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="r8712u_config"


finger@linux-gskd:~/wireless-testing> ls -ogtr /usr/sbin | grep iw
-rwxr-xr-x 1    98504 Oct 29 12:57 iw
-rwxr-xr-x 1    14712 Oct 29 13:09 iwspy
-rwxr-xr-x 1    14760 Oct 29 13:09 iwpriv
-rwxr-xr-x 1    35504 Oct 29 13:09 iwlist
-rwxr-xr-x 1    14680 Oct 29 13:09 iwgetid
-rwxr-xr-x 1    18960 Oct 29 13:09 iwevent
-rwxr-xr-x 1    27160 Oct 29 13:09 iwconfig
finger@linux-gskd:~/wireless-testing> iwconfig --version
iwconfig  Wireless-Tools version 30
          Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

wlan4     Recommend Wireless Extension v16 or later,
          Currently compiled with Wireless Extension v22.

finger@linux-gskd:~/wireless-testing> uname -r
3.3.0-rc6-wl+
finger@linux-gskd:~/wireless-testing> iwconfig wlan4
wlan4     unassociated  Nickname:"rtl_wifi"
          Mode:Managed  Access Point: Not-Associated   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

finger@linux-gskd:~/wireless-testing> ifconfig
eth0      Link encap:Ethernet  HWaddr 40:61:86:FC:43:BA  
          inet addr:192.168.3.101  Bcast:192.168.3.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:101 errors:0 dropped:0 overruns:0 frame:0
          TX packets:117 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:60068 (58.6 Kb)  TX bytes:14665 (14.3 Kb)
          Interrupt:43 Base address:0xa000 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:56 errors:0 dropped:0 overruns:0 frame:0
          TX packets:56 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:2880 (2.8 Kb)  TX bytes:2880 (2.8 Kb)

finger@linux-gskd:~/wireless-testing> sudo iwconfig wlan4 essid radius key restricted 1234f0033edaebf3f7dab4ceca
finger@linux-gskd:~/wireless-testing> sudo iwconfig wlan4
wlan4     IEEE 802.11bg  ESSID:"radius"  Nickname:"rtl_wifi"
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:14:BF:85:49:FA   
          Bit Rate:54 Mb/s   Sensitivity:0/0  
          Retry:off   RTS thr:off   Fragment thr:off
          Encryption key:1234-F003-3EDA-EBF3-F7DA-B4CE-CA   Security mode:restricted
          Power Management:off
          Link Quality=100/100  Signal level=100/100  Noise level=0/100
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

finger@linux-gskd:~/wireless-testing> sudo ifconfig wlan4 up
finger@linux-gskd:~/wireless-testing> ifconfig
eth0      Link encap:Ethernet  HWaddr 40:61:86:FC:43:BA  
          inet addr:192.168.3.101  Bcast:192.168.3.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:102 errors:0 dropped:0 overruns:0 frame:0
          TX packets:117 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:60128 (58.7 Kb)  TX bytes:14665 (14.3 Kb)
          Interrupt:43 Base address:0xa000 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:56 errors:0 dropped:0 overruns:0 frame:0
          TX packets:56 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:2880 (2.8 Kb)  TX bytes:2880 (2.8 Kb)

wlan4     Link encap:Ethernet  HWaddr 00:26:5A:BF:41:E4  
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:37 errors:0 dropped:8 overruns:0 frame:0
          TX packets:27 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:12007 (11.7 Kb)  TX bytes:6195 (6.0 Kb)



--------------080308070404040309070803--
