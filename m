Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:56004 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab0GYWON (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jul 2010 18:14:13 -0400
Received: from [192.168.10.100] (95.232.142.62) by smtp209.alice.it (8.5.124.08) (authenticated as editempo)
        id 4C1A2759026CE9F6 for linux-wireless@vger.kernel.org; Mon, 26 Jul 2010 00:14:08 +0200
Subject: wl1251 blocking soon after association(before it blocked about
 30min after association)
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Jul 2010 00:14:03 +0200
Message-ID: <1280096043.11106.0.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi, I'm still fighting with my wl1251_sdio issues on my htcdream under
GNU/Linux(not android).
I've found that patch for wl1271:
http://www.spinics.net/lists/linux-wireless/msg46931.html
,and I rebased it for wl1251(should I send a git patch for it?).

but I've still some issues.
Here on a public wireless access point I have:
[  315.377563] wl1251: intr: 0x8
[  315.377624] wl1251: RX: FW +1
[  315.377624] wl1251: RX counter: 8
[  315.377655] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.377777] wl1251: rx skb 0xc6b8ed80: 55 B 
[  315.557312] wl1251: IRQ
[  315.557403] wl1251: IRQ work
[  315.557556] wl1251: intr: 0x9
[  315.557586] wl1251: RX: FW +2
[  315.557617] wl1251: RX counter: 10
[  315.557617] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.557739] wl1251: rx skb 0xc69eb6c0: 135 B 
[  315.557922] wl1251: WL1251_ACX_INTR_RX1_DATA
[  315.558044] wl1251: rx skb 0xc69eb6c0: 135 B 
[  315.558197] wl1251: RX: FW +2
[  315.558227] wl1251: RX counter: 12
[  315.558227] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.558349] wl1251: rx skb 0xc69eb6c0: 135 B 
[  315.558441] wl1251: WL1251_ACX_INTR_RX1_DATA
[  315.558563] wl1251: rx skb 0xc69eb6c0: 109 B 
[  315.558715] wl1251: RX: FW and host in sync
[  315.558746] wl1251: RX counter: 12
[  315.558776] wl1251: INTR is 0
[  315.567382] wl1251: IRQ
[  315.569396] wl1251: IRQ work
[  315.569580] wl1251: intr: 0x1
[  315.569641] wl1251: RX: FW +1
[  315.569641] wl1251: RX counter: 13
[  315.569671] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.569793] wl1251: rx skb 0xc4026240: 141 B beacon
[  315.587310] wl1251: IRQ
[  315.587493] wl1251: IRQ work
[  315.587646] wl1251: intr: 0x8
[  315.587707] wl1251: RX: FW +1
[  315.587738] wl1251: RX counter: 14
[  315.587738] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.587860] wl1251: rx skb 0xc4026240: 115 B beacon
[  315.627288] wl1251: IRQ
[  315.627410] wl1251: IRQ work
[  315.627563] wl1251: intr: 0x9
[  315.627624] wl1251: RX: FW +2
[  315.627624] wl1251: RX counter: 0
[  315.627655] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.627777] wl1251: rx skb 0xc4026300: 145 B 
[  315.627929] wl1251: WL1251_ACX_INTR_RX1_DATA
[  315.628051] wl1251: rx skb 0xc4026300: 145 B 
[  315.637390] wl1251: IRQ
[  315.639068] wl1251: IRQ work
[  315.639251] wl1251: intr: 0x1
[  315.639312] wl1251: RX: FW +1
[  315.639343] wl1251: RX counter: 1
[  315.639343] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.639465] wl1251: rx skb 0xc6a2ec00: 145 B 
[  315.767364] wl1251: IRQ
[  315.767517] wl1251: IRQ work
[  315.767669] wl1251: intr: 0x18
[  315.767730] wl1251: RX: FW +1
[  315.767761] wl1251: RX counter: 2
[  315.767761] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.767883] wl1251: rx skb 0xc6b8e780: 24 B 
[  315.767974] wl1251: WL1251_ACX_INTR_EVENT (0x11)
[  315.768005] wl1251: EVENT on mbox 0
[  315.768066] wl1251: MBOX DUMP:
[  315.768096] wl1251: 	vector: 0x8
[  315.768096] wl1251: 	mask: 0xe73f7f57
[  315.768096] wl1251: vector: 0x8
[  315.768127] wl1251: status: 0x8d, channels: 51995
[  315.768188] wl1251: mac80211 config ch 1 psm off power 20
[  315.768218] wl1251: mac80211 config ch 1 psm off power 20
[  315.768218] wl1251: mac80211 hw scan completed
[  315.827362] wl1251: IRQ
[  315.827514] wl1251: IRQ work
[  315.827636] wl1251: intr: 0x1
[  315.827697] wl1251: RX: FW +1
[  315.827728] wl1251: RX counter: 3
[  315.827728] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.827850] wl1251: rx skb 0xc6afc780: 24 B 
[  315.947326] wl1251: IRQ
[  315.947448] wl1251: IRQ work
[  315.947601] wl1251: intr: 0x8
[  315.947662] wl1251: RX: FW +1
[  315.947692] wl1251: RX counter: 4
[  315.947692] wl1251: WL1251_ACX_INTR_RX0_DATA
[  315.947814] wl1251: rx skb 0xc6afc000: 24 B 
[  316.067352] wl1251: IRQ
[  316.067474] wl1251: IRQ work
[  316.067626] wl1251: intr: 0x1
[  316.067687] wl1251: RX: FW +1
[  316.067687] wl1251: RX counter: 5
[  316.067718] wl1251: WL1251_ACX_INTR_RX0_DATA
[  316.067810] wl1251: rx skb 0xc4026e40: 24 B 
[  316.177368] wl1251: IRQ
[  316.177459] wl1251: IRQ work
[  316.177581] wl1251: intr: 0x8
[  316.177642] wl1251: RX: FW +1
[  316.177673] wl1251: RX counter: 6
[  316.177673] wl1251: WL1251_ACX_INTR_RX0_DATA
[  316.177795] wl1251: rx skb 0xc6ab8600: 24 B 
[  316.237304] wl1251: IRQ
[  316.237396] wl1251: IRQ work
[  316.237548] wl1251: intr: 0x1
[  316.237609] wl1251: RX: FW +1
[  316.237640] wl1251: RX counter: 7
[  316.237640] wl1251: WL1251_ACX_INTR_RX0_DATA
[  316.237731] wl1251: rx skb 0xc6a2e0c0: 24 B 
[  316.347351] wl1251: IRQ
[  316.347473] wl1251: IRQ work
[  316.347625] wl1251: intr: 0x8
[  316.347686] wl1251: RX: FW +1
[  316.347686] wl1251: RX counter: 8
[  316.347717] wl1251: WL1251_ACX_INTR_RX0_DATA
[  316.347808] wl1251: rx skb 0xc6b8e600: 24 B 
[  316.877349] wl1251: IRQ
[  316.877441] wl1251: IRQ work
[  316.877563] wl1251: intr: 0x1
[  316.877624] wl1251: RX: FW +1
[  316.877624] wl1251: RX counter: 9
[  316.877655] wl1251: WL1251_ACX_INTR_RX0_DATA
[  316.877746] wl1251: rx skb 0xc69eb540: 16 B 
[  317.027404] wl1251: IRQ
[  317.027526] wl1251: IRQ work
[  317.027679] wl1251: intr: 0x9
[  317.027740] wl1251: RX: FW +2
[  317.027770] wl1251: RX counter: 11
[  317.027770] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.027923] wl1251: rx skb 0xc6afc780: 265 B beacon
[  317.028015] wl1251: WL1251_ACX_INTR_RX1_DATA
[  317.028137] wl1251: rx skb 0xc6afc540: 265 B beacon
[  317.037353] wl1251: IRQ
[  317.039031] wl1251: IRQ work
[  317.039215] wl1251: intr: 0x8
[  317.039276] wl1251: RX: FW +1
[  317.039306] wl1251: RX counter: 12
[  317.039306] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.039459] wl1251: rx skb 0xc40266c0: 251 B beacon
[  317.057312] wl1251: IRQ
[  317.057434] wl1251: IRQ work
[  317.057586] wl1251: intr: 0x1
[  317.057617] wl1251: RX: FW +1
[  317.057647] wl1251: RX counter: 13
[  317.057647] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.057769] wl1251: rx skb 0xc4026e40: 24 B 
[  317.127349] wl1251: IRQ
[  317.127471] wl1251: IRQ work
[  317.127624] wl1251: intr: 0x8
[  317.127685] wl1251: RX: FW +1
[  317.127685] wl1251: RX counter: 14
[  317.127716] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.127838] wl1251: rx skb 0xc6ab8f00: 265 B beacon
[  317.137329] wl1251: IRQ
[  317.138793] wl1251: IRQ work
[  317.138977] wl1251: intr: 0x1
[  317.139038] wl1251: RX: FW +1
[  317.139068] wl1251: RX counter: 15
[  317.139068] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.139221] wl1251: rx skb 0xc6a2e300: 277 B beacon
[  317.237365] wl1251: IRQ
[  317.237457] wl1251: IRQ work
[  317.237579] wl1251: intr: 0x9
[  317.237640] wl1251: RX: FW +2
[  317.237670] wl1251: RX counter: 1
[  317.237670] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.237792] wl1251: rx skb 0xc6b8e3c0: 265 B beacon
[  317.237915] wl1251: WL1251_ACX_INTR_RX1_DATA
[  317.238037] wl1251: rx skb 0xc6b8e780: 277 B beacon
[  317.337310] wl1251: IRQ
[  317.337371] wl1251: IRQ work
[  317.337524] wl1251: intr: 0x9
[  317.337585] wl1251: RX: FW +2
[  317.337585] wl1251: RX counter: 3
[  317.337615] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.337738] wl1251: rx skb 0xc69ebd80: 265 B beacon
[  317.337860] wl1251: WL1251_ACX_INTR_RX1_DATA
[  317.337982] wl1251: rx skb 0xc69ebf00: 265 B beacon
[  317.338134] wl1251: RX: FW +1
[  317.338134] wl1251: RX counter: 4
[  317.338165] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.338287] wl1251: rx skb 0xc6afcb40: 251 B beacon
[  317.447357] wl1251: IRQ
[  317.447479] wl1251: IRQ work
[  317.447631] wl1251: intr: 0x1
[  317.447692] wl1251: RX: FW +1
[  317.447692] wl1251: RX counter: 5
[  317.447723] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.447845] wl1251: rx skb 0xc40263c0: 251 B beacon
[  317.547363] wl1251: IRQ
[  317.547485] wl1251: IRQ work
[  317.547637] wl1251: intr: 0x9
[  317.547698] wl1251: RX: FW +2
[  317.547698] wl1251: RX counter: 7
[  317.547729] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.547851] wl1251: rx skb 0xc6ab8600: 265 B beacon
[  317.547943] wl1251: WL1251_ACX_INTR_RX1_DATA
[  317.548095] wl1251: rx skb 0xc6ab8780: 277 B beacon
[  317.647338] wl1251: IRQ
[  317.647460] wl1251: IRQ work
[  317.647583] wl1251: intr: 0x8
[  317.647644] wl1251: RX: FW +1
[  317.647674] wl1251: RX counter: 8
[  317.647674] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.647827] wl1251: rx skb 0xc6a2e480: 251 B beacon
[  317.957336] wl1251: IRQ
[  317.957427] wl1251: IRQ work
[  317.957550] wl1251: intr: 0x1
[  317.957611] wl1251: RX: FW +1
[  317.957641] wl1251: RX counter: 9
[  317.957641] wl1251: WL1251_ACX_INTR_RX0_DATA
[  317.957763] wl1251: rx skb 0xc6b8e300: 24 B 
[  321.817321] wl1251: IRQ
[  321.817413] wl1251: IRQ work
[  321.817565] wl1251: intr: 0x8
[  321.817626] wl1251: RX: FW +1
[  321.817626] wl1251: RX counter: 10
[  321.817657] wl1251: WL1251_ACX_INTR_RX0_DATA
[  321.817749] wl1251: rx skb 0xc6b8e6c0: 24 B 
[  324.857330] wl1251: IRQ
[  324.857421] wl1251: IRQ work
[  324.857574] wl1251: intr: 0x1
[  324.857604] wl1251: RX: FW +1
[  324.857635] wl1251: RX counter: 11
[  324.857635] wl1251: WL1251_ACX_INTR_RX0_DATA
[  324.857757] wl1251: rx skb 0xc69eb540: 24 B 
[  325.837463] wl1251: mac80211 config ch 1 psm off power 20
[  325.837493] wl1251: mac80211 config ch 6 psm off power 20
[  325.837524] wl1251: acx frame rates
[  325.837524] wl1251: cmd configure
[  325.857513] wl1251: cmd join ch 6 100/1
[  325.897399] wlan0: authenticate with 00:09:5b:3b:ea:f0 (try 1)
[  325.897735] wl1251: tx id 0 skb 0xc6afc840 payload 30 rate 0x1 queue
3
[  325.907348] wl1251: IRQ
[  325.908203] wl1251: IRQ work
[  325.908386] wl1251: intr: 0xa
[  325.908447] wl1251: RX: FW +2
[  325.908477] wl1251: RX counter: 13
[  325.908477] wl1251: WL1251_ACX_INTR_RX0_DATA
[  325.908599] wl1251: rx skb 0xc4026300: 30 B 
[  325.908721] wl1251: WL1251_ACX_INTR_RX1_DATA
[  325.908905] wl1251: rx skb 0xc40260c0: 61 B beacon
[  325.908996] wl1251: WL1251_ACX_INTR_TX_RESULT
[  325.909576] wl1251: tx status id 0 skb 0xc6afc840 failures 0 rate 0x1
status 0x0 ()
[  325.909790] wl1251: RX: FW and host in sync
[  325.909790] wl1251: RX counter: 13
[  325.909820] wl1251: INTR is 0
[  325.909881] wlan0: authenticated
[  325.910095] wlan0: associate with 00:09:5b:3b:ea:f0 (try 1)
[  325.912994] wl1251: tx id 0 skb 0xc4026300 payload 44 rate 0x1 queue
3
[  325.917327] wl1251: IRQ
[  325.919250] wl1251: IRQ work
[  325.919433] wl1251: intr: 0xa
[  325.919525] wl1251: RX: FW +1
[  325.919525] wl1251: RX counter: 14
[  325.919525] wl1251: WL1251_ACX_INTR_RX0_DATA
[  325.919647] wl1251: rx skb 0xc6ab8000: 36 B 
[  325.919769] wl1251: WL1251_ACX_INTR_TX_RESULT
[  325.921508] wl1251: tx status id 0 skb 0xc4026300 failures 0 rate 0x1
status 0x0 ()
[  325.921752] wlan0: RX AssocResp from 00:09:5b:3b:ea:f0 (capab=0x1
status=0 aid=114)
[  325.921783] wlan0: associated
[  325.922546] wl1251: mac80211 conf tx 0
[  325.922576] wl1251: acx ac cfg 3 cw_ming 7 cw_max 15 aifs 2 txop 3264
[  325.922576] wl1251: cmd configure
[  325.937438] wl1251: acx tid cfg 3 type 1 tsid 3 ps_scheme 0
ack_policy 0
[  325.937500] wl1251: cmd configure
[  325.957489] wl1251: mac80211 conf tx 1
[  325.957519] wl1251: acx ac cfg 2 cw_ming 15 cw_max 31 aifs 2 txop
6016
[  325.957550] wl1251: cmd configure
[  325.977478] wl1251: acx tid cfg 2 type 1 tsid 2 ps_scheme 0
ack_policy 0
[  325.977508] wl1251: cmd configure
[  325.997528] wl1251: mac80211 conf tx 2
[  325.997558] wl1251: acx ac cfg 0 cw_ming 31 cw_max 1023 aifs 3 txop 0
[  325.997589] wl1251: cmd configure
[  326.017364] wl1251: IRQ
[  326.017578] wl1251: acx tid cfg 0 type 1 tsid 0 ps_scheme 0
ack_policy 0
[  326.017608] wl1251: cmd configure
[  326.027313] wl1251: IRQ
[  326.037322] wl1251: IRQ
[  326.037536] wl1251: mac80211 conf tx 3
[  326.037567] wl1251: acx ac cfg 1 cw_ming 31 cw_max 1023 aifs 7 txop 0
[  326.037597] wl1251: cmd configure
[  326.047393] wl1251: IRQ
[  326.057342] wl1251: IRQ
[  326.057556] wl1251: acx tid cfg 1 type 1 tsid 1 ps_scheme 0
ack_policy 0
[  326.057586] wl1251: cmd configure
[  326.067382] wl1251: IRQ
[  326.077362] wl1251: IRQ
[  326.077575] wl1251: mac80211 bss info changed
[  326.077606] wl1251: mac80211 bss info changed
[  326.077636] wl1251: cmd template 21
[  326.087371] wl1251: IRQ
[  326.097381] wl1251: IRQ
[  326.097564] wl1251: cmd template 31
[  326.098663] wl1251: acx frame rates
[  326.098693] wl1251: cmd configure
[  326.107330] wl1251: IRQ
[  326.117340] wl1251: IRQ
[  326.117553] wl1251: cmd join ch 6 100/1
[  326.127319] wl1251: IRQ
[  326.137329] wl1251: IRQ
[  326.147369] wl1251: IRQ
[  326.157318] wl1251: IRQ
[  326.157409] wl1251: cmd template 30
[  326.167327] wl1251: IRQ
[  326.177337] wl1251: IRQ
[  326.177520] wl1251: acx aid
[  326.177551] wl1251: cmd configure
[  326.187316] wl1251: IRQ
[  326.197357] wl1251: IRQ
[  326.197814] wl1251: IRQ work
[  326.197937] wl1251: intr: 0x9
[  326.197998] wl1251: RX: FW +2
[  326.198028] wl1251: RX counter: 0
[  326.198028] wl1251: WL1251_ACX_INTR_RX0_DATA
[  326.198242] wl1251: rx skb 0xc40260c0: 61 B beacon
[  326.198364] wl1251: WL1251_ACX_INTR_RX1_DATA
[  326.198760] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  326.199981] wl1251: rx skb 0xc4026300: 61 B beacon
[  326.200408] wl1251: tx id 0 skb 0xc6afccc0 payload 24 rate 0x1 queue
3
[  326.200592] wl1251: mac80211 configure filter
[  326.207366] wl1251: IRQ
[  326.209320] wl1251: IRQ work
[  326.209503] wl1251: intr: 0x2
[  326.209564] wl1251: RX: FW and host in sync
[  326.209594] wl1251: RX counter: 0
[  326.209594] wl1251: WL1251_ACX_INTR_TX_RESULT
[  326.210510] wl1251: tx status id 0 skb 0xc6afccc0 failures 0 rate 0x1
status 0x0 ()
[  326.217590] wl1251: IRQ
[  326.218841] wl1251: tx id 0 skb 0xc6ab8d80 payload 108 rate 0x1 queue
0
[  326.218933] wl1251: IRQ work
[  326.219024] wl1251: intr: 0x1
[  326.219055] wl1251: RX: FW +1
[  326.219085] wl1251: RX counter: 1
[  326.219085] wl1251: WL1251_ACX_INTR_RX0_DATA
[  326.219299] wl1251: rx skb 0xc6ab8000: 61 B beacon
[  326.227294] wl1251: IRQ
[  326.227478] wl1251: IRQ work
[  326.227630] wl1251: intr: 0x2
[  326.227691] wl1251: RX: FW and host in sync
[  326.227691] wl1251: RX counter: 1
[  326.227722] wl1251: WL1251_ACX_INTR_TX_RESULT
[  326.228912] wl1251: tx status id 0 skb 0xc6ab8d80 failures 0 rate 0x1
status 0x0 ()
[  326.317413] wl1251: mac80211 config ch 6 psm on power 20
[  326.317443] wl1251: psm enabled
[  326.317443] wl1251: acx tbtt and dtim
[  326.317474] wl1251: cmd configure
[  326.327362] wl1251: IRQ
[  326.337341] wl1251: IRQ
[  326.337554] wl1251: entering psm
[  326.337554] wl1251: acx beacon filter opt
[  326.337585] wl1251: cmd configure
[  326.347320] wl1251: IRQ
[  326.357330] wl1251: IRQ
[  326.357513] wl1251: acx wake up conditions
[  326.357543] wl1251: cmd configure
[  326.367340] wl1251: IRQ
[  326.377349] wl1251: IRQ
[  326.377563] wl1251: cmd set ps mode
[  326.387329] wl1251: IRQ
[  326.397369] wl1251: IRQ
[  326.397583] wl1251: sleep auth psm/elp
[  326.397613] wl1251: acx sleep auth
[  326.397613] wl1251: cmd configure
[  326.407379] wl1251: IRQ
[  326.417327] wl1251: IRQ
[  326.417541] wl1251: IRQ work
[  326.417663] wl1251: intr: 0x8
[  326.417724] wl1251: RX: FW +1
[  326.417724] wl1251: RX counter: 2
[  326.417755] wl1251: WL1251_ACX_INTR_RX0_DATA
[  326.417968] wl1251: rx skb 0xc69eb6c0: 61 B beacon
[  326.427368] wl1251: IRQ
[  326.428833] wl1251: elp work
[  326.428863] wl1251: chip to elp
[  326.428924] wl1251: IRQ work
[  326.428924] wl1251: waking up chip from elp
[  326.428985] wl1251: wakeup time: 0 ms
[  326.429138] wl1251: intr: 0x1
[  326.429168] wl1251: RX: FW +1
[  326.429199] wl1251: RX counter: 3
[  326.429199] wl1251: WL1251_ACX_INTR_RX0_DATA
[  326.429443] wl1251: rx skb 0xc6afc540: 61 B beacon
[  326.438903] wl1251: elp work
[  326.438934] wl1251: chip to elp
[  326.522308] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  327.027587] wl1251: mac80211 config ch 6 psm off power 20
[  327.027618] wl1251: waking up chip from elp
[  327.027679] mmc0: Command CRC error
[  327.027709] wl1251: ERROR sdio_writeb failed (-84)
[  327.147369] wl1251: ERROR elp wakeup timeout
[  327.147460] wl1251: mac80211 config ch 6 psm on power 20
[  327.147491] wl1251: waking up chip from elp
[  327.267333] wl1251: ERROR elp wakeup timeout
[  327.267364] wl1251: waking up chip from elp
[  327.347381] wl1251: wakeup time: 80 ms
[  327.347625] wl1251: tx id 0 skb 0xc4026540 payload 96 rate 0x1 queue
0
[  327.347717] wl1251: mac80211 config ch 6 psm off power 20
[  327.347717] wl1251: psm disabled
[  327.347747] wl1251: leaving psm
[  327.347747] wl1251: sleep auth cam
[  327.347778] wl1251: acx sleep auth
[  327.347778] wl1251: cmd configure
[  327.367462] wl1251: acx beacon filter opt
[  327.367492] wl1251: cmd configure
[  327.387451] wl1251: acx wake up conditions
[  327.387512] wl1251: cmd configure
[  327.407470] wl1251: cmd set ps mode
[  327.407714] wl1251: mac80211 config ch 6 psm on power 20
[  327.407745] wl1251: psm enabled
[  327.407745] wl1251: acx tbtt and dtim
[  327.407775] wl1251: cmd configure
[  327.427459] wl1251: entering psm
[  327.427490] wl1251: acx beacon filter opt
[  327.427490] wl1251: cmd configure
[  327.447479] wl1251: acx wake up conditions
[  327.447540] wl1251: cmd configure
[  327.467498] wl1251: cmd set ps mode
[  327.487487] wl1251: sleep auth psm/elp
[  327.487518] wl1251: acx sleep auth
[  327.487548] wl1251: cmd configure
[  327.507446] wl1251: elp work
[  327.507476] wl1251: chip to elp
[  327.507537] wl1251: waking up chip from elp
[  327.507598] wl1251: wakeup time: 0 ms
[  327.509338] wl1251: tx id 1 skb 0xc40263c0 payload 108 rate 0x1 queue
0
[  327.518310] wl1251: elp work
[  327.518341] wl1251: chip to elp
[  327.527343] wl1251: IRQ
[  327.528289] wl1251: IRQ work
[  327.528320] wl1251: waking up chip from elp
[  327.528411] wl1251: wakeup time: 0 ms
[  327.528533] wl1251: intr: 0x2
[  327.528594] wl1251: RX: FW and host in sync
[  327.528625] wl1251: RX counter: 3
[  327.528625] wl1251: WL1251_ACX_INTR_TX_RESULT
[  327.530090] wl1251: tx status id 0 skb 0xc4026540 failures 0 rate 0x1
status 0x0 ()
[  327.530151] wl1251: tx status id 1 skb 0xc40263c0 failures 0 rate 0x1
status 0x0 ()
[  327.538848] wl1251: elp work
[  327.538879] wl1251: chip to elp
[  327.612335] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  328.027679] wl1251: mac80211 config ch 6 psm off power 20
[  328.027709] wl1251: waking up chip from elp
[  328.027770] mmc0: Command CRC error
[  328.027801] wl1251: ERROR sdio_writeb failed (-84)
[  328.147369] wl1251: ERROR elp wakeup timeout
[  328.147460] wl1251: mac80211 config ch 6 psm on power 20
[  328.147460] wl1251: waking up chip from elp
[  328.267364] wl1251: ERROR elp wakeup timeout
[  328.267395] wl1251: waking up chip from elp
[  328.387298] wl1251: ERROR elp wakeup timeout
[  328.622344] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  329.627349] mmc0: Command CRC error
[  329.627410] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[  330.637390] wl1251: IRQ
[  330.637481] wl1251: IRQ work
[  330.637512] wl1251: waking up chip from elp
[  330.637573] wl1251: wakeup time: 0 ms
[  330.637725] wl1251: intr: 0x29
[  330.637756] wl1251: RX: FW +2
[  330.637786] wl1251: RX counter: 5
[  330.637786] wl1251: WL1251_ACX_INTR_RX0_DATA
[  330.637939] wl1251: rx skb 0xc6b8e3c0: 299 B 
[  330.638031] wl1251: WL1251_ACX_INTR_RX1_DATA
[  330.638153] wl1251: rx skb 0xc6b8e3c0: 274 B 
[  330.638244] wl1251: WL1251_ACX_INTR_EVENT (0x29)
[  330.638244] wl1251: EVENT on mbox 1
[  330.638305] wl1251: MBOX DUMP:
[  330.638336] wl1251: 	vector: 0x20
[  330.638336] wl1251: 	mask: 0xe73f7f57
[  330.638336] wl1251: vector: 0x20
[  330.821960] wl1251: RX: FW +1
[  330.822021] wl1251: RX counter: 6
[  330.822021] wl1251: WL1251_ACX_INTR_RX0_DATA
[  330.822204] wl1251: rx skb 0xc6afc180: 403 B 
[  330.828277] wl1251: elp work
[  330.828338] wl1251: chip to elp
[  330.842346] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  331.847412] mmc0: Command CRC error
[  331.847473] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[  332.027648] wl1251: mac80211 config ch 6 psm off power 20
[  332.027679] wl1251: waking up chip from elp
[  332.147399] wl1251: ERROR elp wakeup timeout
[  332.147491] wl1251: mac80211 config ch 6 psm on power 20
[  332.147491] wl1251: waking up chip from elp
[  332.267395] wl1251: ERROR elp wakeup timeout
[  332.267425] wl1251: waking up chip from elp
[  332.387451] wl1251: ERROR elp wakeup timeout
[  332.862396] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[  333.867401] mmc0: Command CRC error
[  333.867492] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[  334.877380] wl1251: IRQ
[  334.877471] wl1251: IRQ work
[  334.877502] wl1251: waking up chip from elp
[  334.877563] wl1251: wakeup time: 0 ms
[  334.877716] wl1251: intr: 0x9
[  334.877777] wl1251: RX: FW +2
[  334.877777] wl1251: RX counter: 8
[  334.877807] wl1251: WL1251_ACX_INTR_RX0_DATA
[  334.877960] wl1251: rx skb 0xc4026780: 418 B 
[  334.878051] wl1251: WL1251_ACX_INTR_RX1_DATA
[  334.878173] wl1251: rx skb 0xc4026780: 84 B 
[  334.878295] wl1251: RX: FW +2
[  334.878295] wl1251: RX counter: 10
[  334.878326] wl1251: WL1251_ACX_INTR_RX0_DATA
[  334.878417] wl1251: rx skb 0xc4026780: 187 B 
[  334.878509] wl1251: WL1251_ACX_INTR_RX1_DATA
[  336.878479] mmc0: Data timeout
[  336.880310] wl1251: ERROR sdio read failed (-110)
[  336.880462] wl1251: IRQ
[  336.880493] wl1251: WARNING curr ID:1, last ID inc:2
[  337.027191] wlan0: no IPv6 routers present
Then it is blocked.
Ifconfig wlan0 down is blocked for instance.
should I trace the problem with the kernel "detect soft lockup" and
"detect hang task" detection?

I did iwlist wlan0 scan | grep ESSID
iwconfig wlan0 essid EssidName

Note that I recently rebased against a more recent 2.6.32 android
kernel.
so at first I tought that it was blocking very early because of that(it
didn't some time ago,it blocked after 30 min or something like that)
but I tried the old kernel with the recent compat-wireless.
So it may be the compat-wireless version which causes the very rapid
block

Denis.


