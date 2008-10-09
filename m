Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sr04-03.mta.terra.com.br ([200.154.152.52]:42604 "EHLO
	sr04-03.mta.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbYJINJu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 09:09:50 -0400
Message-ID: <48EE02B9.4060108@terra.com.br> (sfid-20081009_150955_234652_1BE712DF)
Date: Thu, 09 Oct 2008 10:10:17 -0300
From: Piter PUNK <piterpk@terra.com.br>
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8187B transmit problems
References: <48E979B7.4040000@terra.com.br> <20081008195740.GA2794@srcf.ucam.org>
In-Reply-To: <20081008195740.GA2794@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Garrett wrote:
> Try reducing the bit rate - iwconfig wlan0 11M fixed, for example.
> 

Hi,

I try that. This time i got my problem #3:

---from first mail---
3) I associate, can transmit but only "small" transmissions. Ping,
    HTTP GET, POP commands... when i try to upload a file, send a
    mail, etc... the connection stuck.
---------------------

I associate:

---
wmaster0  no wireless extensions.

wlan0     IEEE 802.11bg  ESSID:"MyLab"
           Mode:Managed  Frequency:2.437 GHz  Access Point: 
00:1D:0F:FB:B4:52
           Bit Rate=11 Mb/s   Tx-Power=27 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
           Encryption key:XXXX-XXXX-XX   Security mode:open
           Power Management:off
           Link Quality=100/100  Signal level:-5 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
---

I can ping

---
root@cameron:~# ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=32.9 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=136 ms
64 bytes from 192.168.0.1: icmp_seq=3 ttl=64 time=1.69 ms
64 bytes from 192.168.0.1: icmp_seq=4 ttl=64 time=2.25 ms
64 bytes from 192.168.0.1: icmp_seq=5 ttl=64 time=55.0 ms
^C
--- 192.168.0.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4016ms
rtt min/avg/max/mdev = 1.692/45.795/136.994/49.817 ms
---

But i can't transmit anything bigger. Trying to send an mail
or an 448K tarball through scp didn't work (but ssh session
works). Using rt73 USB dongle works fine (i sent the tarball
and i will send this mail).

Hope this test can help.

Thanks!

Piter PUNK
-- 
     |        E-Mail: piterpk@terra.com.br        (personal)
    .|.
    /V\
   // \\      UIN:116043354  Homepage:http://piterpunk.info02.com.br
  /(   )\
   ^`~'^
  #105432
