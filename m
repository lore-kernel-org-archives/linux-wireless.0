Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out114.alice.it ([85.37.17.114]:3439 "EHLO
	smtp-out114.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532AbXFDXRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 19:17:14 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: linux-wireless@vger.kernel.org
Subject: Re: airo works badly
Date: Tue, 5 Jun 2007 01:03:00 +0200
References: <200705060231.28480.rootkit85@yahoo.it> <20070514182336.GC6999@tuxdriver.com>
In-Reply-To: <20070514182336.GC6999@tuxdriver.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706050103.00711.rootkit85@yahoo.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is another weird behaviour: small packets does arrive, big ones are 
corrupt:

[~/src/openwrt]$ ping libero.it -s 502
PING libero.it (195.210.91.83) 502(530) bytes of data.
510 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=1 ttl=117 time=389 ms
510 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=2 ttl=117 time=74.3 ms
510 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=3 ttl=117 time=54.6 ms
510 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=4 ttl=117 time=47.5 ms

--- libero.it ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 2999ms
rtt min/avg/max/mdev = 47.561/141.382/389.028/143.315 ms
[~/src/openwrt]$ ping libero.it -s 503
PING libero.it (195.210.91.83) 503(531) bytes of data.
511 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=1 ttl=117 time=52.4 ms
wrong data byte #502 should be 0xf6 but was 0xfa
#16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
27 28 29 2a 2b 2c 2d 2e 2f
#48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
47 48 49 4a 4b 4c 4d 4e 4f
#80     50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
67 68 69 6a 6b 6c 6d 6e 6f
#112    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
87 88 89 8a 8b 8c 8d 8e 8f
#144    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
a7 a8 a9 aa ab ac ad ae af
#176    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
c7 c8 c9 ca cb cc cd ce cf
#208    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
e7 e8 e9 ea eb ec ed ee ef
#240    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a 
b c d e f
#272    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
27 28 29 2a 2b 2c 2d 2e 2f
#304    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
47 48 49 4a 4b 4c 4d 4e 4f
#336    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
67 68 69 6a 6b 6c 6d 6e 6f
#368    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
87 88 89 8a 8b 8c 8d 8e 8f
#400    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
a7 a8 a9 aa ab ac ad ae af
#432    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
c7 c8 c9 ca cb cc cd ce cf
#464    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
e7 e8 e9 ea eb ec ed ee ef
#496    f0 f1 f2 f3 f4 f5 fa
511 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=2 ttl=117 time=48.5 ms
wrong data byte #502 should be 0xf6 but was 0xfa
#16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
27 28 29 2a 2b 2c 2d 2e 2f
#48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
47 48 49 4a 4b 4c 4d 4e 4f
#80     50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
67 68 69 6a 6b 6c 6d 6e 6f
#112    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
87 88 89 8a 8b 8c 8d 8e 8f
#144    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
a7 a8 a9 aa ab ac ad ae af
#176    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
c7 c8 c9 ca cb cc cd ce cf
#208    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
e7 e8 e9 ea eb ec ed ee ef
#240    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a 
b c d e f
#272    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
27 28 29 2a 2b 2c 2d 2e 2f
#304    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
47 48 49 4a 4b 4c 4d 4e 4f
#336    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
67 68 69 6a 6b 6c 6d 6e 6f
#368    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
87 88 89 8a 8b 8c 8d 8e 8f
#400    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
a7 a8 a9 aa ab ac ad ae af
#432    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
c7 c8 c9 ca cb cc cd ce cf
#464    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
e7 e8 e9 ea eb ec ed ee ef
#496    f0 f1 f2 f3 f4 f5 fa
511 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=3 ttl=117 time=81.2 ms
wrong data byte #502 should be 0xf6 but was 0xfa
#16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
27 28 29 2a 2b 2c 2d 2e 2f
#48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
47 48 49 4a 4b 4c 4d 4e 4f
#80     50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
67 68 69 6a 6b 6c 6d 6e 6f
#112    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
87 88 89 8a 8b 8c 8d 8e 8f
#144    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
a7 a8 a9 aa ab ac ad ae af
#176    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
c7 c8 c9 ca cb cc cd ce cf
#208    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
e7 e8 e9 ea eb ec ed ee ef
#240    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a 
b c d e f
#272    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
27 28 29 2a 2b 2c 2d 2e 2f
#304    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
47 48 49 4a 4b 4c 4d 4e 4f
#336    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
67 68 69 6a 6b 6c 6d 6e 6f
#368    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
87 88 89 8a 8b 8c 8d 8e 8f
#400    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
a7 a8 a9 aa ab ac ad ae af
#432    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
c7 c8 c9 ca cb cc cd ce cf
#464    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
e7 e8 e9 ea eb ec ed ee ef
#496    f0 f1 f2 f3 f4 f5 fa

--- libero.it ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2008ms
rtt min/avg/max/mdev = 48.570/60.747/81.264/14.594 ms

then after a while the card goes crazy and i have to poweroff:

[~/src/openwrt/target/linux/ar7-2.6/files]$ iwconfig
lo        no wireless extensions.

Warning: Driver for device eth0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 20.
Some things may be broken...

eth0      IEEE 802.11-DS  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: E8:5C:D1:10:00:81
          Bit Rate:-1.59224e+06 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
          Retry limit:16   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=0/100  Signal level=-106 dBm  Noise level=-16 dBm
          Rx invalid nwid:1072759808  Rx invalid crypt:-1  Rx invalid frag:0
          Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
beacon:-32512

wifi0     IEEE 802.11-DS  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: A0:3A:99:EB:1D:2B
          Bit Rate:-1.59224e+06 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
          Retry limit:16   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=175/100  Signal level=-106 dBm  Noise level=-16 dBm
          Rx invalid nwid:1072759808  Rx invalid crypt:-1  Rx invalid frag:0
          Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
beacon:-32512

eth1      no wireless extensions.

[~/src/openwrt/target/linux/ar7-2.6/files]$ iwconfig eth0
Warning: Driver for device eth0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 20.
Some things may be broken...

eth0      IEEE 802.11-DS  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: E8:1C:F1:06:00:81
          Bit Rate:0 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
          Retry limit:16   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=239/100  Signal level=-10 dBm  Noise level=-57 dBm
          Rx invalid nwid:-2144973184  Rx invalid crypt:-1  Rx invalid frag:0
          Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
beacon:-32512

[~/src/openwrt/target/linux/ar7-2.6/files]$ iwconfig eth0
Warning: Driver for device eth0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 20.
Some things may be broken...

eth0      IEEE 802.11-DS  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: E8:DC:8D:06:00:81
          Bit Rate:0 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
          Retry limit:16   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=0/100  Signal level=-10 dBm  Noise level=-6 dBm
          Rx invalid nwid:972605568  Rx invalid crypt:-1  Rx invalid frag:0
          Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
beacon:-32512

[~/src/openwrt/target/linux/ar7-2.6/files]$ iwconfig eth0
Warning: Driver for device eth0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 20.
Some things may be broken...

eth0      IEEE 802.11-DS  ESSID:""
          Mode:Managed  Frequency:2.412 GHz  Access Point: E8:1C:F1:06:00:81
          Bit Rate:0 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
          Retry limit:16   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=0/100  Signal level=-106 dBm  Noise level=-6 dBm
          Rx invalid nwid:1072761536  Rx invalid crypt:-1  Rx invalid frag:0
          Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
beacon:-32512
