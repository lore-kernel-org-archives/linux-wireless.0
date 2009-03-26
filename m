Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48452 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZCZGao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 02:30:44 -0400
Received: by bwz17 with SMTP id 17so371545bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 23:30:39 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Subject: p54spi - mesh mode summary
Date: Thu, 26 Mar 2009 09:22:48 +0300
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com> <200903251442.58712.chunkeey@web.de> <200903251534.29549.chunkeey@web.de>
In-Reply-To: <200903251534.29549.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903260922.48489.jcmvbkbc@gmail.com> (sfid-20090326_073049_282542_A8F9CB08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> FYI, I just finished testing with a 5 node mesh network with various
> drivers (ath5k, ar9170usb and p54 mesh network) and it looks like
> everything works the way it should... ( testing was done with the current
> wireless-testing.git )
Good news.

And here's what's happening in p54spi environment:
1) yesterday's logs, with plink establishment failure:

<7>[ 1438.922118] p54spi_probe
<6>[ 1438.922271] cx3110x spi2.0: firmware: requesting 3826.arm
<6>[ 1439.032744] phy0: p54 detected a LM20 firmware
<6>[ 1439.038267] p54: rx_mtu reduced from 3240 to 2376
<6>[ 1439.043883] phy0: FW rev 2.13.0.0.a.22.8 - Softmac protocol 5.6
<6>[ 1439.049864] phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
<6>[ 1439.055754] cx3110x spi2.0: firmware: requesting 3826.eeprom
<6>[ 1439.159376] cx3110x spi2.0: loading default eeprom...
<6>[ 1439.165723] phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow
<7>[ 1439.222347] phy0: Selected rate control algorithm 'minstrel'
<6>[ 1439.272353] cx3110x spi2.0: device is bound to phy0
<4>[ 1439.618513] Empty flash at 0x01ef1588 ends at 0x01ef1800
<4>[ 1439.768935] Empty flash at 0x02eb9474 ends at 0x02eb9800
<7>[ 1444.630185] usb0: eth_open
<7>[ 1444.630215] usb0: eth_start
<7>[ 1444.630368] g_ether gadget: ecm_open
<7>[ 1466.055751] m0: running mesh housekeeping
<7>[ 1515.025311] phy0: Allocated STA 00:1d:6e:9b:ee:6d
<4>[ 1515.028027] ------------[ cut here ]------------
<4>[ 1515.035626] WARNING: at kernel/softirq.c:138 local_bh_enable+0x54/0xbc()
<4>[ 1515.043316] Modules linked in: p54spi
<4>[ 1515.050976] [<c0034ff8>] (dump_stack+0x0/0x14) from [<c005b1f0>] (warn_on_slowpath+0x4c/0x68)
<4>[ 1515.059308] [<c005b1a4>] (warn_on_slowpath+0x0/0x68) from [<c006051c>] (local_bh_enable+0x54/0xbc)
<4>[ 1515.075696]  r6:c7adae00 r5:c70100a0 r4:c04594a0
<4>[ 1515.084118] [<c00604c8>] (local_bh_enable+0x0/0xbc) from [<bf000038>] (p54spi_op_tx+0x38/0x4c [p54spi])
<4>[ 1515.101422]  r4:c7adae00
<4>[ 1515.109814] [<bf000000>] (p54spi_op_tx+0x0/0x4c [p54spi]) from [<c01a4dbc>] (p54_sta_unlock+0x64/0x78)
<4>[ 1515.127698]  r5:c7ada1a0 r4:c70100a0
<4>[ 1515.136548] [<c01a4d58>] (p54_sta_unlock+0x0/0x78) from [<c01a4df8>] (p54_sta_notify+0x28/0x2c)
<4>[ 1515.146008]  r7:c7f33b80 r6:c7ada1a0 r5:60000013 r4:c7dbf400
<4>[ 1515.155621] [<c01a4dd0>] (p54_sta_notify+0x0/0x2c) from [<c02e0a40>] (sta_info_insert+0x128/0x19c)
<4>[ 1515.175122] [<c02e0918>] (sta_info_insert+0x0/0x19c) from [<c02fdb44>] (mesh_neighbour_update+0x58/0xbc)
<4>[ 1515.196240]  r8:c7f33b80 r7:00000000 r6:00000fff r5:c7ada1a0 r4:c7dbf400
<4>[ 1515.207165] [<c02fdaec>] (mesh_neighbour_update+0x0/0xbc) from [<c02fc398>] (ieee80211_mesh_work+0x188/0x2c4)
<4>[ 1515.229382] [<c02fc210>] (ieee80211_mesh_work+0x0/0x2c4) from [<c006b2bc>] (run_workqueue+0xa8/0x124)
<4>[ 1515.251843] [<c006b214>] (run_workqueue+0x0/0x124) from [<c006be20>] (worker_thread+0xec/0x100)
<4>[ 1515.263653]  r6:c7ace8a0 r5:c79d2000 r4:c7ace8a8
<4>[ 1515.275311] [<c006bd34>] (worker_thread+0x0/0x100) from [<c006ee28>] (kthread+0x5c/0x94)
<4>[ 1515.287274]  r6:c006bd34 r5:c7ace8a0 r4:c79d2000
<4>[ 1515.298962] [<c006edcc>] (kthread+0x0/0x94) from [<c005dd48>] (do_exit+0x0/0x6cc)
<4>[ 1515.310834]  r6:00000000 r5:00000000 r4:00000000
<4>[ 1515.322369] ---[ end trace 6577f51800004055 ]---
<7>[ 1515.333813] phy0: Inserted STA 00:1d:6e:9b:ee:6d
<7>[ 1515.334075] Mesh plink: starting establishment with 00:1d:6e:9b:ee:6d
<7>[ 1515.366638] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 1 55435 0 1
<7>[ 1515.375244] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 2 55435 52255 5
<7>[ 1515.383087] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 55435 52255 7
<7>[ 1515.448926] Mesh plink: starting establishment with 00:1d:6e:9b:ee:6d
<7>[ 1515.565271] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 1 45266 0 1
<7>[ 1515.652472] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 2 45266 42191 1
<7>[ 1515.816619] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 2 45266 42191 1
<7>[ 1515.988764] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 2 45266 42191 1
<7>[ 1516.222413] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 2 45266 42191 7
<7>[ 1516.384869] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1516.474268] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1516.660834] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1517.035595] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1517.620691] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1517.716322] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1517.808898] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1517.996655] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1518.309186] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1518.925549] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1519.047711] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1519.137689] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1519.332318] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1519.567132] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1519.886792] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1520.072015] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1520.162238] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1520.309277] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1520.566906] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1521.027050] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1521.197986] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1521.285534] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1521.449658] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1521.683874] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1522.120782] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1522.222321] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1522.308697] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1522.449658] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1522.722290] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1523.182879] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1523.349408] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1523.441265] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1523.542901] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1523.653998] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1523.808606] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1523.964532] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1524.051355] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1524.238568] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1524.457379] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1524.746228] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1524.885754] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1524.973095] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1525.136694] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1525.395458] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1525.809765] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8
<7>[ 1525.829907] m0: running mesh housekeeping
<7>[ 1525.910473] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1525.996636] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1526.105718] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1526.317089] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 3
<7>[ 1526.573998] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 5 45266 42191 8

