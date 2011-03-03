Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jabba.london.02.net ([82.132.130.169]:39296 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758536Ab1CCTRE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 14:17:04 -0500
Date: Thu, 3 Mar 2011 19:16:56 +0000
From: Tony Houghton <h@realh.co.uk>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil@venema.h4ckr.net, Vivek Natarajan <vnatarajan@atheros.com>
Subject: Re: [ath9k-devel] ath9k causes lockups since kernel 2.6.35
Message-ID: <20110303191656.73bba824@realh.co.uk>
In-Reply-To: <AANLkTiksdt5fciyFZ_nphEYgLH6Ey_HSHHpY5Eg9pNqD@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTiksoeKhMaFarSDVCbcDbZx6iWHkYzrg--1NcKKA@mail.gmail.com>
	<20110225144718.63550601@realh.co.uk>
	<AANLkTinu9NgnZZmieh2PU6e-iShOkapV9kcVe8YGtPHG@mail.gmail.com>
	<20110225165745.4860afe0@realh.co.uk>
	<20110226183542.75bc1786@realh.co.uk>
	<AANLkTi=ZWmWZWMBSdGX8S9EfiRyv3eKEU9P3n0bfDAuJ@mail.gmail.com>
	<20110302163051.425d1419@toddler>
	<AANLkTinEA2NVxwWZJME-oChE6OEJc_TSTajMfe7f+3hm@mail.gmail.com>
	<20110303143151.03dbe76b@toddler>
	<AANLkTiksdt5fciyFZ_nphEYgLH6Ey_HSHHpY5Eg9pNqD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/VB1ovY1rq1ua_Bn8rVT+1kY"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--MP_/VB1ovY1rq1ua_Bn8rVT+1kY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 3 Mar 2011 21:27:32 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> sudo modprobe ath9k debug=0xffffffff

That debug option was what I needed. I'm attaching what I captured with
netconsole leading up to a crash.

I also found that I couldn't reproduce the problem while running on
battery, but as soon as I connected the PSU it crashed the very next
time I disabled wireless. I hadn't noticed that PSU/battery made a
difference before, but it does seem to be an issue.

--MP_/VB1ovY1rq1ua_Bn8rVT+1kY
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=netconsole.log

[  656.568676] ath: NETWORK SLEEP -> AWAKE
[  656.573331] ath: disable IER
[  656.573423] ath: enable IER
[  656.573449] ath: AR_IMR 0x918414b0 IER 0x1
[  656.573488] ath: AWAKE -> NETWORK SLEEP
[  656.671069] ath: NETWORK SLEEP -> AWAKE
[  656.675728] ath: disable IER
[  656.675839] ath: enable IER
[  656.675871] ath: AR_IMR 0x918414b0 IER 0x1
[  656.675909] ath: AWAKE -> NETWORK SLEEP
[  656.773479] ath: NETWORK SLEEP -> AWAKE
[  656.778163] ath: disable IER
[  656.778276] ath: enable IER
[  656.778306] ath: AR_IMR 0x918414b0 IER 0x1
[  656.778345] ath: AWAKE -> NETWORK SLEEP
[  656.875865] ath: NETWORK SLEEP -> AWAKE
[  656.880517] ath: disable IER
[  656.880621] ath: enable IER
[  656.880652] ath: AR_IMR 0x918414b0 IER 0x1
[  656.880691] ath: AWAKE -> NETWORK SLEEP
[  656.978277] ath: NETWORK SLEEP -> AWAKE
[  656.982919] ath: disable IER
[  656.983010] ath: enable IER
[  656.983038] ath: AR_IMR 0x918414b0 IER 0x1
[  656.983076] ath: AWAKE -> NETWORK SLEEP
[  657.080663] ath: NETWORK SLEEP -> AWAKE
[  657.085311] ath: disable IER
[  657.085401] ath: enable IER
[  657.085430] ath: AR_IMR 0x918414b0 IER 0x1
[  657.085468] ath: AWAKE -> NETWORK SLEEP
[  657.183041] ath: NETWORK SLEEP -> AWAKE
[  657.187720] ath: disable IER
[  657.187812] ath: enable IER
[  657.187839] ath: AR_IMR 0x918414b0 IER 0x1
[  657.187878] ath: AWAKE -> NETWORK SLEEP
[  657.285466] ath: NETWORK SLEEP -> AWAKE
[  657.290164] ath: disable IER
[  657.290275] ath: enable IER
[  657.290307] ath: AR_IMR 0x918414b0 IER 0x1
[  657.290345] ath: AWAKE -> NETWORK SLEEP
[  657.387853] ath: NETWORK SLEEP -> AWAKE
[  657.392509] ath: disable IER
[  657.392590] ath: enable IER
[  657.392608] ath: AR_IMR 0x918414b0 IER 0x1
[  657.392640] ath: AWAKE -> NETWORK SLEEP
[  657.490269] ath: NETWORK SLEEP -> AWAKE
[  657.494909] ath: disable IER
[  657.495020] ath: enable IER
[  657.495052] ath: AR_IMR 0x918414b0 IER 0x1
[  657.495090] ath: AWAKE -> NETWORK SLEEP
[  657.592643] ath: NETWORK SLEEP -> AWAKE
[  657.597299] ath: disable IER
[  657.597390] ath: enable IER
[  657.597417] ath: AR_IMR 0x918414b0 IER 0x1
[  657.597455] ath: AWAKE -> NETWORK SLEEP
[  657.695037] ath: NETWORK SLEEP -> AWAKE
[  657.699728] ath: disable IER
[  657.699839] ath: enable IER
[  657.699871] ath: AR_IMR 0x918414b0 IER 0x1
[  657.699909] ath: AWAKE -> NETWORK SLEEP
[  657.797450] ath: NETWORK SLEEP -> AWAKE
[  657.802098] ath: disable IER
[  657.802191] ath: enable IER
[  657.802209] ath: AR_IMR 0x918414b0 IER 0x1
[  657.802241] ath: AWAKE -> NETWORK SLEEP
[  657.899841] ath: NETWORK SLEEP -> AWAKE
[  657.904500] ath: disable IER
[  657.904612] ath: enable IER
[  657.904643] ath: AR_IMR 0x918414b0 IER 0x1
[  657.904681] ath: AWAKE -> NETWORK SLEEP
[  658.002248] ath: NETWORK SLEEP -> AWAKE
[  658.006897] ath: disable IER
[  658.006989] ath: enable IER
[  658.007022] ath: AR_IMR 0x918414b0 IER 0x1
[  658.007060] ath: AWAKE -> NETWORK SLEEP
[  658.104631] ath: NETWORK SLEEP -> AWAKE
[  658.108051] ath: shortcal @89527
[  658.108149] ath: listenTime=247 OFDM:0 errs=89/s CCK:2 errs=16/s ofdm_turn=1
[  658.108224] ath: NF calibrated [ctl] [chain 0] is -115
[  658.109291] ath: disable IER
[  658.109399] ath: enable IER
[  658.109425] ath: AR_IMR 0x918414b0 IER 0x1
[  658.109464] ath: AWAKE -> NETWORK SLEEP
[  658.207056] ath: NETWORK SLEEP -> AWAKE
[  658.208212] ath: listenTime=249 OFDM:0 errs=88/s CCK:2 errs=16/s ofdm_turn=1
[  658.211693] ath: disable IER
[  658.211797] ath: enable IER
[  658.211825] ath: AR_IMR 0x918414b0 IER 0x1
[  658.211864] ath: AWAKE -> NETWORK SLEEP
[  658.309434] ath: NETWORK SLEEP -> AWAKE
[  658.314082] ath: disable IER
[  658.314232] ath: enable IER
[  658.314255] ath: AR_IMR 0x918414b0 IER 0x1
[  658.314294] ath: AWAKE -> NETWORK SLEEP
[  658.411826] ath: NETWORK SLEEP -> AWAKE
[  658.416489] ath: disable IER
[  658.416571] ath: enable IER
[  658.416594] ath: AR_IMR 0x918414b0 IER 0x1
[  658.416626] ath: AWAKE -> NETWORK SLEEP
[  658.514243] ath: NETWORK SLEEP -> AWAKE
[  658.518890] ath: disable IER
[  658.519001] ath: enable IER
[  658.519032] ath: AR_IMR 0x918414b0 IER 0x1
[  658.519071] ath: AWAKE -> NETWORK SLEEP
[  658.616624] ath: NETWORK SLEEP -> AWAKE
[  658.621286] ath: disable IER
[  658.621377] ath: enable IER
[  658.621404] ath: AR_IMR 0x918414b0 IER 0x1
[  658.621443] ath: AWAKE -> NETWORK SLEEP
[  658.719044] ath: NETWORK SLEEP -> AWAKE
[  658.723685] ath: disable IER
[  658.723797] ath: enable IER
[  658.723828] ath: AR_IMR 0x918414b0 IER 0x1
[  658.723866] ath: AWAKE -> NETWORK SLEEP
[  658.821426] ath: NETWORK SLEEP -> AWAKE
[  658.826147] ath: disable IER
[  658.826264] ath: enable IER
[  658.826295] ath: AR_IMR 0x918414b0 IER 0x1
[  658.826334] ath: AWAKE -> NETWORK SLEEP
[  658.923813] ath: NETWORK SLEEP -> AWAKE
[  658.928477] ath: disable IER
[  658.928552] ath: enable IER
[  658.928577] ath: AR_IMR 0x918414b0 IER 0x1
[  658.928609] ath: AWAKE -> NETWORK SLEEP
[  659.026244] ath: NETWORK SLEEP -> AWAKE
[  659.030883] ath: disable IER
[  659.030995] ath: enable IER
[  659.031026] ath: AR_IMR 0x918414b0 IER 0x1
[  659.031064] ath: AWAKE -> NETWORK SLEEP
[  659.128612] ath: NETWORK SLEEP -> AWAKE
[  659.133273] ath: disable IER
[  659.133385] ath: enable IER
[  659.133416] ath: AR_IMR 0x918414b0 IER 0x1
[  659.133465] ath: AWAKE -> NETWORK SLEEP
[  659.231035] ath: NETWORK SLEEP -> AWAKE
[  659.235665] ath: disable IER
[  659.235787] ath: enable IER
[  659.235825] ath: AR_IMR 0x918414b0 IER 0x1
[  659.235863] ath: AWAKE -> NETWORK SLEEP
[  659.333422] ath: NETWORK SLEEP -> AWAKE
[  659.338119] ath: disable IER
[  659.338228] ath: enable IER
[  659.338262] ath: AR_IMR 0x918414b0 IER 0x1
[  659.338301] ath: AWAKE -> NETWORK SLEEP
[  659.435801] ath: NETWORK SLEEP -> AWAKE
[  659.440472] ath: disable IER
[  659.440586] ath: enable IER
[  659.440615] ath: AR_IMR 0x918414b0 IER 0x1
[  659.440654] ath: AWAKE -> NETWORK SLEEP
[  659.538214] ath: NETWORK SLEEP -> AWAKE
[  659.542869] ath: disable IER
[  659.542960] ath: enable IER
[  659.542987] ath: AR_IMR 0x918414b0 IER 0x1
[  659.543026] ath: AWAKE -> NETWORK SLEEP
[  659.640605] ath: NETWORK SLEEP -> AWAKE
[  659.645260] ath: disable IER
[  659.645350] ath: enable IER
[  659.645379] ath: AR_IMR 0x918414b0 IER 0x1
[  659.645417] ath: AWAKE -> NETWORK SLEEP
[  659.743019] ath: NETWORK SLEEP -> AWAKE
[  659.747666] ath: disable IER
[  659.747770] ath: enable IER
[  659.747801] ath: AR_IMR 0x918414b0 IER 0x1
[  659.747839] ath: AWAKE -> NETWORK SLEEP
[  659.845408] ath: NETWORK SLEEP -> AWAKE
[  659.850061] ath: disable IER
[  659.850175] ath: enable IER
[  659.850205] ath: AR_IMR 0x918414b0 IER 0x1
[  659.850243] ath: AWAKE -> NETWORK SLEEP
[  659.947820] ath: NETWORK SLEEP -> AWAKE
[  659.952453] ath: disable IER
[  659.952567] ath: enable IER
[  659.952596] ath: AR_IMR 0x918414b0 IER 0x1
[  659.952635] ath: AWAKE -> NETWORK SLEEP
[  660.050205] ath: NETWORK SLEEP -> AWAKE
[  660.054844] ath: disable IER
[  660.054942] ath: enable IER
[  660.054968] ath: AR_IMR 0x918414b0 IER 0x1
[  660.055006] ath: AWAKE -> NETWORK SLEEP
[  660.152590] ath: NETWORK SLEEP -> AWAKE
[  660.157255] ath: disable IER
[  660.157414] ath: enable IER
[  660.157451] ath: AR_IMR 0x918414b0 IER 0x1
[  660.157496] ath: AWAKE -> NETWORK SLEEP
[  660.255011] ath: NETWORK SLEEP -> AWAKE
[  660.259661] ath: disable IER
[  660.259786] ath: enable IER
[  660.259815] ath: AR_IMR 0x918414b0 IER 0x1
[  660.259853] ath: AWAKE -> NETWORK SLEEP
[  660.357398] ath: NETWORK SLEEP -> AWAKE
[  660.362114] ath: disable IER
[  660.362226] ath: enable IER
[  660.362257] ath: AR_IMR 0x918414b0 IER 0x1
[  660.362296] ath: AWAKE -> NETWORK SLEEP
[  660.459815] ath: NETWORK SLEEP -> AWAKE
[  660.464772] ath: disable IER
[  660.464882] ath: enable IER
[  660.464914] ath: AR_IMR 0x918414b0 IER 0x1
[  660.464952] ath: AWAKE -> NETWORK SLEEP
[  660.562196] ath: NETWORK SLEEP -> AWAKE
[  660.566845] ath: disable IER
[  660.566937] ath: enable IER
[  660.566964] ath: AR_IMR 0x918414b0 IER 0x1
[  660.567002] ath: AWAKE -> NETWORK SLEEP
[  660.664578] ath: NETWORK SLEEP -> AWAKE
[  660.669250] ath: disable IER
[  660.669365] ath: enable IER
[  660.669393] ath: AR_IMR 0x918414b0 IER 0x1
[  660.669432] ath: AWAKE -> NETWORK SLEEP
[  660.766992] ath: NETWORK SLEEP -> AWAKE
[  660.771647] ath: disable IER
[  660.771738] ath: enable IER
[  660.771766] ath: AR_IMR 0x918414b0 IER 0x1
[  660.771804] ath: AWAKE -> NETWORK SLEEP
[  660.869379] ath: NETWORK SLEEP -> AWAKE
[  660.874052] ath: disable IER
[  660.874164] ath: enable IER
[  660.874195] ath: AR_IMR 0x918414b0 IER 0x1
[  660.874234] ath: AWAKE -> NETWORK SLEEP
[  660.971804] ath: NETWORK SLEEP -> AWAKE
[  660.976449] ath: disable IER
[  660.976562] ath: enable IER
[  660.976592] ath: AR_IMR 0x918414b0 IER 0x1
[  660.976630] ath: AWAKE -> NETWORK SLEEP
[  661.074187] ath: NETWORK SLEEP -> AWAKE
[  661.078840] ath: disable IER
[  661.078951] ath: enable IER
[  661.078983] ath: AR_IMR 0x918414b0 IER 0x1
[  661.079021] ath: AWAKE -> NETWORK SLEEP
[  661.176604] ath: NETWORK SLEEP -> AWAKE
[  661.181243] ath: disable IER
[  661.181356] ath: enable IER
[  661.181387] ath: AR_IMR 0x918414b0 IER 0x1
[  661.181426] ath: AWAKE -> NETWORK SLEEP
[  661.278987] ath: NETWORK SLEEP -> AWAKE
[  661.283640] ath: disable IER
[  661.283752] ath: enable IER
[  661.283783] ath: AR_IMR 0x918414b0 IER 0x1
[  661.283821] ath: AWAKE -> NETWORK SLEEP
[  661.344896] ath: Configure tx [queue/halq] [0/0], aifs: 2, cw_min: 3, cw_max: 7, txop: 47
[  661.344922] ath: Set queue properties for: 0
[  661.344933] ath: Reset TX queue: 0
[  661.344968] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.345022] ath: Configure tx [queue/halq] [1/1], aifs: 2, cw_min: 7, cw_max: 15, txop: 94
[  661.345069] ath: Set queue properties for: 1
[  661.345078] ath: Reset TX queue: 1
[  661.345088] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.345145] ath: Configure tx [queue/halq] [2/2], aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
[  661.345191] ath: Set queue properties for: 2
[  661.345200] ath: Reset TX queue: 2
[  661.345209] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.345266] ath: Configure tx [queue/halq] [3/3], aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
[  661.345312] ath: Set queue properties for: 3
[  661.345321] ath: Reset TX queue: 3
[  661.345331] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.345390] ath: NETWORK SLEEP -> AWAKE
[  661.345478] ath: 0xf4041071 => 0xf4041071
[  661.345486] ath: new IMR 0x918414b0
[  661.345496] ath: enable IER
[  661.345516] ath: AR_IMR 0x918414b0 IER 0x1
[  661.345570] ath: BSSID: 00:00:00:00:00:00 aid: 0x0
[  661.345579] ath: ah->misc_mode 0x4
[  661.345612] ath: BSS Changed PREAMBLE 0
[  661.345620] ath: BSS Changed CTS PROT 0
[  661.345628] ath: BSS Changed ASSOC 0
[  661.345635] ath: Bss Info DISASSOC
[  661.345645] wlan0: deauthenticating from 00:1f:9f:eb:41:e1 by local choice (reason=3)
[  661.360110] ath: Set HW Key
[  661.360229] ath: transmitting packet, skb: f5a94480
[  661.360256] ath: qnum: 0, txq depth: 0
[  661.360273] ath: link[0] (f63b652c)=363b6590 (f63b6590)
[  661.360287] ath: Enable TXE on queue: 0
[  661.360381] ath: disable IER
[  661.360419] ath: tx queue 0 (363b6590), link f63b6590
[  661.360426] ath: enable IER
[  661.360444] ath: AR_IMR 0x918414b0 IER 0x1
[  661.361133] ath: disable IER
[  661.361177] ath: tx queue 0 (363b6590), link f63b6590
[  661.361195] ath: TX complete: skb: f5a94480
[  661.361219] ath: enable IER
[  661.361245] ath: AR_IMR 0x918414b0 IER 0x1
[  661.372083] ath: Set HW Key
[  661.376651] ath: Marking phy0 as idle
[  661.376674] ath: idle: disabling radio
[  661.376691] ath: disable IER
[  661.376952] ath: Disable MIB counters
[  661.377035] ath: Disable MIB counters
[  661.377114] ath: NF calibrated [ctl] [chain 0] is -115
[  661.379715] ath: PDADC (0,   0): a280 03020100
[  661.379730] ath: PDADC: Chain 0 | PDADC   0 Value   0 | PDADC   1 Value   1 | PDADC   2 Value   2 | PDADC   3 Value   3 |
[  661.379740] ath: PDADC (0,   0): a284 07060504
[  661.379750] ath: PDADC: Chain 0 | PDADC   4 Value   4 | PDADC   5 Value   5 | PDADC   6 Value   6 | PDADC   7 Value   7 |
[  661.379760] ath: PDADC (0,   0): a288 0a0a0908
[  661.379769] ath: PDADC: Chain 0 | PDADC   8 Value   8 | PDADC   9 Value   9 | PDADC  10 Value  10 | PDADC  11 Value  10 |
[  661.379779] ath: PDADC (0,   0): a28c 110f0d0b
[  661.379789] ath: PDADC: Chain 0 | PDADC  12 Value  11 | PDADC  13 Value  13 | PDADC  14 Value  15 | PDADC  15 Value  17 |
[  661.379798] ath: PDADC (0,   0): a290 18161412
[  661.379808] ath: PDADC: Chain 0 | PDADC  16 Value  18 | PDADC  17 Value  20 | PDADC  18 Value  22 | PDADC  19 Value  24 |
[  661.379817] ath: PDADC (0,   0): a294 24201d1b
[  661.379827] ath: PDADC: Chain 0 | PDADC  20 Value  27 | PDADC  21 Value  29 | PDADC  22 Value  32 | PDADC  23 Value  36 |
[  661.379837] ath: PDADC (0,   0): a298 2f2c2926
[  661.379847] ath: PDADC: Chain 0 | PDADC  24 Value  38 | PDADC  25 Value  41 | PDADC  26 Value  44 | PDADC  27 Value  47 |
[  661.379862] ath: PDADC (0,   0): a29c 453f3933
[  661.379876] ath: PDADC: Chain 0 | PDADC  28 Value  51 | PDADC  29 Value  57 | PDADC  30 Value  63 | PDADC  31 Value  69 |
[  661.379886] ath: PDADC (0,   0): a2a0 5d57514b
[  661.379895] ath: PDADC: Chain 0 | PDADC  32 Value  75 | PDADC  33 Value  81 | PDADC  34 Value  87 | PDADC  35 Value  93 |
[  661.379905] ath: PDADC (0,   0): a2a4 756f6963
[  661.379914] ath: PDADC: Chain 0 | PDADC  36 Value  99 | PDADC  37 Value 105 | PDADC  38 Value 111 | PDADC  39 Value 117 |
[  661.379924] ath: PDADC (0,   0): a2a8 100e817b
[  661.379933] ath: PDADC: Chain 0 | PDADC  40 Value 123 | PDADC  41 Value 129 | PDADC  42 Value  14 | PDADC  43 Value  16 |
[  661.379943] ath: PDADC (0,   0): a2ac 18161412
[  661.379952] ath: PDADC: Chain 0 | PDADC  44 Value  18 | PDADC  45 Value  20 | PDADC  46 Value  22 | PDADC  47 Value  24 |
[  661.379962] ath: PDADC (0,   0): a2b0 1f1d1b19
[  661.379971] ath: PDADC: Chain 0 | PDADC  48 Value  25 | PDADC  49 Value  27 | PDADC  50 Value  29 | PDADC  51 Value  31 |
[  661.379982] ath: PDADC (0,   0): a2b4 2b282522
[  661.379994] ath: PDADC: Chain 0 | PDADC  52 Value  34 | PDADC  53 Value  37 | PDADC  54 Value  40 | PDADC  55 Value  43 |
[  661.380009] ath: PDADC (0,   0): a2b8 3a36322e
[  661.380053] ath: PDADC: Chain 0 | PDADC  56 Value  46 | PDADC  57 Value  50 | PDADC  58 Value  54 | PDADC  59 Value  58 |
[  661.380068] ath: PDADC (0,   0): a2bc 4a46423e
[  661.380081] ath: PDADC: Chain 0 | PDADC  60 Value  62 | PDADC  61 Value  66 | PDADC  62 Value  70 | PDADC  63 Value  74 |
[  661.380094] ath: PDADC (0,   0): a2c0 5e59544f
[  661.380106] ath: PDADC: Chain 0 | PDADC  64 Value  79 | PDADC  65 Value  84 | PDADC  66 Value  89 | PDADC  67 Value  94 |
[  661.380119] ath: PDADC (0,   0): a2c4 6d6d6863
[  661.380132] ath: PDADC: Chain 0 | PDADC  68 Value  99 | PDADC  69 Value 104 | PDADC  70 Value 109 | PDADC  71 Value 109 |
[  661.380145] ath: PDADC (0,   0): a2c8 6d6d6d6d
[  661.380159] ath: PDADC: Chain 0 | PDADC  72 Value 109 | PDADC  73 Value 109 | PDADC  74 Value 109 | PDADC  75 Value 109 |
[  661.380172] ath: PDADC (0,   0): a2cc 6d6d6d6d
[  661.380184] ath: PDADC: Chain 0 | PDADC  76 Value 109 | PDADC  77 Value 109 | PDADC  78 Value 109 | PDADC  79 Value 109 |
[  661.380198] ath: PDADC (0,   0): a2d0 6d6d6d6d
[  661.380210] ath: PDADC: Chain 0 | PDADC  80 Value 109 | PDADC  81 Value 109 | PDADC  82 Value 109 | PDADC  83 Value 109 |
[  661.380223] ath: PDADC (0,   0): a2d4 6d6d6d6d
[  661.380235] ath: PDADC: Chain 0 | PDADC  84 Value 109 | PDADC  85 Value 109 | PDADC  86 Value 109 | PDADC  87 Value 109 |
[  661.380249] ath: PDADC (0,   0): a2d8 6d6d6d6d
[  661.380262] ath: PDADC: Chain 0 | PDADC  88 Value 109 | PDADC  89 Value 109 | PDADC  90 Value 109 | PDADC  91 Value 109 |
[  661.380275] ath: PDADC (0,   0): a2dc 6d6d6d6d
[  661.380289] ath: PDADC: Chain 0 | PDADC  92 Value 109 | PDADC  93 Value 109 | PDADC  94 Value 109 | PDADC  95 Value 109 |
[  661.380303] ath: PDADC (0,   0): a2e0 6d6d6d6d
[  661.380316] ath: PDADC: Chain 0 | PDADC  96 Value 109 | PDADC  97 Value 109 | PDADC  98 Value 109 | PDADC  99 Value 109 |
[  661.380329] ath: PDADC (0,   0): a2e4 6d6d6d6d
[  661.380341] ath: PDADC: Chain 0 | PDADC 100 Value 109 | PDADC 101 Value 109 | PDADC 102 Value 109 | PDADC 103 Value 109 |
[  661.380354] ath: PDADC (0,   0): a2e8 6d6d6d6d
[  661.380367] ath: PDADC: Chain 0 | PDADC 104 Value 109 | PDADC 105 Value 109 | PDADC 106 Value 109 | PDADC 107 Value 109 |
[  661.380380] ath: PDADC (0,   0): a2ec 6d6d6d6d
[  661.380392] ath: PDADC: Chain 0 | PDADC 108 Value 109 | PDADC 109 Value 109 | PDADC 110 Value 109 | PDADC 111 Value 109 |
[  661.380405] ath: PDADC (0,   0): a2f0 6d6d6d6d
[  661.380417] ath: PDADC: Chain 0 | PDADC 112 Value 109 | PDADC 113 Value 109 | PDADC 114 Value 109 | PDADC 115 Value 109 |
[  661.380431] ath: PDADC (0,   0): a2f4 6d6d6d6d
[  661.380444] ath: PDADC: Chain 0 | PDADC 116 Value 109 | PDADC 117 Value 109 | PDADC 118 Value 109 | PDADC 119 Value 109 |
[  661.380457] ath: PDADC (0,   0): a2f8 6d6d6d6d
[  661.380469] ath: PDADC: Chain 0 | PDADC 120 Value 109 | PDADC 121 Value 109 | PDADC 122 Value 109 | PDADC 123 Value 109 |
[  661.380481] ath: PDADC (0,   0): a2fc 6d6d6d6d
[  661.380494] ath: PDADC: Chain 0 | PDADC 124 Value 109 | PDADC 125 Value 109 | PDADC 126 Value 109 | PDADC 127 Value 109 |
[  661.380542] ath: Getting spur idx:0 is2Ghz:1 val:8000
[  661.382342] ath: Reset TX queue: 0
[  661.382367] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.382383] ath: Reset TX queue: 1
[  661.382396] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.382412] ath: Reset TX queue: 2
[  661.382425] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.382437] ath: Reset TX queue: 3
[  661.382451] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.382463] ath: Reset TXQ, inactive queue: 4
[  661.382475] ath: Reset TXQ, inactive queue: 5
[  661.382486] ath: Reset TXQ, inactive queue: 6
[  661.382496] ath: Reset TXQ, inactive queue: 7
[  661.382506] ath: Reset TX queue: 8
[  661.382535] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.382547] ath: Reset TX queue: 9
[  661.382572] ath: tx ok 0x0 err 0x0 desc 0x10f eol 0x10f urn 0x0
[  661.382595] ath: ah->misc_mode 0x4
[  661.384209] ath: Running PA Calibration
[  661.384933] ath: enabling ADC Gain Calibration.
[  661.384945] ath: enabling ADC DC Calibration.
[  661.384953] ath: enabling IQ Calibration.
[  661.384963] ath: starting ADC Gain Calibration
[  661.388029] ath: AWAKE -> FULL-SLEEP
[  662.368089] cfg80211: Calling CRDA to update world regulatory domain
[  662.370424] ath: FULL-SLEEP -> AWAKE

--MP_/VB1ovY1rq1ua_Bn8rVT+1kY--
