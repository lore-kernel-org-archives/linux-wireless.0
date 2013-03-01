Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:38939 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3CAOda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 09:33:30 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	 boundary="l+3BVHpjL5"
Message-ID: <20784.48093.263373.125536@gargle.gargle.HOWL> (sfid-20130301_153336_423132_4B7EE702)
Date: Fri, 1 Mar 2013 20:01:57 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
In-Reply-To: <512EDDC5.7020901@openwrt.org>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20757.1753.863278.858198@gargle.gargle.HOWL>
	<511508A6.8020104@openwrt.org>
	<CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
	<51152D9E.1040106@openwrt.org>
	<20130227192030.GW12537@pogo>
	<CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com>
	<512ECE01.8010102@openwrt.org>
	<20782.54505.239733.82364@gargle.gargle.HOWL>
	<512EDDC5.7020901@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--l+3BVHpjL5
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

Felix Fietkau wrote:
> What was the distance and what was the rate used?

A distance of about a meter between the AP and STA.

AP:  DB120 - running an internal build.
STA: WB222 - wireless-testing HEAD.
Signal is about -43 dBm.
Channel 40, HT40-

I've attached sample runs with minstrel_ht and ath9k-rc. With minstrel_ht,
the numbers fluctuate between 180 and 190 Mbps and the average throughput
varies each time (185, 186 etc.). With ath9k-rc, it's 195+ always.

Sujith


--l+3BVHpjL5
Content-Type: text/plain;
	 name="ath9k-rc.txt"
Content-Description: ath9k-rc
Content-Disposition: inline;
	 filename="ath9k-rc.txt"
Content-Transfer-Encoding: 7bit

