Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:39104 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHaFjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2014 01:39:42 -0400
Received: by mail-we0-f170.google.com with SMTP id p10so3930452wes.15
        for <linux-wireless@vger.kernel.org>; Sat, 30 Aug 2014 22:39:40 -0700 (PDT)
Message-ID: <5402B519.1080002@gmail.com> (sfid-20140831_073957_125047_B281D390)
Date: Sun, 31 Aug 2014 07:39:37 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] MediaTek Inc. MT7601U Wireless Adapter
References: <53FCC55B.90705@gmail.com> <20140826182849.GE30445@tuxdriver.com> <53FD7BFA.1040304@maya.org> <20140827135550.GD15173@tuxdriver.com> <53FE9920.2040702@gmail.com>
In-Reply-To: <53FE9920.2040702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new patch[1] mainly based on patches at 
https://github.com/ashaffer/rt3573sta
and several network throughput tests via the Iperf.
Tested with kernels:
- 3.15.10-200.fc20.x86_64
- 3.16.1-301.fc21.x86_64
- 3.17.0-0.rc2.git3.1.fc22.x86_64
- 3.16.1-301.fc21.i686
- 3.17.0-0.rc2.git3.1.fc22.i686

<Proximity>
Wi-Fi <~20cm LOS~> AP(Wi-Fi <-bridge-> 100Mbit switch) <-> Ethernet

<AP>
# iwconfig ra0
ra0       RTWIFI SoftAP  ESSID:"Geppetto"  
          Mode:Managed  Channel=13  Access Point: 00:22:44:66:88:aa   
          Bit Rate=150 Mb/s   
</AP>
          
<Wi-Fi>
$ iwconfig ra0 
ra0       Ralink STA  ESSID:"Geppetto"  Nickname:"MT7601STA"
          Mode:Managed  Frequency=2.472 GHz  Access Point: 00:22:44:66:88:aa   
          Bit Rate=150 Mb/s   
          RTS thr:off   Fragment thr:off
          Link Quality=100/100  Signal level:-22 dBm  Noise level:-53 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
</Wi-Fi>

<Ethernet>
$ ifconfig bridge0
bridge0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.2.2  netmask 255.255.255.0  broadcast 192.168.2.255
        ether 00:12:34:56:78:90  txqueuelen 0  (Ethernet)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
</Ethernet>

<Ethernet-TCP>
$ iperf -s -i 1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.2 port 5001 connected with 192.168.2.36 port 58536
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  10.6 MBytes  88.9 Mbits/sec
[  4]  1.0- 2.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  2.0- 3.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  3.0- 4.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  4.0- 5.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  5.0- 6.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  6.0- 7.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  7.0- 8.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  8.0- 9.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  9.0-10.0 sec  11.2 MBytes  94.1 Mbits/sec
[  4]  0.0-10.1 sec   113 MBytes  93.6 Mbits/sec
</Ethernet-TCP>
 >
<Wi-Fi-TCP>
$ iperf -c 192.168.2.2 -i 1
------------------------------------------------------------
Client connecting to 192.168.2.2, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.36 port 58536 connected with 192.168.2.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  11.1 MBytes  93.3 Mbits/sec
[  3]  1.0- 2.0 sec  11.8 MBytes  98.6 Mbits/sec
[  3]  2.0- 3.0 sec  11.4 MBytes  95.4 Mbits/sec
[  3]  3.0- 4.0 sec  11.0 MBytes  92.3 Mbits/sec
[  3]  4.0- 5.0 sec  11.5 MBytes  96.5 Mbits/sec
[  3]  5.0- 6.0 sec  11.1 MBytes  93.3 Mbits/sec
[  3]  6.0- 7.0 sec  11.2 MBytes  94.4 Mbits/sec
[  3]  7.0- 8.0 sec  11.1 MBytes  93.3 Mbits/sec
[  3]  8.0- 9.0 sec  11.5 MBytes  96.5 Mbits/sec
[  3]  9.0-10.0 sec  11.0 MBytes  92.3 Mbits/sec
[  3]  0.0-10.0 sec   113 MBytes  94.4 Mbits/sec
</Wi-Fi-TCP>

