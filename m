Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:5107 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXLCWml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 17:42:41 -0500
Received: by an-out-0708.google.com with SMTP id d31so797527and
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2007 14:42:40 -0800 (PST)
Message-ID: <40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com> (sfid-20071203_224246_874670_D36936B1)
Date: Tue, 4 Dec 2007 00:42:40 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Cc: "Mattias Nissler" <mattias.nissler@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <20071203130602.49ab7234@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196622331.7472.4.camel@localhost> <20071203041608.3af3b462@morte>
	 <1196679780.7470.9.camel@localhost> <20071203125402.76562f26@morte>
	 <1196683144.7470.14.camel@localhost> <20071203130602.49ab7234@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are some tests with ath5k + your patches...

I've tested a 5213 and a 5413 card, both have poor phy performance (we
still work on phy initialization,  txpower etc) that means they
receive ok but they can't transmit well (with other supported cards
i've got much better performance up to 27Mbits/sec but i didn't have
one in hand while testing, if you want i can repeat the test).

I've run iperf on the previous rate control, the patched one and with
locked tx rate.

5413 - pid
----------

------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:   114 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.1 port 5001 connected with 192.168.254.253 port 36143
[  3]  0.0- 1.0 sec    132 KBytes  1.08 Mbits/sec  7.021 ms   42/  134 (31%)
[  3]  1.0- 2.0 sec  50.2 KBytes    412 Kbits/sec  3.412 ms    0/   35 (0%)
[  3]  2.0- 3.0 sec  1.32 MBytes  11.0 Mbits/sec  1.379 ms  199/ 1138 (17%)
[  3]  3.0- 4.0 sec    224 KBytes  1.83 Mbits/sec  15.208 ms    0/  156 (0%)
[  3]  4.0- 5.0 sec    210 KBytes  1.72 Mbits/sec  10.241 ms    0/  146 (0%)
[  3]  5.0- 6.0 sec    425 KBytes  3.48 Mbits/sec  4.256 ms    0/  296 (0%)
[  3]  6.0- 7.0 sec    802 KBytes  6.57 Mbits/sec  2.843 ms    0/  559 (0%)
[  3]  7.0- 8.0 sec  1.13 MBytes  9.49 Mbits/sec  1.782 ms    0/  807 (0%)
[  3]  8.0- 9.0 sec  1.59 MBytes  13.3 Mbits/sec  1.661 ms    0/ 1132 (0%)
[  3]  9.0-10.0 sec  1.02 MBytes  8.58 Mbits/sec  1.776 ms    3/  733 (0.41%)
[  3] 10.0-11.0 sec  48.8 KBytes    400 Kbits/sec  1.808 ms    0/   34 (0%)
[  3] 11.0-12.0 sec  0.00 Bytes  0.00 bits/sec  1.808 ms    0/    0 (nan%)
[  3] 12.0-13.0 sec    647 KBytes  5.30 Mbits/sec  2.723 ms  429/  880 (49%)
[  3] 13.0-14.0 sec    162 KBytes  1.33 Mbits/sec  37.721 ms    0/  113 (0%)
[  3] 14.0-15.0 sec    108 KBytes    882 Kbits/sec  28.504 ms    0/   75 (0%)
[  3] 15.0-16.0 sec    139 KBytes  1.14 Mbits/sec  24.509 ms    0/   97 (0%)
[  3] 16.0-17.0 sec    395 KBytes  3.23 Mbits/sec  4.657 ms    0/  275 (0%)
[  3] 17.0-18.0 sec    805 KBytes  6.60 Mbits/sec  2.768 ms    0/  561 (0%)
[  3] 18.0-19.0 sec  1.12 MBytes  9.38 Mbits/sec  1.708 ms    0/  798 (0%)
[  3] 19.0-20.0 sec  1.56 MBytes  13.1 Mbits/sec  1.504 ms    0/ 1116 (0%)
[  3] 20.0-21.0 sec  1.11 MBytes  9.28 Mbits/sec  1.806 ms    0/  789 (0%)
[  3] 21.0-22.0 sec  64.6 KBytes    529 Kbits/sec  1.639 ms    0/   45 (0%)
[  3] 22.0-23.0 sec  0.00 Bytes  0.00 bits/sec  1.639 ms    0/    0 (nan%)
[  3] 23.0-24.0 sec    702 KBytes  5.75 Mbits/sec  2.349 ms  397/  886 (45%)
[  3] 24.0-25.0 sec    156 KBytes  1.28 Mbits/sec  35.780 ms    0/  109 (0%)
[  3] 25.0-26.0 sec    111 KBytes    906 Kbits/sec  25.621 ms    0/   77 (0%)
[  3] 26.0-27.0 sec    139 KBytes  1.14 Mbits/sec  21.186 ms    0/   97 (0%)
[  3] 27.0-28.0 sec    402 KBytes  3.29 Mbits/sec  3.818 ms    0/  280 (0%)
[  3] 28.0-29.0 sec    780 KBytes  6.39 Mbits/sec  3.695 ms    0/  543 (0%)
[  3] 29.0-30.0 sec  1.11 MBytes  9.34 Mbits/sec  3.210 ms    0/  794 (0%)
[  3] 30.0-31.0 sec  1.56 MBytes  13.1 Mbits/sec  1.502 ms    0/ 1116 (0%)
[  3] 31.0-32.0 sec  1.34 MBytes  11.2 Mbits/sec  1.817 ms    0/  955 (0%)
[  3] 32.0-33.0 sec    129 KBytes  1.06 Mbits/sec  1.385 ms    0/   90 (0%)
[  3] 33.0-34.0 sec  0.00 Bytes  0.00 bits/sec  1.385 ms    0/    0 (nan%)
[  3] 34.0-35.0 sec    593 KBytes  4.86 Mbits/sec  3.090 ms  430/  843 (51%)
[  3] 35.0-36.0 sec    210 KBytes  1.72 Mbits/sec  13.811 ms    0/  146 (0%)
[  3] 36.0-37.0 sec    109 KBytes    894 Kbits/sec  32.685 ms    0/   76 (0%)
[  3] 37.0-38.0 sec    129 KBytes  1.06 Mbits/sec  12.335 ms    0/   90 (0%)
[  3] 38.0-39.0 sec    370 KBytes  3.03 Mbits/sec  4.227 ms    0/  258 (0%)
[  3] 39.0-40.0 sec    778 KBytes  6.37 Mbits/sec  4.312 ms    0/  542 (0%)
[  3] 40.0-41.0 sec  1.09 MBytes  9.15 Mbits/sec  1.735 ms    0/  778 (0%)
[  3] 41.0-42.0 sec  1.53 MBytes  12.9 Mbits/sec  1.077 ms    0/ 1094 (0%)
[  3] 42.0-43.0 sec  1.50 MBytes  12.6 Mbits/sec  2.631 ms    0/ 1069 (0%)
[  3] 43.0-44.0 sec    185 KBytes  1.52 Mbits/sec  1.203 ms    0/  129 (0%)
[  3] 44.0-45.0 sec  0.00 Bytes  0.00 bits/sec  1.203 ms    0/    0 (nan%)
[  3] 45.0-46.0 sec    662 KBytes  5.42 Mbits/sec  2.283 ms  407/  868 (47%)
[  3] 46.0-47.0 sec    237 KBytes  1.94 Mbits/sec  13.562 ms    0/  165 (0%)
[  3] 47.0-48.0 sec    109 KBytes    894 Kbits/sec  35.074 ms    0/   76 (0%)
[  3] 48.0-49.0 sec    132 KBytes  1.08 Mbits/sec  11.849 ms    0/   92 (0%)
[  3] 49.0-50.0 sec    370 KBytes  3.03 Mbits/sec  4.068 ms    0/  258 (0%)
[  3] 50.0-51.0 sec    777 KBytes  6.36 Mbits/sec  4.439 ms    0/  541 (0%)
[  3] 51.0-52.0 sec  1.09 MBytes  9.15 Mbits/sec  1.842 ms    0/  778 (0%)
[  3] 52.0-53.0 sec  1.52 MBytes  12.7 Mbits/sec  1.803 ms    0/ 1081 (0%)
[  3] 53.0-54.0 sec  1.76 MBytes  14.7 Mbits/sec  1.593 ms    0/ 1252 (0%)
[  3] 54.0-55.0 sec    276 KBytes  2.26 Mbits/sec  1.054 ms    0/  192 (0%)
[  3] 55.0-56.0 sec  0.00 Bytes  0.00 bits/sec  1.054 ms    0/    0 (nan%)
[  3] 56.0-57.0 sec    534 KBytes  4.37 Mbits/sec  4.054 ms  430/  802 (54%)
[  3] 57.0-58.0 sec    263 KBytes  2.15 Mbits/sec  13.594 ms    0/  183 (0%)
[  3] 58.0-59.0 sec    106 KBytes    870 Kbits/sec  42.790 ms    0/   74 (0%)
[  3] 59.0-60.0 sec    121 KBytes    988 Kbits/sec  18.267 ms    0/   84 (0%)
[  3]  0.0-60.3 sec  33.7 MBytes  4.69 Mbits/sec  22.544 ms 2336/26385 (8.9%)
[  3]  0.0-60.3 sec  1 datagrams received out-of-order


