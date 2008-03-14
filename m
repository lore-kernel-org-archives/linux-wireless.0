Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:2280 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbYCNOzC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 10:55:02 -0400
From: Matteo Croce <rootkit85@yahoo.it>
To: linux-wireless@vger.kernel.org
Subject: Re: airo works badly
Date: Fri, 14 Mar 2008 15:38:40 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	alessandroferrari@email.it
References: <200705060231.28480.rootkit85@yahoo.it> <20070514182336.GC6999@tuxdriver.com> <200706050103.00711.rootkit85@yahoo.it>
In-Reply-To: <200706050103.00711.rootkit85@yahoo.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803141538.40983.rootkit85@yahoo.it> (sfid-20080314_145512_137530_8AB7D867)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il Tuesday 05 June 2007 01:03:00 Matteo Croce ha scritto:
> This is another weird behaviour: small packets does arrive, big ones are 
> corrupt:
> 
> [~/src/openwrt]$ ping libero.it -s 502
> PING libero.it (195.210.91.83) 502(530) bytes of data.
> 510 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=1 ttl=117 time=389 ms
> 510 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=2 ttl=117 time=74.3 ms
> 510 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=3 ttl=117 time=54.6 ms
> 510 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=4 ttl=117 time=47.5 ms
> 
> --- libero.it ping statistics ---
> 4 packets transmitted, 4 received, 0% packet loss, time 2999ms
> rtt min/avg/max/mdev = 47.561/141.382/389.028/143.315 ms
> [~/src/openwrt]$ ping libero.it -s 503
> PING libero.it (195.210.91.83) 503(531) bytes of data.
> 511 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=1 ttl=117 time=52.4 ms
> wrong data byte #502 should be 0xf6 but was 0xfa
> #16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
> 27 28 29 2a 2b 2c 2d 2e 2f
> #48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
> 47 48 49 4a 4b 4c 4d 4e 4f
> #80     50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
> 67 68 69 6a 6b 6c 6d 6e 6f
> #112    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
> 87 88 89 8a 8b 8c 8d 8e 8f
> #144    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
> a7 a8 a9 aa ab ac ad ae af
> #176    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
> c7 c8 c9 ca cb cc cd ce cf
> #208    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
> e7 e8 e9 ea eb ec ed ee ef
> #240    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a 
> b c d e f
> #272    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
> 27 28 29 2a 2b 2c 2d 2e 2f
> #304    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
> 47 48 49 4a 4b 4c 4d 4e 4f
> #336    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
> 67 68 69 6a 6b 6c 6d 6e 6f
> #368    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
> 87 88 89 8a 8b 8c 8d 8e 8f
> #400    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
> a7 a8 a9 aa ab ac ad ae af
> #432    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
> c7 c8 c9 ca cb cc cd ce cf
> #464    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
> e7 e8 e9 ea eb ec ed ee ef
> #496    f0 f1 f2 f3 f4 f5 fa
> 511 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=2 ttl=117 time=48.5 ms
> wrong data byte #502 should be 0xf6 but was 0xfa
> #16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
> 27 28 29 2a 2b 2c 2d 2e 2f
> #48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
> 47 48 49 4a 4b 4c 4d 4e 4f
> #80     50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
> 67 68 69 6a 6b 6c 6d 6e 6f
> #112    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
> 87 88 89 8a 8b 8c 8d 8e 8f
> #144    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
> a7 a8 a9 aa ab ac ad ae af
> #176    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
> c7 c8 c9 ca cb cc cd ce cf
> #208    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
> e7 e8 e9 ea eb ec ed ee ef
> #240    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a 
> b c d e f
> #272    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
> 27 28 29 2a 2b 2c 2d 2e 2f
> #304    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
> 47 48 49 4a 4b 4c 4d 4e 4f
> #336    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
> 67 68 69 6a 6b 6c 6d 6e 6f
> #368    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
> 87 88 89 8a 8b 8c 8d 8e 8f
> #400    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
> a7 a8 a9 aa ab ac ad ae af
> #432    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
> c7 c8 c9 ca cb cc cd ce cf
> #464    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
> e7 e8 e9 ea eb ec ed ee ef
> #496    f0 f1 f2 f3 f4 f5 fa
> 511 bytes from vs-fe.iol.it (195.210.91.83): icmp_seq=3 ttl=117 time=81.2 ms
> wrong data byte #502 should be 0xf6 but was 0xfa
> #16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
> 27 28 29 2a 2b 2c 2d 2e 2f
> #48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
> 47 48 49 4a 4b 4c 4d 4e 4f
> #80     50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
> 67 68 69 6a 6b 6c 6d 6e 6f
> #112    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
> 87 88 89 8a 8b 8c 8d 8e 8f
> #144    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
> a7 a8 a9 aa ab ac ad ae af
> #176    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
> c7 c8 c9 ca cb cc cd ce cf
> #208    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
> e7 e8 e9 ea eb ec ed ee ef
> #240    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a 
> b c d e f
> #272    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 
> 27 28 29 2a 2b 2c 2d 2e 2f
> #304    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 
> 47 48 49 4a 4b 4c 4d 4e 4f
> #336    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 
> 67 68 69 6a 6b 6c 6d 6e 6f
> #368    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 
> 87 88 89 8a 8b 8c 8d 8e 8f
> #400    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 
> a7 a8 a9 aa ab ac ad ae af
> #432    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 
> c7 c8 c9 ca cb cc cd ce cf
> #464    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 
> e7 e8 e9 ea eb ec ed ee ef
> #496    f0 f1 f2 f3 f4 f5 fa
> 
> --- libero.it ping statistics ---
> 3 packets transmitted, 3 received, 0% packet loss, time 2008ms
> rtt min/avg/max/mdev = 48.570/60.747/81.264/14.594 ms
> 
> then after a while the card goes crazy and i have to poweroff:
> 
> [~/src/openwrt/target/linux/ar7-2.6/files]$ iwconfig
> lo        no wireless extensions.
> 
> Warning: Driver for device eth0 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> eth0      IEEE 802.11-DS  ESSID:""
>           Mode:Managed  Frequency:2.412 GHz  Access Point: E8:5C:D1:10:00:81
>           Bit Rate:-1.59224e+06 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
>           Retry limit:16   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=0/100  Signal level=-106 dBm  Noise level=-16 dBm
>           Rx invalid nwid:1072759808  Rx invalid crypt:-1  Rx invalid frag:0
>           Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
> beacon:-32512
> 
> wifi0     IEEE 802.11-DS  ESSID:""
>           Mode:Managed  Frequency:2.412 GHz  Access Point: A0:3A:99:EB:1D:2B
>           Bit Rate:-1.59224e+06 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
>           Retry limit:16   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=175/100  Signal level=-106 dBm  Noise level=-16 dBm
>           Rx invalid nwid:1072759808  Rx invalid crypt:-1  Rx invalid frag:0
>           Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
> beacon:-32512
> 
> eth1      no wireless extensions.
> 
> [~/src/openwrt/target/linux/ar7-2.6/files]$ iwconfig eth0
> Warning: Driver for device eth0 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> eth0      IEEE 802.11-DS  ESSID:""
>           Mode:Managed  Frequency:2.412 GHz  Access Point: E8:1C:F1:06:00:81
>           Bit Rate:0 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
>           Retry limit:16   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=239/100  Signal level=-10 dBm  Noise level=-57 dBm
>           Rx invalid nwid:-2144973184  Rx invalid crypt:-1  Rx invalid frag:0
>           Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
> beacon:-32512
> 
> [~/src/openwrt/target/linux/ar7-2.6/files]$ iwconfig eth0
> Warning: Driver for device eth0 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> eth0      IEEE 802.11-DS  ESSID:""
>           Mode:Managed  Frequency:2.412 GHz  Access Point: E8:DC:8D:06:00:81
>           Bit Rate:0 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
>           Retry limit:16   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=0/100  Signal level=-10 dBm  Noise level=-6 dBm
>           Rx invalid nwid:972605568  Rx invalid crypt:-1  Rx invalid frag:0
>           Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
> beacon:-32512
> 
> [~/src/openwrt/target/linux/ar7-2.6/files]$ iwconfig eth0
> Warning: Driver for device eth0 has been compiled with version 22
> of Wireless Extension, while this program supports up to version 20.
> Some things may be broken...
> 
> eth0      IEEE 802.11-DS  ESSID:""
>           Mode:Managed  Frequency:2.412 GHz  Access Point: E8:1C:F1:06:00:81
>           Bit Rate:0 kb/s   Tx-Power=20 dBm   Sensitivity=0/65535
>           Retry limit:16   RTS thr:off   Fragment thr:off
>           Power Management:off
>           Link Quality=0/100  Signal level=-106 dBm  Noise level=-6 dBm
>           Rx invalid nwid:1072761536  Rx invalid crypt:-1  Rx invalid frag:0
>           Tx excessive retries:-1  Invalid misc:-2145016118   Missed 
> beacon:-32512
> 