root@linux-test ~# iperf -i1 -c 172.16.1.222 -t 120 -P 4
------------------------------------------------------------
Client connecting to 172.16.1.222, TCP port 5001
TCP window size: 22.9 KByte (default)
------------------------------------------------------------
[  3] local 172.16.1.111 port 36815 connected with 172.16.1.222 port 5001
[  4] local 172.16.1.111 port 36816 connected with 172.16.1.222 port 5001
[  5] local 172.16.1.111 port 36817 connected with 172.16.1.222 port 5001
[  6] local 172.16.1.111 port 36818 connected with 172.16.1.222 port 5001

     19:[SUM]    0.0- 1.0 sec  22.8 MBytes   191 Mbits/sec
     24:[SUM]    1.0- 2.0 sec  23.0 MBytes   193 Mbits/sec
     29:[SUM]    2.0- 3.0 sec  23.6 MBytes   198 Mbits/sec
     34:[SUM]    3.0- 4.0 sec  22.9 MBytes   192 Mbits/sec
     39:[SUM]    4.0- 5.0 sec  23.2 MBytes   195 Mbits/sec
     44:[SUM]    5.0- 6.0 sec  22.6 MBytes   190 Mbits/sec
     49:[SUM]    6.0- 7.0 sec  23.2 MBytes   195 Mbits/sec
     54:[SUM]    7.0- 8.0 sec  23.8 MBytes   199 Mbits/sec
     59:[SUM]    8.0- 9.0 sec  23.1 MBytes   194 Mbits/sec
     64:[SUM]    9.0-10.0 sec  23.4 MBytes   196 Mbits/sec
     69:[SUM]   10.0-11.0 sec  23.0 MBytes   193 Mbits/sec
     74:[SUM]   11.0-12.0 sec  23.2 MBytes   195 Mbits/sec
     79:[SUM]   12.0-13.0 sec  22.8 MBytes   191 Mbits/sec
     84:[SUM]   13.0-14.0 sec  23.0 MBytes   193 Mbits/sec
     89:[SUM]   14.0-15.0 sec  23.1 MBytes   194 Mbits/sec
     94:[SUM]   15.0-16.0 sec  23.0 MBytes   193 Mbits/sec
     99:[SUM]   16.0-17.0 sec  22.5 MBytes   189 Mbits/sec
    104:[SUM]   17.0-18.0 sec  23.2 MBytes   195 Mbits/sec
    109:[SUM]   18.0-19.0 sec  23.4 MBytes   196 Mbits/sec
    114:[SUM]   19.0-20.0 sec  23.4 MBytes   196 Mbits/sec
    119:[SUM]   20.0-21.0 sec  22.9 MBytes   192 Mbits/sec
    124:[SUM]   21.0-22.0 sec  22.6 MBytes   190 Mbits/sec
    129:[SUM]   22.0-23.0 sec  23.4 MBytes   196 Mbits/sec
    134:[SUM]   23.0-24.0 sec  23.0 MBytes   193 Mbits/sec
    139:[SUM]   24.0-25.0 sec  22.6 MBytes   190 Mbits/sec
    144:[SUM]   25.0-26.0 sec  23.5 MBytes   197 Mbits/sec
    149:[SUM]   26.0-27.0 sec  23.1 MBytes   194 Mbits/sec
    154:[SUM]   27.0-28.0 sec  23.2 MBytes   195 Mbits/sec
    159:[SUM]   28.0-29.0 sec  23.8 MBytes   199 Mbits/sec
    164:[SUM]   29.0-30.0 sec  23.4 MBytes   196 Mbits/sec
    169:[SUM]   30.0-31.0 sec  22.8 MBytes   191 Mbits/sec
    174:[SUM]   31.0-32.0 sec  23.5 MBytes   197 Mbits/sec
    179:[SUM]   32.0-33.0 sec  22.8 MBytes   191 Mbits/sec
    184:[SUM]   33.0-34.0 sec  23.1 MBytes   194 Mbits/sec
    189:[SUM]   34.0-35.0 sec  23.2 MBytes   195 Mbits/sec
    194:[SUM]   35.0-36.0 sec  23.2 MBytes   195 Mbits/sec
    199:[SUM]   36.0-37.0 sec  23.1 MBytes   194 Mbits/sec
    204:[SUM]   37.0-38.0 sec  23.0 MBytes   193 Mbits/sec
    209:[SUM]   38.0-39.0 sec  23.2 MBytes   195 Mbits/sec
    214:[SUM]   39.0-40.0 sec  23.8 MBytes   199 Mbits/sec
    219:[SUM]   40.0-41.0 sec  23.0 MBytes   193 Mbits/sec
    224:[SUM]   41.0-42.0 sec  23.4 MBytes   196 Mbits/sec
    229:[SUM]   42.0-43.0 sec  23.5 MBytes   197 Mbits/sec
    234:[SUM]   43.0-44.0 sec  23.5 MBytes   197 Mbits/sec
    239:[SUM]   44.0-45.0 sec  22.6 MBytes   190 Mbits/sec
    244:[SUM]   45.0-46.0 sec  23.2 MBytes   195 Mbits/sec
    249:[SUM]   46.0-47.0 sec  23.2 MBytes   195 Mbits/sec
    254:[SUM]   47.0-48.0 sec  23.1 MBytes   194 Mbits/sec
    259:[SUM]   48.0-49.0 sec  24.1 MBytes   202 Mbits/sec
    264:[SUM]   49.0-50.0 sec  23.0 MBytes   193 Mbits/sec
    269:[SUM]   50.0-51.0 sec  23.4 MBytes   196 Mbits/sec
    274:[SUM]   51.0-52.0 sec  23.4 MBytes   196 Mbits/sec
    279:[SUM]   52.0-53.0 sec  23.4 MBytes   196 Mbits/sec
    284:[SUM]   53.0-54.0 sec  23.5 MBytes   197 Mbits/sec
    289:[SUM]   54.0-55.0 sec  23.2 MBytes   195 Mbits/sec
    294:[SUM]   55.0-56.0 sec  23.2 MBytes   195 Mbits/sec
    299:[SUM]   56.0-57.0 sec  23.2 MBytes   195 Mbits/sec
    304:[SUM]   57.0-58.0 sec  22.8 MBytes   191 Mbits/sec
    309:[SUM]   58.0-59.0 sec  23.6 MBytes   198 Mbits/sec
    314:[SUM]   59.0-60.0 sec  23.1 MBytes   194 Mbits/sec
    319:[SUM]   60.0-61.0 sec  22.9 MBytes   192 Mbits/sec
    324:[SUM]   61.0-62.0 sec  23.4 MBytes   196 Mbits/sec
    329:[SUM]   62.0-63.0 sec  23.4 MBytes   196 Mbits/sec
    334:[SUM]   63.0-64.0 sec  22.5 MBytes   189 Mbits/sec
    339:[SUM]   64.0-65.0 sec  23.8 MBytes   199 Mbits/sec
    344:[SUM]   65.0-66.0 sec  23.0 MBytes   193 Mbits/sec
    349:[SUM]   66.0-67.0 sec  24.1 MBytes   202 Mbits/sec
    354:[SUM]   67.0-68.0 sec  22.6 MBytes   190 Mbits/sec
    359:[SUM]   68.0-69.0 sec  23.0 MBytes   193 Mbits/sec
    364:[SUM]   69.0-70.0 sec  23.2 MBytes   195 Mbits/sec
    369:[SUM]   70.0-71.0 sec  23.2 MBytes   195 Mbits/sec
    374:[SUM]   71.0-72.0 sec  22.2 MBytes   187 Mbits/sec
    379:[SUM]   72.0-73.0 sec  23.1 MBytes   194 Mbits/sec
    384:[SUM]   73.0-74.0 sec  23.9 MBytes   200 Mbits/sec
    389:[SUM]   74.0-75.0 sec  22.9 MBytes   192 Mbits/sec
    394:[SUM]   75.0-76.0 sec  23.6 MBytes   198 Mbits/sec
    399:[SUM]   76.0-77.0 sec  23.1 MBytes   194 Mbits/sec
    404:[SUM]   77.0-78.0 sec  23.1 MBytes   194 Mbits/sec
    409:[SUM]   78.0-79.0 sec  23.8 MBytes   199 Mbits/sec
    414:[SUM]   79.0-80.0 sec  23.8 MBytes   199 Mbits/sec
    419:[SUM]   80.0-81.0 sec  23.1 MBytes   194 Mbits/sec
    424:[SUM]   81.0-82.0 sec  22.9 MBytes   192 Mbits/sec
    429:[SUM]   82.0-83.0 sec  23.4 MBytes   196 Mbits/sec
    434:[SUM]   83.0-84.0 sec  23.4 MBytes   196 Mbits/sec
    439:[SUM]   84.0-85.0 sec  23.5 MBytes   197 Mbits/sec
    444:[SUM]   85.0-86.0 sec  23.9 MBytes   200 Mbits/sec
    449:[SUM]   86.0-87.0 sec  22.9 MBytes   192 Mbits/sec
    454:[SUM]   87.0-88.0 sec  23.4 MBytes   196 Mbits/sec
    459:[SUM]   88.0-89.0 sec  23.4 MBytes   196 Mbits/sec
    464:[SUM]   89.0-90.0 sec  23.4 MBytes   196 Mbits/sec
    469:[SUM]   90.0-91.0 sec  22.9 MBytes   192 Mbits/sec
    474:[SUM]   91.0-92.0 sec  23.6 MBytes   198 Mbits/sec
    479:[SUM]   92.0-93.0 sec  23.1 MBytes   194 Mbits/sec
    484:[SUM]   93.0-94.0 sec  23.2 MBytes   195 Mbits/sec
    489:[SUM]   94.0-95.0 sec  23.2 MBytes   195 Mbits/sec
    494:[SUM]   95.0-96.0 sec  23.1 MBytes   194 Mbits/sec
    499:[SUM]   96.0-97.0 sec  22.9 MBytes   192 Mbits/sec
    504:[SUM]   97.0-98.0 sec  23.2 MBytes   195 Mbits/sec
    509:[SUM]   98.0-99.0 sec  23.4 MBytes   196 Mbits/sec
    514:[SUM]  99.0-100.0 sec  23.5 MBytes   197 Mbits/sec
    519:[SUM] 100.0-101.0 sec  24.0 MBytes   201 Mbits/sec
    524:[SUM] 101.0-102.0 sec  23.5 MBytes   197 Mbits/sec
    529:[SUM] 102.0-103.0 sec  23.0 MBytes   193 Mbits/sec
    534:[SUM] 103.0-104.0 sec  23.1 MBytes   194 Mbits/sec
    539:[SUM] 104.0-105.0 sec  23.4 MBytes   196 Mbits/sec
    544:[SUM] 105.0-106.0 sec  23.0 MBytes   193 Mbits/sec
    549:[SUM] 106.0-107.0 sec  23.5 MBytes   197 Mbits/sec
    554:[SUM] 107.0-108.0 sec  23.4 MBytes   196 Mbits/sec
    559:[SUM] 108.0-109.0 sec  23.0 MBytes   193 Mbits/sec
    564:[SUM] 109.0-110.0 sec  22.6 MBytes   190 Mbits/sec
    569:[SUM] 110.0-111.0 sec  23.8 MBytes   199 Mbits/sec
    574:[SUM] 111.0-112.0 sec  23.2 MBytes   195 Mbits/sec
    579:[SUM] 112.0-113.0 sec  23.6 MBytes   198 Mbits/sec
    584:[SUM] 113.0-114.0 sec  24.1 MBytes   202 Mbits/sec
    589:[SUM] 114.0-115.0 sec  22.4 MBytes   188 Mbits/sec
    594:[SUM] 115.0-116.0 sec  23.1 MBytes   194 Mbits/sec
    599:[SUM] 116.0-117.0 sec  23.4 MBytes   196 Mbits/sec
    604:[SUM] 117.0-118.0 sec  22.9 MBytes   192 Mbits/sec
    609:[SUM] 118.0-119.0 sec  22.9 MBytes   192 Mbits/sec
    617:[SUM] 119.0-120.0 sec  23.4 MBytes   196 Mbits/sec

    619:[SUM]   0.0-120.0 sec  2.72 GBytes   195 Mbits/sec


