Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astro.systems.pipex.net ([62.241.163.6]:56526 "EHLO
	astro.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175AbXHPPud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 11:50:33 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
Date: Thu, 16 Aug 2007 16:25:43 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
References: <200708082324.17186.linux@baker-net.org.uk> <200708152249.09948.linux@baker-net.org.uk> <1187272082.5141.53.camel@johannes.berg>
In-Reply-To: <1187272082.5141.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708161625.44057.linux@baker-net.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 16 August 2007 14:48, Johannes Berg wrote:
> On Wed, 2007-08-15 at 22:49 +0100, Adam Baker wrote:
> > Aug 15 22:28:20 gromit kernel: [  286.592323] wlan1: Creating new IBSS
> > network, BSSID 2a:3f:11:b4:62:c9 Aug 15 22:28:20 gromit kernel: [ 
> > 286.593514] HW CONFIG: channel=11 freq=2462 phymode=3 Aug 15 22:28:20
> > gromit kernel: [  286.607980] wlan1: Configured IBSS beacon template
> > based on scan results Aug 15 22:28:40 gromit kernel: [  306.008510]
> > wmaster0: Adding new IBSS station 00:19:4f:9e:b8:ba (dev=wlan1) Aug 15
> > 22:28:40 gromit kernel: [  306.008693] wmaster0: Added STA
> > 00:19:4f:9e:b8:ba Aug 15 22:28:40 gromit kernel: [  306.008742] wlan1:
> > STA 00:19:4f:9e:b8:ba aid 0 enters power save mode Aug 15 22:28:42 gromit
> > kernel: [  308.022518] wlan1: STA 00:19:4f:9e:b8:ba aid 0 exits power
> > save mode Aug 15 22:28:44 gromit kernel: [  309.966798] wlan1: STA
> > 00:19:4f:9e:b8:ba aid 0 enters power save mode
>
> So that MAC address, which device is that? Is that some other device or
> somehow your own?
>

The address 00:19:4F:9E:B8:BA is the remote device I was scanning / connecting
from. The RT73 device is 00:0E:2E:C5:BE:70

I'm starting to think that scanning from the remote device always causes a crash
if done just after the iwconfig essid and never does if left for a while first
(~ 1 minute). Scanning on the local machine I've usually done when the scan and
subsequent connect from the remote machine has succeeded. I'm not yet sure if
that is a necessary condition for the crash.

I've added some printk's as you suggested, the log is attached. I haven't yet
managed to capture this on the serial port so I can't yet guarantee that there
aren't any calls that didn't get logged just as it crashed - I'll keep trying.

Aug 16 15:52:41 gromit kernel: [  581.431014] usb 2-4: new high speed USB device using ehci_hcd and address 4
Aug 16 15:52:42 gromit kernel: [  581.703888] usb 2-4: configuration #1 chosen from 1 choice
Aug 16 15:52:42 gromit kernel: [  582.349463] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
Aug 16 15:52:42 gromit kernel: [  582.349473] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
Aug 16 15:52:42 gromit kernel: [  582.349476] phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET BG: 0x0000
Aug 16 15:52:42 gromit kernel: [  582.352058] phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
Aug 16 15:52:42 gromit kernel: [  582.422603] wmaster0: Selected rate control algorithm 'simple'
Aug 16 15:52:43 gromit kernel: [  582.554797] usbcore: registered new interface driver rt73usb
Aug 16 15:52:43 gromit kernel: [  582.600998] usbcore: registered new interface driver rt2500usb
Aug 16 15:53:27 gromit kernel: [  626.903878] phy0 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt73.bin'.
Aug 16 15:53:27 gromit kernel: [  626.940512] phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 1.7.
Aug 16 15:53:27 gromit kernel: [  626.988778] phy0 -> rt73usb_init_bbp: Debug - Start initialization from EEPROM...
Aug 16 15:53:27 gromit kernel: [  626.988790] phy0 -> rt73usb_init_bbp: Debug - ...End initialization from EEPROM.
Aug 16 15:53:27 gromit kernel: [  626.995372] HW CONFIG: channel=1 freq=2412 phymode=3
Aug 16 15:53:27 gromit kernel: [  627.023029] Entering ieee80211_master_start_xmit()
Aug 16 15:53:27 gromit kernel: [  627.023267] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:27 gromit kernel: [  627.023270] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:27 gromit kernel: [  627.026840] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:27 gromit kernel: [  627.027895] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:27 gromit kernel: [  627.029396] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:27 gromit kernel: [  627.037980] HW CONFIG: channel=11 freq=2462 phymode=3
Aug 16 15:53:27 gromit kernel: [  627.076827] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 - CWmin: 4, CWmax: 10, Aifs: 2.
Aug 16 15:53:27 gromit kernel: [  627.076844] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 - CWmin: 4, CWmax: 10, Aifs: 2.
Aug 16 15:53:27 gromit kernel: [  627.076848] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 - CWmin: 4, CWmax: 10, Aifs: 2.
Aug 16 15:53:27 gromit kernel: [  627.076852] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 - CWmin: 4, CWmax: 10, Aifs: 2.
Aug 16 15:53:27 gromit kernel: [  627.076856] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 4 - CWmin: 4, CWmax: 10, Aifs: 2.
Aug 16 15:53:27 gromit kernel: [  627.076859] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 - CWmin: 5, CWmax: 10, Aifs: 2.
Aug 16 15:53:27 gromit kernel: [  627.077484] wlan1: Trigger new scan to find an IBSS to join
Aug 16 15:53:27 gromit kernel: [  627.105311] HW CONFIG: channel=1 freq=2412 phymode=3
Aug 16 15:53:27 gromit kernel: [  627.161311] Entering ieee80211_master_start_xmit()
Aug 16 15:53:27 gromit kernel: [  627.161331] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:27 gromit kernel: [  627.161335] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:27 gromit kernel: [  627.161366] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:27 gromit kernel: [  627.161506] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:27 gromit kernel: [  627.189279] HW CONFIG: channel=2 freq=2417 phymode=3
Aug 16 15:53:27 gromit kernel: [  627.245279] Entering ieee80211_master_start_xmit()
Aug 16 15:53:27 gromit kernel: [  627.245298] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:27 gromit kernel: [  627.245302] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:27 gromit kernel: [  627.245330] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:27 gromit kernel: [  627.245495] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:27 gromit kernel: [  627.273380] HW CONFIG: channel=3 freq=2422 phymode=3
Aug 16 15:53:27 gromit kernel: [  627.329247] Entering ieee80211_master_start_xmit()
Aug 16 15:53:27 gromit kernel: [  627.329266] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:27 gromit kernel: [  627.329269] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:27 gromit kernel: [  627.329291] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:27 gromit kernel: [  627.329477] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:27 gromit kernel: [  627.357272] HW CONFIG: channel=4 freq=2427 phymode=3
Aug 16 15:53:27 gromit kernel: [  627.413290] Entering ieee80211_master_start_xmit()
Aug 16 15:53:27 gromit kernel: [  627.413309] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:27 gromit kernel: [  627.413313] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:27 gromit kernel: [  627.413344] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:27 gromit kernel: [  627.413463] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:27 gromit kernel: [  627.441237] HW CONFIG: channel=5 freq=2432 phymode=3
Aug 16 15:53:28 gromit kernel: [  627.497205] Entering ieee80211_master_start_xmit()
Aug 16 15:53:28 gromit kernel: [  627.497225] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:28 gromit kernel: [  627.497228] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:28 gromit kernel: [  627.497260] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:28 gromit kernel: [  627.497453] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:28 gromit kernel: [  627.525220] HW CONFIG: channel=6 freq=2437 phymode=3
Aug 16 15:53:28 gromit kernel: [  627.581347] Entering ieee80211_master_start_xmit()
Aug 16 15:53:28 gromit kernel: [  627.581367] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:28 gromit kernel: [  627.581371] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:28 gromit kernel: [  627.581402] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:28 gromit kernel: [  627.581559] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:28 gromit kernel: [  627.609191] HW CONFIG: channel=7 freq=2442 phymode=3
Aug 16 15:53:28 gromit kernel: [  627.665148] Entering ieee80211_master_start_xmit()
Aug 16 15:53:28 gromit kernel: [  627.665168] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:28 gromit kernel: [  627.665171] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:28 gromit kernel: [  627.665201] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:28 gromit kernel: [  627.665288] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:28 gromit kernel: [  627.693180] HW CONFIG: channel=8 freq=2447 phymode=3
Aug 16 15:53:28 gromit kernel: [  627.749882] Entering ieee80211_master_start_xmit()
Aug 16 15:53:28 gromit kernel: [  627.749901] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:28 gromit kernel: [  627.749904] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:28 gromit kernel: [  627.749935] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:28 gromit kernel: [  627.750030] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:28 gromit kernel: [  627.777137] HW CONFIG: channel=9 freq=2452 phymode=3
Aug 16 15:53:28 gromit kernel: [  627.833177] Entering ieee80211_master_start_xmit()
Aug 16 15:53:28 gromit kernel: [  627.833196] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:28 gromit kernel: [  627.833200] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:28 gromit kernel: [  627.833225] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:28 gromit kernel: [  627.833388] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:28 gromit kernel: [  627.862875] HW CONFIG: channel=10 freq=2457 phymode=3
Aug 16 15:53:28 gromit kernel: [  627.917068] Entering ieee80211_master_start_xmit()
Aug 16 15:53:28 gromit kernel: [  627.917087] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:28 gromit kernel: [  627.917090] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:28 gromit kernel: [  627.917110] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:28 gromit kernel: [  627.917245] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:28 gromit kernel: [  627.945063] HW CONFIG: channel=11 freq=2462 phymode=3
Aug 16 15:53:28 gromit kernel: [  628.001044] Entering ieee80211_master_start_xmit()
Aug 16 15:53:28 gromit kernel: [  628.001062] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:28 gromit kernel: [  628.001066] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:28 gromit kernel: [  628.001089] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:28 gromit kernel: [  628.001231] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:28 gromit kernel: [  628.029049] HW CONFIG: channel=11 freq=2462 phymode=3
Aug 16 15:53:28 gromit kernel: [  628.045759] Entering ieee80211_master_start_xmit()
Aug 16 15:53:28 gromit kernel: [  628.045777] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:28 gromit kernel: [  628.045781] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:28 gromit kernel: [  628.045802] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:28 gromit kernel: [  628.045965] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:28 gromit kernel: [  628.052109] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:28 gromit kernel: [  628.154451] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:28 gromit kernel: [  628.256806] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:28 gromit kernel: [  628.359160] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  628.461518] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  628.563875] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  628.608934] Entering ieee80211_master_start_xmit()
Aug 16 15:53:29 gromit kernel: [  628.608953] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:29 gromit kernel: [  628.608957] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:29 gromit kernel: [  628.608990] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:29 gromit kernel: [  628.609124] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:29 gromit kernel: [  628.666236] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  628.768591] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  628.870955] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  628.973308] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  629.075787] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  629.178144] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  629.280498] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:29 gromit kernel: [  629.382857] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:30 gromit kernel: [  629.485211] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:30 gromit kernel: [  629.587568] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:30 gromit kernel: [  629.689927] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:30 gromit kernel: [  629.792284] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:30 gromit kernel: [  629.894780] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:30 gromit kernel: [  629.997120] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:30 gromit kernel: [  630.045969] wlan1: Trigger new scan to find an IBSS to join
Aug 16 15:53:30 gromit kernel: [  630.072511] HW CONFIG: channel=1 freq=2412 phymode=3
Aug 16 15:53:30 gromit kernel: [  630.128416] Entering ieee80211_master_start_xmit()
Aug 16 15:53:30 gromit kernel: [  630.128436] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:30 gromit kernel: [  630.128440] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:30 gromit kernel: [  630.128468] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:30 gromit kernel: [  630.128599] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:30 gromit kernel: [  630.156393] HW CONFIG: channel=2 freq=2417 phymode=3
Aug 16 15:53:30 gromit kernel: [  630.212387] Entering ieee80211_master_start_xmit()
Aug 16 15:53:30 gromit kernel: [  630.212406] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:30 gromit kernel: [  630.212409] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:30 gromit kernel: [  630.212435] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:30 gromit kernel: [  630.212585] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:30 gromit kernel: [  630.240427] HW CONFIG: channel=3 freq=2422 phymode=3
Aug 16 15:53:30 gromit kernel: [  630.296364] Entering ieee80211_master_start_xmit()
Aug 16 15:53:30 gromit kernel: [  630.296384] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:30 gromit kernel: [  630.296387] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:30 gromit kernel: [  630.296420] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:30 gromit kernel: [  630.296700] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:30 gromit kernel: [  630.324343] HW CONFIG: channel=4 freq=2427 phymode=3
Aug 16 15:53:30 gromit kernel: [  630.380435] Entering ieee80211_master_start_xmit()
Aug 16 15:53:30 gromit kernel: [  630.380456] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:30 gromit kernel: [  630.380459] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:30 gromit kernel: [  630.380491] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:30 gromit kernel: [  630.380681] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:30 gromit kernel: [  630.408318] HW CONFIG: channel=5 freq=2432 phymode=3
Aug 16 15:53:31 gromit kernel: [  630.464331] Entering ieee80211_master_start_xmit()
Aug 16 15:53:31 gromit kernel: [  630.464352] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:31 gromit kernel: [  630.464355] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:31 gromit kernel: [  630.464389] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:31 gromit kernel: [  630.464544] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:31 gromit kernel: [  630.492312] HW CONFIG: channel=6 freq=2437 phymode=3
Aug 16 15:53:31 gromit kernel: [  630.549911] Entering ieee80211_master_start_xmit()
Aug 16 15:53:31 gromit kernel: [  630.549933] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:31 gromit kernel: [  630.549936] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:31 gromit kernel: [  630.549968] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:31 gromit kernel: [  630.550151] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:31 gromit kernel: [  630.576299] HW CONFIG: channel=7 freq=2442 phymode=3
Aug 16 15:53:31 gromit kernel: [  630.611254] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:31 gromit kernel: [  630.634793] Entering ieee80211_master_start_xmit()
Aug 16 15:53:31 gromit kernel: [  630.634814] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:31 gromit kernel: [  630.634818] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:31 gromit kernel: [  630.634850] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:31 gromit kernel: [  630.635016] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:31 gromit kernel: [  630.660245] HW CONFIG: channel=8 freq=2447 phymode=3
Aug 16 15:53:31 gromit kernel: [  630.716236] Entering ieee80211_master_start_xmit()
Aug 16 15:53:31 gromit kernel: [  630.716255] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:31 gromit kernel: [  630.716259] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:31 gromit kernel: [  630.716280] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:31 gromit kernel: [  630.716364] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:31 gromit kernel: [  630.744224] HW CONFIG: channel=9 freq=2452 phymode=3
Aug 16 15:53:31 gromit kernel: [  630.800210] Entering ieee80211_master_start_xmit()
Aug 16 15:53:31 gromit kernel: [  630.800229] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:31 gromit kernel: [  630.800233] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:31 gromit kernel: [  630.800256] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:31 gromit kernel: [  630.800348] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:31 gromit kernel: [  630.828208] HW CONFIG: channel=10 freq=2457 phymode=3
Aug 16 15:53:31 gromit kernel: [  630.884188] Entering ieee80211_master_start_xmit()
Aug 16 15:53:31 gromit kernel: [  630.884207] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:31 gromit kernel: [  630.884211] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:31 gromit kernel: [  630.884234] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:31 gromit kernel: [  630.884337] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:31 gromit kernel: [  630.912481] HW CONFIG: channel=11 freq=2462 phymode=3
Aug 16 15:53:31 gromit kernel: [  630.968163] Entering ieee80211_master_start_xmit()
Aug 16 15:53:31 gromit kernel: [  630.968181] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:31 gromit kernel: [  630.968185] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:31 gromit kernel: [  630.968210] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:31 gromit kernel: [  630.968327] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:31 gromit kernel: [  630.996158] HW CONFIG: channel=11 freq=2462 phymode=3
Aug 16 15:53:31 gromit kernel: [  631.020812] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:31 gromit kernel: [  631.123167] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:31 gromit kernel: [  631.225524] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:31 gromit kernel: [  631.327881] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:31 gromit kernel: [  631.430238] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  631.532598] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  631.634950] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  631.737308] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  631.839666] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  631.942147] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  632.044528] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  632.146860] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  632.249216] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:32 gromit kernel: [  632.351573] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:33 gromit kernel: [  632.453932] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:33 gromit kernel: [  632.556288] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:33 gromit kernel: [  632.607696] Entering ieee80211_master_start_xmit()
Aug 16 15:53:33 gromit kernel: [  632.607715] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:33 gromit kernel: [  632.607719] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:33 gromit kernel: [  632.607753] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:33 gromit kernel: [  632.607908] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:33 gromit kernel: [  632.658643] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:33 gromit kernel: [  632.760999] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:33 gromit kernel: [  632.863483] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:33 gromit kernel: [  632.965859] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:33 gromit kernel: [  633.008852] wlan1: Trigger new scan to find an IBSS to join
Aug 16 15:53:33 gromit kernel: [  633.035535] HW CONFIG: channel=1 freq=2412 phymode=3
Aug 16 15:53:33 gromit kernel: [  633.091529] Entering ieee80211_master_start_xmit()
Aug 16 15:53:33 gromit kernel: [  633.091549] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:33 gromit kernel: [  633.091552] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:33 gromit kernel: [  633.091582] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:33 gromit kernel: [  633.091689] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:33 gromit kernel: [  633.119507] HW CONFIG: channel=2 freq=2417 phymode=3
Aug 16 15:53:33 gromit kernel: [  633.175537] Entering ieee80211_master_start_xmit()
Aug 16 15:53:33 gromit kernel: [  633.175558] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:33 gromit kernel: [  633.175561] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:33 gromit kernel: [  633.175592] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:33 gromit kernel: [  633.175674] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:33 gromit kernel: [  633.203484] HW CONFIG: channel=3 freq=2422 phymode=3
Aug 16 15:53:33 gromit kernel: [  633.259483] Entering ieee80211_master_start_xmit()
Aug 16 15:53:33 gromit kernel: [  633.259502] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:33 gromit kernel: [  633.259506] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:33 gromit kernel: [  633.259537] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:33 gromit kernel: [  633.259667] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:33 gromit kernel: [  633.287461] HW CONFIG: channel=4 freq=2427 phymode=3
Aug 16 15:53:33 gromit kernel: [  633.343467] Entering ieee80211_master_start_xmit()
Aug 16 15:53:33 gromit kernel: [  633.343488] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:33 gromit kernel: [  633.343491] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:33 gromit kernel: [  633.343523] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:33 gromit kernel: [  633.343649] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:33 gromit kernel: [  633.371433] HW CONFIG: channel=5 freq=2432 phymode=3
Aug 16 15:53:33 gromit kernel: [  633.428937] Entering ieee80211_master_start_xmit()
Aug 16 15:53:33 gromit kernel: [  633.428958] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:33 gromit kernel: [  633.428961] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:33 gromit kernel: [  633.428995] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:33 gromit kernel: [  633.429137] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:34 gromit kernel: [  633.455408] HW CONFIG: channel=6 freq=2437 phymode=3
Aug 16 15:53:34 gromit kernel: [  633.513686] Entering ieee80211_master_start_xmit()
Aug 16 15:53:34 gromit kernel: [  633.513707] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:34 gromit kernel: [  633.513711] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:34 gromit kernel: [  633.513744] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:34 gromit kernel: [  633.513868] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:34 gromit kernel: [  633.539746] HW CONFIG: channel=7 freq=2442 phymode=3
Aug 16 15:53:34 gromit kernel: [  633.595377] Entering ieee80211_master_start_xmit()
Aug 16 15:53:34 gromit kernel: [  633.595396] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:34 gromit kernel: [  633.595399] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:34 gromit kernel: [  633.595426] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:34 gromit kernel: [  633.595599] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:34 gromit kernel: [  633.623363] HW CONFIG: channel=8 freq=2447 phymode=3
Aug 16 15:53:34 gromit kernel: [  633.679686] Entering ieee80211_master_start_xmit()
Aug 16 15:53:34 gromit kernel: [  633.679706] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:34 gromit kernel: [  633.679709] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:34 gromit kernel: [  633.679738] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:34 gromit kernel: [  633.679838] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:34 gromit kernel: [  633.707347] HW CONFIG: channel=9 freq=2452 phymode=3
Aug 16 15:53:34 gromit kernel: [  633.763329] Entering ieee80211_master_start_xmit()
Aug 16 15:53:34 gromit kernel: [  633.763346] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:34 gromit kernel: [  633.763350] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:34 gromit kernel: [  633.763380] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:34 gromit kernel: [  633.763573] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:34 gromit kernel: [  633.791325] HW CONFIG: channel=10 freq=2457 phymode=3
Aug 16 15:53:34 gromit kernel: [  633.847301] Entering ieee80211_master_start_xmit()
Aug 16 15:53:34 gromit kernel: [  633.847320] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:34 gromit kernel: [  633.847323] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:34 gromit kernel: [  633.847349] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:34 gromit kernel: [  633.847429] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:34 gromit kernel: [  633.875313] HW CONFIG: channel=11 freq=2462 phymode=3
Aug 16 15:53:34 gromit kernel: [  633.931370] Entering ieee80211_master_start_xmit()
Aug 16 15:53:34 gromit kernel: [  633.931390] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:34 gromit kernel: [  633.931393] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:34 gromit kernel: [  633.931421] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:34 gromit kernel: [  633.931545] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:34 gromit kernel: [  633.959384] HW CONFIG: channel=11 freq=2462 phymode=3
Aug 16 15:53:34 gromit kernel: [  633.972942] Entering ieee80211_master_start_xmit()
Aug 16 15:53:34 gromit kernel: [  633.972956] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
Aug 16 15:53:34 gromit kernel: [  633.972960] Leaving ieee80211_tx_h_multicast_ps_buf
Aug 16 15:53:34 gromit kernel: [  633.972980] Leaving ieee80211_master_start_xmit() ret=0
Aug 16 15:53:34 gromit kernel: [  633.973155] phy0 -> rt2x00usb_interrupt_txdone: Debug - status 0
Aug 16 15:53:34 gromit kernel: [  633.989533] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:34 gromit kernel: [  634.091886] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
Aug 16 15:53:34 gromit kernel: [  634.194244] phy0 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