<Ethernet-UDP>
$ iperf -s -i 1 -u
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.2 port 5001 connected with 192.168.2.36 port 48479
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  3]  0.0- 1.0 sec  11.4 MBytes  95.3 Mbits/sec   0.119 ms    0/ 8105 (0%)
[  3]  1.0- 2.0 sec  11.4 MBytes  95.7 Mbits/sec   0.081 ms  480/ 8617 (5.6%)
[  3]  2.0- 3.0 sec  11.4 MBytes  95.7 Mbits/sec   0.098 ms 1200/ 9338 (13%)
[  3]  3.0- 4.0 sec  11.4 MBytes  95.7 Mbits/sec   0.078 ms 1502/ 9640 (16%)
[  3]  4.0- 5.0 sec  11.4 MBytes  95.7 Mbits/sec   0.121 ms 1459/ 9596 (15%)
[  3]  5.0- 6.0 sec  11.4 MBytes  95.7 Mbits/sec   0.084 ms 1488/ 9626 (15%)
[  3]  6.0- 7.0 sec  11.4 MBytes  95.7 Mbits/sec   0.142 ms 1513/ 9651 (16%)
[  3]  7.0- 8.0 sec  11.4 MBytes  95.7 Mbits/sec   0.100 ms 1470/ 9608 (15%)
[  3]  8.0- 9.0 sec  11.4 MBytes  95.7 Mbits/sec   0.095 ms 1526/ 9664 (16%)
[  3]  9.0-10.0 sec  11.4 MBytes  95.7 Mbits/sec   0.076 ms 1415/ 9553 (15%)
[  3]  0.0-10.2 sec   116 MBytes  95.7 Mbits/sec   0.559 ms 12254/94926 (13%)
[  3]  0.0-10.2 sec  1 datagrams received out-of-order
</Ethernet-UDP>
 >
<Wi-Fi-UDP>
$ iperf -c 192.168.2.2 -i 1 -u -b 300M
------------------------------------------------------------
Client connecting to 192.168.2.2, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.36 port 48479 connected with 192.168.2.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  12.4 MBytes   104 Mbits/sec
[  3]  1.0- 2.0 sec  13.2 MBytes   110 Mbits/sec
[  3]  2.0- 3.0 sec  13.2 MBytes   111 Mbits/sec
[  3]  3.0- 4.0 sec  13.6 MBytes   114 Mbits/sec
[  3]  4.0- 5.0 sec  13.5 MBytes   113 Mbits/sec
[  3]  5.0- 6.0 sec  13.4 MBytes   113 Mbits/sec
[  3]  6.0- 7.0 sec  13.5 MBytes   113 Mbits/sec
[  3]  7.0- 8.0 sec  13.6 MBytes   114 Mbits/sec
[  3]  8.0- 9.0 sec  13.5 MBytes   113 Mbits/sec
[  3]  0.0-10.0 sec   133 MBytes   112 Mbits/sec
[  3] Sent 94927 datagrams
[  3] Server Report:
[  3]  0.0-10.2 sec   116 MBytes  95.7 Mbits/sec   0.559 ms 12254/94926 (13%)
[  3]  0.0-10.2 sec  1 datagrams received out-of-order
</Wi-Fi-UDP>

<Wi-Fi-TCP>
$ iperf -s -i 1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.36 port 5001 connected with 192.168.2.2 port 50371
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  10.2 MBytes  85.4 Mbits/sec
[  4]  1.0- 2.0 sec  9.66 MBytes  81.0 Mbits/sec
[  4]  2.0- 3.0 sec  9.53 MBytes  79.9 Mbits/sec
[  4]  3.0- 4.0 sec  9.28 MBytes  77.8 Mbits/sec
[  4]  4.0- 5.0 sec  8.94 MBytes  75.0 Mbits/sec
[  4]  5.0- 6.0 sec  8.60 MBytes  72.2 Mbits/sec
[  4]  6.0- 7.0 sec  8.24 MBytes  69.1 Mbits/sec
[  4]  7.0- 8.0 sec  8.19 MBytes  68.7 Mbits/sec
[  4]  8.0- 9.0 sec  7.77 MBytes  65.2 Mbits/sec
[  4]  9.0-10.0 sec  7.64 MBytes  64.1 Mbits/sec
[  4]  0.0-10.2 sec  89.2 MBytes  73.6 Mbits/sec
</Wi-Fi-TCP>
 >
<Ethernet-TCP>
$ iperf -c 192.168.2.36 -i 1
------------------------------------------------------------
Client connecting to 192.168.2.36, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.2 port 50371 connected with 192.168.2.36 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  10.9 MBytes  91.2 Mbits/sec
[  3]  1.0- 2.0 sec  10.2 MBytes  86.0 Mbits/sec
[  3]  2.0- 3.0 sec  9.50 MBytes  79.7 Mbits/sec
[  3]  3.0- 4.0 sec  9.12 MBytes  76.5 Mbits/sec
[  3]  4.0- 5.0 sec  9.12 MBytes  76.5 Mbits/sec
[  3]  5.0- 6.0 sec  8.38 MBytes  70.3 Mbits/sec
[  3]  6.0- 7.0 sec  8.25 MBytes  69.2 Mbits/sec
[  3]  7.0- 8.0 sec  8.12 MBytes  68.2 Mbits/sec
[  3]  8.0- 9.0 sec  7.75 MBytes  65.0 Mbits/sec
[  3]  9.0-10.0 sec  7.75 MBytes  65.0 Mbits/sec
[  3]  0.0-10.0 sec  89.2 MBytes  74.7 Mbits/sec
</Ethernet-TCP>