cat /sys/kernel/debug/ieee80211/phy2/netdev:wlan0/stations/00:03:7f:42:08:56/rc_stats

    HT    MCS   Rate    Success    Retries   XRetries        PER
  HT20      0   6.5:          0          0          0          0
  HT40      0  13.5:          0          0          0          0
  HT40      1  27.5:          0          0          0          0
  HT40      2  40.5:          0          0          0          0
  HT40      3  54.0:          0          0          0          0
  HT40      4  81.5:          0          0          0          0
  HT40     11 108.0:          0          0          0          0
  HT40     12 162.0:          0          0          0          0
  HT40     13 216.0:          1          0          0          0
  HT40     14 243.0:          2          0          0          0
  HT40     15 270.0:        314         35          0          0
  HT40     15 300.0:      64236       6607          8          0


cat /sys/kernel/debug/ieee80211/phy2/ath9k/xmit

                            BE         BK        VI        VO

MPDUs Queued:                2          0         0        53
MPDUs Completed:             2          0         0        53
MPDUs XRetried:              0          0         0         0
Aggregates:              64462          0         0         0
AMPDUs Queued HW:           46          0         0         0
AMPDUs Queued SW:      2018211          0         0         0
AMPDUs Completed:      2018257          0         0         0
AMPDUs Retried:          21058          0         0         0
AMPDUs XRetried:             0          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:           2018259          0         0        53
TX-Bytes-All:       3099857109          0         0      2440
HW-put-tx-buf:           64534          0         0        53
HW-tx-start:                 0          0         0         0
HW-tx-proc-desc:         64534          0         0        53
TX-Failed:                   0          0         0         0

