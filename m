Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35525 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcHGLlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Aug 2016 07:41:07 -0400
Received: by mail-wm0-f50.google.com with SMTP id f65so80287278wmi.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Aug 2016 04:41:06 -0700 (PDT)
Subject: Re: TCP data throughput for BCM43362
To: =?UTF-8?Q?J=c3=b6rg_Krause?= <joerg.krause@embedded.rocks>,
	Franky Lin <franky.lin@broadcom.com>
References: <1470429980.29489.10.camel@embedded.rocks>
 <CAF7Mx6o+WuQqtzuApMWQ8YAkLSX7xQ_H06xmO--RxFdwHwzLdQ@mail.gmail.com>
 <1BCE83A1-AA47-438D-BC47-05AE53D40121@embedded.rocks>
 <CA+8PC_f7VQMwBfQmZZ_vUtYtNJKVYzmFmxziAwoG8-iRUeW9Jw@mail.gmail.com>
 <1470492734.2120.0.camel@embedded.rocks>
Cc: Brett Rudley <brudley@broadcom.com>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6cdbbae7-8a56-6778-e886-68eeea7add15@broadcom.com> (sfid-20160807_134113_491622_5794AF5C)
Date: Sun, 7 Aug 2016 13:41:04 +0200
MIME-Version: 1.0
In-Reply-To: <1470492734.2120.0.camel@embedded.rocks>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06-08-16 16:12, Jörg Krause wrote:
> Hi all,

A bit weird email format making it a bit hard to determine where your
last reply starts...

> On Fr, 2016-08-05 at 17:56 -0700, Franky Lin wrote:
> 
> On Fri, Aug 5, 2016 at 2:29 PM, Jörg Krause <joerg.krause@embedded.ro
> cks>
> wrote:
> 
> 
> 
> 
> 
> Am 5. August 2016 23:01:10 MESZ, schrieb Arend Van Spriel <
> arend.vanspriel@broadcom.com>:
> 
> 
> Op 5 aug. 2016 22:46 schreef "Jörg Krause"
> <joerg.krause@embedded.rocks>:
> 
> 
> 
> Hi,
> 
> I'm using a custom ARM board with an BCM43362 wifi chip from
> 
> Broadcom.
> 
> 
> The wifi chip is attached via SDIO to the controller with a
> clock of
> 48MHz. Linux kernel version is 4.7.
> 
> When measuring the network bandwidth with iperf3 I get a
> bandwith of
> only around 5 Mbps. I found a similar thread at the Broadcom
> 
> community
> 
> 
> [1] where the test was done with a M4 CPU + BCM43362 and an
> average
> result of 3.3 Mbps.
> 
> Interestingly, a BCM43362 Wi-Fi Dev Kit [2] notes a TCP data
> 
> throughput
> 
> 
> greater than 20 Mbps.
> 
> Why is the throughput I measured much lower? Note that I
> measured
> several times with almost no neighbor devices or networks.
> 
> This is a test sample measured with iperf3:
> 
>     $ iperf3 -c 192.168.2.1 -i 1 -t 10
>     Connecting to host 192.168.2.1, port 5201
>     [  4] local 192.168.2.155 port 36442 connected to
> 192.168.2.1
> 
> port
> 
> 
>     5201
>     [ ID]
> Interval           Transfer     Bandwidth       Retr  Cwnd
>     [  4]   0.00-1.00   sec   615 KBytes  5.04
> Mbits/sec    0   56.6
>     KBytes
>     [  4]   1.00-2.00   sec   622 KBytes  5.10
> Mbits/sec    0   84.8
>     KBytes
>     [  4]   2.00-3.00   sec   625 KBytes  5.12
> Mbits/sec    0    113
>     KBytes
>     [  4]   3.00-4.00   sec   571 KBytes  4.68
> Mbits/sec    0    140
>     KBytes
>     [  4]   4.00-5.00   sec   594 KBytes  4.87
> Mbits/sec    0    167
>     KBytes
>     [  4]   5.00-6.00   sec   628 KBytes  5.14
> Mbits/sec    0    195
>     KBytes
>     [  4]   6.00-7.00   sec   619 KBytes  5.07
> Mbits/sec    0    202
>     KBytes
>     [  4]   7.00-8.00   sec   608 KBytes  4.98
> Mbits/sec    0    202
>     KBytes
>     [  4]   8.00-9.00   sec   602 KBytes  4.93
> Mbits/sec    0    202
>     KBytes
>     [  4]   9.00-10.00  sec   537 KBytes  4.40
> Mbits/sec    0    202
>     KBytes
>     - - - - - - - - - - - - - - - - - - - - - - - - -
>     [ ID] Interval           Transfer     Bandwidth       Retr
>     [  4]   0.00-10.00  sec  5.88 MBytes  4.93
>     Mbits/sec    0             sender
>     [  4]   0.00-10.00  sec  5.68 MBytes  4.76
>     Mbits/sec                  receiver
> 
> 
> Not overly familiar with iperf3. Do these lines mean you are
> doing
> bidirectional test, ie. upstream and downstream at the same time.
> Another
> thing affecting tput could be power-save.
> 
> 
> No, iperf3 does not support bidrectional test. Power-save is turned
> off.
> 
> What does iw link say?
> 