<Wi-Fi-UDP>
$ iperf -s -i 1 -u
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.36 port 5001 connected with 192.168.2.2 port 55274
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  3]  0.0- 1.0 sec  10.5 MBytes  88.3 Mbits/sec   0.251 ms    1/ 7513 (0.013%)
[  3]  1.0- 2.0 sec  11.1 MBytes  93.0 Mbits/sec   0.276 ms  240/ 8149 (2.9%)
[  3]  2.0- 3.0 sec  10.8 MBytes  90.5 Mbits/sec   0.340 ms  400/ 8099 (4.9%)
[  3]  3.0- 4.0 sec  11.0 MBytes  92.1 Mbits/sec   0.127 ms  267/ 8101 (3.3%)
[  3]  4.0- 5.0 sec  10.6 MBytes  89.1 Mbits/sec   0.230 ms  524/ 8104 (6.5%)
[  3]  5.0- 6.0 sec  10.5 MBytes  88.3 Mbits/sec   0.141 ms  636/ 8145 (7.8%)
[  3]  6.0- 7.0 sec  10.4 MBytes  87.4 Mbits/sec   0.126 ms  639/ 8071 (7.9%)
[  3]  7.0- 8.0 sec  10.6 MBytes  89.2 Mbits/sec   0.163 ms  621/ 8207 (7.6%)
[  3]  8.0- 9.0 sec  10.5 MBytes  88.2 Mbits/sec   0.141 ms  537/ 8035 (6.7%)
[  3]  9.0-10.0 sec  10.3 MBytes  86.8 Mbits/sec   0.206 ms  765/ 8145 (9.4%)
[  3]  0.0-10.1 sec   107 MBytes  89.3 Mbits/sec   0.445 ms 4699/81305 (5.8%)
[  3]  0.0-10.1 sec  1 datagrams received out-of-order
</Wi-Fi-UDP>
 >
<Ethernet-UDP>
$ iperf -c 192.168.2.36 -i 1 -u -b 300M
------------------------------------------------------------
Client connecting to 192.168.2.36, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.2 port 55274 connected with 192.168.2.36 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  11.5 MBytes  96.6 Mbits/sec
[  3]  1.0- 2.0 sec  11.4 MBytes  95.2 Mbits/sec
[  3]  2.0- 3.0 sec  11.4 MBytes  95.5 Mbits/sec
[  3]  3.0- 4.0 sec  11.4 MBytes  95.7 Mbits/sec
[  3]  4.0- 5.0 sec  11.4 MBytes  95.6 Mbits/sec
[  3]  5.0- 6.0 sec  11.4 MBytes  95.6 Mbits/sec
[  3]  6.0- 7.0 sec  11.3 MBytes  95.1 Mbits/sec
[  3]  7.0- 8.0 sec  11.4 MBytes  95.6 Mbits/sec
[  3]  8.0- 9.0 sec  11.4 MBytes  95.7 Mbits/sec
[  3]  9.0-10.0 sec  11.4 MBytes  95.5 Mbits/sec
[  3]  0.0-10.0 sec   114 MBytes  95.6 Mbits/sec
[  3] Sent 81306 datagrams
[  3] Server Report:
[  3]  0.0-10.1 sec   107 MBytes  89.3 Mbits/sec   0.444 ms 4699/81305 (5.8%)
[  3]  0.0-10.1 sec  1 datagrams received out-of-order
</Ethernet-UDP>
</Proximity>

 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

<Refraction>
Wi-Fi <~10m NLOS~> AP(Wi-Fi <-bridge-> 100Mbit switch) <-> Ethernet

<AP>
# iwconfig ra0
ra0       RTWIFI SoftAP  ESSID:"Geppetto"  
          Mode:Managed  Channel=13  Access Point: 00:22:44:66:88:aa   
          Bit Rate=150 Mb/s   
</AP>
          
<Wi-Fi>
$ iwconfig ra0 
ra0       Ralink STA  ESSID:"Geppetto"  Nickname:"MT7601STA"
          Mode:Managed  Frequency=2.472 GHz  Access Point: 00:22:44:66:88:aa   
          Bit Rate=27 Mb/s   
          RTS thr:off   Fragment thr:off
          Link Quality=60/100  Signal level:-80 dBm  Noise level:-90 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
</Wi-Fi>

<Ethernet>
$ ifconfig enp0s4f1u4
enp0s4f1u4: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.2.5  netmask 255.255.255.0  broadcast 192.168.2.255
        ether 00:12:34:56:78:20  txqueuelen 1000  (Ethernet)
        RX errors 0  dropped 84  overruns 0  frame 0
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
</Ethernet>