I don't know if it's related, but is this normal?

$ sudo ping macbook-luca -s 1472 -i .001
PING macbook-luca (192.168.1.4) 1472(1500) bytes of data.
1480 bytes from macbook-luca.openwrt (192.168.1.4): icmp_seq=1 ttl=64 time=11.6 ms
..
1480 bytes from macbook-luca.openwrt (192.168.1.4): icmp_seq=229 ttl=64 time=13.7 ms
wrong data byte #1094 should be 0x46 but was 0x44
#16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
#80     50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
#112    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f
#144    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af
#176    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf
#208    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef
#240    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a b c d e f
#272    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#304    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
#336    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
#368    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f
#400    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af
#432    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf
#464    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef
#496    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a b c d e f
#528    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#560    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
#592    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
#624    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f
#656    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af
#688    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf
#720    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef
#752    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a b c d e f
#784    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#816    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
#848    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
#880    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f
#912    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af
#944    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf
#976    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef
#1008   f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a b c d e f
#1040   10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#1072   30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 44 45 46 47 48 49 4a 4b 4c 4d
#1104   4e 4f 50 51 52 53 54 55 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 64 65 66 67 68 69
#1136   6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 84 85
#1168   86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 94 95 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3
#1200   a4 a5 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1
#1232   c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1
#1264   e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1
#1296   2 3 4 5 6 7 8 9 a b c d e f 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21
#1328   22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41
#1360   42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61
#1392   62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81
#1424   82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1
#1456   a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af b0 b1
1480 bytes from macbook-luca.openwrt (192.168.1.4): icmp_seq=231 ttl=64 time=6.32 ms
1480 bytes from macbook-luca.openwrt (192.168.1.4): icmp_seq=232 ttl=64 time=7.14 ms
1480 bytes from macbook-luca.openwrt (192.168.1.4): icmp_seq=233 ttl=64 time=7.07 ms
1480 bytes from macbook-luca.openwrt (192.168.1.4): icmp_seq=234 ttl=64 time=6.75 ms
1480 bytes from macbook-luca.openwrt (192.168.1.4): icmp_seq=235 ttl=64 time=7.70 ms
1480 bytes from macbook-luca.openwrt (192.168.1.4): icmp_seq=236 ttl=64 time=6.22 ms
...
1480 bytes from router.openwrt (192.168.1.1): icmp_seq=69 ttl=64 time=5.86 ms
wrong data byte #580 should be 0x44 but was 0x42
#16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
#80     50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
#112    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f
#144    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af
#176    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf
#208    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef
#240    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a b c d e f
#272    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#304    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
#336    50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f
#368    70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f
#400    90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af
#432    b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf
#464    d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef
#496    f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3 4 5 6 7 8 9 a b c d e f
#528    10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#560    30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 42 43 44 45 46 47 48 49 4a 4b 4c 4d
#592    4e 4f 50 51 52 53 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 62 63 64 65 66 67 68 69
#624    6a 6b 6c 6d 6e 6f 70 71 72 73 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83 82 83 84 85
#656    86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3
#688    a4 a5 a6 a7 a8 a9 aa ab ac ad ae af b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3
#720    c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3
#752    e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3
#784    4 5 6 7 8 9 a b c d e f 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
#816    24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43
#848    44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63
#880    64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83
#912    84 85 86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3
#944    a4 a5 a6 a7 a8 a9 aa ab ac ad ae af b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3
#976    c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3
#1008   e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3
#1040   4 5 6 7 8 9 a b c d e f 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
#1072   24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43
#1104   44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63
#1136   64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83
#1168   84 85 86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3
#1200   a4 a5 a6 a7 a8 a9 aa ab ac ad ae af b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf c0 c1 c2 c3
#1232   c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df e0 e1 e2 e3
#1264   e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff 0 1 2 3
#1296   4 5 6 7 8 9 a b c d e f 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
#1328   24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43
#1360   44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63
#1392   64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 82 83
#1424   84 85 86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a1 a2 a3
#1456   a4 a5 a6 a7 a8 a9 aa ab ac ad ae af b0 b1 b2 b3
1480 bytes from router.openwrt (192.168.1.1): icmp_seq=70 ttl=64 time=5.36 ms
...
1480 bytes from router.openwrt (192.168.1.1): icmp_seq=46 ttl=64 time=6.16 ms
wrong data byte #76 should be 0x4c but was 0x4a
#16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4a 4b 4c 4d
#80     4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b


