Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38381 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1DNLTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2011 07:19:40 -0400
Received: by qyg14 with SMTP id 14so964945qyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 04:19:39 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1302724606-10190-1-git-send-email-nbd@openwrt.org>
References: <1302724606-10190-1-git-send-email-nbd@openwrt.org>
Date: Thu, 14 Apr 2011 13:19:39 +0200
Message-ID: <BANLkTinyONrZ2+wVRL_XiiofjGnvbSFQmg@mail.gmail.com>
Subject: Re: [PATCH 1/5] ath5k: disable 5 GHz support if a 2.4 GHz radio is detected
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 13, 2011 at 9:56 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On a dual-radio dual-band AR5312 device, the calibration data is shared
> between the 5 GHz and the 2.4 GHz radio/MAC.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---

Tested all 5 patches against "freaky" linux-next (next-20110414).

Feel free to add:

     Tested-by: Sedat Dilek <sedat.dilekłgmail.com>

- Sedat -

P.S.: Attach dmesg and lspci outputs

# dmesg | egrep -i 'ath|80211|wlan|crda'
[    4.784132] cfg80211: Calling CRDA to update world regulatory domain
[    5.004594] ath5k 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11
(level, low) -> IRQ 11
[    5.004709] ath5k 0000:02:02.0: registered as 'phy0'
[    5.294992] ath: EEPROM regdomain: 0x61
[    5.294996] ath: EEPROM indicates we should expect a direct regpair map
[    5.295002] ath: Country alpha2 being used: 00
[    5.295004] ath: Regpair used: 0x61
[    5.506881] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[    5.507770] Registered led device: ath5k-phy0::rx
[    5.507800] Registered led device: ath5k-phy0::tx
[    5.507813] ath5k phy0: Atheros AR5212 chip found (MAC: 0x56, PHY: 0x41)
[    5.507857] ath5k phy0: RF5111 5GHz radio found (0x17)
[    5.507893] ath5k phy0: RF2111 2GHz radio found (0x23)
[    8.297097] cfg80211: World regulatory domain updated:
[    8.297149] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    8.299903] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    8.299950] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    8.299997] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[    8.300057] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[    8.300104] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   12.303413] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   17.690110] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
[   17.691907] wlan0: authenticated
[   17.691974] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
[   17.698281] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411
status=0 aid=1)
[   17.698293] wlan0: associated
[   17.700380] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   28.424062] wlan0: no IPv6 routers present

# lspci -nnvv -s 02:02.0
02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
802.11abg NIC [168c:1014] (rev 01)
        Subsystem: Phillips Components Device [17ab:8331]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at c0210000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
        Kernel driver in use: ath5k

- EOT -
