Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.142]:50701 "EHLO mout02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427543AbcHEV3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 17:29:50 -0400
In-Reply-To: <CAF7Mx6o+WuQqtzuApMWQ8YAkLSX7xQ_H06xmO--RxFdwHwzLdQ@mail.gmail.com>
References: <1470429980.29489.10.camel@embedded.rocks> <CAF7Mx6o+WuQqtzuApMWQ8YAkLSX7xQ_H06xmO--RxFdwHwzLdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: TCP data throughput for BCM43362
From: =?ISO-8859-1?Q?J=F6rg_Krause?= <joerg.krause@embedded.rocks>
Date: Fri, 05 Aug 2016 23:29:34 +0200
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
CC: Brett Rudley <brudley@broadcom.com>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>
Message-ID: <1BCE83A1-AA47-438D-BC47-05AE53D40121@embedded.rocks> (sfid-20160805_233001_311108_0A9DD761)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 5. August 2016 23:01:10 MESZ, schrieb Arend Van Spriel <arend.vanspriel@broadcom.com>:
>Op 5 aug. 2016 22:46 schreef "Jörg Krause"
><joerg.krause@embedded.rocks>:
>>
>> Hi,
>>
>> I'm using a custom ARM board with an BCM43362 wifi chip from
>Broadcom.
>> The wifi chip is attached via SDIO to the controller with a clock of
>> 48MHz. Linux kernel version is 4.7.
>>
>> When measuring the network bandwidth with iperf3 I get a bandwith of
>> only around 5 Mbps. I found a similar thread at the Broadcom
>community
>> [1] where the test was done with a M4 CPU + BCM43362 and an average
>> result of 3.3 Mbps.
>>
>> Interestingly, a BCM43362 Wi-Fi Dev Kit [2] notes a TCP data
>throughput
>> greater than 20 Mbps.
>>
>> Why is the throughput I measured much lower? Note that I measured
>> several times with almost no neighbor devices or networks.
>>
>> This is a test sample measured with iperf3:
>>
>>     $ iperf3 -c 192.168.2.1 -i 1 -t 10
>>     Connecting to host 192.168.2.1, port 5201
>>     [  4] local 192.168.2.155 port 36442 connected to 192.168.2.1
>port
>>     5201
>>     [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
>>     [  4]   0.00-1.00   sec   615 KBytes  5.04 Mbits/sec    0   56.6
>>     KBytes
>>     [  4]   1.00-2.00   sec   622 KBytes  5.10 Mbits/sec    0   84.8
>>     KBytes
>>     [  4]   2.00-3.00   sec   625 KBytes  5.12 Mbits/sec    0    113
>>     KBytes
>>     [  4]   3.00-4.00   sec   571 KBytes  4.68 Mbits/sec    0    140
>>     KBytes
>>     [  4]   4.00-5.00   sec   594 KBytes  4.87 Mbits/sec    0    167
>>     KBytes
>>     [  4]   5.00-6.00   sec   628 KBytes  5.14 Mbits/sec    0    195
>>     KBytes
>>     [  4]   6.00-7.00   sec   619 KBytes  5.07 Mbits/sec    0    202
>>     KBytes
>>     [  4]   7.00-8.00   sec   608 KBytes  4.98 Mbits/sec    0    202
>>     KBytes
>>     [  4]   8.00-9.00   sec   602 KBytes  4.93 Mbits/sec    0    202
>>     KBytes
>>     [  4]   9.00-10.00  sec   537 KBytes  4.40 Mbits/sec    0    202
>>     KBytes
>>     - - - - - - - - - - - - - - - - - - - - - - - - -
>>     [ ID] Interval           Transfer     Bandwidth       Retr
>>     [  4]   0.00-10.00  sec  5.88 MBytes  4.93
>>     Mbits/sec    0             sender
>>     [  4]   0.00-10.00  sec  5.68 MBytes  4.76
>>     Mbits/sec                  receiver
>
>Not overly familiar with iperf3. Do these lines mean you are doing
>bidirectional test, ie. upstream and downstream at the same time.
>Another
>thing affecting tput could be power-save.

No, iperf3 does not support bidrectional test. Power-save is turned off.