2) Today it doesn't reproduce. Plink establishment passes, altough, warning remains:

<6>[    8.237792] cx3110x spi2.0: firmware: requesting 3826.arm
<6>[    8.343169] phy0: p54 detected a LM20 firmware
<6>[    8.348693] p54: rx_mtu reduced from 3240 to 2376
<6>[    8.354369] phy0: FW rev 2.13.0.0.a.22.8 - Softmac protocol 5.6
<6>[    8.360319] phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
<6>[    8.366423] cx3110x spi2.0: firmware: requesting 3826.eeprom
<6>[    8.474607] cx3110x spi2.0: loading default eeprom...
<6>[    8.480833] phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow
<7>[    8.538937] phy0: Selected rate control algorithm 'minstrel'
<6>[    8.588103] cx3110x spi2.0: device is bound to phy0
<4>[    8.946653] Empty flash at 0x01ef1588 ends at 0x01ef1800
<4>[    9.091216] Empty flash at 0x02eb9474 ends at 0x02eb9800
<7>[   13.979885] usb0: eth_open
<7>[   13.979916] usb0: eth_start
<7>[   13.980068] g_ether gadget: ecm_open
<7>[   14.827604] g_ether gadget: notify connect true
<7>[   14.859617] g_ether gadget: notify speed 425984000
<7>[  122.496226] m0: running mesh housekeeping
<7>[  124.771694] phy0: Allocated STA 00:1d:6e:9b:ee:6d
<4>[  124.774440] ------------[ cut here ]------------
<4>[  124.782008] WARNING: at kernel/softirq.c:138 local_bh_enable+0x54/0xbc()
<4>[  124.789729] Modules linked in: p54spi
<4>[  124.797389] [<c0034ff8>] (dump_stack+0x0/0x14) from [<c005b1f0>] (warn_on_slowpath+0x4c/0x68)
<4>[  124.805721] [<c005b1a4>] (warn_on_slowpath+0x0/0x68) from [<c006051c>] (local_bh_enable+0x54/0xbc)
<4>[  124.822139]  r6:c79bbe00 r5:c7ed6e20 r4:c04594a0
<4>[  124.830562] [<c00604c8>] (local_bh_enable+0x0/0xbc) from [<bf000038>] (p54spi_op_tx+0x38/0x4c [p54spi])
<4>[  124.847926]  r4:c79bbe00
<4>[  124.856319] [<bf000000>] (p54spi_op_tx+0x0/0x4c [p54spi]) from [<c01a4dbc>] (p54_sta_unlock+0x64/0x78)
<4>[  124.874233]  r5:c79bb1a0 r4:c7ed6e20
<4>[  124.883083] [<c01a4d58>] (p54_sta_unlock+0x0/0x78) from [<c01a4df8>] (p54_sta_notify+0x28/0x2c)
<4>[  124.892574]  r7:c79a5380 r6:c79bb1a0 r5:60000013 r4:c7fec800
<4>[  124.902187] [<c01a4dd0>] (p54_sta_notify+0x0/0x2c) from [<c02e0a40>] (sta_info_insert+0x128/0x19c)
<4>[  124.921748] [<c02e0918>] (sta_info_insert+0x0/0x19c) from [<c02fdb44>] (mesh_neighbour_update+0x58/0xbc)
<4>[  124.942867]  r8:c79a5380 r7:00000000 r6:00000fff r5:c79bb1a0 r4:c7fec800
<4>[  124.953822] [<c02fdaec>] (mesh_neighbour_update+0x0/0xbc) from [<c02fc398>] (ieee80211_mesh_work+0x188/0x2c4)
<4>[  124.976039] [<c02fc210>] (ieee80211_mesh_work+0x0/0x2c4) from [<c006b2bc>] (run_workqueue+0xa8/0x124)
<4>[  124.998500] [<c006b214>] (run_workqueue+0x0/0x124) from [<c006be20>] (worker_thread+0xec/0x100)
<4>[  125.010341]  r6:c7aca920 r5:c79e8000 r4:c7aca928
<4>[  125.021968] [<c006bd34>] (worker_thread+0x0/0x100) from [<c006ee28>] (kthread+0x5c/0x94)
<4>[  125.033992]  r6:c006bd34 r5:c7aca920 r4:c79e8000
<4>[  125.045711] [<c006edcc>] (kthread+0x0/0x94) from [<c005dd48>] (do_exit+0x0/0x6cc)
<4>[  125.057613]  r6:00000000 r5:00000000 r4:00000000
<4>[  125.069148] ---[ end trace 6577f51800004055 ]---
<7>[  125.080592] phy0: Inserted STA 00:1d:6e:9b:ee:6d
<7>[  125.081085] Mesh plink: starting establishment with 00:1d:6e:9b:ee:6d
<7>[  125.103576] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 1 55435 0 1
<7>[  125.110412] Mesh plink (peer, state, llid, plid, event): 00:1d:6e:9b:ee:6d 2 55435 3385 4
<7>[  125.110473] Mesh plink with 00:1d:6e:9b:ee:6d ESTABLISHED
<7>[  183.146203] m0: running mesh housekeeping
<7>[  243.146171] m0: running mesh housekeeping
<7>[  265.520801] phy0: Removed STA 00:1d:6e:9b:ee:6d
<7>[  265.536378] phy0: Destroyed STA 00:1d:6e:9b:ee:6d

