Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55077 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaAOHbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 02:31:04 -0500
Received: by mail-pb0-f50.google.com with SMTP id rq2so769110pbb.23
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 23:31:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABkW7JP=cq4H+iRRLfHzChHHCrX5+pxEwQv7vpdXLTwXGY-qeg@mail.gmail.com>
References: <CABkW7JP=cq4H+iRRLfHzChHHCrX5+pxEwQv7vpdXLTwXGY-qeg@mail.gmail.com>
From: camden lindsay <camden.lindsay@gmail.com>
Date: Tue, 14 Jan 2014 23:30:44 -0800
Message-ID: <CABkW7JPzadqZhDdf6aUwOxYK17dSWDZEeZ8uRzcxz2dVZop+7w@mail.gmail.com> (sfid-20140115_083108_990602_9614B890)
Subject: Re: iwlwifi + 6235 power management issues
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw <ilw@linux.inel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resend and plain-text to avoid being marked as spam by vger.kernel.org

I am a novice at this, so apologies in advance for anything I am overlooking.

The environment is as follows:
Network Card:
[dylan@zenbook linux]$ lspci | grep -i net
02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6235 (rev 24)


Kernel:
[dylan@zenbook ~]$ uname -a
Linux zenbook 3.12.7-1-iwlwifidebug #1 SMP PREEMPT Sun Jan 12 12:26:28
PST 2014 x86_64 GNU/Linux



iwconfig
[dylan@zenbook linux]$ iwconfig -v
iwconfig  Wireless-Tools version 29
          Compatible with Wireless Extension v11 to v22.

Kernel    Currently compiled with Wireless Extension v22.

wlan0     Recommend Wireless Extension v21 or later,
          Currently compiled with Wireless Extension v22.



When power management is off, everything seems ok:
[dylan@zenbook ~]$ sudo iwconfig wlan0 | grep Management
          Power Management:off
[dylan@zenbook ~]$ ping -c 10 192.168.11.253
PING 192.168.11.253 (192.168.11.253) 56(84) bytes of data.
64 bytes from 192.168.11.253: icmp_seq=1 ttl=64 time=1.56 ms
64 bytes from 192.168.11.253: icmp_seq=2 ttl=64 time=1.84 ms
64 bytes from 192.168.11.253: icmp_seq=3 ttl=64 time=1.43 ms
64 bytes from 192.168.11.253: icmp_seq=4 ttl=64 time=2.52 ms
64 bytes from 192.168.11.253: icmp_seq=5 ttl=64 time=1.44 ms
64 bytes from 192.168.11.253: icmp_seq=6 ttl=64 time=1.40 ms
64 bytes from 192.168.11.253: icmp_seq=7 ttl=64 time=2.28 ms
64 bytes from 192.168.11.253: icmp_seq=8 ttl=64 time=1.90 ms
64 bytes from 192.168.11.253: icmp_seq=9 ttl=64 time=1.77 ms
64 bytes from 192.168.11.253: icmp_seq=10 ttl=64 time=2.00 ms

--- 192.168.11.253 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9015ms
rtt min/avg/max/mdev = 1.402/1.818/2.528/0.362 ms



Howerver, when power save is turned on, the ping response latency goes
through the roof:
[dylan@zenbook ~]$ sudo iwconfig wlan0 power on
[dylan@zenbook ~]$ sudo iwconfig wlan0 | grep Management
          Power Management:on
[dylan@zenbook ~]$

[dylan@zenbook ~]$ ping -c 10 192.168.11.253
PING 192.168.11.253 (192.168.11.253) 56(84) bytes of data.
64 bytes from 192.168.11.253: icmp_seq=1 ttl=64 time=53.9 ms
64 bytes from 192.168.11.253: icmp_seq=2 ttl=64 time=903 ms
64 bytes from 192.168.11.253: icmp_seq=3 ttl=64 time=1133 ms
64 bytes from 192.168.11.253: icmp_seq=4 ttl=64 time=138 ms
64 bytes from 192.168.11.253: icmp_seq=5 ttl=64 time=463 ms
64 bytes from 192.168.11.253: icmp_seq=6 ttl=64 time=794 ms
64 bytes from 192.168.11.253: icmp_seq=7 ttl=64 time=1023 ms
64 bytes from 192.168.11.253: icmp_seq=8 ttl=64 time=14.6 ms
64 bytes from 192.168.11.253: icmp_seq=9 ttl=64 time=139 ms
64 bytes from 192.168.11.253: icmp_seq=10 ttl=64 time=269 ms

--- 192.168.11.253 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9014ms
rtt min/avg/max/mdev = 14.611/493.544/1133.541/409.156 ms, pipe 2
[dylan@zenbook ~]$



Disabling power save brings us back to the original state:
[dylan@zenbook ~]$ sudo iwconfig wlan0 power off
[dylan@zenbook ~]$ sudo iwconfig wlan0 | grep Management
          Power Management:off
[dylan@zenbook ~]$ ping -c 10 192.168.11.253
PING 192.168.11.253 (192.168.11.253) 56(84) bytes of data.
64 bytes from 192.168.11.253: icmp_seq=1 ttl=64 time=3.43 ms
64 bytes from 192.168.11.253: icmp_seq=2 ttl=64 time=2.31 ms
64 bytes from 192.168.11.253: icmp_seq=3 ttl=64 time=1.43 ms
64 bytes from 192.168.11.253: icmp_seq=4 ttl=64 time=1.46 ms
64 bytes from 192.168.11.253: icmp_seq=5 ttl=64 time=1.43 ms
64 bytes from 192.168.11.253: icmp_seq=6 ttl=64 time=2.40 ms
64 bytes from 192.168.11.253: icmp_seq=7 ttl=64 time=9.43 ms
64 bytes from 192.168.11.253: icmp_seq=8 ttl=64 time=1.41 ms
64 bytes from 192.168.11.253: icmp_seq=9 ttl=64 time=1.38 ms
64 bytes from 192.168.11.253: icmp_seq=10 ttl=64 time=1.81 ms

--- 192.168.11.253 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9014ms
rtt min/avg/max/mdev = 1.387/2.654/9.439/2.346 ms
[dylan@zenbook ~]$


I have debugfs enabled for 802.11 as well as iwlwifi.
If there is any information I can provide to help find the issue, I
would be happy to help.

take care
Camden