--l+3BVHpjL5
Content-Type: text/plain;
	 name="minstrel_ht.txt"
Content-Description: minstrel_ht
Content-Disposition: inline;
	 filename="minstrel_ht.txt"
Content-Transfer-Encoding: 7bit

root@linux-test ~# iperf -i1 -c 172.16.1.222 -t 120 -P 4
------------------------------------------------------------
Client connecting to 172.16.1.222, TCP port 5001
TCP window size: 22.9 KByte (default)
------------------------------------------------------------
[  5] local 172.16.1.111 port 36820 connected with 172.16.1.222 port 5001
[  4] local 172.16.1.111 port 36819 connected with 172.16.1.222 port 5001
[  3] local 172.16.1.111 port 36821 connected with 172.16.1.222 port 5001
[  6] local 172.16.1.111 port 36822 connected with 172.16.1.222 port 5001

    685:[SUM]    0.0- 1.0 sec  21.0 MBytes   176 Mbits/sec
    690:[SUM]    1.0- 2.0 sec  21.8 MBytes   182 Mbits/sec
    695:[SUM]    2.0- 3.0 sec  21.8 MBytes   182 Mbits/sec
    700:[SUM]    3.0- 4.0 sec  22.8 MBytes   191 Mbits/sec
    705:[SUM]    4.0- 5.0 sec  22.5 MBytes   189 Mbits/sec
    710:[SUM]    5.0- 6.0 sec  22.9 MBytes   192 Mbits/sec
    715:[SUM]    6.0- 7.0 sec  22.2 MBytes   187 Mbits/sec
    720:[SUM]    7.0- 8.0 sec  22.0 MBytes   185 Mbits/sec
    725:[SUM]    8.0- 9.0 sec  23.1 MBytes   194 Mbits/sec
    730:[SUM]    9.0-10.0 sec  21.9 MBytes   184 Mbits/sec
    735:[SUM]   10.0-11.0 sec  22.5 MBytes   189 Mbits/sec
    740:[SUM]   11.0-12.0 sec  22.1 MBytes   186 Mbits/sec
    745:[SUM]   12.0-13.0 sec  22.5 MBytes   189 Mbits/sec
    750:[SUM]   13.0-14.0 sec  23.0 MBytes   193 Mbits/sec
    755:[SUM]   14.0-15.0 sec  21.5 MBytes   180 Mbits/sec
    760:[SUM]   15.0-16.0 sec  22.5 MBytes   189 Mbits/sec
    765:[SUM]   16.0-17.0 sec  22.8 MBytes   191 Mbits/sec
    770:[SUM]   17.0-18.0 sec  22.8 MBytes   191 Mbits/sec
    775:[SUM]   18.0-19.0 sec  21.9 MBytes   184 Mbits/sec
    780:[SUM]   19.0-20.0 sec  21.1 MBytes   177 Mbits/sec
    785:[SUM]   20.0-21.0 sec  22.8 MBytes   191 Mbits/sec
    790:[SUM]   21.0-22.0 sec  22.5 MBytes   189 Mbits/sec
    795:[SUM]   22.0-23.0 sec  22.5 MBytes   189 Mbits/sec
    800:[SUM]   23.0-24.0 sec  22.6 MBytes   190 Mbits/sec
    805:[SUM]   24.0-25.0 sec  21.5 MBytes   180 Mbits/sec
    810:[SUM]   25.0-26.0 sec  22.1 MBytes   186 Mbits/sec
    815:[SUM]   26.0-27.0 sec  22.1 MBytes   186 Mbits/sec
    820:[SUM]   27.0-28.0 sec  21.6 MBytes   181 Mbits/sec
    825:[SUM]   28.0-29.0 sec  22.6 MBytes   190 Mbits/sec
    830:[SUM]   29.0-30.0 sec  23.0 MBytes   193 Mbits/sec
    835:[SUM]   30.0-31.0 sec  22.8 MBytes   191 Mbits/sec
    840:[SUM]   31.0-32.0 sec  22.6 MBytes   190 Mbits/sec
    845:[SUM]   32.0-33.0 sec  21.9 MBytes   184 Mbits/sec
    850:[SUM]   33.0-34.0 sec  21.6 MBytes   181 Mbits/sec
    855:[SUM]   34.0-35.0 sec  22.9 MBytes   192 Mbits/sec
    860:[SUM]   35.0-36.0 sec  22.0 MBytes   185 Mbits/sec
    865:[SUM]   36.0-37.0 sec  22.6 MBytes   190 Mbits/sec
    870:[SUM]   37.0-38.0 sec  22.2 MBytes   187 Mbits/sec
    875:[SUM]   38.0-39.0 sec  22.5 MBytes   189 Mbits/sec
    880:[SUM]   39.0-40.0 sec  21.9 MBytes   184 Mbits/sec
    885:[SUM]   40.0-41.0 sec  22.6 MBytes   190 Mbits/sec
    890:[SUM]   41.0-42.0 sec  22.2 MBytes   187 Mbits/sec
    895:[SUM]   42.0-43.0 sec  21.9 MBytes   184 Mbits/sec
    900:[SUM]   43.0-44.0 sec  22.4 MBytes   188 Mbits/sec
    905:[SUM]   44.0-45.0 sec  20.5 MBytes   172 Mbits/sec
    910:[SUM]   45.0-46.0 sec  22.4 MBytes   188 Mbits/sec
    915:[SUM]   46.0-47.0 sec  23.0 MBytes   193 Mbits/sec
    920:[SUM]   47.0-48.0 sec  21.8 MBytes   182 Mbits/sec
    925:[SUM]   48.0-49.0 sec  22.2 MBytes   187 Mbits/sec
    930:[SUM]   49.0-50.0 sec  22.4 MBytes   188 Mbits/sec
    935:[SUM]   50.0-51.0 sec  22.4 MBytes   188 Mbits/sec
    940:[SUM]   51.0-52.0 sec  23.1 MBytes   194 Mbits/sec
    945:[SUM]   52.0-53.0 sec  22.4 MBytes   188 Mbits/sec
    950:[SUM]   53.0-54.0 sec  22.6 MBytes   190 Mbits/sec
    955:[SUM]   54.0-55.0 sec  22.8 MBytes   191 Mbits/sec
    960:[SUM]   55.0-56.0 sec  22.4 MBytes   188 Mbits/sec
    965:[SUM]   56.0-57.0 sec  22.5 MBytes   189 Mbits/sec
    970:[SUM]   57.0-58.0 sec  23.0 MBytes   193 Mbits/sec
    975:[SUM]   58.0-59.0 sec  22.1 MBytes   186 Mbits/sec
    980:[SUM]   59.0-60.0 sec  21.8 MBytes   182 Mbits/sec
    985:[SUM]   60.0-61.0 sec  21.6 MBytes   181 Mbits/sec
    990:[SUM]   61.0-62.0 sec  22.6 MBytes   190 Mbits/sec
    995:[SUM]   62.0-63.0 sec  22.1 MBytes   186 Mbits/sec
   1000:[SUM]   63.0-64.0 sec  21.8 MBytes   182 Mbits/sec
   1005:[SUM]   64.0-65.0 sec  22.2 MBytes   187 Mbits/sec
   1010:[SUM]   65.0-66.0 sec  21.8 MBytes   182 Mbits/sec
   1015:[SUM]   66.0-67.0 sec  22.2 MBytes   187 Mbits/sec
   1020:[SUM]   67.0-68.0 sec  22.2 MBytes   187 Mbits/sec
   1025:[SUM]   68.0-69.0 sec  23.2 MBytes   195 Mbits/sec
   1030:[SUM]   69.0-70.0 sec  23.2 MBytes   195 Mbits/sec
   1035:[SUM]   70.0-71.0 sec  22.5 MBytes   189 Mbits/sec
   1040:[SUM]   71.0-72.0 sec  22.2 MBytes   187 Mbits/sec
   1045:[SUM]   72.0-73.0 sec  22.0 MBytes   185 Mbits/sec
   1050:[SUM]   73.0-74.0 sec  21.9 MBytes   184 Mbits/sec
   1055:[SUM]   74.0-75.0 sec  22.5 MBytes   189 Mbits/sec
   1060:[SUM]   75.0-76.0 sec  22.4 MBytes   188 Mbits/sec
   1065:[SUM]   76.0-77.0 sec  22.6 MBytes   190 Mbits/sec
   1070:[SUM]   77.0-78.0 sec  22.9 MBytes   192 Mbits/sec
   1075:[SUM]   78.0-79.0 sec  22.1 MBytes   186 Mbits/sec
   1080:[SUM]   79.0-80.0 sec  22.0 MBytes   185 Mbits/sec
   1085:[SUM]   80.0-81.0 sec  21.9 MBytes   184 Mbits/sec
   1090:[SUM]   81.0-82.0 sec  21.5 MBytes   180 Mbits/sec
   1095:[SUM]   82.0-83.0 sec  22.4 MBytes   188 Mbits/sec
   1100:[SUM]   83.0-84.0 sec  23.4 MBytes   196 Mbits/sec
   1105:[SUM]   84.0-85.0 sec  22.0 MBytes   185 Mbits/sec
   1110:[SUM]   85.0-86.0 sec  22.5 MBytes   189 Mbits/sec
   1115:[SUM]   86.0-87.0 sec  22.8 MBytes   191 Mbits/sec
   1120:[SUM]   87.0-88.0 sec  22.4 MBytes   188 Mbits/sec
   1125:[SUM]   88.0-89.0 sec  22.1 MBytes   186 Mbits/sec
   1130:[SUM]   89.0-90.0 sec  22.8 MBytes   191 Mbits/sec
   1135:[SUM]   90.0-91.0 sec  21.4 MBytes   179 Mbits/sec
   1140:[SUM]   91.0-92.0 sec  22.4 MBytes   188 Mbits/sec
   1145:[SUM]   92.0-93.0 sec  22.9 MBytes   192 Mbits/sec
   1150:[SUM]   93.0-94.0 sec  22.9 MBytes   192 Mbits/sec
   1155:[SUM]   94.0-95.0 sec  23.4 MBytes   196 Mbits/sec
   1160:[SUM]   95.0-96.0 sec  21.1 MBytes   177 Mbits/sec
   1165:[SUM]   96.0-97.0 sec  22.0 MBytes   185 Mbits/sec
   1170:[SUM]   97.0-98.0 sec  22.2 MBytes   187 Mbits/sec
   1175:[SUM]   98.0-99.0 sec  22.5 MBytes   189 Mbits/sec
   1180:[SUM]  99.0-100.0 sec  22.2 MBytes   187 Mbits/sec
   1185:[SUM] 100.0-101.0 sec  22.4 MBytes   188 Mbits/sec
   1190:[SUM] 101.0-102.0 sec  22.5 MBytes   189 Mbits/sec
   1195:[SUM] 102.0-103.0 sec  23.0 MBytes   193 Mbits/sec
   1200:[SUM] 103.0-104.0 sec  22.0 MBytes   185 Mbits/sec
   1205:[SUM] 104.0-105.0 sec  22.0 MBytes   185 Mbits/sec
   1210:[SUM] 105.0-106.0 sec  22.5 MBytes   189 Mbits/sec
   1215:[SUM] 106.0-107.0 sec  22.1 MBytes   186 Mbits/sec
   1220:[SUM] 107.0-108.0 sec  22.4 MBytes   188 Mbits/sec
   1225:[SUM] 108.0-109.0 sec  22.8 MBytes   191 Mbits/sec
   1230:[SUM] 109.0-110.0 sec  22.4 MBytes   188 Mbits/sec
   1235:[SUM] 110.0-111.0 sec  22.2 MBytes   187 Mbits/sec
   1240:[SUM] 111.0-112.0 sec  22.9 MBytes   192 Mbits/sec
   1245:[SUM] 112.0-113.0 sec  23.1 MBytes   194 Mbits/sec
   1250:[SUM] 113.0-114.0 sec  23.1 MBytes   194 Mbits/sec
   1255:[SUM] 114.0-115.0 sec  21.8 MBytes   182 Mbits/sec
   1260:[SUM] 115.0-116.0 sec  21.5 MBytes   180 Mbits/sec
   1265:[SUM] 116.0-117.0 sec  22.0 MBytes   185 Mbits/sec
   1270:[SUM] 117.0-118.0 sec  21.8 MBytes   182 Mbits/sec
   1275:[SUM] 118.0-119.0 sec  23.1 MBytes   194 Mbits/sec
   1283:[SUM] 119.0-120.0 sec  23.2 MBytes   195 Mbits/sec

   1285:[SUM]   0.0-120.0 sec  2.62 GBytes   187 Mbits/sec