5413 - old
----------

------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:   114 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.1 port 5001 connected with 192.168.254.253 port 56805
[  3]  0.0- 1.0 sec    108 KBytes    882 Kbits/sec  28.413 ms   11/   86 (13%)
[  3]  1.0- 2.0 sec    109 KBytes    894 Kbits/sec  22.192 ms    0/   76 (0%)
[  3]  2.0- 3.0 sec    108 KBytes    882 Kbits/sec  18.275 ms    0/   75 (0%)
[  3]  3.0- 4.0 sec    106 KBytes    870 Kbits/sec  39.404 ms    0/   74 (0%)
[  3]  4.0- 5.0 sec    108 KBytes    882 Kbits/sec  27.725 ms    0/   75 (0%)
[  3]  5.0- 6.0 sec    108 KBytes    882 Kbits/sec  21.480 ms    0/   75 (0%)
[  3]  6.0- 7.0 sec    106 KBytes    870 Kbits/sec  18.883 ms    0/   74 (0%)
[  3]  7.0- 8.0 sec    109 KBytes    894 Kbits/sec  34.303 ms    0/   76 (0%)
[  3]  8.0- 9.0 sec    109 KBytes    894 Kbits/sec  24.028 ms    0/   76 (0%)
[  3]  9.0-10.0 sec    106 KBytes    870 Kbits/sec  19.903 ms    0/   74 (0%)
[  3] 10.0-11.0 sec    109 KBytes    894 Kbits/sec  41.994 ms    0/   76 (0%)
[  3] 11.0-12.0 sec    109 KBytes    894 Kbits/sec  28.307 ms    0/   76 (0%)
[  3] 12.0-13.0 sec    106 KBytes    870 Kbits/sec  22.669 ms    0/   74 (0%)
[  3] 13.0-14.0 sec    108 KBytes    882 Kbits/sec  18.358 ms    0/   75 (0%)
[  3] 14.0-15.0 sec    109 KBytes    894 Kbits/sec  35.580 ms    0/   76 (0%)
[  3] 15.0-16.0 sec    108 KBytes    882 Kbits/sec  25.767 ms    0/   75 (0%)
[  3] 16.0-17.0 sec    106 KBytes    870 Kbits/sec  21.180 ms    0/   74 (0%)
[  3] 17.0-18.0 sec    106 KBytes    870 Kbits/sec  17.949 ms    0/   74 (0%)
[  3] 18.0-19.0 sec    106 KBytes    870 Kbits/sec  35.777 ms    0/   74 (0%)
[  3] 19.0-20.0 sec    108 KBytes    882 Kbits/sec  25.847 ms    0/   75 (0%)
[  3] 20.0-21.0 sec    108 KBytes    882 Kbits/sec  20.102 ms    0/   75 (0%)
[  3] 21.0-22.0 sec    109 KBytes    894 Kbits/sec  16.769 ms    0/   76 (0%)
[  3] 22.0-23.0 sec    109 KBytes    894 Kbits/sec  29.286 ms    0/   76 (0%)
[  3] 23.0-24.0 sec    109 KBytes    894 Kbits/sec  21.612 ms    0/   76 (0%)
[  3] 24.0-25.0 sec    108 KBytes    882 Kbits/sec  17.813 ms    0/   75 (0%)
[  3] 25.0-26.0 sec    109 KBytes    894 Kbits/sec  33.985 ms    0/   76 (0%)
[  3] 26.0-27.0 sec    106 KBytes    870 Kbits/sec  26.606 ms    0/   74 (0%)
[  3] 27.0-28.0 sec    106 KBytes    870 Kbits/sec  21.156 ms    0/   74 (0%)
[  3] 28.0-29.0 sec    108 KBytes    882 Kbits/sec  18.012 ms    0/   75 (0%)
[  3] 29.0-30.0 sec    108 KBytes    882 Kbits/sec  32.733 ms    0/   75 (0%)
[  3] 30.0-31.0 sec    109 KBytes    894 Kbits/sec  23.418 ms    0/   76 (0%)
[  3] 31.0-32.0 sec    108 KBytes    882 Kbits/sec  18.921 ms    0/   75 (0%)
[  3] 32.0-33.0 sec    108 KBytes    882 Kbits/sec  40.147 ms    0/   75 (0%)
[  3] 33.0-34.0 sec    109 KBytes    894 Kbits/sec  27.288 ms    0/   76 (0%)
[  3] 34.0-35.0 sec    109 KBytes    894 Kbits/sec  20.471 ms    0/   76 (0%)
[  3] 35.0-36.0 sec    108 KBytes    882 Kbits/sec  17.623 ms    0/   75 (0%)
[  3] 36.0-37.0 sec    109 KBytes    894 Kbits/sec  31.486 ms    0/   76 (0%)
[  3] 37.0-38.0 sec    109 KBytes    894 Kbits/sec  22.784 ms    0/   76 (0%)
[  3] 38.0-39.0 sec    109 KBytes    894 Kbits/sec  18.150 ms    0/   76 (0%)
[  3] 39.0-40.0 sec    109 KBytes    894 Kbits/sec  35.253 ms    0/   76 (0%)
[  3] 40.0-41.0 sec    103 KBytes    847 Kbits/sec  29.593 ms    0/   72 (0%)
[  3] 41.0-42.0 sec    108 KBytes    882 Kbits/sec  21.835 ms    0/   75 (0%)
[  3] 42.0-43.0 sec    108 KBytes    882 Kbits/sec  18.173 ms    0/   75 (0%)
[  3] 43.0-44.0 sec    109 KBytes    894 Kbits/sec  34.021 ms    0/   76 (0%)
[  3] 44.0-45.0 sec    109 KBytes    894 Kbits/sec  24.144 ms    0/   76 (0%)
[  3] 45.0-46.0 sec    108 KBytes    882 Kbits/sec  19.291 ms    0/   75 (0%)
[  3] 46.0-47.0 sec    108 KBytes    882 Kbits/sec  42.682 ms    0/   75 (0%)
[  3] 47.0-48.0 sec    105 KBytes    858 Kbits/sec  32.320 ms    0/   73 (0%)
[  3] 48.0-49.0 sec    109 KBytes    894 Kbits/sec  22.861 ms    0/   76 (0%)
[  3] 49.0-50.0 sec    109 KBytes    894 Kbits/sec  18.203 ms    0/   76 (0%)
[  3] 50.0-51.0 sec    109 KBytes    894 Kbits/sec  35.487 ms    0/   76 (0%)
[  3] 51.0-52.0 sec    106 KBytes    870 Kbits/sec  26.665 ms    0/   74 (0%)
[  3] 52.0-53.0 sec    108 KBytes    882 Kbits/sec  21.349 ms    0/   75 (0%)
[  3] 53.0-54.0 sec    109 KBytes    894 Kbits/sec  17.185 ms    0/   76 (0%)
[  3] 54.0-55.0 sec    108 KBytes    882 Kbits/sec  30.991 ms    0/   75 (0%)
[  3] 55.0-56.0 sec    109 KBytes    894 Kbits/sec  22.754 ms    0/   76 (0%)
[  3] 56.0-57.0 sec    109 KBytes    894 Kbits/sec  18.139 ms    0/   76 (0%)
[  3] 57.0-58.0 sec    106 KBytes    870 Kbits/sec  39.086 ms    0/   74 (0%)
[  3] 58.0-59.0 sec    109 KBytes    894 Kbits/sec  26.425 ms    0/   76 (0%)
[  3] 59.0-60.0 sec    109 KBytes    894 Kbits/sec  20.040 ms    0/   76 (0%)
[  3]  0.0-60.6 sec  6.39 MBytes    884 Kbits/sec  40.237 ms   10/ 4566 (0.22%)
[  3]  0.0-60.6 sec  1 datagrams received out-of-order

