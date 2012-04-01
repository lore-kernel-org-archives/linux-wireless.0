Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:53717 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750834Ab2DAILJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 04:11:09 -0400
Date: Sun, 1 Apr 2012 10:04:19 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: 3945ABG fails to connect (3.4-rc1)
Message-ID: <20120401080419.GA5207@comet.dominikbrodowski.net> (sfid-20120401_101157_508072_F1FD0B93)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

Somewhere in between 3.3.0 and 3.4-rc1 my notebook fails to connect to my
local AP:

02:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection (rev 02)

Snippets from dmesg:

[    0.000000] Linux version 3.4.0-rc1 (brodo@comet) (gcc version 4.6.1 (Ubuntu/Linaro 4.6.1-9ubuntu3) ) #53 SMP PREEMPT Sun Apr 1 08:57:21 CEST 2012
...
[    0.134024] pci 0000:02:00.0: [8086:4222] type 00 class 0x028000
[    0.134082] pci 0000:02:00.0: reg 10: [mem 0xf0300000-0xf0300fff]
[    0.134502] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.134575] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
...
[    1.931734] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
[    1.933056] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[    1.987828] iwl3945 0000:02:00.0: Tunable channels: 13 802.11bg, 23 802.11a channels
[    1.989166] iwl3945 0000:02:00.0: Detected Intel Wireless WiFi Link 3945ABG
[    1.990632] iwl3945 0000:02:00.0: irq 44 for MSI/MSI-X
...
[   50.894520] iwl3945 0000:02:00.0: loaded firmware version 15.32.2.9
[   50.976024] ADDRCONF(NETDEV_UP): wlan0: link is not ready

[   59.571787] wlan0: send auth to $INSERT_MAC_HERE (try 1/3)
[   59.575172] wlan0: authenticated
[   59.576399] wlan0: associate with $INSERT_MAC_HERE (try 1/3)
[   59.603200] wlan0: RX AssocResp from $INSERT_MAC_HERE (capab=0x431 status=0 aid=1)
[   59.603209] wlan0: associated
[   59.605953] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   69.607344] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
[   69.609931] cfg80211: Calling CRDA to update world regulatory domain
[   69.612438] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
...
[   73.193729] wlan0: authenticate with $INSERT_MAC_HERE
[   73.197329] wlan0: send auth to $INSERT_MAC_HERE (try 1/3)
[   73.207590] wlan0: authenticated
[   73.208204] wlan0: associate with $INSERT_MAC_HERE (try 1/3)
[   73.262982] wlan0: RX AssocResp from $INSERT_MAC_HERE (capab=0x431 status=0 aid=1)
[   73.262988] wlan0: associated
[   83.266222] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
[   83.271478] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
[   83.273599] cfg80211: Calling CRDA to update world regulatory domain
...
[   86.844682] wlan0: authenticate with $INSERT_MAC_HERE
[   86.846846] wlan0: send auth to $INSERT_MAC_HERE (try 1/3)
[   87.048046] wlan0: send auth to $INSERT_MAC_HERE (try 2/3)
[   87.123473] wlan0: authenticated
[   87.124148] wlan0: associate with $INSERT_MAC_HERE (try 1/3)
[   87.197630] wlan0: RX AssocResp from $INSERT_MAC_HERE (capab=0x431 status=0 aid=1)
[   87.197639] wlan0: associated
[   97.207046] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
[   97.211935] cfg80211: Calling CRDA to update world regulatory domain
[   97.213532] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
...
[  100.825547] wlan0: authenticate with $INSERT_MAC_HERE
[  100.827890] wlan0: send auth to $INSERT_MAC_HERE (try 1/3)
[  100.867381] wlan0: authenticated
[  100.868915] wlan0: associate with $INSERT_MAC_HERE (try 1/3)
[  100.877573] wlan0: RX AssocResp from $INSERT_MAC_HERE (capab=0x431 status=0 aid=1)
[  100.877581] wlan0: associated
[  110.881870] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
[  110.884473] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
[  110.887192] cfg80211: Calling CRDA to update world regulatory domain
...
[  114.495433] wlan0: authenticate with $INSERT_MAC_HERE
[  114.497659] wlan0: send auth to $INSERT_MAC_HERE (try 1/3)
[  114.614665] wlan0: authenticated
[  114.615700] wlan0: associate with $INSERT_MAC_HERE (try 1/3)
[  114.621766] wlan0: RX AssocResp from $INSERT_MAC_HERE (capab=0x431 status=0 aid=1)
[  114.621776] wlan0: associated
[  116.003302] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
[  116.007075] cfg80211: Calling CRDA to update world regulatory domain
...
[ 1036.553636] wlan0: authenticate with $INSERT_MAC_HERE
[ 1036.555684] wlan0: direct probe to $INSERT_MAC_HERE (try 1/3)
[ 1036.756145] wlan0: send auth to $INSERT_MAC_HERE (try 2/3)
[ 1036.759927] wlan0: authenticated
[ 1036.761145] wlan0: associate with $INSERT_MAC_HERE (try 1/3)
[ 1036.765255] wlan0: RX AssocResp from $INSERT_MAC_HERE (capab=0x431 status=0 aid=1)
[ 1036.765262] wlan0: associated
[ 1046.776103] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
[ 1046.782985] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)
[ 1046.784663] cfg80211: Calling CRDA to update world regulatory domain
...
[ 1050.387653] wlan0: authenticate with $INSERT_MAC_HERE
[ 1050.389923] wlan0: send auth to $INSERT_MAC_HERE (try 1/3)
[ 1050.393341] wlan0: authenticated
[ 1050.393983] wlan0: associate with $INSERT_MAC_HERE (try 1/3)
[ 1050.397606] wlan0: RX AssocResp from $INSERT_MAC_HERE (capab=0x431 status=0 aid=1)
[ 1050.397611] wlan0: associated
[ 1060.405977] wlan0: disassociating from $INSERT_MAC_HERE by local choice (reason=3)
[ 1060.409604] cfg80211: Calling CRDA to update world regulatory domain
[ 1060.411326] wlan0: deauthenticating from $INSERT_MAC_HERE by local choice (reason=3)

(and so on...)

In comparison, v3.3.0 works fine:

[  165.584375] wlan0: authenticate with $INSERT_MAC_HERE (try 1)
[  165.587628] wlan0: authenticated
[  165.587762] wlan0: associate with $INSERT_MAC_HERE (try 1)
[  165.590796] wlan0: RX AssocResp from $INSERT_MAC_HERE (capab=0x431 status=0 aid=1)
[  165.590801] wlan0: associated
[  165.590804] wlan0: moving STA $INSERT_MAC_HERE to state 1
[  165.590807] wlan0: moving STA $INSERT_MAC_HERE to state 2
[  165.592782] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  165.614572] wlan0: moving STA $INSERT_MAC_HERE to state 3

Best,
	Dominik
