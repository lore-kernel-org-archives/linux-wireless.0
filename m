Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42922 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965890Ab2FAWwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 18:52:49 -0400
Received: by yhmm54 with SMTP id m54so2078630yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2012 15:52:49 -0700 (PDT)
Message-ID: <4FC947BD.50701@lwfinger.net> (sfid-20120602_005253_882137_AF8E45A1)
Date: Fri, 01 Jun 2012 17:52:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jacopo Runchi <jacoporunchi@hotmail.it>
CC: linux-wireless@vger.kernel.org
Subject: Re: I: RTL8187 driver in linux 3.4
References: <!&!AAAAAAAAAAAuAAAAAAAAAH2SKMTPZA1PmAOs8RWvl9YBANlTnCJhprtFudq2LHCBs8EBACQA//8AABAAAACIF7qVX5kVSJrDEtYsG/e+AQAAAAA=@hotmail.it> <DUB107-ds5BA2D5341A3C373209B17A0080@phx.gbl>,<4FC8E733.6030905@lwfinger.net> <DUB107-W18A171E5A851D8D798C403A0080@phx.gbl>
In-Reply-To: <DUB107-W18A171E5A851D8D798C403A0080@phx.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2012 04:36 PM, Jacopo Runchi wrote:
> Hi, i'm using Openwrt on the device, so lsusb is not available.
> The USB device used is an ALFA NETWORK AWUS036H.
> In the last try i set the rate fixed, but the iwlist command says "unknown bitrate".
>
> So, I'm unable to verify that the rate has been successfully set.
> In fact also setting the rate fixed to 1M it doesn't works anymore.
> The behaviour seems to be the same as this post:
> http://www.gossamer-threads.com/lists/linux/kernel/860544 .
>
> I found some infos on what is the pid rate control algorithm, but I didn't
> understand how to set it or how to verify how is it set.
> Do I have to recompile the kernel to do it?

The AWUS036H is an RTL8187L. You don't need to send me the lsusb output.

Yes, to enable PID, you will need to reconfigure and recompile the kernel.

I have an AWUS036H, and got the following:

finger@linux-y7cb:~/wireless-testing> iwconfig
wlan0     IEEE 802.11bg  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=36 Mb/s   Tx-Power=0 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-26 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:22   Missed beacon:0

finger@linux-y7cb:~/wireless-testing> sudo iwconfig wlan0 rate 1M
finger@linux-y7cb:~/wireless-testing> iwconfig
wlan0     IEEE 802.11bg  ESSID:"lwfdjf-n"
           Mode:Managed  Frequency:2.422 GHz  Access Point: C0:3F:0E:BE:2B:44
           Bit Rate=1 Mb/s   Tx-Power=0 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:off
           Link Quality=70/70  Signal level=-30 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:29   Missed beacon:0

finger@linux-y7cb:~/wireless-testing> ping -c5 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=4.34 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=3.24 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=2.61 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=64 time=3.14 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=64 time=2.36 ms

--- 192.168.1.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 2.368/3.144/4.348/0.684 ms


By removing the antenna, I could reduce the signal strength reported by iwconfig 
to -63 dBm, and still connect and ping with the tayr set at 1 Mbps.

wlan0     IEEE 802.11bg  ESSID:"Larry_wpa1"
           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:1A:70:46:BA:B1
           Bit Rate=1 Mb/s   Tx-Power=0 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:off
           Link Quality=47/70  Signal level=-63 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:117   Missed beacon:0

finger@linux-y7cb:~/wireless-testing> ping -c5 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=63 time=4.35 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=63 time=3.73 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=63 time=3.73 ms
64 bytes from 192.168.1.1: icmp_seq=4 ttl=63 time=3.88 ms
64 bytes from 192.168.1.1: icmp_seq=5 ttl=63 time=6.87 ms

When I reset the rate to "auto", the driver set it to 54M, and it would not 
communicate.

Larry