<Wi-Fi-TCP>
$ iperf -s -i 1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.36 port 5001 connected with 192.168.2.5 port 59063
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  1.81 MBytes  15.2 Mbits/sec
[  4]  1.0- 2.0 sec  2.24 MBytes  18.8 Mbits/sec
[  4]  2.0- 3.0 sec  2.25 MBytes  18.8 Mbits/sec
[  4]  3.0- 4.0 sec  2.26 MBytes  19.0 Mbits/sec
[  4]  4.0- 5.0 sec  2.12 MBytes  17.8 Mbits/sec
[  4]  5.0- 6.0 sec  1.60 MBytes  13.4 Mbits/sec
[  4]  6.0- 7.0 sec  2.20 MBytes  18.5 Mbits/sec
[  4]  7.0- 8.0 sec  2.23 MBytes  18.7 Mbits/sec
[  4]  8.0- 9.0 sec  1.41 MBytes  11.8 Mbits/sec
[  4]  9.0-10.0 sec  2.83 MBytes  23.7 Mbits/sec
[  4]  0.0-10.6 sec  22.0 MBytes  17.4 Mbits/sec
</Wi-Fi-TCP>
 >
<Ethernet-TCP>
$ iperf -c 192.168.2.36 -i 1
------------------------------------------------------------
Client connecting to 192.168.2.36, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.5 port 59063 connected with 192.168.2.36 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  2.00 MBytes  16.8 Mbits/sec
[  3]  1.0- 2.0 sec  2.50 MBytes  21.0 Mbits/sec
[  3]  2.0- 3.0 sec  2.38 MBytes  19.9 Mbits/sec
[  3]  3.0- 4.0 sec  2.25 MBytes  18.9 Mbits/sec
[  3]  4.0- 5.0 sec  2.50 MBytes  21.0 Mbits/sec
[  3]  5.0- 6.0 sec  1.88 MBytes  15.7 Mbits/sec
[  3]  6.0- 7.0 sec  2.00 MBytes  16.8 Mbits/sec
[  3]  7.0- 8.0 sec  2.38 MBytes  19.9 Mbits/sec
[  3]  8.0- 9.0 sec  1.38 MBytes  11.5 Mbits/sec
[  3]  9.0-10.0 sec  2.62 MBytes  22.0 Mbits/sec
[  3]  0.0-10.0 sec  22.0 MBytes  18.4 Mbits/sec
</Ethernet-TCP>

<Wi-Fi-UDP>
$ iperf -s -i 1 -u
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.36 port 5001 connected with 192.168.2.5 port 55884
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  3]  0.0- 1.0 sec  1.94 MBytes  16.3 Mbits/sec   1.198 ms 2902/ 4284 (68%)
[  3]  1.0- 2.0 sec  1.79 MBytes  15.0 Mbits/sec   1.282 ms 6990/ 8269 (85%)
[  3]  2.0- 3.0 sec  2.27 MBytes  19.0 Mbits/sec   0.722 ms 6875/ 8492 (81%)
[  3]  3.0- 4.0 sec  2.30 MBytes  19.3 Mbits/sec   0.970 ms 6538/ 8176 (80%)
[  3]  4.0- 5.0 sec  2.27 MBytes  19.0 Mbits/sec   0.994 ms 6387/ 8006 (80%)
[  3]  5.0- 6.0 sec  2.22 MBytes  18.6 Mbits/sec   1.724 ms 6557/ 8140 (81%)
[  3]  6.0- 7.0 sec  1.96 MBytes  16.4 Mbits/sec   1.001 ms 6799/ 8195 (83%)
[  3]  7.0- 8.0 sec  2.28 MBytes  19.1 Mbits/sec   0.699 ms 6556/ 8181 (80%)
[  3]  8.0- 9.0 sec  2.32 MBytes  19.5 Mbits/sec   1.065 ms 6259/ 7916 (79%)
[  3]  9.0-10.0 sec  2.31 MBytes  19.4 Mbits/sec   1.043 ms 6443/ 8092 (80%)
[  3]  0.0-10.4 sec  22.5 MBytes  18.2 Mbits/sec   1.554 ms 64724/80784 (80%)
</Wi-Fi-UDP>
 >
<Ethernet-UDP>
$ iperf -c 192.168.2.36 -i 1 -u -b 300M
------------------------------------------------------------
Client connecting to 192.168.2.36, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.5 port 55884 connected with 192.168.2.36 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  11.4 MBytes  95.7 Mbits/sec
[  3]  1.0- 2.0 sec  11.3 MBytes  95.1 Mbits/sec
[  3]  2.0- 3.0 sec  11.3 MBytes  95.0 Mbits/sec
[  3]  3.0- 4.0 sec  11.3 MBytes  94.6 Mbits/sec
[  3]  4.0- 5.0 sec  11.4 MBytes  95.3 Mbits/sec
[  3]  5.0- 6.0 sec  11.3 MBytes  95.0 Mbits/sec
[  3]  6.0- 7.0 sec  11.3 MBytes  94.5 Mbits/sec
[  3]  7.0- 8.0 sec  11.3 MBytes  95.0 Mbits/sec
[  3]  8.0- 9.0 sec  11.3 MBytes  94.9 Mbits/sec
[  3]  9.0-10.0 sec  11.4 MBytes  95.4 Mbits/sec
[  3]  0.0-10.0 sec   113 MBytes  95.0 Mbits/sec
[  3] Sent 80820 datagrams
[  3] Server Report:
[  3]  0.0-10.4 sec  22.5 MBytes  18.2 Mbits/sec   1.554 ms 64724/80784 (80%)
</Ethernet-UDP>