$ dmesg |fgrep airo
airo(): Probing for PCI adapters
airo(): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
airo(): Doing fast bap_reads
airo(): WPA is supported.
airo(eth0): MAC enabled 00:0d:29:4f:0c:be
airo(): Finished probing for PCI adapters
airo(eth0): Bad size 8192

it seems that some memcpy or copy loop copies data with an index decremented by 2.
Pinging the router:
$ sudo ping router -s 128 -i .001
136 bytes from router.openwrt (192.168.1.1): icmp_seq=203 ttl=64 time=2.44 ms
wrong data byte #26 should be 0x1a but was 0x18
#16     10 11 12 13 14 15 16 17 18 19 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 28 29 2a 2b
#48     2c 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49
#80     4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69
#112    6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79

This happens pinging different hosts, so that's not an issue with the host macbook-luca,
(it has an atheros, great card)

or "ida", intel 3945ABG (good card):
$sudo ping ida -s 128 -i .001
136 bytes from ida.openwrt (192.168.1.10): icmp_seq=69 ttl=128 time=3.59 ms
wrong data byte #82 should be 0x52 but was 0x50
#16     10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
#48     30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
#80     50 51 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d
#112    6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d

$ uname -a
Linux raver 2.6.24 #10 SMP PREEMPT Wed Mar 5 13:20:59 CET 2008 x86_64 GNU/Linux

Cheers,
Matteo
