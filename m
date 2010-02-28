Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:47531 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968188Ab0B1PQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 10:16:38 -0500
Received: by qyk9 with SMTP id 9so896631qyk.5
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 07:16:37 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 28 Feb 2010 23:16:36 +0800
Message-ID: <d82e647a1002280716h342c7a1cu552ffdf908f495e6@mail.gmail.com>
Subject: ath9k: wireless-test can't work in ht40
From: Ming Lei <tom.leiming@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

My atheros 11n card does not work in ht40 mode using the current
wireless test tree,
but it can work in ht40 if using 2.6.33 or 2.6.32 mainline.

Follows the dmesg information, hope it is helpful to troubleshoot the issue.

[  245.233755] bus: 'pci': add driver ath9k
[  245.233809] bus: 'pci': driver_probe_device: matched device
0000:16:00.0 with driver ath9k
[  245.233813] bus: 'pci': really_probe: probing driver ath9k with
device 0000:16:00.0
[  245.233866] ath9k 0000:16:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  245.668698] ath: Eeprom VER: 14, REV: 8
[  245.670918] ath: EEPROM regdomain: 0x0
[  245.670920] ath: EEPROM indicates default country code should be used
[  245.670922] ath: doing EEPROM country->regdmn map search
[  245.670924] ath: country maps to regdmn code: 0x3a
[  245.670926] ath: Country alpha2 being used: US
[  245.670928] ath: Regpair used: 0x3a
[  245.670933] ath: tx DMA: 512 buffers 1 desc/buf
[  245.670967] ath: tx DMA map: ffff880073720000 (77824) -> 73720000 (77824)
[  245.671188] ath: beacon DMA: 4 buffers 1 desc/buf
[  245.671194] ath: beacon DMA map: ffff880070bf9000 (608) -> 70bf9000 (608)
[  245.671208] ath: cachelsz 64 rxbufsize 3904
[  245.671211] ath: rx DMA: 512 buffers 1 desc/buf
[  245.671244] ath: rx DMA map: ffff880073780000 (77824) -> 73780000 (77824)
[  245.680266] device: 'phy3': device_add
[  245.680502] PM: Adding info for No Bus:phy3
[  245.681247] device: 'rfkill4': device_add
[  245.681488] PM: Adding info for No Bus:rfkill4
[  245.683412] phy3: Selected rate control algorithm 'ath9k_rate_control'
[  245.683649] device: 'wlan0': device_add
[  245.684564] PM: Adding info for No Bus:wlan0
[  245.685824] device: 'ath9k-phy3::radio': device_add
[  245.686081] PM: Adding info for No Bus:ath9k-phy3::radio
[  245.686722] Registered led device: ath9k-phy3::radio
[  245.686755] device: 'ath9k-phy3::assoc': device_add
[  245.686895] PM: Adding info for No Bus:ath9k-phy3::assoc
[  245.687719] Registered led device: ath9k-phy3::assoc
[  245.687752] device: 'ath9k-phy3::tx': device_add
[  245.687896] PM: Adding info for No Bus:ath9k-phy3::tx
[  245.688672] Registered led device: ath9k-phy3::tx
[  245.688707] device: 'ath9k-phy3::rx': device_add
[  245.688840] PM: Adding info for No Bus:ath9k-phy3::rx
[  245.689611] Registered led device: ath9k-phy3::rx
[  245.689618] phy3: Atheros AR5416 MAC/BB Rev:2 AR5133 RF Rev:81
mem=0xffffc90016660000, irq=16
[  245.689621] driver: '0000:16:00.0': driver_bound: bound to device 'ath9k'
[  245.689626] bus: 'pci': really_probe: bound device 0000:16:00.0 to
driver ath9k
[  245.704350] device: 'wlan0': device_rename: renaming to 'wlan1'
[  245.707519] udev: renamed network interface wlan0 to wlan1
[  250.267697] ath: Starting driver with initial channel: 2412 MHz
[  250.268482] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  250.270113] ath: Attach a VIF of type: 2
[  250.270206] ath: BSS Changed PREAMBLE 0
[  250.270209] ath: BSS Changed CTS PROT 0
[  250.272155] ath: Marking phy3 as idle
[  250.272915] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  250.274677] ath: not-idle: enabling radio
[  250.274684] ath: Set channel: 2412 MHz
[  250.274687] ath: tx chmask: 1, rx chmask: 1
[  250.274832] ath: (2412 MHz) -> (2412 MHz), conf_is_ht40: 0
[  250.275594] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  250.277017] ath: idle: disabling radio
[  250.277967] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  250.278923] ath: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min:
7, cw_max: 15, txop: 102
[  250.279490] ath: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min:
15, cw_max: 31, txop: 188
[  250.280660] ath: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min:
31, cw_max: 1023, txop: 0
[  250.281833] ath: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min:
31, cw_max: 1023, txop: 0
[  250.283206] ath: Set HW RX filter: 0x207
[  250.283289] ath: Set HW RX filter: 0x207
[  250.283429] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  250.283534] ath: Set HW RX filter: 0x207
[  250.288279] ath: Marking phy3 as not-idle
[  250.289112] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  250.290310] ath: not-idle: enabling radio
[  250.290329] ath: Set HW RX filter: 0x17
[  250.421032] ath: Set channel: 2412 MHz
[  250.421038] ath: tx chmask: 5, rx chmask: 7
[  250.421190] ath: (2412 MHz) -> (2412 MHz), conf_is_ht40: 0
[  250.421974] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  250.483100] ath: Set channel: 2417 MHz
[  250.483114] ath: tx chmask: 5, rx chmask: 7
[  250.483302] ath: (2412 MHz) -> (2417 MHz), conf_is_ht40: 0
[  250.483411] ath: Force rf_pwd_icsyndiv to 1 on 2417
[  250.544108] ath: Set channel: 2422 MHz
[  250.544120] ath: tx chmask: 5, rx chmask: 7
[  250.544307] ath: (2417 MHz) -> (2422 MHz), conf_is_ht40: 0
[  250.544416] ath: Force rf_pwd_icsyndiv to 2 on 2422
[  250.605027] ath: Set channel: 2427 MHz
[  250.605031] ath: tx chmask: 5, rx chmask: 7
[  250.605179] ath: (2422 MHz) -> (2427 MHz), conf_is_ht40: 0
[  250.605261] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  250.666100] ath: Set channel: 2432 MHz
[  250.666112] ath: tx chmask: 5, rx chmask: 7
[  250.666299] ath: (2427 MHz) -> (2432 MHz), conf_is_ht40: 0
[  250.666407] ath: Force rf_pwd_icsyndiv to 2 on 2432
[  250.727122] ath: Set channel: 2437 MHz
[  250.727134] ath: tx chmask: 5, rx chmask: 7
[  250.727319] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 0
[  250.727427] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  250.788119] ath: Set channel: 2442 MHz
[  250.788128] ath: tx chmask: 5, rx chmask: 7
[  250.788313] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
[  250.788421] ath: Force rf_pwd_icsyndiv to 2 on 2442
[  250.849118] ath: Set channel: 2447 MHz
[  250.849132] ath: tx chmask: 5, rx chmask: 7
[  250.849320] ath: (2442 MHz) -> (2447 MHz), conf_is_ht40: 0
[  250.849431] ath: Force rf_pwd_icsyndiv to 2 on 2447
[  250.910101] ath: Set channel: 2452 MHz
[  250.910113] ath: tx chmask: 5, rx chmask: 7
[  250.910302] ath: (2447 MHz) -> (2452 MHz), conf_is_ht40: 0
[  250.910412] ath: Force rf_pwd_icsyndiv to 2 on 2452
[  250.971097] ath: Set channel: 2457 MHz
[  250.971108] ath: tx chmask: 5, rx chmask: 7
[  250.971303] ath: (2452 MHz) -> (2457 MHz), conf_is_ht40: 0
[  250.971412] ath: Force rf_pwd_icsyndiv to 2 on 2457
[  251.032117] ath: Set channel: 2462 MHz
[  251.032129] ath: tx chmask: 5, rx chmask: 7
[  251.032314] ath: (2457 MHz) -> (2462 MHz), conf_is_ht40: 0
[  251.032423] ath: Force rf_pwd_icsyndiv to 2 on 2462
[  251.094106] ath: Set channel: 2467 MHz
[  251.094117] ath: tx chmask: 5, rx chmask: 7
[  251.094316] ath: (2462 MHz) -> (2467 MHz), conf_is_ht40: 0
[  251.094425] ath: Force rf_pwd_icsyndiv to 2 on 2467
[  251.155073] ath: Set channel: 2472 MHz
[  251.155079] ath: tx chmask: 5, rx chmask: 7
[  251.155242] ath: (2467 MHz) -> (2472 MHz), conf_is_ht40: 0
[  251.155331] ath: Force rf_pwd_icsyndiv to 2 on 2472
[  251.217087] ath: Set channel: 2484 MHz
[  251.217102] ath: tx chmask: 5, rx chmask: 7
[  251.217300] ath: (2472 MHz) -> (2484 MHz), conf_is_ht40: 0
[  251.217418] ath: Force rf_pwd_icsyndiv to 2 on 2484
[  251.278099] ath: Set channel: 5180 MHz
[  251.278113] ath: tx chmask: 5, rx chmask: 7
[  251.278301] ath: (2484 MHz) -> (5180 MHz), conf_is_ht40: 0
[  251.341103] ath: Set channel: 5200 MHz
[  251.341115] ath: tx chmask: 5, rx chmask: 7
[  251.341304] ath: (5180 MHz) -> (5200 MHz), conf_is_ht40: 0
[  251.402113] ath: Set channel: 5220 MHz
[  251.402124] ath: tx chmask: 5, rx chmask: 7
[  251.402324] ath: (5200 MHz) -> (5220 MHz), conf_is_ht40: 0
[  251.463115] ath: Set channel: 5240 MHz
[  251.463125] ath: tx chmask: 5, rx chmask: 7
[  251.463309] ath: (5220 MHz) -> (5240 MHz), conf_is_ht40: 0
[  251.524107] ath: Set channel: 5260 MHz
[  251.524117] ath: tx chmask: 5, rx chmask: 7
[  251.524303] ath: (5240 MHz) -> (5260 MHz), conf_is_ht40: 0
[  251.650092] ath: Set channel: 5280 MHz
[  251.650103] ath: tx chmask: 5, rx chmask: 7
[  251.650301] ath: (5260 MHz) -> (5280 MHz), conf_is_ht40: 0
[  251.776115] ath: Set channel: 5300 MHz
[  251.776124] ath: tx chmask: 5, rx chmask: 7
[  251.776307] ath: (5280 MHz) -> (5300 MHz), conf_is_ht40: 0
[  251.903090] ath: Set channel: 5320 MHz
[  251.903102] ath: tx chmask: 5, rx chmask: 7
[  251.903293] ath: (5300 MHz) -> (5320 MHz), conf_is_ht40: 0
[  252.029127] ath: Set channel: 5500 MHz
[  252.029138] ath: tx chmask: 5, rx chmask: 7
[  252.029323] ath: (5320 MHz) -> (5500 MHz), conf_is_ht40: 0
[  252.155124] ath: Set channel: 5520 MHz
[  252.155135] ath: tx chmask: 5, rx chmask: 7
[  252.155320] ath: (5500 MHz) -> (5520 MHz), conf_is_ht40: 0
[  252.281062] ath: Set channel: 5540 MHz
[  252.281068] ath: tx chmask: 5, rx chmask: 7
[  252.281231] ath: (5520 MHz) -> (5540 MHz), conf_is_ht40: 0
[  252.407106] ath: Set channel: 5560 MHz
[  252.407118] ath: tx chmask: 5, rx chmask: 7
[  252.407315] ath: (5540 MHz) -> (5560 MHz), conf_is_ht40: 0
[  252.533094] ath: Set channel: 5580 MHz
[  252.533105] ath: tx chmask: 5, rx chmask: 7
[  252.533291] ath: (5560 MHz) -> (5580 MHz), conf_is_ht40: 0
[  252.659117] ath: Set channel: 5600 MHz
[  252.659127] ath: tx chmask: 5, rx chmask: 7
[  252.659310] ath: (5580 MHz) -> (5600 MHz), conf_is_ht40: 0
[  252.785120] ath: Set channel: 5620 MHz
[  252.785134] ath: tx chmask: 5, rx chmask: 7
[  252.785325] ath: (5600 MHz) -> (5620 MHz), conf_is_ht40: 0
[  252.911913] ath: Set channel: 5640 MHz
[  252.911929] ath: tx chmask: 5, rx chmask: 7
[  252.912162] ath: (5620 MHz) -> (5640 MHz), conf_is_ht40: 0
[  253.038232] ath: Set channel: 5660 MHz
[  253.038251] ath: tx chmask: 5, rx chmask: 7
[  253.038441] ath: (5640 MHz) -> (5660 MHz), conf_is_ht40: 0
[  253.164106] ath: Set channel: 5680 MHz
[  253.164118] ath: tx chmask: 5, rx chmask: 7
[  253.164343] ath: (5660 MHz) -> (5680 MHz), conf_is_ht40: 0
[  253.290119] ath: Set channel: 5700 MHz
[  253.290151] ath: tx chmask: 5, rx chmask: 7
[  253.290350] ath: (5680 MHz) -> (5700 MHz), conf_is_ht40: 0
[  253.416145] ath: Set channel: 5745 MHz
[  253.416157] ath: tx chmask: 5, rx chmask: 7
[  253.416346] ath: (5700 MHz) -> (5745 MHz), conf_is_ht40: 0
[  253.479118] ath: Set channel: 5765 MHz
[  253.479148] ath: tx chmask: 5, rx chmask: 7
[  253.479350] ath: (5745 MHz) -> (5765 MHz), conf_is_ht40: 0
[  253.541116] ath: Set channel: 5785 MHz
[  253.541151] ath: tx chmask: 5, rx chmask: 7
[  253.541352] ath: (5765 MHz) -> (5785 MHz), conf_is_ht40: 0
[  253.603119] ath: Set channel: 5805 MHz
[  253.603151] ath: tx chmask: 5, rx chmask: 7
[  253.603348] ath: (5785 MHz) -> (5805 MHz), conf_is_ht40: 0
[  253.665111] ath: Set channel: 5825 MHz
[  253.665121] ath: tx chmask: 5, rx chmask: 7
[  253.665343] ath: (5805 MHz) -> (5825 MHz), conf_is_ht40: 0
[  253.727828] ath: Set channel: 2412 MHz
[  253.727839] ath: tx chmask: 5, rx chmask: 7
[  253.728039] ath: (5825 MHz) -> (2412 MHz), conf_is_ht40: 0
[  253.728902] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  253.731049] ath: Set HW RX filter: 0x207
[  253.731096] ath: Marking phy3 as idle
[  253.731957] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  253.733910] ath: not-idle: enabling radio
[  253.733921] ath: idle: disabling radio
[  253.734968] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  258.730573] ath: Marking phy3 as not-idle
[  258.731510] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  258.733337] ath: not-idle: enabling radio
[  258.733373] ath: Set HW RX filter: 0x17
[  258.863107] ath: Set channel: 2412 MHz
[  258.863120] ath: tx chmask: 5, rx chmask: 7
[  258.863346] ath: (2412 MHz) -> (2412 MHz), conf_is_ht40: 0
[  258.864246] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  258.925215] ath: Set channel: 2417 MHz
[  258.925228] ath: tx chmask: 5, rx chmask: 7
[  258.925430] ath: (2412 MHz) -> (2417 MHz), conf_is_ht40: 0
[  258.925548] ath: Force rf_pwd_icsyndiv to 1 on 2417
[  258.987185] ath: Set channel: 2422 MHz
[  258.987197] ath: tx chmask: 5, rx chmask: 7
[  258.987389] ath: (2417 MHz) -> (2422 MHz), conf_is_ht40: 0
[  258.987509] ath: Force rf_pwd_icsyndiv to 2 on 2422
[  259.049197] ath: Set channel: 2427 MHz
[  259.049202] ath: tx chmask: 5, rx chmask: 7
[  259.049347] ath: (2422 MHz) -> (2427 MHz), conf_is_ht40: 0
[  259.049437] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  259.110215] ath: Set channel: 2432 MHz
[  259.110226] ath: tx chmask: 5, rx chmask: 7
[  259.110412] ath: (2427 MHz) -> (2432 MHz), conf_is_ht40: 0
[  259.110521] ath: Force rf_pwd_icsyndiv to 2 on 2432
[  259.171193] ath: Set channel: 2437 MHz
[  259.171211] ath: tx chmask: 5, rx chmask: 7
[  259.171401] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 0
[  259.171511] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  259.233111] ath: Set channel: 2442 MHz
[  259.233123] ath: tx chmask: 5, rx chmask: 7
[  259.233348] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
[  259.233458] ath: Force rf_pwd_icsyndiv to 2 on 2442
[  259.294237] ath: Set channel: 2447 MHz
[  259.294248] ath: tx chmask: 5, rx chmask: 7
[  259.294437] ath: (2442 MHz) -> (2447 MHz), conf_is_ht40: 0
[  259.294545] ath: Force rf_pwd_icsyndiv to 2 on 2447
[  259.355146] ath: Set channel: 2452 MHz
[  259.355159] ath: tx chmask: 5, rx chmask: 7
[  259.355349] ath: (2447 MHz) -> (2452 MHz), conf_is_ht40: 0
[  259.355458] ath: Force rf_pwd_icsyndiv to 2 on 2452
[  259.416121] ath: Set channel: 2457 MHz
[  259.416185] ath: tx chmask: 5, rx chmask: 7
[  259.416371] ath: (2452 MHz) -> (2457 MHz), conf_is_ht40: 0
[  259.416479] ath: Force rf_pwd_icsyndiv to 2 on 2457
[  259.477123] ath: Set channel: 2462 MHz
[  259.477159] ath: tx chmask: 5, rx chmask: 7
[  259.477351] ath: (2457 MHz) -> (2462 MHz), conf_is_ht40: 0
[  259.477463] ath: Force rf_pwd_icsyndiv to 2 on 2462
[  259.538152] ath: Set channel: 5180 MHz
[  259.538166] ath: tx chmask: 5, rx chmask: 7
[  259.538356] ath: (2462 MHz) -> (5180 MHz), conf_is_ht40: 0
[  259.601212] ath: Set channel: 5200 MHz
[  259.601223] ath: tx chmask: 5, rx chmask: 7
[  259.601409] ath: (5180 MHz) -> (5200 MHz), conf_is_ht40: 0
[  259.662119] ath: Set channel: 5220 MHz
[  259.662157] ath: tx chmask: 5, rx chmask: 7
[  259.662359] ath: (5200 MHz) -> (5220 MHz), conf_is_ht40: 0
[  259.723027] ath: Set channel: 5240 MHz
[  259.723033] ath: tx chmask: 5, rx chmask: 7
[  259.723186] ath: (5220 MHz) -> (5240 MHz), conf_is_ht40: 0
[  259.785114] ath: Set channel: 5260 MHz
[  259.785128] ath: tx chmask: 5, rx chmask: 7
[  259.785325] ath: (5240 MHz) -> (5260 MHz), conf_is_ht40: 0
[  259.911087] ath: Set channel: 5280 MHz
[  259.911102] ath: tx chmask: 5, rx chmask: 7
[  259.911298] ath: (5260 MHz) -> (5280 MHz), conf_is_ht40: 0
[  260.038097] ath: Set channel: 5300 MHz
[  260.038110] ath: tx chmask: 5, rx chmask: 7
[  260.038305] ath: (5280 MHz) -> (5300 MHz), conf_is_ht40: 0
[  260.165101] ath: Set channel: 5320 MHz
[  260.165115] ath: tx chmask: 5, rx chmask: 7
[  260.165309] ath: (5300 MHz) -> (5320 MHz), conf_is_ht40: 0
[  260.291103] ath: Set channel: 5500 MHz
[  260.291115] ath: tx chmask: 5, rx chmask: 7
[  260.291305] ath: (5320 MHz) -> (5500 MHz), conf_is_ht40: 0
[  260.417097] ath: Set channel: 5520 MHz
[  260.417110] ath: tx chmask: 5, rx chmask: 7
[  260.417298] ath: (5500 MHz) -> (5520 MHz), conf_is_ht40: 0
[  260.543127] ath: Set channel: 5540 MHz
[  260.543140] ath: tx chmask: 5, rx chmask: 7
[  260.543328] ath: (5520 MHz) -> (5540 MHz), conf_is_ht40: 0
[  260.669129] ath: Set channel: 5560 MHz
[  260.669145] ath: tx chmask: 5, rx chmask: 7
[  260.669333] ath: (5540 MHz) -> (5560 MHz), conf_is_ht40: 0
[  260.795121] ath: Set channel: 5580 MHz
[  260.795134] ath: tx chmask: 5, rx chmask: 7
[  260.795321] ath: (5560 MHz) -> (5580 MHz), conf_is_ht40: 0
[  260.921106] ath: Set channel: 5600 MHz
[  260.921119] ath: tx chmask: 5, rx chmask: 7
[  260.921306] ath: (5580 MHz) -> (5600 MHz), conf_is_ht40: 0
[  261.047121] ath: Set channel: 5620 MHz
[  261.047135] ath: tx chmask: 5, rx chmask: 7
[  261.047325] ath: (5600 MHz) -> (5620 MHz), conf_is_ht40: 0
[  261.173105] ath: Set channel: 5640 MHz
[  261.173119] ath: tx chmask: 5, rx chmask: 7
[  261.173308] ath: (5620 MHz) -> (5640 MHz), conf_is_ht40: 0
[  261.300134] ath: Set channel: 5660 MHz
[  261.300148] ath: tx chmask: 5, rx chmask: 7
[  261.300336] ath: (5640 MHz) -> (5660 MHz), conf_is_ht40: 0
[  261.426130] ath: Set channel: 5680 MHz
[  261.426144] ath: tx chmask: 5, rx chmask: 7
[  261.426334] ath: (5660 MHz) -> (5680 MHz), conf_is_ht40: 0
[  261.552098] ath: Set channel: 5700 MHz
[  261.552110] ath: tx chmask: 5, rx chmask: 7
[  261.552306] ath: (5680 MHz) -> (5700 MHz), conf_is_ht40: 0
[  261.678129] ath: Set channel: 5745 MHz
[  261.678143] ath: tx chmask: 5, rx chmask: 7
[  261.678333] ath: (5700 MHz) -> (5745 MHz), conf_is_ht40: 0
[  261.742087] ath: Set channel: 5765 MHz
[  261.742102] ath: tx chmask: 5, rx chmask: 7
[  261.742307] ath: (5745 MHz) -> (5765 MHz), conf_is_ht40: 0
[  261.806043] ath: Set channel: 5785 MHz
[  261.806050] ath: tx chmask: 5, rx chmask: 7
[  261.806202] ath: (5765 MHz) -> (5785 MHz), conf_is_ht40: 0
[  261.869184] ath: Set channel: 5805 MHz
[  261.869199] ath: tx chmask: 5, rx chmask: 7
[  261.869402] ath: (5785 MHz) -> (5805 MHz), conf_is_ht40: 0
[  261.932177] ath: Set channel: 5825 MHz
[  261.932183] ath: tx chmask: 5, rx chmask: 7
[  261.932336] ath: (5805 MHz) -> (5825 MHz), conf_is_ht40: 0
[  261.994537] ath: Set channel: 2412 MHz
[  261.994544] ath: tx chmask: 5, rx chmask: 7
[  261.994703] ath: (5825 MHz) -> (2412 MHz), conf_is_ht40: 0
[  261.995511] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  261.997194] ath9k: Two wiphys trying to scan at the same time
[  261.997211] ath: Set HW RX filter: 0x17
[  261.997214] ath: Set HW RX filter: 0x17
[  262.127025] ath: Set channel: 2437 MHz
[  262.127031] ath: tx chmask: 1, rx chmask: 1
[  262.127181] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 0
[  262.127959] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  262.189304] ath: Set channel: 2412 MHz
[  262.189311] ath: tx chmask: 1, rx chmask: 1
[  262.189465] ath: (2437 MHz) -> (2412 MHz), conf_is_ht40: 0
[  262.189555] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  262.190500] ath: Set HW RX filter: 0x207
[  262.190573] ath: Set channel: 2437 MHz
[  262.190577] ath: tx chmask: 1, rx chmask: 1
[  262.190728] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 0
[  262.191496] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  262.193306] wlan1: direct probe to 00:26:5a:2d:31:46 (try 1)
[  262.393106] wlan1: direct probe to 00:26:5a:2d:31:46 (try 2)
[  262.593101] wlan1: direct probe to 00:26:5a:2d:31:46 (try 3)
[  262.597614] wlan1: direct probe responded
[  262.603080] wlan1: authenticate with 00:26:5a:2d:31:46 (try 1)
[  262.623048] wlan1: authenticated
[  262.623218] ath: Marking phy3 as idle
[  262.624104] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  262.625656] ath: not-idle: enabling radio
[  262.625667] ath: idle: disabling radio
[  262.626681] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  262.627638] wlan1: associate with 00:26:5a:2d:31:46 (try 1)
[  262.627728] ath: Marking phy3 as not-idle
[  262.628633] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  262.629975] ath: not-idle: enabling radio
[  262.648691] wlan1: RX AssocResp from 00:26:5a:2d:31:46 (capab=0xc31
status=0 aid=1)
[  262.648700] wlan1: associated
[  262.648787] ath: Choosing rate table for mode: 6
[  262.648815] ath: RC Initialized with capabilities: 0xe
[  262.650614] ath_rate_update:1342 channel_type=0
[  262.650621] ath: Choosing rate table for mode: 3
[  262.650647] ath: RC Initialized with capabilities: 0xc
[  262.650655] ath: Operating HT Bandwidth changed to: 0
[  262.650672] ath: BSSID: 00:26:5a:2d:31:46 aid: 0x0
[  262.650694] ath: BSS Changed PREAMBLE 1
[  262.650701] ath: BSS Changed ASSOC 1
[  262.650709] ath: Bss Info ASSOC 1, bssid: 00:26:5a:2d:31:46
[  262.651470] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  262.654653] cfg80211: Calling CRDA for country: GB
[  262.656068] ath: Set channel: 2437 MHz
[  262.656081] ath: tx chmask: 5, rx chmask: 7
[  262.659888] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 1
[  262.660731] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  262.663888] ath: Set HW RX filter: 0x607
[  262.665692] cfg80211: Received country IE:
[  262.665695] cfg80211: Regulatory domain: GB
[  262.665697]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  262.665700]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (10000
mBi, 1600 mBm)
[  262.665702] cfg80211: CRDA thinks this should applied:
[  262.665704] cfg80211: Regulatory domain: GB
[  262.665705]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  262.665708]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  262.665710]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  262.665713]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  262.665715]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  262.665717] cfg80211: We intersect both of these and get:
[  262.665719] cfg80211: Regulatory domain: 98
[  262.665721]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  262.665723]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 1600 mBm)
[  262.665735] cfg80211: Disabling channel 2484 MHz on phy3 due to Country IE
[  262.665738] cfg80211: Leaving channel 5180 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665740] cfg80211: Leaving channel 5200 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665743] cfg80211: Leaving channel 5220 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665745] cfg80211: Leaving channel 5240 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665747] cfg80211: Leaving channel 5260 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665750] cfg80211: Leaving channel 5280 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665752] cfg80211: Leaving channel 5300 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665755] cfg80211: Leaving channel 5320 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665757] cfg80211: Leaving channel 5500 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665760] cfg80211: Leaving channel 5520 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665762] cfg80211: Leaving channel 5540 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665764] cfg80211: Leaving channel 5560 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665767] cfg80211: Leaving channel 5580 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665769] cfg80211: Leaving channel 5600 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665772] cfg80211: Leaving channel 5620 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665774] cfg80211: Leaving channel 5640 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665776] cfg80211: Leaving channel 5660 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665779] cfg80211: Leaving channel 5680 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665781] cfg80211: Leaving channel 5700 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665784] cfg80211: Leaving channel 5745 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665786] cfg80211: Leaving channel 5765 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665788] cfg80211: Leaving channel 5785 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665791] cfg80211: Leaving channel 5805 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665793] cfg80211: Leaving channel 5825 MHz intact on phy3 - no
rule found in band on Country IE
[  262.665798] cfg80211: Current regulatory domain updated by AP to: GB
[  262.665800]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  262.665802]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 1600 mBm)
[  262.686067] ath: Set HW Key
[  262.686831] ath: Set HW Key
[  262.721413] ath: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min:
15, cw_max: 1023, txop: 0
[  262.721427] ath: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min:
15, cw_max: 1023, txop: 0
[  262.721438] ath: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min:
7, cw_max: 15, txop: 94
[  262.721449] ath: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min:
3, cw_max: 7, txop: 47
[  272.327097] ath: Set HW RX filter: 0x607
[  273.030062] wlan1: no IPv6 routers present
[  300.270394] ath: Set HW RX filter: 0x417
[  300.400098] ath: Set channel: 2412 MHz
[  300.400110] ath: tx chmask: 5, rx chmask: 7
[  300.400473] ath: (2437 MHz) -> (2412 MHz), conf_is_ht40: 0
[  300.400581] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  300.462213] ath: Set channel: 2437 MHz
[  300.462224] ath: tx chmask: 5, rx chmask: 7
[  300.462409] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 1
[  300.462517] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  300.763099] ath: Set channel: 2417 MHz
[  300.763110] ath: tx chmask: 5, rx chmask: 7
[  300.763324] ath: (2437 MHz) -> (2417 MHz), conf_is_ht40: 0
[  300.763430] ath: Force rf_pwd_icsyndiv to 1 on 2417
[  300.824230] ath: Set channel: 2437 MHz
[  300.824240] ath: tx chmask: 5, rx chmask: 7
[  300.824425] ath: (2417 MHz) -> (2437 MHz), conf_is_ht40: 1
[  300.824533] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  301.125106] ath: Set channel: 2422 MHz
[  301.125117] ath: tx chmask: 5, rx chmask: 7
[  301.125333] ath: (2437 MHz) -> (2422 MHz), conf_is_ht40: 0
[  301.125437] ath: Force rf_pwd_icsyndiv to 2 on 2422
[  301.186097] ath: Set channel: 2437 MHz
[  301.186107] ath: tx chmask: 5, rx chmask: 7
[  301.186328] ath: (2422 MHz) -> (2437 MHz), conf_is_ht40: 1
[  301.186439] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  301.487107] ath: Set channel: 2427 MHz
[  301.487117] ath: tx chmask: 5, rx chmask: 7
[  301.487332] ath: (2437 MHz) -> (2427 MHz), conf_is_ht40: 0
[  301.487437] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  301.548102] ath: Set channel: 2437 MHz
[  301.548112] ath: tx chmask: 5, rx chmask: 7
[  301.548331] ath: (2427 MHz) -> (2437 MHz), conf_is_ht40: 1
[  301.548439] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  301.849212] ath: Set channel: 2432 MHz
[  301.849223] ath: tx chmask: 5, rx chmask: 7
[  301.849399] ath: (2437 MHz) -> (2432 MHz), conf_is_ht40: 0
[  301.849502] ath: Force rf_pwd_icsyndiv to 2 on 2432
[  301.910208] ath: Set channel: 2437 MHz
[  301.910218] ath: tx chmask: 5, rx chmask: 7
[  301.910403] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 1
[  301.910511] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  302.211086] ath: Set channel: 2437 MHz
[  302.211096] ath: tx chmask: 5, rx chmask: 7
[  302.211303] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 0
[  302.212177] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  302.273309] ath: Set channel: 2437 MHz
[  302.273320] ath: tx chmask: 5, rx chmask: 7
[  302.273504] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 1
[  302.274397] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  302.576210] ath: Set channel: 2442 MHz
[  302.576221] ath: tx chmask: 5, rx chmask: 7
[  302.576397] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
[  302.576501] ath: Force rf_pwd_icsyndiv to 2 on 2442
[  302.637114] ath: Set channel: 2437 MHz
[  302.637124] ath: tx chmask: 5, rx chmask: 7
[  302.637344] ath: (2442 MHz) -> (2437 MHz), conf_is_ht40: 1
[  302.637460] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  302.938122] ath: Set channel: 2447 MHz
[  302.938156] ath: tx chmask: 5, rx chmask: 7
[  302.938346] ath: (2437 MHz) -> (2447 MHz), conf_is_ht40: 0
[  302.938458] ath: Force rf_pwd_icsyndiv to 2 on 2447
[  302.999118] ath: Set channel: 2437 MHz
[  302.999148] ath: tx chmask: 5, rx chmask: 7
[  302.999346] ath: (2447 MHz) -> (2437 MHz), conf_is_ht40: 1
[  302.999460] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  303.300211] ath: Set channel: 2452 MHz
[  303.300222] ath: tx chmask: 5, rx chmask: 7
[  303.300398] ath: (2437 MHz) -> (2452 MHz), conf_is_ht40: 0
[  303.300502] ath: Force rf_pwd_icsyndiv to 2 on 2452
[  303.361118] ath: Set channel: 2437 MHz
[  303.361152] ath: tx chmask: 5, rx chmask: 7
[  303.361351] ath: (2452 MHz) -> (2437 MHz), conf_is_ht40: 1
[  303.361467] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  303.662123] ath: Set channel: 2457 MHz
[  303.662156] ath: tx chmask: 5, rx chmask: 7
[  303.662345] ath: (2437 MHz) -> (2457 MHz), conf_is_ht40: 0
[  303.662456] ath: Force rf_pwd_icsyndiv to 2 on 2457
[  303.723123] ath: Set channel: 2437 MHz
[  303.723153] ath: tx chmask: 5, rx chmask: 7
[  303.723352] ath: (2457 MHz) -> (2437 MHz), conf_is_ht40: 1
[  303.723467] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  304.024333] ath: Set channel: 2462 MHz
[  304.024345] ath: tx chmask: 5, rx chmask: 7
[  304.024521] ath: (2437 MHz) -> (2462 MHz), conf_is_ht40: 0
[  304.024625] ath: Force rf_pwd_icsyndiv to 2 on 2462
[  304.085112] ath: Set channel: 2437 MHz
[  304.085123] ath: tx chmask: 5, rx chmask: 7
[  304.085340] ath: (2462 MHz) -> (2437 MHz), conf_is_ht40: 1
[  304.085458] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  304.386116] ath: Set channel: 5180 MHz
[  304.386149] ath: tx chmask: 5, rx chmask: 7
[  304.386341] ath: (2437 MHz) -> (5180 MHz), conf_is_ht40: 0
[  304.449120] ath: Set channel: 2437 MHz
[  304.449150] ath: tx chmask: 5, rx chmask: 7
[  304.449348] ath: (5180 MHz) -> (2437 MHz), conf_is_ht40: 1
[  304.450206] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  304.752119] ath: Set channel: 5200 MHz
[  304.752151] ath: tx chmask: 5, rx chmask: 7
[  304.752343] ath: (2437 MHz) -> (5200 MHz), conf_is_ht40: 0
[  304.815118] ath: Set channel: 2437 MHz
[  304.815149] ath: tx chmask: 5, rx chmask: 7
[  304.815350] ath: (5200 MHz) -> (2437 MHz), conf_is_ht40: 1
[  304.816217] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  305.118216] ath: Set channel: 5220 MHz
[  305.118227] ath: tx chmask: 5, rx chmask: 7
[  305.118402] ath: (2437 MHz) -> (5220 MHz), conf_is_ht40: 0
[  305.181118] ath: Set channel: 2437 MHz
[  305.181151] ath: tx chmask: 5, rx chmask: 7
[  305.181351] ath: (5220 MHz) -> (2437 MHz), conf_is_ht40: 1
[  305.182210] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  305.484118] ath: Set channel: 5240 MHz
[  305.484151] ath: tx chmask: 5, rx chmask: 7
[  305.484345] ath: (2437 MHz) -> (5240 MHz), conf_is_ht40: 0
[  305.547118] ath: Set channel: 2437 MHz
[  305.547151] ath: tx chmask: 5, rx chmask: 7
[  305.547348] ath: (5240 MHz) -> (2437 MHz), conf_is_ht40: 1
[  305.548211] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  305.850202] ath: Set channel: 5260 MHz
[  305.850209] ath: tx chmask: 5, rx chmask: 7
[  305.850354] ath: (2437 MHz) -> (5260 MHz), conf_is_ht40: 0
[  305.978121] ath: Set channel: 2437 MHz
[  305.978152] ath: tx chmask: 5, rx chmask: 7
[  305.978352] ath: (5260 MHz) -> (2437 MHz), conf_is_ht40: 1
[  305.979216] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  306.281196] ath: Set channel: 5280 MHz
[  306.281207] ath: tx chmask: 5, rx chmask: 7
[  306.281385] ath: (2437 MHz) -> (5280 MHz), conf_is_ht40: 0
[  306.409113] ath: Set channel: 2437 MHz
[  306.409123] ath: tx chmask: 5, rx chmask: 7
[  306.409344] ath: (5280 MHz) -> (2437 MHz), conf_is_ht40: 1
[  306.410218] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  306.712090] ath: Set channel: 5300 MHz
[  306.712101] ath: tx chmask: 5, rx chmask: 7
[  306.712312] ath: (2437 MHz) -> (5300 MHz), conf_is_ht40: 0
[  306.840117] ath: Set channel: 2437 MHz
[  306.840146] ath: tx chmask: 5, rx chmask: 7
[  306.840346] ath: (5300 MHz) -> (2437 MHz), conf_is_ht40: 1
[  306.841218] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  307.143123] ath: Set channel: 5320 MHz
[  307.143156] ath: tx chmask: 5, rx chmask: 7
[  307.143348] ath: (2437 MHz) -> (5320 MHz), conf_is_ht40: 0
[  307.271110] ath: Set channel: 2437 MHz
[  307.271120] ath: tx chmask: 5, rx chmask: 7
[  307.271337] ath: (5320 MHz) -> (2437 MHz), conf_is_ht40: 1
[  307.272209] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  307.574116] ath: Set channel: 5500 MHz
[  307.574136] ath: tx chmask: 5, rx chmask: 7
[  307.574326] ath: (2437 MHz) -> (5500 MHz), conf_is_ht40: 0
[  307.702124] ath: Set channel: 2437 MHz
[  307.702134] ath: tx chmask: 5, rx chmask: 7
[  307.702318] ath: (5500 MHz) -> (2437 MHz), conf_is_ht40: 1
[  307.703189] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  308.005116] ath: Set channel: 5520 MHz
[  308.005127] ath: tx chmask: 5, rx chmask: 7
[  308.005316] ath: (2437 MHz) -> (5520 MHz), conf_is_ht40: 0
[  308.133111] ath: Set channel: 2437 MHz
[  308.133121] ath: tx chmask: 5, rx chmask: 7
[  308.133305] ath: (5520 MHz) -> (2437 MHz), conf_is_ht40: 1
[  308.134166] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  308.436119] ath: Set channel: 5540 MHz
[  308.436130] ath: tx chmask: 5, rx chmask: 7
[  308.436307] ath: (2437 MHz) -> (5540 MHz), conf_is_ht40: 0
[  308.564120] ath: Set channel: 2437 MHz
[  308.564131] ath: tx chmask: 5, rx chmask: 7
[  308.564315] ath: (5540 MHz) -> (2437 MHz), conf_is_ht40: 1
[  308.565181] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  308.867115] ath: Set channel: 5560 MHz
[  308.867126] ath: tx chmask: 5, rx chmask: 7
[  308.867308] ath: (2437 MHz) -> (5560 MHz), conf_is_ht40: 0
[  308.995118] ath: Set channel: 2437 MHz
[  308.995128] ath: tx chmask: 5, rx chmask: 7
[  308.995311] ath: (5560 MHz) -> (2437 MHz), conf_is_ht40: 1
[  308.996172] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  309.298119] ath: Set channel: 5580 MHz
[  309.298130] ath: tx chmask: 5, rx chmask: 7
[  309.298305] ath: (2437 MHz) -> (5580 MHz), conf_is_ht40: 0
[  309.426118] ath: Set channel: 2437 MHz
[  309.426128] ath: tx chmask: 5, rx chmask: 7
[  309.426311] ath: (5580 MHz) -> (2437 MHz), conf_is_ht40: 1
[  309.427171] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  309.729132] ath: Set channel: 5600 MHz
[  309.729142] ath: tx chmask: 5, rx chmask: 7
[  309.729324] ath: (2437 MHz) -> (5600 MHz), conf_is_ht40: 0
[  309.857123] ath: Set channel: 2437 MHz
[  309.857133] ath: tx chmask: 5, rx chmask: 7
[  309.857316] ath: (5600 MHz) -> (2437 MHz), conf_is_ht40: 1
[  309.858180] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  310.160116] ath: Set channel: 5620 MHz
[  310.160126] ath: tx chmask: 5, rx chmask: 7
[  310.160306] ath: (2437 MHz) -> (5620 MHz), conf_is_ht40: 0
[  310.287095] ath: Set channel: 2437 MHz
[  310.287108] ath: tx chmask: 5, rx chmask: 7
[  310.287300] ath: (5620 MHz) -> (2437 MHz), conf_is_ht40: 1
[  310.288172] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  310.590126] ath: Set channel: 5640 MHz
[  310.590139] ath: tx chmask: 5, rx chmask: 7
[  310.590707] ath: (2437 MHz) -> (5640 MHz), conf_is_ht40: 0
[  310.718122] ath: Set channel: 2437 MHz
[  310.718132] ath: tx chmask: 5, rx chmask: 7
[  310.718316] ath: (5640 MHz) -> (2437 MHz), conf_is_ht40: 1
[  310.719183] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  311.021120] ath: Set channel: 5660 MHz
[  311.021133] ath: tx chmask: 5, rx chmask: 7
[  311.021311] ath: (2437 MHz) -> (5660 MHz), conf_is_ht40: 0
[  311.149122] ath: Set channel: 2437 MHz
[  311.149132] ath: tx chmask: 5, rx chmask: 7
[  311.149315] ath: (5660 MHz) -> (2437 MHz), conf_is_ht40: 1
[  311.150181] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  311.453412] ath: Set channel: 5680 MHz
[  311.453427] ath: tx chmask: 5, rx chmask: 7
[  311.453609] ath: (2437 MHz) -> (5680 MHz), conf_is_ht40: 0
[  311.583090] ath: Set channel: 2437 MHz
[  311.583104] ath: tx chmask: 5, rx chmask: 7
[  311.583309] ath: (5680 MHz) -> (2437 MHz), conf_is_ht40: 1
[  311.584191] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  311.886097] ath: Set channel: 5700 MHz
[  311.886111] ath: tx chmask: 5, rx chmask: 7
[  311.886303] ath: (2437 MHz) -> (5700 MHz), conf_is_ht40: 0
[  312.015108] ath: Set channel: 2437 MHz
[  312.015116] ath: tx chmask: 5, rx chmask: 7
[  312.015275] ath: (5700 MHz) -> (2437 MHz), conf_is_ht40: 1
[  312.015948] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  312.317102] ath: Set channel: 5745 MHz
[  312.317117] ath: tx chmask: 5, rx chmask: 7
[  312.317335] ath: (2437 MHz) -> (5745 MHz), conf_is_ht40: 0
[  312.380105] ath: Set channel: 2437 MHz
[  312.380119] ath: tx chmask: 5, rx chmask: 7
[  312.380344] ath: (5745 MHz) -> (2437 MHz), conf_is_ht40: 1
[  312.381222] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  312.685097] ath: Set channel: 5765 MHz
[  312.685109] ath: tx chmask: 5, rx chmask: 7
[  312.685377] ath: (2437 MHz) -> (5765 MHz), conf_is_ht40: 0
[  312.749104] ath: Set channel: 2437 MHz
[  312.749117] ath: tx chmask: 5, rx chmask: 7
[  312.749323] ath: (5765 MHz) -> (2437 MHz), conf_is_ht40: 1
[  312.750218] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  313.052236] ath: Set channel: 5785 MHz
[  313.052250] ath: tx chmask: 5, rx chmask: 7
[  313.052431] ath: (2437 MHz) -> (5785 MHz), conf_is_ht40: 0
[  313.115122] ath: Set channel: 2437 MHz
[  313.115192] ath: tx chmask: 5, rx chmask: 7
[  313.115378] ath: (5785 MHz) -> (2437 MHz), conf_is_ht40: 1
[  313.116242] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  313.418119] ath: Set channel: 5805 MHz
[  313.418189] ath: tx chmask: 5, rx chmask: 7
[  313.418367] ath: (2437 MHz) -> (5805 MHz), conf_is_ht40: 0
[  313.481092] ath: Set channel: 2437 MHz
[  313.481102] ath: tx chmask: 5, rx chmask: 7
[  313.481462] ath: (5805 MHz) -> (2437 MHz), conf_is_ht40: 1
[  313.482330] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  313.784117] ath: Set channel: 5825 MHz
[  313.784260] ath: tx chmask: 5, rx chmask: 7
[  313.784440] ath: (2437 MHz) -> (5825 MHz), conf_is_ht40: 0
[  313.847142] ath: Set channel: 2437 MHz
[  313.847153] ath: tx chmask: 5, rx chmask: 7
[  313.847345] ath: (5825 MHz) -> (2437 MHz), conf_is_ht40: 1
[  313.848217] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  313.851422] ath: Set HW RX filter: 0x607
[  340.273288] ath: Set HW RX filter: 0x417
[  340.403259] ath: Set channel: 2412 MHz
[  340.403275] ath: tx chmask: 5, rx chmask: 7
[  340.403460] ath: (2437 MHz) -> (2412 MHz), conf_is_ht40: 0
[  340.404346] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  340.466038] ath: Set channel: 2437 MHz
[  340.466046] ath: tx chmask: 5, rx chmask: 7
[  340.466207] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 1
[  340.466297] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  340.767171] ath: Set channel: 2417 MHz
[  340.767176] ath: tx chmask: 5, rx chmask: 7
[  340.776258] ath: (2437 MHz) -> (2417 MHz), conf_is_ht40: 0
[  340.776343] ath: Force rf_pwd_icsyndiv to 1 on 2417
[  340.837205] ath: Set channel: 2437 MHz
[  340.837218] ath: tx chmask: 5, rx chmask: 7
[  340.837430] ath: (2417 MHz) -> (2437 MHz), conf_is_ht40: 1
[  340.837552] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  341.139210] ath: Set channel: 2422 MHz
[  341.139216] ath: tx chmask: 5, rx chmask: 7
[  341.139352] ath: (2437 MHz) -> (2422 MHz), conf_is_ht40: 0
[  341.139437] ath: Force rf_pwd_icsyndiv to 2 on 2422
[  341.200280] ath: Set channel: 2437 MHz
[  341.200294] ath: tx chmask: 5, rx chmask: 7
[  341.200486] ath: (2422 MHz) -> (2437 MHz), conf_is_ht40: 1
[  341.200597] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  341.502284] ath: Set channel: 2427 MHz
[  341.502290] ath: tx chmask: 5, rx chmask: 7
[  341.502424] ath: (2437 MHz) -> (2427 MHz), conf_is_ht40: 0
[  341.502502] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  341.563099] ath: Set channel: 2437 MHz
[  341.563113] ath: tx chmask: 5, rx chmask: 7
[  341.563344] ath: (2427 MHz) -> (2437 MHz), conf_is_ht40: 1
[  341.563463] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  341.864180] ath: Set channel: 2432 MHz
[  341.864186] ath: tx chmask: 5, rx chmask: 7
[  341.864324] ath: (2437 MHz) -> (2432 MHz), conf_is_ht40: 0
[  341.864407] ath: Force rf_pwd_icsyndiv to 2 on 2432
[  341.925208] ath: Set channel: 2437 MHz
[  341.925215] ath: tx chmask: 5, rx chmask: 7
[  341.925371] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 1
[  341.925461] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  342.226150] ath: Set channel: 2437 MHz
[  342.226165] ath: tx chmask: 5, rx chmask: 7
[  342.226351] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 0
[  342.227237] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  342.288357] ath: Set channel: 2437 MHz
[  342.288363] ath: tx chmask: 5, rx chmask: 7
[  342.288507] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 1
[  342.289189] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  342.590124] ath: Set channel: 2442 MHz
[  342.590167] ath: tx chmask: 5, rx chmask: 7
[  342.590369] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
[  342.590479] ath: Force rf_pwd_icsyndiv to 2 on 2442
[  342.652105] ath: Set channel: 2437 MHz
[  342.652119] ath: tx chmask: 5, rx chmask: 7
[  342.652350] ath: (2442 MHz) -> (2437 MHz), conf_is_ht40: 1
[  342.652465] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  342.955052] ath: Set channel: 2447 MHz
[  342.955058] ath: tx chmask: 5, rx chmask: 7
[  342.955199] ath: (2437 MHz) -> (2447 MHz), conf_is_ht40: 0
[  342.955282] ath: Force rf_pwd_icsyndiv to 2 on 2447
[  343.016020] ath: Set channel: 2437 MHz
[  343.016026] ath: tx chmask: 5, rx chmask: 7
[  343.016182] ath: (2447 MHz) -> (2437 MHz), conf_is_ht40: 1
[  343.016265] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  343.318040] ath: Set channel: 2452 MHz
[  343.318046] ath: tx chmask: 5, rx chmask: 7
[  343.318180] ath: (2437 MHz) -> (2452 MHz), conf_is_ht40: 0
[  343.318259] ath: Force rf_pwd_icsyndiv to 2 on 2452
[  343.380040] ath: Set channel: 2437 MHz
[  343.380043] ath: tx chmask: 5, rx chmask: 7
[  343.380187] ath: (2452 MHz) -> (2437 MHz), conf_is_ht40: 1
[  343.380270] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  343.682042] ath: Set channel: 2457 MHz
[  343.682046] ath: tx chmask: 5, rx chmask: 7
[  343.682180] ath: (2437 MHz) -> (2457 MHz), conf_is_ht40: 0
[  343.682258] ath: Force rf_pwd_icsyndiv to 2 on 2457
[  343.744046] ath: Set channel: 2437 MHz
[  343.744051] ath: tx chmask: 5, rx chmask: 7
[  343.744201] ath: (2457 MHz) -> (2437 MHz), conf_is_ht40: 1
[  343.744285] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  344.045167] ath: Set channel: 2462 MHz
[  344.045171] ath: tx chmask: 5, rx chmask: 7
[  344.045304] ath: (2437 MHz) -> (2462 MHz), conf_is_ht40: 0
[  344.045383] ath: Force rf_pwd_icsyndiv to 2 on 2462
[  344.106165] ath: Set channel: 2437 MHz
[  344.106168] ath: tx chmask: 5, rx chmask: 7
[  344.106310] ath: (2462 MHz) -> (2437 MHz), conf_is_ht40: 1
[  344.106393] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  344.407165] ath: Set channel: 5180 MHz
[  344.407170] ath: tx chmask: 5, rx chmask: 7
[  344.407303] ath: (2437 MHz) -> (5180 MHz), conf_is_ht40: 0
[  344.469445] ath: Set channel: 2437 MHz
[  344.469452] ath: tx chmask: 5, rx chmask: 7
[  344.469604] ath: (5180 MHz) -> (2437 MHz), conf_is_ht40: 1
[  344.470281] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  344.772674] ath: Set channel: 5200 MHz
[  344.772689] ath: tx chmask: 5, rx chmask: 7
[  344.772873] ath: (2437 MHz) -> (5200 MHz), conf_is_ht40: 0
[  344.835245] ath: Set channel: 2437 MHz
[  344.835259] ath: tx chmask: 5, rx chmask: 7
[  344.835452] ath: (5200 MHz) -> (2437 MHz), conf_is_ht40: 1
[  344.836338] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  345.140055] ath: Set channel: 5220 MHz
[  345.140062] ath: tx chmask: 5, rx chmask: 7
[  345.140205] ath: (2437 MHz) -> (5220 MHz), conf_is_ht40: 0
[  345.202031] ath: Set channel: 2437 MHz
[  345.202037] ath: tx chmask: 5, rx chmask: 7
[  345.202190] ath: (5220 MHz) -> (2437 MHz), conf_is_ht40: 1
[  345.202852] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  345.504205] ath: Set channel: 5240 MHz
[  345.504220] ath: tx chmask: 5, rx chmask: 7
[  345.504420] ath: (2437 MHz) -> (5240 MHz), conf_is_ht40: 0
[  345.567171] ath: Set channel: 2437 MHz
[  345.567177] ath: tx chmask: 5, rx chmask: 7
[  345.567328] ath: (5240 MHz) -> (2437 MHz), conf_is_ht40: 1
[  345.567992] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  345.869100] ath: Set channel: 5260 MHz
[  345.869106] ath: tx chmask: 5, rx chmask: 7
[  345.869695] ath: (2437 MHz) -> (5260 MHz), conf_is_ht40: 0
[  345.997179] ath: Set channel: 2437 MHz
[  345.997185] ath: tx chmask: 5, rx chmask: 7
[  345.997333] ath: (5260 MHz) -> (2437 MHz), conf_is_ht40: 1
[  345.997998] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  346.299208] ath: Set channel: 5280 MHz
[  346.299222] ath: tx chmask: 5, rx chmask: 7
[  346.299406] ath: (2437 MHz) -> (5280 MHz), conf_is_ht40: 0
[  346.427104] ath: Set channel: 2437 MHz
[  346.427110] ath: tx chmask: 5, rx chmask: 7
[  346.427288] ath: (5280 MHz) -> (2437 MHz), conf_is_ht40: 1
[  346.427962] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  346.729207] ath: Set channel: 5300 MHz
[  346.729215] ath: tx chmask: 5, rx chmask: 7
[  346.729359] ath: (2437 MHz) -> (5300 MHz), conf_is_ht40: 0
[  346.856183] ath: Set channel: 2437 MHz
[  346.856201] ath: tx chmask: 5, rx chmask: 7
[  346.856399] ath: (5300 MHz) -> (2437 MHz), conf_is_ht40: 1
[  346.857306] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  347.160186] ath: Set channel: 5320 MHz
[  347.160193] ath: tx chmask: 5, rx chmask: 7
[  347.160328] ath: (2437 MHz) -> (5320 MHz), conf_is_ht40: 0
[  347.287358] ath: Set channel: 2437 MHz
[  347.287373] ath: tx chmask: 5, rx chmask: 7
[  347.287565] ath: (5320 MHz) -> (2437 MHz), conf_is_ht40: 1
[  347.288471] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  347.591203] ath: Set channel: 5500 MHz
[  347.591209] ath: tx chmask: 5, rx chmask: 7
[  347.591345] ath: (2437 MHz) -> (5500 MHz), conf_is_ht40: 0
[  347.718114] ath: Set channel: 2437 MHz
[  347.718120] ath: tx chmask: 5, rx chmask: 7
[  347.718286] ath: (5500 MHz) -> (2437 MHz), conf_is_ht40: 1
[  347.718954] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  348.022069] ath: Set channel: 5520 MHz
[  348.022075] ath: tx chmask: 5, rx chmask: 7
[  348.022241] ath: (2437 MHz) -> (5520 MHz), conf_is_ht40: 0
[  348.149210] ath: Set channel: 2437 MHz
[  348.149225] ath: tx chmask: 5, rx chmask: 7
[  348.149418] ath: (5520 MHz) -> (2437 MHz), conf_is_ht40: 1
[  348.150319] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  348.452477] ath: Set channel: 5540 MHz
[  348.452492] ath: tx chmask: 5, rx chmask: 7
[  348.452689] ath: (2437 MHz) -> (5540 MHz), conf_is_ht40: 0
[  348.580062] ath: Set channel: 2437 MHz
[  348.580077] ath: tx chmask: 5, rx chmask: 7
[  348.580285] ath: (5540 MHz) -> (2437 MHz), conf_is_ht40: 1
[  348.581183] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  348.883076] ath: Set channel: 5560 MHz
[  348.883091] ath: tx chmask: 5, rx chmask: 7
[  348.883288] ath: (2437 MHz) -> (5560 MHz), conf_is_ht40: 0
[  349.011065] ath: Set channel: 2437 MHz
[  349.011080] ath: tx chmask: 5, rx chmask: 7
[  349.011279] ath: (5560 MHz) -> (2437 MHz), conf_is_ht40: 1
[  349.012173] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  349.314093] ath: Set channel: 5580 MHz
[  349.314100] ath: tx chmask: 5, rx chmask: 7
[  349.314244] ath: (2437 MHz) -> (5580 MHz), conf_is_ht40: 0
[  349.441280] ath: Set channel: 2437 MHz
[  349.441296] ath: tx chmask: 5, rx chmask: 7
[  349.441487] ath: (5580 MHz) -> (2437 MHz), conf_is_ht40: 1
[  349.442382] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  349.744104] ath: Set channel: 5600 MHz
[  349.744112] ath: tx chmask: 5, rx chmask: 7
[  349.744258] ath: (2437 MHz) -> (5600 MHz), conf_is_ht40: 0
[  349.873062] ath: Set channel: 2437 MHz
[  349.873068] ath: tx chmask: 5, rx chmask: 7
[  349.873230] ath: (5600 MHz) -> (2437 MHz), conf_is_ht40: 1
[  349.873889] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  350.175210] ath: Set channel: 5620 MHz
[  350.175226] ath: tx chmask: 5, rx chmask: 7
[  350.175419] ath: (2437 MHz) -> (5620 MHz), conf_is_ht40: 0
[  350.303231] ath: Set channel: 2437 MHz
[  350.303237] ath: tx chmask: 5, rx chmask: 7
[  350.303400] ath: (5620 MHz) -> (2437 MHz), conf_is_ht40: 1
[  350.304080] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  350.605202] ath: Set channel: 5640 MHz
[  350.605218] ath: tx chmask: 5, rx chmask: 7
[  350.605417] ath: (2437 MHz) -> (5640 MHz), conf_is_ht40: 0
[  350.733114] ath: Set channel: 2437 MHz
[  350.733158] ath: tx chmask: 5, rx chmask: 7
[  350.733364] ath: (5640 MHz) -> (2437 MHz), conf_is_ht40: 1
[  350.734253] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  351.037170] ath: Set channel: 5660 MHz
[  351.037175] ath: tx chmask: 5, rx chmask: 7
[  351.037312] ath: (2437 MHz) -> (5660 MHz), conf_is_ht40: 0
[  351.164069] ath: Set channel: 2437 MHz
[  351.164075] ath: tx chmask: 5, rx chmask: 7
[  351.164237] ath: (5660 MHz) -> (2437 MHz), conf_is_ht40: 1
[  351.164903] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  351.467196] ath: Set channel: 5680 MHz
[  351.467214] ath: tx chmask: 5, rx chmask: 7
[  351.467397] ath: (2437 MHz) -> (5680 MHz), conf_is_ht40: 0
[  351.595154] ath: Set channel: 2437 MHz
[  351.595160] ath: tx chmask: 5, rx chmask: 7
[  351.595313] ath: (5680 MHz) -> (2437 MHz), conf_is_ht40: 1
[  351.595979] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  351.898174] ath: Set channel: 5700 MHz
[  351.898180] ath: tx chmask: 5, rx chmask: 7
[  351.898321] ath: (2437 MHz) -> (5700 MHz), conf_is_ht40: 0
[  352.025859] ath: Set channel: 2437 MHz
[  352.025875] ath: tx chmask: 5, rx chmask: 7
[  352.026076] ath: (5700 MHz) -> (2437 MHz), conf_is_ht40: 1
[  352.026983] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  352.329179] ath: Set channel: 5745 MHz
[  352.329186] ath: tx chmask: 5, rx chmask: 7
[  352.329333] ath: (2437 MHz) -> (5745 MHz), conf_is_ht40: 0
[  352.391393] ath: Set channel: 2437 MHz
[  352.391407] ath: tx chmask: 5, rx chmask: 7
[  352.391599] ath: (5745 MHz) -> (2437 MHz), conf_is_ht40: 1
[  352.392509] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  352.695354] ath: Set channel: 5765 MHz
[  352.695371] ath: tx chmask: 5, rx chmask: 7
[  352.695555] ath: (2437 MHz) -> (5765 MHz), conf_is_ht40: 0
[  352.759066] ath: Set channel: 2437 MHz
[  352.759072] ath: tx chmask: 5, rx chmask: 7
[  352.759258] ath: (5765 MHz) -> (2437 MHz), conf_is_ht40: 1
[  352.760133] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  353.063368] ath: Set channel: 5785 MHz
[  353.063383] ath: tx chmask: 5, rx chmask: 7
[  353.063565] ath: (2437 MHz) -> (5785 MHz), conf_is_ht40: 0
[  353.126203] ath: Set channel: 2437 MHz
[  353.126218] ath: tx chmask: 5, rx chmask: 7
[  353.126413] ath: (5785 MHz) -> (2437 MHz), conf_is_ht40: 1
[  353.127331] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  353.430190] ath: Set channel: 5805 MHz
[  353.430203] ath: tx chmask: 5, rx chmask: 7
[  353.430386] ath: (2437 MHz) -> (5805 MHz), conf_is_ht40: 0
[  353.493168] ath: Set channel: 2437 MHz
[  353.493175] ath: tx chmask: 5, rx chmask: 7
[  353.493340] ath: (5805 MHz) -> (2437 MHz), conf_is_ht40: 1
[  353.494023] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  353.796175] ath: Set channel: 5825 MHz
[  353.796181] ath: tx chmask: 5, rx chmask: 7
[  353.796319] ath: (2437 MHz) -> (5825 MHz), conf_is_ht40: 0
[  353.859085] ath: Set channel: 2437 MHz
[  353.859099] ath: tx chmask: 5, rx chmask: 7
[  353.859301] ath: (5825 MHz) -> (2437 MHz), conf_is_ht40: 1
[  353.860186] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  353.862370] ath: Set HW RX filter: 0x607
[  357.864053] CE: hpet increasing min_delta_ns to 15000 nsec
[  400.272849] ath: Set HW RX filter: 0x417
[  400.402182] ath: Set channel: 2412 MHz
[  400.402197] ath: tx chmask: 5, rx chmask: 7
[  400.402381] ath: (2437 MHz) -> (2412 MHz), conf_is_ht40: 0
[  400.403290] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  400.465159] ath: Set channel: 2437 MHz
[  400.465166] ath: tx chmask: 5, rx chmask: 7
[  400.465312] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 1
[  400.465400] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  400.766222] ath: Set channel: 2417 MHz
[  400.766236] ath: tx chmask: 5, rx chmask: 7
[  400.766418] ath: (2437 MHz) -> (2417 MHz), conf_is_ht40: 0
[  400.766528] ath: Force rf_pwd_icsyndiv to 1 on 2417
[  400.827125] ath: Set channel: 2437 MHz
[  400.827163] ath: tx chmask: 5, rx chmask: 7
[  400.827366] ath: (2417 MHz) -> (2437 MHz), conf_is_ht40: 1
[  400.827483] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  401.128181] ath: Set channel: 2422 MHz
[  401.128188] ath: tx chmask: 5, rx chmask: 7
[  401.128327] ath: (2437 MHz) -> (2422 MHz), conf_is_ht40: 0
[  401.128408] ath: Force rf_pwd_icsyndiv to 2 on 2422
[  401.189156] ath: Set channel: 2437 MHz
[  401.189162] ath: tx chmask: 5, rx chmask: 7
[  401.189313] ath: (2422 MHz) -> (2437 MHz), conf_is_ht40: 1
[  401.189397] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  401.490626] ath: Set channel: 2427 MHz
[  401.490642] ath: tx chmask: 5, rx chmask: 7
[  401.490825] ath: (2437 MHz) -> (2427 MHz), conf_is_ht40: 0
[  401.490931] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  401.552192] ath: Set channel: 2437 MHz
[  401.552207] ath: tx chmask: 5, rx chmask: 7
[  401.552399] ath: (2427 MHz) -> (2437 MHz), conf_is_ht40: 1
[  401.552511] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  401.853204] ath: Set channel: 2432 MHz
[  401.853218] ath: tx chmask: 5, rx chmask: 7
[  401.853414] ath: (2437 MHz) -> (2432 MHz), conf_is_ht40: 0
[  401.853524] ath: Force rf_pwd_icsyndiv to 2 on 2432
[  401.914110] ath: Set channel: 2437 MHz
[  401.914125] ath: tx chmask: 5, rx chmask: 7
[  401.914359] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 1
[  401.914482] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  402.215192] ath: Set channel: 2437 MHz
[  402.215198] ath: tx chmask: 5, rx chmask: 7
[  402.215335] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 0
[  402.216108] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  402.277152] ath: Set channel: 2437 MHz
[  402.277157] ath: tx chmask: 5, rx chmask: 7
[  402.277305] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 1
[  402.277966] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  402.579180] ath: Set channel: 2442 MHz
[  402.579196] ath: tx chmask: 5, rx chmask: 7
[  402.579385] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
[  402.579496] ath: Force rf_pwd_icsyndiv to 2 on 2442
[  402.640106] ath: Set channel: 2437 MHz
[  402.640122] ath: tx chmask: 5, rx chmask: 7
[  402.640348] ath: (2442 MHz) -> (2437 MHz), conf_is_ht40: 1
[  402.640467] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  402.942187] ath: Set channel: 2447 MHz
[  402.942201] ath: tx chmask: 5, rx chmask: 7
[  402.942397] ath: (2437 MHz) -> (2447 MHz), conf_is_ht40: 0
[  402.942505] ath: Force rf_pwd_icsyndiv to 2 on 2447
[  403.004200] ath: Set channel: 2437 MHz
[  403.004208] ath: tx chmask: 5, rx chmask: 7
[  403.004367] ath: (2447 MHz) -> (2437 MHz), conf_is_ht40: 1
[  403.004454] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  403.305152] ath: Set channel: 2452 MHz
[  403.305158] ath: tx chmask: 5, rx chmask: 7
[  403.305299] ath: (2437 MHz) -> (2452 MHz), conf_is_ht40: 0
[  403.305377] ath: Force rf_pwd_icsyndiv to 2 on 2452
[  403.366173] ath: Set channel: 2437 MHz
[  403.366179] ath: tx chmask: 5, rx chmask: 7
[  403.366322] ath: (2452 MHz) -> (2437 MHz), conf_is_ht40: 1
[  403.366406] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  403.667079] ath: Set channel: 2457 MHz
[  403.667087] ath: tx chmask: 5, rx chmask: 7
[  403.667241] ath: (2437 MHz) -> (2457 MHz), conf_is_ht40: 0
[  403.667330] ath: Force rf_pwd_icsyndiv to 2 on 2457
[  403.728770] ath: Set channel: 2437 MHz
[  403.728784] ath: tx chmask: 5, rx chmask: 7
[  403.728986] ath: (2457 MHz) -> (2437 MHz), conf_is_ht40: 1
[  403.729108] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  404.030194] ath: Set channel: 2462 MHz
[  404.030207] ath: tx chmask: 5, rx chmask: 7
[  404.030395] ath: (2437 MHz) -> (2462 MHz), conf_is_ht40: 0
[  404.030503] ath: Force rf_pwd_icsyndiv to 2 on 2462
[  404.091209] ath: Set channel: 2437 MHz
[  404.091223] ath: tx chmask: 5, rx chmask: 7
[  404.091432] ath: (2462 MHz) -> (2437 MHz), conf_is_ht40: 1
[  404.091548] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  404.393186] ath: Set channel: 5180 MHz
[  404.393201] ath: tx chmask: 5, rx chmask: 7
[  404.393387] ath: (2437 MHz) -> (5180 MHz), conf_is_ht40: 0
[  404.456225] ath: Set channel: 2437 MHz
[  404.456231] ath: tx chmask: 5, rx chmask: 7
[  404.456383] ath: (5180 MHz) -> (2437 MHz), conf_is_ht40: 1
[  404.457051] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  404.762243] ath: Set channel: 5200 MHz
[  404.762249] ath: tx chmask: 5, rx chmask: 7
[  404.762390] ath: (2437 MHz) -> (5200 MHz), conf_is_ht40: 0
[  404.825174] ath: Set channel: 2437 MHz
[  404.825180] ath: tx chmask: 5, rx chmask: 7
[  404.825331] ath: (5200 MHz) -> (2437 MHz), conf_is_ht40: 1
[  404.825994] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  405.127200] ath: Set channel: 5220 MHz
[  405.127216] ath: tx chmask: 5, rx chmask: 7
[  405.127405] ath: (2437 MHz) -> (5220 MHz), conf_is_ht40: 0
[  405.190210] ath: Set channel: 2437 MHz
[  405.190226] ath: tx chmask: 5, rx chmask: 7
[  405.190428] ath: (5220 MHz) -> (2437 MHz), conf_is_ht40: 1
[  405.191329] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  405.493189] ath: Set channel: 5240 MHz
[  405.493195] ath: tx chmask: 5, rx chmask: 7
[  405.493335] ath: (2437 MHz) -> (5240 MHz), conf_is_ht40: 0
[  405.556213] ath: Set channel: 2437 MHz
[  405.556229] ath: tx chmask: 5, rx chmask: 7
[  405.556425] ath: (5240 MHz) -> (2437 MHz), conf_is_ht40: 1
[  405.557331] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  405.859188] ath: Set channel: 5260 MHz
[  405.859193] ath: tx chmask: 5, rx chmask: 7
[  405.859338] ath: (2437 MHz) -> (5260 MHz), conf_is_ht40: 0
[  405.986204] ath: Set channel: 2437 MHz
[  405.986219] ath: tx chmask: 5, rx chmask: 7
[  405.986419] ath: (5260 MHz) -> (2437 MHz), conf_is_ht40: 1
[  405.987335] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  406.290197] ath: Set channel: 5280 MHz
[  406.290213] ath: tx chmask: 5, rx chmask: 7
[  406.290400] ath: (2437 MHz) -> (5280 MHz), conf_is_ht40: 0
[  406.418214] ath: Set channel: 2437 MHz
[  406.418230] ath: tx chmask: 5, rx chmask: 7
[  406.418438] ath: (5280 MHz) -> (2437 MHz), conf_is_ht40: 1
[  406.419330] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  406.723172] ath: Set channel: 5300 MHz
[  406.723177] ath: tx chmask: 5, rx chmask: 7
[  406.723317] ath: (2437 MHz) -> (5300 MHz), conf_is_ht40: 0
[  406.850147] ath: Set channel: 2437 MHz
[  406.850153] ath: tx chmask: 5, rx chmask: 7
[  406.850306] ath: (5300 MHz) -> (2437 MHz), conf_is_ht40: 1
[  406.850966] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  407.152175] ath: Set channel: 5320 MHz
[  407.152181] ath: tx chmask: 5, rx chmask: 7
[  407.152322] ath: (2437 MHz) -> (5320 MHz), conf_is_ht40: 0
[  407.279176] ath: Set channel: 2437 MHz
[  407.279182] ath: tx chmask: 5, rx chmask: 7
[  407.279332] ath: (5320 MHz) -> (2437 MHz), conf_is_ht40: 1
[  407.280010] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  407.581205] ath: Set channel: 5500 MHz
[  407.581212] ath: tx chmask: 5, rx chmask: 7
[  407.581348] ath: (2437 MHz) -> (5500 MHz), conf_is_ht40: 0
[  407.708151] ath: Set channel: 2437 MHz
[  407.708157] ath: tx chmask: 5, rx chmask: 7
[  407.708312] ath: (5500 MHz) -> (2437 MHz), conf_is_ht40: 1
[  407.708974] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  408.010405] ath: Set channel: 5520 MHz
[  408.010411] ath: tx chmask: 5, rx chmask: 7
[  408.010547] ath: (2437 MHz) -> (5520 MHz), conf_is_ht40: 0
[  408.137178] ath: Set channel: 2437 MHz
[  408.137184] ath: tx chmask: 5, rx chmask: 7
[  408.137336] ath: (5520 MHz) -> (2437 MHz), conf_is_ht40: 1
[  408.138001] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  408.439508] ath: Set channel: 5540 MHz
[  408.439514] ath: tx chmask: 5, rx chmask: 7
[  408.439652] ath: (2437 MHz) -> (5540 MHz), conf_is_ht40: 0
[  408.568048] ath: Set channel: 2437 MHz
[  408.568054] ath: tx chmask: 5, rx chmask: 7
[  408.568206] ath: (5540 MHz) -> (2437 MHz), conf_is_ht40: 1
[  408.568872] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  408.870025] ath: Set channel: 5560 MHz
[  408.870031] ath: tx chmask: 5, rx chmask: 7
[  408.870179] ath: (2437 MHz) -> (5560 MHz), conf_is_ht40: 0
[  408.997115] ath: Set channel: 2437 MHz
[  408.997130] ath: tx chmask: 5, rx chmask: 7
[  408.997322] ath: (5560 MHz) -> (2437 MHz), conf_is_ht40: 1
[  408.998214] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  409.300261] ath: Set channel: 5580 MHz
[  409.300276] ath: tx chmask: 5, rx chmask: 7
[  409.300478] ath: (2437 MHz) -> (5580 MHz), conf_is_ht40: 0
[  409.428573] ath: Set channel: 2437 MHz
[  409.428589] ath: tx chmask: 5, rx chmask: 7
[  409.428780] ath: (5580 MHz) -> (2437 MHz), conf_is_ht40: 1
[  409.429662] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  409.732183] ath: Set channel: 5600 MHz
[  409.732189] ath: tx chmask: 5, rx chmask: 7
[  409.732329] ath: (2437 MHz) -> (5600 MHz), conf_is_ht40: 0
[  409.859204] ath: Set channel: 2437 MHz
[  409.859220] ath: tx chmask: 5, rx chmask: 7
[  409.859424] ath: (5600 MHz) -> (2437 MHz), conf_is_ht40: 1
[  409.860327] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  410.163107] ath: Set channel: 5620 MHz
[  410.163122] ath: tx chmask: 5, rx chmask: 7
[  410.163307] ath: (2437 MHz) -> (5620 MHz), conf_is_ht40: 0
[  410.291059] ath: Set channel: 2437 MHz
[  410.291075] ath: tx chmask: 5, rx chmask: 7
[  410.291277] ath: (5620 MHz) -> (2437 MHz), conf_is_ht40: 1
[  410.292154] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  410.594214] ath: Set channel: 5640 MHz
[  410.594230] ath: tx chmask: 5, rx chmask: 7
[  410.594434] ath: (2437 MHz) -> (5640 MHz), conf_is_ht40: 0
[  410.722085] ath: Set channel: 2437 MHz
[  410.722091] ath: tx chmask: 5, rx chmask: 7
[  410.722255] ath: (5640 MHz) -> (2437 MHz), conf_is_ht40: 1
[  410.722916] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  411.025291] ath: Set channel: 5660 MHz
[  411.025306] ath: tx chmask: 5, rx chmask: 7
[  411.025490] ath: (2437 MHz) -> (5660 MHz), conf_is_ht40: 0
[  411.153110] ath: Set channel: 2437 MHz
[  411.153153] ath: tx chmask: 5, rx chmask: 7
[  411.153359] ath: (5660 MHz) -> (2437 MHz), conf_is_ht40: 1
[  411.154258] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  411.457151] ath: Set channel: 5680 MHz
[  411.457157] ath: tx chmask: 5, rx chmask: 7
[  411.457299] ath: (2437 MHz) -> (5680 MHz), conf_is_ht40: 0
[  411.584194] ath: Set channel: 2437 MHz
[  411.584212] ath: tx chmask: 5, rx chmask: 7
[  411.584402] ath: (5680 MHz) -> (2437 MHz), conf_is_ht40: 1
[  411.585298] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  411.888107] ath: Set channel: 5700 MHz
[  411.888122] ath: tx chmask: 5, rx chmask: 7
[  411.888345] ath: (2437 MHz) -> (5700 MHz), conf_is_ht40: 0
[  412.016164] ath: Set channel: 2437 MHz
[  412.016172] ath: tx chmask: 5, rx chmask: 7
[  412.016330] ath: (5700 MHz) -> (2437 MHz), conf_is_ht40: 1
[  412.017003] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  412.319118] ath: Set channel: 5745 MHz
[  412.319154] ath: tx chmask: 5, rx chmask: 7
[  412.319358] ath: (2437 MHz) -> (5745 MHz), conf_is_ht40: 0
[  412.382099] ath: Set channel: 2437 MHz
[  412.382105] ath: tx chmask: 5, rx chmask: 7
[  412.382271] ath: (5745 MHz) -> (2437 MHz), conf_is_ht40: 1
[  412.382931] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  412.686054] ath: Set channel: 5765 MHz
[  412.686060] ath: tx chmask: 5, rx chmask: 7
[  412.686201] ath: (2437 MHz) -> (5765 MHz), conf_is_ht40: 0
[  412.749038] ath: Set channel: 2437 MHz
[  412.749045] ath: tx chmask: 5, rx chmask: 7
[  412.749198] ath: (5765 MHz) -> (2437 MHz), conf_is_ht40: 1
[  412.749861] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  413.051447] ath: Set channel: 5785 MHz
[  413.051454] ath: tx chmask: 5, rx chmask: 7
[  413.051600] ath: (2437 MHz) -> (5785 MHz), conf_is_ht40: 0
[  413.113036] ath: Set channel: 2437 MHz
[  413.113043] ath: tx chmask: 5, rx chmask: 7
[  413.113202] ath: (5785 MHz) -> (2437 MHz), conf_is_ht40: 1
[  413.113862] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  413.416047] ath: Set channel: 5805 MHz
[  413.416053] ath: tx chmask: 5, rx chmask: 7
[  413.416192] ath: (2437 MHz) -> (5805 MHz), conf_is_ht40: 0
[  413.479050] ath: Set channel: 2437 MHz
[  413.479055] ath: tx chmask: 5, rx chmask: 7
[  413.479207] ath: (5805 MHz) -> (2437 MHz), conf_is_ht40: 1
[  413.479872] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  413.781178] ath: Set channel: 5825 MHz
[  413.781186] ath: tx chmask: 5, rx chmask: 7
[  413.781326] ath: (2437 MHz) -> (5825 MHz), conf_is_ht40: 0
[  413.843160] ath: Set channel: 2437 MHz
[  413.843166] ath: tx chmask: 5, rx chmask: 7
[  413.843331] ath: (5825 MHz) -> (2437 MHz), conf_is_ht40: 1
[  413.843998] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  413.845846] ath: Set HW RX filter: 0x607
[  480.268794] ath: Set HW RX filter: 0x417
[  480.399035] ath: Set channel: 2412 MHz
[  480.399042] ath: tx chmask: 5, rx chmask: 7
[  480.399182] ath: (2437 MHz) -> (2412 MHz), conf_is_ht40: 0
[  480.399958] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  480.463058] ath: Set channel: 2437 MHz
[  480.463064] ath: tx chmask: 5, rx chmask: 7
[  480.463213] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 1
[  480.463299] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  480.764215] ath: Set channel: 2417 MHz
[  480.764230] ath: tx chmask: 5, rx chmask: 7
[  480.764432] ath: (2437 MHz) -> (2417 MHz), conf_is_ht40: 0
[  480.764546] ath: Force rf_pwd_icsyndiv to 1 on 2417
[  480.826280] ath: Set channel: 2437 MHz
[  480.826295] ath: tx chmask: 5, rx chmask: 7
[  480.826499] ath: (2417 MHz) -> (2437 MHz), conf_is_ht40: 1
[  480.826615] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  481.128186] ath: Set channel: 2422 MHz
[  481.128200] ath: tx chmask: 5, rx chmask: 7
[  481.128383] ath: (2437 MHz) -> (2422 MHz), conf_is_ht40: 0
[  481.128490] ath: Force rf_pwd_icsyndiv to 2 on 2422
[  481.189209] ath: Set channel: 2437 MHz
[  481.189223] ath: tx chmask: 5, rx chmask: 7
[  481.190104] ath: (2422 MHz) -> (2437 MHz), conf_is_ht40: 1
[  481.190242] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  481.492210] ath: Set channel: 2427 MHz
[  481.492225] ath: tx chmask: 5, rx chmask: 7
[  481.492410] ath: (2437 MHz) -> (2427 MHz), conf_is_ht40: 0
[  481.492516] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  481.553207] ath: Set channel: 2437 MHz
[  481.553222] ath: tx chmask: 5, rx chmask: 7
[  481.553414] ath: (2427 MHz) -> (2437 MHz), conf_is_ht40: 1
[  481.553526] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  481.855200] ath: Set channel: 2432 MHz
[  481.855215] ath: tx chmask: 5, rx chmask: 7
[  481.855397] ath: (2437 MHz) -> (2432 MHz), conf_is_ht40: 0
[  481.855505] ath: Force rf_pwd_icsyndiv to 2 on 2432
[  481.916095] ath: Set channel: 2437 MHz
[  481.916110] ath: tx chmask: 5, rx chmask: 7
[  481.916321] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 1
[  481.916437] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  482.217089] ath: Set channel: 2437 MHz
[  482.217103] ath: tx chmask: 5, rx chmask: 7
[  482.217320] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 0
[  482.218193] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  482.279082] ath: Set channel: 2437 MHz
[  482.279096] ath: tx chmask: 5, rx chmask: 7
[  482.279323] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 1
[  482.280201] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  482.583079] ath: Set channel: 2442 MHz
[  482.583095] ath: tx chmask: 5, rx chmask: 7
[  482.583289] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
[  482.583397] ath: Force rf_pwd_icsyndiv to 2 on 2442
[  482.645104] ath: Set channel: 2437 MHz
[  482.645120] ath: tx chmask: 5, rx chmask: 7
[  482.645328] ath: (2442 MHz) -> (2437 MHz), conf_is_ht40: 1
[  482.645448] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  482.947109] ath: Set channel: 2447 MHz
[  482.947124] ath: tx chmask: 5, rx chmask: 7
[  482.947320] ath: (2437 MHz) -> (2447 MHz), conf_is_ht40: 0
[  482.947426] ath: Force rf_pwd_icsyndiv to 2 on 2447
[  483.009085] ath: Set channel: 2437 MHz
[  483.009098] ath: tx chmask: 5, rx chmask: 7
[  483.009302] ath: (2447 MHz) -> (2437 MHz), conf_is_ht40: 1
[  483.009413] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  483.311064] ath: Set channel: 2452 MHz
[  483.311077] ath: tx chmask: 5, rx chmask: 7
[  483.311266] ath: (2437 MHz) -> (2452 MHz), conf_is_ht40: 0
[  483.311373] ath: Force rf_pwd_icsyndiv to 2 on 2452
[  483.373062] ath: Set channel: 2437 MHz
[  483.373074] ath: tx chmask: 5, rx chmask: 7
[  483.373269] ath: (2452 MHz) -> (2437 MHz), conf_is_ht40: 1
[  483.373379] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  483.675182] ath: Set channel: 2457 MHz
[  483.675197] ath: tx chmask: 5, rx chmask: 7
[  483.675382] ath: (2437 MHz) -> (2457 MHz), conf_is_ht40: 0
[  483.675489] ath: Force rf_pwd_icsyndiv to 2 on 2457
[  483.736084] ath: Set channel: 2437 MHz
[  483.736100] ath: tx chmask: 5, rx chmask: 7
[  483.736327] ath: (2457 MHz) -> (2437 MHz), conf_is_ht40: 1
[  483.736444] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  484.038209] ath: Set channel: 2462 MHz
[  484.038223] ath: tx chmask: 5, rx chmask: 7
[  484.038413] ath: (2437 MHz) -> (2462 MHz), conf_is_ht40: 0
[  484.038519] ath: Force rf_pwd_icsyndiv to 2 on 2462
[  484.099187] ath: Set channel: 2437 MHz
[  484.099202] ath: tx chmask: 5, rx chmask: 7
[  484.099401] ath: (2462 MHz) -> (2437 MHz), conf_is_ht40: 1
[  484.099517] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  484.402066] ath: Set channel: 5180 MHz
[  484.402080] ath: tx chmask: 5, rx chmask: 7
[  484.402275] ath: (2437 MHz) -> (5180 MHz), conf_is_ht40: 0
[  484.466073] ath: Set channel: 2437 MHz
[  484.466087] ath: tx chmask: 5, rx chmask: 7
[  484.466292] ath: (5180 MHz) -> (2437 MHz), conf_is_ht40: 1
[  484.467186] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  484.769077] ath: Set channel: 5200 MHz
[  484.769092] ath: tx chmask: 5, rx chmask: 7
[  484.769292] ath: (2437 MHz) -> (5200 MHz), conf_is_ht40: 0
[  484.832078] ath: Set channel: 2437 MHz
[  484.832092] ath: tx chmask: 5, rx chmask: 7
[  484.832299] ath: (5200 MHz) -> (2437 MHz), conf_is_ht40: 1
[  484.833188] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  485.135206] ath: Set channel: 5220 MHz
[  485.135221] ath: tx chmask: 5, rx chmask: 7
[  485.135409] ath: (2437 MHz) -> (5220 MHz), conf_is_ht40: 0
[  485.198084] ath: Set channel: 2437 MHz
[  485.198099] ath: tx chmask: 5, rx chmask: 7
[  485.198328] ath: (5220 MHz) -> (2437 MHz), conf_is_ht40: 1
[  485.199211] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  485.501198] ath: Set channel: 5240 MHz
[  485.501213] ath: tx chmask: 5, rx chmask: 7
[  485.501401] ath: (2437 MHz) -> (5240 MHz), conf_is_ht40: 0
[  485.565191] ath: Set channel: 2437 MHz
[  485.565206] ath: tx chmask: 5, rx chmask: 7
[  485.565408] ath: (5240 MHz) -> (2437 MHz), conf_is_ht40: 1
[  485.567306] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  485.870208] ath: Set channel: 5260 MHz
[  485.870223] ath: tx chmask: 5, rx chmask: 7
[  485.870407] ath: (2437 MHz) -> (5260 MHz), conf_is_ht40: 0
[  485.998190] ath: Set channel: 2437 MHz
[  485.998204] ath: tx chmask: 5, rx chmask: 7
[  485.998399] ath: (5260 MHz) -> (2437 MHz), conf_is_ht40: 1
[  485.999292] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  486.302183] ath: Set channel: 5280 MHz
[  486.302196] ath: tx chmask: 5, rx chmask: 7
[  486.302379] ath: (2437 MHz) -> (5280 MHz), conf_is_ht40: 0
[  486.431181] ath: Set channel: 2437 MHz
[  486.431194] ath: tx chmask: 5, rx chmask: 7
[  486.431399] ath: (5280 MHz) -> (2437 MHz), conf_is_ht40: 1
[  486.432294] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  486.735183] ath: Set channel: 5300 MHz
[  486.735196] ath: tx chmask: 5, rx chmask: 7
[  486.735381] ath: (2437 MHz) -> (5300 MHz), conf_is_ht40: 0
[  486.863230] ath: Set channel: 2437 MHz
[  486.863243] ath: tx chmask: 5, rx chmask: 7
[  486.863438] ath: (5300 MHz) -> (2437 MHz), conf_is_ht40: 1
[  486.864347] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  487.167185] ath: Set channel: 5320 MHz
[  487.167190] ath: tx chmask: 5, rx chmask: 7
[  487.167327] ath: (2437 MHz) -> (5320 MHz), conf_is_ht40: 0
[  487.294172] ath: Set channel: 2437 MHz
[  487.294180] ath: tx chmask: 5, rx chmask: 7
[  487.294342] ath: (5320 MHz) -> (2437 MHz), conf_is_ht40: 1
[  487.295023] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  487.597217] ath: Set channel: 5500 MHz
[  487.597231] ath: tx chmask: 5, rx chmask: 7
[  487.597422] ath: (2437 MHz) -> (5500 MHz), conf_is_ht40: 0
[  487.726115] ath: Set channel: 2437 MHz
[  487.726155] ath: tx chmask: 5, rx chmask: 7
[  487.726358] ath: (5500 MHz) -> (2437 MHz), conf_is_ht40: 1
[  487.727253] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  488.029207] ath: Set channel: 5520 MHz
[  488.029221] ath: tx chmask: 5, rx chmask: 7
[  488.029403] ath: (2437 MHz) -> (5520 MHz), conf_is_ht40: 0
[  488.158185] ath: Set channel: 2437 MHz
[  488.158201] ath: tx chmask: 5, rx chmask: 7
[  488.158392] ath: (5520 MHz) -> (2437 MHz), conf_is_ht40: 1
[  488.159290] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  488.461192] ath: Set channel: 5540 MHz
[  488.461200] ath: tx chmask: 5, rx chmask: 7
[  488.461348] ath: (2437 MHz) -> (5540 MHz), conf_is_ht40: 0
[  488.589208] ath: Set channel: 2437 MHz
[  488.589224] ath: tx chmask: 5, rx chmask: 7
[  488.589428] ath: (5540 MHz) -> (2437 MHz), conf_is_ht40: 1
[  488.590321] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  488.892186] ath: Set channel: 5560 MHz
[  488.892200] ath: tx chmask: 5, rx chmask: 7
[  488.892389] ath: (2437 MHz) -> (5560 MHz), conf_is_ht40: 0
[  489.020188] ath: Set channel: 2437 MHz
[  489.020202] ath: tx chmask: 5, rx chmask: 7
[  489.020393] ath: (5560 MHz) -> (2437 MHz), conf_is_ht40: 1
[  489.021273] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  489.323200] ath: Set channel: 5580 MHz
[  489.323214] ath: tx chmask: 5, rx chmask: 7
[  489.323408] ath: (2437 MHz) -> (5580 MHz), conf_is_ht40: 0
[  489.452214] ath: Set channel: 2437 MHz
[  489.452228] ath: tx chmask: 5, rx chmask: 7
[  489.452425] ath: (5580 MHz) -> (2437 MHz), conf_is_ht40: 1
[  489.453302] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  489.755289] ath: Set channel: 5600 MHz
[  489.755302] ath: tx chmask: 5, rx chmask: 7
[  489.755494] ath: (2437 MHz) -> (5600 MHz), conf_is_ht40: 0
[  489.883191] ath: Set channel: 2437 MHz
[  489.883205] ath: tx chmask: 5, rx chmask: 7
[  489.883396] ath: (5600 MHz) -> (2437 MHz), conf_is_ht40: 1
[  489.884285] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  490.188046] ath: Set channel: 5620 MHz
[  490.188052] ath: tx chmask: 5, rx chmask: 7
[  490.188189] ath: (2437 MHz) -> (5620 MHz), conf_is_ht40: 0
[  490.315089] ath: Set channel: 2437 MHz
[  490.315105] ath: tx chmask: 5, rx chmask: 7
[  490.315309] ath: (5620 MHz) -> (2437 MHz), conf_is_ht40: 1
[  490.316224] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  490.622031] ath: Set channel: 5640 MHz
[  490.622037] ath: tx chmask: 5, rx chmask: 7
[  490.622186] ath: (2437 MHz) -> (5640 MHz), conf_is_ht40: 0
[  490.750038] ath: Set channel: 2437 MHz
[  490.750043] ath: tx chmask: 5, rx chmask: 7
[  490.750206] ath: (5640 MHz) -> (2437 MHz), conf_is_ht40: 1
[  490.750872] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  491.052183] ath: Set channel: 5660 MHz
[  491.052199] ath: tx chmask: 5, rx chmask: 7
[  491.052381] ath: (2437 MHz) -> (5660 MHz), conf_is_ht40: 0
[  491.180098] ath: Set channel: 2437 MHz
[  491.180113] ath: tx chmask: 5, rx chmask: 7
[  491.180343] ath: (5660 MHz) -> (2437 MHz), conf_is_ht40: 1
[  491.181224] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  491.483207] ath: Set channel: 5680 MHz
[  491.483223] ath: tx chmask: 5, rx chmask: 7
[  491.483406] ath: (2437 MHz) -> (5680 MHz), conf_is_ht40: 0
[  491.611215] ath: Set channel: 2437 MHz
[  491.611230] ath: tx chmask: 5, rx chmask: 7
[  491.611421] ath: (5680 MHz) -> (2437 MHz), conf_is_ht40: 1
[  491.612321] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  491.915083] ath: Set channel: 5700 MHz
[  491.915098] ath: tx chmask: 5, rx chmask: 7
[  491.915297] ath: (2437 MHz) -> (5700 MHz), conf_is_ht40: 0
[  492.043036] ath: Set channel: 2437 MHz
[  492.043043] ath: tx chmask: 5, rx chmask: 7
[  492.043197] ath: (5700 MHz) -> (2437 MHz), conf_is_ht40: 1
[  492.043860] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  492.345114] ath: Set channel: 5745 MHz
[  492.345152] ath: tx chmask: 5, rx chmask: 7
[  492.345351] ath: (2437 MHz) -> (5745 MHz), conf_is_ht40: 0
[  492.408183] ath: Set channel: 2437 MHz
[  492.408196] ath: tx chmask: 5, rx chmask: 7
[  492.408388] ath: (5745 MHz) -> (2437 MHz), conf_is_ht40: 1
[  492.409306] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  492.711171] ath: Set channel: 5765 MHz
[  492.711178] ath: tx chmask: 5, rx chmask: 7
[  492.712079] ath: (2437 MHz) -> (5765 MHz), conf_is_ht40: 0
[  492.775181] ath: Set channel: 2437 MHz
[  492.775195] ath: tx chmask: 5, rx chmask: 7
[  492.775390] ath: (5765 MHz) -> (2437 MHz), conf_is_ht40: 1
[  492.776279] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  493.078208] ath: Set channel: 5785 MHz
[  493.078221] ath: tx chmask: 5, rx chmask: 7
[  493.078405] ath: (2437 MHz) -> (5785 MHz), conf_is_ht40: 0
[  493.141096] ath: Set channel: 2437 MHz
[  493.141109] ath: tx chmask: 5, rx chmask: 7
[  493.141333] ath: (5785 MHz) -> (2437 MHz), conf_is_ht40: 1
[  493.142861] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  493.445200] ath: Set channel: 5805 MHz
[  493.445214] ath: tx chmask: 5, rx chmask: 7
[  493.445396] ath: (2437 MHz) -> (5805 MHz), conf_is_ht40: 0
[  493.509208] ath: Set channel: 2437 MHz
[  493.509223] ath: tx chmask: 5, rx chmask: 7
[  493.509415] ath: (5805 MHz) -> (2437 MHz), conf_is_ht40: 1
[  493.510995] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  493.813203] ath: Set channel: 5825 MHz
[  493.813219] ath: tx chmask: 5, rx chmask: 7
[  493.813400] ath: (2437 MHz) -> (5825 MHz), conf_is_ht40: 0
[  493.876216] ath: Set channel: 2437 MHz
[  493.876230] ath: tx chmask: 5, rx chmask: 7
[  493.876428] ath: (5825 MHz) -> (2437 MHz), conf_is_ht40: 1
[  493.877315] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  493.879752] ath: Set HW RX filter: 0x607
[  580.274931] ath: Set HW RX filter: 0x417
[  580.404209] ath: Set channel: 2412 MHz
[  580.404224] ath: tx chmask: 5, rx chmask: 7
[  580.404409] ath: (2437 MHz) -> (2412 MHz), conf_is_ht40: 0
[  580.405315] ath: Force rf_pwd_icsyndiv to 1 on 2412
[  580.467180] ath: Set channel: 2437 MHz
[  580.467188] ath: tx chmask: 5, rx chmask: 7
[  580.467343] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 1
[  580.467432] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  580.768175] ath: Set channel: 2417 MHz
[  580.768183] ath: tx chmask: 5, rx chmask: 7
[  580.768331] ath: (2437 MHz) -> (2417 MHz), conf_is_ht40: 0
[  580.768416] ath: Force rf_pwd_icsyndiv to 1 on 2417
[  580.829200] ath: Set channel: 2437 MHz
[  580.829215] ath: tx chmask: 5, rx chmask: 7
[  580.829415] ath: (2417 MHz) -> (2437 MHz), conf_is_ht40: 1
[  580.829548] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  581.131085] ath: Set channel: 2422 MHz
[  581.131099] ath: tx chmask: 5, rx chmask: 7
[  581.131298] ath: (2437 MHz) -> (2422 MHz), conf_is_ht40: 0
[  581.131405] ath: Force rf_pwd_icsyndiv to 2 on 2422
[  581.193050] ath: Set channel: 2437 MHz
[  581.193056] ath: tx chmask: 5, rx chmask: 7
[  581.193205] ath: (2422 MHz) -> (2437 MHz), conf_is_ht40: 1
[  581.193290] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  581.494094] ath: Set channel: 2427 MHz
[  581.494110] ath: tx chmask: 5, rx chmask: 7
[  581.494321] ath: (2437 MHz) -> (2427 MHz), conf_is_ht40: 0
[  581.494430] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  581.555602] ath: Set channel: 2437 MHz
[  581.555617] ath: tx chmask: 5, rx chmask: 7
[  581.555813] ath: (2427 MHz) -> (2437 MHz), conf_is_ht40: 1
[  581.555927] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  581.857083] ath: Set channel: 2432 MHz
[  581.857097] ath: tx chmask: 5, rx chmask: 7
[  581.857287] ath: (2437 MHz) -> (2432 MHz), conf_is_ht40: 0
[  581.857393] ath: Force rf_pwd_icsyndiv to 2 on 2432
[  581.918084] ath: Set channel: 2437 MHz
[  581.918098] ath: tx chmask: 5, rx chmask: 7
[  581.918288] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 1
[  581.918400] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  582.219203] ath: Set channel: 2437 MHz
[  582.219218] ath: tx chmask: 5, rx chmask: 7
[  582.219398] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 0
[  582.220286] ath: Force rf_pwd_icsyndiv to 2 on 2437
[  582.282194] ath: Set channel: 2437 MHz
[  582.282208] ath: tx chmask: 5, rx chmask: 7
[  582.282398] ath: (2437 MHz) -> (2437 MHz), conf_is_ht40: 1
[  582.283266] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  582.585193] ath: Set channel: 2442 MHz
[  582.585208] ath: tx chmask: 5, rx chmask: 7
[  582.585391] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
[  582.585499] ath: Force rf_pwd_icsyndiv to 2 on 2442
[  582.646207] ath: Set channel: 2437 MHz
[  582.646222] ath: tx chmask: 5, rx chmask: 7
[  582.646422] ath: (2442 MHz) -> (2437 MHz), conf_is_ht40: 1
[  582.646542] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  582.948090] ath: Set channel: 2447 MHz
[  582.948105] ath: tx chmask: 5, rx chmask: 7
[  582.948321] ath: (2437 MHz) -> (2447 MHz), conf_is_ht40: 0
[  582.948435] ath: Force rf_pwd_icsyndiv to 2 on 2447
[  583.009115] ath: Set channel: 2437 MHz
[  583.009152] ath: tx chmask: 5, rx chmask: 7
[  583.009354] ath: (2447 MHz) -> (2437 MHz), conf_is_ht40: 1
[  583.009470] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  583.311184] ath: Set channel: 2452 MHz
[  583.311199] ath: tx chmask: 5, rx chmask: 7
[  583.311386] ath: (2437 MHz) -> (2452 MHz), conf_is_ht40: 0
[  583.311494] ath: Force rf_pwd_icsyndiv to 2 on 2452
[  583.372205] ath: Set channel: 2437 MHz
[  583.372219] ath: tx chmask: 5, rx chmask: 7
[  583.372409] ath: (2452 MHz) -> (2437 MHz), conf_is_ht40: 1
[  583.372520] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  583.674205] ath: Set channel: 2457 MHz
[  583.674220] ath: tx chmask: 5, rx chmask: 7
[  583.674401] ath: (2437 MHz) -> (2457 MHz), conf_is_ht40: 0
[  583.674507] ath: Force rf_pwd_icsyndiv to 2 on 2457
[  583.735200] ath: Set channel: 2437 MHz
[  583.735214] ath: tx chmask: 5, rx chmask: 7
[  583.735404] ath: (2457 MHz) -> (2437 MHz), conf_is_ht40: 1
[  583.735516] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  584.038078] ath: Set channel: 2462 MHz
[  584.038093] ath: tx chmask: 5, rx chmask: 7
[  584.038277] ath: (2437 MHz) -> (2462 MHz), conf_is_ht40: 0
[  584.038384] ath: Force rf_pwd_icsyndiv to 2 on 2462
[  584.099080] ath: Set channel: 2437 MHz
[  584.099094] ath: tx chmask: 5, rx chmask: 7
[  584.099286] ath: (2462 MHz) -> (2437 MHz), conf_is_ht40: 1
[  584.099397] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  584.403875] ath: Set channel: 5180 MHz
[  584.403891] ath: tx chmask: 5, rx chmask: 7
[  584.404084] ath: (2437 MHz) -> (5180 MHz), conf_is_ht40: 0
[  584.466094] ath: Set channel: 2437 MHz
[  584.466108] ath: tx chmask: 5, rx chmask: 7
[  584.466341] ath: (5180 MHz) -> (2437 MHz), conf_is_ht40: 1
[  584.467244] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  584.770091] ath: Set channel: 5200 MHz
[  584.770106] ath: tx chmask: 5, rx chmask: 7
[  584.770331] ath: (2437 MHz) -> (5200 MHz), conf_is_ht40: 0
[  584.833255] ath: Set channel: 2437 MHz
[  584.833271] ath: tx chmask: 5, rx chmask: 7
[  584.833469] ath: (5200 MHz) -> (2437 MHz), conf_is_ht40: 1
[  584.834374] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  585.136112] ath: Set channel: 5220 MHz
[  585.136152] ath: tx chmask: 5, rx chmask: 7
[  585.136350] ath: (2437 MHz) -> (5220 MHz), conf_is_ht40: 0
[  585.199094] ath: Set channel: 2437 MHz
[  585.199109] ath: tx chmask: 5, rx chmask: 7
[  585.199325] ath: (5220 MHz) -> (2437 MHz), conf_is_ht40: 1
[  585.200208] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  585.502084] ath: Set channel: 5240 MHz
[  585.502099] ath: tx chmask: 5, rx chmask: 7
[  585.502290] ath: (2437 MHz) -> (5240 MHz), conf_is_ht40: 0
[  585.565081] ath: Set channel: 2437 MHz
[  585.565098] ath: tx chmask: 5, rx chmask: 7
[  585.565297] ath: (5240 MHz) -> (2437 MHz), conf_is_ht40: 1
[  585.566189] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  585.868083] ath: Set channel: 5260 MHz
[  585.868098] ath: tx chmask: 5, rx chmask: 7
[  585.868318] ath: (2437 MHz) -> (5260 MHz), conf_is_ht40: 0
[  585.996216] ath: Set channel: 2437 MHz
[  585.996231] ath: tx chmask: 5, rx chmask: 7
[  585.996422] ath: (5260 MHz) -> (2437 MHz), conf_is_ht40: 1
[  585.997308] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  586.305106] ath: Set channel: 5280 MHz
[  586.305121] ath: tx chmask: 5, rx chmask: 7
[  586.305319] ath: (2437 MHz) -> (5280 MHz), conf_is_ht40: 0
[  586.433103] ath: Set channel: 2437 MHz
[  586.433119] ath: tx chmask: 5, rx chmask: 7
[  586.433319] ath: (5280 MHz) -> (2437 MHz), conf_is_ht40: 1
[  586.434211] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  586.736076] ath: Set channel: 5300 MHz
[  586.736091] ath: tx chmask: 5, rx chmask: 7
[  586.736273] ath: (2437 MHz) -> (5300 MHz), conf_is_ht40: 0
[  586.864094] ath: Set channel: 2437 MHz
[  586.864109] ath: tx chmask: 5, rx chmask: 7
[  586.864323] ath: (5300 MHz) -> (2437 MHz), conf_is_ht40: 1
[  586.865253] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  587.168223] ath: Set channel: 5320 MHz
[  587.168237] ath: tx chmask: 5, rx chmask: 7
[  587.168419] ath: (2437 MHz) -> (5320 MHz), conf_is_ht40: 0
[  587.296064] ath: Set channel: 2437 MHz
[  587.296078] ath: tx chmask: 5, rx chmask: 7
[  587.296276] ath: (5320 MHz) -> (2437 MHz), conf_is_ht40: 1
[  587.297163] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  587.599079] ath: Set channel: 5500 MHz
[  587.599094] ath: tx chmask: 5, rx chmask: 7
[  587.599279] ath: (2437 MHz) -> (5500 MHz), conf_is_ht40: 0
[  587.727093] ath: Set channel: 2437 MHz
[  587.727108] ath: tx chmask: 5, rx chmask: 7
[  587.727337] ath: (5500 MHz) -> (2437 MHz), conf_is_ht40: 1
[  587.728228] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  588.030235] ath: Set channel: 5520 MHz
[  588.030251] ath: tx chmask: 5, rx chmask: 7
[  588.030443] ath: (2437 MHz) -> (5520 MHz), conf_is_ht40: 0
[  588.158209] ath: Set channel: 2437 MHz
[  588.158224] ath: tx chmask: 5, rx chmask: 7
[  588.158429] ath: (5520 MHz) -> (2437 MHz), conf_is_ht40: 1
[  588.159323] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  588.461181] ath: Set channel: 5540 MHz
[  588.461197] ath: tx chmask: 5, rx chmask: 7
[  588.461378] ath: (2437 MHz) -> (5540 MHz), conf_is_ht40: 0
[  588.589205] ath: Set channel: 2437 MHz
[  588.589220] ath: tx chmask: 5, rx chmask: 7
[  588.589410] ath: (5540 MHz) -> (2437 MHz), conf_is_ht40: 1
[  588.590311] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  588.892199] ath: Set channel: 5560 MHz
[  588.892214] ath: tx chmask: 5, rx chmask: 7
[  588.892395] ath: (2437 MHz) -> (5560 MHz), conf_is_ht40: 0
[  589.020213] ath: Set channel: 2437 MHz
[  589.020228] ath: tx chmask: 5, rx chmask: 7
[  589.020419] ath: (5560 MHz) -> (2437 MHz), conf_is_ht40: 1
[  589.021312] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  589.323210] ath: Set channel: 5580 MHz
[  589.323225] ath: tx chmask: 5, rx chmask: 7
[  589.323412] ath: (2437 MHz) -> (5580 MHz), conf_is_ht40: 0
[  589.451093] ath: Set channel: 2437 MHz
[  589.451107] ath: tx chmask: 5, rx chmask: 7
[  589.451334] ath: (5580 MHz) -> (2437 MHz), conf_is_ht40: 1
[  589.452240] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  589.754210] ath: Set channel: 5600 MHz
[  589.754224] ath: tx chmask: 5, rx chmask: 7
[  589.754407] ath: (2437 MHz) -> (5600 MHz), conf_is_ht40: 0
[  589.882205] ath: Set channel: 2437 MHz
[  589.882220] ath: tx chmask: 5, rx chmask: 7
[  589.882412] ath: (5600 MHz) -> (2437 MHz), conf_is_ht40: 1
[  589.883291] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  590.185538] ath: Set channel: 5620 MHz
[  590.185553] ath: tx chmask: 5, rx chmask: 7
[  590.185747] ath: (2437 MHz) -> (5620 MHz), conf_is_ht40: 0
[  590.313057] ath: Set channel: 2437 MHz
[  590.313072] ath: tx chmask: 5, rx chmask: 7
[  590.313274] ath: (5620 MHz) -> (2437 MHz), conf_is_ht40: 1
[  590.314148] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  590.616112] ath: Set channel: 5640 MHz
[  590.616128] ath: tx chmask: 5, rx chmask: 7
[  590.616310] ath: (2437 MHz) -> (5640 MHz), conf_is_ht40: 0
[  590.744094] ath: Set channel: 2437 MHz
[  590.744108] ath: tx chmask: 5, rx chmask: 7
[  590.744315] ath: (5640 MHz) -> (2437 MHz), conf_is_ht40: 1
[  590.745229] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  591.047090] ath: Set channel: 5660 MHz
[  591.047105] ath: tx chmask: 5, rx chmask: 7
[  591.047324] ath: (2437 MHz) -> (5660 MHz), conf_is_ht40: 0
[  591.175192] ath: Set channel: 2437 MHz
[  591.175200] ath: tx chmask: 5, rx chmask: 7
[  591.175359] ath: (5660 MHz) -> (2437 MHz), conf_is_ht40: 1
[  591.176044] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  591.478365] ath: Set channel: 5680 MHz
[  591.478384] ath: tx chmask: 5, rx chmask: 7
[  591.478581] ath: (2437 MHz) -> (5680 MHz), conf_is_ht40: 0
[  591.606102] ath: Set channel: 2437 MHz
[  591.606117] ath: tx chmask: 5, rx chmask: 7
[  591.606349] ath: (5680 MHz) -> (2437 MHz), conf_is_ht40: 1
[  591.607249] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  591.909185] ath: Set channel: 5700 MHz
[  591.909200] ath: tx chmask: 5, rx chmask: 7
[  591.909383] ath: (2437 MHz) -> (5700 MHz), conf_is_ht40: 0
[  592.037192] ath: Set channel: 2437 MHz
[  592.037206] ath: tx chmask: 5, rx chmask: 7
[  592.037397] ath: (5700 MHz) -> (2437 MHz), conf_is_ht40: 1
[  592.038301] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  592.340210] ath: Set channel: 5745 MHz
[  592.340224] ath: tx chmask: 5, rx chmask: 7
[  592.340414] ath: (2437 MHz) -> (5745 MHz), conf_is_ht40: 0
[  592.403096] ath: Set channel: 2437 MHz
[  592.403111] ath: tx chmask: 5, rx chmask: 7
[  592.403337] ath: (5745 MHz) -> (2437 MHz), conf_is_ht40: 1
[  592.404224] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  592.707198] ath: Set channel: 5765 MHz
[  592.707212] ath: tx chmask: 5, rx chmask: 7
[  592.707395] ath: (2437 MHz) -> (5765 MHz), conf_is_ht40: 0
[  592.770121] ath: Set channel: 2437 MHz
[  592.770158] ath: tx chmask: 5, rx chmask: 7
[  592.770366] ath: (5765 MHz) -> (2437 MHz), conf_is_ht40: 1
[  592.771276] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  593.073205] ath: Set channel: 5785 MHz
[  593.073220] ath: tx chmask: 5, rx chmask: 7
[  593.073401] ath: (2437 MHz) -> (5785 MHz), conf_is_ht40: 0
[  593.136066] ath: Set channel: 2437 MHz
[  593.136081] ath: tx chmask: 5, rx chmask: 7
[  593.136312] ath: (5785 MHz) -> (2437 MHz), conf_is_ht40: 1
[  593.137225] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  593.445200] ath: Set channel: 5805 MHz
[  593.445214] ath: tx chmask: 5, rx chmask: 7
[  593.445396] ath: (2437 MHz) -> (5805 MHz), conf_is_ht40: 0
[  593.508202] ath: Set channel: 2437 MHz
[  593.508217] ath: tx chmask: 5, rx chmask: 7
[  593.508410] ath: (5805 MHz) -> (2437 MHz), conf_is_ht40: 1
[  593.509301] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  593.811094] ath: Set channel: 5825 MHz
[  593.811109] ath: tx chmask: 5, rx chmask: 7
[  593.811329] ath: (2437 MHz) -> (5825 MHz), conf_is_ht40: 0
[  593.874200] ath: Set channel: 2437 MHz
[  593.874215] ath: tx chmask: 5, rx chmask: 7
[  593.874418] ath: (5825 MHz) -> (2437 MHz), conf_is_ht40: 1
[  593.875341] ath: Force rf_pwd_icsyndiv to 2 on 2427
[  593.879010] ath: Set HW RX filter: 0x607
[  639.192956] ath: Set HW Key




-- 
Lei Ming