<Ethernet-TCP>
$ iperf -s -i 1
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.2.5 port 5001 connected with 192.168.2.36 port 49506
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0- 1.0 sec  1.78 MBytes  15.0 Mbits/sec
[  4]  1.0- 2.0 sec  1.71 MBytes  14.3 Mbits/sec
[  4]  2.0- 3.0 sec  1.75 MBytes  14.7 Mbits/sec
[  4]  3.0- 4.0 sec  1.73 MBytes  14.5 Mbits/sec
[  4]  4.0- 5.0 sec  1.76 MBytes  14.7 Mbits/sec
[  4]  5.0- 6.0 sec  1.62 MBytes  13.6 Mbits/sec
[  4]  6.0- 7.0 sec  1.70 MBytes  14.3 Mbits/sec
[  4]  7.0- 8.0 sec  1.52 MBytes  12.7 Mbits/sec
[  4]  8.0- 9.0 sec  1.55 MBytes  13.0 Mbits/sec
[  4]  9.0-10.0 sec  1.64 MBytes  13.7 Mbits/sec
[  4]  0.0-10.5 sec  17.6 MBytes  14.1 Mbits/sec
</Ethernet-TCP>
 >
<Wi-Fi-TCP>
$ iperf -c 192.168.2.5 -i 1
------------------------------------------------------------
Client connecting to 192.168.2.5, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.36 port 49506 connected with 192.168.2.5 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  2.00 MBytes  16.8 Mbits/sec
[  3]  1.0- 2.0 sec  1.75 MBytes  14.7 Mbits/sec
[  3]  2.0- 3.0 sec  1.88 MBytes  15.7 Mbits/sec
[  3]  3.0- 4.0 sec  1.62 MBytes  13.6 Mbits/sec
[  3]  4.0- 5.0 sec  2.00 MBytes  16.8 Mbits/sec
[  3]  5.0- 6.0 sec  1.50 MBytes  12.6 Mbits/sec
[  3]  6.0- 7.0 sec  1.88 MBytes  15.7 Mbits/sec
[  3]  7.0- 8.0 sec  1.50 MBytes  12.6 Mbits/sec
[  3]  8.0- 9.0 sec  1.50 MBytes  12.6 Mbits/sec
[  3]  9.0-10.0 sec  1.88 MBytes  15.7 Mbits/sec
[  3]  0.0-10.1 sec  17.6 MBytes  14.6 Mbits/sec
</Wi-Fi-TCP>

<Ethernet-UDP>
$ iperf -s -i 1 -u
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.5 port 5001 connected with 192.168.2.36 port 32801
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  3]  0.0- 1.0 sec  2.02 MBytes  17.0 Mbits/sec   0.370 ms    0/ 1442 (0%)
[  3]  1.0- 2.0 sec  2.63 MBytes  22.1 Mbits/sec   0.623 ms    0/ 1876 (0%)
[  3]  2.0- 3.0 sec  2.77 MBytes  23.2 Mbits/sec   0.423 ms    0/ 1974 (0%)
[  3]  3.0- 4.0 sec  2.48 MBytes  20.8 Mbits/sec   1.137 ms    0/ 1769 (0%)
[  3]  4.0- 5.0 sec  2.18 MBytes  18.3 Mbits/sec   0.398 ms    0/ 1558 (0%)
[  3]  5.0- 6.0 sec  2.26 MBytes  18.9 Mbits/sec   0.846 ms    0/ 1609 (0%)
[  3]  6.0- 7.0 sec  2.37 MBytes  19.9 Mbits/sec   0.500 ms    0/ 1690 (0%)
[  3]  7.0- 8.0 sec  2.33 MBytes  19.6 Mbits/sec   0.782 ms    0/ 1663 (0%)
[  3]  8.0- 9.0 sec  2.44 MBytes  20.5 Mbits/sec   0.707 ms    0/ 1741 (0%)
[  3]  9.0-10.0 sec  2.58 MBytes  21.7 Mbits/sec   1.300 ms    0/ 1842 (0%)
[  3]  0.0-10.1 sec  24.2 MBytes  20.2 Mbits/sec   2.782 ms    0/17256 (0%)
[  3]  0.0-10.1 sec  1 datagrams received out-of-order
</Ethernet-UDP>
 >
