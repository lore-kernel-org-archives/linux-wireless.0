Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:18135 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753887AbYLIMzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 07:55:04 -0500
Date: Tue, 9 Dec 2008 13:54:56 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: Sujith <m.sujith@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni.Malinen@Atheros.com
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
Message-ID: <20081209135456.68778e51@loke.fish.not> (sfid-20081209_135524_315350_87464E2E)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Confirmation from one userland of ath9k. This patch on top of latest
wireless-testing (pulled an hour ago) allows me to scan (root or normal
user) without loss of connectivity or Kernel panic in "Channel Width:
Auto 20/40 MHz" mode. Thank you devs.

Boot finished at 13:25, scan with Wicd Manager at 13:30:

13:24:46 : ath0: authenticate with AP 00:1b:11:60:7a:3d
13:24:46 : ath0: authenticated
13:24:46 : ath0: associate with AP 00:1b:11:60:7a:3d
13:24:46 : ath0: RX AssocResp from 00:1b:11:60:7a:3d (capab=0x431 status=0 aid=4)
13:24:46 : ath0: associated
13:24:46 : ath9k: Choosing rate table for mode: 10
13:24:46 : ath9k: Configure tx [queue/halq] [2/1],  aifs: 3, cw_min: 15, cw_max: 1023, txop: 0
13:24:46 : ath9k: Configure tx [queue/halq] [3/0],  aifs: 7, cw_min: 15, cw_max: 1023, txop: 0
13:24:46 : ath9k: Configure tx [queue/halq] [1/2],  aifs: 2, cw_min: 7, cw_max: 15, txop: 94
13:24:46 : ath9k: Configure tx [queue/halq] [0/3],  aifs: 2, cw_min: 3, cw_max: 7, txop: 47
13:24:46 : ath9k: Set channel: 2412 MHz
13:24:46 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 1
13:24:46 : ath9k: tx chmask: 5, rx chmask: 5
13:24:46 : ath9k: BSS Changed PREAMBLE 1
13:24:46 : ath9k: BSS Changed ASSOC 1
13:24:46 : ath9k: Bss Info ASSOC 4, bssid: 00:1b:11:60:7a:3d
13:24:46 : ADDRCONF(NETDEV_CHANGE): ath0: link becomes ready
13:24:46 : ath9k: Set HW RX filter: 0x0
13:24:46 : ath9k: Set HW RX filter: 0x0
13:24:46 : Clocksource tsc unstable (delta = -87796076 ns)
13:24:54 : ath9k: Set HW RX filter: 0x0
13:24:54 : ath9k: Set HW RX filter: 0x0
13:24:56 : ath0: no IPv6 routers present
13:25:07 : ACPI: EC: missing confirmations, switch off interrupt mode.
13:30:15 : ath9k: Set HW RX filter: 0x0
13:30:15 : ath9k: Set HW RX filter: 0x10
13:30:15 : ath9k: Set channel: 2412 MHz
13:30:15 : ath9k: (2412 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 0
13:30:15 : ath9k: tx chmask: 1, rx chmask: 1
13:30:15 : ath9k: Set channel: 2417 MHz
13:30:15 : ath9k: (2412 MHz) -> (2417 MHz), cflags:300e0, chanwidth: 0
13:30:15 : ath9k: tx chmask: 1, rx chmask: 1
13:30:15 : ath9k: Set channel: 2422 MHz
13:30:15 : ath9k: (2417 MHz) -> (2422 MHz), cflags:300e0, chanwidth: 0
13:30:15 : ath9k: tx chmask: 1, rx chmask: 1
13:30:15 : ath9k: Set channel: 2427 MHz
13:30:15 : ath9k: (2422 MHz) -> (2427 MHz), cflags:300e0, chanwidth: 0
13:30:15 : ath9k: tx chmask: 1, rx chmask: 1
13:30:16 : ath9k: Set channel: 2432 MHz
13:30:16 : ath9k: (2427 MHz) -> (2432 MHz), cflags:700e0, chanwidth: 0
13:30:16 : ath9k: tx chmask: 1, rx chmask: 1
13:30:16 : ath9k: Set channel: 2437 MHz
13:30:16 : ath9k: (2432 MHz) -> (2437 MHz), cflags:700e0, chanwidth: 0
13:30:16 : ath9k: tx chmask: 1, rx chmask: 1
13:30:16 : ath9k: Set channel: 2442 MHz
13:30:16 : ath9k: (2437 MHz) -> (2442 MHz), cflags:700e0, chanwidth: 0
13:30:16 : ath9k: tx chmask: 1, rx chmask: 1
13:30:16 : ath9k: Set channel: 2447 MHz
13:30:16 : ath9k: (2442 MHz) -> (2447 MHz), cflags:500e0, chanwidth: 0
13:30:16 : ath9k: tx chmask: 1, rx chmask: 1
13:30:16 : ath9k: Set channel: 2452 MHz
13:30:16 : ath9k: (2447 MHz) -> (2452 MHz), cflags:500e0, chanwidth: 0
13:30:16 : ath9k: tx chmask: 1, rx chmask: 1
13:30:16 : ath9k: Set channel: 2457 MHz
13:30:16 : ath9k: (2452 MHz) -> (2457 MHz), cflags:500e0, chanwidth: 0
13:30:16 : ath9k: tx chmask: 1, rx chmask: 1
13:30:16 : ath9k: Set channel: 2462 MHz
13:30:16 : ath9k: (2457 MHz) -> (2462 MHz), cflags:500e0, chanwidth: 0
13:30:16 : ath9k: tx chmask: 1, rx chmask: 1
13:30:16 : ath9k: Set channel: 2412 MHz
13:30:16 : ath9k: (2462 MHz) -> (2412 MHz), cflags:300e0, chanwidth: 1
13:30:16 : ath9k: tx chmask: 5, rx chmask: 5
13:30:16 : ath9k: Set HW RX filter: 0x0

/Mats