cat /sys/kernel/debug/ieee80211/phy3/netdev:wlan0/stations/00:03:7f:42:08:56/rc_stats

type         rate     throughput  ewma prob   this prob  retry   this succ/attempt   success    attempts
HT20/LGI     MCS0            6.6       99.9       100.0      2              0(  0)        86          91
HT20/LGI     MCS1           10.5       81.1       100.0      2              0(  0)        90          96
HT20/LGI     MCS2           17.5       91.8       100.0      2              0(  0)        88          91
HT20/LGI     MCS3           24.9       99.6       100.0      2              0(  0)        85          92
HT20/LGI     MCS4           36.0       99.2       100.0      2              0(  0)        88          92
HT20/LGI     MCS5           42.8       92.0       100.0      2              0(  0)        85          90
HT20/LGI     MCS6           48.2       94.0       100.0      2              0(  0)        85          95
HT20/LGI     MCS7           57.1       99.9       100.0      2              0(  0)        92          95
HT20/LGI     MCS8           12.9       99.5       100.0      2              0(  0)        89          93
HT20/LGI     MCS9           24.1       96.4       100.0      2              0(  0)        91          96
HT20/LGI     MCS10          36.3       99.9       100.0      2              0(  0)        86          91
HT20/LGI     MCS11          46.5       99.9       100.0      2              0(  0)        92          96
HT20/LGI     MCS12          60.3       91.1       100.0      2              0(  0)        89          93
HT20/LGI     MCS13          81.1       99.8       100.0      2              0(  0)        86          93
HT20/LGI     MCS14          90.0       99.9       100.0      2              0(  0)        91          96
HT20/LGI     MCS15          83.4       85.9       100.0      2              0(  0)        97          99
HT20/SGI     MCS0            7.3       99.6       100.0      2              0(  0)        87          93
HT20/SGI     MCS1           14.4       99.9       100.0      2              0(  0)        88          93
HT20/SGI     MCS2           20.9       99.3       100.0      2              0(  0)        88          93
HT20/SGI     MCS3           27.4       99.3       100.0      2              0(  0)        90          96
HT20/SGI     MCS4           37.9       95.2       100.0      2              0(  0)        83          92
HT20/SGI     MCS5           48.4       95.5       100.0      2              0(  0)        87          93
HT20/SGI     MCS6           55.6       99.6       100.0      2              0(  0)        93         100
HT20/SGI     MCS7           60.9       98.1       100.0      2              0(  0)        93          95
HT20/SGI     MCS8           13.7       95.3       100.0      2              0(  0)        82          90
HT20/SGI     MCS9           26.8       97.3       100.0      2              0(  0)        84          90
HT20/SGI     MCS10          39.8       99.9       100.0      2              0(  0)        90          91
HT20/SGI     MCS11          50.7       99.9       100.0      2              0(  0)        87          92
HT20/SGI     MCS12          71.1       98.9       100.0      2              0(  0)        85          89
HT20/SGI     MCS13          80.2       91.4       100.0      2              0(  0)        87          91
HT20/SGI     MCS14          97.0       99.9       100.0      2              0(  0)        92          97
HT20/SGI     MCS15          78.0       74.9         0.0      2              0(  0)       476         538
HT40/LGI     MCS0           13.5       99.8       100.0      2              0(  0)        90          95
HT40/LGI     MCS1           26.0       99.9       100.0      2              0(  0)        86          90
HT40/LGI     MCS2           36.1       96.6       100.0      2              0(  0)        89          92
HT40/LGI     MCS3           44.4       92.0       100.0      2              0(  0)        91          94
HT40/LGI     MCS4           61.7       90.7       100.0      2              0(  0)        86          93
HT40/LGI     MCS5           70.1       83.4       100.0      2              0(  0)        81          91
HT40/LGI     MCS6           85.9       92.0       100.0      2              0(  0)        91          96
HT40/LGI     MCS7          100.6       99.6       100.0      2              0(  0)        88          94
HT40/LGI     MCS8           25.5       97.9       100.0      2              0(  0)        83          92
HT40/LGI     MCS9           44.4       92.0       100.0      2              0(  0)        84          90
HT40/LGI     MCS10          67.7       99.5       100.0      2              0(  0)        81          91
HT40/LGI     MCS11          59.2       70.5         0.0      2              0(  0)        85          89
HT40/LGI     MCS12         105.8       92.0       100.0      3              0(  0)        90          93
HT40/LGI     MCS13         118.3       88.7       100.0      3              0(  0)        84          89
HT40/LGI     MCS14         145.4       97.4       100.0      4              0(  0)       768         899
HT40/LGI     MCS15         130.0       81.9       100.0      4              0(  0)     80856       88875
HT40/SGI     MCS0           14.9       99.9       100.0      2              0(  0)        86          91
HT40/SGI     MCS1           21.4       74.7         0.0      2              0(  0)        91          95
HT40/SGI     MCS2           41.1       99.9       100.0      2              0(  0)        85          91
HT40/SGI     MCS3           49.7       93.9       100.0      2              0(  0)        88          93
HT40/SGI     MCS4           55.4       74.8         0.0      2              0(  0)        88          92
HT40/SGI     MCS5           86.9       95.6       100.0      2              0(  0)        85          91
HT40/SGI     MCS6          100.9       99.9       100.0      2              0(  0)        86          94
HT40/SGI   P MCS7          106.9       98.4       100.0      5              0(  0)      4424        4980
HT40/SGI     MCS8           28.6       99.8       100.0      2              0(  0)        87          89
HT40/SGI     MCS9           45.1       85.3       100.0      2              0(  0)        85          91
HT40/SGI     MCS10          72.6       98.1       100.0      2              0(  0)        88          90
HT40/SGI     MCS11          89.9       98.9       100.0      2              0(  0)        80          88
HT40/SGI     MCS12         121.9       98.7       100.0      3              0(  0)        86          92
HT40/SGI     MCS13         132.4       94.0       100.0      3              0(  0)        85          89
HT40/SGI  t  MCS14         152.6       96.1       100.0      5              0(  0)     88243       96781
HT40/SGI T   MCS15         161.8       97.1       100.0      5              1(  1)   1760690     1945362

Total packet count::    ideal 1934621      lookaround 5901
Average A-MPDU length: 4.4


cat /sys/kernel/debug/ieee80211/phy3/ath9k/xmit

                            BE         BK        VI        VO

MPDUs Queued:               10          0         0        47
MPDUs Completed:            10          0         0        47
MPDUs XRetried:              0          0         0         0
Aggregates:              63956          0         0         0
AMPDUs Queued HW:           99          0         0         0
AMPDUs Queued SW:      1940401          0         0         0
AMPDUs Completed:      1940500          0         0         0
AMPDUs Retried:          14536          0         0         0
AMPDUs XRetried:             0          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:           1940510          0         0        47
TX-Bytes-All:       2980293154          0         0      2296
HW-put-tx-buf:           70308          0         0        47
HW-tx-start:                 0          0         0         0
HW-tx-proc-desc:         70308          0         0        47
TX-Failed:                   0          0         0         0

--l+3BVHpjL5--
