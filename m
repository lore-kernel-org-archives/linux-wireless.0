Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:44644 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab0K3CTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 21:19:14 -0500
Date: Mon, 29 Nov 2010 22:19:11 -0400
From: Giacomo Comes <comes@naic.edu>
To: Dave Kilroy <kilroyd@gmail.com>
Cc: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs module and WPA not working
Message-ID: <20101130021911.GA18971@monopoli.naic.edu>
References: <20101122024208.GA13377@monopoli.naic.edu> <AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com> <20101125014511.GA1683@monopoli.naic.edu> <AANLkTi=nkayyyzECi6MO87ZO-CUpZeNP007_hMp8LiPV@mail.gmail.com> <20101126040742.GA5238@monopoli.naic.edu> <AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTim=P+QejCObCH1=5cPBDR6BpEXxuqHGZj3JBKbE@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 28, 2010 at 04:10:30PM +0000, Dave Kilroy wrote:
> 
> Just had a closer look at your log. wpa_supplicant is clearing keys 4
> and 5, which is why you're getting invalid arguments reported. This
> shouldn't affect driver behaviour.
> 
> After that, something seems to go wrong with scanning. Try a plain
> scan with wpa_supplicant turned off. Do you get any results?
> 
> iw dev eth1 scan
> iwlist eth1 scan
> 
> Dave.

After a reboot and without configuring the wireless interface,
iw dev eth1 scan
gives:
command failed: Network is down (-100)
and
iwlist eth1 scan
gives:
eth1      Interface doesn't support scanning : Network is down

I was trying to associate the wireless card using iwconfig:
    iwconfig eth1 mode managed key <key>
    iwconfig eth1 essid <essid>
but the card does not associate with the AP.
Isn't that supposed to work or am I missing something?

Buy the way, if I configure the wireless interface with yast
using WEP (the only way I can make the truemobile
card work) then iw dev eth1 scan gives:
BSS 00:18:f8:c6:04:05 (on eth1)
        TSF: 21366823341 usec (0d, 05:56:06)
        freq: 2412
        beacon interval: 100
        capability: ESS Privacy PBCC (0x0051)
        signal: -60.00 dBm
        last seen: 88 ms ago
        SSID: ssid1
        Supported rates: 1.0* 2.0* 5.5* 11.0* 22.0
        DS Parameter set: channel 1
        ERP: NonERP_Present Use_Protection Barker_Preamble_Mode
        Extended supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0
BSS 00:13:10:aa:89:4b (on eth1)
        TSF: 12179691 usec (0d, 00:00:12)
        freq: 2437
        beacon interval: 100
        capability: ESS Privacy PBCC ShortSlotTime (0x0451)
        signal: -27.00 dBm
        last seen: 48 ms ago
        SSID: ssid2
        Supported rates: 1.0* 2.0* 5.5* 11.0* 22.0
        DS Parameter set: channel 6
        ERP: Barker_Preamble_Mode
        Extended supported rates: 6.0 9.0 12.0 18.0 24.0 36.0 48.0 54.0
        WPA:     * Version: 1
                 * Group cipher: TKIP
                 * Pairwise ciphers: TKIP
                 * Authentication suites: PSK

and iwlist eth1 scan gives:
eth1      Scan completed :
          Cell 01 - Address: 00:18:F8:C6:04:05
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=58/70  Signal level=-52 dBm
                    Encryption key:on
                    ESSID:"ssid1"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 22 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=0000000504cfa466
                    Extra: Last beacon: 248ms ago
                    IE: Unknown: 00076C696E6B737973
                    IE: Unknown: 010582848B962C
                    IE: Unknown: 030101
                    IE: Unknown: 2A0107
                    IE: Unknown: 32080C1218243048606C
          Cell 02 - Address: 00:13:10:AA:89:4B
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=70/70  Signal level=-27 dBm
                    Encryption key:on
                    ESSID:"ssid2"
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 22 Mb/s
                    Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s
                              36 Mb/s; 48 Mb/s; 54 Mb/s
                    Mode:Master
                    Extra:tsf=000000000bf9a76e
                    Extra: Last beacon: 208ms ago
                    IE: Unknown: 0005436F6D6573
                    IE: Unknown: 010582848B962C
                    IE: Unknown: 030106
                    IE: Unknown: 2A0104
                    IE: Unknown: 32080C1218243048606C
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : TKIP
                        Authentication Suites (1) : PSK

I hope this help.
Giacomo
