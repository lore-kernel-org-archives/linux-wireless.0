Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:28657 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZESRsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 13:48:31 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2481852ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 10:48:32 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 May 2009 01:48:32 +0800
Message-ID: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
Subject: Throughput is not changed when setting to a much higher bit rate
From: Dongas <dongas86@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi ALL,

I'm doing the performance profiling of our WiFi module with iperf.
The module is based on Marvell 8686 chipset with Libertas driver.

A strange issue i encounterred is that even i changed to a higher bit
rate ,the result of iperf seems that the bandwidth/troughput is still
not changed.

Details are as follows:
1. First test with default Bit Rate -1Mb/s
# iwconfig
eth1      IEEE 802.11b/g  ESSID:"dlink"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:24:01:25:18:8A
          Bit Rate:1 Mb/s   Tx-Power=13 dBm
          Retry limit:8   RTS thr=2347 B   Fragment thr=2346 B
          Encryption key:off
          Power Management:off
          Link Quality=100/100  Signal level=-22 dBm  Noise level=-93 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:125310
          Tx excessive retries:1120  Invalid misc:2988   Missed beacon:0
#

# iperf -c 172.31.42.51 -i 5 -t 60
------------------------------------------------------------
Client connecting to 172.31.42.51, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 172.31.42.218 port 33228 connected with 172.31.42.51 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec    792 KBytes  1.30 Mbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  5.0-10.0 sec    680 KBytes  1.11 Mbits/sec
……

The bandwidth tested out with iperf is around 1.1Mb/s.

2.  Change to a higner Bit Rate (11Mb/s) and re-test
# iwconfig eth1 rate 11M fixed
# iwconfig
eth1      IEEE 802.11b/g  ESSID:"dlink"
          Mode:Managed  Frequency:2.437 GHz  Access Point: 00:24:01:25:18:8A
          Bit Rate=11 Mb/s   Tx-Power=13 dBm
          Retry limit:8   RTS thr=2347 B   Fragment thr=2346 B
          Encryption key:off
          Power Management:off
          Link Quality=100/100  Signal level=-22 dBm  Noise level=-94 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:125610
          Tx excessive retries:1120  Invalid misc:2988   Missed beacon:0

# iperf -c 172.31.42.51 -i 5 -t 60
------------------------------------------------------------
Client connecting to 172.31.42.51, TCP port 5001
TCP window size: 16.0 KByte (default)
------------------------------------------------------------
[  3] local 172.31.42.218 port 33229 connected with 172.31.42.51 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec    776 KBytes  1.27 Mbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3]  5.0-10.0 sec    720 KBytes  1.18 Mbits/sec
[ ID] Interval       Transfer     Bandwidth
[  3] 10.0-15.0 sec    680 KBytes  1.11 Mbits/sec

The bandwidth tested out with iperf is still around 1.1Mb/s.

Why the bandwidth is not changed when bit rate is changed to 11Mb/s?
Any thing wrong?

Thanks

Regards
Dongas
