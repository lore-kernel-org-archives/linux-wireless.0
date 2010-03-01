Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:37657 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0CACFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 21:05:15 -0500
Received: by qyk9 with SMTP id 9so1073212qyk.5
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 18:05:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d82e647a1002280716h342c7a1cu552ffdf908f495e6@mail.gmail.com>
References: <d82e647a1002280716h342c7a1cu552ffdf908f495e6@mail.gmail.com>
Date: Mon, 1 Mar 2010 10:05:14 +0800
Message-ID: <d82e647a1002281805x1a146815r73094dacc7230ee1@mail.gmail.com>
Subject: Re: ath9k: wireless-test can't work in ht40
From: Ming Lei <tom.leiming@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/28 Ming Lei <tom.leiming@gmail.com>:
> Hi,
>
> My atheros 11n card does not work in ht40 mode using the current
> wireless test tree,
> but it can work in ht40 if using 2.6.33 or 2.6.32 mainline.
>
> Follows the dmesg information, hope it is helpful to troubleshoot the issue.
>
> [  245.233755] bus: 'pci': add driver ath9k
> [  245.233809] bus: 'pci': driver_probe_device: matched device
> 0000:16:00.0 with driver ath9k
> [  245.233813] bus: 'pci': really_probe: probing driver ath9k with
> device 0000:16:00.0
> [  245.233866] ath9k 0000:16:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [  245.668698] ath: Eeprom VER: 14, REV: 8
> [  245.670918] ath: EEPROM regdomain: 0x0
> [  245.670920] ath: EEPROM indicates default country code should be used
> [  245.670922] ath: doing EEPROM country->regdmn map search
> [  245.670924] ath: country maps to regdmn code: 0x3a
> [  245.670926] ath: Country alpha2 being used: US
> [  245.670928] ath: Regpair used: 0x3a
> [  245.670933] ath: tx DMA: 512 buffers 1 desc/buf
> [  245.670967] ath: tx DMA map: ffff880073720000 (77824) -> 73720000 (77824)
> [  245.671188] ath: beacon DMA: 4 buffers 1 desc/buf
> [  245.671194] ath: beacon DMA map: ffff880070bf9000 (608) -> 70bf9000 (608)
> [  245.671208] ath: cachelsz 64 rxbufsize 3904
> [  245.671211] ath: rx DMA: 512 buffers 1 desc/buf
> [  245.671244] ath: rx DMA map: ffff880073780000 (77824) -> 73780000 (77824)
> [  245.680266] device: 'phy3': device_add
> [  245.680502] PM: Adding info for No Bus:phy3
> [  245.681247] device: 'rfkill4': device_add
> [  245.681488] PM: Adding info for No Bus:rfkill4
> [  245.683412] phy3: Selected rate control algorithm 'ath9k_rate_control'
> [  245.683649] device: 'wlan0': device_add
> [  245.684564] PM: Adding info for No Bus:wlan0
> [  245.685824] device: 'ath9k-phy3::radio': device_add
> [  245.686081] PM: Adding info for No Bus:ath9k-phy3::radio
> [  245.686722] Registered led device: ath9k-phy3::radio
> [  245.686755] device: 'ath9k-phy3::assoc': device_add
> [  245.686895] PM: Adding info for No Bus:ath9k-phy3::assoc
> [  245.687719] Registered led device: ath9k-phy3::assoc
> [  245.687752] device: 'ath9k-phy3::tx': device_add
> [  245.687896] PM: Adding info for No Bus:ath9k-phy3::tx
> [  245.688672] Registered led device: ath9k-phy3::tx
> [  245.688707] device: 'ath9k-phy3::rx': device_add
> [  245.688840] PM: Adding info for No Bus:ath9k-phy3::rx
> [  245.689611] Registered led device: ath9k-phy3::rx
> [  245.689618] phy3: Atheros AR5416 MAC/BB Rev:2 AR5133 RF Rev:81
> mem=0xffffc90016660000, irq=16
> [  245.689621] driver: '0000:16:00.0': driver_bound: bound to device 'ath9k'
> [  245.689626] bus: 'pci': really_probe: bound device 0000:16:00.0 to
> driver ath9k
> [  245.704350] device: 'wlan0': device_rename: renaming to 'wlan1'
> [  245.707519] udev: renamed network interface wlan0 to wlan1
> [  250.267697] ath: Starting driver with initial channel: 2412 MHz
> [  250.268482] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  250.270113] ath: Attach a VIF of type: 2
> [  250.270206] ath: BSS Changed PREAMBLE 0
> [  250.270209] ath: BSS Changed CTS PROT 0
> [  250.272155] ath: Marking phy3 as idle
> [  250.272915] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  250.274677] ath: not-idle: enabling radio
> [  250.274684] ath: Set channel: 2412 MHz
> [  250.274687] ath: tx chmask: 1, rx chmask: 1
> [  250.274832] ath: (2412 MHz) -> (2412 MHz), conf_is_ht40: 0
> [  250.275594] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  250.277017] ath: idle: disabling radio
> [  250.277967] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  250.278923] ath: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min:
> 7, cw_max: 15, txop: 102
> [  250.279490] ath: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min:
> 15, cw_max: 31, txop: 188
> [  250.280660] ath: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min:
> 31, cw_max: 1023, txop: 0
> [  250.281833] ath: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min:
> 31, cw_max: 1023, txop: 0
> [  250.283206] ath: Set HW RX filter: 0x207
> [  250.283289] ath: Set HW RX filter: 0x207
> [  250.283429] ADDRCONF(NETDEV_UP): wlan1: link is not ready
> [  250.283534] ath: Set HW RX filter: 0x207
> [  250.288279] ath: Marking phy3 as not-idle
> [  250.289112] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  250.290310] ath: not-idle: enabling radio
> [  250.290329] ath: Set HW RX filter: 0x17
> [  250.421032] ath: Set channel: 2412 MHz
> [  250.421038] ath: tx chmask: 5, rx chmask: 7
> [  250.421190] ath: (2412 MHz) -> (2412 MHz), conf_is_ht40: 0
> [  250.421974] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  250.483100] ath: Set channel: 2417 MHz
> [  250.483114] ath: tx chmask: 5, rx chmask: 7
> [  250.483302] ath: (2412 MHz) -> (2417 MHz), conf_is_ht40: 0
> [  250.483411] ath: Force rf_pwd_icsyndiv to 1 on 2417
> [  250.544108] ath: Set channel: 2422 MHz
> [  250.544120] ath: tx chmask: 5, rx chmask: 7
> [  250.544307] ath: (2417 MHz) -> (2422 MHz), conf_is_ht40: 0
> [  250.544416] ath: Force rf_pwd_icsyndiv to 2 on 2422
> [  250.605027] ath: Set channel: 2427 MHz
> [  250.605031] ath: tx chmask: 5, rx chmask: 7
> [  250.605179] ath: (2422 MHz) -> (2427 MHz), conf_is_ht40: 0
> [  250.605261] ath: Force rf_pwd_icsyndiv to 2 on 2427
> [  250.666100] ath: Set channel: 2432 MHz
> [  250.666112] ath: tx chmask: 5, rx chmask: 7
> [  250.666299] ath: (2427 MHz) -> (2432 MHz), conf_is_ht40: 0
> [  250.666407] ath: Force rf_pwd_icsyndiv to 2 on 2432
> [  250.727122] ath: Set channel: 2437 MHz
> [  250.727134] ath: tx chmask: 5, rx chmask: 7
> [  250.727319] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 0
> [  250.727427] ath: Force rf_pwd_icsyndiv to 2 on 2437
> [  250.788119] ath: Set channel: 2442 MHz
> [  250.788128] ath: tx chmask: 5, rx chmask: 7
> [  250.788313] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
> [  250.788421] ath: Force rf_pwd_icsyndiv to 2 on 2442
> [  250.849118] ath: Set channel: 2447 MHz
> [  250.849132] ath: tx chmask: 5, rx chmask: 7
> [  250.849320] ath: (2442 MHz) -> (2447 MHz), conf_is_ht40: 0
> [  250.849431] ath: Force rf_pwd_icsyndiv to 2 on 2447
> [  250.910101] ath: Set channel: 2452 MHz
> [  250.910113] ath: tx chmask: 5, rx chmask: 7
> [  250.910302] ath: (2447 MHz) -> (2452 MHz), conf_is_ht40: 0
> [  250.910412] ath: Force rf_pwd_icsyndiv to 2 on 2452
> [  250.971097] ath: Set channel: 2457 MHz
> [  250.971108] ath: tx chmask: 5, rx chmask: 7
> [  250.971303] ath: (2452 MHz) -> (2457 MHz), conf_is_ht40: 0
> [  250.971412] ath: Force rf_pwd_icsyndiv to 2 on 2457
> [  251.032117] ath: Set channel: 2462 MHz
> [  251.032129] ath: tx chmask: 5, rx chmask: 7
> [  251.032314] ath: (2457 MHz) -> (2462 MHz), conf_is_ht40: 0
> [  251.032423] ath: Force rf_pwd_icsyndiv to 2 on 2462
> [  251.094106] ath: Set channel: 2467 MHz
> [  251.094117] ath: tx chmask: 5, rx chmask: 7
> [  251.094316] ath: (2462 MHz) -> (2467 MHz), conf_is_ht40: 0
> [  251.094425] ath: Force rf_pwd_icsyndiv to 2 on 2467
> [  251.155073] ath: Set channel: 2472 MHz
> [  251.155079] ath: tx chmask: 5, rx chmask: 7
> [  251.155242] ath: (2467 MHz) -> (2472 MHz), conf_is_ht40: 0
> [  251.155331] ath: Force rf_pwd_icsyndiv to 2 on 2472
> [  251.217087] ath: Set channel: 2484 MHz
> [  251.217102] ath: tx chmask: 5, rx chmask: 7
> [  251.217300] ath: (2472 MHz) -> (2484 MHz), conf_is_ht40: 0
> [  251.217418] ath: Force rf_pwd_icsyndiv to 2 on 2484
> [  251.278099] ath: Set channel: 5180 MHz
> [  251.278113] ath: tx chmask: 5, rx chmask: 7
> [  251.278301] ath: (2484 MHz) -> (5180 MHz), conf_is_ht40: 0
> [  251.341103] ath: Set channel: 5200 MHz
> [  251.341115] ath: tx chmask: 5, rx chmask: 7
> [  251.341304] ath: (5180 MHz) -> (5200 MHz), conf_is_ht40: 0
> [  251.402113] ath: Set channel: 5220 MHz
> [  251.402124] ath: tx chmask: 5, rx chmask: 7
> [  251.402324] ath: (5200 MHz) -> (5220 MHz), conf_is_ht40: 0
> [  251.463115] ath: Set channel: 5240 MHz
> [  251.463125] ath: tx chmask: 5, rx chmask: 7
> [  251.463309] ath: (5220 MHz) -> (5240 MHz), conf_is_ht40: 0
> [  251.524107] ath: Set channel: 5260 MHz
> [  251.524117] ath: tx chmask: 5, rx chmask: 7
> [  251.524303] ath: (5240 MHz) -> (5260 MHz), conf_is_ht40: 0
> [  251.650092] ath: Set channel: 5280 MHz
> [  251.650103] ath: tx chmask: 5, rx chmask: 7
> [  251.650301] ath: (5260 MHz) -> (5280 MHz), conf_is_ht40: 0
> [  251.776115] ath: Set channel: 5300 MHz
> [  251.776124] ath: tx chmask: 5, rx chmask: 7
> [  251.776307] ath: (5280 MHz) -> (5300 MHz), conf_is_ht40: 0
> [  251.903090] ath: Set channel: 5320 MHz
> [  251.903102] ath: tx chmask: 5, rx chmask: 7
> [  251.903293] ath: (5300 MHz) -> (5320 MHz), conf_is_ht40: 0
> [  252.029127] ath: Set channel: 5500 MHz
> [  252.029138] ath: tx chmask: 5, rx chmask: 7
> [  252.029323] ath: (5320 MHz) -> (5500 MHz), conf_is_ht40: 0
> [  252.155124] ath: Set channel: 5520 MHz
> [  252.155135] ath: tx chmask: 5, rx chmask: 7
> [  252.155320] ath: (5500 MHz) -> (5520 MHz), conf_is_ht40: 0
> [  252.281062] ath: Set channel: 5540 MHz
> [  252.281068] ath: tx chmask: 5, rx chmask: 7
> [  252.281231] ath: (5520 MHz) -> (5540 MHz), conf_is_ht40: 0
> [  252.407106] ath: Set channel: 5560 MHz
> [  252.407118] ath: tx chmask: 5, rx chmask: 7
> [  252.407315] ath: (5540 MHz) -> (5560 MHz), conf_is_ht40: 0
> [  252.533094] ath: Set channel: 5580 MHz
> [  252.533105] ath: tx chmask: 5, rx chmask: 7
> [  252.533291] ath: (5560 MHz) -> (5580 MHz), conf_is_ht40: 0
> [  252.659117] ath: Set channel: 5600 MHz
> [  252.659127] ath: tx chmask: 5, rx chmask: 7
> [  252.659310] ath: (5580 MHz) -> (5600 MHz), conf_is_ht40: 0
> [  252.785120] ath: Set channel: 5620 MHz
> [  252.785134] ath: tx chmask: 5, rx chmask: 7
> [  252.785325] ath: (5600 MHz) -> (5620 MHz), conf_is_ht40: 0
> [  252.911913] ath: Set channel: 5640 MHz
> [  252.911929] ath: tx chmask: 5, rx chmask: 7
> [  252.912162] ath: (5620 MHz) -> (5640 MHz), conf_is_ht40: 0
> [  253.038232] ath: Set channel: 5660 MHz
> [  253.038251] ath: tx chmask: 5, rx chmask: 7
> [  253.038441] ath: (5640 MHz) -> (5660 MHz), conf_is_ht40: 0
> [  253.164106] ath: Set channel: 5680 MHz
> [  253.164118] ath: tx chmask: 5, rx chmask: 7
> [  253.164343] ath: (5660 MHz) -> (5680 MHz), conf_is_ht40: 0
> [  253.290119] ath: Set channel: 5700 MHz
> [  253.290151] ath: tx chmask: 5, rx chmask: 7
> [  253.290350] ath: (5680 MHz) -> (5700 MHz), conf_is_ht40: 0
> [  253.416145] ath: Set channel: 5745 MHz
> [  253.416157] ath: tx chmask: 5, rx chmask: 7
> [  253.416346] ath: (5700 MHz) -> (5745 MHz), conf_is_ht40: 0
> [  253.479118] ath: Set channel: 5765 MHz
> [  253.479148] ath: tx chmask: 5, rx chmask: 7
> [  253.479350] ath: (5745 MHz) -> (5765 MHz), conf_is_ht40: 0
> [  253.541116] ath: Set channel: 5785 MHz
> [  253.541151] ath: tx chmask: 5, rx chmask: 7
> [  253.541352] ath: (5765 MHz) -> (5785 MHz), conf_is_ht40: 0
> [  253.603119] ath: Set channel: 5805 MHz
> [  253.603151] ath: tx chmask: 5, rx chmask: 7
> [  253.603348] ath: (5785 MHz) -> (5805 MHz), conf_is_ht40: 0
> [  253.665111] ath: Set channel: 5825 MHz
> [  253.665121] ath: tx chmask: 5, rx chmask: 7
> [  253.665343] ath: (5805 MHz) -> (5825 MHz), conf_is_ht40: 0
> [  253.727828] ath: Set channel: 2412 MHz
> [  253.727839] ath: tx chmask: 5, rx chmask: 7
> [  253.728039] ath: (5825 MHz) -> (2412 MHz), conf_is_ht40: 0
> [  253.728902] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  253.731049] ath: Set HW RX filter: 0x207
> [  253.731096] ath: Marking phy3 as idle
> [  253.731957] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  253.733910] ath: not-idle: enabling radio
> [  253.733921] ath: idle: disabling radio
> [  253.734968] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  258.730573] ath: Marking phy3 as not-idle
> [  258.731510] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  258.733337] ath: not-idle: enabling radio
> [  258.733373] ath: Set HW RX filter: 0x17
> [  258.863107] ath: Set channel: 2412 MHz
> [  258.863120] ath: tx chmask: 5, rx chmask: 7
> [  258.863346] ath: (2412 MHz) -> (2412 MHz), conf_is_ht40: 0
> [  258.864246] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  258.925215] ath: Set channel: 2417 MHz
> [  258.925228] ath: tx chmask: 5, rx chmask: 7
> [  258.925430] ath: (2412 MHz) -> (2417 MHz), conf_is_ht40: 0
> [  258.925548] ath: Force rf_pwd_icsyndiv to 1 on 2417
> [  258.987185] ath: Set channel: 2422 MHz
> [  258.987197] ath: tx chmask: 5, rx chmask: 7
> [  258.987389] ath: (2417 MHz) -> (2422 MHz), conf_is_ht40: 0
> [  258.987509] ath: Force rf_pwd_icsyndiv to 2 on 2422
> [  259.049197] ath: Set channel: 2427 MHz
> [  259.049202] ath: tx chmask: 5, rx chmask: 7
> [  259.049347] ath: (2422 MHz) -> (2427 MHz), conf_is_ht40: 0
> [  259.049437] ath: Force rf_pwd_icsyndiv to 2 on 2427
> [  259.110215] ath: Set channel: 2432 MHz
> [  259.110226] ath: tx chmask: 5, rx chmask: 7
> [  259.110412] ath: (2427 MHz) -> (2432 MHz), conf_is_ht40: 0
> [  259.110521] ath: Force rf_pwd_icsyndiv to 2 on 2432
> [  259.171193] ath: Set channel: 2437 MHz
> [  259.171211] ath: tx chmask: 5, rx chmask: 7
> [  259.171401] ath: (2432 MHz) -> (2437 MHz), conf_is_ht40: 0
> [  259.171511] ath: Force rf_pwd_icsyndiv to 2 on 2437
> [  259.233111] ath: Set channel: 2442 MHz
> [  259.233123] ath: tx chmask: 5, rx chmask: 7
> [  259.233348] ath: (2437 MHz) -> (2442 MHz), conf_is_ht40: 0
> [  259.233458] ath: Force rf_pwd_icsyndiv to 2 on 2442
> [  259.294237] ath: Set channel: 2447 MHz
> [  259.294248] ath: tx chmask: 5, rx chmask: 7
> [  259.294437] ath: (2442 MHz) -> (2447 MHz), conf_is_ht40: 0
> [  259.294545] ath: Force rf_pwd_icsyndiv to 2 on 2447
> [  259.355146] ath: Set channel: 2452 MHz
> [  259.355159] ath: tx chmask: 5, rx chmask: 7
> [  259.355349] ath: (2447 MHz) -> (2452 MHz), conf_is_ht40: 0
> [  259.355458] ath: Force rf_pwd_icsyndiv to 2 on 2452
> [  259.416121] ath: Set channel: 2457 MHz
> [  259.416185] ath: tx chmask: 5, rx chmask: 7
> [  259.416371] ath: (2452 MHz) -> (2457 MHz), conf_is_ht40: 0
> [  259.416479] ath: Force rf_pwd_icsyndiv to 2 on 2457
> [  259.477123] ath: Set channel: 2462 MHz
> [  259.477159] ath: tx chmask: 5, rx chmask: 7
> [  259.477351] ath: (2457 MHz) -> (2462 MHz), conf_is_ht40: 0
> [  259.477463] ath: Force rf_pwd_icsyndiv to 2 on 2462
> [  259.538152] ath: Set channel: 5180 MHz
> [  259.538166] ath: tx chmask: 5, rx chmask: 7
> [  259.538356] ath: (2462 MHz) -> (5180 MHz), conf_is_ht40: 0
> [  259.601212] ath: Set channel: 5200 MHz
> [  259.601223] ath: tx chmask: 5, rx chmask: 7
> [  259.601409] ath: (5180 MHz) -> (5200 MHz), conf_is_ht40: 0
> [  259.662119] ath: Set channel: 5220 MHz
> [  259.662157] ath: tx chmask: 5, rx chmask: 7
> [  259.662359] ath: (5200 MHz) -> (5220 MHz), conf_is_ht40: 0
> [  259.723027] ath: Set channel: 5240 MHz
> [  259.723033] ath: tx chmask: 5, rx chmask: 7
> [  259.723186] ath: (5220 MHz) -> (5240 MHz), conf_is_ht40: 0
> [  259.785114] ath: Set channel: 5260 MHz
> [  259.785128] ath: tx chmask: 5, rx chmask: 7
> [  259.785325] ath: (5240 MHz) -> (5260 MHz), conf_is_ht40: 0
> [  259.911087] ath: Set channel: 5280 MHz
> [  259.911102] ath: tx chmask: 5, rx chmask: 7
> [  259.911298] ath: (5260 MHz) -> (5280 MHz), conf_is_ht40: 0
> [  260.038097] ath: Set channel: 5300 MHz
> [  260.038110] ath: tx chmask: 5, rx chmask: 7
> [  260.038305] ath: (5280 MHz) -> (5300 MHz), conf_is_ht40: 0
> [  260.165101] ath: Set channel: 5320 MHz
> [  260.165115] ath: tx chmask: 5, rx chmask: 7
> [  260.165309] ath: (5300 MHz) -> (5320 MHz), conf_is_ht40: 0
> [  260.291103] ath: Set channel: 5500 MHz
> [  260.291115] ath: tx chmask: 5, rx chmask: 7
> [  260.291305] ath: (5320 MHz) -> (5500 MHz), conf_is_ht40: 0
> [  260.417097] ath: Set channel: 5520 MHz
> [  260.417110] ath: tx chmask: 5, rx chmask: 7
> [  260.417298] ath: (5500 MHz) -> (5520 MHz), conf_is_ht40: 0
> [  260.543127] ath: Set channel: 5540 MHz
> [  260.543140] ath: tx chmask: 5, rx chmask: 7
> [  260.543328] ath: (5520 MHz) -> (5540 MHz), conf_is_ht40: 0
> [  260.669129] ath: Set channel: 5560 MHz
> [  260.669145] ath: tx chmask: 5, rx chmask: 7
> [  260.669333] ath: (5540 MHz) -> (5560 MHz), conf_is_ht40: 0
> [  260.795121] ath: Set channel: 5580 MHz
> [  260.795134] ath: tx chmask: 5, rx chmask: 7
> [  260.795321] ath: (5560 MHz) -> (5580 MHz), conf_is_ht40: 0
> [  260.921106] ath: Set channel: 5600 MHz
> [  260.921119] ath: tx chmask: 5, rx chmask: 7
> [  260.921306] ath: (5580 MHz) -> (5600 MHz), conf_is_ht40: 0
> [  261.047121] ath: Set channel: 5620 MHz
> [  261.047135] ath: tx chmask: 5, rx chmask: 7
> [  261.047325] ath: (5600 MHz) -> (5620 MHz), conf_is_ht40: 0
> [  261.173105] ath: Set channel: 5640 MHz
> [  261.173119] ath: tx chmask: 5, rx chmask: 7
> [  261.173308] ath: (5620 MHz) -> (5640 MHz), conf_is_ht40: 0
> [  261.300134] ath: Set channel: 5660 MHz
> [  261.300148] ath: tx chmask: 5, rx chmask: 7
> [  261.300336] ath: (5640 MHz) -> (5660 MHz), conf_is_ht40: 0
> [  261.426130] ath: Set channel: 5680 MHz
> [  261.426144] ath: tx chmask: 5, rx chmask: 7
> [  261.426334] ath: (5660 MHz) -> (5680 MHz), conf_is_ht40: 0
> [  261.552098] ath: Set channel: 5700 MHz
> [  261.552110] ath: tx chmask: 5, rx chmask: 7
> [  261.552306] ath: (5680 MHz) -> (5700 MHz), conf_is_ht40: 0
> [  261.678129] ath: Set channel: 5745 MHz
> [  261.678143] ath: tx chmask: 5, rx chmask: 7
> [  261.678333] ath: (5700 MHz) -> (5745 MHz), conf_is_ht40: 0
> [  261.742087] ath: Set channel: 5765 MHz
> [  261.742102] ath: tx chmask: 5, rx chmask: 7
> [  261.742307] ath: (5745 MHz) -> (5765 MHz), conf_is_ht40: 0
> [  261.806043] ath: Set channel: 5785 MHz
> [  261.806050] ath: tx chmask: 5, rx chmask: 7
> [  261.806202] ath: (5765 MHz) -> (5785 MHz), conf_is_ht40: 0
> [  261.869184] ath: Set channel: 5805 MHz
> [  261.869199] ath: tx chmask: 5, rx chmask: 7
> [  261.869402] ath: (5785 MHz) -> (5805 MHz), conf_is_ht40: 0
> [  261.932177] ath: Set channel: 5825 MHz
> [  261.932183] ath: tx chmask: 5, rx chmask: 7
> [  261.932336] ath: (5805 MHz) -> (5825 MHz), conf_is_ht40: 0
> [  261.994537] ath: Set channel: 2412 MHz
> [  261.994544] ath: tx chmask: 5, rx chmask: 7
> [  261.994703] ath: (5825 MHz) -> (2412 MHz), conf_is_ht40: 0
> [  261.995511] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  261.997194] ath9k: Two wiphys trying to scan at the same time
> [  261.997211] ath: Set HW RX filter: 0x17
> [  261.997214] ath: Set HW RX filter: 0x17
> [  262.127025] ath: Set channel: 2437 MHz
> [  262.127031] ath: tx chmask: 1, rx chmask: 1
> [  262.127181] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 0
> [  262.127959] ath: Force rf_pwd_icsyndiv to 2 on 2437
> [  262.189304] ath: Set channel: 2412 MHz
> [  262.189311] ath: tx chmask: 1, rx chmask: 1
> [  262.189465] ath: (2437 MHz) -> (2412 MHz), conf_is_ht40: 0
> [  262.189555] ath: Force rf_pwd_icsyndiv to 1 on 2412
> [  262.190500] ath: Set HW RX filter: 0x207
> [  262.190573] ath: Set channel: 2437 MHz
> [  262.190577] ath: tx chmask: 1, rx chmask: 1
> [  262.190728] ath: (2412 MHz) -> (2437 MHz), conf_is_ht40: 0
> [  262.191496] ath: Force rf_pwd_icsyndiv to 2 on 2437
> [  262.193306] wlan1: direct probe to 00:26:5a:2d:31:46 (try 1)
> [  262.393106] wlan1: direct probe to 00:26:5a:2d:31:46 (try 2)
> [  262.593101] wlan1: direct probe to 00:26:5a:2d:31:46 (try 3)
> [  262.597614] wlan1: direct probe responded
> [  262.603080] wlan1: authenticate with 00:26:5a:2d:31:46 (try 1)
> [  262.623048] wlan1: authenticated
> [  262.623218] ath: Marking phy3 as idle
> [  262.624104] ath: Force rf_pwd_icsyndiv to 2 on 2437
> [  262.625656] ath: not-idle: enabling radio
> [  262.625667] ath: idle: disabling radio
> [  262.626681] ath: Force rf_pwd_icsyndiv to 2 on 2437
> [  262.627638] wlan1: associate with 00:26:5a:2d:31:46 (try 1)
> [  262.627728] ath: Marking phy3 as not-idle
> [  262.628633] ath: Force rf_pwd_icsyndiv to 2 on 2437
> [  262.629975] ath: not-idle: enabling radio
> [  262.648691] wlan1: RX AssocResp from 00:26:5a:2d:31:46 (capab=0xc31
> status=0 aid=1)
> [  262.648700] wlan1: associated
> [  262.648787] ath: Choosing rate table for mode: 6
> [  262.648815] ath: RC Initialized with capabilities: 0xe
> [  262.650614] ath_rate_update:1342 channel_type=0
> [  262.650621] ath: Choosing rate table for mode: 3

rate table is switched from ht40plus to ht20 in ath_rate_update(), but
the switch does not happen if using v2.6.33 mainline.

> [  262.650647] ath: RC Initialized with capabilities: 0xc
> [  262.650655] ath: Operating HT Bandwidth changed to: 0
> [  262.650672] ath: BSSID: 00:26:5a:2d:31:46 aid: 0x0
> [  262.650694] ath: BSS Changed PREAMBLE 1
> [  262.650701] ath: BSS Changed ASSOC 1
> [  262.650709] ath: Bss Info ASSOC 1, bssid: 00:26:5a:2d:31:46
> [  262.651470] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> [  262.654653] cfg80211: Calling CRDA for country: GB

--
Lei Ming