<Wi-Fi-UDP>
$ iperf -c 192.168.2.5 -i 1 -u -b 300M
------------------------------------------------------------
Client connecting to 192.168.2.5, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 192.168.2.36 port 32801 connected with 192.168.2.5 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  2.23 MBytes  18.7 Mbits/sec
[  3]  1.0- 2.0 sec  2.59 MBytes  21.7 Mbits/sec
[  3]  2.0- 3.0 sec  2.76 MBytes  23.1 Mbits/sec
[  3]  3.0- 4.0 sec  2.59 MBytes  21.8 Mbits/sec
[  3]  4.0- 5.0 sec  2.15 MBytes  18.0 Mbits/sec
[  3]  5.0- 6.0 sec  2.14 MBytes  17.9 Mbits/sec
[  3]  6.0- 7.0 sec  2.44 MBytes  20.5 Mbits/sec
[  3]  7.0- 8.0 sec  2.42 MBytes  20.3 Mbits/sec
[  3]  8.0- 9.0 sec  2.43 MBytes  20.4 Mbits/sec
[  3]  9.0-10.0 sec  2.45 MBytes  20.5 Mbits/sec
[  3]  0.0-10.0 sec  24.2 MBytes  20.3 Mbits/sec
[  3] Sent 17257 datagrams
[  3] Server Report:
[  3]  0.0-10.1 sec  24.2 MBytes  20.2 Mbits/sec   2.782 ms    0/17256 (0%)
[  3]  0.0-10.1 sec  1 datagrams received out-of-order
</Wi-Fi-UDP>
</Refraction>


[1] DPO_MT7601U_LinuxSTA_3.0.0.4_20130913-Linux-3.17.0-v2.patch

diff -ur a/common/crypt_aes.c b/common/crypt_aes.c
--- a/common/crypt_aes.c	2013-09-12 07:27:14.000000000 +0200
+++ b/common/crypt_aes.c	2014-08-29 22:51:56.252033992 +0200
@@ -1456,7 +1456,7 @@
 /*    if ((pResult = (UINT8 *) kmalloc(sizeof(UINT8)*PlainTextLength, GFP_ATOMIC)) == NULL) {
 */
     if (pResult == NULL) {
-    	DBGPRINT(RT_DEBUG_ERROR, ("AES_Key_Wrap: allocate %d bytes memory failure.\n", sizeof(UINT8)*PlainTextLength));
+    	DBGPRINT(RT_DEBUG_ERROR, ("AES_Key_Wrap: allocate %d bytes memory failure.\n", (UINT)(sizeof(UINT8)*PlainTextLength)));
         return -2;
     } /* End of if */
 
@@ -1551,7 +1551,7 @@
 /*    if ((pResult = (UINT8 *) kmalloc(sizeof(UINT8)*PlainLength, GFP_ATOMIC)) == NULL) {
 */
     if (pResult == NULL) {
-    	DBGPRINT(RT_DEBUG_ERROR, ("AES_Key_Unwrap: allocate %d bytes memory failure.\n", sizeof(UINT8)*PlainLength));
+    	DBGPRINT(RT_DEBUG_ERROR, ("AES_Key_Unwrap: allocate %d bytes memory failure.\n", (UINT)(sizeof(UINT8)*PlainLength)));
         return -2;
     } /* End of if */
 
diff -ur a/common/mlme.c b/common/mlme.c
--- a/common/mlme.c	2013-09-12 07:27:14.000000000 +0200
+++ b/common/mlme.c	2014-08-28 20:54:24.000000000 +0200
@@ -541,8 +541,8 @@
 #endif /* RALINK_ATE */
 		/* for performace enchanement */
 		NdisZeroMemory(&pAd->RalinkCounters,
-						(UINT32)&pAd->RalinkCounters.OneSecEnd -
-						(UINT32)&pAd->RalinkCounters.OneSecStart);
+						(ULONG)&pAd->RalinkCounters.OneSecEnd -
+						(ULONG)&pAd->RalinkCounters.OneSecStart);
 
 	return;
 }
diff -ur a/common/rtmp_init_inf.c b/common/rtmp_init_inf.c
--- a/common/rtmp_init_inf.c	2013-09-17 11:16:36.000000000 +0200
+++ b/common/rtmp_init_inf.c	2014-08-29 20:57:04.000000000 +0200
@@ -665,7 +665,9 @@
 	{
 	UINT32 reg = 0;
 	RTMP_IO_READ32(pAd, 0x1300, &reg);  /* clear garbage interrupts*/
+#ifdef DBG
 	printk("0x1300 = %08x\n", reg);
+#endif /* DBG */
 	}
 
 	{
diff -ur a/common/rtusb_bulk.c b/common/rtusb_bulk.c
--- a/common/rtusb_bulk.c	2013-09-12 07:27:14.000000000 +0200
+++ b/common/rtusb_bulk.c	2014-08-29 20:57:43.000000000 +0200
@@ -1585,7 +1585,9 @@
 
 	if (pCmdRspEventContext->IRPPending == TRUE)
 	{
+#ifdef DBG
 		printk("unlink cmd rsp urb\n");
+#endif /* DBG */
 		RTUSB_UNLINK_URB(pCmdRspEventContext->pUrb);
 		pCmdRspEventContext->IRPPending = FALSE;
 		pCmdRspEventContext->InUse = FALSE;
diff -ur a/common/spectrum.c b/common/spectrum.c
--- a/common/spectrum.c	2013-09-12 07:27:14.000000000 +0200
+++ b/common/spectrum.c	2014-08-29 23:03:23.250333353 +0200
@@ -1969,7 +1969,7 @@
 /*	if ((pMeasureReportInfo = kmalloc(sizeof(MEASURE_RPI_REPORT), GFP_ATOMIC)) == NULL)*/
 	if (pMeasureReportInfo == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __FUNCTION__, sizeof(MEASURE_RPI_REPORT)));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __FUNCTION__, (UINT)sizeof(MEASURE_RPI_REPORT)));
 		return;
 	}
 
