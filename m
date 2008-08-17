Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:55565 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbYHQJyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 05:54:35 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Ivo van Doorn'" <ivdoorn@gmail.com>,
	<rt2400-devel@lists.sourceforge.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: RE: [Rt2400-devel] mac80211 / rt2x00 / rt61 and adhoc status
Date: Sun, 17 Aug 2008 11:54:42 +0200
Message-ID: <059201c9004f$459ccc50$0b3ca8c0@gotws1589> (sfid-20080817_115441_712682_CFFAF916)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <200808171105.46498.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > 
> > Have tried using the wpa_supplicant and got the -EBUSY from
> > ieee80211_ioctl_siwmode().
> 
> As usual: The interface must be down when changing working mode.
> 

The initial mode is 2. I do not know the source of that mode, might be a
default.
<7>[   85.713782] LaE: ieee80211_ioctl_siwmode: type=2, sdata->vif.type=2 

Between 85.713698 and 85.821832 device is opened (1=netif_running(dev))
<7>[   85.713698] LaE: ieee80211_ioctl_siwmode: 0=netif_running(dev)
<7>[   85.713752] LaE: ieee80211_ioctl_siwmode: mode=2 
<7>[   85.713782] LaE: ieee80211_ioctl_siwmode: type=2, sdata->vif.type=2 
<6>[   85.713938] phy0 -> rt2x00lib_request_firmware: Info - Loading
firmware file 'rt2561s.bin'.
<6>[   85.724265] firmware: requesting rt2561s.bin
<6>[   85.779042] phy0 -> rt2x00lib_request_firmware: Info - Firmware
detected - version: 0.8.
<7>[   85.821654] LaE: ieee80211_ioctl_giwrange: enter; 
<7>[   85.821832] LaE: ieee80211_ioctl_giwrange: 1=netif_running(dev)

When wpa supplicant set the adhoc mode=1/type=3 the device is running and
fails
<7>[   85.947991] LaE: ieee80211_ioctl_siwmode: mode=1 
<7>[   85.948134] LaE: ieee80211_ioctl_siwmode: type=3, sdata->vif.type=2 
<7>[   85.948433] LaE: ieee80211_ioctl_siwmode: type=3 

My work around was to ignore this situation and continue the mode change.

> > Worked around that and got the rt61 to join an existing 
> adhoc net, but no
> > data flow.
> > 
> > Two tests cases, but same behaviour:
> > 1) Linx.git: 2.6.26 and wpa_supplicant 0.5.9
> > 2) rt2x00.git: Version 2.2.0 and wpa_supplicant 0.5.9
> 
> Are any beacons going out? Is there anything in the logs which
> indicates what is happening?
> 

As you can se in the trace below, the configuration proceeds and the adhoc
is created.
The warnon might give some clues.




=================================================================
Complete trace follows
=================================================================