5413 - locked at 24M
--------------------

------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:   114 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.1 port 5001 connected with 192.168.254.253 port 52228
[  3]  0.0- 1.0 sec  1.86 MBytes  15.6 Mbits/sec  2.076 ms    0/ 1330 (0%)
[  3]  1.0- 2.0 sec  1.90 MBytes  15.9 Mbits/sec  1.897 ms    0/ 1354 (0%)
[  3]  2.0- 3.0 sec  1.79 MBytes  15.0 Mbits/sec  1.680 ms    0/ 1279 (0%)
[  3]  3.0- 4.0 sec  1.87 MBytes  15.7 Mbits/sec  2.079 ms    0/ 1337 (0%)
[  3]  4.0- 5.0 sec  1.89 MBytes  15.9 Mbits/sec  0.974 ms    0/ 1351 (0%)
[  3]  5.0- 6.0 sec  1.92 MBytes  16.1 Mbits/sec  1.950 ms    1/ 1369 (0.073%)
[  3]  6.0- 7.0 sec  1.89 MBytes  15.9 Mbits/sec  1.266 ms    0/ 1348 (0%)
[  3]  7.0- 8.0 sec  1.89 MBytes  15.9 Mbits/sec  1.312 ms    0/ 1349 (0%)
[  3]  8.0- 9.0 sec  1.85 MBytes  15.5 Mbits/sec  2.175 ms    0/ 1320 (0%)
[  3]  9.0-10.0 sec  1.89 MBytes  15.9 Mbits/sec  0.989 ms    0/ 1349 (0%)
[  3] 10.0-11.0 sec  1.90 MBytes  16.0 Mbits/sec  1.526 ms    0/ 1357 (0%)
[  3] 11.0-12.0 sec  1.91 MBytes  16.0 Mbits/sec  1.637 ms    0/ 1361 (0%)
[  3] 12.0-13.0 sec  1.89 MBytes  15.9 Mbits/sec  1.860 ms    0/ 1350 (0%)
[  3] 13.0-14.0 sec  1.91 MBytes  16.0 Mbits/sec  1.276 ms    0/ 1359 (0%)
[  3] 14.0-15.0 sec  1.86 MBytes  15.6 Mbits/sec  1.993 ms    0/ 1329 (0%)
[  3] 15.0-16.0 sec  1.79 MBytes  15.0 Mbits/sec  1.056 ms    0/ 1274 (0%)
[  3] 16.0-17.0 sec  1.75 MBytes  14.7 Mbits/sec  1.661 ms    0/ 1251 (0%)
[  3] 17.0-18.0 sec  1.63 MBytes  13.7 Mbits/sec  1.495 ms    0/ 1162 (0%)
[  3] 18.0-19.0 sec  1.70 MBytes  14.3 Mbits/sec  1.059 ms    1/ 1213 (0.082%)
[  3] 19.0-20.0 sec  1.71 MBytes  14.3 Mbits/sec  1.994 ms    0/ 1218 (0%)
[  3] 20.0-21.0 sec  1.68 MBytes  14.1 Mbits/sec  1.528 ms    0/ 1198 (0%)
[  3] 21.0-22.0 sec  1.62 MBytes  13.6 Mbits/sec  1.647 ms    0/ 1156 (0%)
[  3] 22.0-23.0 sec  1.66 MBytes  14.0 Mbits/sec  1.779 ms    0/ 1187 (0%)
[  3] 23.0-24.0 sec  1.70 MBytes  14.2 Mbits/sec  2.449 ms    0/ 1210 (0%)
[  3] 24.0-25.0 sec  1.74 MBytes  14.6 Mbits/sec  1.990 ms    0/ 1238 (0%)
[  3] 25.0-26.0 sec  1.85 MBytes  15.5 Mbits/sec  1.678 ms    0/ 1321 (0%)
[  3] 26.0-27.0 sec  1.87 MBytes  15.7 Mbits/sec  1.130 ms    0/ 1332 (0%)
[  3] 27.0-28.0 sec  1.93 MBytes  16.2 Mbits/sec  1.914 ms    0/ 1377 (0%)
[  3] 28.0-29.0 sec  1.89 MBytes  15.8 Mbits/sec  1.259 ms    0/ 1347 (0%)
[  3] 29.0-30.0 sec  1.90 MBytes  15.9 Mbits/sec  1.592 ms    0/ 1354 (0%)
[  3] 30.0-31.0 sec  1.86 MBytes  15.6 Mbits/sec  1.274 ms    0/ 1329 (0%)
[  3] 31.0-32.0 sec  1.88 MBytes  15.8 Mbits/sec  0.979 ms    0/ 1342 (0%)
[  3] 32.0-33.0 sec  1.88 MBytes  15.7 Mbits/sec  1.299 ms    0/ 1339 (0%)
[  3] 33.0-34.0 sec  1.87 MBytes  15.7 Mbits/sec  1.074 ms    0/ 1335 (0%)
[  3] 34.0-35.0 sec  1.86 MBytes  15.6 Mbits/sec  2.409 ms    0/ 1327 (0%)
[  3] 35.0-36.0 sec  1.91 MBytes  16.0 Mbits/sec  1.501 ms    0/ 1360 (0%)
[  3] 36.0-37.0 sec  1.88 MBytes  15.7 Mbits/sec  2.250 ms    0/ 1339 (0%)
[  3] 37.0-38.0 sec  1.88 MBytes  15.8 Mbits/sec  0.934 ms    0/ 1344 (0%)
[  3] 38.0-39.0 sec  1.89 MBytes  15.9 Mbits/sec  1.000 ms    0/ 1350 (0%)
[  3] 39.0-40.0 sec  1.84 MBytes  15.4 Mbits/sec  0.951 ms    0/ 1310 (0%)
[  3] 40.0-41.0 sec  1.88 MBytes  15.8 Mbits/sec  1.438 ms    0/ 1344 (0%)
[  3] 41.0-42.0 sec  1.87 MBytes  15.7 Mbits/sec  0.951 ms    0/ 1332 (0%)
[  3] 42.0-43.0 sec  1.88 MBytes  15.8 Mbits/sec  1.024 ms    0/ 1343 (0%)
[  3] 43.0-44.0 sec  1.89 MBytes  15.8 Mbits/sec  1.061 ms    0/ 1346 (0%)
[  3] 44.0-45.0 sec  1.88 MBytes  15.8 Mbits/sec  0.833 ms    0/ 1344 (0%)
[  3] 45.0-46.0 sec  1.88 MBytes  15.8 Mbits/sec  1.193 ms    0/ 1344 (0%)
[  3] 46.0-47.0 sec  1.91 MBytes  16.0 Mbits/sec  1.731 ms    0/ 1360 (0%)
[  3] 47.0-48.0 sec  1.83 MBytes  15.4 Mbits/sec  1.839 ms    0/ 1306 (0%)
[  3] 48.0-49.0 sec  1.80 MBytes  15.1 Mbits/sec  1.234 ms    0/ 1282 (0%)
[  3] 49.0-50.0 sec  1.31 MBytes  11.0 Mbits/sec  1.719 ms    0/  936 (0%)
[  3] 50.0-51.0 sec  1.60 MBytes  13.4 Mbits/sec  0.929 ms    0/ 1141 (0%)
[  3] 51.0-52.0 sec  1.72 MBytes  14.5 Mbits/sec  1.392 ms    0/ 1230 (0%)
[  3] 52.0-53.0 sec  1.86 MBytes  15.6 Mbits/sec  1.064 ms    0/ 1324 (0%)
[  3] 53.0-54.0 sec  1.95 MBytes  16.4 Mbits/sec  1.135 ms    0/ 1391 (0%)
[  3] 54.0-55.0 sec  1.92 MBytes  16.1 Mbits/sec  1.976 ms    0/ 1368 (0%)
[  3] 55.0-56.0 sec  1.79 MBytes  15.0 Mbits/sec  1.960 ms    0/ 1275 (0%)
[  3] 56.0-57.0 sec  1.89 MBytes  15.9 Mbits/sec  1.510 ms    0/ 1350 (0%)
[  3] 57.0-58.0 sec  1.89 MBytes  15.8 Mbits/sec  1.979 ms    0/ 1346 (0%)
[  3] 58.0-59.0 sec  1.90 MBytes  15.9 Mbits/sec  2.356 ms    0/ 1355 (0%)
[  3] 59.0-60.0 sec  1.90 MBytes  16.0 Mbits/sec  1.232 ms    0/ 1357 (0%)
[  3]  0.0-60.0 sec    110 MBytes  15.4 Mbits/sec  2.022 ms    2/78460 (0.0025%)