diff -ur a/include/os/rt_linux.h b/include/os/rt_linux.h
--- a/include/os/rt_linux.h	2013-09-12 07:27:14.000000000 +0200
+++ b/include/os/rt_linux.h	2014-08-28 20:54:24.000000000 +0200
@@ -879,12 +879,19 @@
 		(RTPKT_TO_OSPKT(_pkt)->len)
 #define SET_OS_PKT_LEN(_pkt, _len)	\
 		(RTPKT_TO_OSPKT(_pkt)->len) = (_len)
-		
+
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+#define GET_OS_PKT_DATATAIL(_pkt) \
+        (RTPKT_TO_OSPKT(_pkt)->head + (ULONG)RTPKT_TO_OSPKT(_pkt)->tail)
+#define SET_OS_PKT_DATATAIL(_pkt, _start, _len)	\
+		((RTPKT_TO_OSPKT(_pkt))->tail) = (ULONG)_start - (ULONG)(RTPKT_TO_OSPKT(_pkt)->head) + (_len)
+#else
 #define GET_OS_PKT_DATATAIL(_pkt) \
-		(RTPKT_TO_OSPKT(_pkt)->tail)
+        (RTPKT_TO_OSPKT(_pkt)->tail)
 #define SET_OS_PKT_DATATAIL(_pkt, _start, _len)	\
 		((RTPKT_TO_OSPKT(_pkt))->tail) = (PUCHAR)((_start) + (_len))
-		
+#endif
+
 #define GET_OS_PKT_HEAD(_pkt) \
 		(RTPKT_TO_OSPKT(_pkt)->head)
 
diff -ur a/os/linux/config.mk b/os/linux/config.mk
--- a/os/linux/config.mk	2013-09-12 08:05:55.000000000 +0200
+++ b/os/linux/config.mk	2014-08-28 20:54:24.000000000 +0200
@@ -150,7 +150,7 @@
 HAS_BGFP_OPEN_SUPPORT=n
 
 # Support HOSTAPD function
-HAS_HOSTAPD_SUPPORT=n
+HAS_HOSTAPD_SUPPORT=y
 
 #Support GreenAP function
 HAS_GREENAP_SUPPORT=n
@@ -290,7 +290,7 @@
 # config for STA mode
 
 ifeq ($(RT28xx_MODE),STA)
-WFLAGS += -DCONFIG_STA_SUPPORT -DSCAN_SUPPORT -DDBG
+WFLAGS += -DCONFIG_STA_SUPPORT -DSCAN_SUPPORT
 
 ifeq ($(HAS_XLINK),y)
 WFLAGS += -DXLINK_SUPPORT
@@ -1054,11 +1054,16 @@
 export CFLAGS
 endif
 
+GCCVERSION = $(shell gcc -dumpversion)
+
 ifeq ($(PLATFORM),PC)
     ifneq (,$(findstring 2.4,$(LINUX_SRC)))
 	# Linux 2.4
 	CFLAGS := -D__KERNEL__ -I$(LINUX_SRC)/include -O2 -fomit-frame-pointer -fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=2 -march=i686 -DMODULE -DMODVERSIONS -include $(LINUX_SRC)/include/linux/modversions.h $(WFLAGS)
 	export CFLAGS
+    else ifneq (,$(findstring 4.9,$(GCCVERSION)))
+	# GCC 4.9
+        EXTRA_CFLAGS := -Wno-error=date-time $(WFLAGS)
     else
 	# Linux 2.6
 	EXTRA_CFLAGS := $(WFLAGS) 
diff -ur a/os/linux/rt_linux.c b/os/linux/rt_linux.c
--- a/os/linux/rt_linux.c	2013-09-12 07:27:14.000000000 +0200
+++ b/os/linux/rt_linux.c	2014-08-28 20:54:24.000000000 +0200
@@ -494,9 +494,11 @@
 		MEM_DBG_PKT_ALLOC_INC(skb);
 
 		skb_reserve(skb, 2);
-		NdisMoveMemory(skb->tail, pHeader802_3, HdrLen);
+
+		NdisMoveMemory(GET_OS_PKT_DATATAIL(skb), pHeader802_3, HdrLen);
 		skb_put(skb, HdrLen);