3) Beaconing works, but not the way it should: like MPs don't hear each other. Timestamps never get in sync
and both MPs issue beacon during 0.1s beacon interval.
I've seen it before, with stlc45xx. It shows when LMAC is set up with LMAC_SETUP_IBSS | LMAC_SETUP_TRANSPARENT flags.
If there's no LMAC_SETUP_TRANSPARENT flag in LMAC setup then timestamps get in sync.

(Traced with tshark -T fields -e frame.time -e wlan.sa -e wlan.seq -e wlan.fc.type_subtype -e wlan_mgt.fixed.timestamp)

08:27:47.423880000	00:1d:6e:9b:ee:6c	0	0x08	0x0000000000000580
08:27:47.433851000	00:1d:6e:9b:ee:6c	1	0x08	0x00000000000004ED
08:27:47.437849000	00:1d:6e:9b:ee:6c	2	0x08	0x0000000000000266
08:27:47.443847000	00:1d:6e:9b:ee:6c	3	0x08	0x0000000000000220
08:27:47.546857000	00:1d:6e:9b:ee:6c	4	0x08	0x0000000000019370
08:27:47.649819000	00:1d:6e:9b:ee:6c	5	0x08	0x00000000000326A4
08:27:47.751787000	00:1d:6e:9b:ee:6c	6	0x08	0x000000000004B690
08:27:47.853764000	00:1d:6e:9b:ee:6c	7	0x08	0x0000000000064474
08:27:47.955744000	00:1d:6e:9b:ee:6c	8	0x08	0x000000000007D1F4
08:27:48.058762000	00:1d:6e:9b:ee:6c	9	0x08	0x00000000000965B4
08:27:48.160737000	00:1d:6e:9b:ee:6c	10	0x08	0x00000000000AF398
08:27:48.263704000	00:1d:6e:9b:ee:6c	11	0x08	0x00000000000C830C
08:27:48.366677000	00:1d:6e:9b:ee:6c	12	0x08	0x00000000000E1537
08:27:48.467636000	00:1d:6e:9b:ee:6c	13	0x08	0x00000000000FA26C
08:27:48.571610000	00:1d:6e:9b:ee:6c	14	0x08	0x0000000000113528
08:27:48.673588000	00:1d:6e:9b:ee:6c	15	0x08	0x000000000012C690
08:27:48.775578000	00:1d:6e:9b:ee:6c	16	0x08	0x0000000000145528
08:27:48.877544000	00:1d:6e:9b:ee:6c	17	0x08	0x000000000015E35C
08:27:48.980549000	00:1d:6e:9b:ee:6c	18	0x08	0x0000000000177348
08:27:49.083530000	00:1d:6e:9b:ee:6c	19	0x08	0x0000000000190474
08:27:49.186511000	00:1d:6e:9b:ee:6c	20	0x08	0x00000000001A9690
08:27:49.287465000	00:1d:6e:9b:ee:6c	21	0x08	0x00000000001C2384
08:27:49.390436000	00:1d:6e:9b:ee:6c	22	0x08	0x00000000001DB671
08:27:49.492412000	00:1d:6e:9b:ee:6c	23	0x08	0x00000000001F44C4
08:27:49.595410000	00:1d:6e:9b:ee:6c	24	0x08	0x000000000020D3E9
08:27:49.696370000	00:1d:6e:9b:ee:6d	0	0x08	0x0000000000000569
08:27:49.698362000	00:1d:6e:9b:ee:6c	25	0x08	0x0000000000226656
08:27:49.712360000	00:1d:6e:9b:ee:6d	1	0x08	0x000000000000023D
08:27:49.713360000	00:1d:6e:9b:ee:6d	2	0x08	0x0000000000000438
08:27:49.719359000	00:1d:6e:9b:ee:6d	3	0x08	0x0000000000000296
08:27:49.720358000	00:1d:6e:9b:ee:6d	4	0x08	0x0000000000000613
08:27:49.799379000	00:1d:6e:9b:ee:6c	26	0x08	0x000000000023F2D2
08:27:49.823342000	00:1d:6e:9b:ee:6d	5	0x08	0x00000000000196A5
08:27:49.902330000	00:1d:6e:9b:ee:6c	27	0x08	0x00000000002583EA
08:27:49.925317000	00:1d:6e:9b:ee:6d	6	0x08	0x00000000000326D7
08:27:50.004346000	00:1d:6e:9b:ee:6c	28	0x08	0x00000000002712FA
08:27:50.010336000	00:1d:6e:9b:ee:6c	0	0x0d	
08:27:50.011399000			0x1d	
08:27:50.027297000	00:1d:6e:9b:ee:6d	7	0x08	0x000000000004B26D
08:27:50.028290000	00:1d:6e:9b:ee:6d	0	0x0d	
08:27:50.029305000			0x1d	
08:27:50.030287000	00:1d:6e:9b:ee:6c	1	0x0d	
08:27:50.031295000			0x1d	
08:27:50.032286000	00:1d:6e:9b:ee:6d	1	0x0d	
08:27:50.033295000			0x1d	
08:27:50.108304000	00:1d:6e:9b:ee:6c	29	0x08	0x000000000028A6CD
08:27:50.129274000	00:1d:6e:9b:ee:6d	8	0x08	0x0000000000064399
08:27:50.210268000	00:1d:6e:9b:ee:6c	30	0x08	0x00000000002A357A
08:27:50.232249000	00:1d:6e:9b:ee:6d	9	0x08	0x000000000007D30D
08:27:50.312234000	00:1d:6e:9b:ee:6c	31	0x08	0x00000000002BC642
08:27:50.334228000	00:1d:6e:9b:ee:6d	10	0x08	0x00000000000964ED
08:27:50.414218000	00:1d:6e:9b:ee:6c	32	0x08	0x00000000002D52E6
08:27:50.436206000	00:1d:6e:9b:ee:6d	11	0x08	0x00000000000AF26D
08:27:50.517218000	00:1d:6e:9b:ee:6c	33	0x08	0x00000000002EE6B9
08:27:50.539201000	00:1d:6e:9b:ee:6d	12	0x08	0x00000000000C8529
08:27:50.619169000	00:1d:6e:9b:ee:6c	34	0x08	0x00000000003073EA
08:27:50.642167000	00:1d:6e:9b:ee:6d	13	0x08	0x00000000000E1691

4) Pings don't go, because MPs don't answer ARP requests sent to it. Haven't tested for the root cause yet.
But again, I have seen this with stlc45xx with two different causes:
- when LMAC was set up without LMAC_SETUP_TRANSPARENT flag, ARP requests didn't pass LMAC packet filter
  and weren't reported to the driver;
- when LMAC was set up with LMAC_SETUP_TRANSPARENT flag firmware seem to truncate last 2 bytes of the packet
  that it reports.

> Is there anything else I can do, or something you want to know?
Are there other p54 species that use 3826.arm firmware?

Are there other sources of information regarding LMAC interaction except
http://wireless.kernel.org/en/developers/Documentation/specs?action=AttachFile&do=get&target=STSW45x0C_LMAC_API_ED1P4.pdf ?

Who should be contacted with questions about firmware behavior?

-- 
Thanks.
-- Max