buggy 5213 - new
----------------

------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:   114 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.1 port 5001 connected with 192.168.254.253 port 54518
[  3]  0.0- 1.0 sec    106 KBytes    870 Kbits/sec  28.986 ms    0/   74 (0%)
[  3]  1.0- 2.0 sec    109 KBytes    894 Kbits/sec  22.215 ms    0/   76 (0%)
[  3]  2.0- 3.0 sec    108 KBytes    882 Kbits/sec  18.270 ms    0/   75 (0%)
[  3]  3.0- 4.0 sec    109 KBytes    894 Kbits/sec  35.364 ms    0/   76 (0%)
[  3]  4.0- 5.0 sec    109 KBytes    894 Kbits/sec  24.852 ms    0/   76 (0%)
[  3]  5.0- 6.0 sec    109 KBytes    894 Kbits/sec  19.227 ms    0/   76 (0%)
[  3]  6.0- 7.0 sec    108 KBytes    882 Kbits/sec  43.108 ms    0/   75 (0%)
[  3]  7.0- 8.0 sec    108 KBytes    882 Kbits/sec  29.529 ms    0/   75 (0%)
[  3]  8.0- 9.0 sec    108 KBytes    882 Kbits/sec  22.474 ms    0/   75 (0%)
[  3]  9.0-10.0 sec    108 KBytes    882 Kbits/sec  18.301 ms    0/   75 (0%)
[  3] 10.0-11.0 sec    108 KBytes    882 Kbits/sec  37.304 ms    0/   75 (0%)
[  3] 11.0-12.0 sec    108 KBytes    882 Kbits/sec  26.654 ms    0/   75 (0%)
[  3] 12.0-13.0 sec    108 KBytes    882 Kbits/sec  20.756 ms    0/   75 (0%)
[  3] 13.0-14.0 sec    108 KBytes    882 Kbits/sec  17.599 ms    0/   75 (0%)
[  3] 14.0-15.0 sec    109 KBytes    894 Kbits/sec  31.706 ms    0/   76 (0%)
[  3] 15.0-16.0 sec    108 KBytes    882 Kbits/sec  23.543 ms    0/   75 (0%)
[  3] 16.0-17.0 sec    109 KBytes    894 Kbits/sec  18.614 ms    0/   76 (0%)
[  3] 17.0-18.0 sec    108 KBytes    882 Kbits/sec  38.622 ms    0/   75 (0%)
[  3] 18.0-19.0 sec    108 KBytes    882 Kbits/sec  27.565 ms    0/   75 (0%)
[  3] 19.0-20.0 sec    109 KBytes    894 Kbits/sec  20.734 ms    0/   76 (0%)
[  3] 20.0-21.0 sec    108 KBytes    882 Kbits/sec  17.491 ms    0/   75 (0%)
[  3] 21.0-22.0 sec    109 KBytes    894 Kbits/sec  31.622 ms    0/   76 (0%)
[  3] 22.0-23.0 sec    105 KBytes    858 Kbits/sec  25.122 ms    0/   73 (0%)
[  3] 23.0-24.0 sec    106 KBytes    870 Kbits/sec  20.350 ms    0/   74 (0%)
[  3] 24.0-25.0 sec    108 KBytes    882 Kbits/sec  17.260 ms    0/   75 (0%)
[  3] 25.0-26.0 sec    108 KBytes    882 Kbits/sec  31.625 ms    0/   75 (0%)
[  3] 26.0-27.0 sec    109 KBytes    894 Kbits/sec  22.704 ms    0/   76 (0%)
[  3] 27.0-28.0 sec    109 KBytes    894 Kbits/sec  18.222 ms    0/   76 (0%)
[  3] 28.0-29.0 sec    108 KBytes    882 Kbits/sec  37.273 ms    0/   75 (0%)
[  3] 29.0-30.0 sec    108 KBytes    882 Kbits/sec  26.877 ms    0/   75 (0%)
[  3] 30.0-31.0 sec    109 KBytes    894 Kbits/sec  20.289 ms    0/   76 (0%)
[  3] 31.0-32.0 sec    108 KBytes    882 Kbits/sec  17.130 ms    0/   75 (0%)
[  3] 32.0-33.0 sec    109 KBytes    894 Kbits/sec  30.488 ms    0/   76 (0%)
[  3] 33.0-34.0 sec    109 KBytes    894 Kbits/sec  22.206 ms    0/   76 (0%)
[  3] 34.0-35.0 sec    108 KBytes    882 Kbits/sec  18.197 ms    0/   75 (0%)
[  3] 35.0-36.0 sec    109 KBytes    894 Kbits/sec  35.741 ms    0/   76 (0%)
[  3] 36.0-37.0 sec    108 KBytes    882 Kbits/sec  25.775 ms    0/   75 (0%)
[  3] 37.0-38.0 sec    109 KBytes    894 Kbits/sec  19.618 ms    0/   76 (0%)
[  3] 38.0-39.0 sec    108 KBytes    882 Kbits/sec  16.985 ms    0/   75 (0%)
[  3] 39.0-40.0 sec    109 KBytes    894 Kbits/sec  29.361 ms    0/   76 (0%)
[  3] 40.0-41.0 sec    108 KBytes    882 Kbits/sec  22.500 ms    0/   75 (0%)
[  3] 41.0-42.0 sec    108 KBytes    882 Kbits/sec  18.246 ms    0/   75 (0%)
[  3] 42.0-43.0 sec    108 KBytes    882 Kbits/sec  36.884 ms    0/   75 (0%)
[  3] 43.0-44.0 sec    109 KBytes    894 Kbits/sec  25.659 ms    0/   76 (0%)
[  3] 44.0-45.0 sec    109 KBytes    894 Kbits/sec  19.738 ms    0/   76 (0%)
[  3] 45.0-46.0 sec    109 KBytes    894 Kbits/sec  41.998 ms    0/   76 (0%)
[  3] 46.0-47.0 sec    109 KBytes    894 Kbits/sec  28.284 ms    0/   76 (0%)
[  3] 47.0-48.0 sec    109 KBytes    894 Kbits/sec  21.218 ms    0/   76 (0%)
[  3] 48.0-49.0 sec    109 KBytes    894 Kbits/sec  17.364 ms    0/   76 (0%)
[  3] 49.0-50.0 sec    109 KBytes    894 Kbits/sec  31.410 ms    0/   76 (0%)
[  3] 50.0-51.0 sec    108 KBytes    882 Kbits/sec  23.454 ms    0/   75 (0%)
[  3] 51.0-52.0 sec    109 KBytes    894 Kbits/sec  18.596 ms    0/   76 (0%)
[  3] 52.0-53.0 sec    109 KBytes    894 Kbits/sec  37.050 ms    0/   76 (0%)
[  3] 53.0-54.0 sec    108 KBytes    882 Kbits/sec  26.519 ms    0/   75 (0%)
[  3] 54.0-55.0 sec    108 KBytes    882 Kbits/sec  20.822 ms    0/   75 (0%)
[  3] 55.0-56.0 sec    109 KBytes    894 Kbits/sec  17.169 ms    0/   76 (0%)
[  3] 56.0-57.0 sec    108 KBytes    882 Kbits/sec  31.968 ms    0/   75 (0%)
[  3] 57.0-58.0 sec    108 KBytes    882 Kbits/sec  23.726 ms    0/   75 (0%)
[  3] 58.0-59.0 sec    106 KBytes    870 Kbits/sec  19.529 ms    0/   74 (0%)
[  3] 59.0-60.0 sec    106 KBytes    870 Kbits/sec  16.992 ms    0/   74 (0%)
[  3]  0.0-60.5 sec  6.39 MBytes    886 Kbits/sec  40.698 ms    0/ 4555 (0%)