-		NdisMoveMemory(skb->tail, pData, DataSize);
+		NdisMoveMemory(GET_OS_PKT_DATATAIL(skb), pData, DataSize);
+
 		skb_put(skb, DataSize);
 		skb->dev = pNetDev;	/*get_netdev_from_bssid(pAd, FromWhichBSSID); */
 		pPacket = OSPKT_TO_RTPKT(skb);
@@ -647,7 +649,7 @@
 		pClonedPkt->dev = pRxPkt->dev;
 		pClonedPkt->data = pData;
 		pClonedPkt->len = DataSize;
-		pClonedPkt->tail = pClonedPkt->data + pClonedPkt->len;
+		SET_OS_PKT_DATATAIL(pClonedPkt, pClonedPkt->data, pClonedPkt->len);
 		ASSERT(DataSize < 1530);
 	}
 	return pClonedPkt;
@@ -692,7 +694,7 @@
 	pOSPkt->dev = pNetDev;
 	pOSPkt->data = pData;
 	pOSPkt->len = DataSize;
-	pOSPkt->tail = pOSPkt->data + pOSPkt->len;
+	SET_OS_PKT_DATATAIL(pOSPkt, pOSPkt->data, pOSPkt->len);
 
 	/* copy 802.3 header */
 
@@ -1117,6 +1119,11 @@
 		pOSFSInfo->fsuid = current->fsuid;
 		pOSFSInfo->fsgid = current->fsgid;
 		current->fsuid = current->fsgid = 0;
+
+#elif LINUX_VERSION_CODE >= KERNEL_VERSION(3,15,10)
+      pOSFSInfo->fsuid = current_fsuid().val;
+      pOSFSInfo->fsgid = current_fsgid().val;
+
 #else
 		pOSFSInfo->fsuid = current_fsuid();
 		pOSFSInfo->fsgid = current_fsgid();
diff -ur a/os/linux/rt_main_dev.c b/os/linux/rt_main_dev.c
--- a/os/linux/rt_main_dev.c	2013-09-12 07:27:14.000000000 +0200
+++ b/os/linux/rt_main_dev.c	2014-08-29 21:14:46.000000000 +0200
@@ -746,7 +746,9 @@
 	/* Unregister network device */
 	if (net_dev != NULL)
 	{
+#ifdef DBG
 		printk("RtmpOSNetDevDetach(): RtmpOSNetDeviceDetach(), dev->name=%s!\n", net_dev->name);
+#endif /* DBG */
 		RtmpOSNetDevDetach(net_dev);
 	}
 
diff -ur a/os/linux/rt_profile.c b/os/linux/rt_profile.c
--- a/os/linux/rt_profile.c	2013-09-12 07:27:14.000000000 +0200
+++ b/os/linux/rt_profile.c	2014-08-29 23:23:18.033710839 +0200
@@ -396,7 +396,7 @@
 
     if (pRxBlk->DataSize + sizeof(wlan_ng_prism2_header) > RX_BUFFER_AGGRESIZE)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __FUNCTION__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __FUNCTION__, pRxBlk->DataSize + (UINT)sizeof(wlan_ng_prism2_header)));
 		goto err_free_sk_buff;
     }
 
diff -ur a/os/linux/usb_main_dev.c b/os/linux/usb_main_dev.c
--- a/os/linux/usb_main_dev.c	2013-09-12 07:27:14.000000000 +0200
+++ b/os/linux/usb_main_dev.c	2014-08-29 21:12:35.000000000 +0200
@@ -516,7 +516,9 @@
 /* Init driver module */
 INT __init rtusb_init(void)
 {
+#ifdef DBG
 	printk("rtusb init %s --->\n", RTMP_DRV_NAME);
+#endif /* DBG */
 	return usb_register(&rtusb_driver);
 }
 
@@ -524,7 +526,9 @@
 VOID __exit rtusb_exit(void)
 {
 	usb_deregister(&rtusb_driver);	
+#ifdef DBG
 	printk("<--- rtusb exit\n");
+#endif /* DBG */
 }
 
 module_init(rtusb_init);
diff -ur a/sta/sta_cfg.c b/sta/sta_cfg.c
--- a/sta/sta_cfg.c	2013-09-12 07:27:14.000000000 +0200
+++ b/sta/sta_cfg.c	2014-08-28 20:54:24.000000000 +0200
@@ -8274,6 +8274,7 @@
 			RTMPIoctlGetSiteSurvey(pAd, pRequest);
 			break;
 
+#ifdef DBG
 		case CMD_RTPRIV_IOCTL_MAC:
 			RTMPIoctlMAC(pAd, pRequest);
 			break;
@@ -8285,6 +8286,7 @@
 		case CMD_RTPRIV_IOCTL_RF:
 			RTMPIoctlRF(pAd, pRequest);
 			break;
+#endif /* DBG */
 
 		case CMD_RTPRIV_IOCTL_BBP:
 			RTMPIoctlBbp(pAd, pRequest, pData, Data);


poma