<7>[    6.591789] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - NIC:
0xff80
<7>[    6.591789] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - Led:
0xe0ff
<7>[    6.592049] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - RSSI
OFFSET BG: 0x0000
<7>[    6.592531] phy0 -> rt61pci_validate_eeprom: EEPROM recovery - RSSI
OFFSET A: 0x0000
<6>[    6.593020] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt:
0301, rf: 0003, rev: 0002661b.
<7>[    6.619711] LaE: ieee80211_register_hw: type=1 
<7>[    6.619812] LaE: ieee80211_if_set_type: enter; 
<7>[    6.619812] LaE: ieee80211_if_set_type: 0=netif_running(dev)
<7>[    6.620290] LaE: ieee80211_if_set_type: type=1 
<7>[    6.621016] phy0: Selected rate control algorithm 'pid'
<7>[    6.837403] LaE: ieee80211_if_add: type=2 
<7>[    6.837455] LaE: ieee80211_if_set_type: enter; 
<7>[    6.837483] LaE: ieee80211_if_set_type: 0=netif_running(dev)
<7>[    6.837512] LaE: ieee80211_if_set_type: type=2 
<6>[    7.150755] eth0: DSPCFG accepted after 0 usec.
<5>[    7.151830] eth0: link up.
<6>[    7.151830] eth0: Setting full-duplex based on negotiated link
capability.
<7>[   85.713213] LaE: ieee80211_ioctl_siwmode: enter; 
<7>[   85.713698] LaE: ieee80211_ioctl_siwmode: 0=netif_running(dev)
<7>[   85.713752] LaE: ieee80211_ioctl_siwmode: mode=2 
<7>[   85.713782] LaE: ieee80211_ioctl_siwmode: type=2, sdata->vif.type=2 
<6>[   85.713938] phy0 -> rt2x00lib_request_firmware: Info - Loading
firmware file 'rt2561s.bin'.
<6>[   85.724265] firmware: requesting rt2561s.bin
<6>[   85.779042] phy0 -> rt2x00lib_request_firmware: Info - Firmware
detected - version: 0.8.
<7>[   85.821654] LaE: ieee80211_ioctl_giwrange: enter; 
<7>[   85.821832] LaE: ieee80211_ioctl_giwrange: 1=netif_running(dev)
<7>[   85.832734] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.833103] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.833853] LaE: ieee80211_ioctl_siwencodeext: enter; 
<7>[   85.834032] LaE: ieee80211_ioctl_siwencodeext: 1=netif_running(dev)
<7>[   85.834755] LaE: ieee80211_ioctl_siwencodeext: enter; 
<7>[   85.834994] LaE: ieee80211_ioctl_siwencodeext: 1=netif_running(dev)
<7>[   85.835730] LaE: ieee80211_ioctl_siwencodeext: enter; 
<7>[   85.835907] LaE: ieee80211_ioctl_siwencodeext: 1=netif_running(dev)
<7>[   85.836626] LaE: ieee80211_ioctl_siwencodeext: enter; 
<7>[   85.836803] LaE: ieee80211_ioctl_siwencodeext: 1=netif_running(dev)
<7>[   85.837495] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.837714] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.839895] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.840074] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.944444] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.944814] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.945426] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.945794] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.947112] LaE: ieee80211_ioctl_siwap: enter; new AP is
00:00:00:00:00:00
<7>[   85.947496] LaE: ieee80211_ioctl_siwap: 1=netif_running(dev)
<7>[   85.947686] LaE: ieee80211_ioctl_siwmode: enter; 
<7>[   85.947842] LaE: ieee80211_ioctl_siwmode: 1=netif_running(dev)
<7>[   85.947991] LaE: ieee80211_ioctl_siwmode: mode=1 
<7>[   85.948134] LaE: ieee80211_ioctl_siwmode: type=3, sdata->vif.type=2 
<7>[   85.948433] LaE: ieee80211_ioctl_siwmode: type=3 
<7>[   85.948584] LaE: ieee80211_if_set_type: enter; 
<7>[   85.948730] LaE: ieee80211_if_set_type: 1=netif_running(dev)
<7>[   85.948963] LaE: ieee80211_if_set_type: type=3 
<7>[   85.949657] LaE: ieee80211_ioctl_siwgenie: enter; 
<7>[   85.949835] LaE: ieee80211_ioctl_siwgenie: 1=netif_running(dev)
<7>[   85.950009] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.950165] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.950333] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.950487] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.950654] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.950809] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.951055] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.951217] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.951385] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.951539] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.952524] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   85.952699] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   85.952874] LaE: ieee80211_ioctl_siwessid: enter; 
<7>[   85.953082] LaE: ieee80211_ioctl_siwessid: 1=netif_running(dev)
<7>[   85.953241] LaE: ieee80211_ioctl_siwessid: ssid=VMC500; 
<7>[   85.953392] ieee80211_sta_find_ibss: State 4
<7>[   85.953529] ieee80211_sta_active_ibss: 
<7>[   87.951049] ieee80211_sta_work: State 4
<7>[   87.951095] ieee80211_sta_find_ibss: State 4
<7>[   87.951120] ieee80211_sta_active_ibss: 
<7>[   89.346901] phy0: Adding new IBSS station 00:1c:bf:a8:70:ee
(dev=wlan0)
<4>[   89.347189] ------------[ cut here ]------------
<4>[   89.352754] WARNING: at net/mac80211/rate.h:153
rate_control_pid_rate_init+0x70/0x90 [mac80211]()
<4>[   89.363439] Modules linked in: arc4 ecb crypto_blkcipher cryptomgr
crypto_algapi rt61pci crc_itu_t rt2x00pci rt2x00lib firmware_class
eeprom_93cx6 mac80211 cfg80211
<4>[   89.382330] Pid: 0, comm: swapper Not tainted 2.6.26-lae #14
<4>[   89.388129]  [<c011c9bf>] warn_on_slowpath+0x5f/0x90
<4>[   89.394999]  [<c0114efe>] __wake_up_common+0x3e/0x70
<4>[   89.401178]  [<c0119d30>] __wake_up+0x50/0x90
<4>[   89.406426]  [<c011d30b>] wake_up_klogd+0x3b/0x40
<4>[   89.412055]  [<c011da6a>] vprintk+0x34a/0x3e0
<4>[   89.418085]  [<c01f7552>] scnprintf+0x22/0x30
<4>[   89.423334]  [<d086e830>] rate_control_pid_rate_init+0x70/0x90
[mac80211]
<4>[   89.431615]  [<d085a9bf>] ieee80211_ibss_add_sta+0xbf/0x110 [mac80211]
<4>[   89.439545]  [<d0865464>] __ieee80211_rx_handle_packet+0x744/0x860
[mac80211]
<4>[   89.448202]  [<c011e549>] profile_tick+0x49/0x90
<4>[   89.453802]  [<d08648e8>] ieee80211_rx_irqsafe+0x38/0x80 [mac80211]
<4>[   89.461430]  [<d082e195>] rt2x00lib_rxdone+0x195/0x240 [rt2x00lib]
<4>[   89.467693]  [<c028b089>] dev_alloc_skb+0x19/0x30
<4>[   89.473409]  [<d08674f1>] __ieee80211_rx+0x2c1/0x590 [mac80211]
<4>[   89.481034]  [<d0854a2f>] ieee80211_tasklet_handler+0x11f/0x130
[mac80211]
<4>[   89.489406]  [<c0121db3>] tasklet_action+0x33/0x70
<4>[   89.495165]  [<c0121ce4>] __do_softirq+0x54/0xb0
<4>[   89.501270]  [<c0121d75>] do_softirq+0x35/0x40
<4>[   89.506603]  [<c0121f17>] irq_exit+0x37/0x40
<4>[   89.511725]  [<c0105781>] do_IRQ+0x51/0xa0
<4>[   89.517304]  [<c0101dd7>] __switch_to+0x27/0x150
<4>[   89.522851]  [<c0101b40>] default_idle+0x0/0x40
<4>[   89.527795]  [<c010395b>] common_interrupt+0x23/0x28
<4>[   89.533764]  [<c0101b40>] default_idle+0x0/0x40
<4>[   89.539197]  [<c0101b69>] default_idle+0x29/0x40
<4>[   89.544752]  [<c0101a6b>] cpu_idle+0x2b/0x90
<4>[   89.549895]  =======================
<4>[   89.554143] ---[ end trace cd78b4bb496834c6 ]---
<7>[   89.967289] ieee80211_sta_work: State 4
<7>[   89.967333] ieee80211_sta_find_ibss: State 4
<7>[   89.967359] ieee80211_sta_active_ibss: 
<7>[   90.972263] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   90.972321] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   90.972531] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   90.972569] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   90.972992] LaE: ieee80211_ioctl_siwap: enter; new AP is
00:00:00:00:00:00
<7>[   90.973034] LaE: ieee80211_ioctl_siwap: 1=netif_running(dev)
<7>[   90.973079] LaE: ieee80211_ioctl_siwmode: enter; 
<7>[   90.973108] LaE: ieee80211_ioctl_siwmode: 1=netif_running(dev)
<7>[   90.973138] LaE: ieee80211_ioctl_siwmode: mode=1 
<7>[   90.973167] LaE: ieee80211_ioctl_siwmode: type=3, sdata->vif.type=3 
<7>[   90.973246] LaE: ieee80211_ioctl_siwgenie: enter; 
<7>[   90.973278] LaE: ieee80211_ioctl_siwgenie: 1=netif_running(dev)
<7>[   90.973325] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   90.973353] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   90.973393] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   90.973420] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   90.973460] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   90.973487] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   90.973527] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   90.973554] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   90.973594] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   90.973622] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   90.973806] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   90.973844] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   90.973893] LaE: ieee80211_ioctl_siwessid: enter; 
<7>[   90.973921] LaE: ieee80211_ioctl_siwessid: 1=netif_running(dev)
<7>[   90.973952] LaE: ieee80211_ioctl_siwessid: ssid=VMC500; 
<7>[   90.973984] ieee80211_sta_find_ibss: State 4
<7>[   90.974008] ieee80211_sta_active_ibss: 
<7>[   92.971242] ieee80211_sta_work: State 4
<7>[   92.971288] ieee80211_sta_find_ibss: State 4
<7>[   92.971313] ieee80211_sta_active_ibss: 
<7>[   94.971313] ieee80211_sta_work: State 4
<7>[   94.971359] ieee80211_sta_find_ibss: State 4
<7>[   94.971385] ieee80211_sta_active_ibss: 
<7>[   95.976449] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   95.976947] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   95.977218] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   95.977257] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   95.977685] LaE: ieee80211_ioctl_siwap: enter; new AP is
00:00:00:00:00:00
<7>[   95.977727] LaE: ieee80211_ioctl_siwap: 1=netif_running(dev)
<7>[   95.977772] LaE: ieee80211_ioctl_siwmode: enter; 
<7>[   95.977801] LaE: ieee80211_ioctl_siwmode: 1=netif_running(dev)
<7>[   95.977831] LaE: ieee80211_ioctl_siwmode: mode=1 
<7>[   95.977860] LaE: ieee80211_ioctl_siwmode: type=3, sdata->vif.type=3 
<7>[   95.977941] LaE: ieee80211_ioctl_siwgenie: enter; 
<7>[   95.977973] LaE: ieee80211_ioctl_siwgenie: 1=netif_running(dev)
<7>[   95.978020] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   95.978048] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   95.978088] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   95.978116] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   95.978155] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   95.978183] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   95.978222] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   95.978250] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   95.978289] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   95.978317] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   95.978502] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   95.978540] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   95.978588] LaE: ieee80211_ioctl_siwessid: enter; 
<7>[   95.978617] LaE: ieee80211_ioctl_siwessid: 1=netif_running(dev)
<7>[   95.978648] LaE: ieee80211_ioctl_siwessid: ssid=VMC500; 
<7>[   95.978679] ieee80211_sta_find_ibss: State 4
<7>[   95.978704] ieee80211_sta_active_ibss: 
<7>[   97.975428] ieee80211_sta_work: State 4
<7>[   97.975473] ieee80211_sta_find_ibss: State 4
<7>[   97.975499] ieee80211_sta_active_ibss: 
<7>[   98.122847] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   98.122906] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   98.123036] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   98.123073] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   98.123198] LaE: ieee80211_ioctl_siwauth: enter; 
<7>[   98.123234] LaE: ieee80211_ioctl_siwauth: 1=netif_running(dev)
<7>[   98.124623] LaE: ieee80211_ioctl_siwap: enter; new AP is
00:00:00:00:00:00
<7>[   98.124683] LaE: ieee80211_ioctl_siwap: 1=netif_running(dev) 

