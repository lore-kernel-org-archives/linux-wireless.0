Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:48783
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965967AbXCFSIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 13:08:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Crash in cfg80211
Date: Tue, 6 Mar 2007 19:07:19 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200703061907.19929.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did some stresstesting on the code in my tree.
The testscript loaded bcm43xx-mac80211, started wpa_supplicant,
rmmod while wpa_supplicant was running, in a loop.

It crashed.
Complete dmesg follows. I'm not exactly sure what happens,
but it seems cfg80211 related. The tasklet fix I sent earlier was applied.


wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=30, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 2/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=30, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 1/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 2/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 8/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=31, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
sta0: deauthenticate(reason=3)
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
sta0: starting scan
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 2/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 2/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
bcm43xx_mac80211: Broadcom 4306 WLAN found
bcm43xx_mac80211: Radio turned off
wmaster0: Selected rate control algorithm 'simple'
bcm43xx_mac80211: Adding Interface type 2
bcm43xx_mac80211: Found PHY: Analog 2, Type 2, Revision 2
bcm43xx_mac80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
bcm43xx_mac80211: Loading firmware version 316.1 (2005-09-13 21:08:28)
bcm43xx_mac80211: Radio turned on
bcm43xx_mac80211: Radio enabled by hardware
bcm43xx_mac80211: !WARNING! Idle-TSSI phy->cur_idle_tssi measuring failed. (cur=30, tgt=62). Disabling TX power adjustment.
bcm43xx_mac80211: Chip initialized
bcm43xx_mac80211: 30-bit DMA initialized
bcm43xx_mac80211: Wireless interface started
wmaster0: Does not support passive scan, disabled
sta0: starting scan
sta0: scan completed
sta0: Initial auth_alg=0
sta0: authenticate with AP 00:12:17:d4:95:e1
sta0: RX authentication from 00:12:17:d4:95:e1 (alg=0 transaction=2 status=0)
sta0: authenticated
sta0: associate with AP 00:12:17:d4:95:e1
sta0: RX AssocResp from 00:12:17:d4:95:e1 (capab=0x411 status=0 aid=1)
sta0: associated
bcm43xx_mac80211: Using hardware based encryption for keyidx: 0, mac: 00:12:17:d4:95:e1
bcm43xx_mac80211: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
bcm43xx_mac80211: Removing Interface type 2
bcm43xx_mac80211: Wireless interface stopped
bcm43xx_mac80211: DMA-32 0x0200 (RX) max used slots: 3/64
bcm43xx_mac80211: DMA-32 0x02A0 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0280 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0260 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0240 (TX) max used slots: 0/128
bcm43xx_mac80211: DMA-32 0x0220 (TX) max used slots: 6/128
bcm43xx_mac80211: DMA-32 0x0200 (TX) max used slots: 0/128
bcm43xx_mac80211: Radio turned off
bcm43xx_mac80211: Radio turned off
BUG: unable to handle kernel paging request at virtual address 00100104
 printing eip:
c89680c7
*pde = 00000000
Oops: 0002 [#1]
PREEMPT 
Modules linked in: bcm43xx_mac80211 aes af_packet apm savage drm parport_pc lp parport arc4 ecb blkcipher rc80211_simple tsdev ssb mac80211 psmouse serio_raw cfg80211 uhci_hcd usbcore snd_ymfpci gameport snd_ac97_codec ac97_bus intel_agp agpgart donauboe irda crc_ccitt snd_pcm_oss pcspkr snd_mixer_oss snd_pcm snd_opl3_lib snd_timer snd_hwdep snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore evdev i2c_piix4 i2c_core
CPU:    0
EIP:    0060:[<c89680c7>]    Not tainted VLI
EFLAGS: 00210296   (2.6.21-rc1-bwldev #4)
EIP is at cfg80211_netdev_notifier_call+0xa7/0xe0 [cfg80211]
eax: c1e6d388   ebx: c5a0801c   ecx: 00100100   edx: 00200200
esi: c1e6d000   edi: c1e6d000   ebp: 00000006   esp: c22b1d0c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process wpa_supplicant (pid: 7489, ti=c22b1000 task=c6038070 task.ti=c22b1000)
Stack: c896c1b4 c896c1b4 c8b2cb20 c1e6d000 c01255a5 c1e6d000 0000710b 0000710b 
       c22b1d44 c029d476 c496cb20 c02a40a0 c02afba7 c1124e54 c4c90964 c5786164 
       c1124e00 00000025 c22b1f40 c74c1200 c02a4057 00000000 c1124e00 00000025 
Call Trace:
 [<c01255a5>] notifier_call_chain+0x25/0x40
 [<c029d476>] netdev_run_todo+0x196/0x280
 [<c02a40a0>] rtnetlink_rcv_msg+0x0/0x240
 [<c02afba7>] netlink_run_queue+0xe7/0x120
 [<c02a4057>] rtnetlink_rcv+0x37/0x50
 [<c02b00d2>] netlink_data_ready+0x12/0x50
 [<c02aec91>] netlink_sendskb+0x21/0x40
 [<c02affd6>] netlink_sendmsg+0x1d6/0x2c0
 [<c029193f>] sock_sendmsg+0xbf/0xf0
 [<c012bec0>] autoremove_wake_function+0x0/0x50
 [<c012bec0>] autoremove_wake_function+0x0/0x50
 [<c01679dd>] core_sys_select+0x24d/0x2f0
 [<c0291d1f>] sys_sendto+0x12f/0x180
 [<c029241f>] move_addr_to_user+0x5f/0x70
 [<c0292785>] sys_recvfrom+0x125/0x180
 [<c0141547>] __alloc_pages+0x57/0x2f0
 [<c013f1e8>] filemap_nopage+0x2a8/0x360
 [<c0291da3>] sys_send+0x33/0x40
 [<c0292cd2>] sys_socketcall+0x142/0x280
 [<c0104080>] sysenter_past_esp+0x5d/0x81
 [<c0340000>] wireless_seq_show+0x0/0x190
 =======================
Code: 5e 5f c3 83 eb 24 89 d8 e8 c7 a7 9d f7 8d 86 38 02 00 00 ba 1c a8 96 c8 e8 57 ca 82 f7 8b 86 bc 00 00 00 83 c0 3c 8b 50 04 8b 08 <89> 51 04 89 0a c7 40 04 00 02 20 00 c7 00 00 01 10 00 89 d8 e8 
EIP: [<c89680c7>] cfg80211_netdev_notifier_call+0xa7/0xe0 [cfg80211] SS:ESP 0068:c22b1d0c

-- 
Greetings Michael.