but I guess it starts here!

> I compared the results with a Cubietruck I have:
> 
> # iperf3 -s
> -----------------------------------------------------------
> Server listening on 5201
> -----------------------------------------------------------
> Accepted connection from 192.168.178.46, port 42906
> [  5] local 192.168.178.38 port 5201 connected to 192.168.178.46 port
> 42908
> [ ID] Interval           Transfer     Bandwidth
> [  5]   0.00-1.00   sec  2.29 MBytes  19.2 Mbits/sec                  
> [  5]   1.00-2.00   sec  2.21 MBytes  18.5 Mbits/sec                  
> [  5]   2.00-3.00   sec  2.17 MBytes  18.2 Mbits/sec                  
> [  5]   3.00-4.00   sec  2.09 MBytes  17.6 Mbits/sec                  
> [  5]   4.00-5.00   sec  2.20 MBytes  18.5 Mbits/sec                  
> [  5]   5.00-6.00   sec  2.64 MBytes  22.1 Mbits/sec                  
> [  5]   6.00-7.00   sec  2.67 MBytes  22.4 Mbits/sec                  
> [  5]   7.00-8.00   sec  2.62 MBytes  22.0 Mbits/sec                  
> [  5]   8.00-9.00   sec  2.35 MBytes  19.8 Mbits/sec                  
> [  5]   9.00-10.00  sec  2.30 MBytes  19.3 Mbits/sec                  
> [  5]  10.00-10.03  sec  83.4 KBytes  23.5 Mbits/sec                  
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  5]   0.00-10.03  sec  23.9 MBytes  20.0
> Mbits/sec    0             sender
> [  5]   0.00-10.03  sec  23.6 MBytes  19.8
> Mbits/sec                  receiver
> 
> # iw dev wlan0 link
> Connected to xx:xx:xx:xx:xx (on wlan0)
> 	SSID: xxx
> 	freq: 2437
> 	tx bitrate: 65.0 MBit/s
> 
> 	bss flags:	short-preamble short-slot-time
> 	dtim period:	1
> 	beacon int:	100

Too bad RSSI is not in the output above. That may be due to a regression
in our driver which has been fixed by commit 94abd778a7bb ("brcmfmac:
add fallback for devices that do not report per-chain values"). However,
the tx bitrate seems within the same range as the other platform.

> The Cubietruck works also with the brcmfmac driver.
> 
> May it depend on the NVRAM file?

Not sure. Can you tell me a bit more about the custom ARM board. Does it
use the same wifi module as Cubietruck, ie. the AMPAK AP6210? If you can
make a wireshark sniff we can check the actual bitrate and medium
density in terms of packets. Another thing to look at is the SDIO host
controller. In brcmf_sdiod_sgtable_alloc() some key values are used from
the host controller. It only logs the number of entries of the
scatter-gather table, but could you add the other values in this
function that are used to determine the number of entries.

Regards,
Arend