buggy 5213 - old
----------------

------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:   114 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.1 port 5001 connected with 192.168.254.253 port 39925
[  3]  0.0- 1.0 sec    105 KBytes    858 Kbits/sec  28.859 ms    0/   73 (0%)
[  3]  1.0- 2.0 sec    109 KBytes    894 Kbits/sec  22.118 ms    0/   76 (0%)
[  3]  2.0- 3.0 sec    111 KBytes    906 Kbits/sec  17.487 ms    0/   77 (0%)
[  3]  3.0- 4.0 sec    109 KBytes    894 Kbits/sec  32.625 ms    0/   76 (0%)
[  3]  4.0- 5.0 sec    109 KBytes    894 Kbits/sec  23.307 ms    0/   76 (0%)
[  3]  5.0- 6.0 sec    109 KBytes    894 Kbits/sec  18.435 ms    0/   76 (0%)
[  3]  6.0- 7.0 sec    111 KBytes    906 Kbits/sec  35.235 ms    0/   77 (0%)
[  3]  7.0- 8.0 sec    109 KBytes    894 Kbits/sec  24.753 ms    0/   76 (0%)
[  3]  8.0- 9.0 sec    109 KBytes    894 Kbits/sec  19.179 ms    0/   76 (0%)
[  3]  9.0-10.0 sec    111 KBytes    906 Kbits/sec  38.414 ms    0/   77 (0%)
[  3] 10.0-11.0 sec    109 KBytes    894 Kbits/sec  26.320 ms    0/   76 (0%)
[  3] 11.0-12.0 sec    109 KBytes    894 Kbits/sec  20.114 ms    0/   76 (0%)
[  3] 12.0-13.0 sec    109 KBytes    894 Kbits/sec  16.729 ms    0/   76 (0%)
[  3] 13.0-14.0 sec    109 KBytes    894 Kbits/sec  29.206 ms    0/   76 (0%)
[  3] 14.0-15.0 sec    109 KBytes    894 Kbits/sec  22.261 ms    0/   76 (0%)
[  3] 15.0-16.0 sec    109 KBytes    894 Kbits/sec  17.665 ms    0/   76 (0%)
[  3] 16.0-17.0 sec    108 KBytes    882 Kbits/sec  34.128 ms    0/   75 (0%)
[  3] 17.0-18.0 sec    109 KBytes    894 Kbits/sec  24.078 ms    0/   76 (0%)
[  3] 18.0-19.0 sec    111 KBytes    906 Kbits/sec  18.414 ms    0/   77 (0%)
[  3] 19.0-20.0 sec    109 KBytes    894 Kbits/sec  36.801 ms    0/   76 (0%)
[  3] 20.0-21.0 sec    109 KBytes    894 Kbits/sec  25.608 ms    0/   76 (0%)
[  3] 21.0-22.0 sec    111 KBytes    906 Kbits/sec  19.220 ms    0/   77 (0%)
[  3] 22.0-23.0 sec    109 KBytes    894 Kbits/sec  38.542 ms    0/   76 (0%)
[  3] 23.0-24.0 sec    109 KBytes    894 Kbits/sec  27.278 ms    0/   76 (0%)
[  3] 24.0-25.0 sec    109 KBytes    894 Kbits/sec  20.543 ms    0/   76 (0%)
[  3] 25.0-26.0 sec    109 KBytes    894 Kbits/sec  17.029 ms    0/   76 (0%)
[  3] 26.0-27.0 sec    109 KBytes    894 Kbits/sec  30.219 ms    0/   76 (0%)
[  3] 27.0-28.0 sec    111 KBytes    906 Kbits/sec  21.563 ms    0/   77 (0%)
[  3] 28.0-29.0 sec    109 KBytes    894 Kbits/sec  17.574 ms    0/   76 (0%)
[  3] 29.0-30.0 sec    109 KBytes    894 Kbits/sec  32.626 ms    0/   76 (0%)
[  3] 30.0-31.0 sec    106 KBytes    870 Kbits/sec  25.459 ms    0/   74 (0%)
[  3] 31.0-32.0 sec    109 KBytes    894 Kbits/sec  19.353 ms    0/   76 (0%)
[  3] 32.0-33.0 sec    109 KBytes    894 Kbits/sec  40.229 ms    0/   76 (0%)
[  3] 33.0-34.0 sec    108 KBytes    882 Kbits/sec  28.182 ms    0/   75 (0%)
[  3] 34.0-35.0 sec    109 KBytes    894 Kbits/sec  21.184 ms    0/   76 (0%)
[  3] 35.0-36.0 sec    108 KBytes    882 Kbits/sec  17.722 ms    0/   75 (0%)
[  3] 36.0-37.0 sec    109 KBytes    894 Kbits/sec  32.773 ms    0/   76 (0%)
[  3] 37.0-38.0 sec    108 KBytes    882 Kbits/sec  24.356 ms    0/   75 (0%)
[  3] 38.0-39.0 sec    109 KBytes    894 Kbits/sec  18.992 ms    0/   76 (0%)
[  3] 39.0-40.0 sec    109 KBytes    894 Kbits/sec  38.837 ms    0/   76 (0%)
[  3] 40.0-41.0 sec    108 KBytes    882 Kbits/sec  27.703 ms    0/   75 (0%)
[  3] 41.0-42.0 sec    109 KBytes    894 Kbits/sec  20.723 ms    0/   76 (0%)
[  3] 42.0-43.0 sec    109 KBytes    894 Kbits/sec  17.044 ms    0/   76 (0%)
[  3] 43.0-44.0 sec    109 KBytes    894 Kbits/sec  30.279 ms    0/   76 (0%)
[  3] 44.0-45.0 sec    109 KBytes    894 Kbits/sec  22.083 ms    0/   76 (0%)
[  3] 45.0-46.0 sec    109 KBytes    894 Kbits/sec  17.835 ms    0/   76 (0%)
[  3] 46.0-47.0 sec    109 KBytes    894 Kbits/sec  34.045 ms    0/   76 (0%)
[  3] 47.0-48.0 sec    109 KBytes    894 Kbits/sec  24.038 ms    0/   76 (0%)
[  3] 48.0-49.0 sec    109 KBytes    894 Kbits/sec  18.827 ms    0/   76 (0%)
[  3] 49.0-50.0 sec    109 KBytes    894 Kbits/sec  38.538 ms    0/   76 (0%)
[  3] 50.0-51.0 sec    111 KBytes    906 Kbits/sec  25.513 ms    0/   77 (0%)
[  3] 51.0-52.0 sec    109 KBytes    894 Kbits/sec  19.665 ms    0/   76 (0%)
[  3] 52.0-53.0 sec    109 KBytes    894 Kbits/sec  41.888 ms    0/   76 (0%)
[  3] 53.0-54.0 sec    109 KBytes    894 Kbits/sec  28.206 ms    0/   76 (0%)
[  3] 54.0-55.0 sec    109 KBytes    894 Kbits/sec  21.016 ms    0/   76 (0%)
[  3] 55.0-56.0 sec    109 KBytes    894 Kbits/sec  17.303 ms    0/   76 (0%)
[  3] 56.0-57.0 sec    111 KBytes    906 Kbits/sec  30.269 ms    0/   77 (0%)
[  3] 57.0-58.0 sec    109 KBytes    894 Kbits/sec  22.099 ms    0/   76 (0%)
[  3] 58.0-59.0 sec    109 KBytes    894 Kbits/sec  17.931 ms    0/   76 (0%)
[  3] 59.0-60.0 sec    109 KBytes    894 Kbits/sec  33.954 ms    0/   76 (0%)
[  3]  0.0-60.8 sec  6.48 MBytes    893 Kbits/sec  40.233 ms    0/ 4619 (0%)
[  3]  0.0-60.8 sec  1 datagrams received out-of-order
read failed: Connection refused

