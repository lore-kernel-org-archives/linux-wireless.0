Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:58630 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3CaBtb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 21:49:31 -0400
Received: by mail-la0-f44.google.com with SMTP id eb20so1341581lab.3
        for <linux-wireless@vger.kernel.org>; Sat, 30 Mar 2013 18:49:29 -0700 (PDT)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 30 Mar 2013 18:49:08 -0700
Message-ID: <CAObL_7G8i9fuvoVMu2D1P7vk9DE_=EwJcp3uDPiLPC7YfuHROg@mail.gmail.com> (sfid-20130331_034950_361359_E9636B0A)
Subject: Mysterious (?) VHT/HT warning on 3.8.2
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When my system (using an Intel 6300) associates to the AP here, it says:

wlan0: authenticate with [MAC]
wlan0: capabilities/regulatory prevented using AP HT/VHT
configuration, downgraded

Despite this warning, HT seems to work.  I'm getting >7 MB/s over ssh,
which isn't terrible.

$ sudo iw wlan0 link
Connected to [MAC] (on wlan0)
	SSID: [omitted]
	freq: 2432
	RX: 421276864 bytes (301704 packets)
	TX: 5148186 bytes (46101 packets)
	signal: -47 dBm
	tx bitrate: 270.0 MBit/s MCS 14 40Mhz short GI

	bss flags:	short-preamble short-slot-time
	dtim period:	2
	beacon int:	100

That's a nice high MCS rate at 40MHz.

$ sudo iw dev wlan0 scan dump
BSS [MAC] (on wlan0) -- associated
	TSF: 126363129751 usec (1d, 11:06:03)
	freq: 2432
	beacon interval: 100
	capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
	signal: -39.00 dBm
	last seen: 30251 ms ago
	Information elements from Probe Response frame:
	SSID: [omitted]
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0
	DS Parameter set: channel 5
	RSN:	 * Version: 1
		 * Group cipher: CCMP
		 * Pairwise ciphers: CCMP
		 * Authentication suites: PSK
		 * Capabilities: (0x0000)
	ERP: <no flags>
	Extended supported rates: 24.0 36.0 48.0 54.0
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
	HT capabilities:
		Capabilities: 0x11ce
			HT20/HT40
			SM Power Save disabled
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT RX MCS rate indexes supported: 0-15
		HT TX MCS rate indexes are undefined
	HT operation:
		 * primary channel: 5
		 * secondary channel offset: below
		 * STA channel width: any
		 * RIFS: 0
		 * HT protection: non-HT mixed
		 * non-GF present: 0
		 * OBSS non-GF present: 1
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * AP setup locked: 0x01
		 * Response Type: 3 (AP)
		 * UUID: 00000000-0000-1000-0000-74440171ae50
		 * Manufacturer: Netgear
		 * Model: WNDR3800
		 * Model Number: V1
		 * Serial Number: none
		 * Primary Device Type: 6-0050f204-1
		 * Device name: WNDR3800(Wireless AP)
		 * Config methods: Ethernet, Label, PBC
		 * RF Bands: 0x3

What's happening here?