buggy 5213 - locked at 18M
--------------------------

------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size:   114 KByte (default)
------------------------------------------------------------
[  3] local 192.168.254.1 port 5001 connected with 192.168.254.253 port 47165
[  3]  0.0- 1.0 sec    973 KBytes  7.97 Mbits/sec  4.058 ms    0/  678 (0%)
[  3]  1.0- 2.0 sec  1.02 MBytes  8.55 Mbits/sec  2.260 ms    0/  727 (0%)
[  3]  2.0- 3.0 sec  1.02 MBytes  8.54 Mbits/sec  1.856 ms    0/  726 (0%)
[  3]  3.0- 4.0 sec  1.04 MBytes  8.75 Mbits/sec  1.752 ms    0/  744 (0%)
[  3]  4.0- 5.0 sec  1.01 MBytes  8.47 Mbits/sec  4.400 ms    0/  720 (0%)
[  3]  5.0- 6.0 sec  1.03 MBytes  8.61 Mbits/sec  1.713 ms    0/  732 (0%)
[  3]  6.0- 7.0 sec  1.30 MBytes  10.9 Mbits/sec  1.638 ms    0/  924 (0%)
[  3]  7.0- 8.0 sec  1.29 MBytes  10.8 Mbits/sec  1.343 ms    0/  922 (0%)
[  3]  8.0- 9.0 sec  1.30 MBytes  10.9 Mbits/sec  3.195 ms    0/  928 (0%)
[  3]  9.0-10.0 sec  1.32 MBytes  11.1 Mbits/sec  2.185 ms    0/  940 (0%)
[  3] 10.0-11.0 sec  1.32 MBytes  11.1 Mbits/sec  1.282 ms    0/  942 (0%)
[  3] 11.0-12.0 sec  1.31 MBytes  11.0 Mbits/sec  3.269 ms    0/  936 (0%)
[  3] 12.0-13.0 sec  1.31 MBytes  11.0 Mbits/sec  1.962 ms    0/  936 (0%)
[  3] 13.0-14.0 sec  1.31 MBytes  11.0 Mbits/sec  1.195 ms    0/  937 (0%)
[  3] 14.0-15.0 sec  1.32 MBytes  11.1 Mbits/sec  2.992 ms    0/  944 (0%)
[  3] 15.0-16.0 sec  1.30 MBytes  10.9 Mbits/sec  3.041 ms    0/  926 (0%)
[  3] 16.0-17.0 sec  1.31 MBytes  11.0 Mbits/sec  2.477 ms    0/  936 (0%)
[  3] 17.0-18.0 sec  1.32 MBytes  11.1 Mbits/sec  1.744 ms    0/  940 (0%)
[  3] 18.0-19.0 sec  1.31 MBytes  11.0 Mbits/sec  1.581 ms    0/  937 (0%)
[  3] 19.0-20.0 sec  1.34 MBytes  11.2 Mbits/sec  1.471 ms    0/  956 (0%)
[  3] 20.0-21.0 sec  1.31 MBytes  11.0 Mbits/sec  1.629 ms    0/  933 (0%)
[  3] 21.0-22.0 sec  1.37 MBytes  11.5 Mbits/sec  2.259 ms    0/  977 (0%)
[  3] 22.0-23.0 sec  1.40 MBytes  11.7 Mbits/sec  2.398 ms    0/  996 (0%)
[  3] 23.0-24.0 sec  1.39 MBytes  11.6 Mbits/sec  3.008 ms    0/  988 (0%)
[  3] 24.0-25.0 sec  1.41 MBytes  11.8 Mbits/sec  2.801 ms    0/ 1004 (0%)
[  3] 25.0-26.0 sec  1.39 MBytes  11.7 Mbits/sec  1.777 ms    0/  994 (0%)
[  3] 26.0-27.0 sec  1.38 MBytes  11.6 Mbits/sec  2.815 ms    0/  986 (0%)
[  3] 27.0-28.0 sec  1.38 MBytes  11.5 Mbits/sec  1.334 ms    0/  982 (0%)
[  3] 28.0-29.0 sec  1.37 MBytes  11.5 Mbits/sec  1.874 ms    0/  980 (0%)
[  3] 29.0-30.0 sec  1.39 MBytes  11.7 Mbits/sec  1.801 ms    0/  995 (0%)
[  3] 30.0-31.0 sec  1.38 MBytes  11.6 Mbits/sec  1.018 ms    0/  983 (0%)
[  3] 31.0-32.0 sec  1.36 MBytes  11.4 Mbits/sec  1.483 ms    0/  968 (0%)
[  3] 32.0-33.0 sec  1.38 MBytes  11.5 Mbits/sec  1.919 ms    0/  981 (0%)
[  3] 33.0-34.0 sec  1.38 MBytes  11.5 Mbits/sec  1.248 ms    0/  982 (0%)
[  3] 34.0-35.0 sec  1.39 MBytes  11.7 Mbits/sec  1.649 ms    0/  994 (0%)
[  3] 35.0-36.0 sec  1.36 MBytes  11.4 Mbits/sec  1.479 ms    0/  973 (0%)
[  3] 36.0-37.0 sec  1.31 MBytes  11.0 Mbits/sec  2.953 ms    0/  936 (0%)
[  3] 37.0-38.0 sec  1.31 MBytes  11.0 Mbits/sec  1.862 ms    0/  934 (0%)
[  3] 38.0-39.0 sec  1.33 MBytes  11.2 Mbits/sec  2.341 ms    0/  950 (0%)
[  3] 39.0-40.0 sec  1.30 MBytes  10.9 Mbits/sec  2.196 ms    0/  926 (0%)
[  3] 40.0-41.0 sec  1.14 MBytes  9.60 Mbits/sec  2.827 ms    0/  816 (0%)
[  3] 41.0-42.0 sec  1.17 MBytes  9.80 Mbits/sec  2.091 ms    0/  833 (0%)
[  3] 42.0-43.0 sec  1.12 MBytes  9.42 Mbits/sec  2.489 ms    0/  801 (0%)
[  3] 43.0-44.0 sec  1.08 MBytes  9.06 Mbits/sec  1.849 ms    0/  770 (0%)
[  3] 44.0-45.0 sec  1.14 MBytes  9.57 Mbits/sec  3.914 ms    0/  814 (0%)
[  3] 45.0-46.0 sec  1.16 MBytes  9.73 Mbits/sec  1.979 ms    0/  827 (0%)
[  3] 46.0-47.0 sec  1.32 MBytes  11.0 Mbits/sec  1.560 ms    0/  939 (0%)
[  3] 47.0-48.0 sec  1.29 MBytes  10.9 Mbits/sec  1.514 ms    0/  923 (0%)
[  3] 48.0-49.0 sec  1.30 MBytes  10.9 Mbits/sec  1.651 ms    0/  930 (0%)
[  3] 49.0-50.0 sec  1.31 MBytes  11.0 Mbits/sec  1.273 ms    0/  935 (0%)
[  3] 50.0-51.0 sec  1.32 MBytes  11.1 Mbits/sec  2.045 ms    0/  940 (0%)
[  3] 51.0-52.0 sec  1.31 MBytes  11.0 Mbits/sec  1.331 ms    0/  938 (0%)
[  3] 52.0-53.0 sec  1.30 MBytes  10.9 Mbits/sec  1.484 ms    0/  927 (0%)
[  3] 53.0-54.0 sec  1.37 MBytes  11.5 Mbits/sec  2.499 ms    0/  975 (0%)
[  3] 54.0-55.0 sec  1.41 MBytes  11.8 Mbits/sec  1.902 ms    0/ 1005 (0%)
[  3] 55.0-56.0 sec  1.42 MBytes  11.9 Mbits/sec  1.441 ms    0/ 1011 (0%)
[  3] 56.0-57.0 sec  1.42 MBytes  11.9 Mbits/sec  2.671 ms    0/ 1013 (0%)
[  3] 57.0-58.0 sec  1.41 MBytes  11.8 Mbits/sec  2.405 ms    0/ 1003 (0%)
[  3] 58.0-59.0 sec  1.42 MBytes  11.9 Mbits/sec  1.369 ms    0/ 1011 (0%)
[  3] 59.0-60.0 sec  1.42 MBytes  11.9 Mbits/sec  2.615 ms    0/ 1012 (0%)
[  3]  0.0-60.1 sec  77.6 MBytes  10.8 Mbits/sec  3.345 ms    0/55349 (0%)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
